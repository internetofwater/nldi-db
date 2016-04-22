--liquibase formatted sql

--changeset drsteini:create_sequence.nhdplus_navigation.tmp_navigation_status_seq
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'tmp_navigation_status_seq'
create sequence nhdplus_navigation.tmp_navigation_status_seq increment by 1 start with 1;
--rollback drop sequence if exists nhdplus_navigation.tmp_navigation_status_seq;

--changeset drsteini:create_sequence.nhdplus_navigation.tmp_navigation_results_seq
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'tmp_navigation_results_seq'
create sequence nhdplus_navigation.tmp_navigation_results_seq increment by 1 start with 1;
--rollback drop sequence if exists nhdplus_navigation.tmp_navigation_results_seq;
