--liquibase formatted sql

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dd_08i
create index prep_connections_dd_08i on nhdplus_navigation.prep_connections_dd (hydroseq);
--rollback drop index nhdplus_navigation.prep_connections_dd_08i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dd_13i
create index prep_connections_dd_13i on nhdplus_navigation.prep_connections_dd (pathlength);
--rollback drop index nhdplus_navigation.prep_connections_dd_13i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dd_14i
create index prep_connections_dd_14i on nhdplus_navigation.prep_connections_dd (lengthkm);
--rollback drop index nhdplus_navigation.prep_connections_dd_14i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dd_16i
create index prep_connections_dd_16i on nhdplus_navigation.prep_connections_dd (pathtime);
--rollback drop index nhdplus_navigation.prep_connections_dd_16i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dd_17i
create index prep_connections_dd_17i on nhdplus_navigation.prep_connections_dd (travtime);
--rollback drop index nhdplus_navigation.prep_connections_dd_17i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dd_u01
create unique index prep_connections_dd_u01 on nhdplus_navigation.prep_connections_dd (objectid);
--rollback drop index nhdplus_navigation.prep_connections_dd_u01;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dm_08i
create index prep_connections_dm_08i on nhdplus_navigation.prep_connections_dm (hydroseq);
--rollback drop index nhdplus_navigation.prep_connections_dm_08i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dm_13i
create index prep_connections_dm_13i on nhdplus_navigation.prep_connections_dm (pathlength);
--rollback drop index nhdplus_navigation.prep_connections_dm_13i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dm_14i
create index prep_connections_dm_14i on nhdplus_navigation.prep_connections_dm (lengthkm);
--rollback drop index nhdplus_navigation.prep_connections_dm_14i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dm_16i
create index prep_connections_dm_16i on nhdplus_navigation.prep_connections_dm (pathtime);
--rollback drop index nhdplus_navigation.prep_connections_dm_16i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dm_17i
create index prep_connections_dm_17i on nhdplus_navigation.prep_connections_dm (travtime);
--rollback drop index nhdplus_navigation.prep_connections_dm_17i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_dm_u01
create unique index prep_connections_dm_u01 on nhdplus_navigation.prep_connections_dm (objectid);
--rollback drop index nhdplus_navigation.prep_connections_dm_u01;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_um_08i
create index prep_connections_um_08i on nhdplus_navigation.prep_connections_um (hydroseq);
--rollback drop index nhdplus_navigation.prep_connections_um_08i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_um_13i
create index prep_connections_um_13i on nhdplus_navigation.prep_connections_um (pathlength);
--rollback drop index nhdplus_navigation.prep_connections_um_13i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_um_14i
create index prep_connections_um_14i on nhdplus_navigation.prep_connections_um (lengthkm);
--rollback drop index nhdplus_navigation.prep_connections_um_14i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_um_16i
create index prep_connections_um_16i on nhdplus_navigation.prep_connections_um (pathtime);
--rollback drop index nhdplus_navigation.prep_connections_um_16i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_um_17i
create index prep_connections_um_17i on nhdplus_navigation.prep_connections_um (travtime);
--rollback drop index nhdplus_navigation.prep_connections_um_17i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_um_u01
create unique index prep_connections_um_u01 on nhdplus_navigation.prep_connections_um (objectid);
--rollback drop index nhdplus_navigation.prep_connections_um_u01;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_ut_08i
create index prep_connections_ut_08i on nhdplus_navigation.prep_connections_ut (hydroseq);
--rollback drop index nhdplus_navigation.prep_connections_ut_08i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_ut_13i
create index prep_connections_ut_13i on nhdplus_navigation.prep_connections_ut (pathlength);
--rollback drop index nhdplus_navigation.prep_connections_ut_13i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_ut_14i
create index prep_connections_ut_14i on nhdplus_navigation.prep_connections_ut (lengthkm);
--rollback drop index nhdplus_navigation.prep_connections_ut_14i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_ut_16i
create index prep_connections_ut_16i on nhdplus_navigation.prep_connections_ut (pathtime);
--rollback drop index nhdplus_navigation.prep_connections_ut_16i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_ut_17i
create index prep_connections_ut_17i on nhdplus_navigation.prep_connections_ut (travtime);
--rollback drop index nhdplus_navigation.prep_connections_ut_17i;

