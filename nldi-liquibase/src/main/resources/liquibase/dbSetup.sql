--liquibase formatted sql

--changeset drsteini:create_user_nhdplus
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_user where usename = 'nhdplus'
create user nhdplus with password '${POSTGRES_PASSWORD}';
--rollback drop user if exists nhdplus;

--changeset drsteini:create_user_nhdplus_navigation
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_user where usename = 'nhdplus_navigation'
create user nhdplus_navigation with password '${POSTGRES_PASSWORD}';
--rollback drop user if exists nhdplus_navigation;

--changeset drsteini:create_user_nhdplus_indexing
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_user where usename = 'nhdplus_indexing'
create user nhdplus_indexing with password '${POSTGRES_PASSWORD}';
--rollback drop user if exists nhdplus_indexing;

--changeset drsteini:create_user_nhdplus_delineation
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_user where usename = 'nhdplus_delineation'
create user nhdplus_delineation with password '${POSTGRES_PASSWORD}';
--rollback drop user if exists nhdplus_delineation;

--changeset drsteini:create_user_nldi_data
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_user where usename = 'nldi_data'
create user nldi_data with password '${POSTGRES_PASSWORD}';
--rollback drop user if exists nldi_data;


--changeset ayan:create_user_characteristic_data
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_user where usename = 'characteristic_data'
create user characteristic_data with password '${POSTGRES_PASSWORD}';
--rollback drop user if exists characteristic_data

--changeset drsteini:create_extension_postgis
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_available_extensions where name='postgis'and installed_version!='';
create extension postgis;
--rollback drop extension postgis;

--changeset drsteini:create_extension_postgis_topology
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_available_extensions where name='postgis_topology'and installed_version!='';
create extension postgis_topology;
--rollback drop extension postgis_topology;

--changeset drsteini:create_extension_uuid-ossp
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from pg_available_extensions where name='uuid-ossp'and installed_version!='';
create extension "uuid-ossp";
--rollback drop extension "uuid-ossp";

--changeset drsteini:alter_st_iscoveragetile_search_path-ossp
alter function st_iscoveragetile(raster,raster,integer,integer) set search_path=pg_catalog,public,postgis;
--rollback alter funtion st_iscoveragetile(raster,raster,integer,integer) reset search_path;

--changeset drsteini:alter_st_bandmetadata_a_search_path
alter function st_bandmetadata(raster,integer) set search_path=pg_catalog,public,postgis;
--rollback alter funtion st_bandmetadata(raster,integer) reset search_path;

--changeset drsteini:alter_st_bandmetadata_b_search_path
alter function st_bandmetadata(raster,integer[]) set search_path=pg_catalog,public,postgis;
--rollback alter funtion st_bandmetadata(raster,integer[]) reset search_path;

--changeset drsteini:alter_st_numbands_search_path
alter function st_numbands(raster) set search_path=pg_catalog,public,postgis;
--rollback alter funtion st_numbands(raster) reset search_path;

--changeset drsteini:alter_st_coveredby_a_search_path
alter function st_coveredby(raster,raster) set search_path=pg_catalog,public,postgis;
--rollback alter funtion st_coveredby(raster,raster) reset search_path;

--changeset drsteini:alter_st_coveredby_b_search_path
alter function st_coveredby(raster,integer,raster,integer) set search_path=pg_catalog,public,postgis;
--rollback alter funtion st_coveredby(raster,integer,raster,integer) reset search_path;

--changeset drsteini:alter_st_coveredby_c_search_path
alter function st_coveredby(geometry,geometry) set search_path=pg_catalog,public,postgis;
--rollback alter funtion st_coveredby(geometry,geometry) reset search_path;

--changeset drsteini:alter__raster_constraint_pixel_types_search_path
alter function _raster_constraint_pixel_types(raster) set search_path=pg_catalog,public,postgis;
--rollback alter funtion _raster_constraint_pixel_types(raster) reset search_path;

--changeset drsteini:alter__raster_constraint_nodata_values_search_path
alter function _raster_constraint_nodata_values(raster) set search_path=pg_catalog,public,postgis;
--rollback alter funtion _raster_constraint_nodata_values(raster) reset search_path;

--changeset drsteini:alter__raster_constraint_out_db_search_path
alter function _raster_constraint_out_db(raster) set search_path=pg_catalog,public,postgis;
--rollback alter funtion _raster_constraint_out_db(raster) reset search_path;

--changeset drsteini:alter__raster_constraint_info_regular_blocking_search_path
alter function _raster_constraint_info_regular_blocking(name,name,name) set search_path=pg_catalog,public,postgis;
--rollback alter funtion _raster_constraint_info_regular_blocking(name,name,name) reset search_path;

--changeset drsteini:alter__st_coveredby_a_search_path
alter function _st_coveredby(raster,integer,raster,integer) set search_path=pg_catalog,public,postgis;
--rollback alter funtion _st_coveredby(raster,integer,raster,integer) reset search_path;

--changeset drsteini:alter__st_coveredby_b_search_path
alter function _st_coveredby(geometry,geometry) set search_path=pg_catalog,public,postgis;
--rollback alter funtion _st_coveredby(geometry,geometry) reset search_path;

