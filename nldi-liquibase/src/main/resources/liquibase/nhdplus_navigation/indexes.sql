--liquibase formatted sql

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dd_08i
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'prep_connections_dd_08i' and c.relkind = 'i'
create index prep_connections_dd_08i on nhdplus_navigation.prep_connections_dd (hydroseq);
--rollback drop index nhdplus_navigation.prep_connections_dd_08i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dd_13i
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'prep_connections_dd_13i' and c.relkind = 'i'
create index prep_connections_dd_13i on nhdplus_navigation.prep_connections_dd (pathlength);
--rollback drop index nhdplus_navigation.prep_connections_dd_13i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dd_14i
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'prep_connections_dd_14i' and c.relkind = 'i'
create index prep_connections_dd_14i on nhdplus_navigation.prep_connections_dd (lengthkm);
--rollback drop index nhdplus_navigation.prep_connections_dd_14i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dd_16i
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'prep_connections_dd_16i' and c.relkind = 'i'
create index prep_connections_dd_16i on nhdplus_navigation.prep_connections_dd (pathtime);
--rollback drop index nhdplus_navigation.prep_connections_dd_16i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dd_17i
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'prep_connections_dd_17i' and c.relkind = 'i'
create index prep_connections_dd_17i on nhdplus_navigation.prep_connections_dd (travtime);
--rollback drop index nhdplus_navigation.prep_connections_dd_17i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dd_u01
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'prep_connections_dd_u01' and c.relkind = 'i'
create unique index prep_connections_dd_u01 on nhdplus_navigation.prep_connections_dd (objectid);
--rollback drop index nhdplus_navigation.prep_connections_dd_u01;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dm_08i
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'prep_connections_dm_08i' and c.relkind = 'i'
create index prep_connections_dm_08i on nhdplus_navigation.prep_connections_dm (hydroseq);
--rollback drop index nhdplus_navigation.prep_connections_dm_08i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dm_13i
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'prep_connections_dm_13i' and c.relkind = 'i'
create index prep_connections_dm_13i on nhdplus_navigation.prep_connections_dm (pathlength);
--rollback drop index nhdplus_navigation.prep_connections_dm_13i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dm_14i
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'prep_connections_dm_14i' and c.relkind = 'i'
create index prep_connections_dm_14i on nhdplus_navigation.prep_connections_dm (lengthkm);
--rollback drop index nhdplus_navigation.prep_connections_dm_14i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dm_16i
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'prep_connections_dm_16i' and c.relkind = 'i'
create index prep_connections_dm_16i on nhdplus_navigation.prep_connections_dm (pathtime);
--rollback drop index nhdplus_navigation.prep_connections_dm_16i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dm_17i
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'prep_connections_dm_17i' and c.relkind = 'i'
create index prep_connections_dm_17i on nhdplus_navigation.prep_connections_dm (travtime);
--rollback drop index nhdplus_navigation.prep_connections_dm_17i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dm_u01
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'prep_connections_dm_u01' and c.relkind = 'i'
create unique index prep_connections_dm_u01 on nhdplus_navigation.prep_connections_dm (objectid);
--rollback drop index nhdplus_navigation.prep_connections_dm_u01;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_um_08i
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'prep_connections_um_08i' and c.relkind = 'i'
create index prep_connections_um_08i on nhdplus_navigation.prep_connections_um (hydroseq);
--rollback drop index nhdplus_navigation.prep_connections_um_08i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_um_13i
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'prep_connections_um_13i' and c.relkind = 'i'
create index prep_connections_um_13i on nhdplus_navigation.prep_connections_um (pathlength);
--rollback drop index nhdplus_navigation.prep_connections_um_13i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_um_14i
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'prep_connections_um_14i' and c.relkind = 'i'
create index prep_connections_um_14i on nhdplus_navigation.prep_connections_um (lengthkm);
--rollback drop index nhdplus_navigation.prep_connections_um_14i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_um_16i
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'prep_connections_um_16i' and c.relkind = 'i'
create index prep_connections_um_16i on nhdplus_navigation.prep_connections_um (pathtime);
--rollback drop index nhdplus_navigation.prep_connections_um_16i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_um_17i
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'prep_connections_um_17i' and c.relkind = 'i'
create index prep_connections_um_17i on nhdplus_navigation.prep_connections_um (travtime);
--rollback drop index nhdplus_navigation.prep_connections_um_17i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_um_u01
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'prep_connections_um_u01' and c.relkind = 'i'
create unique index prep_connections_um_u01 on nhdplus_navigation.prep_connections_um (objectid);
--rollback drop index nhdplus_navigation.prep_connections_um_u01;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_ut_08i
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'prep_connections_ut_08i' and c.relkind = 'i'
create index prep_connections_ut_08i on nhdplus_navigation.prep_connections_ut (hydroseq);
--rollback drop index nhdplus_navigation.prep_connections_ut_08i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_ut_13i
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'prep_connections_ut_13i' and c.relkind = 'i'
create index prep_connections_ut_13i on nhdplus_navigation.prep_connections_ut (pathlength);
--rollback drop index nhdplus_navigation.prep_connections_ut_13i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_ut_14i
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'prep_connections_ut_14i' and c.relkind = 'i'
create index prep_connections_ut_14i on nhdplus_navigation.prep_connections_ut (lengthkm);
--rollback drop index nhdplus_navigation.prep_connections_ut_14i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_ut_16i
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'prep_connections_ut_16i' and c.relkind = 'i'
create index prep_connections_ut_16i on nhdplus_navigation.prep_connections_ut (pathtime);
--rollback drop index nhdplus_navigation.prep_connections_ut_16i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_ut_17i
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'prep_connections_ut_17i' and c.relkind = 'i'
create index prep_connections_ut_17i on nhdplus_navigation.prep_connections_ut (travtime);
--rollback drop index nhdplus_navigation.prep_connections_ut_17i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_ut_u01
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'prep_connections_ut_u01' and c.relkind = 'i'
create unique index prep_connections_ut_u01 on nhdplus_navigation.prep_connections_ut (objectid);
--rollback drop index nhdplus_navigation.prep_connections_ut_u01;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_results_03i
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'tmp_navigation_results_03i' and c.relkind = 'i'
create index tmp_navigation_results_03i on nhdplus_navigation.tmp_navigation_results (session_id, reachcode);
--rollback drop index nhdplus_navigation.tmp_navigation_results_03i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_results_08i
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'tmp_navigation_results_08i' and c.relkind = 'i'
create index tmp_navigation_results_08i on nhdplus_navigation.tmp_navigation_results (session_id, hydroseq);
--rollback drop index nhdplus_navigation.tmp_navigation_results_08i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_results_09i
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'tmp_navigation_results_09i' and c.relkind = 'i'
create index tmp_navigation_results_09i on nhdplus_navigation.tmp_navigation_results (session_id, levelpathid);
--rollback drop index nhdplus_navigation.tmp_navigation_results_09i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_results_10i
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'tmp_navigation_results_10i' and c.relkind = 'i'
create index tmp_navigation_results_10i on nhdplus_navigation.tmp_navigation_results (session_id, terminalpathid);
--rollback drop index nhdplus_navigation.tmp_navigation_results_10i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_results_13i
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'tmp_navigation_results_13i' and c.relkind = 'i'
create index tmp_navigation_results_13i on nhdplus_navigation.tmp_navigation_results (session_id, pathlength);
--rollback drop index nhdplus_navigation.tmp_navigation_results_13i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_results_16i
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'tmp_navigation_results_16i' and c.relkind = 'i'
create index tmp_navigation_results_16i on nhdplus_navigation.tmp_navigation_results (session_id, pathtime);
--rollback drop index nhdplus_navigation.tmp_navigation_results_16i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_results_u01
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'tmp_navigation_results_u01' and c.relkind = 'i'
create unique index tmp_navigation_results_u01 on nhdplus_navigation.tmp_navigation_results (objectid);
--rollback drop index nhdplus_navigation.tmp_navigation_results_u01;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_status_u01
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nhdplus_navigation' and c.relname = 'navigation_cache_status_u01' and c.relkind = 'i'
create unique index navigation_cache_status_u01 on nhdplus_navigation.navigation_cache_status (objectid);
--rollback drop index nhdplus_navigation.navigation_cache_status_u01;
