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


