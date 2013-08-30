
create database intact with encoding='UTF-8';

CREATE SEQUENCE interactions_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 604526
  CACHE 1;
ALTER TABLE interactions_id_seq OWNER TO <owner>;

CREATE TABLE interactions
(
  id integer NOT NULL DEFAULT nextval('interactions_id_seq'::regclass),
  uniprot1id character varying(32) NOT NULL,
  ebi1id character varying(32),
  interactor1alt character varying NOT NULL,
  interactor1alias character varying NOT NULL,
  interactor1_taxid character varying(512),
  uniprot2id character varying(32) NOT NULL,
  ebi2id character varying(32),
  interactor2alt character varying(8192) NOT NULL,
  interactor2alias character varying(8192) NOT NULL,
  interactor2_taxid character varying(512),
  interactionid character varying(8192) NOT NULL,
  conf_value real NOT NULL,
  detection_method character varying(8192),
  pubmed character varying(2048),
  interaction_type character varying(2048),
  CONSTRAINT interactions_pkey_0813 PRIMARY KEY (id)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE interactions OWNER TO <owner>;
COMMENT ON TABLE interactions082013 IS 'Whole Intact database (original psimitab format)';