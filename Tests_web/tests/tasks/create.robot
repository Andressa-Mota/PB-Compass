*** Settings ***
Documentation    cenários de cadstro de tarefas
Resource    ../../resources/base.resource
Library    JSONLibrary    

#executa antes de cada teste
Test Setup    start session
#executa depois de cada teste
Test Teardown    Take Screenshot      
*** Test Cases ***

CT10:cadastar uma nova tarefa
       ${data}    receber fixtures        tasks.json     create

       limpar user do banco de dados    ${data}[user][email]
       inserir usuario no banco de dados    ${data}[user]

        submeter formulario de login    ${data}[user]
        conferencia de login    ${data}[user][name]
       ir para tarefas
       submeter o formulario de tarefas     ${data}[task] 
       conferir tarefa cadastrada   ${data}[task][name]

CT11:não cadastrar tarefa duplicada
    [Tags]    dup
    
    ${data}    receber fixtures        tasks.json     duplicate
    
    #criando novo usuario
     limpar user do banco de dados    ${data}[user][email]
     inserir usuario no banco de dados    ${data}[user]
    #cadastrando uma nova tarefa via API
     criar sessao    ${data}[user]
     cadastrar nova tarefa    ${data}[task]
    
    #logando na aplicação
      submeter formulario de login    ${data}[user]
      conferencia de login    ${data}[user][name]
    #cadastrando novamente tarefa já cadastrada
      ir para tarefas
     submeter o formulario de tarefas     ${data}[task]
    
    #erro de duplicidade
     conferir erro de login    Oops! Tarefa duplicada.
    
         
CT12:não cadastrar tarefa ao atingir limite de tags
     [Tags]    limite_tags
    
    ${data}    receber fixtures        tasks.json     tags_limit
    
    #criando novo usuario
     limpar user do banco de dados    ${data}[user][email]
     inserir usuario no banco de dados    ${data}[user]
  
    #logando na aplicação
      submeter formulario de login    ${data}[user]
      conferencia de login    ${data}[user][name]
    #cadastrando novamente tarefa já cadastrada
      ir para tarefas
     submeter o formulario de tarefas     ${data}[task]
    
    #erro de duplicidade
     conferir erro de login    Oops! Limite de tags atingido.
    
        