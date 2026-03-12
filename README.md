🛒 projeto_ecommerce-atividade-sql
Banco de dados relacional de um sistema de e-commerce, desenvolvido como projeto prático para estudo e demonstração de habilidades em SQL intermediário.

📋 Sobre o Projeto
Este projeto simula o banco de dados de uma plataforma de vendas online, cobrindo desde o cadastro de produtos e clientes até a análise de desempenho de vendas. O objetivo é demonstrar domínio de modelagem relacional, consultas analíticas e recursos avançados do SQL Server.

🗄️ Estrutura do Banco de Dados
O banco é composto por 5 tabelas relacionadas entre si:

Tabela                      Descrição
categorias            Agrupamento dos produtos
produtos              Catálogo com preço, estoque e status
clientes              Dados dos compradores
pedidos               Registros de compras com status e total
itens_pedido          Itens de cada pedido (relação N:N entre pedidos e produtos)
avaliacoes            Notas e comentários dos clientes sobre produtos


Diagrama de Relacionamento
categorias ──< produtos ──< itens_pedido >── pedidos >── clientes
                   │                                         │
                   └──────────── avaliacoes ─────────────────┘

⚙️ Recursos Utilizados

✅ Criação de tabelas com chaves primárias e estrangeiras
✅ Constraints de integridade (UNIQUE, CHECK, NOT NULL)
✅ Índices para otimização de performance
✅ Consultas com JOINs múltiplos
✅ Agregações com GROUP BY, SUM, AVG, COUNT
✅ Filtro de grupos com HAVING
✅ LEFT JOIN para identificar registros sem correspondência
✅ Funções de data com DATE_FORMAT e DATE_SUB
✅ Window Function RANK() OVER()
✅ Views reutilizáveis
✅ Stored Procedure com parâmetro de saída
✅ Trigger para atualização automática de totais


📊 Consultas de Análise Incluídas

1.Total de pedidos e receita agrupados por status
2.Top 5 produtos mais vendidos por quantidade
3.Clientes com mais de um pedido (clientes fiéis)
4.Média de avaliação por produto
5.Receita mensal dos últimos 12 meses
6.Produtos com estoque crítico (abaixo de 30 unidades)
7.Clientes que nunca realizaram um pedido
8.Ranking de categorias por receita com Window Function


🚀 Como Executar
Pré-requisitos

SQL Server instalado
SQL Server Management Studio (SSMS) ou Azure Data Studio

Passos

1.Clone o repositório:

bash   git clone https://github.com/Henrique-devv/projeto_ecommerce-atividade-sql.git

2.Abra o arquivo projeto_ecommerce.sql no SSMS
3.Crie um novo banco de dados e selecione-o:

sql   CREATE DATABASE ecommerce;
   USE ecommerce;

4.Execute o script completo (F5 ou botão Execute)


🛠️ Tecnologias
SQL SERVER
GIT
GITHUB

👤 Autor
Feito por Henrique Carvalho — sinta-se à vontade para explorar meus outros projetos aqui no GitHub.

