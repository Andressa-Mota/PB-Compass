*** Settings ***
Documentation    cenarios de teste de remoção de tarefas
Library    Browser
Resource    ../../resources/base.resource
Resource    ../../../test_api/keywords/commom.robot

#executa antes de cada teste
Test Setup    start session
#executa depois de cada teste
Test Teardown    Take Screenshot   

*** Test Cases ***

CT14:apagar tarefa 

     ${data}    receber fixtures        tasks.json     delete
      limpar user do banco de dados    ${data}[user][email]
     inserir usuario no banco de dados    ${data}[user]
    
    criar sessao   ${data}[user]
    cadastrar nova tarefa    ${data}[task]
    
    submeter formulario de login    ${data}[user]
    conferencia de login    ${data}[user][name]

    exclusao de tarefa    ${data}[task][name] 
    conferir exclusão da tarefa    ${data}[task][name]

  
 