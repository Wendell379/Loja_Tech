DROP PROCEDURE IF EXISTS sp_atualizar_preco_categoria;
use loja_tech;


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_atualizar_preco_categoria$$

CREATE PROCEDURE sp_atualizar_preco_categoria(
    IN p_id_categoria INT,
    IN p_percentual DECIMAL(5,2),
    OUT p_qtd_alterados INT,
    OUT p_mensagem VARCHAR(255)
)
BEGIN
    DECLARE v_categoria_existe INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_qtd_alterados = 0;
        SET p_mensagem = 'Erro inesperado ao atualizar os preços.';
    END;

    SET p_qtd_alterados = 0;

    IF p_percentual < -50.00 OR p_percentual > 100.00 THEN
        SET p_mensagem = 'Erro: O percentual deve estar entre -50% (desconto) e 100% (aumento).';

    ELSEIF p_percentual = 0.00 THEN
        SET p_mensagem = 'Aviso: Percentual de 0% informado. Nenhum preço foi alterado.';

    ELSE
        SELECT COUNT(*) INTO v_categoria_existe
        FROM categorias
        WHERE id_categoria = p_id_categoria;

        IF v_categoria_existe = 0 THEN
            SET p_mensagem = CONCAT('Erro: Categoria ID ', p_id_categoria, ' não encontrada.');
        ELSE
            START TRANSACTION;

            UPDATE produtos
            SET preco = ROUND(preco * (1 + (p_percentual / 100)), 2)
            WHERE id_categoria = p_id_categoria
              AND ativo = TRUE;

            SET p_qtd_alterados = ROW_COUNT();

            INSERT INTO log_operacoes (tabela_afetada, operacao, descricao)
            VALUES (
                'produtos',
                'update_preco',
                CONCAT(
                    'Ajuste de ', p_percentual, '% na categoria ID ', p_id_categoria,
                    '. Produtos afetados: ', p_qtd_alterados, '.'
                )
            );

            COMMIT;

            SET p_mensagem = CONCAT('Sucesso: ', p_qtd_alterados, ' produto(s) atualizado(s) com ajuste de ', p_percentual, '%.');
        END IF;
    END IF;
END$$
