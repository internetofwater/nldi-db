--liquibase formatted sql

--changeset drsteini:grant.select.all.tables.in.nhdplus.to.${NLDI_READ_ONLY_USERNAME} runAlways:true
grant select on all tables in schema nhdplus to ${NLDI_READ_ONLY_USERNAME};
--rollback revoke select on all tables in schema nhdplus from ${NLDI_READ_ONLY_USERNAME};
