use loja_tech;
DROP PROCEDURE IF EXISTS consultar_extrato_cliente$$

delimiter $$

drop procedure if exists consultar_extrato_cliente$$

create procedure consultar_extrato_cliente(
    in p_id_cliente int
)
begin
    declare v_cliente_existe int default 0;

    select count(*) into v_cliente_existe
    from clientes
    where id_cliente = p_id_cliente;

    if v_cliente_existe = 0 then
        select concat('Erro: Cliente ID ', p_id_cliente, ' não encontrado.') as mensagem;
    else

        select 
            nome,
            email,
            telefone,
            criado_em as data_cadastro
        from clientes
        where id_cliente = p_id_cliente;
        
        select 
            id_pedido as numero_pedido,
            data_pedido as data,
            status,
            valor_total
        from pedidos
        where id_cliente = p_id_cliente
        order by data_pedido desc;

        select 
            count(id_pedido) as total_pedidos,
            coalesce(sum(valor_total), 0.00) as valor_total_gasto,
            coalesce(round(avg(valor_total), 2), 0.00) as ticket_medio,
            max(data_pedido) as ultimo_pedido
        from pedidos
        where id_cliente = p_id_cliente;
    end if;
end$$

delimiter ;


call consultar_extrato_cliente(1);
SHOW PROCEDURE STATUS WHERE Db = 'loja_tech';