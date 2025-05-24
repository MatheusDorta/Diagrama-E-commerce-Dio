CREATE TABLE cliente (
	id INT PRIMARY KEY,
    nome VARCHAR(100),
    tipo CHAR(2) CHECK (tipo IN ('PF', 'PJ')),
    cpf_cnpj VARCHAR(20) UNIQUE NOT NULL, 
    email VARCHAR(100)
);

CREATE TABLE FormaPagamento (
		id INT PRIMARY KEY,
        descricao VARCHAR(50)
);

CREATE TABLE EnderecoEntrega (
	id INT PRIMARY KEY,
    cliente_id INT,
    endereco TEXT,
    status_entrega VARCHAR(50),
    codigo_rastreio VARCHAR(100),
    FOREIGN KEY (cliente_id) REFERENCES Cliente(id)
);

CREATE TABLE Pedido (
		id INT PRIMARY KEY,
        cliente_id INT,
        Data DATE,
        endereco_entrega_id INT,
        FOREIGN KEY (cliente_id) REFERENCES Cliente(id),
        FOREIGN KEY (endereco_entrega_id) REFERENCES EnderecoEntrega(id)
);

CREATE TABLE PagamentoPedido (
			pedido_id INT,
            forma_pagamento_id INT,
			PRIMARY KEY (pedido_id, forma_pagamento_id),
			FOREIGN KEY (pedido_id) REFERENCES Pedido(id),
			FOREIGN KEY (forma_pagamento_id) REFERENCES FormaPagamento(id)
);

CREATE TABLE Fornecedor (
	ID INT PRIMARY KEY,
    nome VARCHAR(100)
);

CREATE TABLE Vendedor (
		id INT PRIMARY KEY,
        nome VARCHAR(100),
        fornecedor_id INT,
        FOREIGN KEY (fornecedor_id) REFERENCES Fornecedor(id)
);

CREATE TABLE Produto (
			id INT PRIMARY KEY,
            nome VARCHAR(100),
            preco DECIMAL(10,2),
            estoque INT,
            fornecedor_id INT,
            FOREIGN KEY (fornecedor_id) REFERENCES Fornecedor(id)
);

SHOW TABLES;

INSERT INTO cliente VALUES (1, 'João da Silva', 'PF', '123.456.789-00', 'joao@email.com');
INSERT INTO cliente VALUES (2, 'Empresa X', 'PJ', '12.345.678/0001-99', 'contato@empresax.com');

INSERT INTO FormaPagamento VALUES (1, 'Cartão de Crédito');
INSERT INTO FormaPagamento VALUES (2, 'Boleto Bancário');

INSERT INTO EnderecoEntrega VALUES (1, 1, 'Rua A, 123', 'Enviado', 'COD123XYZ');

INSERT INTO Fornecedor VALUES (1, 'Fornecedor A');
INSERT INTO Fornecedor VALUES (2, 'Fornecedor B');

INSERT INTO Vendedor  VALUES (1, 'Carlos Vendedor', 1);

INSERT INTO Produto VALUES (1, 'Notebook', 3500.00, 10, 1);
INSERT INTO Produto VALUES (2, 'Mouse', 100.00, 50, 2);            
            
SELECT c.nome, COUNT(p.id) AS total_pedidos
FROM cliente c
LEFT JOIN pedido p ON c.id = p.cliente_id
GROUP BY c.nome;        

SELECT v.nome
FROM Vendedor v
JOIN Fornecedor f ON v.nome = f.nome;

SELECT p.nome AS produto, f.nome AS fornecedor, p.estoque
FROM Produto p
JOIN Fornecedor f ON p.fornecedor_id = f.id;

SELECT f.nome AS fornecedor, p.nome AS produto
FROM Produto p
JOIN Fornecedor f ON p.fornecedor_id = f.id
ORDER BY f.nome;

SELECT p.id AS pedido_id, COUNT(pp.forma_pagamento_id) AS formas_pagamento
FROM Pedido p
JOIN PagamentoPedido pp ON p.id = pp.pedido_id
GROUP BY p.id
HAVING COUNT(pp.forma_pagamento_id) > 1;

SELECT c.nome, e.status_entrega, e.codigo_rastreio
FROM Cliente c
JOIN Pedido p ON c.id = p.cliente_id
JOIN EnderecoEntrega e ON p.endereco_entrega_id = e.id;

USE ecommerce;
SELECT * FROM cliente;
SELECT * FROM cliente WHERE nome = 'João';
SELECT * FROM Fornecedor;

SELECT departamento_id, COUNT(*) AS total_funcionarios
FROM empregado
GROUP BY departamento_id
ORDER BY total_funcionarios DESC
LIMIT 1;

SELECT d.nome AS departamento, d.cidade
FROM departamento d
ORDER BY d.cidade;

SELECT d.nome AS depatramento, e.nome AS empregado
FROM departamento d
JOIN empregado e ON e.departamento_id = d.id
ORDER BY d.nome;

CREATE INDEX idx_empregado_departamento ON empregado(departamento_id);

CREATE INDEX idx_departamento_cidade ON departamento(cidade);

DELIMITER $$

CREATE PROCEDURE sp_gerenciar_produto (
	IN acao INT,
	IN pid INT,
	IN pnome VARCHAR(100),
	IN ppreco DECIMAL(10,2),
	IN pestoque INT,
	IN pfornecedor_id INT
)
BEGIN 
	CASE
		WHEN acao = 1 THEN
			INSERT INTO Produto (id, nome, preco, estqoue, fornecedor_id)
			VALUES (pid, pnome, ppreco, pestoque, pfornecedor_id);

		WHEN acao = 2 THEN
			UPDATE Produto
			SET nome = pnome, preco = ppreco, estoque = pestoque, fornecedor_id = pfornecedor_id
			WHERE id = pid;

		WHEN acao = 3 THEN
			DELETE FROM Produto WHERE id = pid;

		ELSE
			SELECT 'Ação Inválida, Use 1 para INSERT, 2 para UPDATE, 3 para DELETE.' AS mensagem;
END$$

DELIMITER ; 

-- Inserção
CALL sp_gerenciar_produto(1, 101, 'Teclado Gamer', 199.90, 50, 1);

-- Atualização
CALL sp_gerenciar_produto(2, 101, 'Teclado Mecânico RGB', 249.90, 45, 1);

-- Remoção
CALL sp_gerenciar_produto(3, 101, NULL, NULL, NULL, NULL);


-- PARTE 1 – TRANSAÇÕES
SET autocommit = 0;

START TRANSACTION;
UPDATE produto SET estoque = estoque - 1 WHERE id = 1;
UPDATE produto SET estoque = estoque - 1 WHERE id = 2;
COMMIT;

-- PARTE 2 – TRANSAÇÃO COM PROCEDURE
DELIMITER $$

CREATE PROCEDURE sp_movimenta_estoque (
    IN p_id_produto1 INT,
    IN p_id_produto2 INT
)
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE produto SET estoque = estoque - 1 WHERE id = p_id_produto1;
    UPDATE produto SET estoque = estoque - 1 WHERE id = p_id_produto2;

    COMMIT;
END$$

DELIMITER ;

CALL sp_movimenta_estoque(1, 2);

-- PARTE 3 – BACKUP E RECOVERY
-- Backup
-- mysqldump -u root -p e_commerce > e_commerce_backup.sql

-- Recovery
-- mysql -u root -p e_commerce < e_commerce_backup.sql
