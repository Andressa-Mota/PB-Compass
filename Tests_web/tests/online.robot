*** Settings ***
Library   Browser
Resource    ../resources/base.robot

*** Test Cases ***
Verificar se webapp esta online
    start session
    Get Title    equal    Mark85 by QAx