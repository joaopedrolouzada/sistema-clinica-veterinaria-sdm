-- =========================================================
-- API do Governo (simulada) - criação das tabelas
-- Banco separado do banco da clínica (é "outro servidor").
-- Feito para SQLite. Lembrete: rodar PRAGMA foreign_keys = ON;
-- =========================================================

CREATE TABLE gov_animais (
    id             INTEGER PRIMARY KEY,
    microchip      VARCHAR(20)  NOT NULL UNIQUE,
    nome_animal    VARCHAR(100) NOT NULL,
    especie        VARCHAR(30)  NOT NULL,
    cpf_tutor      VARCHAR(14)  NOT NULL,
    nome_tutor     VARCHAR(100) NOT NULL,
    registrado_em  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE gov_vacinas_raiva (
    id              INTEGER PRIMARY KEY,
    protocolo       VARCHAR(50) NOT NULL UNIQUE,   -- devolvido para a clínica
    microchip       VARCHAR(20) NOT NULL,
    data_aplicacao  DATE        NOT NULL,
    lote            VARCHAR(50),
    crmv_veterinario VARCHAR(20) NOT NULL,
    recebido_em     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (microchip) REFERENCES gov_animais(microchip)
);
