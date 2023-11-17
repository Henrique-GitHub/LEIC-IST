---------------------------------------------------------------
--   6.Consultas OLAP   ---------------------------------------
---------------------------------------------------------------

---------------------------------------------------------------
--  1. Numero total de artigos vendidos num periodo, por dia 
--  da semana, por concelho e no total
---------------------------------------------------------------



SELECT dia_semana, concelho, SUM(unidades) AS Total_unidades
FROM Vendas
WHERE CAST(CONCAT(ano, '-', mes, '-', dia_mes) AS DATE)
BETWEEN '2022-01-01' AND '2022-03-13'
GROUP BY
    GROUPING SETS ( (dia_semana, concelho), dia_semana, concelho, ( ) )
ORDER BY dia_semana, concelho;



---------------------------------------------------------------
--  2. Numero total de artigos vendidos num distrito, 
--  por concelho, categoria, dia da semana e no total
---------------------------------------------------------------
SELECT concelho, cat, dia_semana, SUM(unidades) AS Total_unidades
FROM Vendas
WHERE distrito = 'Lisboa'
GROUP BY
    CUBE (concelho , cat, dia_semana)
ORDER BY concelho, cat, dia_semana;