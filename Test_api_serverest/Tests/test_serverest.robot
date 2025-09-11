*** Settings ***
Resource          ../keywords/test_serverest.resource
Resource          ../keywords/common.robot

Suite Setup       Setup da Suíte

*** Test Cases ***
CT001: Cadastrar novo usuário com sucesso
    [Tags]    POST    USUARIOS
    ${resp}=    Cadastrar usuario valido    201
    Conferência de cadastro    ${resp.json()}

CT002: Cadastrar usuário com e-mail duplicado
    [Tags]    POST    USUARIOS
    ${resp}=    Cadastrar usuario duplicado    400
    Conferência de erro    ${resp.json()}    Este email já está sendo usado

CT003: Cadastrar usuário com provedor bloqueado (gmail)
    [Tags]    POST    USUARIOS
    ${resp}=    Cadastrar usuario provedor bloqueado    gmail    400
    Conferência de erro    ${resp.json()}    não permitido

CT004: Cadastrar usuário com provedor bloqueado (hotmail)
    [Tags]    POST    USUARIOS
    ${resp}=    Cadastrar usuario provedor bloqueado    hotmail    400
    Conferência de erro    ${resp.json()}    não permitido

CT005: Atualizar usuário inexistente
    [Tags]    PUT    USUARIOS
    ${resp}=    Atualizar usuario inexistente    201
    Conferência de erro    ${resp.json()}    Cadastro realizado com sucesso

CT006: Deletar usuário inexistente
    [Tags]    DELETE    USUARIOS
    ${resp}=    Deletar usuario inexistente    200
    Conferência de sucesso    ${resp.json()}    Nenhum registro excluído

CT007: Listar usuários
    [Tags]    GET    USUARIOS
    ${resp}=    Listar usuarios    200
    Conferência de lista de usuários    ${resp.json()}

CT008: Login com usuário válido
    [Tags]    POST    LOGIN
    ${resp}=    Login com credenciais    user_valido    200
    Conferência de login    ${resp.json()}

CT009: Login com usuário inexistente
    [Tags]    POST    LOGIN
    ${resp}=    Login com credenciais    user_invalido    401
    Conferência de erro    ${resp.json()}    Email e/ou senha inválidos

CT010: Login com senha incorreta
    [Tags]    POST    LOGIN
    ${resp}=    Login com credenciais    user_senha_errada    401
    Conferência de erro    ${resp.json()}    Email e/ou senha inválidos

CT011: Cadastrar novo produto com sucesso
    [Tags]    POST    PRODUTOS
    ${token}=    Obter Token de Autenticação
    ${resp}=     Cadastrar produto valido    ${token}    201
    Conferência de cadastro    ${resp.json()}

CT012: Cadastrar produto com token expirado
    [Tags]    POST    PRODUTOS
    ${resp}=     Cadastrar produto valido    Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImZ1bGFub0BxYS5jb20iLCJwYXNzd29yZCI6InRlc3RlIiwiaWF0IjoxNzU3NjE2NzEyLCJleHAiOjE3NTc2MTczMTJ9.aJqcIsNcva0fyPeJrFHYo0VX81h6A_IM7ECCa_-y-2o    401
     Conferência de erro    ${resp.json()}    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

CT012: Cadastrar produto duplicado
    [Tags]    POST    PRODUTOS
    ${token}=    Obter Token de Autenticação
    ${resp}=     Cadastrar produto duplicado    ${token}    400
    Conferência de erro    ${resp.json()}    Já existe produto com esse nome

CT013: Cadastrar produto sem autenticação
    [Tags]    POST    PRODUTOS
    ${resp}=    Cadastrar produto sem autenticação    401
    Conferência de erro    ${resp.json()}    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

CT014: Atualizar produto inexistente
    [Tags]    PUT    PRODUTOS
    ${token}=    Obter Token de Autenticação
    ${resp}=     Atualizar produto inexistente    ${token}    201
    Conferência de sucesso    ${resp.json()}    Cadastro realizado com sucesso
   

CT015: Excluir produto vinculado a carrinho
    [Tags]    DELETE    PRODUTOS
    ${token}=    Obter Token de Autenticação
    Limpar carrinho existente    ${token}
    ${resp}=     Excluir produto em carrinho    ${token}    400
    Conferência de erro    ${resp.json()}    Não é permitido excluir produto que faz parte de carrinho

CT016: Listar produtos
    [Tags]    GET    PRODUTOS
    ${resposta}=    Listar produtos    200
    Dictionary Should Contain Key    ${resposta.json()}    produtos
CT016: Criar carrinho com sucesso
    [Tags]    POST    CARRINHOS
    ${token}=    Obter Token de Autenticação
    Limpar carrinho existente    ${token}
    ${resp_produto}=    Cadastrar produto valido    ${token}    201
    ${id_produto}=      Set Variable    ${resp_produto.json()['_id']}
    ${resp_carrinho}=   Criar carrinho    ${token}    ${id_produto}    201
    Conferência de cadastro    ${resp_carrinho.json()}

CT017: Concluir compra de um carrinho
    [Tags]    DELETE    CARRINHOS
    ${token}=    Obter Token de Autenticação
    Limpar carrinho existente    ${token}
    ${resp_produto}=    Cadastrar produto valido    ${token}    201
    ${id_produto}=      Set Variable    ${resp_produto.json()['_id']}
    Criar carrinho    ${token}    ${id_produto}    201
    ${resp_concluir}=   Concluir carrinho    ${token}    200
    Conferência de sucesso    ${resp_concluir.json()}    Registro excluído com sucesso

CT018: Cancelar compra de um carrinho
    [Tags]    DELETE    CARRINHOS
    ${token}=    Obter Token de Autenticação
    Limpar carrinho existente    ${token}
    ${resp_produto}=    Cadastrar produto valido    ${token}    201
    ${id_produto}=      Set Variable    ${resp_produto.json()['_id']}
    Criar carrinho    ${token}    ${id_produto}    201
    ${resp_cancelar}=   Cancelar carrinho    ${token}    200
    Conferência de sucesso    ${resp_cancelar.json()}    Registro excluído com sucesso. Estoque dos produtos reabastecido
    


    #Listar produtos  e acesso com token expirado