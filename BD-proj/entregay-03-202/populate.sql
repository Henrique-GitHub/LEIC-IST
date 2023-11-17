---------------------------------------------------------
--  1.Base de Dados -------------------------------------
---------------------------------------------------------
drop table if exists responsavel_por;
drop table if exists evento_reposicao;
drop table if exists tem_outra;
drop table if exists tem_categoria;
drop table if exists instalada_em;
drop table if exists planograma;
drop table if exists ponto_de_retalho;
drop table if exists prateleira;
drop table if exists IVM;
drop table if exists retalhista;
drop table if exists produto;
drop table if exists categoria_simples;
drop table if exists super_categoria;
drop table if exists categoria;

-----------------------------------------------------
--  Criacao de tabelas  -----------------------------
-----------------------------------------------------

create table categoria(
    nome varchar(50) not null unique,
    constraint pk_categoria primary key(nome)
);

create table categoria_simples(
    nome varchar(50) not null unique,
    constraint pk_categoria_simples primary key(nome),
    constraint fk_categoria_simples foreign key(nome) references categoria(nome) ON DELETE CASCADE
);

create table super_categoria(
    nome varchar(50) not null unique,
    constraint pk_super_categoria primary key(nome),
    constraint fk_super_categoria foreign key(nome) references categoria(nome) ON DELETE CASCADE
);

create table tem_outra(
    super_categoria varchar(50) not null,
    categoria varchar(50) not null,
    constraint pk_tem_outra primary key(categoria),
    constraint fk_tem_outra_categoria foreign key(categoria) references categoria(nome) ON DELETE CASCADE,
    constraint fk_tem_outra_super_categoria foreign key(super_categoria) references super_categoria(nome) ON DELETE CASCADE
);

create table produto(
    ean char(13) not null unique,               
    cat varchar(50) not null,
    descr varchar(60) not null,
    constraint pk_produto primary key(ean),
    constraint fk_produto_categoria foreign key(cat) references categoria(nome) ON DELETE CASCADE
);

create table tem_categoria(
    ean char(13) not null,
    nome varchar(50) not null,
    constraint pk_tem_categoria primary key(ean, nome),
    constraint fk_tem_categoria_ean foreign key(ean) references produto(ean) ON DELETE CASCADE,
    constraint fk_tem_categoria_nome foreign key(nome) references categoria(nome) ON DELETE CASCADE
);

create table IVM(
    num_serie integer not null,
    fabricante varchar(50) not null,
    constraint pk_IVM primary key(num_serie, fabricante)       
);

create table ponto_de_retalho(
    nome varchar(50) not null unique,
    distrito varchar(30) not null,
    concelho varchar(30) not null,
    constraint pk_ponto_de_retalho primary key(nome)
);

create table instalada_em(
    num_serie integer not null,
    fabricante varchar(50) not null,
    localizacao varchar(50) not null,
    constraint pk_instalada_em primary key(num_serie, fabricante),
    constraint fk_instalada_em_IVM foreign key(num_serie, fabricante) references IVM(num_serie, fabricante) ON DELETE CASCADE,
    constraint fk_instalada_em_localizacao foreign key(localizacao) references ponto_de_retalho(nome) ON DELETE CASCADE
);

create table prateleira(
    nro integer not null,
    num_serie integer not null,
    fabricante varchar(50) not null,
    altura integer not null,
    nome varchar(50) not null,
    constraint pk_prateleira primary key(nro, num_serie, fabricante),
    constraint fk_prateleira_IVM foreign key(num_serie, fabricante) references IVM(num_serie, fabricante) ON DELETE CASCADE,
    constraint fk_prateleira_nome foreign key(nome) references categoria(nome) ON DELETE CASCADE
);

create table planograma(
    ean char(13) not null,
    nro integer not null,
    num_serie integer not null,
    fabricante varchar(50) not null,
    faces integer not null,
    max_unidades integer not null,
    loc varchar(40) not null,
    constraint pk_planograma primary key(ean, nro, num_serie, fabricante),
    constraint fk_planograma_ean foreign key(ean) references produto(ean) ON DELETE CASCADE,
    constraint fk_planograma_prateleira foreign key(nro, num_serie, fabricante) references prateleira(nro, num_serie, fabricante) ON DELETE CASCADE
);

