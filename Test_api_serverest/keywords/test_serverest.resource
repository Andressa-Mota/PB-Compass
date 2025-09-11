*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           JSONLibrary
Library           String
Resource          common.robot

*** Keywords ***
Setup da Suíte
    Criar Sessão Base
    # Garante que o usuário para login/autenticação sempre exista
    Cadastrar usuario para login

Criar Sessão Base
    ${headers}=    Create Dictionary    Content-Type=application/json
    Create Session    serverest    https://serverest.dev    headers=${headers}

Obter Token de Autenticação
    ${resp}=    Login com credenciais    user_valido    200
    ${token}=   Set Variable    ${resp.json()['authorization']}
    [Return]    ${token}

# --- Keywords de Usuários ---
Cadastrar usuario para login
    ${json}=      importar json estatico    json_login.json
    ${body}=      Get From Dictionary    ${json}    user_valido
    ${resp}=      POST On Session    serverest    /usuarios    json=${body}    expected_status=any
    Log    Usuário de login garantido. Status: ${resp.status_code}

Cadastrar usuario valido
    [Arguments]    ${status_esperado}
    ${json}=       importar json estatico    json_usuarios.json
    ${body}=       Get From Dictionary    ${json}    usuario_valido
    ${email_rand}=    Generate Random String    8    [LOWER]
    Set To Dictionary    ${body}    email    ${email_rand}@robot.com
    ${resposta}=     POST On Session    serverest    /usuarios    json=${body}    expected_status=${status_esperado}
    [Return]    ${resposta}

Cadastrar usuario duplicado
    [Arguments]    ${status_esperado}
    ${json}=      importar json estatico    json_usuarios.json
    ${body}=      Get From Dictionary    ${json}    usuario_duplicado
    POST On Session    serverest    /usuarios    json=${body}    expected_status=any
    ${resposta}=  POST On Session    serverest    /usuarios    json=${body}    expected_status=${status_esperado}
    [Return]    ${resposta}

Cadastrar usuario provedor bloqueado
    [Arguments]    ${provedor}    ${status_esperado}
    ${json}=      importar json estatico    json_usuarios.json
    ${body}=      Get From Dictionary    ${json}    usuario_${provedor}
    ${resposta}=  POST On Session    serverest    /usuarios    json=${body}    expected_status=${status_esperado}
    [Return]    ${resposta}

Atualizar usuario inexistente

    [Arguments]    ${status_esperado}
    ${json}=      importar json estatico    json_usuarios.json
    ${body}=      Get From Dictionary    ${json}    usuario_valido
    ${email_rand}=    Generate Random String    8    [LOWER]
    Set To Dictionary    ${body}    email    ${email_rand}@robot.com
    ${resposta}=  PUT On Session    serverest    /usuarios/64646    json=${body}    expected_status=${status_esperado}
    [Return]    ${resposta}

Deletar usuario inexistente
    [Arguments]    ${status_esperado}
    ${resposta}=  DELETE On Session    serverest    /usuarios/IDInexistente    expected_status=${status_esperado}
    [Return]    ${resposta}

Listar usuarios
    [Arguments]    ${status_esperado}
    ${resposta}=  GET On Session    serverest    /usuarios    expected_status=${status_esperado}
    [Return]    ${resposta}

# --- Keywords de Login ---
Login com credenciais
    [Arguments]    ${tipo_usuario}    ${status_esperado}
    ${json}=      importar json estatico    json_login.json
    ${body}=      Get From Dictionary    ${json}    ${tipo_usuario}
    ${resposta}=  POST On Session    serverest    /login    json=${body}    expected_status=${status_esperado}
    [Return]    ${resposta}

# --- Keywords de Produtos ---
Cadastrar produto valido
    [Arguments]    ${token}    ${status_esperado}
    ${headers}=      Create Dictionary    Authorization=${token}
    ${nome_prod}=    Generate Random String    10    Produto [LOWER]
    ${body}=         Create Dictionary    nome=${nome_prod}    preco=500    descricao=Mouse Gamer    quantidade=100
    ${resposta}=     POST On Session    serverest    /produtos    json=${body}    headers=${headers}    expected_status=${status_esperado}
    [Return]    ${resposta}

Cadastrar produto duplicado
    [Arguments]    ${token}    ${status_esperado}
    ${headers}=    Create Dictionary    Authorization=${token}
    ${body}=       Create Dictionary    nome=Produto Duplicado Teste    preco=100    descricao=Item Teste    quantidade=5
    POST On Session    serverest    /produtos    json=${body}    headers=${headers}    expected_status=any
    ${resposta}=   POST On Session    serverest    /produtos    json=${body}    headers=${headers}    expected_status=${status_esperado}
    [Return]    ${resposta}

Cadastrar produto sem autenticação
    [Arguments]    ${status_esperado}
    ${body}=      Create Dictionary    nome=Produto Sem Token    preco=200    descricao=Teste    quantidade=3
    ${resposta}=  POST On Session    serverest    /produtos    json=${body}    expected_status=${status_esperado}
    [Return]    ${resposta}

Atualizar produto inexistente
    [Arguments]    ${token}    ${status_esperado}
    ${headers}=    Create Dictionary    Authorization=${token}
    ${nome_prod}=    Generate Random String    10    Produto [LOWER]
    ${body}=         Create Dictionary    nome=${nome_prod}   preco=150    descricao=Update Teste    quantidade=10
    ${resposta}=   PUT On Session    serverest    /produtos/idinexistente000   json=${body}    headers=${headers}    expected_status=${status_esperado}
    [Return]    ${resposta}

Excluir produto em carrinho
    [Arguments]    ${token}    ${status_esperado}
    ${headers}=           Create Dictionary    Authorization=${token}
    ${resp_produto}=      Cadastrar produto valido    ${token}    201
    ${id_produto}=        Set Variable    ${resp_produto.json()['_id']}
    Criar carrinho    ${token}    ${id_produto}    201
    ${resposta_delete}=   DELETE On Session    serverest    /produtos/${id_produto}    headers=${headers}    expected_status=${status_esperado}
    [Return]    ${resposta_delete}

Limpar carrinho existente
    [Arguments]    ${token}
    ${headers}=      Create Dictionary    Authorization=${token}
    ${response}=     DELETE On Session    serverest    /carrinhos/concluir-compra    headers=${headers}    expected_status=any
    Log    Tentativa de limpeza de carrinho finalizada com status: ${response.status_code}

Criar carrinho
    [Arguments]    ${token}    ${id_produto}    ${status_esperado}
    ${headers}=    Create Dictionary    Authorization=${token}
    &{produto_dicionario}=    Create Dictionary    idProduto=${id_produto}    quantidade=2
    @{produtos_lista}=    Create List    ${produto_dicionario}
    ${body}=       Create Dictionary    produtos=${produtos_lista}
    ${resposta}=   POST On Session    serverest    /carrinhos    json=${body}    headers=${headers}    expected_status=${status_esperado}
    [Return]    ${resposta}

Cancelar carrinho
    [Arguments]    ${token}    ${status_esperado}
    ${headers}=    Create Dictionary    Authorization=${token}
    ${resposta}=   DELETE On Session    serverest    /carrinhos/cancelar-compra    headers=${headers}    expected_status=${status_esperado}
    [Return]    ${resposta}

Concluir carrinho
    [Arguments]    ${token}    ${status_esperado}
    ${headers}=    Create Dictionary    Authorization=${token}
    ${resposta}=   DELETE On Session    serverest    /carrinhos/concluir-compra    headers=${headers}    expected_status=${status_esperado}
    [Return]    ${resposta}