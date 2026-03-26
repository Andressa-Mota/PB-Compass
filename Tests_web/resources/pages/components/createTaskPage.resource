*** Settings ***
Library    Browser
Library    String    

*** Keywords ***

submeter o formulario de tarefas
    [Arguments]    ${tarefa}

    Fill text    css=input[name=name]    ${tarefa}[name]

    ${seletor}    Set Variable    css=input[name=tags]    

    FOR    ${tag}    IN     @{tarefa}[tags]
        Fill Text     ${seletor}    ${tag}
        Sleep    1
        #sleep para simular o tempo que o usurário levaria para preencher
        Press Keys    ${seletor}    Enter
        
    END
    Click    css=button >> text=Cadastrar

marcar tarefa como completa
    [Arguments]    ${task_name}
    ${seletor}    Set Variable  xpath=//strong[text()="${task_name}"]/..//button[@class="item-toggle"]
    Wait For Elements State    ${seletor}
    ...    visible    5
    Click    ${seletor}

exclusao de tarefa
     [Arguments]    ${task_name}
    ${seletor}    Set Variable  xpath=//strong[text()="${task_name}"]/..//button[@class="task-remove"]
    Wait For Elements State    ${seletor}
    ...    visible    5
    Click    ${seletor}

conferir exclusão da tarefa
    [Arguments]    ${task_name}
   
    Wait For Elements State    css=.task-todo >> text=${task_name}       detached    5
    