create table retalhista(
    tin char(14) not null unique,
    nome varchar(50) not null unique,
    constraint pk_retalhista primary key(tin)
);

create table responsavel_por(
    nome_cat varchar(50) not null,
    tin char(14) not null,
    num_serie integer not null,
    fabricante varchar(50) not null,
    constraint pk_responsavel_por primary key(num_serie, fabricante),
    constraint fk_responsavel_por_IVM foreign key(num_serie, fabricante) references IVM(num_serie, fabricante) ON DELETE CASCADE,
    constraint fk_responsavel_por_tin foreign key(tin) references retalhista(tin) ON DELETE CASCADE,
    constraint fk_responsavel_por_nome_cat foreign key(nome_cat) references categoria(nome) ON DELETE CASCADE
);

create table evento_reposicao(
    ean char(13) not null,
    nro integer not null,
    num_serie integer not null,
    fabricante varchar(50) not null,
    instante timestamp not null,
    unidades integer not null,
    tin char(14) not null,
    constraint pk_evento_reposicao primary key(ean, nro, num_serie, fabricante, instante),
    constraint fk_evento_reposicao_planograma foreign key(ean, nro, num_serie, fabricante) references planograma(ean, nro, num_serie, fabricante) ON DELETE CASCADE,
    constraint fk_evento_reposicao_tin foreign key(tin) references retalhista(tin) ON DELETE CASCADE
);

----------------------------------------------------
--  Populacao   ------------------------------------
----------------------------------------------------

INSERT INTO categoria VALUES('Bebidas');        
INSERT INTO categoria VALUES('Bebidas com gas');    
INSERT INTO categoria VALUES('Bebidas alcoolicas');
INSERT INTO categoria VALUES('Sandes');
INSERT INTO categoria VALUES('Doces');                  

INSERT INTO categoria_simples VALUES('Bebidas com gas');    
INSERT INTO categoria_simples VALUES('Bebidas alcoolicas');
INSERT INTO categoria_simples VALUES('Sandes');
INSERT INTO categoria_simples VALUES('Doces');

INSERT INTO super_categoria VALUES('Bebidas');              

INSERT INTO tem_outra VALUES('Bebidas','Bebidas com gas');  
INSERT INTO tem_outra VALUES('Bebidas','Bebidas alcoolicas');

INSERT INTO produto VALUES('1234567890123', 'Bebidas alcoolicas', 'Cerveja');
INSERT INTO produto VALUES('1234567890124', 'Bebidas alcoolicas', 'Vinho');  
INSERT INTO produto VALUES('1234567890125', 'Bebidas com gas', 'Coca-Cola');
INSERT INTO produto VALUES('1234567890126', 'Bebidas com gas', 'Fanta');        
INSERT INTO produto VALUES('1234567890127', 'Sandes', 'Sandes de presunto');    
INSERT INTO produto VALUES('1234567890128', 'Sandes', 'Sandes de atum');
INSERT INTO produto VALUES('1234567890129', 'Sandes', 'Sandes mista');  
INSERT INTO produto VALUES('1234567890130', 'Doces', 'Gomas');      
INSERT INTO produto VALUES('1234567890131', 'Doces', 'Chocolate');      

INSERT INTO tem_categoria VALUES('1234567890123', 'Bebidas alcoolicas');
INSERT INTO tem_categoria VALUES('1234567890123', 'Bebidas com gas');
INSERT INTO tem_categoria VALUES('1234567890124', 'Bebidas alcoolicas');
INSERT INTO tem_categoria VALUES('1234567890125', 'Bebidas com gas');
INSERT INTO tem_categoria VALUES('1234567890126', 'Bebidas com gas');
INSERT INTO tem_categoria VALUES('1234567890127', 'Sandes');
INSERT INTO tem_categoria VALUES('1234567890128', 'Sandes');
INSERT INTO tem_categoria VALUES('1234567890129', 'Sandes');
INSERT INTO tem_categoria VALUES('1234567890130', 'Doces');
INSERT INTO tem_categoria VALUES('1234567890131', 'Doces');

