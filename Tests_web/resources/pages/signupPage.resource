*** Settings ***
Documentation    Elementos e ações da pagina singup

Library    Browser
Resource    ../libs/env.resource

*** Keywords ***

ir para pagina de cadastro

#iniciandoa sessão
    
    Go To    ${BASE_URL}/signup

#checkpoint
     Wait For Elements State    xpath=//h1    visible    5
                                 #//h1[text()="Faça seu cadastro"] é um modo de encontrar mais preciso a partir do texto
     Get Text    xpath=//h1    equal    Faça seu cadastro    

submeter o formulario de cadastro
    [Arguments]    ${user}


#prennchendo campos
     Fill Text    css=input[name=name]        ${user}[name]
     Fill Text    css=input[name=email]      ${user}[email]
     Fill Text    css=input[name=password]    ${user}[password]

#cliando no botão
     Click    css=button[type=submit] >> text=Cadastrar


conferencia do teste
    [Arguments]    ${txt_esperado}    
    ${element}    Set Variable    css=.notice p
#verificação
     Wait For Elements State    ${element}   visible    5                         
     Get Text    ${element}   equal    ${txt_esperado}    
     #sSleep   2    

