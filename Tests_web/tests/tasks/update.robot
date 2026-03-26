*** Settings ***
Documentation    cenarios de teste para atualização de tarefas
Library    Browser
Resource    ../../resources/base.resource
Resource    ../../../test_api/keywords/commom.robot

#executa antes de cada teste
Test Setup    start session
#executa depois de cada teste
Test Teardown    Take Screenshot   

*** Test Cases ***

CT13:marcar tarefa como concluida

     ${data}    receber fixtures        tasks.json     done
      limpar user do banco de dados    ${data}[user][email]
     inserir usuario no banco de dados    ${data}[user]
    
    criar sessao   ${data}[user]
    cadastrar nova tarefa    ${data}[task]
    
    submeter formulario de login    ${data}[user]
    conferencia de login    ${data}[user][name] 

    marcar tarefa como completa    ${data}[task][name] 
    conferir tarefa completada    ${data}[task][name] 
    Sleep    2  