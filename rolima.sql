DROP DATABASE IF EXISTS rolima_db;
CREATE DATABASE IF NOT EXISTS rolima_db;
USE rolima_db;

-- ======================
-- TABELA: Usuários
-- ======================
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    telefone VARCHAR(20),
    tipo_usuario ENUM('cliente','admin') DEFAULT 'cliente',
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ======================
-- TABELA: Carrinhos
-- ======================
CREATE TABLE carrinhos (
    id_carrinho INT AUTO_INCREMENT PRIMARY KEY,
    modelo VARCHAR(50) NOT NULL,
    status ENUM('disponível','alugado','manutenção') DEFAULT 'disponível',
    preco_hora DECIMAL(6,2) NOT NULL,
    observacoes TEXT
);

-- ======================
-- TABELA: Percursos
-- ======================
CREATE TABLE percursos (
    id_percurso INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    distancia_m INT,
    dificuldade ENUM('fácil','médio','difícil') DEFAULT 'médio',
    descricao TEXT
);

-- ======================
-- TABELA: Reservas
-- ======================
CREATE TABLE reservas (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_carrinho INT NOT NULL,
    id_percurso INT,
    data_inicio DATETIME NOT NULL,
    data_fim DATETIME NOT NULL,
    status ENUM('ativa','finalizada','cancelada') DEFAULT 'ativa',
    valor_total DECIMAL(8,2),

    CONSTRAINT fk_usuario_reserva FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    CONSTRAINT fk_carrinho_reserva FOREIGN KEY (id_carrinho) REFERENCES carrinhos(id_carrinho),
    CONSTRAINT fk_percurso_reserva FOREIGN KEY (id_percurso) REFERENCES percursos(id_percurso)
);

-- ======================
-- TABELA: Pagamentos
-- ======================
CREATE TABLE pagamentos (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    id_reserva INT NOT NULL,
    valor DECIMAL(8,2) NOT NULL,
    metodo ENUM('cartão','pix','dinheiro') NOT NULL,
    status ENUM('pendente','pago','estornado') DEFAULT 'pendente',
    data_pagamento DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_reserva_pagamento FOREIGN KEY (id_reserva) REFERENCES reservas(id_reserva)
);

-- ======================
-- TABELA: Avaliações
-- ======================
CREATE TABLE avaliacoes (
    id_avaliacao INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_reserva INT NOT NULL,
    nota INT CHECK (nota BETWEEN 1 AND 5),
    comentario TEXT,
    data_avaliacao DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_usuario_avaliacao FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    CONSTRAINT fk_reserva_avaliacao FOREIGN KEY (id_reserva) REFERENCES reservas(id_reserva)
);

-- ======================
-- INSERINDO ALGUNS DADOS INICIAIS
-- ======================
INSERT INTO usuarios (nome, email, senha, telefone, tipo_usuario)
VALUES 
('Admin do Sistema', 'admin@rolima.com', '123456', '51999999999', 'admin'),
('João da Silva', 'joao@email.com', 'senha123', '51988888888', 'cliente');

INSERT INTO carrinhos (modelo, status, preco_hora, observacoes)
VALUES
('Carrinho Infantil', 'disponível', 15.00, 'Reforçado para crianças'),
('Carrinho Adulto', 'disponível', 25.00, 'Suporta até 120kg');

INSERT INTO percursos (nome, distancia_m, dificuldade, descricao)
VALUES
('Descida Principal', 500, 'fácil', 'Reta longa com curvas leves'),
('Serro da Linha Bonita', 1200, 'difícil', 'Descida íngreme e desafiadora');