*** Settings ***
Library  RequestsLibrary
Library  String
Library  Collections

*** Keywords ***

Criar sessao na api

    ${headers}  Create Dictionary  
    ...  accept=application/json  
    ...  Content-Type=application/json  
    Create Session    serverest_api    https://reqres.in/api  headers=${headers}

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
