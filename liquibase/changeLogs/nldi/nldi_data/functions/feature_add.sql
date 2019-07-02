create or replace function nldi_data.feature_add
(temptablename character varying
,crawlersourceid integer
,identifier character varying
,name character varying
,uri character varying
,location geometry
,reachcode character varying
,measure numeric
)
returns integer
language plpgsql
as $$
declare
num_updated integer;
begin
	execute 'insert into nldi_data.' || quote_ident(temptablename) || ' (crawler_source_id, identifier, name, uri, location, reachcode, measure)
		values ($1, $2, $3, $4, $5, $6, $7)'
		using crawlersourceid, identifier, name, uri, location, reachcode, measure;

	get diagnostics num_updated = row_count;
	return num_updated;
end
$$
