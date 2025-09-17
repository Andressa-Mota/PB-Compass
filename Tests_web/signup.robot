*** Settings ***
Documentation    casos te teste de do cadastro de usuarios
Library    Browser

*** Test Cases ***

cadastrar um novo usuario
     New Browser    browser=chromium    headless=false
     New Page    http://localhost:3000/signup
     #checkpoint
     Wait For Elements State    xpath=//h1    visible    5
                                 #//h1[text()="Faça seu cadastro"] é um modo de encontrar mais preciso a partir do texto
     Get Text    xpath=//h1    equal    Faça seu cadastro                            