--liquibase formatted sql

--changeset drsteini:grant.select.all.tables.in.nldi_data.to.nldi_user runAlways:true
grant select on all tables in schema nldi_data to nldi_user;
--rollback revoke select on all tables in schema nldi_data from nldi_user;

--changeset drsteini:grant.insert.update.on.web_service_log.to.nldi_user
grant insert, update on nldi_data.web_service_log to nldi_user;
--rollback revoke insert, update on nldi_data.web_service_log from nldi_user;

--changeset drsteini:grant.select.usage.update.on.web_service_log_web_service_log_id_seq.to.nldi_user
grant select, usage on sequence nldi_data.web_service_log_web_service_log_id_seq to nldi_user;
--rollback revoke select, usage on nldi_data.web_service_log_web_service_log_id_seq from nldi_user;
