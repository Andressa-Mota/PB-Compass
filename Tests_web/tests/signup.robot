*** Settings ***
Documentation    casos te teste de do cadastro de usuarios
Library    Browser
Resource    ../resources/base.resource 
Resource    ../resources/libs/env.resource

#executa antes de cada teste
Test Setup    start session
#executa depois de cada teste
Test Teardown    Take Screenshot      

*** Variables ***
  

*** Test Cases ***

CT02:cadastrar um novo usuario
    [Tags]    cadastro simples
#definindo variaveis do teste

    ${user}    Create Dictionary    
    ...    name=tester    
    ...    email=test@mail.com    
    ...    password=senha123
   
#removendo usuario do banco (caso ele já exista)
    remover usuario do banco de dados    ${user}[email]

    ir para pagina de cadastro
    submeter o formulario de cadastro    ${user}
    conferencia do teste    Boas vindas ao Mark85, o seu gerenciador de tarefas.    
CT03:Nao cadastar email duplicado
    [Tags]    duplicidade
#definindovariaveis do teste
    ${user}    Create Dictionary    
    ...    name=tester    
    ...    email=test02@mail.com  
    ...    password=senha124

#deletando um apossivel massa de testes incorreta
    remover usuario do banco de dados     ${user}[email]
#adicionando o usuario com os dados definidos no banco de dados
    inserir usuario no banco de dados    ${user}  

    ir para pagina de cadastro
    submeter o formulario de cadastro    ${user}
    conferencia do teste   Oops! Já existe uma conta com o e-mail informado.    

CT04:campos obrigatorios
    [Tags]    obrigatorios
    ${user}    Create Dictionary    
    ...    name=${EMPTY}
    ...    email=${EMPTY}
    ...    password=${EMPTY}
    ir para pagina de cadastro
    submeter o formulario de cadastro    ${user}  
    mensagens de alerta    Informe seu nome completo
    mensagens de alerta    Informe seu e-email
    mensagens de alerta    Informe uma senha com pelo menos 6 digitos


CT05:não cadastrar email incorreto
   [Tags]    email_incorreto
    ${user}    Create Dictionary    
    ...    name=andressa
    ...    email=email.com
    ...    password=senha135
    ir para pagina de cadastro
    submeter o formulario de cadastro    ${user}  
    mensagens de alerta    Digite um e-mail válido

CT06:não cadastrar com senhas muito curtas
    @{password_list}    Create List  1    12    123    1234    12345
    #lista de strings
    FOR    ${senha_curta}    IN    @{password_list}
         ${user}    Create Dictionary    
    ...    name=andressa
    ...    email=test03@mail.com
    ...    password=${senha_curta}
    ir para pagina de cadastro
    submeter o formulario de cadastro    ${user}  
    mensagens de alerta    Informe uma senha com pelo menos 6 digitos

        
    END