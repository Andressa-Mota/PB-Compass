*** Settings ***
Library  RequestsLibrary
Library  String
Library    Collections

*** Keywords ***

Criar sessao na api

    ${headers}  Create Dictionary  
    ...  accept=application/json  
    ...  Content-Type=application/json  
    ...    x-api-key=reqres-free-v1
    Create Session    reqres_api    https://reqres.in/api  headers=${headers}

Cadastrar novo usuário

       [Arguments]  ${status_esperado}
    ${body}    Create Dictionary  
        Set To Dictionary    ${body}  email  eve.holt@reqres.in
        Set To Dictionary    ${body}  password  senha  
    Criar sessao na api 
    ${resposta}  POST On Session  
    ...  alias=reqres_api   
    ...    url=/register   
    ...    json=${body}
    ...    expected_status=${status_esperado}
    Log    ${resposta.json()}
    Set Test Variable    ${id_user}  ${resposta.json()["id"]}
    Set Test Variable    ${resp_api}  ${resposta.json()}
Conferência de cadastro
     Log    ${resp_api}
     Dictionary Should Contain Key    ${resp_api}    id
     Dictionary Should Contain Key    ${resp_api}    token
cadastrar sem senha

    [Arguments]    ${status_esperado}
    ${body}=    Create Dictionary
    Set To Dictionary    ${body}    email    eve.holt@reqres.in
    Criar sessao na api
    ${resposta}=    POST On Session
    ...    alias=reqres_api
    ...    url=/register
    ...    json=${body}
    ...    expected_status=${status_esperado}
    Log    ${resposta.json()}
    Set Test Variable    ${resp_api}    ${resposta.json()}
    Dictionary Should Contain Key    ${resp_api}    error
Consultar dados do usuario


    ${resp_consulta}    GET On Session    alias=reqres_api  url=/users/${id_user} 
    Set Test Variable    ${conferir_consulta}    ${resp_consulta.json()}
Conferir dados retornados

    ${data}    Set Variable    ${conferir_consulta["data"]}
    Log    ${data}
    Dictionary Should Contain Item    ${data}    id    ${id_user}
    Dictionary Should Contain Item    ${data}    email    eve.holt@reqres.in
    Dictionary Should Contain Item    ${data}    first_name    Eve
    Dictionary Should Contain Item    ${data}    last_name    Holt

Atualizar usuario
    [Arguments]    ${id_user}    ${status_esperado}=200
    ${body}    Create Dictionary
    Set To Dictionary    ${body}    name    Andressa Mota
    Set To Dictionary    ${body}    job     QA Engineer
    Criar sessao na api
    ${resposta}    PUT On Session
    ...    alias=reqres_api
    ...    url=/users/${id_user}
    ...    json=${body}
    ...    expected_status=${status_esperado}
    Log    ${resposta.json()}
    Set Test Variable    ${resp_atualizacao}    ${resposta.json()}

Conferir usuario atualizado
    Log    ${resp_atualizacao}
    Dictionary Should Contain Item    ${resp_atualizacao}    name    Andressa Mota
    Dictionary Should Contain Item    ${resp_atualizacao}    job     QA Engineer
    Dictionary Should Contain Key     ${resp_atualizacao}    updatedAt

Deletar usuario
    [Arguments]    ${status_esperado}=204
    ${resposta}    DELETE On Session
    ...    alias=reqres_api
    ...    url=/users/${id_user}
    ...    expected_status=${status_esperado}
    Log    ${resposta.status_code}
Consultar recurso por id
    [Arguments]    ${id_recurso}    ${status_esperado}=200
    Criar sessao na api
    ${resposta}=    GET On Session
    ...    alias=reqres_api
    ...    url=/unknown/${id_recurso}
    ...    expected_status=${status_esperado}
    Log    ${resposta.json()}
    Set Test Variable    ${resp_recurso}    ${resposta.json()}

Conferir recurso retornado
    [Arguments]    ${id_esperado}
    Dictionary Should Contain Key    ${resp_recurso}    data
    ${data}=    Set Variable    ${resp_recurso["data"]}
    ${id_esperado_int}    Convert To Integer    ${id_esperado}
    Dictionary Should Contain Item   ${data}    id    ${id_esperado_int}
    Log    ${data["name"]}
    Log    ${data["color"]}

Login com usuario
    [Arguments]    ${email}    ${senha}    ${status_esperado}
    Criar sessao na api
    ${body}   Create Dictionary    email=${email}    password=${senha}
    ${resp_login}    POST On Session    reqres_api    /login    json=${body}    expected_status=${status_esperado}
    [Return]    ${resp_login.json()}

Fazer login
    ${resp_login2}   Login com usuario    eve.holt@reqres.in    cityslicka    200
    Dictionary Should Contain Key    ${resp_login2}    token
    Log    Token gerado: ${resp_login2["token"]}
