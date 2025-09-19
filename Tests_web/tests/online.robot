*** Settings ***
Library   Browser
Resource    ../resources/base.resource

*** Test Cases ***
CT01:Verificar se webapp esta online
    start session
    Get Title    equal    Mark85 by QAx