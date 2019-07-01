--liquibase formatted sql

--changeset drsteini:create.nhdplus_navigation.flowline_rec
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_type where typname = 'flowline_rec'
create type nhdplus_navigation.flowline_rec as
(permanent_identifier			character varying(40)
,nhdplus_comid					integer
,reachcode						character varying(14)
,fmeasure						numeric
,tmeasure						numeric
,hydroseq						integer
,pathlength						numeric
,lengthkm						numeric
,length_measure_ratio			numeric
,pathtime						numeric
,travtime						numeric
,time_measure_ratio				numeric
,divergence						integer
,uphydroseq						integer
,uplevelpathid					integer
,dnhydroseq						integer
,dnlevelpathid					integer
,terminalpathid					integer
,levelpathid					integer
,nhdplus_region					character varying(3)
,nhdplus_version				character varying(6)
);
alter type nhdplus_navigation.flowline_rec owner to ${NHDPLUS_SCHEMA_OWNER_USERNAME};
--rollback drop type if exists nhdplus_navigation.flowline_rec;

--changeset drsteini:create.nhdplus_navigation.listdivs_rec
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_type where typname = 'listdivs_rec'
create type nhdplus_navigation.listdivs_rec as
(permanent_identifier			character varying(40)
,nhdplus_comid					integer
,fmeasure						numeric
,tmeasure						numeric
,hydroseq						integer
,pathlength						numeric
,pathtime						numeric
,lengthkm						numeric
,travtime						numeric
,terminalpathid					integer
,levelpathid					integer
,uphydroseq						integer
,divergence						integer
,done							integer
,nhdplus_region					character varying(3)
,nhdplus_version				character varying(6)
);
alter type nhdplus_navigation.listdivs_rec owner to ${NHDPLUS_SCHEMA_OWNER_USERNAME};
--rollback drop type if exists nhdplus_navigation.listdivs_rec;

--changeset drsteini:create.nhdplus_navigation.type_recdivs
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_type where typname = 'type_recdivs'
create type nhdplus_navigation.type_recdivs as
(permanent_identifier			character varying(40)
,nhdplus_comid					integer
,reachcode						character varying(14)
,hydroseq						integer
,pathlength						numeric
,terminalpathid					integer
,levelpathid					integer
,uphydroseq						integer
,uplevelpathid					integer
,dnhydroseq						integer
,dnlevelpathid					integer
,dnminorhyd						integer
,divergence						integer
,dndraincount					integer
,frommeas						numeric
,tomeas							numeric
,lengthkm						numeric
,travtime						numeric
,pathtime						numeric
,selected						integer
,from1							numeric
,to1							numeric
,totaldist						numeric
,totaltime						numeric
,nhdplus_region					character varying(3)
);
alter type nhdplus_navigation.type_recdivs owner to ${NHDPLUS_SCHEMA_OWNER_USERNAME};
--rollback drop type if exists nhdplus_navigation.type_recdivs;

--changeset drsteini:create.nhdplus_navigation.typ_rec_mega_divergences
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_type where typname = 'typ_rec_mega_divergences'
create type nhdplus_navigation.typ_rec_mega_divergences as
(fromcomid						integer
,comid							integer
,hydroseq						integer
);
alter type nhdplus_navigation.typ_rec_mega_divergences owner to ${NHDPLUS_SCHEMA_OWNER_USERNAME};
--rollback drop type if exists nhdplus_navigation.typ_rec_mega_divergences;

--changeset drsteini:create.nhdplus_navigation.typ_connections
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_type where typname = 'typ_connections'
create type nhdplus_navigation.typ_connections as
(upcomid						integer
,dncomid						integer
,upunitid						character varying(8)
,dnunitid						character varying(8)
);
alter type nhdplus_navigation.typ_connections owner to ${NHDPLUS_SCHEMA_OWNER_USERNAME};
--rollback drop type if exists nhdplus_navigation.typ_connections;
