--liquibase formatted sql

--changeset drsteini:create_nhdplus_navigation.navigation_cache_status
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'nhdplus_navigation' and table_name = 'navigation_cache_status'
create unlogged table nhdplus_navigation.navigation_cache_status
(objectid						integer not null
,session_id						character varying(40) not null
,navigation_mode				character varying(2) not null
,start_comid					integer
,max_distance					integer
,stop_comid						integer
,return_code					integer
,status_message					character varying(255)
,session_datestamp				timestamp without time zone
,constraint navigation_cache_status_pk
  primary key (session_id)
);
alter table nhdplus_navigation.navigation_cache_status owner to ${NHDPLUS_SCHEMA_OWNER_USERNAME};
--rollback drop table nhdplus_navigation.navigation_cache_status;

--changeset drsteini:create_nhdplus_navigation.prep_connections_dd
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'nhdplus_navigation' and table_name = 'prep_connections_dd'
create table nhdplus_navigation.prep_connections_dd
(objectid						integer not null
,snapshot_date					date not null
,start_permanent_identifier		character varying(40) not null
,permanent_identifier			character varying(40) not null
,start_nhdplus_comid			integer not null
,nhdplus_comid					integer not null
,reachcode						character varying(14)
,fmeasure						numeric
,tmeasure						numeric
,hydroseq						integer
,levelpathid					integer
,terminalpathid					integer
,uphydroseq						integer
,dnhydroseq						integer
,pathlength						numeric
,lengthkm						numeric
,length_measure_ratio			numeric
,pathtime						numeric
,travtime						numeric
,time_measure_ratio				numeric
,nhdplus_region					character varying(3)
,nhdplus_version				character varying(6)
,reachsmdate					date
,ftype							numeric
,fcode							numeric
,gnis_id						character varying(10)
,wbarea_permanent_identifier	character varying(40)
,wbarea_nhdplus_comid			integer
,wbd_huc12						character varying(12)
,catchment_featureid			integer
,constraint prep_connections_dd_pk
  primary key (start_nhdplus_comid, nhdplus_comid)
,constraint prep_connections_dd_pk2
  unique (start_permanent_identifier, permanent_identifier)
);
alter table nhdplus_navigation.prep_connections_dd owner to ${NHDPLUS_SCHEMA_OWNER_USERNAME};
--rollback drop table nhdplus_navigation.prep_connections_dd;

--changeset drsteini:create_nhdplus_navigation.prep_connections_dm
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'nhdplus_navigation' and table_name = 'prep_connections_dm'
create table nhdplus_navigation.prep_connections_dm
(objectid						integer not null
,snapshot_date					date not null
,start_permanent_identifier		character varying(40) not null
,permanent_identifier			character varying(40) not null
,start_nhdplus_comid			integer not null
,nhdplus_comid					integer not null
,reachcode						character varying(14)
,fmeasure						numeric
,tmeasure						numeric
,hydroseq						integer
,levelpathid					integer
,terminalpathid					integer
,uphydroseq						integer
,dnhydroseq						integer
,pathlength						numeric
,lengthkm						numeric
,length_measure_ratio			numeric
,pathtime						numeric
,travtime						numeric
,time_measure_ratio				numeric
,nhdplus_region					character varying(3)
,nhdplus_version				character varying(6)
,reachsmdate					date
,ftype							numeric
,fcode							numeric
,gnis_id						character varying(10)
,wbarea_permanent_identifier	character varying(40)
,wbarea_nhdplus_comid			integer
,wbd_huc12						character varying(12)
,catchment_featureid			integer
,constraint prep_connections_dm_pk
  primary key (start_nhdplus_comid, nhdplus_comid)
,constraint prep_connections_dm_pk2
  unique (start_permanent_identifier, permanent_identifier)
);
alter table nhdplus_navigation.prep_connections_dm owner to ${NHDPLUS_SCHEMA_OWNER_USERNAME};
--rollback  drop table nhdplus_navigation.prep_connections_dm;

