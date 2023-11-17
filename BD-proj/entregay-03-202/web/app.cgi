#!/usr/bin/python3

from wsgiref.handlers import CGIHandler
from flask import Flask
from flask import render_template, request, redirect, url_for

import psycopg2
import psycopg2.extras

## SGBD configs
DB_HOST = "db.tecnico.ulisboa.pt"
DB_USER = "ist199133"
DB_DATABASE = DB_USER
DB_PASSWORD = "mjry1275"
DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % (
    DB_HOST,
    DB_DATABASE,
    DB_USER,
    DB_PASSWORD,
)

app = Flask(__name__)

@app.route("/")
def main():
    try:
        return render_template("index.html", params=request.form)
    except Exception as e:
        return str(e)


@app.route('/categorias', methods=["POST", "GET"])
def menu_categorias():
    try:
        return render_template("menu_categorias.html", params=request.form)
    except Exception as e:
        return str(e)

@app.route('/categorias/update', methods=["POST", "GET"])
def update_categorias():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        cat = request.form["Categoria"]
        if (request.form['action'] == "Inserir Categoria Simples"):
            query = "INSERT INTO categoria (nome) \
                    VALUES (%s); \
                    INSERT INTO categoria_simples (nome) \
                    VALUES (%s);"
            data = (cat,cat)
        elif (request.form['action'] == "Inserir Super Categoria"):
            query = "INSERT INTO categoria (nome) \
                    VALUES (%s); \
                    INSERT INTO super_categoria (nome) \
                    VALUES (%s);"
            data = (cat,cat)
        elif (request.form['action'] == "Remover Categoria"):
            query = "DELETE FROM categoria \
                    WHERE nome=%s; \
                    DELETE FROM categoria_simples \
                    WHERE nome=%s; \
                    DELETE FROM super_categoria\
                    WHERE nome=%s;"
            data = (cat,cat,cat)
        elif (request.form['action'] == "Listar sub-categorias"):
            query = "WITH RECURSIVE subcat (super, sub) AS \
                        (SELECT * FROM tem_outra WHERE super_categoria=%s \
                        UNION ALL \
                        SELECT sc.super, t.categoria \
                        FROM subcat sc JOIN tem_outra t \
                        ON sc.sub = t.super_categoria) \
                    SELECT sub FROM subcat"
            data = (cat,)
            cursor.execute(query,data)
            return render_template("tabela_sub_categorias.html", params=request.form)
        cursor.execute(query,data)
        return render_template("update.html", params=request.form)
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

@app.route('/retalhistas', methods=["POST", "GET"])
def menu_retalhistas():
    try:
        return render_template("menu_retalhistas.html", params=request.form)
    except Exception as e:
        return str(e)

@app.route('/retalhistas/update', methods=["POST", "GET"])
def update_retalhista():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        tin = request.form["TIN Retalhista"]
        if (request.form['action'] == "Inserir Retalhista"):
            query = "INSERT INTO retalhista (tin, nome)\
                    VALUES (%s,%s);\
                    INSERT INTO responsavel_por (nome_cat, tin, num_serie, fabricante)\
                    VALUES (%s,%s,%s,%s);"
            nome = request.form["Nome Retalhista"]
            cat = request.form["Categoria Retalhista"]
            num_serie = request.form["num_serie IVM Retalhista"]
            fabricante = request.form["fab IVM Retalhista"]
            data = (tin, nome, cat, tin, num_serie, fabricante)
        elif (request.form['action'] == "Remover Retalhista"):
            query = "DELETE FROM retalhista\
                        WHERE tin=%s;\
                        DELETE FROM responsavel_por\
                        WHERE tin=%s;"
            data = (tin,tin)
        cursor.execute(query,data)
        return render_template("update.html", params=request.form)
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

@app.route('/eventos', methods=["POST", "GET"])
def menu_eventos():
    try:
        return render_template("eventos.html", params=request.form)
    except Exception as e:
        return str(e)

@app.route('/eventos/listar', methods=["POST", "GET"])
def listar_eventos():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        num_serie = request.form["num_serie"]
        fabricante = request.form["fab"]
        query = "SELECT cat, SUM(unidades) AS unidades_repostas \
                 FROM evento_reposicao NATURAL JOIN produto \
                 WHERE num_serie=%s AND fabricante=%s\
                 GROUP BY cat ;"
        data = (num_serie,fabricante)
        cursor.execute(query, data)
        return render_template("eventos_listar.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


CGIHandler().run(app)
