--liquibase formatted sql

--changeset drsteini:grant.select.all.tables.in.characteristic_data.to.${NLDI_READ_ONLY_USERNAME} runAlways:true
grant select on all tables in schema characteristic_data to ${NLDI_READ_ONLY_USERNAME};
--rollback revoke select on all tables in schema characteristic_data from ${NLDI_READ_ONLY_USERNAME};
