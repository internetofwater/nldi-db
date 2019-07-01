
CREATE OR REPLACE FUNCTION nhdplus_navigation.navigate_cached(pnavigationtype character varying, pstartcomid integer, pstartpermanentidentifier character varying, pstartreachcode character varying, pstartmeasure numeric, pstopcomid integer, pstoppermanentidentifier character varying, pstopreachcode character varying, pstopmeasure numeric, pmaxdistancekm numeric, pmaxflowtimehour numeric, pdebug character varying DEFAULT 'FALSE'::character varying, paddflowlineattributes character varying DEFAULT 'FALSE'::character varying, paddflowlinegeometry character varying DEFAULT 'FALSE'::character varying, OUT poutstartcomid integer, OUT poutstartmeasure numeric, OUT poutstopcomid integer, OUT poutstopmeasure numeric, OUT preturncode numeric, OUT pstatusmessage character varying, INOUT psessionid character varying DEFAULT NULL::character varying) RETURNS record
    LANGUAGE plpgsql
    AS $$
DECLARE
   str_nav_type                   VARCHAR(4000) := UPPER(pNavigationType);
   num_maximum_distance_km        NUMERIC := pMaxDistanceKm;
   num_maximum_flowtime_hour      NUMERIC := pMaxFlowTimeHour;
   str_add_flowline_attributes    VARCHAR(4000) := UPPER(pAddFlowlineAttributes);
   str_add_flowline_geometry      VARCHAR(4000) := UPPER(pAddFlowlineGeometry);
   int_start_comid                INTEGER;
   str_start_permanent_identifier VARCHAR(40);
   num_start_measure              NUMERIC;
   num_start_path_length          NUMERIC;
   num_start_path_time            NUMERIC;
   num_start_inc_dist             NUMERIC;
   num_start_inc_time             NUMERIC;
   int_stop_comid                 INTEGER;
   str_stop_permanent_identifier  VARCHAR(40);
   num_stop_measure               NUMERIC;
   num_stop_inc_dist              NUMERIC;
   num_stop_inc_time              NUMERIC;
   num_stop_condition_met         NUMERIC;
   obj_start_flowline             nhdplus_navigation.flowline_rec;
   obj_stop_flowline              nhdplus_navigation.flowline_rec;
   r                              RECORD;
   int_return_code                INTEGER;
   int_navigation_count           INTEGER;
   
