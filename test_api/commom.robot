*** Settings ***
Documentation        Keywords e variáveiss para ações gerais
Library    OperatingSystem
Library    Collections
Library    RequestsLibrary
Library    JSONLibrary

*** Keywords ***

validar status code 
    [Arguments]     ${status_code}  
    Should Be True    ${resposta.status_code} == ${status_code}

importar json estatico
    [Arguments]    ${nome_arquivo}
    ${arquivo}    Get File    ${EXECDIR}/test_api/${nome_arquivo}
    ${dados}      Evaluate    json.loads('''${arquivo}''')    modules=json
    RETURN         ${dados}

login na api
    [Arguments]    ${tipo_usuario}    ${status_esperado}
    ${json}       importar json estatico    json_login.json
    ${body}       Set Variable    ${json["${tipo_usuario}"]}
    ${resposta}   POST On Session    reqres_api    /login    json=${body}    expected_status=${status_esperado}
    ${resposta_json}=    To JSON    ${resposta.content}
    RETURN         ${resposta_json}