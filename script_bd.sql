--BANCO DE DADOS DE UM HOTEL

--CRIAR TABELAS
create table categoria(
cod_cat int not null primary key,
nome varchar(50) not null,
descr varchar(100) not null,
valor_dia float not null);

create table apto(
num int not null primary key,
status varchar(1) not null check(status='D' or status='O'),
cod_cat int not null references categoria(cod_cat));

create table funcionario(
cod_func int not null primary key,
dt_nasc date not null,
nome varchar(100) not null);

create table hospede(
cod_hosp int not null primary key,
dt_nasc date not null,
nome varchar(100) not null);

create table hospedagem(
cod_hospeda int not null primary key,
num int not null references apto(num),
cod_func int not null references funcionario(cod_func),
cod_hosp int not null references hospede(cod_hosp),
valor_total float not null,
dt_ent date not null,
dt_sai date not null);

--INSERIR VALORES
insert into categoria values(1,'simples','sim',300);
insert into categoria values(2,'complexo','não',450);
insert into categoria values(3,'wow','talvez',600);

insert into apto values(101,'D',1);
insert into apto values(102,'D',2);
insert into apto values(201,'O',3);

insert into funcionario values(1,'2010-09-14','Hidrogênio');
insert into funcionario values(2,'2009-07-12','Oxigênio');
insert into funcionario values(3,'2010-03-08','Boro');
insert into funcionario values(4,'2010-02-05','Cobre');

insert into hospede values(1,'2010-04-03','Computador');

insert into hospedagem values(1,201,3,1,1200,'2020-10-12','2020-10-14');

--SINTAXE INSERT:
--INSERT INTO tabela(s) VALUES(valor1,valor2,...);

--SINTAXE SELECT:
--SELECT atributo(s) FROM tabela(s) WHERE condição(ões);

--QUESTÃO (03/03/2026)
--A) O NOME DOS FUNCIONÁRIOS DE CÓDIGO 1 ou 3:
select nome from funcionario where cod_func=1 or cod_func=3;

--B) O CÓDIGO E O NOME DAS CATEGORIAS QUE CUSTAM MAIS DE R$400,00 A DIÁRIA:
select cod_cat,nome from categoria where valor_dia>400;

--C) O NÚMERO DOS APARTAMENTOS DA CATETGORIA DE CÓDIGO 1, 2 ou 3:
--FORMA 1(usando 'in'):
select num from apto where cod_cat in (1,2,3);
--FORMA 2(usando 'between'):
select num from apto where cod_cat between 1 and 3;

--D) O CÓDIGO DAS HOSPEDAGENS REALIZADAS PARA O HÓSPEDE DE CÓDIGO 1 NO APARTAMENTO 101:
select cod_hospeda from hospedagem where cod_hosp=1 and num=101;

--E) TODAS AS INFORMAÇÕES DOS FUNCIONÁRIOS QUE NASCERAM NO ANO DE 2010:
--FORMA 1(intervalo):
select * from funcionario where dt_nasc>='2010-01-01' and dt_nasc<'2011-01-01';
--FORMA 2(usando 'between'):
select * from funcionario where dt_nasc between '2010-01-01' and '2010-12-31';
--FORMA 3(usando 'extract'):
select * from funcionario where extract(year from dt_nasc) = 2010;

--QUESTÃO (10/03/2026)
--A) DATA DA PRIMEIRA HOSPEDAGEM DO HOTEL:
select min(dt_ent) from hospedagem;

--B) DATA DE NASCIMENTO DO HÓSPEDE MAIS VELHO:
select min(dt_nasc) from hospede;

--C) DATA DE NASCIMENTO DO HÓSPEDE MAIS NOVO:
select max(dt_nasc) from hospede;

--D) MÉDIA DOS VALORES DAS DIÁRIAS DE TODAS AS CATEGORIAS:
select avg(valor_dia) from categoria;

--E) MAIOR CÓDIGO DOS HÓSPEDES QUE NASCERAM EM 2010:
select max(cod_hosp) from hospede where extract(year from dt_nasc) = 2010;

--F) MENOR NÚMERO DOS APARTAMENTOS DE CATEGORIA 1:
select min(num) from apto where cod_cat = 1;

--G) NOME DO HÓSPEDE MAIS VELHO:
select nome from hospede where dt_nasc = (select min(dt_nasc) from hospedagem);

--H) CÓDIGO DO HOSPEDE E CÓDIGO DO FUNCIONÁRIO DA HOSPEDAGEM MAIS RECENTE:
select cod_hosp,cod_func from hospedagem where dt_ent = (select max(dt_ent) from hospedagem);

--I) NOME DA CATEGORIA DE MAIOR VALOR DA DIÁRIA:
select nome from categoria where valor_dia = (select max(valor_dia) from categoria);

--J) NOME DA CATEGORIA QUE O VALOR DA DIÁRIA É MAIOR QUE A MÉDIA DOS VALORES DA DIÁRIA DE TODAS AS CATEGORIAS:
select nome from categoria where valor_dia > (select avg(valor_dia) from categoria);

--EXEMPLOS: SUB-QUERY(sub-pesquisa) (17/03/2026)
--1. NÚMERO DOS APARTAMENTOS DA CATEGORIA DE NOME LUXO:
select num from apto where cod_cat in (select cod_cat from categoria where nome = 'wow');

--2. NOME DOS HÓSPEDES QUE SE HOSPEDARAM NO ANO DE 2020:
select nome from hospede where cod_hosp in (select cod_hosp from hospedagem where extract(year from dt_ent) = 2020);

--3. NOME DOS FUNCIONÁRIOS QUE ATENDERAM O HÓSPEDE DE CÓDIGO 1:
select nome from funcionario where cod_func in (select cod_func from hospedagem where cod_hosp = 1);

--4. NOME DOS HÓSPEDES QUE FORAM ATENDIDOS PELO FUNCIONÁRIO DE NOME JOÃO:
select nome from hospede where cod_hosp in (select cod_hosp from hospedagem where cod_func in (select cod_func from funcionario where nome = 'João'));

--5. OBTER O NOME DOS HÓSPEDES QUE SE HOSPEDARAM EM APARTAMENTOS DA CATEGORIA DE CÓDIGO 1:
select nome from hospede where cod_hosp in (select cod_hosp from hospedagem where num in (select num from apto where cod_cat = 1));

--6. NOME DAS CATEGORIAS DOS APARTAMENTOS OCUPADOS PELOS HÓSPEDES QUE NASCERAM NO MÊS DE SETEMBRO:
select nome from categoria where cod_cat in (select cod_cat from apto where num in (select num from hospedagem where cod_hosp in (select cod_hosp from hospede where extract (month from dt_nasc) = 09)));

--7. CÓDIGO DAS HOSPEDAGENS REALIZADAS PARA O HÓSPEDE DE CÓDIGO 1 OU PELO FUNCIONÁRIO DE NOME JOÃO
select cod_hospeda from hospedagem where cod_hosp = 1 or cod_func in (select cod_func from funcionario where nome = 'João');
