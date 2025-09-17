*** Settings ***
Library   Browser

*** Test Cases ***
Verificar se webapp esta online
    New Browser    browser=chromium    headless=false
    New Page    http://localhost:3000
    Get Title    equal    Mark85 by QAx