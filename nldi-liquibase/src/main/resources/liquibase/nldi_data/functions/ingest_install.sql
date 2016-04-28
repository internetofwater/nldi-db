create or replace function nldi_data.ingest_install(tablename character varying, temptablename character varying, oldtablename character varying)
returns void
language plpgsql
as $$
begin
	execute 'drop table if exists nldi_data.' || quote_ident(oldtablename);
	execute 'alter table if exists nldi_data.' || quote_ident(tablename) || ' no inherit nldi_data.feature';
	execute 'alter table nldi_data.' || quote_ident(temptablename) || ' inherit nldi_data.feature';
	execute 'alter table if exists nldi_data.' || quote_ident(tablename) || ' rename to ' || quote_ident(oldtablename);
	execute 'alter table nldi_data.' || quote_ident(temptablename) || ' rename to ' || quote_ident(tablename);
	execute 'alter table if exists nldi_data.' || quote_ident(oldtablename) || ' rename to ' || quote_ident(temptablename);
end
$$
