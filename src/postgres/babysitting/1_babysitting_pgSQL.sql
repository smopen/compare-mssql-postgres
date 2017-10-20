--Andrew Figueroa; CS299-03; Spring 2017
--
--1_babysitting_pgSQL.sql
--
--Final Paper Babysitting Schema (pgSQL) - 5/11/2017

--This schema describes a fictional babysitting co-op where members earn and use credits through babysitting each other’s children.

--The schema was originally implemented for Oracle, and has been ported to Postgres 9.6 while making the fewest changes possible.

CREATE TABLE Family(
	FID INTEGER PRIMARY KEY CHECK (FID > 0),
	FName VARCHAR(50) NOT NULL,
	FAddress VARCHAR(100) NOT NULL
);

CREATE TABLE Family_Member(
	FID INTEGER,
	Member VARCHAR(50),
	CONSTRAINT pk_Family_Member PRIMARY KEY (FID, Member),
	CONSTRAINT fk_PartOfFamily FOREIGN KEY (FID) 
	 REFERENCES Family(FID)
);

CREATE TABLE Child(
	FID INTEGER NOT NULL,
	CName VARCHAR(50) NOT NULL,
	CBirthdate DATE NOT NULL,
	CONSTRAINT pk_Child PRIMARY KEY (FID, CName),
	CONSTRAINT fk_ChildOfFamily FOREIGN KEY (FID)
	 REFERENCES Family(FID)
);

CREATE TABLE Sitting(
	SID INTEGER PRIMARY KEY CHECK (SID > 0),
	F_FID INTEGER NOT NULL,
	CName VARCHAR(50) NOT NULL,
	C_FID INTEGER NOT NULL,
	SDate DATE NOT NULL,
	SStart TIMESTAMP NOT NULL,
	SFinish TIMESTAMP NOT NULL,
	CONSTRAINT fk_SittingFamily FOREIGN KEY (F_FID)
	 REFERENCES Family(FID),
	CONSTRAINT fk_ChildSat FOREIGN KEY (C_FID, CName)
	 REFERENCES Child(FID, CName),
	CONSTRAINT Sitting_DiffFam CHECK (F_FID <> C_FID),
	CONSTRAINT Sitting_SeqTimes CHECK (SStart < SFinish)
);

CREATE VIEW Sitting_Comp AS (
  SELECT SID, F_FID, CName, C_FID SDate, SStart, SFinish,
    (SFinish - SStart) as SLength 
  FROM Sitting );
