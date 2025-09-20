*** Settings ***
Library    Browser
Library    String

*** Keywords ***
conferencia de login
    [Arguments]    ${name}
    ${seletor}    Set Variable   css=header .right small 

    Wait For Elements State     ${seletor}        visible    5
    Get Text     ${seletor}    equal    Olá, ${name}

ir para tarefas

    Click    css=.button-add