*** Settings ***
Library    libs/database.py
Library    Browser

*** Variables ***
${BASE_URL}    http://localhost:3000

*** Keywords ***

start session
    New Browser    browser=chromium    headless=false
    New Page    ${BASE_URL}