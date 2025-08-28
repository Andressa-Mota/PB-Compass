*** Settings ***

Resource  testing_api.resource


*** Test Cases ***


Cenario 01: Cadastrar novo usuário com sucesso
    [Tags]    POST
    Cadastrar novo usuário    status_esperado=200
    Conferência de cadastro

 Cenario 02: Cadastrar usuário sem senha
     [Tags]    POST
     cadastrar sem senha    400  

 Cenario 03: Consultar dados de um novo usuario
     [Tags]    GET
     Cadastrar novo usuário    status_esperado=200
     Consultar dados do usuario
     Conferir dados retornados

Cenario 04: Atualizar usuario existente
    [Tags]    PUT
    Cadastrar novo usuário    status_esperado=200
    Atualizar usuario    ${id_user}    200
    Conferir usuario atualizado

Cenario 05: Deletar usuário
    [Tags]    DELETE
    Cadastrar novo usuário    status_esperado=200
    Deletar usuario

Cenario 06: Consultar recurso por ID
    [Tags]    GET
    Consultar recurso por id    2    200
    Conferir recurso retornado    2

Cenario 07: Login com sucesso
    [Tags]    POST
    Login com usuario     eve.holt@reqres.in    cityslicka    200
    Fazer login