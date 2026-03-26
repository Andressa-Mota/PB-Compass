*** Settings ***
Documentation    Ações e elementos da pafina de listagem de tarefas
Library    Browser

*** Keywords ***

conferir tarefa cadastrada
    [Arguments]    ${nome_tarefa}
    Wait For Elements State    css=.task-todo >> text=${nome_tarefa}    visible    5
    
conferir tarefa completada
    [Arguments]    ${nome_tarefa}
    ${seletor}    Set Variable    css=.task-done >> text=${nome_tarefa}    
    Wait For Elements State    ${seletor}        visible    5
    Get Style    ${seletor}    text-decoration-line     equal    line-through

