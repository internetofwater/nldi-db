--liquibase formatted sql

--changeset drsteini:create.schema.nhdplus
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_namespace where nspname = 'nhdplus'
create schema nhdplus authorization nhdplus;
--rollback drop schema if exists nhdplus cascade;

--changeset drsteini:grant.usage.on.schema.nhdplus.to.nldi_data
grant usage on schema nhdplus to nldi_data;
--rollback revoke usage on schema nhdplus from nldi_data;

--changeset drsteini:grant.usage.on.schema.nhdplus.to.nldi_user
grant usage on schema nhdplus to nldi_user;
--rollback revoke usage on schema nhdplus from nldi_user;

--changeset drsteini:create_schema_nhdplus_navigation
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_namespace where nspname = 'nhdplus_navigation'
create schema nhdplus_navigation authorization nhdplus;
--rollback drop schema if exists nhdplus_navigation cascade;

--changeset drsteini:grant.usage.on.schema.nhdplus_navigation.to.nldi_user
grant usage on schema nhdplus_navigation to nldi_user;
--rollback revoke usage on schema nhdplus_navigation from nldi_user;

--changeset drsteini:create_schema_nldi_data
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_namespace where nspname = 'nldi_data'
create schema nldi_data authorization nldi_data;
--rollback drop schema if exists nldi_data cascade;

--changeset drsteini:grant.usage.on.schema.nldi_data.to.nldi_user
grant usage on schema nldi_data to nldi_user;
--rollback revoke usage on schema nldi_data from nldi_user;

--change set drsteini:grant.usage.on.schema.nldi_data.to.nldi_data
--grant usage on schema nldi_data to nldi_data;
--roll back revoke usage on schema nldi_data from nldi_data;

--changeset ayan:create_schema_characteristic_data
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_namespace where nspname = 'characteristic_data'
create schema characteristic_data authorization nldi_data;
--rollback drop schema if exists characteristic_data cascade;

--changeset drsteini:grant.usage.on.schema.characteristic_data.to.nldi_user
grant usage on schema characteristic_data to nldi_user;
--rollback revoke usage on schema characteristic_data from nldi_user;
