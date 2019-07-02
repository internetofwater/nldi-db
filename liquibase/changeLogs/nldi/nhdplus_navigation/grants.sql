--liquibase formatted sql

--changeset drsteini:grant.select.all.tables.in.nhdplus_navigation.to.${NLDI_READ_ONLY_USERNAME} runAlways:true
grant select on all tables in schema nhdplus_navigation to ${NLDI_READ_ONLY_USERNAME};
--rollback revoke select on all tables in schema nhdplus_navigation from ${NLDI_READ_ONLY_USERNAME};

--changeset drsteini:grant.insert.update.on.nhdplus_navigation.navigation_cache_status.to.${NLDI_READ_ONLY_USERNAME}
grant insert, update on nhdplus_navigation.navigation_cache_status to ${NLDI_READ_ONLY_USERNAME};
--rollback revoke insert, update on nhdplus_navigation.navigation_cache_status from ${NLDI_READ_ONLY_USERNAME};

--changeset drsteini:grant.select.usage.on.nhdplus_navigation.tmp_navigation_status_seq.to.${NLDI_READ_ONLY_USERNAME}
grant select, usage on sequence nhdplus_navigation.tmp_navigation_status_seq to ${NLDI_READ_ONLY_USERNAME};
--rollback revoke select, usage on nhdplus_navigation.tmp_navigation_status_seq from ${NLDI_READ_ONLY_USERNAME};

--changeset drsteini:grant.insert.update.on.nhdplus_navigation.tmp_navigation_results.to.${NLDI_READ_ONLY_USERNAME}
grant insert, update on nhdplus_navigation.tmp_navigation_results to ${NLDI_READ_ONLY_USERNAME};
--rollback revoke insert, update on nhdplus_navigation.tmp_navigation_results from ${NLDI_READ_ONLY_USERNAME};

--changeset drsteini:grant.select.usage.on.nhdplus_navigation.tmp_navigation_results_seq.to.${NLDI_READ_ONLY_USERNAME}
grant select, usage on sequence nhdplus_navigation.tmp_navigation_results_seq to ${NLDI_READ_ONLY_USERNAME};
--rollback revoke select, usage on nhdplus_navigation.tmp_navigation_results_seq from ${NLDI_READ_ONLY_USERNAME};
