--liquibase formatted sql

--changeset ayan:create.characteristic_data.characteristic_metadata
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'characteristic_data' and table_name = 'characteristic_metadata'
create table characteristic_data.characteristic_metadata
(characteristic_id              character varying(500) not null
,characteristic_description     character varying(4000)
,units                          character varying(4000)
,dataset_label                  character varying(4000)
,dataset_url                    character varying(4000)
,theme_label                    character varying(4000)
,theme_url                      character varying(4000)
,characteristic_type            character varying(4000)
,constraint characteristic_metadata_pk
    primary key (characteristic_id)
);
alter table characteristic_data.characteristic_metadata owner to nldi_data;
--rollback drop table characteristic_data.characteristic_metadata


--changeset ayan:create.characteristic_data.divergence_routed_characteristics
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'characteristic_data' and table_name = 'divergence_routed_characteristics'
create table characteristic_data.divergence_routed_characteristics
(comid                          integer not null
,characteristic_id              character varying(4000)
,characteristic_value           numeric(20, 10)
,percent_nodata                 smallint
,constraint divergence_routed_characteristics_pk
    primary key (comid, characteristic_id)
);
alter table characteristic_data.divergence_routed_characteristics owner to nldi_data;
--rollback drop table characteristic_data.divergence_routed_characteristics


--changeset ayan:create.characteristic_data.total_accumulated_characteristics
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'characteristic_data' and table_name = 'total_accumulated_characteristics'
create table characteristic_data.total_accumulated_characteristics
(comid                          integer not null
,characteristic_id              character varying(4000)
,characteristic_value           numeric(20, 10)
,percent_nodata                 smallint
,constraint total_accumulated_characteristics_pk
    primary key (comid, characteristic_id)
);
alter table characteristic_data.total_accumulated_characteristics owner to nldi_data;
--rollback drop table characteristic_data.total_accumulated_characteristics


--changeset ayan:create.characteristic_data.local_catchment_characteristics
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'characteristic_data' and table_name = 'local_catchment_characteristics'
create table characteristic_data.local_catchment_characteristics
(comid                          integer not null
,characteristic_id              character varying(4000)
,characteristic_value           numeric(20, 10)
,percent_nodata                 smallint
,constraint local_catchment_characteristics_pk
    primary key (comid, characteristic_id)
);
alter table characteristic_data.local_catchment_characteristics owner to nldi_data;
--rollback drop table characteristic_data.local_catchment_characteristics


--changeset drsteini:create.characteristic_data.plusflowlinevaa_np21
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'characteristic_data' and table_name = 'plusflowlinevaa_np21'
create table characteristic_data.plusflowlinevaa_np21
(comid                          integer not null
,hydroseq                       numeric(11,0) not null
,startflag                      smallint
,dnhydroseq                     numeric(11,0) not null
,dnminorhyd                     numeric(11,0) not null
,pathlength                     numeric(11,0)
);
alter table characteristic_data.plusflowlinevaa_np21 owner to nldi_data;
--rollback drop table characteristic_data.plusflowlinevaa_np21


--changeset drsteini:create.characteristic_data.catchmentsp
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from information_schema.tables where table_schema = 'characteristic_data' and table_name = 'catchmentsp'
create table characteristic_data.catchmentsp
(ogc_fid	integer not null
,featureid	integer
,the_geom	geometry(MultiPolygon,4269)
);
alter table characteristic_data.catchmentsp owner to nldi_data;
--rollback drop table characteristic_data.catchmentsp


--changeset mbucknell:alter.characteristc_data.characteristic_metadata.constraint
--preconditions onFail:Mark_RAN onError:HALT
alter table characteristic_data.characteristic_metadata rename constraint characteristic_metadata_pk to characteristic_metadata_pkey;
--rollback alter table characteristic_data.characteristic_metadata rename constraint characteristic_metadata_pkey to characteristic_metadata_pk


--changeset mbucknell:alter.characteristc_data.local_catchment_characteristics.constraint
--preconditions onFail:Mark_RAN onError:HALT
alter table characteristic_data.local_catchment_characteristics rename constraint local_catchment_characteristics_pk to local_catchment_characteristics_pkey;
--rollback alter table characteristic_data.local_catchment_characteristics rename constraint local_catchment_characteristics_pkey to local_catchment_characteristics_pk


--changeset mbucknell:alter.characteristc_data.divergence_routed_characteristics.constraint
--preconditions onFail:Mark_RAN onError:HALT
alter table characteristic_data.divergence_routed_characteristics rename constraint divergence_routed_characteristics_pk to divergence_routed_characteristics_pkey;
--rollback alter table characteristic_data.divergence_routed_characteristics rename constraint divergence_routed_characteristics_pkey to divergence_routed_characteristics_pk


--changeset mbucknell:alter.characteristc_data.total_accumulated_characteristics.constraint
--preconditions onFail:Mark_RAN onError:HALT
alter table characteristic_data.total_accumulated_characteristics rename constraint total_accumulated_characteristics_pk to total_accumulated_characteristics_pkey;
--rollback alter table characteristic_data.total_accumulated_characteristics rename constraint total_accumulated_characteristics_pkey to total_accumulated_characteristics_pk