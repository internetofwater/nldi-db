--liquibase formatted sql

--changeset drsteini:add_prep_connections_dd.shape
select public.AddGeometryColumn('nhdplus_navigation', 'prep_connections_dd', 'shape', 4269, 'LINESTRINGM' ,3);
--rollback select public.DropGeometryColumn('nhdplus_navigation', 'prep_connections_dd', 'shape');

--changeset drsteini:add_prep_connections_dm.shape
select public.AddGeometryColumn('nhdplus_navigation', 'prep_connections_dm', 'shape', 4269, 'LINESTRINGM', 3);   
--rollback select public.DropGeometryColumn('nhdplus_navigation', 'prep_connections_dm', 'shape');

--changeset drsteini:add_prep_connections_um.shape
select public.AddGeometryColumn('nhdplus_navigation', 'prep_connections_um', 'shape', 4269, 'LINESTRINGM', 3);   
--rollback select public.DropGeometryColumn('nhdplus_navigation', 'prep_connections_um', 'shape');

--changeset drsteini:add_prep_connections_ut.shape
select public.AddGeometryColumn('nhdplus_navigation', 'prep_connections_ut', 'shape', 4269, 'LINESTRINGM', 3);
--rollback select public.DropGeometryColumn('nhdplus_navigation', 'prep_connections_ut', 'shape');

--changeset drsteini:add_tmp_navigation_results.shape
select public.AddGeometryColumn('nhdplus_navigation', 'tmp_navigation_results', 'shape', 4269, 'LINESTRINGM', 3);
--rollback select public.DropGeometryColumn('nhdplus_navigation', 'tmp_navigation_results', 'shape');
