------------------------------------------------------------------------------------------
--  4.Vistas    --------------------------------------------------------------------------
------------------------------------------------------------------------------------------

DROP VIEW IF EXISTS Vendas;

CREATE VIEW Vendas(ean, cat, ano, trimestre, mes, dia_mes, dia_semana, distrito, concelho, unidades)
AS
SELECT ean, X.cat, EXTRACT(YEAR FROM instante) AS ano, EXTRACT(QUARTER FROM instante)
    AS trimestre, EXTRACT(MONTH FROM instante) AS mes, EXTRACT(DAY FROM instante) AS dia_mes, EXTRACT(DOW FROM instante) 
    AS dia_semana, distrito, concelho, unidades
FROM (evento_reposicao
    NATURAL JOIN    instalada_em    
    NATURAL JOIN    produto) AS X JOIN ponto_de_retalho ON X.localizacao = ponto_de_retalho.nome;