--liquibase formatted sql

--changeset drsteini:create_user_nhdplus
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_user where usename = 'nhdplus'
create user nhdplus with password '${POSTGRES_PASSWORD}';
--rollback drop user if exists nhdplus;

--changeset drsteini:create_user_nhdplus_navigation
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_user where usename = 'nhdplus_navigation'
CREATE USER nhdplus_navigation WITH PASSWORD '${POSTGRES_PASSWORD}';
--rollback drop user if exists nhdplus_navigation;
