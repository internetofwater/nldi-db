--liquibase formatted sql

--changeset drsteini:create.nldi_data.crawler_source
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'nldi_data' and table_name = 'crawler_source'
create table nldi_data.crawler_source
(crawler_source_id				integer not null
,source_name					character varying(500) not null
,source_suffix					character varying(10) not null
,source_uri						character varying(256) not null
,feature_id						character varying(500) not null
,feature_name					character varying(500) not null
,feature_uri					character varying(256) not null
,constraint crawler_source_pk
  primary key (crawler_source_id)
);
--rollback drop table nldi_data.crawler_source;

--changeset drsteini:create.nldi_data.feature
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'nldi_data' and table_name = 'feature'
create table nldi_data.feature
(crawler_source_id				integer not null
,identifier						character varying(500)
,name							character varying(500)
,uri							character varying(256)
,location						geometry(point,4269)
,comid							integer
);
--rollback drop table nldi_data.feature;

--changeset drsteini:create.nldi_data.feature_wqp
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'nldi_data' and table_name = 'feature_wqp'
create table nldi_data.feature_wqp ( ) inherits (nldi_data.feature);
--rollback drop table nldi_data.feature_wqp;

--changeset drsteini:create.nldi_data.feature_wqp_temp
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'nldi_data' and table_name = 'feature_wqp_temp'
create table nldi_data.feature_wqp_temp
(crawler_source_id				integer not null
,identifier						character varying(500)
,name							character varying(500)
,uri							character varying(256)
,location						geometry(point,4269)
,comid							integer
);
--rollback drop table nldi_data.feature_wqp_temp;

--changeset drsteini:create.nldi_data.feature.reachcode
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.columns where table_schema = 'nldi_data' and table_name = 'feature' and column_name = 'reachcode'
alter table nldi_data.feature add reachcode character varying(14);
--rollback alter table nldi_data.feature drop reachcode;

--changeset drsteini:create.nldi_data.feature.measure
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.columns where table_schema = 'nldi_data' and table_name = 'feature' and column_name = 'measure'
alter table nldi_data.feature add measure numeric(38,10);
--rollback alter table nldi_data.feature drop measure;

--changeset drsteini:create.nldi_data.feature_wqp_temp.reachcode
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.columns where table_schema = 'nldi_data' and table_name = 'feature_wqp_temp' and column_name = 'reachcode'
alter table nldi_data.feature_wqp_temp add reachcode character varying(14);
--rollback alter table nldi_data.feature_wqp_temp drop reachcode;

--changeset drsteini:create.nldi_data.feature_wqp_temp.measure
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.columns where table_schema = 'nldi_data' and table_name = 'feature_wqp_temp' and column_name = 'measure'
alter table nldi_data.feature_wqp_temp add measure numeric(38,10);
--rollback alter table nldi_data.feature_wqp_temp drop measure;

--changeset drsteini:create.nldi_data.crawler_source.feature_reach
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.columns where table_schema = 'nldi_data' and table_name = 'crawler_source' and column_name = 'feature_reach'
alter table nldi_data.crawler_source add feature_reach character varying(500);
--rollback alter table nldi_data.crawler_source drop feature_reach;

--changeset drsteini:create.nldi_data.feature.feature_measure
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.columns where table_schema = 'nldi_data' and table_name = 'crawler_source' and column_name = 'feature_measure'
alter table nldi_data.crawler_source add feature_measure character varying(500);
--rollback alter table nldi_data.crawler_source drop feature_measure;

--changeset drsteini:create.nldi_data.feature.ingest_type
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.columns where table_schema = 'nldi_data' and table_name = 'crawler_source' and column_name = 'ingest_type'
alter table nldi_data.crawler_source add ingest_type character varying(5);
--rollback alter table nldi_data.crawler_source drop ingest_type;

--changeset drsteini:create.nldi_data.feature_nwis
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'nldi_data' and table_name = 'feature_nwis'
create table nldi_data.feature_nwis ( ) inherits (nldi_data.feature);
--rollback drop table nldi_data.feature_nwis;

--changeset drsteini:create.nldi_data.sqlinjection_test
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'nldi_data' and table_name = 'feature; select * from pg_class;'
create table nldi_data."feature; select * from pg_class;" ( ) inherits (nldi_data.feature);
--rollback drop table nldi_data."feature; select * from pg_class;";


--changeset drsteini:create.nldi_data.sqlinjection_test_temp
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'nldi_data' and table_name = 'feature; select * from pg_class;_temp'
create table nldi_data."feature; select * from pg_class;_temp" (like nldi_data.feature);
--rollback drop table nldi_data."feature; select * from pg_class;_temp";

