create or replace function nldi_data.log_request_end
(p_web_service_log_id bigint
,p_http_status_code integer
)
returns void
language plpgsql
as $$
begin
    update nldi_data.web_service_log
       set http_status_code = p_http_status_code,
           request_completed_utc = current_timestamp at time zone 'UTC'
     where web_service_log_id = p_web_service_log_id;
end;
$$;
