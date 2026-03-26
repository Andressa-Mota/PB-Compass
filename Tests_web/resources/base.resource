*** Settings ***
Library    libs/database.py
Library    Browser
Library    JSONLibrary
Resource    libs/env.resource
Resource    pages/components/notice.resource
Resource    pages/components/header.resource
Resource    pages/components/alert.resource
Resource    pages/signupPage.resource
Resource    pages/loginPage.resource
Resource    pages/components/createTaskPage.resource
Resource    pages/components/tasksPage.resource
Resource    pages/services.resource



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

receber fixtures
     [Arguments]    ${arquivo}   ${cenario}
           ${data}     Load Json From File    ${EXECDIR}/Tests_web/resources/fixtures/${arquivo}     encoding=utf-8
           Log    ${data}
           RETURN    ${data}[${cenario}]