--liquibase formatted sql

--changeset drsteini:grant.select.all.tables.in.nldi_data.to.${NLDI_READ_ONLY_USERNAME} runAlways:true
grant select on all tables in schema nldi_data to ${NLDI_READ_ONLY_USERNAME};
--rollback revoke select on all tables in schema nldi_data from ${NLDI_READ_ONLY_USERNAME};

--changeset drsteini:grant.insert.update.on.web_service_log.to.${NLDI_READ_ONLY_USERNAME}
grant insert, update on nldi_data.web_service_log to ${NLDI_READ_ONLY_USERNAME};
--rollback revoke insert, update on nldi_data.web_service_log from ${NLDI_READ_ONLY_USERNAME};

--changeset drsteini:grant.select.usage.update.on.web_service_log_web_service_log_id_seq.to.${NLDI_READ_ONLY_USERNAME}
grant select, usage on sequence nldi_data.web_service_log_web_service_log_id_seq to ${NLDI_READ_ONLY_USERNAME};
--rollback revoke select, usage on nldi_data.web_service_log_web_service_log_id_seq from ${NLDI_READ_ONLY_USERNAME};
