--liquibase formatted sql

--changeset drsteini:create_nhdplus_navigation.prep_connections_dd
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
alter table nhdplus_navigation.prep_connections_dd owner to nhdplus_navigation;
--rollback drop table nhdplus_navigation.prep_connections_dd;

--changeset drsteini:create_nhdplus_navigation.prep_connections_dm
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
alter table nhdplus_navigation.prep_connections_dm owner to nhdplus_navigation;
--rollback  drop table nhdplus_navigation.prep_connections_dm;

--changeset drsteini:create_nhdplus_navigation.prep_connections_um
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
alter table nhdplus_navigation.prep_connections_um owner to nhdplus_navigation;  
--rollback drop table nhdplus_navigation.prep_connections_um;

--changeset drsteini:create_nhdplus_navigation.prep_connections_ut
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
alter table nhdplus_navigation.prep_connections_ut owner to nhdplus_navigation;  
--rollback drop table nhdplus_navigation.prep_connections_ut;

--changeset drsteini:create_nhdplus_navigation.tmp_navigation_connections
create table nhdplus_navigation.tmp_navigation_connections
(start_permanent_identifier		varchar(40)
,permanent_identifier			varchar(40)
,start_nhdplus_comid			integer
,nhdplus_comid					integer
,reachcode						varchar(14)
,fmeasure						numeric
,tmeasure						numeric
,totaldist						numeric
,totaltime						numeric
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
,ofmeasure						numeric
,otmeasure						numeric
,nhdplus_region					varchar(3)
,nhdplus_version				varchar(6)
,reachsmdate					date
,ftype							integer
,fcode							integer
,gnis_id						varchar(10)
,wbarea_permanent_identifier	varchar(40)
,wbarea_nhdplus_comid			integer
,wbd_huc12						varchar(12)
,catchment_featureid			integer
);
--rollback drop table nhdplus_navigation.tmp_navigation_connections;
  
--changeset drsteini:create_nhdplus_navigation.tmp_navigation_connections_dd
create table nhdplus_navigation.tmp_navigation_connections_dd
(start_permanent_identifier		varchar(40)
,permanent_identifier			varchar(40)
,start_nhdplus_comid			integer
,nhdplus_comid					integer
,reachcode						varchar(14)
,fmeasure						numeric
,tmeasure						numeric
,totaldist						numeric
,totaltime						numeric
,hydroseq						integer
,levelpathid					integer
,terminalpathid			  		integer
,uphydroseq				  		integer
,dnhydroseq				  		integer
,pathlength				  		numeric
,lengthkm						numeric
,length_measure_ratio			numeric
,pathtime						numeric
,travtime						numeric
,time_measure_ratio			  	numeric
,ofmeasure						numeric
,otmeasure						numeric
,processed						numeric(11)
,nhdplus_region			  		varchar(3)
,nhdplus_version			 	varchar(6)
,reachsmdate				 	date
,ftype							numeric(3)
,fcode							numeric(5)
,gnis_id					 	varchar(10)
,wbarea_permanent_identifier 	varchar(40)
,wbarea_nhdplus_comid			integer
,wbd_huc12						varchar(12)
,catchment_featureid		 	integer
);
--rollback drop table nhdplus_navigation.tmp_navigation_connections_dd;

--changeset drsteini:create_nhdplus_navigation.tmp_navigation_results
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
alter table nhdplus_navigation.tmp_navigation_results owner to nhdplus_navigation;
--rollback drop table nhdplus_navigation.tmp_navigation_results;

--changeset drsteini:create_nhdplus_navigation.tmp_navigation_status
create unlogged table nhdplus_navigation.tmp_navigation_status
(objectid						integer not null
,session_id						character varying(40) not null
,return_code					integer
,status_message					character varying(255)
,session_datestamp				timestamp without time zone
,constraint tmp_navigation_status_pk
  primary key (session_id)
);
alter table nhdplus_navigation.tmp_navigation_status owner to nhdplus_navigation;
--rollback drop table nhdplus_navigation.tmp_navigation_status;
  
--changeset drsteini:create_nhdplus_navigation.tmp_navigation_uptrib
create table nhdplus_navigation.tmp_navigation_uptrib
(fromlevelpathid			 integer
,minhs						integer
);
--rollback drop table nhdplus_navigation.tmp_navigation_uptrib;

--changeset drsteini:create_nhdplus_navigation.tmp_navigation_working
create table nhdplus_navigation.tmp_navigation_working
(start_permanent_identifier		varchar(40)
,permanent_identifier			varchar(40)
,start_nhdplus_comid			integer
,nhdplus_comid					integer
,reachcode						varchar(14)
,fmeasure						numeric
,tmeasure						numeric
,totaldist						numeric
,totaltime						numeric
,hydroseq						integer
,levelpathid					integer
,terminalpathid					integer
,uphydroseq						integer
,uplevelpathid					integer
,dnhydroseq						integer
,dnlevelpathid					integer
,dnminorhyd						integer
,divergence						integer
,dndraincount					integer
,pathlength						numeric
,lengthkm						numeric
,length_measure_ratio			numeric
,pathtime						numeric
,travtime						numeric
,time_measure_ratio				numeric
,ofmeasure						numeric
,otmeasure						numeric
,selected						integer
,nhdplus_region					varchar(3)
,nhdplus_version				varchar(6)
,reachsmdate					date
);
--rollback drop table nhdplus_navigation.tmp_navigation_working;
