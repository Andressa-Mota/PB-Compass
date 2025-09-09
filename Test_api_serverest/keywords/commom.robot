*** Settings ***
Documentation       
Library    OperatingSystem
Library    Collections
Library    RequestsLibrary
Library    JSONLibrary

*** Keywords ***

validar status code 
    [Arguments]     ${resposta}    ${status_code}  
    Should Be True    ${resposta.status_code} == ${status_code}

importar json estatico
    [Arguments]    ${nome_arquivo}
    ${arquivo}    Get File    ${EXECDIR}/static/${nome_arquivo}
    ${dados}      Evaluate    json.loads('''${arquivo}''')    modules=json
    RETURN         ${dados}

login na api
    [Arguments]    ${tipo_usuario}    ${status_esperado}
    ${json}       importar json estatico    json_login.json
    ${body}       Set Variable    ${json["${tipo_usuario}"]}
    ${resposta}   POST On Session    serverest_api    /login    json=${body}    expected_status=${status_esperado}
    ${resposta_json}=    To JSON    ${resposta.content}
    RETURN         ${resposta_json}
*** Keywords ***

Conferência de cadastro
    [Arguments]    ${resp_api}
    Log    ${resp_api}
    Dictionary Should Contain Key    ${resp_api}    _id
    Run Keyword If    'nome' in ${resp_api}    Dictionary Should Contain Key    ${resp_api}    nome

Conferência de erro
    [Arguments]    ${resp_api}    ${mensagem_esperada}
    Log    ${resp_api}
    Dictionary Should Contain Key    ${resp_api}    message
    Should Contain    ${resp_api["message"]}    ${mensagem_esperada}

Conferência de login
    [Arguments]    ${resp_api}
    Log    ${resp_api}
    Dictionary Should Contain Key    ${resp_api}    authorization

Conferência de lista
    [Arguments]    ${resp_api}
    Log    ${resp_api}
    Dictionary Should Contain Key    ${resp_api}    usuarios

Conferência de sucesso
    [Arguments]    ${resp_api}
    Log    ${resp_api}
    Should Be True    ${resp_api} != None
