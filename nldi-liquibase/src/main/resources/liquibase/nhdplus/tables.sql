--liquibase formatted sql

--changeset drsteini:create.nhdplus.megadiv_np21
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'nhdplus' and table_name = 'megadiv_np21'
create table nhdplus.megadiv_np21 
(objectid						integer not null
,fromcomid						integer not null
,tocomid						integer not null
,nhdplus_region					character varying(3) not null
,nhdplus_version				character varying(6) not null
);
alter table nhdplus.megadiv_np21 owner to nhdplus;
--rollback drop table nhdplus.megadiv_np21;

--changeset drsteini:create.nhdplus.nhdflowline_np21
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'nhdplus' and table_name = 'nhdflowline_np21'
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
alter table nhdplus.nhdflowline_np21 owner to nhdplus;
--rollback drop table nhdplus.nhdflowline_np21;

--changeset drsteini:create.nhdplus.nhdplusconnect_np21
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'nhdplus' and table_name = 'nhdplusconnect_np21'
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
alter table nhdplus.nhdplusconnect_np21 owner to nhdplus;
--rollback drop table nhdplus.nhdplusconnect_np21;

--changeset drsteini:create.nhdplus.plusflowlinevaa_np21
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'nhdplus' and table_name = 'plusflowlinevaa_np21'
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
alter table nhdplus.plusflowlinevaa_np21 owner to nhdplus;
--rollback drop table nhdplus.plusflowlinevaa_np21;

--changeset drsteini:create.nhdplus.plusflow_np21
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'nhdplus' and table_name = 'plusflow_np21'
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
alter table nhdplus.plusflow_np21 owner to nhdplus;
--rollback drop table nhdplus.plusflow_np21;

--changeset drsteini:create.nhdplus.catchmentsp
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'nhdplus' and table_name = 'catchmentsp'
create table nhdplus.catchmentsp
(ogc_fid						serial not null
,the_geom						geometry(MultiPolygon,4269)
,gridcode						integer
,featureid						integer
,sourcefc						character varying
,areasqkm						double precision
,shape_length					double precision
,shape_area						double precision
,constraint catchmentsp_pkey
  primary key (ogc_fid)
);
alter table nhdplus.catchmentsp owner to nhdplus;
--rollback drop table nhdplus.catchmentsp;
