--liquibase formatted sql

--changeset drsteini:grant.select.all.tables.in.nhdplus.to.nldi_user runAlways:true
grant select on all tables in schema nhdplus to nldi_user;
--rollback revoke select on all tables in schema nhdplus from nldi_user;