--changeset drsteini:insert_spatial_ref_sys_5070
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from spatial_ref_sys where srid = 5070;
insert into spatial_ref_sys(srid, auth_name, auth_srid, proj4text, srtext)
values (5070
        ,'NAD83 Continental US Albers Equal Area USGS'
        ,5070
        ,'+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs '
        ,'PROJCS["NAD83 Continental US Albers Equal Area USGS",GEOGCS["GCS_North_American_1983",DATUM["North_American_Datum_1983",SPHEROID["GRS_1980",6378137,298.257222101]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Albers_Conic_Equal_Area"],PARAMETER["False_Easting",0],PARAMETER["False_Northing",0],PARAMETER["longitude_of_center",-96],PARAMETER["Standard_Parallel_1",29.5],PARAMETER["Standard_Parallel_2",45.5],PARAMETER["latitude_of_center",23],UNIT["Meter",1],AUTHORITY["EPSG","5070"]]'
       );
--rollback delete from spatial_ref_sys where srid = 5070;

--changeset drsteini:insert_spatial_ref_sys_3338
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from spatial_ref_sys where srid = 3338;
insert into spatial_ref_sys(srid, auth_name, auth_srid, proj4text, srtext)
values (3338
        ,'NAD83 Alaska Albers Equal Area USGS'
        ,3338
        ,'+proj=aea +lat_1=55 +lat_2=65 +lat_0=50 +lon_0=-154 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs '
        ,'PROJCS["NAD83 Alaska Albers Equal Area USGS",GEOGCS["GCS_North_American_1983",DATUM["North_American_Datum_1983",SPHEROID["GRS_1980",6378137,298.257222101]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Albers_Conic_Equal_Area"],PARAMETER["False_Easting",0],PARAMETER["False_Northing",0],PARAMETER["longitude_of_center",-154],PARAMETER["Standard_Parallel_1",55],PARAMETER["Standard_Parallel_2",65],PARAMETER["latitude_of_center",50],UNIT["Meter",1],AUTHORITY["EPA OW","990003"]]'
       );
--rollback delete from spatial_ref_sys where srid = 3338;

--changeset drsteini:insert_spatial_ref_sys_990002
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from spatial_ref_sys where srid = 990002;
insert into spatial_ref_sys(srid, auth_name, auth_srid, proj4text, srtext)
values (990002
        ,'NAD83 Hawaii Albers Equal Area USGS'
        ,990002
        ,'+proj=aea +lat_1=8 +lat_2=18 +lat_0=3 +lon_0=-157 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs '
        ,'PROJCS["NAD83 Hawaii Albers Equal Area USGS",GEOGCS["GCS_North_American_1983",DATUM["North_American_Datum_1983",SPHEROID["GRS_1980",6378137,298.257222101]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Albers_Conic_Equal_Area"],PARAMETER["False_Easting",0],PARAMETER["False_Northing",0],PARAMETER["longitude_of_center",-157],PARAMETER["Standard_Parallel_1",8],PARAMETER["Standard_Parallel_2",18],PARAMETER["latitude_of_center",3],UNIT["Meter",1],AUTHORITY["EPA OW","990002"]]'
       );
--rollback delete from spatial_ref_sys where srid = 990002;

--changeset drsteini:insert_spatial_ref_sys_990004
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from spatial_ref_sys where srid = 990004;
insert into spatial_ref_sys(srid, auth_name, auth_srid, proj4text, srtext)
values (990004
        ,'NAD83 Puerto Rico/Virgin Islands Albers Equal Area USGS'
        ,990004
        ,'+proj=aea +lat_1=8 +lat_2=18 +lat_0=3 +lon_0=-66 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs '
        ,'PROJCS["NAD83 Puerto Rico/Virgin Islands Albers Equal Area USGS",GEOGCS["GCS_North_American_1983",DATUM["North_American_Datum_1983",SPHEROID["GRS_1980",6378137,298.257222101]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Albers_Conic_Equal_Area"],PARAMETER["False_Easting",0],PARAMETER["False_Northing",0],PARAMETER["longitude_of_center",-66],PARAMETER["Standard_Parallel_1",8],PARAMETER["Standard_Parallel_2",18],PARAMETER["latitude_of_center",3],UNIT["Meter",1],AUTHORITY["EPA OW","990004"]]'
       );
--rollback delete from spatial_ref_sys where srid = 990004;

--changeset drsteini:insert_spatial_ref_sys_990005
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(*) from spatial_ref_sys where srid = 990005;
insert into spatial_ref_sys(srid, auth_name, auth_srid, proj4text, srtext)
values (990005
        ,'NAD83 Pacific Trust Albers Equal Area USGS'
        ,990005
        ,'+proj=aea +lat_1=8 +lat_2=18 +lat_0=3 +lon_0=145 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs '
        ,'PROJCS["NAD83 Pacific Trust Albers Equal Area USGS",GEOGCS["GCS_North_American_1983",DATUM["North_American_Datum_1983",SPHEROID["GRS_1980",6378137,298.257222101]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Albers_Conic_Equal_Area"],PARAMETER["False_Easting",0],PARAMETER["False_Northing",0],PARAMETER["longitude_of_center",145],PARAMETER["Standard_Parallel_1",8],PARAMETER["Standard_Parallel_2",18],PARAMETER["latitude_of_center",3],UNIT["Meter",1],AUTHORITY["EPA OW","990005"]]'
       );
--rollback delete from spatial_ref_sys where srid = 990005;
