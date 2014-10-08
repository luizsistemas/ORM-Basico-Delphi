/******************************************************************************/

SET SQL DIALECT 3;

SET NAMES NONE;

CREATE DATABASE 'F:\Programas\ProgsXe\Persistencia\Teste\Bd\BANCOTESTE.FDB'
USER 'SYSDBA' PASSWORD '02025626'
PAGE_SIZE 16384
DEFAULT CHARACTER SET NONE;



/******************************************************************************/
/****                                Tables                                ****/
/******************************************************************************/



CREATE TABLE CIDADE (
    ID       INTEGER NOT NULL,
    NOME     VARCHAR(60),
    UF       CHAR(2),
    IBGE     INTEGER,
    DATACAD  DATE
);

CREATE TABLE CLIENTE (
    ID        INTEGER NOT NULL,
    NOME      VARCHAR(100),
    CIDADEID  INTEGER
);



/******************************************************************************/
/****                             Primary Keys                             ****/
/******************************************************************************/

ALTER TABLE CIDADE ADD CONSTRAINT PK_CIDADE PRIMARY KEY (ID);
ALTER TABLE CLIENTE ADD CONSTRAINT PK_CLIENTE PRIMARY KEY (ID);


/******************************************************************************/
/****                             Foreign Keys                             ****/
/******************************************************************************/

ALTER TABLE CLIENTE ADD CONSTRAINT FK_CLIENTE_1 FOREIGN KEY (CIDADEID) REFERENCES CIDADE (ID);
