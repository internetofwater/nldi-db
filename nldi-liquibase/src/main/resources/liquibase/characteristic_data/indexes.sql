--liquibase formatted sql

--changeset drsteini:create_index.characteristic_data.plusflowline_vaa_np21_ut
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'characteristic_data' and c.relname = 'plusflowlinevaa_np21_ut' and c.relkind = 'i'
create index plusflowlinevaa_np21_ut on characteristic_data.plusflowlinevaa_np21(dnhydroseq, dnminorhyd, pathlength, comid, hydroseq, startflag);
--rollback drop index characteristic_data.plusflowlinevaa_np21_ut;
