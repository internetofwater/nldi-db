create or replace function nldi_data.log_request_start
(p_referer character varying
,p_user_agent character varying
,p_request_uri character varying
,p_query_string character varying
)
returns bigint
language plpgsql
as $$
declare
l_web_service_log_id bigint;
begin
    insert into nldi_data.web_service_log (referer, user_agent, request_uri, query_string)
    values (p_referer, p_user_agent, p_request_uri, p_query_string)
    returning web_service_log_id into l_web_service_log_id;

    return l_web_service_log_id;
end;
$$;