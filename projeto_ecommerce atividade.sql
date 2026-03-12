-- ============================================================
--  PROJETO: Sistema de E-commerce
--  Nível: SQL Intermediário
--  Autor: Henrique Carvalho
--  Descrição: Banco de dados relacional para uma plataforma
--             de e-commerce com clientes, produtos, pedidos
--             e análises de desempenho.
-- ============================================================


-- ============================================================
-- SEÇÃO 1: CRIAÇÃO DAS TABELAS (DDL)
-- ============================================================

CREATE TABLE categorias (
    id_categoria  INT           PRIMARY KEY AUTO_INCREMENT,
    nome          VARCHAR(100)  NOT NULL,
    descricao     TEXT
);

CREATE TABLE produtos (
    id_produto    INT             PRIMARY KEY AUTO_INCREMENT,
    nome          VARCHAR(150)    NOT NULL,
    descricao     TEXT,
    preco         DECIMAL(10,2)   NOT NULL,
    estoque       INT             NOT NULL DEFAULT 0,
    id_categoria  INT             NOT NULL,
    ativo         BOOLEAN         NOT NULL DEFAULT TRUE,
    criado_em     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_produto_categoria
        FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

CREATE TABLE clientes (
    id_cliente    INT           PRIMARY KEY AUTO_INCREMENT,
    nome          VARCHAR(150)  NOT NULL,
    email         VARCHAR(200)  NOT NULL UNIQUE,
    cpf           CHAR(11)      NOT NULL UNIQUE,
    telefone      VARCHAR(20),
    cidade        VARCHAR(100),
    estado        CHAR(2),
    criado_em     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pedidos (
    id_pedido     INT           PRIMARY KEY AUTO_INCREMENT,
    id_cliente    INT           NOT NULL,
    status        ENUM('pendente','aprovado','enviado','entregue','cancelado')
                                NOT NULL DEFAULT 'pendente',
    total         DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    criado_em     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME      ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE itens_pedido (
    id_item       INT             PRIMARY KEY AUTO_INCREMENT,
    id_pedido     INT             NOT NULL,
    id_produto    INT             NOT NULL,
    quantidade    INT             NOT NULL,
    preco_unitario DECIMAL(10,2)  NOT NULL,   -- preço no momento da compra
    CONSTRAINT fk_item_pedido
        FOREIGN KEY (id_pedido)   REFERENCES pedidos(id_pedido),
    CONSTRAINT fk_item_produto
        FOREIGN KEY (id_produto)  REFERENCES produtos(id_produto)
);

CREATE TABLE avaliacoes (
    id_avaliacao  INT     PRIMARY KEY AUTO_INCREMENT,
    id_cliente    INT     NOT NULL,
    id_produto    INT     NOT NULL,
    nota          TINYINT NOT NULL CHECK (nota BETWEEN 1 AND 5),
    comentario    TEXT,
    criado_em     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_aval_cliente  FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    CONSTRAINT fk_aval_produto  FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);


-- ============================================================
-- SEÇÃO 2: ÍNDICES PARA PERFORMANCE
-- ============================================================

CREATE INDEX idx_pedidos_cliente   ON pedidos(id_cliente);
CREATE INDEX idx_pedidos_status    ON pedidos(status);
CREATE INDEX idx_pedidos_criado    ON pedidos(criado_em);
CREATE INDEX idx_itens_pedido      ON itens_pedido(id_pedido);
CREATE INDEX idx_produtos_categoria ON produtos(id_categoria);


-- ============================================================
-- SEÇÃO 3: INSERÇÃO DE DADOS DE EXEMPLO (DML)
-- ============================================================

INSERT INTO categorias (nome, descricao) VALUES
('Eletrônicos',    'Smartphones, notebooks, tablets e acessórios'),
('Roupas',         'Vestuário masculino e feminino'),
('Livros',         'Livros físicos e e-books'),
('Casa e Jardim',  'Móveis, decoração e ferramentas');

INSERT INTO produtos (nome, preco, estoque, id_categoria) VALUES
('Smartphone Galaxy S22',  3499.90,  50, 1),
('Notebook Dell Inspiron', 4299.00,  30, 1),
('Fone Bluetooth JBL',      299.90, 120, 1),
('Camiseta Polo Masculina',  89.90, 200, 2),
('Tênis Casual Feminino',   159.90, 150, 2),
('Clean Code - Robert Martin', 79.90, 80, 3),
('O Poder do Hábito',          54.90, 60, 3),
('Cadeira de Escritório',    899.00,  25, 4),
('Luminária LED',             129.90, 90, 4);

INSERT INTO clientes (nome, email, cpf, cidade, estado) VALUES
('Ana Souza',     'ana.souza@email.com',    '11122233344', 'São Paulo',       'SP'),
('Bruno Lima',    'bruno.lima@email.com',   '22233344455', 'Rio de Janeiro',  'RJ'),
('Carla Mendes',  'carla.mendes@email.com', '33344455566', 'Belo Horizonte',  'MG'),
('Diego Santos',  'diego.santos@email.com', '44455566677', 'Curitiba',        'PR'),
('Eva Costa',     'eva.costa@email.com',    '55566677788', 'Florianópolis',   'SC'),
('Felipe Torres', 'felipe.t@email.com',     '66677788899', 'Salvador',        'BA'),
('Gabriela Alves','gabriela.a@email.com',   '77788899900', 'Recife',          'PE');

INSERT INTO pedidos (id_cliente, status, total) VALUES
(1, 'entregue',  3799.80),
(1, 'aprovado',   299.90),
(2, 'entregue',  4299.00),
(3, 'enviado',    249.80),
(4, 'entregue',   899.00),
(5, 'pendente',   159.90),
(6, 'cancelado',  79.90),
(7, 'entregue',  3629.80),
(2, 'aprovado',   129.90);

INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 3499.90), (1, 3, 1,  299.90),
(2, 3, 1,  299.90),
(3, 2, 1, 4299.00),
(4, 4, 2,   89.90), (4, 6, 1,   79.90),  -- 2 camisetas + 1 livro
(5, 8, 1,  899.00),
(6, 5, 1,  159.90),
(7, 6, 1,   79.90),
(8, 1, 1, 3499.90), (8, 4, 1,   89.90), (8, 7, 1,  54.90),
(9, 9, 1,  129.90);

INSERT INTO avaliacoes (id_cliente, id_produto, nota, comentario) VALUES
(1, 1, 5, 'Excelente smartphone, bateria dura bastante!'),
(1, 3, 4, 'Ótimo fone, mas poderia ter melhor isolamento.'),
(2, 2, 5, 'Notebook muito rápido, super recomendo.'),
(3, 4, 3, 'Boa camiseta, mas o tamanho saiu menor que o esperado.'),
(4, 8, 5, 'Cadeira confortável, valeu cada centavo.'),
(7, 1, 4, 'Bom produto, entrega rápida.');


-- ============================================================
-- SEÇÃO 4: QUERIES DE ANÁLISE (INTERMEDIÁRIO)
-- ============================================================

-- -------------------------------------------------------
-- 4.1  Total de pedidos e receita por status
-- -------------------------------------------------------
SELECT
    status,
    COUNT(*)            AS total_pedidos,
    SUM(total)          AS receita_total,
    AVG(total)          AS ticket_medio
FROM pedidos
GROUP BY status
ORDER BY receita_total DESC;


-- -------------------------------------------------------
-- 4.2  Top 5 produtos mais vendidos (por quantidade)
-- -------------------------------------------------------
SELECT
    p.nome                      AS produto,
    SUM(ip.quantidade)          AS unidades_vendidas,
    SUM(ip.quantidade * ip.preco_unitario) AS receita_gerada
FROM itens_pedido ip
JOIN produtos p ON p.id_produto = ip.id_produto
JOIN pedidos  pe ON pe.id_pedido = ip.id_pedido
WHERE pe.status NOT IN ('cancelado')
GROUP BY p.id_produto, p.nome
ORDER BY unidades_vendidas DESC
LIMIT 5;


-- -------------------------------------------------------
-- 4.3  Clientes com mais de 1 pedido (clientes fiéis)
-- -------------------------------------------------------
SELECT
    c.nome,
    c.email,
    COUNT(pe.id_pedido)  AS total_pedidos,
    SUM(pe.total)        AS gasto_total
FROM clientes c
JOIN pedidos pe ON pe.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome, c.email
HAVING COUNT(pe.id_pedido) > 1
ORDER BY gasto_total DESC;


-- -------------------------------------------------------
-- 4.4  Média de avaliação por produto (com total de reviews)
-- -------------------------------------------------------
SELECT
    p.nome                          AS produto,
    ROUND(AVG(a.nota), 2)           AS media_nota,
    COUNT(a.id_avaliacao)           AS total_avaliacoes
FROM produtos p
LEFT JOIN avaliacoes a ON a.id_produto = p.id_produto
GROUP BY p.id_produto, p.nome
ORDER BY media_nota DESC;


-- -------------------------------------------------------
-- 4.5  Receita mensal (últimos 12 meses)
-- -------------------------------------------------------
SELECT
    DATE_FORMAT(criado_em, '%Y-%m') AS mes,
    COUNT(*)                        AS pedidos_realizados,
    SUM(total)                      AS receita_mensal
FROM pedidos
WHERE status = 'entregue'
  AND criado_em >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
GROUP BY mes
ORDER BY mes;


-- -------------------------------------------------------
-- 4.6  Produtos com estoque crítico (< 30 unidades)
-- -------------------------------------------------------
SELECT
    p.nome          AS produto,
    c.nome          AS categoria,
    p.estoque,
    p.preco
FROM produtos p
JOIN categorias c ON c.id_categoria = p.id_categoria
WHERE p.ativo = TRUE
  AND p.estoque < 30
ORDER BY p.estoque ASC;


-- -------------------------------------------------------
-- 4.7  Clientes que nunca fizeram pedido (LEFT JOIN)
-- -------------------------------------------------------
SELECT
    c.nome,
    c.email,
    c.criado_em AS cliente_desde
FROM clientes c
LEFT JOIN pedidos pe ON pe.id_cliente = c.id_cliente
WHERE pe.id_pedido IS NULL;


-- -------------------------------------------------------
-- 4.8  Ranking de categorias por receita (WINDOW FUNCTION)
-- -------------------------------------------------------
SELECT
    cat.nome                                            AS categoria,
    SUM(ip.quantidade * ip.preco_unitario)              AS receita,
    RANK() OVER (ORDER BY SUM(ip.quantidade * ip.preco_unitario) DESC) AS ranking
FROM itens_pedido ip
JOIN produtos  p   ON p.id_produto   = ip.id_produto
JOIN categorias cat ON cat.id_categoria = p.id_categoria
JOIN pedidos   pe  ON pe.id_pedido   = ip.id_pedido
WHERE pe.status NOT IN ('cancelado')
GROUP BY cat.id_categoria, cat.nome;


-- ============================================================
-- SEÇÃO 5: VIEWS REUTILIZÁVEIS
-- ============================================================

-- View: resumo dos pedidos com nome do cliente
CREATE OR REPLACE VIEW vw_pedidos_resumo AS
SELECT
    pe.id_pedido,
    c.nome          AS cliente,
    c.email,
    pe.status,
    pe.total,
    pe.criado_em
FROM pedidos pe
JOIN clientes c ON c.id_cliente = pe.id_cliente;


-- View: desempenho de produtos
CREATE OR REPLACE VIEW vw_desempenho_produtos AS
SELECT
    p.id_produto,
    p.nome                                           AS produto,
    cat.nome                                         AS categoria,
    p.preco,
    p.estoque,
    COALESCE(SUM(ip.quantidade), 0)                  AS total_vendido,
    COALESCE(ROUND(AVG(a.nota), 2), 0)               AS media_avaliacao
FROM produtos p
JOIN categorias cat  ON cat.id_categoria = p.id_categoria
LEFT JOIN itens_pedido ip ON ip.id_produto = p.id_produto
LEFT JOIN pedidos pe      ON pe.id_pedido  = ip.id_pedido
                         AND pe.status NOT IN ('cancelado')
LEFT JOIN avaliacoes a    ON a.id_produto  = p.id_produto
GROUP BY p.id_produto, p.nome, cat.nome, p.preco, p.estoque;


-- ============================================================
-- SEÇÃO 6: STORED PROCEDURE
-- ============================================================

DELIMITER $$

CREATE PROCEDURE sp_registrar_pedido(
    IN  p_id_cliente  INT,
    OUT p_id_pedido   INT
)
BEGIN
    -- Cria o pedido com status padrão 'pendente'
    INSERT INTO pedidos (id_cliente, status, total)
    VALUES (p_id_cliente, 'pendente', 0.00);

    SET p_id_pedido = LAST_INSERT_ID();
END$$

DELIMITER ;


-- ============================================================
-- SEÇÃO 7: TRIGGER
-- ============================================================

DELIMITER $$

-- Atualiza o total do pedido sempre que um item é inserido
CREATE TRIGGER trg_atualiza_total_pedido
AFTER INSERT ON itens_pedido
FOR EACH ROW
BEGIN
    UPDATE pedidos
    SET total = (
        SELECT SUM(quantidade * preco_unitario)
        FROM itens_pedido
        WHERE id_pedido = NEW.id_pedido
    )
    WHERE id_pedido = NEW.id_pedido;
END$$

DELIMITER ;


-- ============================================================
-- FIM DO SCRIPT
-- ============================================================
