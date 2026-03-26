*** Settings ***
Library    Browser

*** Keywords ***
conferir erro de login
    [Arguments]    ${txt_esperado}
     ${seletor}    Set Variable   css=.notice p
    Wait For Elements State     ${seletor}        visible    5
    Get Text     ${seletor}    equal   ${txt_esperado}