--liquibase formatted sql

--changeset ayan:create.role.nldi_data
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_roles where rolname = 'nldi'
create role nldi;
-- rollback drop role if exists nldi;

--changeset ayan:grant.nldi.to.postgres
grant nldi to postgres
--rollback revoke nldi from postgres;

--changeset drsteini:create.role.nhdplus
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_roles where rolname = 'nhdplus'
create role nhdplus;
--rollback drop role if exists nhdplus;

--changeset drsteini:grant.nhdplus.to.postgres
grant nhdplus to postgres;
--rollback revoke nhdplus from postgres;

--changeset drsteini:grant.nhdplus.to.nldi
grant nhdplus to nldi;
--rollback revoke nhdplus from nldi;

--changeset drsteini:create.role.nldi_data
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_roles where rolname = 'nldi_data'
create role nldi_data with login password '${NLDI_DATA_PASSWORD}';
--rollback drop role if exists nldi_data;

--changeset drsteini:grant.nldi_data.to.postgres
grant nldi_data to postgres;
--rollback revoke nldi_data from postgres;

--changeset drsteini:grant.nldi_data.to.nldi
grant nldi_data to nldi;
--rollback revoke nldi_data from nldi;

--changeset drsteini:create.role.nldi_user
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_roles where rolname = 'nldi_user'
create role nldi_user with login password '${NLDI_USER_PASSWORD}';
--rollback drop role if exists nldi_user;

--changeset drsteini:grant.nldi_user.to.nldi_data
grant nldi_user to nldi_data;
--rollback revoke nldi_user from nldi_data;