--changeset drsteini:create_index.nhdplus_navigation.prep_connections_ut_u01
create unique index prep_connections_ut_u01 on nhdplus_navigation.prep_connections_ut (objectid);
--rollback drop index nhdplus_navigation.prep_connections_ut_u01;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_pk
create unique index tmp_navigation_connections_pk on nhdplus_navigation.tmp_navigation_connections (permanent_identifier);
--rollback drop index nhdplus_navigation.tmp_navigation_connections_pk;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_pk2
create unique index tmp_navigation_connections_pk2 on nhdplus_navigation.tmp_navigation_connections (nhdplus_comid);
--rollback drop index nhdplus_navigation.tmp_navigation_connections_pk2;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_08i
create index tmp_navigation_connections_08i on nhdplus_navigation.tmp_navigation_connections (hydroseq);
--rollback drop index nhdplus_navigation.tmp_navigation_connections_08i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_09i
create index tmp_navigation_connections_09i on nhdplus_navigation.tmp_navigation_connections (levelpathid);
--rollback drop index nhdplus_navigation.tmp_navigation_connections_09i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_10i
create index tmp_navigation_connections_10i on nhdplus_navigation.tmp_navigation_connections (terminalpathid);
--rollback drop index nhdplus_navigation.tmp_navigation_connections_10i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_13i
create index tmp_navigation_connections_13i on nhdplus_navigation.tmp_navigation_connections (pathlength);
--rollback drop index nhdplus_navigation.tmp_navigation_connections_13i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_16i
create index tmp_navigation_connections_16i on nhdplus_navigation.tmp_navigation_connections (pathtime);
--rollback drop index nhdplus_navigation.tmp_navigation_connections_16i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_dd_pk
create unique index tmp_navigation_connections_dd_pk on nhdplus_navigation.tmp_navigation_connections_dd (permanent_identifier);
--rollback drop index nhdplus_navigation.tmp_navigation_connections_dd_pk;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_dd_pk2
create unique index tmp_navigation_connections_dd_pk2 on nhdplus_navigation.tmp_navigation_connections_dd (nhdplus_comid);
--rollback drop index nhdplus_navigation.tmp_navigation_connections_dd_pk2;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_dd_08i
create index tmp_navigation_connections_dd_08i on nhdplus_navigation.tmp_navigation_connections_dd (hydroseq);
--rollback drop index nhdplus_navigation.tmp_navigation_connections_dd_08i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_dd_09i
create index tmp_navigation_connections_dd_09i on nhdplus_navigation.tmp_navigation_connections_dd (levelpathid);
--rollback drop index nhdplus_navigation.tmp_navigation_connections_dd_09i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_dd_10i
create index tmp_navigation_connections_dd_10i on nhdplus_navigation.tmp_navigation_connections_dd (terminalpathid);
--rollback drop index nhdplus_navigation.tmp_navigation_connections_dd_10i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_dd_13i
create index tmp_navigation_connections_dd_13i on nhdplus_navigation.tmp_navigation_connections_dd (pathlength);
--rollback drop index nhdplus_navigation.tmp_navigation_connections_dd_13i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_dd_16i
create index tmp_navigation_connections_dd_16i on nhdplus_navigation.tmp_navigation_connections_dd (pathtime);
--rollback drop index nhdplus_navigation.tmp_navigation_connections_dd_16i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_connections_dd_21i
create index tmp_navigation_connections_dd_21i on nhdplus_navigation.tmp_navigation_connections_dd (processed);      
--rollback drop index nhdplus_navigation.tmp_navigation_connections_dd_21i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_results_03i
create index tmp_navigation_results_03i on nhdplus_navigation.tmp_navigation_results (session_id, reachcode);
--rollback drop index nhdplus_navigation.tmp_navigation_results_03i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_results_08i
create index tmp_navigation_results_08i on nhdplus_navigation.tmp_navigation_results (session_id, hydroseq);
--rollback drop index nhdplus_navigation.tmp_navigation_results_08i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_results_09i
create index tmp_navigation_results_09i on nhdplus_navigation.tmp_navigation_results (session_id, levelpathid);
--rollback drop index nhdplus_navigation.tmp_navigation_results_09i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_results_10i
create index tmp_navigation_results_10i on nhdplus_navigation.tmp_navigation_results (session_id, terminalpathid);
--rollback drop index nhdplus_navigation.tmp_navigation_results_10i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_results_13i
create index tmp_navigation_results_13i on nhdplus_navigation.tmp_navigation_results (session_id, pathlength);
--rollback drop index nhdplus_navigation.tmp_navigation_results_13i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_results_16i
create index tmp_navigation_results_16i on nhdplus_navigation.tmp_navigation_results (session_id, pathtime);
--rollback drop index nhdplus_navigation.tmp_navigation_results_16i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_results_u01
create unique index tmp_navigation_results_u01 on nhdplus_navigation.tmp_navigation_results (objectid);
--rollback drop index nhdplus_navigation.tmp_navigation_results_u01;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_status_u01
create unique index tmp_navigation_status_u01 on nhdplus_navigation.tmp_navigation_status (objectid);
--rollback drop index nhdplus_navigation.tmp_navigation_status_u01;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_uptrib_pk
create unique index tmp_navigation_uptrib_pk on nhdplus_navigation.tmp_navigation_uptrib (fromlevelpathid);
--rollback drop index nhdplus_navigation.tmp_navigation_uptrib_pk;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_working_pk
create unique index tmp_navigation_working_pk on nhdplus_navigation.tmp_navigation_working (permanent_identifier);
--rollback drop index nhdplus_navigation.tmp_navigation_working_pk;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_working_pk2
create unique index tmp_navigation_working_pk2 on nhdplus_navigation.tmp_navigation_working (permanent_identifier);
--rollback drop index nhdplus_navigation.tmp_navigation_working_pk2;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_working_03i
create index tmp_navigation_working_03i on nhdplus_navigation.tmp_navigation_working (reachcode);
--rollback drop index nhdplus_navigation.tmp_navigation_working_03i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_working_08i
create index tmp_navigation_working_08i on nhdplus_navigation.tmp_navigation_working (hydroseq);
--rollback drop index nhdplus_navigation.tmp_navigation_working_08i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_working_09i
create index tmp_navigation_working_09i on nhdplus_navigation.tmp_navigation_working (levelpathid);
--rollback drop index nhdplus_navigation.tmp_navigation_working_09i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_working_10i
create index tmp_navigation_working_10i on nhdplus_navigation.tmp_navigation_working (terminalpathid);
--rollback drop index nhdplus_navigation.tmp_navigation_working_10i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_working_13i
create index tmp_navigation_working_13i on nhdplus_navigation.tmp_navigation_working (pathlength);
--rollback drop index nhdplus_navigation.tmp_navigation_working_13i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_working_16i
create index tmp_navigation_working_16i on nhdplus_navigation.tmp_navigation_working (pathtime);
--rollback drop index nhdplus_navigation.tmp_navigation_working_16i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_working_17i
create index tmp_navigation_working_17i on nhdplus_navigation.tmp_navigation_working (dndraincount);
--rollback drop index nhdplus_navigation.tmp_navigation_working_17i;

