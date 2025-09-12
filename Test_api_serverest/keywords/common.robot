*** Settings ***
Library           OperatingSystem
Library           Collections
Library           JSONLibrary
Library           RequestsLibrary

*** Keywords ***
importar json estatico
    [Arguments]    ${nome_arquivo}
    ${json}=       Load JSON From File    ${CURDIR}/../static/${nome_arquivo}    encoding=UTF-8
    [Return]       ${json}

Conferência de cadastro
    [Arguments]    ${response}
    Dictionary Should Contain Key    ${response}    _id
    Should Contain    ${response['message']}    Cadastro realizado com sucesso

Conferência de erro
    [Arguments]    ${response}    ${mensagem_esperada}
    Dictionary Should Contain Key    ${response}    message
    Should Contain    ${response['message']}    ${mensagem_esperada}

Conferência de login
    [Arguments]    ${response}
    Dictionary Should Contain Key    ${response}    authorization
    Should Contain    ${response['message']}    Login realizado com sucesso

Conferência de lista de usuários
    [Arguments]    ${response}
    Dictionary Should Contain Key    ${response}    usuarios
    ${quantidade}=    Get Length    ${response['usuarios']}
    Should Be True    ${quantidade} > 0

Conferência de sucesso
    [Arguments]    ${response}    ${mensagem_esperada}
    Dictionary Should Contain Key    ${response}    message
    Should Be Equal As Strings    ${response['message']}    ${mensagem_esperada}