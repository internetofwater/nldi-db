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

--changeset drsteini:create.nhdplus.megadiv_np21
create table nhdplus.megadiv_np21 
(objectid						integer not null
,fromcomid						integer not null
,tocomid						integer not null
,nhdplus_region					character varying(3) not null
,nhdplus_version				character varying(6) not null
);
--rollback drop table nhdplus.megadiv_np21;

--changeset drsteini:create.nhdplus.nhdflowline_np21
create table nhdplus.nhdflowline_np21 
(objectid						integer not null
,permanent_identifier			character varying(40) not null
,nhdplus_comid					integer not null
,fdate							timestamp without time zone not null
,resolution						numeric(38,10) not null
,gnis_id						character varying(10)
,gnis_name						character varying(65)
,lengthkm						numeric(38,11) not null
,reachcode						character varying(14) not null
,flowdir						integer not null
,wbarea_permanent_identifier	character varying(40)
,wbarea_nhdplus_comid			integer
,ftype							integer not null
,fcode							integer not null
,reachsmdate					timestamp without time zone not null
,fmeasure						numeric(38,10) not null
,tmeasure						numeric(38,10) not null
,wbarea_ftype					integer
,wbarea_fcode					integer
,wbd_huc12						character varying(12) not null
,wbd_huc12_percent				numeric(38,10)
,catchment_featureid			integer
,nhdplus_region					character varying(3) not null
,nhdplus_version				character varying(6) not null
,navigable						character varying(1) not null
,streamlevel					smallint
,streamorder					smallint
,hydroseq						integer
,levelpathid					integer
,terminalpathid					integer
,uphydroseq						integer
,dnhydroseq						integer
,closed_loop					character varying(1)
,gdb_geomattr_data				bytea
,shape							public.geometry(linestringm,4269)
,constraint enforce_srid_shape
  check ((public.st_srid(shape) = 4269))
);
--rollback drop table nhdplus.nhdflowline_np21;

--changeset drsteini:create.nhdplus.nhdplusconnect_np21
create table nhdplus.nhdplusconnect_np21 
(objectid						integer not null
,drainageid						character varying(2)
,upunitid						character varying(8) not null
,upunittype						character varying(5) not null
,dnunitid						character varying(8) not null
,dnunittype						character varying(5) not null
,upcomid						integer not null
,dncomid						integer not null
,uphydroseq						integer not null
,dnhydroseq						integer not null
,upmainhydroseq					integer
,dnmainhydroseq					integer
);
--rollback drop table nhdplus.nhdplusconnect_np21;

--changeset drsteini:create.nhdplus.plusflowlinevaa_np21
create table nhdplus.plusflowlinevaa_np21 
(objectid						integer not null
,comid							integer not null
,fdate							timestamp without time zone not null
,streamlevel					smallint not null
,streamorder					smallint not null
,streamcalculator				smallint
,fromnode						numeric(11,0) not null
,tonode							numeric(11,0) not null
,hydroseq						numeric(11,0) not null
,levelpathid					numeric(11,0) not null
,pathlength						numeric(38,10) not null
,terminalpathid					numeric(11,0) not null
,arbolatesum					numeric(38,10)
,divergence						smallint
,startflag						smallint
,terminalflag					smallint
,dnlevel						smallint
,thinnercode					smallint
,uplevelpathid					numeric(11,0) not null
,uphydroseq						numeric(11,0) not null
,dnlevelpathid					numeric(11,0) not null
,dnminorhyd						numeric(11,0) not null
,dndraincount					smallint not null
,dnhydroseq						numeric(11,0) not null
,frommeas						numeric(38,10) not null
,tomeas							numeric(38,10) not null
,reachcode						character varying(14) not null
,lengthkm						numeric(38,10) not null
,fcode							integer
,rtndiv							smallint
,outdiv							smallint
,diveffect						smallint
,vpuin							smallint
,vpuout							smallint
,travtime						numeric(38,10) not null
,pathtime						numeric(38,10) not null
,areasqkm						numeric(38,10)
,totdasqkm						numeric(38,10)
,divdasqkm						numeric(38,10)
,nhdplus_region					character varying(3) not null
,nhdplus_version				character varying(6) not null
,permanent_identifier			character varying(40) not null
,reachsmdate					timestamp without time zone not null
,fmeasure						numeric(38,10) not null
,tmeasure						numeric(38,10) not null
);
--rollback drop table nhdplus.plusflowlinevaa_np21;

--changeset drsteini:create.nhdplus.plusflow_np21
create table nhdplus.plusflow_np21 
(objectid						integer not null
,fromcomid						integer not null
,fromhydroseq					numeric(11,0) not null
,fromlevelpathid				numeric(11,0) not null
,tocomid						integer not null
,tohydroseq						numeric(11,0) not null
,tolevelpathid					numeric(11,0) not null
,nodenumber						numeric(11,0) not null
,deltalevel						smallint not null
,direction						smallint not null
,gapdistkm						numeric(38,10) not null
,hasgeo							character varying(1) not null
,totdasqkm						numeric(38,10) not null
,divdasqkm						numeric(38,10) not null
,nhdplus_region					character varying(3) not null
,nhdplus_version				character varying(6) not null
);
--rollback drop table nhdplus.plusflow_np21;

--changeset drsteini:create.nldi_data.crawler
create table nldi_data.crawler
(nldi_crawler_id				integer not null
,source_name					character varying(500) not null
,source_uri						character varying(256) not null
,feature_id						character varying(500) not null
,feature_name					character varying(500) not null
,feature_uri_prefix				character varying(256) not null
,constraint crawler_pk
  primary key (nldi_crawler_id)
);
--rollback drop table nldi_data.crawler;