--changeset drsteini:create_index.nhdplus_navigation.tmp_navigation_working_26i
create index tmp_navigation_working_26i on nhdplus_navigation.tmp_navigation_working (selected);      
--rollback drop index nhdplus_navigation.tmp_navigation_working_26i;

--changeset drsteini:create_index.nhdplus.i398fromcomid
create index i398fromcomid on nhdplus.megadiv_np21 using btree (fromcomid) with (fillfactor=75);
--rollback drop index nhdplus.i398fromcomid;

--changeset drsteini:create_index.nhdplus.i444nhdplus_regi_1
create index i444nhdplus_regi_1 on nhdplus.megadiv_np21 using btree (nhdplus_region) with (fillfactor=75);
--rollback drop index nhdplus.i444nhdplus_regi_1;

--changeset drsteini:create_index.nhdplus.i664tocomid
create index i664tocomid on nhdplus.megadiv_np21 using btree (tocomid) with (fillfactor=75);
--rollback drop index nhdplus.i664tocomid;

--changeset drsteini:create_index.nhdplus.r34_sde_rowid_uk
create unique index r34_sde_rowid_uk on nhdplus.megadiv_np21 using btree (objectid) with (fillfactor=60);
--rollback drop index nhdplus.r34_sde_rowid_uk;

--changeset drsteini:create_index.nhdplus.a162_ix1
create index a162_ix1 on nhdplus.nhdflowline_np21 using gist (shape);
--rollback drop index nhdplus.a162_ix1;

--changeset drsteini:create_index.nhdplus.i160catchment_fe
create index i160catchment_fe on nhdplus.nhdflowline_np21 using btree (catchment_featureid) with (fillfactor=75);
--rollback drop index nhdplus.i160catchment_fe;

--changeset drsteini:create_index.nhdplus.i206streamorder
create index i206streamorder on nhdplus.nhdflowline_np21 using btree (streamorder) with (fillfactor=75);
--rollback drop index nhdplus.i206streamorder;

