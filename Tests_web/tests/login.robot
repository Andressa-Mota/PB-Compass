*** Settings ***
Documentation    cenarios de atenticação
Library    Collections

Resource    ../resources/base.resource


#executa antes de cada teste
Test Setup    start session
#executa depois de cada teste
Test Teardown    Take Screenshot      


*** Test Cases ***

CT07:logar com usuario cadastrado

    ${user}    Create Dictionary     
    ...    name=tester      
    ...    email=test@mail.com    
    ...    password=senha123 
    
    remover usuario do banco de dados     ${user}[email]
    inserir usuario no banco de dados    ${user}

    submeter formulario de login    ${user}
    conferencia de login    ${user}[name]

CT08:não logar com senha invalida

    ${user}    Create Dictionary     
    ...    name=tester02      
    ...    email=test02@mail.com    
    ...    password=senha1234 
    
    remover usuario do banco de dados     ${user}[email]
    inserir usuario no banco de dados    ${user}

    Set To Dictionary    ${user}    password=senhaincorreta    

    submeter formulario de login    ${user}
    conferir erro de login    Ocorreu um erro ao fazer login, verifique suas credenciais.