--changeset drsteini:create_nhdplus_navigation.prep_connections_um
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'nhdplus_navigation' and table_name = 'prep_connections_um'
create table nhdplus_navigation.prep_connections_um
(objectid						integer not null
,snapshot_date					date not null
,start_permanent_identifier		character varying(40) not null
,permanent_identifier			character varying(40) not null
,start_nhdplus_comid			integer not null
,nhdplus_comid					integer not null
,reachcode						character varying(14)
,fmeasure						numeric
,tmeasure						numeric
,hydroseq						integer
,levelpathid					integer
,terminalpathid					integer
,uphydroseq						integer
,dnhydroseq						integer
,pathlength						numeric
,lengthkm						numeric
,length_measure_ratio			numeric
,pathtime						numeric
,travtime						numeric
,time_measure_ratio				numeric
,nhdplus_region					character varying(3)
,nhdplus_version				character varying(6)
,reachsmdate					date
,ftype							numeric
,fcode							numeric
,gnis_id						character varying(10)
,wbarea_permanent_identifier	character varying(40)
,wbarea_nhdplus_comid			integer
,wbd_huc12						character varying(12)
,catchment_featureid			integer
,constraint prep_connections_um_pk
  primary key (start_nhdplus_comid, nhdplus_comid)
,constraint prep_connections_um_pk2
  unique (start_permanent_identifier, permanent_identifier)
);
alter table nhdplus_navigation.prep_connections_um owner to ${NHDPLUS_SCHEMA_OWNER_USERNAME};
--rollback drop table nhdplus_navigation.prep_connections_um;

--changeset drsteini:create_nhdplus_navigation.prep_connections_ut
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'nhdplus_navigation' and table_name = 'prep_connections_ut'
create table nhdplus_navigation.prep_connections_ut
(objectid						integer not null
,snapshot_date					date not null
,start_permanent_identifier		character varying(40) not null
,permanent_identifier			character varying(40) not null
,start_nhdplus_comid			integer not null
,nhdplus_comid					integer not null
,reachcode						character varying(14)
,fmeasure						numeric
,tmeasure						numeric
,hydroseq						integer
,levelpathid					integer
,terminalpathid					integer
,uphydroseq						integer
,dnhydroseq						integer
,pathlength						numeric
,lengthkm						numeric
,length_measure_ratio			numeric
,pathtime						numeric
,travtime						numeric
,time_measure_ratio				numeric
,nhdplus_region					character varying(3)
,nhdplus_version				character varying(6)
,reachsmdate					date
,ftype							numeric
,fcode							numeric
,gnis_id						character varying(10)
,wbarea_permanent_identifier	character varying(40)
,wbarea_nhdplus_comid			integer
,wbd_huc12						character varying(12)
,catchment_featureid			integer
,constraint prep_connections_ut_pk
  primary key (start_nhdplus_comid, nhdplus_comid)
,constraint prep_connections_ut_pk2
  unique (start_permanent_identifier, permanent_identifier)
);
alter table nhdplus_navigation.prep_connections_ut owner to ${NHDPLUS_SCHEMA_OWNER_USERNAME};
--rollback drop table nhdplus_navigation.prep_connections_ut;


--changeset drsteini:create_nhdplus_navigation.tmp_navigation_results
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'nhdplus_navigation' and table_name = 'tmp_navigation_results'
create unlogged table nhdplus_navigation.tmp_navigation_results
(objectid						integer not null
,session_id						character varying(40) not null
,start_permanent_identifier		character varying(40) not null
,permanent_identifier			character varying(40) not null
,start_nhdplus_comid			integer not null
,nhdplus_comid					integer not null
,reachcode						character varying(14) not null
,fmeasure						numeric not null
,tmeasure						numeric not null
,totaldist						numeric
,totaltime						numeric
,hydroseq						integer not null
,levelpathid					integer not null
,terminalpathid					integer not null
,uphydroseq						integer
,dnhydroseq						integer
,pathlength						numeric
,lengthkm						numeric not null
,length_measure_ratio			numeric
,pathtime						numeric
,travtime						numeric
,time_measure_ratio				numeric
,ofmeasure						numeric
,otmeasure						numeric
,nhdplus_region					character varying(3)
,nhdplus_version				character varying(6)
,reachsmdate					date
,ftype							numeric(3,0)
,fcode							numeric(5,0)
,gnis_id						character varying(10)
,wbarea_permanent_identifier	character varying(40)
,wbarea_nhdplus_comid			integer
,wbd_huc12						character varying(12)
,catchment_featureid			integer
,constraint tmp_navigation_results_pk
  primary key (session_id, nhdplus_comid)
,constraint tmp_navigation_results_pk2
  unique (session_id, permanent_identifier)
);
alter table nhdplus_navigation.tmp_navigation_results owner to ${NHDPLUS_SCHEMA_OWNER_USERNAME};
--rollback drop table nhdplus_navigation.tmp_navigation_results;
