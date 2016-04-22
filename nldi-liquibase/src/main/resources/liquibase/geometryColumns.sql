--liquibase formatted sql

--changeset drsteini:add_prep_connections_dd.shape
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from geometry_columns where f_table_schema = 'nhdplus_navigation' and f_table_name = 'prep_connections_dd' and f_geometry_column = 'shape'
select public.AddGeometryColumn('nhdplus_navigation', 'prep_connections_dd', 'shape', 4269, 'LINESTRINGM' ,3);
--rollback select public.DropGeometryColumn('nhdplus_navigation', 'prep_connections_dd', 'shape');

--changeset drsteini:add_prep_connections_dm.shape
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from geometry_columns where f_table_schema = 'nhdplus_navigation' and f_table_name = 'prep_connections_dm' and f_geometry_column = 'shape'
select public.AddGeometryColumn('nhdplus_navigation', 'prep_connections_dm', 'shape', 4269, 'LINESTRINGM', 3);   
--rollback select public.DropGeometryColumn('nhdplus_navigation', 'prep_connections_dm', 'shape');

--changeset drsteini:add_prep_connections_um.shape
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from geometry_columns where f_table_schema = 'nhdplus_navigation' and f_table_name = 'prep_connections_um' and f_geometry_column = 'shape'
select public.AddGeometryColumn('nhdplus_navigation', 'prep_connections_um', 'shape', 4269, 'LINESTRINGM', 3);   
--rollback select public.DropGeometryColumn('nhdplus_navigation', 'prep_connections_um', 'shape');

--changeset drsteini:add_prep_connections_ut.shape
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from geometry_columns where f_table_schema = 'nhdplus_navigation' and f_table_name = 'prep_connections_ut' and f_geometry_column = 'shape'
select public.AddGeometryColumn('nhdplus_navigation', 'prep_connections_ut', 'shape', 4269, 'LINESTRINGM', 3);
--rollback select public.DropGeometryColumn('nhdplus_navigation', 'prep_connections_ut', 'shape');

--changeset drsteini:add_tmp_navigation_results.shape
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from geometry_columns where f_table_schema = 'nhdplus_navigation' and f_table_name = 'tmp_navigation_results' and f_geometry_column = 'shape'
select public.AddGeometryColumn('nhdplus_navigation', 'tmp_navigation_results', 'shape', 4269, 'LINESTRINGM', 3);
--rollback select public.DropGeometryColumn('nhdplus_navigation', 'tmp_navigation_results', 'shape');
