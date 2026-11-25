use loja_tech;

select nome, email
from clientes;

select nome, preco
from produtos
where preco < 500.00;

select * 
from pedidos
where status = 'pendente';

select nome, preco
from produtos
order by preco desc;

select id_produto, nome, preco
from produtos
where nome like '%Monitor%';

select nome, estoque
from produtos
where id_categoria = 3
and estoque < 40;

select count(*) as total_clientes
from clientes;

select sum(valor_total) as faturamento_bruto
from pedidos;

select 
p.id_pedido,
p.status,
p.valor_total
from pedidos p
inner join clientes c on p.id_cliente = c.id_cliente
where c.nome = 'Ana Silva';
 
