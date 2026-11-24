*** Settings ***
Resource    resources/quickpizza.resource
Test Teardown    Close All Browsers

*** Test Cases ***
# Verify that a restricted pizza appears with the same tool in the admin list.
QP-01 A Custom Pizza Reaches The Admin List
    # Step 1: Open the home page and verify its heading.
    Open QuickPizza
    # Step 2: Open Advanced and check that all four controls appear.
    Show Advanced Fields
    # Step 3: Enter and check the restrictions and unique name.
    ${stamp}=    Get Current Date    result_format=%Y%m%d-%H%M%S
    ${name}=    Set Variable    Lab Pizza ${stamp}
    Enter Restrictions    ${name}    600    Knife
    Capture Page Screenshot    qp01-step3-fields.png
    # Step 4: Check the name, tool and calorie limit.
    ${tool}=    Check Recommendation    ${name}    600    Knife
    Capture Element Screenshot    ${RESULT}    qp01-step4-pizza.png
    # Step 5: Check that guest ratings require login.
    Check Login Required
    Capture Page Screenshot    qp01-step5-login-needed.png
    # Step 6: Sign in to the admin page.
    Log In As Admin
    # Step 7: Verify the exact pizza and its tool in the list.
    Check Admin Recommendation    ${name}    ${tool}
    Capture Page Screenshot    qp01-step7-admin-list.png
