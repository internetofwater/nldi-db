--liquibase formatted sql

--changeset drsteini:grant.select.all.tables.in.nhdplus_navigation.to.nldi_user runAlways:true
grant select on all tables in schema nhdplus_navigation to nldi_user;
--rollback revoke select on all tables in schema nhdplus_navigation from nldi_user;

--changeset drsteini:grant.insert.update.on.nhdplus_navigation.navigation_cache_status.to.nldi_user
grant insert, update on nhdplus_navigation.navigation_cache_status to nldi_user;
--rollback revoke insert, update on nhdplus_navigation.navigation_cache_status from nldi_user;

--changeset drsteini:grant.select.usage.on.nhdplus_navigation.tmp_navigation_status_seq.to.nldi_user
grant select, usage on sequence nhdplus_navigation.tmp_navigation_status_seq to nldi_user;
--rollback revoke select, usage on nhdplus_navigation.tmp_navigation_status_seq from nldi_user;

--changeset drsteini:grant.insert.update.on.nhdplus_navigation.tmp_navigation_results.to.nldi_user
grant insert, update on nhdplus_navigation.tmp_navigation_results to nldi_user;
--rollback revoke insert, update on nhdplus_navigation.tmp_navigation_results from nldi_user;

--changeset drsteini:grant.select.usage.on.nhdplus_navigation.tmp_navigation_results_seq.to.nldi_user
grant select, usage on sequence nhdplus_navigation.tmp_navigation_results_seq to nldi_user;
--rollback revoke select, usage on nhdplus_navigation.tmp_navigation_results_seq from nldi_user;
