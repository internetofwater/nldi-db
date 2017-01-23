--liquibase formatted sql

--changeset drsteini:grant.select.all.tables.in.characteristic_data.to.nldi_user runAlways:true
grant select on all tables in schema characteristic_data to nldi_user;
--rollback revoke select on all tables in schema characteristic_data from nldi_user;
