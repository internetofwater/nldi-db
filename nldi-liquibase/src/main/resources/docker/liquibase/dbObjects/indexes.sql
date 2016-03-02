--liquibase formatted sql

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dd_08i
create index prep_connections_dd_08i on nhdplus_navigation.prep_connections_dd (hydroseq);
--rollback drop index nhdplus_navigation.prep_connections_dd_08i

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dd_13i
create index prep_connections_dd_13i on nhdplus_navigation.prep_connections_dd (pathlength);
--rollback drop index nhdplus_navigation.prep_connections_dd_13i

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dd_14i
create index prep_connections_dd_14i on nhdplus_navigation.prep_connections_dd (lengthkm);
--rollback drop index nhdplus_navigation.prep_connections_dd_14i

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dd_16i
create index prep_connections_dd_16i on nhdplus_navigation.prep_connections_dd (pathtime);
--rollback drop index nhdplus_navigation.prep_connections_dd_16i

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dd_17i
create index prep_connections_dd_17i on nhdplus_navigation.prep_connections_dd (travtime);
--rollback drop index nhdplus_navigation.prep_connections_dd_17i

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dd_u01
create unique index prep_connections_dd_u01 on nhdplus_navigation.prep_connections_dd (objectid);
--rollback drop index nhdplus_navigation.prep_connections_dd_u01

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dm_08i
create index prep_connections_dm_08i on nhdplus_navigation.prep_connections_dm (hydroseq);
--rollback drop index nhdplus_navigation.prep_connections_dm_08i

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dm_13i
create index prep_connections_dm_13i on nhdplus_navigation.prep_connections_dm (pathlength);
--rollback drop index nhdplus_navigation.prep_connections_dm_13i

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dm_14i
create index prep_connections_dm_14i on nhdplus_navigation.prep_connections_dm (lengthkm);
--rollback drop index nhdplus_navigation.prep_connections_dm_14i

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dm_16i
create index prep_connections_dm_16i on nhdplus_navigation.prep_connections_dm (pathtime);
--rollback drop index nhdplus_navigation.prep_connections_dm_16i

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dm_17i
create index prep_connections_dm_17i on nhdplus_navigation.prep_connections_dm (travtime);
--rollback drop index nhdplus_navigation.prep_connections_dm_17i

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dm_u01
create unique index prep_connections_dm_u01 on nhdplus_navigation.prep_connections_dm (objectid);
--rollback drop index nhdplus_navigation.prep_connections_dm_u01

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_um_08i
create index prep_connections_um_08i on nhdplus_navigation.prep_connections_um (hydroseq);
--rollback drop index nhdplus_navigation.prep_connections_um_08i

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_um_13i
create index prep_connections_um_13i on nhdplus_navigation.prep_connections_um (pathlength);
--rollback drop index nhdplus_navigation.prep_connections_um_13i

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_um_14i
create index prep_connections_um_14i on nhdplus_navigation.prep_connections_um (lengthkm);
--rollback drop index nhdplus_navigation.prep_connections_um_14i

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_um_16i
create index prep_connections_um_16i on nhdplus_navigation.prep_connections_um (pathtime);
--rollback drop index nhdplus_navigation.prep_connections_um_16i

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_um_17i
create index prep_connections_um_17i on nhdplus_navigation.prep_connections_um (travtime);
--rollback drop index nhdplus_navigation.prep_connections_um_17i

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_um_u01
create unique index prep_connections_um_u01 on nhdplus_navigation.prep_connections_um (objectid);
--rollback drop index nhdplus_navigation.prep_connections_um_u01

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_ut_08i
create index prep_connections_ut_08i on nhdplus_navigation.prep_connections_ut (hydroseq);
--rollback drop index nhdplus_navigation.prep_connections_ut_08i

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_ut_13i
create index prep_connections_ut_13i on nhdplus_navigation.prep_connections_ut (pathlength);
--rollback drop index nhdplus_navigation.prep_connections_ut_13i

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_ut_14i
create index prep_connections_ut_14i on nhdplus_navigation.prep_connections_ut (lengthkm);
--rollback drop index nhdplus_navigation.prep_connections_ut_14i

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_ut_16i
create index prep_connections_ut_16i on nhdplus_navigation.prep_connections_ut (pathtime);
--rollback drop index nhdplus_navigation.prep_connections_ut_16i

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_ut_17i
create index prep_connections_ut_17i on nhdplus_navigation.prep_connections_ut (travtime);
--rollback drop index nhdplus_navigation.prep_connections_ut_17i

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_ut_u01
create unique index prep_connections_ut_u01 on nhdplus_navigation.prep_connections_ut (objectid);
--rollback drop index nhdplus_navigation.prep_connections_ut_u01

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_pk
create unique index tmp_navigation_connections_pk on nhdplus_navigation.tmp_navigation_connections (permanent_identifier);
--rollback drop index nhdplus_navigation.tmp_navigation_connections_pk

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_pk2
create unique index tmp_navigation_connections_pk2 on nhdplus_navigation.tmp_navigation_connections (nhdplus_comid);
--rollback drop index nhdplus_navigation.tmp_navigation_connections_pk2

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_08i
create index tmp_navigation_connections_08i on nhdplus_navigation.tmp_navigation_connections (hydroseq);
--rollback drop index nhdplus_navigation.tmp_navigation_connections_08i

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_09i
create index tmp_navigation_connections_09i on nhdplus_navigation.tmp_navigation_connections (levelpathid);
--rollback drop index nhdplus_navigation.tmp_navigation_connections_09i

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_10i
create index tmp_navigation_connections_10i on nhdplus_navigation.tmp_navigation_connections (terminalpathid);
--rollback drop index nhdplus_navigation.tmp_navigation_connections_10i

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_13i
create index tmp_navigation_connections_13i on nhdplus_navigation.tmp_navigation_connections (pathlength);
--rollback drop index nhdplus_navigation.tmp_navigation_connections_13i

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_16i
create index tmp_navigation_connections_16i on nhdplus_navigation.tmp_navigation_connections (pathtime);
--rollback drop index nhdplus_navigation.tmp_navigation_connections_16i

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_dd_pk
create unique index tmp_navigation_connections_dd_pk on nhdplus_navigation.tmp_navigation_connections_dd (permanent_identifier);
--rollback drop index nhdplus_navigation.tmp_navigation_connections_dd_pk

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_dd_pk2
create unique index tmp_navigation_connections_dd_pk2 on nhdplus_navigation.tmp_navigation_connections_dd (nhdplus_comid);
--rollback drop index nhdplus_navigation.tmp_navigation_connections_dd_pk2

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_dd_08i
create index tmp_navigation_connections_dd_08i on nhdplus_navigation.tmp_navigation_connections_dd (hydroseq);
--rollback drop index nhdplus_navigation.tmp_navigation_connections_dd_08i

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_dd_09i
create index tmp_navigation_connections_dd_09i on nhdplus_navigation.tmp_navigation_connections_dd (levelpathid);
--rollback drop index nhdplus_navigation.tmp_navigation_connections_dd_09i

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_dd_10i
create index tmp_navigation_connections_dd_10i on nhdplus_navigation.tmp_navigation_connections_dd (terminalpathid);
--rollback drop index nhdplus_navigation.tmp_navigation_connections_dd_10i

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_dd_13i
create index tmp_navigation_connections_dd_13i on nhdplus_navigation.tmp_navigation_connections_dd (pathlength);
--rollback drop index nhdplus_navigation.tmp_navigation_connections_dd_13i

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_dd_16i
create index tmp_navigation_connections_dd_16i on nhdplus_navigation.tmp_navigation_connections_dd (pathtime);
--rollback drop index nhdplus_navigation.tmp_navigation_connections_dd_16i

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_dd_21i
create index tmp_navigation_connections_dd_21i on nhdplus_navigation.tmp_navigation_connections_dd (processed);      
--rollback drop index nhdplus_navigation.tmp_navigation_connections_dd_21i

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_results_03i
create index tmp_navigation_results_03i on nhdplus_navigation.tmp_navigation_results (session_id, reachcode);
--rollback drop index nhdplus_navigation.tmp_navigation_results_03i

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_results_08i
create index tmp_navigation_results_08i on nhdplus_navigation.tmp_navigation_results (session_id, hydroseq);
--rollback drop index nhdplus_navigation.tmp_navigation_results_08i

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_results_09i
create index tmp_navigation_results_09i on nhdplus_navigation.tmp_navigation_results (session_id, levelpathid);
--rollback drop index nhdplus_navigation.tmp_navigation_results_09i

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_results_10i
create index tmp_navigation_results_10i on nhdplus_navigation.tmp_navigation_results (session_id, terminalpathid);
--rollback drop index nhdplus_navigation.tmp_navigation_results_10i

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_results_13i
create index tmp_navigation_results_13i on nhdplus_navigation.tmp_navigation_results (session_id, pathlength);
--rollback drop index nhdplus_navigation.tmp_navigation_results_13i

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_results_16i
create index tmp_navigation_results_16i on nhdplus_navigation.tmp_navigation_results (session_id, pathtime);
--rollback drop index nhdplus_navigation.tmp_navigation_results_16i

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_results_u01
create unique index tmp_navigation_results_u01 on nhdplus_navigation.tmp_navigation_results (objectid);
--rollback drop index nhdplus_navigation.tmp_navigation_results_u01

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_status_u01
create unique index tmp_navigation_status_u01 on nhdplus_navigation.tmp_navigation_status (objectid);
--rollback drop index nhdplus_navigation.tmp_navigation_status_u01

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_uptrib_pk
create unique index tmp_navigation_uptrib_pk on nhdplus_navigation.tmp_navigation_uptrib (fromlevelpathid);
--rollback drop index nhdplus_navigation.tmp_navigation_uptrib_pk

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_working_pk
create unique index tmp_navigation_working_pk on nhdplus_navigation.tmp_navigation_working (permanent_identifier);
--rollback drop index nhdplus_navigation.tmp_navigation_working_pk

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_working_pk2
create unique index tmp_navigation_working_pk2 on nhdplus_navigation.tmp_navigation_working (permanent_identifier);
--rollback drop index nhdplus_navigation.tmp_navigation_working_pk2

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_working_03i
create index tmp_navigation_working_03i on nhdplus_navigation.tmp_navigation_working (reachcode);
--rollback drop index nhdplus_navigation.tmp_navigation_working_03i

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_working_08i
create index tmp_navigation_working_08i on nhdplus_navigation.tmp_navigation_working (hydroseq);
--rollback drop index nhdplus_navigation.tmp_navigation_working_08i

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_working_09i
create index tmp_navigation_working_09i on nhdplus_navigation.tmp_navigation_working (levelpathid);
--rollback drop index nhdplus_navigation.tmp_navigation_working_09i

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_working_10i
create index tmp_navigation_working_10i on nhdplus_navigation.tmp_navigation_working (terminalpathid);
--rollback drop index nhdplus_navigation.tmp_navigation_working_10i

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_working_13i
create index tmp_navigation_working_13i on nhdplus_navigation.tmp_navigation_working (pathlength);
--rollback drop index nhdplus_navigation.tmp_navigation_working_13i

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_working_16i
create index tmp_navigation_working_16i on nhdplus_navigation.tmp_navigation_working (pathtime);
--rollback drop index nhdplus_navigation.tmp_navigation_working_16i

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_working_17i
create index tmp_navigation_working_17i on nhdplus_navigation.tmp_navigation_working (dndraincount);
--rollback drop index nhdplus_navigation.tmp_navigation_working_17i

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_working_26i
create index tmp_navigation_working_26i on nhdplus_navigation.tmp_navigation_working (selected);      
--rollback drop index nhdplus_navigation.tmp_navigation_working_26i
