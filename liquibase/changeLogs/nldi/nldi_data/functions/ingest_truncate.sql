create or replace function nldi_data.ingest_truncate(tempTablename character varying)
returns void
language plpgsql
as $$
begin
	execute 'drop table if exists nldi_data.' || quote_ident(temptablename);
	execute 'create table nldi_data.' || quote_ident(temptablename) || ' (like nldi_data.feature)';
end
$$