--changeset drsteini:create_index.nhdplus.i270nhdplus_regi
create index i270nhdplus_regi on nhdplus.nhdflowline_np21 using btree (nhdplus_region) with (fillfactor=75);
--rollback drop index nhdplus.i270nhdplus_regi;

--changeset drsteini:create_index.nhdplus.i301gnis_id
create index i301gnis_id on nhdplus.nhdflowline_np21 using btree (gnis_id) with (fillfactor=75);
--rollback drop index nhdplus.i301gnis_id;

--changeset drsteini:create_index.nhdplus.i387wbarea_fcode
create index i387wbarea_fcode on nhdplus.nhdflowline_np21 using btree (wbarea_fcode) with (fillfactor=75);
--rollback drop index nhdplus.i387wbarea_fcode;

--changeset drsteini:create_index.nhdplus.i468reachcode
create index i468reachcode on nhdplus.nhdflowline_np21 using btree (reachcode) with (fillfactor=75);
--rollback drop index nhdplus.i468reachcode;

--changeset drsteini:create_index.nhdplus.i51streamlevel
create index i51streamlevel on nhdplus.nhdflowline_np21 using btree (streamlevel) with (fillfactor=75);
--rollback drop index nhdplus.i51streamlevel;

--changeset drsteini:create_index.nhdplus.i540wbarea_ftype
create index i540wbarea_ftype on nhdplus.nhdflowline_np21 using btree (wbarea_ftype) with (fillfactor=75);
--rollback drop index nhdplus.i540wbarea_ftype;

--changeset drsteini:create_index.nhdplus.i576permanent_id
create unique index i576permanent_id on nhdplus.nhdflowline_np21 using btree (permanent_identifier) with (fillfactor=75);
--rollback drop index nhdplus.i576permanent_id;

--changeset drsteini:create_index.nhdplus.i603wbd_huc12
create index i603wbd_huc12 on nhdplus.nhdflowline_np21 using btree (wbd_huc12) with (fillfactor=75);
--rollback drop index nhdplus.i603wbd_huc12;

--changeset drsteini:create_index.nhdplus.i605nhdplus_comi
create unique index i605nhdplus_comi on nhdplus.nhdflowline_np21 using btree (nhdplus_comid) with (fillfactor=75);
--rollback drop index nhdplus.i605nhdplus_comi;

--changeset drsteini:create_index.nhdplus.i655gnis_name
create index i655gnis_name on nhdplus.nhdflowline_np21 using btree (gnis_name) with (fillfactor=75);
--rollback drop index nhdplus.i655gnis_name;

--changeset drsteini:create_index.nhdplus.i757wbarea_nhdpl
create index i757wbarea_nhdpl on nhdplus.nhdflowline_np21 using btree (wbarea_nhdplus_comid) with (fillfactor=75);
--rollback drop index nhdplus.i757wbarea_nhdpl;

--changeset drsteini:create_index.nhdplus.i814hydroseq
create index i814hydroseq on nhdplus.nhdflowline_np21 using btree (hydroseq) with (fillfactor=75);
--rollback drop index nhdplus.i814hydroseq;

--changeset drsteini:create_index.nhdplus.i818wbarea_perma
create index i818wbarea_perma on nhdplus.nhdflowline_np21 using btree (wbarea_permanent_identifier) with (fillfactor=75);
--rollback drop index nhdplus.i818wbarea_perma;

--changeset drsteini:create_index.nhdplus.i82ftype
create index i82ftype on nhdplus.nhdflowline_np21 using btree (ftype) with (fillfactor=75);
--rollback drop index nhdplus.i82ftype;

--changeset drsteini:create_index.nhdplus.i835fcode
create index i835fcode on nhdplus.nhdflowline_np21 using btree (fcode) with (fillfactor=75);
--rollback drop index nhdplus.i835fcode;

--changeset drsteini:create_index.nhdplus.i871navigable
create index i871navigable on nhdplus.nhdflowline_np21 using btree (navigable) with (fillfactor=75);
--rollback drop index nhdplus.i871navigable;

--changeset drsteini:create_index.nhdplus.r368_sde_rowid_uk
create unique index r368_sde_rowid_uk on nhdplus.nhdflowline_np21 using btree (objectid) with (fillfactor=60);
--rollback drop index nhdplus.r368_sde_rowid_uk;

--changeset drsteini:create_index.nhdplus.i52dncomid
create index i52dncomid on nhdplus.nhdplusconnect_np21 using btree (dncomid) with (fillfactor=75);
--rollback drop index nhdplus.i52dncomid;