INSERT INTO IVM VALUES(420691,'Google');
INSERT INTO IVM VALUES(420692,'IBM');
INSERT INTO IVM VALUES(420693,'Samsung');
INSERT INTO IVM VALUES(420694,'Apple');
INSERT INTO IVM VALUES(420695,'SMEG');
INSERT INTO IVM VALUES(420696,'Microsoft');
INSERT INTO IVM VALUES(420697,'Intel');
INSERT INTO IVM VALUES(420698,'Sony');
INSERT INTO IVM VALUES(420699,'Sony');

INSERT INTO ponto_de_retalho VALUES('IST-TagusPark', 'Lisboa', 'Oeiras');
INSERT INTO ponto_de_retalho VALUES('IST-Alameda', 'Lisboa', 'Lisboa');
INSERT INTO ponto_de_retalho VALUES('NOVA-SBE', 'Lisboa', 'Cascais');
INSERT INTO ponto_de_retalho VALUES('NOVA-FCT', 'Setubal', 'Almada');
INSERT INTO ponto_de_retalho VALUES('FCUL', 'Lisboa', 'Lisboa');
INSERT INTO ponto_de_retalho VALUES('FDUL', 'Lisboa', 'Lisboa');
INSERT INTO ponto_de_retalho VALUES('FFUL', 'Lisboa', 'Lisboa');
INSERT INTO ponto_de_retalho VALUES('ISA', 'Lisboa', 'Lisboa');

INSERT INTO instalada_em VALUES(420691,'Google','IST-TagusPark');
INSERT INTO instalada_em VALUES(420692,'IBM','IST-Alameda');
INSERT INTO instalada_em VALUES(420693,'Samsung','NOVA-SBE');
INSERT INTO instalada_em VALUES(420694,'Apple','NOVA-FCT');
INSERT INTO instalada_em VALUES(420695,'SMEG','FCUL');
INSERT INTO instalada_em VALUES(420696,'Microsoft','FDUL');
INSERT INTO instalada_em VALUES(420697,'Intel','FFUL');
INSERT INTO instalada_em VALUES(420698,'Sony','ISA');
INSERT INTO instalada_em VALUES(420699,'Sony','ISA');

INSERT INTO prateleira VALUES(1,420691,'Google',20,'Sandes');
INSERT INTO prateleira VALUES(2,420691,'Google',20,'Doces');            
INSERT INTO prateleira VALUES(3,420691,'Google',20,'Bebidas com gas');      
INSERT INTO prateleira VALUES(4,420691,'Google',20,'Bebidas alcoolicas');
INSERT INTO prateleira VALUES(1,420692,'IBM',20,'Sandes');
INSERT INTO prateleira VALUES(2,420692,'IBM',20,'Doces');           
INSERT INTO prateleira VALUES(3,420692,'IBM',20,'Bebidas com gas');     
INSERT INTO prateleira VALUES(4,420692,'IBM',20,'Bebidas alcoolicas');
INSERT INTO prateleira VALUES(1,420693,'Samsung',20,'Bebidas alcoolicas');
INSERT INTO prateleira VALUES(1,420694,'Apple',20,'Sandes');
INSERT INTO prateleira VALUES(1,420696,'Microsoft',20,'Bebidas alcoolicas');
INSERT INTO prateleira VALUES(1,420695,'SMEG',20,'Sandes');
INSERT INTO prateleira VALUES(1,420697,'Intel',20,'Bebidas com gas'); 
INSERT INTO prateleira VALUES(1,420698,'Sony',20,'Bebidas');
INSERT INTO prateleira VALUES(1,420699,'Sony',20,'Bebidas');  

