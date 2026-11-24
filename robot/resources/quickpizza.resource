*** Settings ***
Library    SeleniumLibrary    timeout=15s
Library    DateTime
Library    String
Library    OperatingSystem

*** Variables ***
${URL}             https://quickpizza.grafana.com
${BROWSER}         headlesschrome
${MAX CALORIES}    xpath://label[normalize-space()='Max Calories per Slice']/preceding-sibling::input
${EXCLUDED TOOLS}  css:select
${VEGETARIAN}      id:default-checkbox
${PIZZA NAME}      css:input#pizza-name
${PIZZA BUTTON}    name:pizza-please
${RESULT}          id:recommendations

*** Keywords ***
Open Lab Browser
    [Arguments]    ${url}
    ${driver}=    Get Environment Variable    CHROMEDRIVER    ${EMPTY}
    IF    $driver
        ${service}=    Evaluate    selenium.webdriver.chrome.service.Service($driver)    modules=selenium.webdriver
        Open Browser    ${url}    ${BROWSER}    service=${service}
    ELSE
        Open Browser    ${url}    ${BROWSER}
    END
    Set Window Size    1280    1600

Open QuickPizza
    Open Lab Browser    ${URL}
    Wait Until Element Is Visible    css:h1
    Element Text Should Be    css:h1    Looking to break out of your pizza routine?
    Wait Until Page Contains Element    id:svelte-announcer

Show Advanced Fields
    Click Element    xpath://label[.//span[normalize-space()='Advanced']]
    Wait Until Page Contains Element    xpath://option[normalize-space()='Knife']
    Element Should Be Visible    ${MAX CALORIES}
    Element Should Be Visible    ${EXCLUDED TOOLS}
    Element Should Be Visible    ${VEGETARIAN}
    Element Should Be Visible    ${PIZZA NAME}

Enter Restrictions
    [Arguments]    ${name}    ${limit}    ${excluded}
    Input Text    ${MAX CALORIES}    ${limit}
    Select From List By Label    ${EXCLUDED TOOLS}    ${excluded}
    Select Checkbox    ${VEGETARIAN}
    Input Text    ${PIZZA NAME}    ${name}
    Textfield Value Should Be    ${MAX CALORIES}    ${limit}
    List Selection Should Be    ${EXCLUDED TOOLS}    ${excluded}
    Checkbox Should Be Selected    ${VEGETARIAN}
    Textfield Value Should Be    ${PIZZA NAME}    ${name}

Check Recommendation
    [Arguments]    ${name}    ${limit}    ${excluded}
    Click Button    ${PIZZA BUTTON}
    Wait Until Element Contains    ${RESULT}    Name: ${name}
    ${tool line}=    Get Text    xpath://*[@id='recommendations']//p[starts-with(normalize-space(),'Tool:')]
    ${calorie line}=    Get Text    xpath://*[@id='recommendations']//p[starts-with(normalize-space(),'Calories per slice:')]
    ${tool}=    Remove String    ${tool line}    Tool:${SPACE}
    ${calories}=    Remove String    ${calorie line}    Calories per slice:${SPACE}
    Should Not Be Equal    ${tool}    ${excluded}
    Should Be True    float($calories) <= int($limit)
    Log To Console    ${name} | ${tool} | ${calories} calories per slice
    RETURN    ${tool}

Check Login Required
    Click Button    name:rate-5
    Wait Until Element Contains    id:rate-result    Please log in first.

Log In As Admin
    Go To    ${URL}/admin
    Wait Until Page Contains Element    id:svelte-announcer
    Input Text    id:username    admin
    Input Password    id:password    admin
    Click Button    css:button[type=submit]
    Wait Until Page Contains    Latest pizza recommendations

Check Admin Recommendation
    [Arguments]    ${name}    ${tool}
    ${row}=    Set Variable    xpath://li[contains(.,'${name}')]
    Wait Until Element Contains    ${row}    (tool=${tool},
