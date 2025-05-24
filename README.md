# 📦 Projeto Banco de Dados - E-commerce (Diagrama Incluso)

Este projeto consiste na modelagem e implementação de um banco de dados relacional para um sistema de e-commerce. Ele abrange as principais entidades e relacionamentos necessários para o funcionamento de uma loja virtual.

## 🧱 Estrutura do Banco de Dados

O banco de dados é composto pelas seguintes tabelas:

- `cliente`: Armazena informações dos clientes (PF e PJ).
- `enderecoentrega`: Registra os endereços de entrega vinculados a clientes.
- `pedido`: Guarda os pedidos realizados por clientes.
- `formapagamento`: Contém os métodos de pagamento disponíveis.
- `pagamentopedido`: Associa pedidos às formas de pagamento utilizadas.
- `fornecedor`: Dados dos fornecedores dos produtos.
- `vendedor`: Vendedores associados a fornecedores.
- `produto`: Produtos disponíveis no e-commerce.

## 🛠️ Tecnologias

- MySQL
- SQL padrão (DDL + DML)
- MySQL Workbench (ou qualquer outro client SQL)

## 📄 Scripts

### 📌 Criação das Tabelas (DDL)

O script `create_tables.sql` contém todos os comandos `CREATE TABLE` para estruturar o banco.

## 📊 Projeto: Índices Otimizados no Banco de Dados (Company)

Neste projeto, aplicamos **técnicas de otimização com índices** em tabelas de um banco de dados relacional representando uma estrutura corporativa, com o objetivo de acelerar consultas frequentes e relevantes.

---

### ✅ Consultas resolvidas

- Qual o departamento com maior número de pessoas?
- Quais são os departamentos por cidade?
- Relação de empregados por departamento

---

### 📌 Índices criados

| Índice                         | Tabela       | Coluna           | Tipo    | Motivo                                                                 |
|-------------------------------|--------------|------------------|---------|------------------------------------------------------------------------|
| `idx_empregado_departamento`  | `empregado`  | `departamento_id`| B-TREE  | Acelera junções e contagens por departamento.                         |
| `idx_departamento_cidade`     | `departamento`| `cidade`         | B-TREE  | Otimiza buscas e ordenações por cidade.                               |

> **Critério de criação:** foram considerados apenas índices com impacto direto nas queries mais comuns e de maior custo.

---

### 🔧 Scripts disponíveis

- `create_indexes.sql`: Criação dos índices otimizados.
- `queries_otimizadas.sql`: Consultas com aproveitamento dos índices.

### 📌 Inserção de Dados (DML)

O script `insert_data.sql` traz exemplos de inserções para teste do banco de dados.

### 📌 Consultas Exemplares (SQL)

Você pode realizar consultas como:

```sql
-- Clientes cadastrados
SELECT * FROM cliente;

-- Pedidos e total por cliente
SELECT c.nome, COUNT(p.id) AS total_pedidos
FROM cliente c
LEFT JOIN pedido p ON c.id = p.cliente_id
GROUP BY c.id;