--changeset drsteini:create_index.nhdplus.i841upcomid
create index i841upcomid on nhdplus.nhdplusconnect_np21 using btree (upcomid) with (fillfactor=75);
--rollback drop index nhdplus.i841upcomid;

--changeset drsteini:create_index.nhdplus.r325_sde_rowid_uk
create unique index r325_sde_rowid_uk on nhdplus.nhdplusconnect_np21 using btree (objectid) with (fillfactor=60);
--rollback drop index nhdplus.r325_sde_rowid_uk;

--changeset drsteini:create_index.nhdplus.i177terminalpath
create index i177terminalpath on nhdplus.plusflowlinevaa_np21 using btree (terminalpathid) with (fillfactor=75);
--rollback drop index nhdplus.i177terminalpath;

--changeset drsteini:create_index.nhdplus.i325comid
create unique index i325comid on nhdplus.plusflowlinevaa_np21 using btree (comid) with (fillfactor=75);
--rollback drop index nhdplus.i325comid;

--changeset drsteini:create_index.nhdplus.i349reachcode
create index i349reachcode on nhdplus.plusflowlinevaa_np21 using btree (reachcode) with (fillfactor=75);
--rollback drop index nhdplus.i349reachcode;

--changeset drsteini:create_index.nhdplus.i427fcode
create index i427fcode on nhdplus.plusflowlinevaa_np21 using btree (fcode) with (fillfactor=75);
--rollback drop index nhdplus.i427fcode;

--changeset drsteini:create_index.nhdplus.i442hydroseq
create index i442hydroseq on nhdplus.plusflowlinevaa_np21 using btree (hydroseq) with (fillfactor=75);
--rollback drop index nhdplus.i442hydroseq;

--changeset drsteini:create_index.nhdplus.i509nhdplus_regi
create index i509nhdplus_regi on nhdplus.plusflowlinevaa_np21 using btree (nhdplus_region) with (fillfactor=75);
--rollback drop index nhdplus.i509nhdplus_regi;

--changeset drsteini:create_index.nhdplus.i638streamorder
create index i638streamorder on nhdplus.plusflowlinevaa_np21 using btree (streamorder) with (fillfactor=75);
--rollback drop index nhdplus.i638streamorder;

--changeset drsteini:create_index.nhdplus.i648levelpathid
create index i648levelpathid on nhdplus.plusflowlinevaa_np21 using btree (levelpathid) with (fillfactor=75);
--rollback drop index nhdplus.i648levelpathid;

--changeset drsteini:create_index.nhdplus.i910permanent_id
create unique index i910permanent_id on nhdplus.plusflowlinevaa_np21 using btree (permanent_identifier) with (fillfactor=75);
--rollback drop index nhdplus.i910permanent_id;

--changeset drsteini:create_index.nhdplus.i954streamlevel
create index i954streamlevel on nhdplus.plusflowlinevaa_np21 using btree (streamlevel) with (fillfactor=75);
--rollback drop index nhdplus.i954streamlevel;

--changeset drsteini:create_index.nhdplus.r45_sde_rowid_uk
create unique index r45_sde_rowid_uk on nhdplus.plusflowlinevaa_np21 using btree (objectid) with (fillfactor=60);
--rollback drop index nhdplus.r45_sde_rowid_uk;

--changeset drsteini:create_index.nhdplus.i12fromcomid
create index i12fromcomid on nhdplus.plusflow_np21 using btree (fromcomid) with (fillfactor=75);
--rollback drop index nhdplus.i12fromcomid;

--changeset drsteini:create_index.nhdplus.i556nhdplus_regi
create index i556nhdplus_regi on nhdplus.plusflow_np21 using btree (nhdplus_region) with (fillfactor=75);
--rollback drop index nhdplus.i556nhdplus_regi;

--changeset drsteini:create_index.nhdplus.i973tocomid
create index i973tocomid on nhdplus.plusflow_np21 using btree (tocomid) with (fillfactor=75);
--rollback drop index nhdplus.i973tocomid;

--changeset drsteini:create_index.nhdplus.r43_sde_rowid_uk
create unique index r43_sde_rowid_uk on nhdplus.plusflow_np21 using btree (objectid) with (fillfactor=60);
--rollback drop index nhdplus.r43_sde_rowid_uk;

--changeset drsteini:create_index.nhdplus.catchmentsp_the_geom_geom_idx
create index catchmentsp_the_geom_geom_idx on nhdplus.catchmentsp using gist (the_geom);
--rollback drop index nhdplus.catchmentsp_the_geom_geom_idx;
