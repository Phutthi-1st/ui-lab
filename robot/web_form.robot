*** Settings ***
Resource    resources/quickpizza.resource
Test Teardown    Close All Browsers

*** Test Cases ***
# Fill and submit the Selenium practice form.
Submit Web Form
    Open Lab Browser    https://www.selenium.dev/selenium/web/web-form.html
    Input Text    id:my-text-id    Robot
    Textfield Value Should Be    id:my-text-id    Robot
    Input Password    name:my-password    Secret123
    Input Text    name:my-textarea    My first form test
    Select From List By Label    name:my-select    Two
    List Selection Should Be    name:my-select    Two
    Select Checkbox    id:my-check-2
    Checkbox Should Be Selected    id:my-check-2
    Select Radio Button    my-radio    my-radio-2
    ${selected}=    Get WebElement    id:my-radio-2
    Should Be True    $selected.is_selected()
    Input Text    name:my-date    11/05/2026
    Textfield Value Should Be    name:my-date    11/05/2026
    Press Keys    name:my-date    ESC
    Click Button    css:button[type=submit]
    Wait Until Element Is Visible    id:message
    Title Should Be    Web form - target page
    Element Text Should Be    id:message    Received!
