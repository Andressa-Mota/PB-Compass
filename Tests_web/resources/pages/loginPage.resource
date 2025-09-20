*** Settings ***

Library    Browser

*** Keywords ***

submeter formulario de login
    [Arguments]    ${user}
    Fill Text    css=input[placeholder$=mail]    ${user}[email] 
                #buscando placeholder que termine com a palavra "mail"  
    Fill Text    css=input[placeholder=Senha]    ${user}[password] 

    Click    css=button >> text=Entrar
            #Escolehndo botão pela classe e texto combinados


