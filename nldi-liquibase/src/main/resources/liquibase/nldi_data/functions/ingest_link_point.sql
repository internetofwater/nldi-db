create or replace function nldi_data.ingest_link_point(temptablename character varying)
returns integer
language plpgsql
as $$
declare
num_updated integer;
begin
	execute 'update nldi_data.' || quote_ident(temptablename) || ' upd_table
		        set comid = featureid
		       from nldi_data.' || quote_ident(temptablename) || ' src_table
		            join nhdplus.catchmentsp
		              on ST_covers(catchmentsp.the_geom, src_table.location)
		      where upd_table.crawler_source_id = src_table.crawler_source_id and 
		            upd_table.identifier = src_table.identifier';

	get diagnostics num_updated = row_count;
	return num_updated;
end
$$
