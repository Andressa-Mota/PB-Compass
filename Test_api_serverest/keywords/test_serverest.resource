*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Library    DateTime
Library    String
Library    commom.robot

*** Keywords ***

Criar sessão na ServeRest
    ${headers}  Create Dictionary  
    ...  accept=application/json  
    ...  Content-Type=application/json
    Create Session    serverest    https://serverest.dev    headers=${headers}


Cadastrar usuario valido
    [Arguments]    ${status_esperado}=201
    ${json}       importar json estatico    json_usuarios.json
    ${body}       Set Variable    ${json["usuario_valido"]}
    ${email_rand}    Generate Random String    6    [LOWER]
    Set To Dictionary    ${body}    email    ${email_rand}@teste.com
    Criar sessão na ServeRest
    ${resposta}   POST On Session    serverest    /usuarios    json=${body}    expected_status=${status_esperado}
    Log    ${resposta.json()}
    Set Test Variable    ${resp_api}    ${resposta.json()}
    Set Test Variable    ${id_user}     ${resposta.json()["_id"]}


Cadastrar usuario duplicado
    [Arguments]    ${status_esperado}=400
    ${json}       importar json estatico    json_usuarios.json
    ${body}       Set Variable    ${json["usuario_duplicado"]}
    Criar sessão na ServeRest
    POST On Session    serverest    /usuarios    json=${body}    expected_status=201
    ${resposta}   POST On Session    serverest    /usuarios    json=${body}    expected_status=${status_esperado}
    Log    ${resposta.json()}
    Set Test Variable    ${resp_api}    ${resposta.json()}


Cadastrar usuario provedor bloqueado
    [Arguments]    ${provedor}    ${status_esperado}=400
    ${json}       importar json estatico    json_usuarios.json
    ${body}       Set Variable    ${json["usuario_valido"]}  # Inicialização
    Run Keyword If    '${provedor}'=='gmail'    Set Variable    ${body}    ${json["usuario_gmail"]}
    ...    ELSE IF    '${provedor}'=='hotmail'    Set Variable    ${body}    ${json["usuario_hotmail"]}
    Criar sessão na ServeRest
    ${resposta}   POST On Session    serverest    /usuarios    json=${body}    expected_status=${status_esperado}
    Log    ${resposta.json()}
    Set Test Variable    ${resp_api}    ${resposta.json()}


Atualizar usuario inexistente
    [Arguments]    ${status_esperado}=201
    ${json}       importar json estatico    json_usuarios.json
    ${body}       Set Variable    ${json["usuario_valido"]}
    Criar sessão na ServeRest
    ${resposta}   PUT On Session    serverest    /usuarios/123456789    json=${body}    expected_status=${status_esperado}
    Log    ${resposta.json()}


Deletar usuario inexistente
    [Arguments]    ${status_esperado}=404
    Criar sessão na ServeRest
    ${resposta}   DELETE On Session    serverest    /usuarios/naoExiste    expected_status=${status_esperado}
    Log    ${resposta.json()}


Listar usuarios
    [Arguments]    ${status_esperado}=200
    Criar sessão na ServeRest
    ${resposta}   GET On Session    serverest    /usuarios    expected_status=${status_esperado}
    Log    ${resposta.json()}


Login usuario valido
    [Arguments]    ${status_esperado}=200
    ${json}       importar json estatico    json_login.json
    ${body}       Set Variable    ${json["user_valido"]}
    Criar sessão na ServeRest
    ${resposta}   POST On Session    serverest    /login    json=${body}    expected_status=${status_esperado}
    Log    ${resposta.json()}
    Set Test Variable    ${token}    ${resposta.json()["authorization"]}


Login usuario inexistente
    [Arguments]    ${status_esperado}=401
    ${json}       importar json estatico    json_login.json
    ${body}       Set Variable    ${json["user_invalido"]}
    Criar sessão na ServeRest
    ${resposta}   POST On Session    serverest    /login    json=${body}    expected_status=${status_esperado}
    Log    ${resposta.json()}


Login senha incorreta
    [Arguments]    ${status_esperado}=401
    ${json}       importar json estatico    json_login.json
    ${body}       Set Variable    ${json["user_senha_errada"]}
    Criar sessão na ServeRest
    ${resposta}   POST On Session    serverest    /login    json=${body}    expected_status=${status_esperado}
    Log    ${resposta.json()}