INSERT INTO planograma VALUES('1234567890123',4,420691,'Google',2,10,'41');
INSERT INTO planograma VALUES('1234567890124',4,420691,'Google',2,10,'42');
INSERT INTO planograma VALUES('1234567890125',3,420691,'Google',2,10,'31');
INSERT INTO planograma VALUES('1234567890126',3,420691,'Google',2,10,'32');
INSERT INTO planograma VALUES('1234567890127',1,420691,'Google',1,5,'11');
INSERT INTO planograma VALUES('1234567890128',1,420691,'Google',1,5,'12');
INSERT INTO planograma VALUES('1234567890129',1,420691,'Google',2,10,'13');
INSERT INTO planograma VALUES('1234567890130',2,420691,'Google',2,10,'21');
INSERT INTO planograma VALUES('1234567890131',2,420691,'Google',2,10,'22');
INSERT INTO planograma VALUES('1234567890123',4,420692,'IBM',2,10,'41');
INSERT INTO planograma VALUES('1234567890124',4,420692,'IBM',2,10,'42');
INSERT INTO planograma VALUES('1234567890125',3,420692,'IBM',2,10,'31');
INSERT INTO planograma VALUES('1234567890126',3,420692,'IBM',2,10,'32');
INSERT INTO planograma VALUES('1234567890127',1,420692,'IBM',1,5,'11');
INSERT INTO planograma VALUES('1234567890128',1,420692,'IBM',1,5,'12');
INSERT INTO planograma VALUES('1234567890129',1,420692,'IBM',2,10,'13');
INSERT INTO planograma VALUES('1234567890130',2,420692,'IBM',2,10,'21');
INSERT INTO planograma VALUES('1234567890123',1,420693,'Samsung',4,20,'11');
INSERT INTO planograma VALUES('1234567890127',1,420694,'Apple',4,20,'11');
INSERT INTO planograma VALUES('1234567890128',1,420695,'SMEG',4,20,'11');
INSERT INTO planograma VALUES('1234567890124',1,420696,'Microsoft',4,20,'11');
INSERT INTO planograma VALUES('1234567890126',1,420697,'Intel',4,20,'11');
INSERT INTO planograma VALUES('1234567890123',1,420698,'Sony',4,20,'11');
INSERT INTO planograma VALUES('1234567890125',1,420699,'Sony',2,10,'11');
INSERT INTO planograma VALUES('1234567890124',1,420699,'Sony',2,10,'11');

INSERT INTO retalhista VALUES('00000000000001','Pepita');
INSERT INTO retalhista VALUES('00000000000002','Pepita Femea');
INSERT INTO retalhista VALUES('00000000000003','Non binary pepita');

INSERT INTO responsavel_por VALUES('Bebidas com gas','00000000000001',420691,'Google'); 
INSERT INTO responsavel_por VALUES('Bebidas alcoolicas','00000000000001',420693,'Samsung'); 
INSERT INTO responsavel_por VALUES('Sandes','00000000000001',420694,'Apple'); 
INSERT INTO responsavel_por VALUES('Doces','00000000000001',420692,'IBM');
INSERT INTO responsavel_por VALUES('Sandes','00000000000002',420695,'SMEG'); 
INSERT INTO responsavel_por VALUES('Bebidas alcoolicas','00000000000002',420696,'Microsoft'); 
INSERT INTO responsavel_por VALUES('Bebidas com gas','00000000000002',420697,'Intel');
INSERT INTO responsavel_por VALUES('Bebidas','00000000000002',420698,'Sony');
INSERT INTO responsavel_por VALUES('Bebidas','00000000000003',420699,'Sony');

INSERT INTO evento_reposicao VALUES('1234567890125',3,420691,'Google','2022-05-16',6,'00000000000001');
INSERT INTO evento_reposicao VALUES('1234567890130',2,420692,'IBM','2022-03-12',9,'00000000000001');
INSERT INTO evento_reposicao VALUES('1234567890125',1,420699,'Sony','2022-02-20',5,'00000000000002');
INSERT INTO evento_reposicao VALUES('1234567890124',4,420692,'IBM','2022-02-20',7,'00000000000003');
INSERT INTO evento_reposicao VALUES('1234567890123',4,420692,'IBM','2022-02-20',7,'00000000000003');
INSERT INTO evento_reposicao VALUES('1234567890124',1,420699,'Sony','2022-02-20',4,'00000000000003');






