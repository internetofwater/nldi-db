--liquibase formatted sql

--changeset drsteini:create_schema_nhdplus
create schema nhdplus authorization nhdplus;
grant all on schema nhdplus to nhdplus;
grant usage on schema nhdplus to public;
--rollback drop schema if exists nhdplus cascade;

--changeset drsteini:create_schema_catchmentsp_np21_acu_topo
create schema catchmentsp_np21_acu_topo authorization nhdplus;
grant all on schema catchmentsp_np21_acu_topo to nhdplus;
grant usage on schema catchmentsp_np21_acu_topo to public;
--rollback drop schema if exists catchmentsp_np21_acu_topo cascade;

--changeset drsteini:create_schema_catchmentsp_np21_lpv_topo
create schema catchmentsp_np21_lpv_topo authorization nhdplus;
grant usage on schema catchmentsp_np21_lpv_topo to public;
revoke all on schema catchmentsp_np21_lpv_topo from nhdplus;
--rollback drop schema if exists catchmentsp_np21_lpv_topo cascade;

--changeset drsteini:create_schema_catchmentsp_np21_uhi_topo
create schema catchmentsp_np21_uhi_topo authorization nhdplus;
grant all on schema catchmentsp_np21_uhi_topo to nhdplus;
grant usage on schema catchmentsp_np21_uhi_topo to public;
--rollback drop schema if exists catchmentsp_np21_uhi_topo cascade;

--changeset drsteini:create_schema_nhdplus_navigation
create schema nhdplus_navigation authorization nhdplus_navigation;
grant all on schema nhdplus_navigation to nhdplus_navigation;
grant usage on schema nhdplus_navigation to public;
--rollback drop schema if exists nhdplus_navigation cascade;

--changeset drsteini:create_schema_nhdplus_indexing
create schema nhdplus_indexing authorization nhdplus_indexing;
grant all on schema nhdplus_indexing to nhdplus_indexing;
grant usage on schema nhdplus_indexing to public;
--rollback drop schema if exists nhdplus_indexing cascade;

--changeset drsteini:create_schema_nhdplus_delineation
create schema nhdplus_delineation authorization nhdplus_delineation;
grant all on schema nhdplus_delineation to nhdplus_delineation;
grant usage on schema nhdplus_delineation to public;
--rollback drop schema if exists nhdplus_delineation cascade;

--changeset drsteini:create_schema_nldi_data
create schema nldi_data authorization nldi_data;
grant all on schema nldi_data to nldi_data;
grant usage on schema nldi_data to public;
--rollback drop schema if exists nldi_data cascade;
