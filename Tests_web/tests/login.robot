*** Settings ***
Documentation    cenarios de atenticação

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
    submeter formulario de login    ${user}
    conferencia de login    ${user}[name]
    Sleep    1