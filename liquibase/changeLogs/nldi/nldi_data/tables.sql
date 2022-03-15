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
,feature_reach					character varying(500)
,feature_measure				character varying(500)
,ingest_type					character varying(5)
,feature_type					character varying(100)
,constraint crawler_source_pk
  primary key (crawler_source_id)
);
alter table nldi_data.crawler_source owner to ${NLDI_SCHEMA_OWNER_USERNAME};
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
,reachcode						character varying(14)
,measure						numeric(38,10)
);
alter table nldi_data.feature owner to ${NLDI_SCHEMA_OWNER_USERNAME};
--rollback drop table nldi_data.feature;

--changeset drsteini:create.nldi_data.feature_wqp
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'nldi_data' and table_name = 'feature_wqp'
create table nldi_data.feature_wqp ( ) inherits (nldi_data.feature);
alter table nldi_data.feature_wqp owner to ${NLDI_SCHEMA_OWNER_USERNAME};
--rollback drop table nldi_data.feature_wqp;

--changeset drsteini:create.nldi_data.feature_np21_nwis
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'nldi_data' and table_name = 'feature_np21_nwis'
create table nldi_data.feature_np21_nwis ( ) inherits (nldi_data.feature);
alter table nldi_data.feature_np21_nwis owner to ${NLDI_SCHEMA_OWNER_USERNAME};
--rollback drop table nldi_data.feature_np21_nwis;

--changeset drsteini:create.nldi_data.sqlinjection_test context:ci
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'nldi_data' and table_name = 'feature; select * from pg_class;'
create table nldi_data."feature; select * from pg_class;" ( ) inherits (nldi_data.feature);
alter table nldi_data."feature; select * from pg_class;"  owner to ${NLDI_SCHEMA_OWNER_USERNAME};
--rollback drop table nldi_data."feature; select * from pg_class;";

--changeset drsteini:create.nldi_data.feature_huc12pp
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'nldi_data' and table_name = 'feature_huc12pp'
create table nldi_data.feature_huc12pp ( ) inherits (nldi_data.feature);
alter table nldi_data.feature_huc12pp owner to ${NLDI_SCHEMA_OWNER_USERNAME};
--rollback drop table nldi_data.feature_huc12pp;

--changeset drsteini:create.nldi_data.web_service_log
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'nldi_data' and table_name = 'web_service_log'
create table nldi_data.web_service_log
(web_service_log_id				bigserial
,request_timestamp_utc			timestamp				not null default (now() at time zone 'UTC')
,request_completed_utc			timestamp
,referer						character varying(4000)
,user_agent						character varying(4000)
,request_uri					character varying(4000)
,query_string					character varying(4000)
,http_status_code				integer
);
alter table nldi_data.web_service_log owner to ${NLDI_SCHEMA_OWNER_USERNAME};
--rollback drop table nldi_data.web_service_log;

--changeset egrahn:drop.nldi_data.feature_wqp_temp
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:t select to_regclass('nldi_data.feature_wqp_temp') is not null
drop table nldi_data.feature_wqp_temp;

--changeset egrahn:drop.nldi_data.feature_np21_nwis_temp
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:t select to_regclass('nldi_data.feature_np21_nwis_temp') is not null
drop table nldi_data.feature_np21_nwis_temp;

--changeset egrahn:drop.nldi_data.sqlinjection_test_temp
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:t select to_regclass('nldi_data."feature; select * from pg_class;_temp"') is not null
drop table nldi_data."feature; select * from pg_class;_temp";

--changeset egrahn:drop.nldi_data.feature_huc12pp_temp
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:t select to_regclass('nldi_data.feature_huc12pp_temp') is not null
drop table nldi_data.feature_huc12pp_temp;
