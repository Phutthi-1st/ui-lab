*** Settings ***
Resource    resources/quickpizza.resource
Test Teardown    Close All Browsers

*** Test Cases ***
# Confirm that Chrome opens the Selenium practice form.
Open Web Form
    Open Lab Browser    https://www.selenium.dev/selenium/web/web-form.html
    Title Should Be    Web form
