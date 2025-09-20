*** Settings ***
Library    Browser

*** Keywords ***
mensagens de alerta
    [Arguments]    ${txt_esperado}
    Wait For Elements State    css=.alert-error >> text=${txt_esperado}    visible    5
    Wait For Elements State    css=.alert-error >> text=${txt_esperado}    visible    5
    Wait For Elements State    css=.alert-error >> text=${txt_esperado}    visible    5