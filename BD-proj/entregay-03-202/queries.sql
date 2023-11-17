---------------------------------------------------------------
--   3.SQL  ---------------------------------------------------
---------------------------------------------------------------

---------------------------------------------------------------
--  Qual o nome do retalhista (ou retalhistas) responsaveis
--  pela reposicao do maior numero de categorias
---------------------------------------------------------------
SELECT nome
FROM retalhista r NATURAL JOIN responsavel_por rp
GROUP BY nome
HAVING COUNT(nome_cat) >= ALL (
    SELECT COUNT(nome_cat)
    FROM retalhista r2 NATURAL JOIN responsavel_por rp2
    GROUP BY nome);

---------------------------------------------------------------
--  Qual o nome do ou dos retalhistas que sao responsaveis
--  pela reposicao do maior numero de categorias
---------------------------------------------------------------
SELECT DISTINCT r.nome
FROM retalhista r
WHERE NOT EXISTS(
    SELECT cs.nome
    FROM categoria_simples cs
    EXCEPT
    SELECT nome_cat
    FROM (responsavel_por rp
        JOIN retalhista r2
            ON rp.tin = r2.tin) rp2
        WHERE rp2.nome = r.nome);

---------------------------------------------------------------
--  Quais os produtos (ean) que nunca foram repostos
---------------------------------------------------------------
SELECT p.ean
FROM produto p
WHERE p.ean
NOT IN (SELECT rp.ean FROM evento_reposicao rp);

---------------------------------------------------------------
--  Quais os produtos (ean) que foram repostos sempre pelo
--  mesmo retalhista
---------------------------------------------------------------
SELECT ean
FROM retalhista r NATURAL JOIN evento_reposicao er
GROUP BY ean
HAVING COUNT(DISTINCT r.tin) = 1;
