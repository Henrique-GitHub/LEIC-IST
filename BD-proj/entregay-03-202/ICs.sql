----------------------------------------------------------------------------------------------------------
--  2.Restricoes de Integridade --------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------
--  (RI-1)------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

DROP TRIGGER IF EXISTS verifica_categoria_contida_em_si ON tem_outra;

CREATE OR REPLACE FUNCTION verifica_categoria_contida_em_si_proc()
RETURNS TRIGGER AS
$$
BEGIN
    IF new.super_categoria = new.categoria THEN
        RAISE EXCEPTION 'Uma Categoria não pode estar contida em si própria';
    END IF;
    RETURN new;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER verifica_categoria_contida_em_si BEFORE INSERT OR UPDATE ON tem_outra
FOR EACH ROW EXECUTE PROCEDURE verifica_categoria_contida_em_si_proc();

----------------------------------------------------------------------------------------------------------
--  (RI-4)------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

DROP TRIGGER IF EXISTS verifica_unidades_repostas ON evento_reposicao;

CREATE OR REPLACE FUNCTION verifica_unidades_repostas_proc()
RETURNS TRIGGER AS 
$$
DECLARE max_uni INTEGER := 0;
BEGIN
    SELECT max_unidades INTO max_uni
    FROM planograma p
    WHERE p.ean = new.ean AND p.nro = new.nro AND
            p.num_serie = new.num_serie AND
            p.fabricante = new.fabricante;
    
    IF max_uni < new.unidades THEN
        RAISE EXCEPTION 'O número de unidades repostas num Evento de Reposição não pode exceder o número de unidades especificado no Planograma';
    END IF;
    RETURN new;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER verifica_unidades_repostas BEFORE INSERT OR UPDATE ON evento_reposicao
FOR EACH ROW EXECUTE PROCEDURE verifica_unidades_repostas_proc();                       

----------------------------------------------------------------------------------------------------------
--  (RI-5)------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

DROP TRIGGER IF EXISTS verifica_categoria_prateleira ON evento_reposicao;

CREATE OR REPLACE FUNCTION verifica_categoria_prateleira_proc()
RETURNS TRIGGER AS
$$
DECLARE prateleira_cat VARCHAR(50);
BEGIN
    SELECT nome INTO prateleira_cat
    FROM prateleira p
    WHERE p.nro = new.nro AND p.num_serie = new.num_serie AND p.fabricante = new.fabricante;

    IF prateleira_cat NOT IN (SELECT nome FROM tem_categoria tc WHERE tc.ean = new.ean) THEN
        RAISE EXCEPTION 'Um Produto só pode ser reposto numa Prateleira que apresente (pelo menos) uma das Categorias desse produto';
    END IF;
    RETURN new;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER verifica_categoria_prateleira BEFORE INSERT OR UPDATE ON evento_reposicao
FOR EACH ROW EXECUTE PROCEDURE verifica_categoria_prateleira_proc();
                       
