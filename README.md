# 🛒 Projeto E-commerce - DIO

Este projeto simula a modelagem de um banco de dados relacional para um sistema de E-commerce. A proposta foi desenvolvida como parte de um desafio da Digital Innovation One (DIO), abordando conceitos de banco de dados, modelagem relacional e regras de negócio.

## 📌 Objetivo

Modelar as entidades e os relacionamentos de um sistema de e-commerce que abrange:

- Cadastro de clientes (Pessoa Física ou Jurídica)
- Gerenciamento de pedidos, produtos e estoque
- Relacionamento com fornecedores e vendedores terceiros
- Regras de negócio que garantem integridade e consistência

---

## 🧠 Regras de Negócio Refinadas

- **Cliente (PF ou PJ):** Cada cliente pode ser cadastrado como **Pessoa Física** ou **Pessoa Jurídica**, mas **não pode ser os dois ao mesmo tempo**.
- **Pagamento:** Um pedido pode ter **mais de uma forma de pagamento** (ex: parte no cartão, parte no boleto).
- **Entrega:** Cada pedido deve conter um **status de entrega** (como “em processamento”, “enviado” ou “entregue”) e um **código de rastreio** para acompanhamento.

---

## 🗂️ Entidades Modeladas

- **Cliente**
- **Pedido**
- **Produto**
- **Fornecedor**
- **Estoque**
- **Terceiro-Vendedor**
- **Forma de Pagamento** (implementada conforme a regra refinada)

---

## 🛠️ Tecnologias Utilizadas

- Modelagem de dados com base no Modelo Entidade-Relacionamento
- SQL (DDL) para criação de tabelas
- MySql Workbanch 8.0 para elaboração do diagrama

---


