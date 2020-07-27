--liquibase formatted sql

--changeset kkehl:create_index.nldi_data.web_service_log_id_idx runAlways:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nldi_data' and c.relname = 'web_service_log_id_idx' and c.relkind = 'i'
create index web_service_log_id_idx on nldi_data.web_service_log(web_service_log_id);
--rollback drop index nldi_data.web_service_log_id_idx;

