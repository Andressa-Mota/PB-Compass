*** Settings ***
Documentation    casos te teste de do cadastro de usuarios
Library    Browser
Resource    ../resources/base.robot  

#executa antes de cada teste
Test Setup    start session
#executa depois de cada teste
Test Teardown    Take Screenshot      

*** Variables ***
  

*** Test Cases ***

CT01:cadastrar um novo usuario
    [Tags]    cadastro simples
#definindo variaveis do teste

    ${user}    Create Dictionary    
    ...    name=tester    
    ...    email=test@mail.com    
    ...    password=senha123
   
#removendo usuario do banco (caso ele já exista)
    remover usuario do banco de dados    ${user}[email]

#iniciandoa sessão
    
    Go To    ${BASE_URL}/signup

#checkpoint
     Wait For Elements State    xpath=//h1    visible    5
                                 #//h1[text()="Faça seu cadastro"] é um modo de encontrar mais preciso a partir do texto
     Get Text    xpath=//h1    equal    Faça seu cadastro    

#prennchendo campos
     Fill Text    id=name        ${user}[name]
     Fill Text    id=email       ${user}[email]
     Fill Text    id=password    ${user}[password]

#cliando no botão
     Click    id=buttonSignup

#verificação
     Wait For Elements State    css=.notice p    visible    5                         
     Get Text    css=.notice p    equal    Boas vindas ao Mark85, o seu gerenciador de tarefas.    
     #sSleep   2    
     #              

CT02:Nao cadastar email duplicado
    [Tags]    duplicidade
#definindovariaveis do teste
    ${user}    Create Dictionary    
    ...    name=tester    
    ...    email=test02@mail.com  
    ...    password=senha124
#iniciandoa sessão

    Go To    ${BASE_URL}/signup

#checkpoint
     Wait For Elements State    xpath=//h1    visible    5
     Get Text    xpath=//h1    equal    Faça seu cadastro

#deletando um apossivel massa de testes incorreta
    remover usuario do banco de dados     ${user}[email]
#adicionando o usuario com os dados definidos no banco de dados
    inserir usuario no banco de dados    ${user}  
#prennchendo campos
     Fill Text    id=name        ${user}[name]
     Fill Text    id=email       ${user}[email]
     Fill Text    id=password    ${user}[password]

#cliando no botão
     Click    id=buttonSignup
#verificação
     Wait For Elements State    css=.notice p    visible    5                         
     Get Text    css=.notice p    equal    Oops! Já existe uma conta com o e-mail informado.   
     #Sleep   2
