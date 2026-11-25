# Banco de Dados Relacional - Loja Tech (`loja_tech`)

Este repositório reúne os scripts SQL desenvolvidos para a estruturação, consulta e automação de rotinas de um sistema de vendas de produtos de tecnologia (`loja_tech`), utilizando **MySQL**.



## Estrutura do Banco de Dados

O banco é composto por 6 tabelas principais que armazenam o catálogo, os clientes e o histórico de movimentações:

* **`categorias`**: Classificação dos produtos (ex.: periféricos, monitores) e status de ativação.
* **`produtos`**: Catálogo de itens, preços e controle de quantidade em estoque.
* **`clientes`**: Dados cadastrais e de contato dos compradores.
* **`pedidos`**: Registro das vendas, datas, status de pagamento/entrega e valor total.
* **`itens_pedido`**: Detalhamento dos produtos vinculados a cada pedido.
* **`log_operacoes`**: Registro de auditoria para alterações críticas realizadas no sistema.
![Diagrama do Banco de Dados](<img width="784" height="818" alt="Diagrma" src="https://github.com/user-attachments/assets/a6c44447-4ba3-407b-89e8-7d016616463e" />)




## O que foi desenvolvido e o que cada script faz

### 1. Consultas SQL (Relatórios e Filtros)
Conjunto de queries (`SELECT`) voltadas para extração de dados gerenciais e operacionais:
* **Listagem e Filtros:** Exibe contatos de clientes para marketing, produtos em faixa promocional (abaixo de R$ 500,00), pedidos com status `pendente` e itens de categorias específicas com estoque acima de 40 unidades.
* **Busca e Ordenação:** Organiza o catálogo do maior para o menor preço e realiza buscas textuais parciais (`LIKE`) por palavras-chave como "Monitor".
* **Agregações e Junções (`INNER JOIN`):** Calcula o total de clientes cadastrados, soma o faturamento bruto da loja e cruza dados entre `produtos`, `categorias`, `pedidos` e `clientes` para exibir relatórios completos.

### 2. Stored Procedures (Rotinas Automatizadas)
Procedimentos armazenados no banco que encapsulam regras de negócio e operações repetitivas:

| Procedure | O que faz quando executada |
| :--- | :--- |
| **`listar_categorias_ativas()`** | Retorna o ID, nome e descrição de todas as categorias ativas (`ativo = true`), ordenadas em ordem alfabética. |
| **`buscar_pedidos_por_status(p_status)`** | Recebe um status (ex.: `'entregue'`, `'pendente'`) e lista todos os pedidos correspondentes com data e valor total. |
| **`inserir_categoria(p_nome, p_descricao)`** | Cadastra automaticamente uma nova categoria na tabela `categorias` a partir do nome e descrição informados. |
| **`atualizar_telefone_cliente(p_id, p_tel)`** | Localiza um cliente pelo ID e atualiza seu número de telefone na tabela `clientes`. |
| **`contar_produtos_categoria(p_id, @total)`** | Conta quantos produtos pertencem a uma determinada categoria e devolve o resultado em um parâmetro de saída (`OUT`). |
| **`consultar_extrato_cliente(p_id_cliente)`** | Valida se o cliente existe; caso positivo, retorna 3 relatórios simultâneos: dados cadastrais, histórico de pedidos e resumo financeiro (total de pedidos, valor gasto, ticket médio e data da última compra). |
| **`sp_atualizar_preco_categoria(...)`** | Reajusta os preços dos produtos de uma categoria específica aplicando validações de segurança e registrando a alteração na tabela `log_operacoes`. |



## Como executar os scripts

1. Abra o **MySQL Workbench** e conecte-se ao seu servidor local.
2. Execute primeiro o script de criação do banco e inserção dos dados iniciais.
3. Certifique-se de ativar o banco antes de rodar as consultas ou criar as procedures:
   ```sql
   use loja_tech;