BEGIN
  
   --------------------------------------------------------------------------
   -- Step 10
   -- Check over incoming parameters
   --------------------------------------------------------------------------
   pReturnCode := 0;
   
   IF str_nav_type NOT IN ('UM','UT','DM','DD','PP')
   THEN
      pReturnCode    := -1;
      pStatusMessage := 'Valid navigation type codes are UM, UT, DM, DD and PP.';
      RETURN;
   
   END IF;
   
   IF str_nav_type = 'PP'
   THEN
      num_maximum_distance_km   := NULL;
      num_maximum_flowtime_hour := NULL;
      
   END IF;
   
   IF str_add_flowline_attributes IS NULL
   OR str_add_flowline_attributes NOT IN ('TRUE','FALSE')
   THEN
      str_add_flowline_attributes := 'FALSE';
      
   END IF;
   
   IF str_add_flowline_geometry IS NULL
   OR str_add_flowline_geometry NOT IN ('TRUE','FALSE')
   THEN
      str_add_flowline_geometry := 'FALSE';
      
   END IF;
   
   IF  str_add_flowline_geometry = 'TRUE'
   AND str_add_flowline_attributes = 'FALSE'
   THEN
      str_add_flowline_attributes = 'TRUE';
      
   END IF;
   
   --------------------------------------------------------------------------
   -- Step 20
   -- Verify or create the session id
   --------------------------------------------------------------------------
   IF pSessionID IS NULL
   THEN
      pSessionID := '{' || uuid_generate_v1() || '}';

      INSERT INTO
      nhdplus_navigation.navigation_cache_status(
          objectid
         ,session_id
         ,navigation_mode
         ,start_comid
         ,max_distance
         ,stop_comid
         ,session_datestamp
      ) VALUES (
          nextval('nhdplus_navigation.tmp_navigation_status_seq')
         ,pSessionID
         ,str_nav_type
         ,pstartcomid
         ,pMaxDistanceKm
         ,pstopcomid
         ,(abstime(('now'::text)::timestamp(6) with time zone))
      );

   END IF;
   
   --------------------------------------------------------------------------
   -- Step 20
   -- Run Navigation within the VPU
   --------------------------------------------------------------------------
   r := nhdplus_navigation.navigate_vpu_core(
       pNavigationType           := str_nav_type
      ,pStartComID               := pStartComID
      ,pStartPermanentIdentifier := pStartPermanentIdentifier
      ,pStartReachcode           := pStartReachcode
      ,pStartMeasure             := pStartMeasure
      ,pStopComID                := pStopComID
      ,pStopPermanentIdentifier  := pStopPermanentIdentifier
      ,pStopReachcode            := pStopReachcode
      ,pStopMeasure              := pStopMeasure
      ,pMaxDistanceKm            := num_maximum_distance_km
      ,pMaxFlowTimeHour          := num_maximum_flowtime_hour
      ,pSessionID                := pSessionID
      ,pDebug                    := pDebug
   );
   int_start_comid                := r.pCheckStartComID;
   str_start_permanent_identifier := r.pCheckStartPermanentIdentifier;
   num_start_measure              := r.pCheckStartMeasure;
   num_start_path_length          := r.pCheckStartPathLength;
   num_start_path_time            := r.pCheckStartPathTime;
   num_start_inc_dist             := r.pCheckStartIncDist;
   num_start_inc_time             := r.pCheckStartIncTime;
   int_stop_comid                 := r.pCheckStopComID;
   str_stop_permanent_identifier  := r.pCheckStopPermanentIdentifier;
   num_stop_measure               := r.pCheckStopMeasure;
   num_stop_inc_dist              := r.pCheckStopIncDist;
   num_stop_inc_time              := r.pCheckStopIncTime;
   num_stop_condition_met         := r.pCheckStopConditionMet;
   obj_start_flowline             := r.pCheckStartFlowline;
   obj_stop_flowline              := r.pCheckStopFlowline;
   pReturnCode                    := r.pReturnCode;
   pStatusMessage                 := r.pStatusMessage;
   
   -- Provide to out parameters for use by delineation
   pOutStartComID                 := r.pCheckStartComID;
   pOutStartMeasure               := r.pCheckStartMeasure;
   pOutStopComID                  := r.pCheckStopComID;
   pOutStopMeasure                := r.pCheckStopMeasure;

   --------------------------------------------------------------------------
   -- Step 30
   -- Do the IRC processes if stop condition has not been met
   --------------------------------------------------------------------------
   IF num_stop_condition_met <> 1
   THEN
      -- IRCProcess
      IF str_nav_type IN ('UM','UT')
      THEN
         int_return_code := nhdplus_navigation.irc_up_processing(
             p_navigation_type         := str_nav_type
            ,p_start_flowline          := obj_start_flowline
            ,p_num_max_distance        := num_maximum_distance_km
            ,p_num_max_time            := num_maximum_flowtime_hour
            ,p_start_path_length       := num_start_path_length
            ,p_start_path_time         := num_start_path_time
            ,p_add_flowline_attributes := str_add_flowline_attributes
            ,p_add_flowline_geometry   := str_add_flowline_geometry
            ,p_session_id              := pSessionID
         );
         
      ELSE
         int_return_code := nhdplus_navigation.irc_down_processing(
             p_navigation_type            := str_nav_type
            ,p_start_flowline             := obj_start_flowline
            ,p_stop_flowline              := obj_stop_flowline
            ,p_num_max_distance           := num_maximum_distance_km
            ,p_num_max_time               := num_maximum_flowtime_hour
            ,p_start_path_length          := num_start_path_length
            ,p_start_path_time            := num_start_path_time
            ,p_start_comid                := int_start_comid
            ,p_start_permanent_identifier := str_start_permanent_identifier
            ,p_start_measure              := num_start_measure
            ,p_stop_comid                 := int_stop_comid
            ,p_stop_permanent_identifier  := str_stop_permanent_identifier 
            ,p_stop_measure               := num_stop_measure
            ,p_start_inc_dist             := num_start_inc_dist
            ,p_add_flowline_attributes    := str_add_flowline_attributes
            ,p_add_flowline_geometry      := str_add_flowline_geometry
            ,p_session_id                 := pSessionID
         );
         
      END IF;
      
   END IF;

   --------------------------------------------------------------------------
   -- Step 40
   -- Update measures and distances
   --------------------------------------------------------------------------
   IF str_nav_type IN ('UM','UT')
   THEN
      --Populate totaldist field in navigation results table
      UPDATE nhdplus_navigation.tmp_navigation_results a 
      SET 
      totaldist = a.pathlength + a.lengthkm - num_start_path_length
      WHERE 
          a.session_id = pSessionID
      AND a.totaldist IS NULL;

      --Populate totaltime field in navigation results table
      UPDATE nhdplus_navigation.tmp_navigation_results a 
      SET 
      totaltime = a.pathtime + a.travtime - num_start_path_time 
      WHERE 
          a.session_id = pSessionID
      AND a.totaltime IS NULL;

      --Update from1,totaldist of start record (based on user supplied startmeas)
      UPDATE nhdplus_navigation.tmp_navigation_results a 
      SET 
       fmeasure  = num_start_measure
      ,totaldist = num_start_inc_dist
      ,totaltime = num_start_inc_time 
      WHERE 
          a.session_id = pSessionID
      AND a.nhdplus_comid = int_start_comid;

   ELSIF str_nav_type IN ('DM','DD','PP')
   THEN
      --Populate totaldist field in navigation results table
      UPDATE nhdplus_navigation.tmp_navigation_results a 
      SET 
      totaldist = num_start_path_length - a.pathlength 
      WHERE 
          a.session_id = pSessionID
      AND a.totaldist IS NULL;

      --Populate totaltime field in navigation results table
      UPDATE nhdplus_navigation.tmp_navigation_results a 
      SET 
      totaltime = num_start_path_time - a.pathtime 
      WHERE 
          a.session_id = pSessionID
      AND a.totaltime IS NULL;

      --Update to1,totaldist of start record (based on user supplied startmeas)
      UPDATE nhdplus_navigation.tmp_navigation_results a 
      SET 
       tmeasure  = num_start_measure 
      ,totaldist = num_start_inc_dist
      WHERE 
          a.session_id = pSessionID
      AND a.nhdplus_comid = int_start_comid;
   
   ELSE
      RAISE EXCEPTION 'err';
      
   END IF;

   --------------------------------------------------------------------------
   -- Step 50
   -- Deal with top of headwater condition
   --------------------------------------------------------------------------
   UPDATE nhdplus_navigation.tmp_navigation_results a 
   SET 
    fmeasure = 99.999
   WHERE
       a.session_id = pSessionID
   AND a.fmeasure = 100
   AND a.tmeasure = 100
   AND a.uphydroseq = 0;

   --------------------------------------------------------------------------
   -- Step 60
   -- Recalculate modified flowlines, need reasonable where clause here
   --------------------------------------------------------------------------
   UPDATE nhdplus_navigation.tmp_navigation_results a 
   SET 
    lengthkm = (a.tmeasure - a.fmeasure) * a.length_measure_ratio
   ,travtime = (a.tmeasure - a.fmeasure) * a.time_measure_ratio
   WHERE
   a.session_id = pSessionID;
   
   --------------------------------------------------------------------------
   -- Step 70
   -- Add flowline attributes if requested
   --------------------------------------------------------------------------
   IF str_add_flowline_attributes = 'TRUE'
   THEN
      IF str_add_flowline_geometry = 'TRUE'
      THEN
         UPDATE nhdplus_navigation.tmp_navigation_results a 
         SET
          reachsmdate                 = b.reachsmdate
         ,ftype                       = b.ftype
         ,fcode                       = b.fcode
         ,gnis_id                     = b.gnis_id
         ,wbarea_permanent_identifier = b.wbarea_permanent_identifier
         ,wbarea_nhdplus_comid        = b.wbarea_nhdplus_comid
         ,wbd_huc12                   = b.wbd_huc12
         ,catchment_featureid         = b.catchment_featureid
         ,shape                       = CASE
                                        WHEN a.fmeasure <> b.fmeasure
                                        OR   a.tmeasure <> b.tmeasure
                                        THEN
                                           ST_GeometryN(ST_LocateBetween(b.shape,a.fmeasure,a.tmeasure),1)
                                        ELSE
                                           b.shape
                                        END
         FROM 
         nhdplus.nhdflowline_np21 b
         WHERE
             a.session_id = pSessionID
         AND b.nhdplus_comid = a.nhdplus_comid;
         
      ELSE
         UPDATE nhdplus_navigation.tmp_navigation_results a 
         SET 
          reachsmdate                 = b.reachsmdate
         ,ftype                       = b.ftype
         ,fcode                       = b.fcode
         ,gnis_id                     = b.gnis_id
         ,wbarea_permanent_identifier = b.wbarea_permanent_identifier
         ,wbarea_nhdplus_comid        = b.wbarea_nhdplus_comid
         ,wbd_huc12                   = b.wbd_huc12
         ,catchment_featureid         = b.catchment_featureid
         FROM
         nhdplus.nhdflowline_np21 b
         WHERE
             a.session_id = pSessionID
         AND b.nhdplus_comid = a.nhdplus_comid;
         
      END IF;
   
   END IF;
   
   -----------------------------------------------------------------------------
   -- Step 80
   -- Exit with zero
   -----------------------------------------------------------------------------
   UPDATE nhdplus_navigation.navigation_cache_status a
   SET
    return_code    = pReturnCode
   ,status_message = pStatusMessage
   WHERE
   a.session_id = pSessionID;
   
END;
$$;


ALTER FUNCTION nhdplus_navigation.navigate_cached(pnavigationtype character varying, pstartcomid integer, pstartpermanentidentifier character varying, pstartreachcode character varying, pstartmeasure numeric, pstopcomid integer, pstoppermanentidentifier character varying, pstopreachcode character varying, pstopmeasure numeric, pmaxdistancekm numeric, pmaxflowtimehour numeric, pdebug character varying, paddflowlineattributes character varying, paddflowlinegeometry character varying, OUT poutstartcomid integer, OUT poutstartmeasure numeric, OUT poutstopcomid integer, OUT poutstopmeasure numeric, OUT preturncode numeric, OUT pstatusmessage character varying, INOUT psessionid character varying) owner to ${NHDPLUS_SCHEMA_OWNER_USERNAME};
