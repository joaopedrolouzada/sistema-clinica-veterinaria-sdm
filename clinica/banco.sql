-- =========================================================
-- Sistema de Clínica Veterinária - criação das tabelas
-- Milestone 1 (Modelagem)
--
-- Feito para SQLite (banco escolhido pelo grupo). Testado.
-- Lembrete: no SQLite as chaves estrangeiras só funcionam
-- depois de rodar: PRAGMA foreign_keys = ON;
-- =========================================================

-- ---------------------------------------------------------
-- BANCO DA CLÍNICA (API privada)
-- ---------------------------------------------------------

-- Quem pode entrar no sistema (login)
CREATE TABLE usuarios (
    id          INTEGER PRIMARY KEY,
    nome        VARCHAR(100) NOT NULL,
    email       VARCHAR(100) NOT NULL UNIQUE,
    senha_hash  VARCHAR(255) NOT NULL,           -- nunca salvar a senha pura
    perfil      VARCHAR(20)  NOT NULL DEFAULT 'recepcao', -- 'admin', 'veterinario' ou 'recepcao'
    ativo       BOOLEAN      NOT NULL DEFAULT 1,
    criado_em   TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

-- Dono do animal. O endereço vem do ViaCEP a partir do CEP.
CREATE TABLE tutores (
    id           INTEGER PRIMARY KEY,
    nome         VARCHAR(100) NOT NULL,
    cpf          VARCHAR(14)  NOT NULL UNIQUE,
    telefone     VARCHAR(20),
    email        VARCHAR(100),
    cep          VARCHAR(9),
    logradouro   VARCHAR(150),                   -- preenchido pelo ViaCEP
    numero       VARCHAR(10),                    -- digitado pelo usuário
    complemento  VARCHAR(100),
    bairro       VARCHAR(100),                   -- preenchido pelo ViaCEP
    cidade       VARCHAR(100),                   -- preenchido pelo ViaCEP
    uf           CHAR(2),                        -- preenchido pelo ViaCEP
    criado_em    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Veterinários da clínica. usuario_id liga o vet ao login dele (opcional).
CREATE TABLE veterinarios (
    id             INTEGER PRIMARY KEY,
    nome           VARCHAR(100) NOT NULL,
    crmv           VARCHAR(20)  NOT NULL UNIQUE,
    especialidade  VARCHAR(100),
    telefone       VARCHAR(20),
    email          VARCHAR(100),
    usuario_id     INTEGER,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Animais. Cada animal tem um tutor. Microchip é opcional, mas não pode repetir.
CREATE TABLE animais (
    id                     INTEGER PRIMARY KEY,
    tutor_id               INTEGER     NOT NULL,
    nome                   VARCHAR(100) NOT NULL,
    especie                VARCHAR(30)  NOT NULL,   -- 'cachorro', 'gato', ...
    raca                   VARCHAR(50),
    sexo                   CHAR(1),                 -- 'M' ou 'F'
    data_nascimento        DATE,
    peso                   DECIMAL(5,2),            -- em kg
    microchip              VARCHAR(20) UNIQUE,      -- NULL se não tiver chip
    registrado_governo     BOOLEAN NOT NULL DEFAULT 0, -- já foi enviado para a API do governo?
    criado_em              TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tutor_id) REFERENCES tutores(id)
);

-- Consultas: um animal é atendido por um veterinário em uma data.
CREATE TABLE consultas (
    id              INTEGER PRIMARY KEY,
    animal_id       INTEGER   NOT NULL,
    veterinario_id  INTEGER   NOT NULL,
    data_hora       TIMESTAMP NOT NULL,
    motivo          VARCHAR(255),
    diagnostico     TEXT,
    observacoes     TEXT,
    status          VARCHAR(20) NOT NULL DEFAULT 'agendada', -- 'agendada', 'realizada' ou 'cancelada'
    FOREIGN KEY (animal_id)      REFERENCES animais(id),
    FOREIGN KEY (veterinario_id) REFERENCES veterinarios(id)
);

-- Vacinas aplicadas. As colunas "envio_governo" cuidam da regra da antirrábica.
CREATE TABLE vacinas (
    id                    INTEGER PRIMARY KEY,
    animal_id             INTEGER NOT NULL,
    veterinario_id        INTEGER NOT NULL,
    consulta_id           INTEGER,                 -- opcional: vacina dada numa consulta
    nome_vacina           VARCHAR(100) NOT NULL,   -- ex: 'Antirrábica', 'V10'
    antirrabica           BOOLEAN NOT NULL DEFAULT 0, -- 1 = precisa ir para o governo
    lote                  VARCHAR(50),
    data_aplicacao        DATE NOT NULL,
    proxima_dose          DATE,
    -- Controle do envio para a API do governo:
    status_envio          VARCHAR(20) NOT NULL DEFAULT 'nao_precisa', -- 'nao_precisa', 'pendente' ou 'enviada'
    tentativas_envio      INTEGER NOT NULL DEFAULT 0,
    ultimo_erro           VARCHAR(255),            -- mensagem da última falha
    data_envio            TIMESTAMP,               -- quando o governo confirmou
    protocolo_governo     VARCHAR(50),             -- número que a API do governo devolve
    FOREIGN KEY (animal_id)      REFERENCES animais(id),
    FOREIGN KEY (veterinario_id) REFERENCES veterinarios(id),
    FOREIGN KEY (consulta_id)    REFERENCES consultas(id)
);
