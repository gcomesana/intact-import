CREATE DATABASE intact with encoding='UTF-8';

CREATE TABLE "public"."interactions" (
  "id" SERIAL NOT NULL, 
  "uniprot1id" VARCHAR(32) NOT NULL,
  "ebi1id" VARCHAR(32) not NULL,
  "interactor1alt" VARCHAR NOT NULL, 
  "interactor1alias" VARCHAR NOT NULL, 
  "interactor1_taxid" VARCHAR(512),
  "uniprot2id" VARCHAR(32) NOT NULL,
  "ebi2id" VARCHAR(32) not NULL,
  "interactor2alt" VARCHAR NOT NULL,
  "interactor2alias" VARCHAR NOT NULL, 
  "interactor2_taxid" VARCHAR(512),
  "interactionid" VARCHAR NOT NULL,
  "conf_value" REAL NOT NULL,
  "detection_method" VARCHAR(8192),
  "pubmed" VARCHAR(1024), 
  "interaction_type" VARCHAR(1024),
  PRIMARY KEY("id")
) WITH OIDS;