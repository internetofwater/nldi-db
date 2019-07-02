create or replace function nldi_data.ingest_link_reach_measure(temptablename character varying)
returns integer
language plpgsql
as $$
declare
num_updated integer;
begin
	execute 'update nldi_data.' || quote_ident(temptablename) || ' upd_table
		        set comid = nhdflowline_np21.nhdplus_comid
		       from nldi_data.' || quote_ident(temptablename) || ' src_table
		            join nhdplus.nhdflowline_np21
		              on nhdflowline_np21.reachcode = src_table.reachcode and
		                 src_table.measure between nhdflowline_np21.fmeasure and nhdflowline_np21.tmeasure
		      where upd_table.crawler_source_id = src_table.crawler_source_id and 
		            upd_table.identifier = src_table.identifier';

	get diagnostics num_updated = row_count;
	return num_updated;
end
$$
