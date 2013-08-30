IntAct Importer
======================================================
The purpose of this script is just to import the entire contents of IntAct database (http://www.ebi.ac.uk/intact) from a MITAB25 format file into a postgresql database. As by October 2012, the IntAct database in MITAB25 format can be downloaded from ftp://ftp.ebi.ac.uk/pub/databases/intact/current/psimitab/intact.zip.

# Requirements
- ruby 1.9.2 or later (supposedly)
- dbi gem ([sudo] gem install dbi)
- postgres driver ([sudo] gem install pg)
- postgresql 9.x on a reachable server

The pg gem can raise complaints specially with pg_config file and libpq file. We run into the latter, and it was solved by providing the path to the postgres lib directory (click-by-click instalation on Mac OSX 10.6.8)
	
	$ sudo gem install pg -- --with-pg-config=/Library/PostgreSQL/9.0/bin/pg_config \
		-- --with-pg-lib=/Library/PostgreSQL/9.0/lib/

Keep in mind the '--' are absolutely necessary, otherwise gem will raise a confusing error message.

# Overview
Just reads the MITAB2.5 file line per line, selecting the following fields:
- interactor A id
- interactor A alternative id
- interactor A aliases
- interactor A tax id
- interactor B id
- interactor B alternative id
- interactor B aliases
- interactor B tax id
- interaction id
- interaction confidence value
- interaction type
- interaction detection method
- interaction pubmed reference

Then, a simple insert into the database will store the data. Nothing remarkable else to be done.

# Usage
From command line: 
	
	$ ruby intact-importer.rb -f <filename> -s <server> -p <port> -d <dbname> -u <dbuser> -pw <password>

<filename> has to be a reachable file path, either relative or absolute.
All parameters are necessary.

The database has to be created on the database <server> with right permissions to perform insert operations.
The database name is arbitrary and specified by -d <dbname> param, but the only table in the database has to be named as 'interactions'. The table has to have the same fields as above plus and autoincrement id field as primary key to provide an internal database identifier as primary key.

A small SQL is provided to create database and table if necessary. Both DDL statements have to be executed separately.
