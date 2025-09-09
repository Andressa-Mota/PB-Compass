*** Settings ***
Resource    ../keywords/test_serverest.resource
Resource    ../keywords/commom.robot

*** Test Cases ***

CT001: Cadastrar novo usuário com sucesso
    [Tags]    POST    USUARIOS
    ${resp}=    Cadastrar usuario valido    201
    Conferência de cadastro    ${resp}

CT002: Cadastrar usuário com e-mail duplicado
    [Tags]    POST    USUARIOS
    ${resp}=    Cadastrar usuario duplicado    400
    Conferência de erro    ${resp}    "Este email já está sendo usado"

CT003: Cadastrar usuário com provedor bloqueado (gmail)
    [Tags]    POST    USUARIOS
    ${resp}=    Cadastrar usuario provedor bloqueado    gmail    400
    Conferência de erro    ${resp}    "não permitido"

CT004: Cadastrar usuário com provedor bloqueado (hotmail)
    [Tags]    POST    USUARIOS
    ${resp}=    Cadastrar usuario provedor bloqueado    hotmail    400
    Conferência de erro    ${resp}    "não permitido"

CT005: Atualizar usuário inexistente
    [Tags]    PUT    USUARIOS
    ${resp}=    Atualizar usuario inexistente    201
    Conferência de erro    ${resp}    "Usuário não encontrado"

CT006: Deletar usuário inexistente
    [Tags]    DELETE    USUARIOS
    ${resp}=    Deletar usuario inexistente    404
    Conferência de erro    ${resp}    "Usuário não encontrado"

CT007: Listar usuários
    [Tags]    GET    USUARIOS
    ${resp}=    Listar usuarios    200
    Conferência de lista    ${resp}

CT008: Login com usuário válido
    [Tags]    POST    LOGIN
    ${resp}=    Login usuario valido    200
    Conferência de login    ${resp}

CT009: Login com usuário inexistente
    [Tags]    POST    LOGIN
    ${resp}=    Login usuario inexistente    401
    Conferência de erro    ${resp}    "Email e/ou senha inválidos"

CT010: Login com senha incorreta
    [Tags]    POST    LOGIN
    ${resp}=    Login senha incorreta    401
    Conferência de erro    ${resp}    "Email e/ou senha inválidos"

CT011: Login sem senha
    [Tags]    POST    LOGIN
    ${resp}=    Login sem senha    400
    Conferência de erro    ${resp}    "Senha é obrigatória"

CT012: Cadastrar novo produto com sucesso
    [Tags]    POST    PRODUTOS
    ${resp}=    Cadastrar produto valido    201
    Conferência de cadastro    ${resp}

CT013: Cadastrar produto duplicado
    [Tags]    POST    PRODUTOS
    ${resp}=    Cadastrar produto duplicado    400
    Conferência de erro    ${resp}    "Já existe produto com esse nome"

CT014: Cadastrar produto sem autenticação
    [Tags]    POST    PRODUTOS
    ${resp}=    Cadastrar produto sem autenticação    401
    Conferência de erro    ${resp}    "Token de acesso ausente, inválido, expirado ou usuário do token não existe mais"

CT015: Atualizar produto inexistente
    [Tags]    PUT    PRODUTOS
    ${resp}=    Atualizar produto inexistente    201
    Conferência de erro    ${resp}    "Produto não encontrado"

CT016: Excluir produto vinculado a carrinho
    [Tags]    DELETE    PRODUTOS
    ${resp}=    Excluir produto em carrinho    400
    Conferência de erro    ${resp}    "Não é permitido excluir produto que faz parte de carrinho"

CT017: Criar carrinho com sucesso
    [Tags]    POST    CARRINHOS
    Cadastrar produto valido    201
    ${resp}=    Criar carrinho    201
    Conferência de cadastro    ${resp}

CT018: Cancelar carrinho
    [Tags]    DELETE    CARRINHOS
    ${resp}=    Cancelar carrinho    200
    Conferência de sucesso    ${resp}

CT019: Concluir carrinho
    [Tags]    DELETE    CARRINHOS
    ${resp}=    Concluir carrinho    200
    Conferência de sucesso    ${resp}
