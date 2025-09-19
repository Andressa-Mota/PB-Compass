*** Settings ***
Library    libs/database.py
Library    Browser
Resource    libs/env.resource
Resource    pages/signupPage.resource
Resource    pages/loginPage.resource

*** Variables ***

*** Keywords ***

start session
    New Browser    browser=chromium    headless=false
    New Page    ${BASE_URL}

senhas curtas
    [Arguments]    ${senha_curta}
        ${user}    Create Dictionary    
    ...    name=andressa
    ...    email=test03@mail.com
    ...    password=${senha_curta}
    ir para pagina de cadastro
    submeter o formulario de cadastro    ${user}  
    mensagens de alerta    Informe uma senha com pelo menos 6 digitos