Login sem senha
    [Arguments]    ${status_esperado}=400
    ${json}       importar json estatico    json_login.json
    ${body}       Set Variable    ${json["user_sem_senha"]}
    Criar sessão na ServeRest
    ${resposta}   POST On Session    serverest    /login    json=${body}    expected_status=${status_esperado}
    Log    ${resposta.json()}


Cadastrar produto valido
    [Arguments]    ${status_esperado}=201
    Login usuario valido
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json    authorization=${token}
    Create Session    serverest    https://serverest.dev    headers=${headers}
    ${random}     Generate Random String    6    [LOWER]
    ${body}    Create Dictionary    nome=Produto ${random}    preco=100    descricao=Item Teste    quantidade=5
    ${resposta}   POST On Session    serverest    /produtos    json=${body}    expected_status=${status_esperado}
    Log    ${resposta.json()}
    Set Test Variable    ${id_produto}    ${resposta.json()["_id"]}


Cadastrar produto duplicado
    [Arguments]    ${status_esperado}=400
    Login usuario valido
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json    authorization=${token}
    Create Session    serverest    https://serverest.dev    headers=${headers}
    ${body}    Create Dictionary    nome=Produto Duplicado    preco=100    descricao=Item Teste    quantidade=5
    POST On Session    serverest    /produtos    json=${body}    expected_status=201
    ${resposta}   POST On Session    serverest    /produtos    json=${body}    expected_status=${status_esperado}
    Log    ${resposta.json()}


Cadastrar produto sem autenticação
    [Arguments]    ${status_esperado}=401
    Criar sessão na ServeRest
    ${body}    Create Dictionary    nome=Produto Sem Token    preco=200    descricao=Teste    quantidade=3
    ${resposta}   POST On Session    serverest    /produtos    json=${body}    expected_status=${status_esperado}
    Log    ${resposta.json()}


Atualizar produto inexistente
    [Arguments]    ${status_esperado}=201
    Login usuario valido
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json    authorization=${token}
    Create Session    serverest    https://serverest.dev    headers=${headers}
    ${body}    Create Dictionary    nome=Produto Novo    preco=150    descricao=Update Teste    quantidade=10
    ${resposta}   PUT On Session    serverest    /produtos/naoExiste    json=${body}    expected_status=${status_esperado}
    Log    ${resposta.json()}


Excluir produto em carrinho
    [Arguments]    ${status_esperado}=400
    Login usuario valido
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json    authorization=${token}
    Create Session    serverest    https://serverest.dev    headers=${headers}
    ${body}    Create Dictionary    nome=Produto Carrinho    preco=50    descricao=Item    quantidade=1
    ${resposta}   POST On Session    serverest    /produtos    json=${body}    expected_status=201
    ${id_produto}    Set Variable    ${resposta.json()["_id"]}
    # Forçando o vínculo com carrinho (simulado)
    ${resposta_del}    DELETE On Session    serverest    /produtos/${id_produto}    expected_status=${status_esperado}
    Log    ${resposta_del.json()}


Listar produtos
    [Arguments]    ${status_esperado}=200
    Criar sessão na ServeRest
    ${resposta}   GET On Session    serverest    /produtos    expected_status=${status_esperado}
    Log    ${resposta.json()}


Criar carrinho
    [Arguments]    ${status_esperado}=201
    Login usuario valido
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json    authorization=${token}
    Create Session    serverest    https://serverest.dev    headers=${headers}
    ${body}    Create Dictionary    produtos=[{"idProduto":"${id_produto}","quantidade":1}]
    ${resposta}   POST On Session    serverest    /carrinhos    json=${body}    expected_status=${status_esperado}
    Log    ${resposta.json()}
    Set Test Variable    ${id_carrinho}    ${resposta.json()["_id"]}


Cancelar carrinho
    [Arguments]    ${status_esperado}=200
    Login usuario valido
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json    authorization=${token}
    Create Session    serverest    https://serverest.dev    headers=${headers}
    ${resposta}   DELETE On Session    serverest    /carrinhos/cancelar-compra    expected_status=${status_esperado}
    Log    ${resposta.json()}


Concluir carrinho
    [Arguments]    ${status_esperado}=200
    Login usuario valido
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json    authorization=${token}
    Create Session    serverest    https://serverest.dev    headers=${headers}
    ${resposta}   DELETE On Session    serverest    /carrinhos/concluir-compra    expected_status=${status_esperado}
    Log    ${resposta.json()}
