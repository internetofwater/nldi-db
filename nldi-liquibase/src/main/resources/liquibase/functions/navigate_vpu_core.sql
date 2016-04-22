
CREATE OR REPLACE FUNCTION nhdplus_navigation.navigate_vpu_core(pnavigationtype character varying, pstartcomid integer, pstartpermanentidentifier character varying, pstartreachcode character varying, pstartmeasure numeric, pstopcomid integer, pstoppermanentidentifier character varying, pstopreachcode character varying, pstopmeasure numeric, pmaxdistancekm numeric, pmaxflowtimehour numeric, psessionid character varying, pdebug character varying DEFAULT 'FALSE'::character varying, OUT pcheckstartcomid integer, OUT pcheckstartpermanentidentifier character varying, OUT pcheckstartmeasure numeric, OUT pcheckstartpathlength numeric, OUT pcheckstartpathtime numeric, OUT pcheckstartincdist numeric, OUT pcheckstartinctime numeric, OUT pcheckstopcomid integer, OUT pcheckstoppermanentidentifier character varying, OUT pcheckstopmeasure numeric, OUT pcheckstopincdist numeric, OUT pcheckstopinctime numeric, OUT pcheckstopconditionmet numeric, OUT pcheckstartflowline nhdplus_navigation.flowline_rec, OUT pcheckstopflowline nhdplus_navigation.flowline_rec, OUT preturncode numeric, OUT pstatusmessage character varying) RETURNS record
    LANGUAGE plpgsql
    AS $$
DECLARE
   str_nav_type              VARCHAR(4000) := UPPER(pNavigationType);
   num_maximum_distance_km   NUMERIC := pMaxDistanceKm;
   num_maximum_flowtime_hour NUMERIC := pMaxFlowTimeHour;
   num_count                 NUMERIC;
   num_measure_range         NUMERIC;
   int_return_code           INTEGER;
   r                         RECORD;
      
BEGIN
   
   -----------------------------------------------------------------------------
   -- Step 10
   -- Check over incoming parameters
   -----------------------------------------------------------------------------
   pReturnCode                    := 0;
   
   pCheckStartComID               := pStartComID;
   pCheckStartPermanentIdentifier := pStartPermanentIdentifier;
   pCheckStartMeasure             := pStartMeasure;
   
   pCheckStopComID                := pStopComID;
   pCheckStopPermanentIdentifier  := pStopPermanentIdentifier;
   pCheckStopMeasure              := pStopMeasure;
   
   pCheckStopConditionMet         := 0;
   
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
   
   -----------------------------------------------------------------------------
   -- Step 20
   -- Flush or create the temp tables
   -----------------------------------------------------------------------------
   int_return_code := nhdplus_navigation.create_temp_tables();
   
   --------------------------------------------------------------------------
   -- Step 30
   -- Load start flowline
   --------------------------------------------------------------------------
   r := nhdplus_navigation.query_single_flowline(
       p_navigation_type      := str_nav_type
      ,p_comid                := pCheckStartComID
      ,p_permanent_identifier := pCheckStartPermanentIdentifier
      ,p_hydrosequence        := NULL
      ,p_reachcode            := pStartReachcode 
      ,p_measure              := pCheckStartMeasure
      ,p_check_intent         := NULL
   );
   pCheckStartFlowline            := r.p_output;
   pCheckStartComID               := r.p_check_comid;
   pCheckStartPermanentIdentifier := r.p_check_permanent_identifier;
   pCheckStartMeasure             := r.p_check_measure;
   pReturnCode                    := r.p_return_code;
   pStatusMessage                 := r.p_status_message;
   
   IF pReturnCode <> 0
   THEN
      RETURN;
       
   END IF;
   
   IF pDebug = 'TRUE'
   THEN
      RAISE DEBUG 'start flowline: %', pCheckStartPermanentIdentifier;
      RAISE DEBUG 'start measure: %', pCheckStartMeasure;
      
   END IF;
   
   --------------------------------------------------------------------------
   -- Step 30
   -- Load stop flowline if required
   --------------------------------------------------------------------------
   IF str_nav_type = 'PP'
   THEN
      r := nhdplus_navigation.query_single_flowline(
          p_navigation_type      := NULL
         ,p_comid                := pCheckStopComID
         ,p_permanent_identifier := pCheckStopPermanentIdentifier
         ,p_hydrosequence        := NULL
         ,p_reachcode            := pStopReachcode 
         ,p_measure              := pCheckStopMeasure
         ,p_check_intent         := 'STOP'
      );
      pCheckStopFlowline            := r.p_output;
      pCheckStopComID               := r.p_check_comid;
      pCheckStopPermanentIdentifier := r.p_check_permanent_identifier;
      pCheckStopMeasure             := r.p_check_measure;
      pReturnCode                   := r.p_return_code;
      pStatusMessage                := r.p_status_message;
       
      IF pReturnCode <> 0
      THEN
         RETURN;
           
      END IF;
      
      IF  pCheckStartFlowline.hydroseq < pCheckStopFlowline.hydroseq
      AND pCheckStartFlowline.nhdplus_region = pCheckStopFlowline.nhdplus_region
      THEN
         pReturnCode    := 310;
         pStatusMessage := 'Start ComID must have a hydroseq greater than the hydroseq for stop ComID.';
         RETURN;
         
      END IF;
      
      IF pDebug = 'TRUE'
      THEN
         RAISE DEBUG 'stop flowline: %', pCheckStopPermanentIdentifier;
         RAISE DEBUG 'stop measure: %', pCheckStopMeasure;
         
      END IF;
   
   END IF;
   
   --------------------------------------------------------------------------
   -- Step 40
   -- Account for PP navigation shorter than the flowline
   --------------------------------------------------------------------------
   IF str_nav_type = 'PP'
   AND pCheckStartComID = pCheckStopComID
   THEN
      IF pCheckStartMeasure <= pCheckStopMeasure
      THEN
         pReturnCode    := 311;
         pStatusMessage := 'Start measure must be greater than stop measure when navigating a single reach.';
         RETURN;
       
      END IF;
      
      num_measure_range       := pCheckStartMeasure - pCheckStopMeasure;  
      
      pCheckStartIncDist      := ROUND(num_measure_range * pCheckStartFlowline.length_measure_ratio,5);
      pCheckStartIncTime      := ROUND(num_measure_range * pCheckStartFlowline.time_measure_ratio,5);
      
      INSERT INTO tmp_navigation_working(
          start_permanent_identifier
         ,permanent_identifier
         ,start_nhdplus_comid
         ,nhdplus_comid
         ,reachcode
         ,fmeasure
         ,tmeasure
         ,totaldist
         ,totaltime
         ,hydroseq
         ,levelpathid
         ,terminalpathid
         ,uphydroseq
         ,uplevelpathid
         ,dnhydroseq
         ,dnlevelpathid
         ,dnminorhyd
         ,divergence
         ,dndraincount
         ,pathlength
         ,lengthkm
         ,length_measure_ratio
         ,pathtime
         ,travtime
         ,time_measure_ratio
         ,ofmeasure
         ,otmeasure
         ,selected
         ,nhdplus_region
         ,nhdplus_version
      ) VALUES (
          pCheckStartFlowline.permanent_identifier
         ,pCheckStartFlowline.permanent_identifier
         ,pCheckStartFlowline.nhdplus_comid 
         ,pCheckStartFlowline.nhdplus_comid 
         ,pCheckStartFlowline.reachcode
         ,pCheckStopMeasure
         ,pCheckStartMeasure
         ,pCheckStartIncDist
         ,pCheckStartIncTime           
         ,pCheckStartFlowline.hydroseq
         ,pCheckStartFlowline.levelpathid
         ,pCheckStartFlowline.terminalpathid
         ,pCheckStartFlowline.uphydroseq
         ,pCheckStartFlowline.uplevelpathid
         ,pCheckStartFlowline.dnhydroseq
         ,pCheckStartFlowline.dnlevelpathid
         ,NULL 
         ,NULL
         ,NULL
         ,pCheckStartIncDist  -- path length
         ,pCheckStartFlowline.lengthkm
         ,pCheckStartFlowline.length_measure_ratio
         ,pCheckStartIncTime  --path time
         ,pCheckStartFlowline.travtime
         ,pCheckStartFlowline.time_measure_ratio
         ,pCheckStopMeasure
         ,pCheckStartMeasure
         ,1
         ,pCheckStartFlowline.nhdplus_region
         ,pCheckStartFlowline.nhdplus_version
      );
            
      pCheckStopConditionMet := 1;
      
   END IF;
   
   --------------------------------------------------------------------------
   -- Step 50
   -- Account for DD,DM,UM,UT navigation shorter than the flowline
   --------------------------------------------------------------------------
   IF num_maximum_distance_km IS NOT NULL
   OR num_maximum_flowtime_hour IS NOT NULL
   THEN
      IF str_nav_type IN ('UM','UT')
      AND num_maximum_distance_km IS NOT NULL
      AND num_maximum_distance_km <= (pCheckStartFlowline.tmeasure - pCheckStartMeasure) * pCheckStartFlowline.length_measure_ratio
      THEN
         num_measure_range       := num_maximum_distance_km / pCheckStartFlowline.length_measure_ratio;
         
         pCheckStartIncDist      := ROUND(num_measure_range * pCheckStartFlowline.length_measure_ratio,5);
         pCheckStartIncTime      := ROUND(num_measure_range * pCheckStartFlowline.time_measure_ratio,5);
         
         INSERT INTO tmp_navigation_working(
             start_permanent_identifier
            ,permanent_identifier
            ,start_nhdplus_comid
            ,nhdplus_comid
            ,reachcode
            ,fmeasure
            ,tmeasure
            ,totaldist
            ,totaltime
            ,hydroseq
            ,levelpathid
            ,terminalpathid
            ,uphydroseq
            ,uplevelpathid
            ,dnhydroseq
            ,dnlevelpathid
            ,dnminorhyd
            ,divergence
            ,dndraincount
            ,pathlength
            ,lengthkm
            ,length_measure_ratio
            ,pathtime
            ,travtime
            ,time_measure_ratio
            ,ofmeasure
            ,otmeasure
            ,selected
            ,nhdplus_region
            ,nhdplus_version
         ) VALUES (
             pCheckStartFlowline.permanent_identifier
            ,pCheckStartFlowline.permanent_identifier
            ,pCheckStartFlowline.nhdplus_comid
            ,pCheckStartFlowline.nhdplus_comid
            ,pCheckStartFlowline.reachcode
            ,pCheckStartMeasure
            ,ROUND(pCheckStartMeasure + num_measure_range,5)
            ,num_maximum_distance_km
            ,pCheckStartIncTime          
            ,pCheckStartFlowline.hydroseq
            ,pCheckStartFlowline.levelpathid
            ,pCheckStartFlowline.terminalpathid
            ,pCheckStartFlowline.uphydroseq
            ,pCheckStartFlowline.uplevelpathid
            ,pCheckStartFlowline.dnhydroseq
            ,pCheckStartFlowline.dnlevelpathid
            ,NULL 
            ,NULL
            ,NULL
            ,pCheckStartIncDist
            ,pCheckStartFlowline.lengthkm
            ,pCheckStartFlowline.length_measure_ratio
            ,pCheckStartIncTime
            ,pCheckStartFlowline.travtime
            ,pCheckStartFlowline.time_measure_ratio
            ,pCheckStartMeasure
            ,ROUND(pCheckStartMeasure + num_measure_range,5)
            ,1
            ,pCheckStartFlowline.nhdplus_region
            ,pCheckStartFlowline.nhdplus_version
         );
            
         pCheckStopConditionMet := 1;
         
      ELSIF str_nav_type IN ('UM','UT')
      AND num_maximum_flowtime_hour IS NOT NULL
      AND num_maximum_flowtime_hour <= (pCheckStartFlowline.tmeasure - pCheckStartMeasure) * pCheckStartFlowline.time_measure_ratio  
      THEN
         num_measure_range      := num_maximum_flowtime_hour / pCheckStartFlowline.time_measure_ratio;
         
         pCheckStartIncDist      := ROUND(num_measure_range * pCheckStartFlowline.length_measure_ratio,5);
         pCheckStartIncTime      := ROUND(num_measure_range * pCheckStartFlowline.time_measure_ratio,5);
            
         INSERT INTO tmp_navigation_working(
             start_permanent_identifier
            ,permanent_identifier
            ,start_nhdplus_comid
            ,nhdplus_comid
            ,reachcode
            ,fmeasure
            ,tmeasure
            ,totaldist
            ,totaltime
            ,hydroseq
            ,levelpathid
            ,terminalpathid
            ,uphydroseq
            ,uplevelpathid
            ,dnhydroseq
            ,dnlevelpathid
            ,dnminorhyd
            ,divergence
            ,dndraincount
            ,pathlength
            ,lengthkm
            ,length_measure_ratio
            ,pathtime
            ,travtime
            ,time_measure_ratio
            ,ofmeasure
            ,otmeasure
            ,selected
            ,nhdplus_region
            ,nhdplus_version
         ) VALUES (
             pCheckStartFlowline.permanent_identifier
            ,pCheckStartFlowline.permanent_identifier
            ,pCheckStartFlowline.nhdplus_comid
            ,pCheckStartFlowline.nhdplus_comid
            ,pCheckStartFlowline.reachcode
            ,pCheckStartMeasure
            ,ROUND(pCheckStartMeasure + num_measure_range,5)
            ,pCheckStartIncDist
            ,num_maximum_flowtime_hour         
            ,pCheckStartFlowline.hydroseq
            ,pCheckStartFlowline.levelpathid
            ,pCheckStartFlowline.terminalpathid
            ,pCheckStartFlowline.uphydroseq
            ,pCheckStartFlowline.uplevelpathid
            ,pCheckStartFlowline.dnhydroseq
            ,pCheckStartFlowline.dnlevelpathid
            ,NULL 
            ,NULL
            ,NULL
            ,pCheckStartIncDist
            ,pCheckStartFlowline.lengthkm
            ,pCheckStartFlowline.length_measure_ratio
            ,pCheckStartIncTime
            ,pCheckStartFlowline.travtime
            ,pCheckStartFlowline.time_measure_ratio
            ,pCheckStartMeasure
            ,ROUND(pCheckStartMeasure + num_measure_range,5)
            ,1
            ,pCheckStartFlowline.nhdplus_region
            ,pCheckStartFlowline.nhdplus_version
         );
            
         pCheckStopConditionMet := 1;
      
      ELSIF str_nav_type IN ('DM','DD')
      AND num_maximum_distance_km IS NOT NULL
      AND num_maximum_distance_km <= (pCheckStartMeasure - pCheckStartFlowline.fmeasure) * pCheckStartFlowline.length_measure_ratio 
      THEN
         num_measure_range       := num_maximum_distance_km / pCheckStartFlowline.length_measure_ratio;
         pCheckStartIncDist      := ROUND(num_measure_range * pCheckStartFlowline.length_measure_ratio,5);
         pCheckStartIncTime      := ROUND(num_measure_range * pCheckStartFlowline.time_measure_ratio,5);
               
         INSERT INTO tmp_navigation_working(
             start_permanent_identifier
            ,permanent_identifier
            ,start_nhdplus_comid
            ,nhdplus_comid
            ,reachcode
            ,fmeasure
            ,tmeasure
            ,totaldist
            ,totaltime
            ,hydroseq
            ,levelpathid
            ,terminalpathid
            ,uphydroseq
            ,uplevelpathid
            ,dnhydroseq
            ,dnlevelpathid
            ,dnminorhyd
            ,divergence
            ,dndraincount
            ,pathlength
            ,lengthkm
            ,length_measure_ratio
            ,pathtime
            ,travtime
            ,time_measure_ratio
            ,ofmeasure
            ,otmeasure
            ,selected
            ,nhdplus_region
            ,nhdplus_version
         ) VALUES (
             pCheckStartFlowline.permanent_identifier
            ,pCheckStartFlowline.permanent_identifier
            ,pCheckStartFlowline.nhdplus_comid
            ,pCheckStartFlowline.nhdplus_comid
            ,pCheckStartFlowline.reachcode
            ,ROUND(pCheckStartMeasure - num_measure_range,5)
            ,pCheckStartMeasure
            ,num_maximum_distance_km
            ,num_measure_range * pCheckStartFlowline.time_measure_ratio      
            ,pCheckStartFlowline.hydroseq
            ,pCheckStartFlowline.levelpathid
            ,pCheckStartFlowline.terminalpathid
            ,pCheckStartFlowline.uphydroseq
            ,pCheckStartFlowline.uplevelpathid
            ,pCheckStartFlowline.dnhydroseq
            ,pCheckStartFlowline.dnlevelpathid
            ,NULL 
            ,NULL
            ,NULL
            ,pCheckStartIncDist
            ,pCheckStartFlowline.lengthkm
            ,pCheckStartFlowline.length_measure_ratio
            ,pCheckStartIncTime
            ,pCheckStartFlowline.travtime
            ,pCheckStartFlowline.time_measure_ratio
            ,ROUND(pCheckStartMeasure - num_measure_range,5)
            ,pCheckStartMeasure
            ,1
            ,pCheckStartFlowline.nhdplus_region
            ,pCheckStartFlowline.nhdplus_version
         );
               
         pCheckStopConditionMet := 1;
               
      ELSIF str_nav_type IN ('DM','DD')
      AND num_maximum_flowtime_hour IS NOT NULL
      AND num_maximum_flowtime_hour <= (pCheckStartMeasure - pCheckStartFlowline.fmeasure) * pCheckStartFlowline.time_measure_ratio
      THEN
         num_measure_range  := num_maximum_flowtime_hour / pCheckStartFlowline.time_measure_ratio;
         pCheckStartIncDist := ROUND(num_measure_range * pCheckStartFlowline.length_measure_ratio,5);
         pCheckStartIncTime := ROUND(num_measure_range * pCheckStartFlowline.time_measure_ratio,5);
               
         INSERT INTO tmp_navigation_working(
             start_permanent_identifier
            ,permanent_identifier
            ,start_nhdplus_comid
            ,nhdplus_comid
            ,reachcode
            ,fmeasure
            ,tmeasure
            ,totaldist
            ,totaltime
            ,hydroseq
            ,levelpathid
            ,terminalpathid
            ,uphydroseq
            ,uplevelpathid
            ,dnhydroseq
            ,dnlevelpathid
            ,dnminorhyd
            ,divergence
            ,dndraincount
            ,pathlength
            ,lengthkm
            ,length_measure_ratio
            ,pathtime
            ,travtime
            ,time_measure_ratio
            ,ofmeasure
            ,otmeasure
            ,selected
            ,nhdplus_region
            ,nhdplus_version
         ) VALUES (
             pCheckStartFlowline.permanent_identifier
            ,pCheckStartFlowline.permanent_identifier
            ,pCheckStartFlowline.nhdplus_comid
            ,pCheckStartFlowline.nhdplus_comid
            ,pCheckStartFlowline.reachcode
            ,ROUND(pCheckStartMeasure - num_measure_range,5)
            ,pCheckStartMeasure
            ,num_measure_range * pCheckStartFlowline.length_measure_ratio
            ,num_maximum_flowtime_hour     
            ,pCheckStartFlowline.hydroseq
            ,pCheckStartFlowline.levelpathid
            ,pCheckStartFlowline.terminalpathid
            ,pCheckStartFlowline.uphydroseq
            ,pCheckStartFlowline.uplevelpathid
            ,pCheckStartFlowline.dnhydroseq
            ,pCheckStartFlowline.dnlevelpathid
            ,NULL 
            ,NULL
            ,NULL
            ,pCheckStartIncDist
            ,pCheckStartFlowline.lengthkm
            ,pCheckStartFlowline.length_measure_ratio
            ,pCheckStartIncTime
            ,pCheckStartFlowline.travtime
            ,pCheckStartFlowline.time_measure_ratio
            ,ROUND(pCheckStartMeasure - num_measure_range,5)
            ,pCheckStartMeasure
            ,1
            ,pCheckStartFlowline.nhdplus_region
            ,pCheckStartFlowline.nhdplus_version
         );
               
         pCheckStopConditionMet := 1;
            
      END IF;
      
   END IF;

   --------------------------------------------------------------------------
   -- Step 60
   -- Run reference calculations
   --------------------------------------------------------------------------
   IF pCheckStopConditionMet <> 1
   THEN
      r := nhdplus_navigation.reference_calculations(
          p_navigation_type   := str_nav_type
         ,p_start_measure     := pCheckStartMeasure
         ,p_start_flowline    := pCheckStartFlowline
         ,p_num_max_distance  := num_maximum_distance_km
         ,p_num_max_time      := num_maximum_flowtime_hour
      );
      pCheckStartPathLength := r.p_start_path_length;
      pCheckStartPathTime   := r.p_start_path_time;
      pCheckStartIncDist    := r.p_start_inc_dist;
      pCheckStartIncTime    := r.p_start_inc_time;
  
      IF pDebug = 'TRUE'
      THEN
         RAISE DEBUG 'Start Path Length: %', pCheckStartPathLength;
         RAISE DEBUG 'Start Inc Distance: %', pCheckStartIncDist;
               
      END IF;
         
   END IF;
     
   --------------------------------------------------------------------------
   -- Step 70
   -- Prepare the working table
   --------------------------------------------------------------------------
   IF pCheckStopConditionMet <> 1
   THEN
      int_return_code := nhdplus_navigation.prepare_working_table(
          p_navigation_type   := str_nav_type
         ,p_num_max_distance  := num_maximum_distance_km
         ,p_num_max_time      := num_maximum_flowtime_hour
         ,p_start_flowline    := pCheckStartFlowline
         ,p_stop_flowline     := pCheckStopFlowline
         ,p_start_path_length := pCheckStartPathLength
         ,p_start_path_time   := pCheckStartPathTime
      );
         
      IF pDebug = 'TRUE'
      THEN
         SELECT COUNT(*) INTO num_count FROM tmp_navigation_working;
         RAISE DEBUG 'prepare working table: %', num_count;
            
      END IF;
      
   END IF;
   
   --------------------------------------------------------------------------
   -- Step 90
   -- Process Upstream Variations
   --------------------------------------------------------------------------
   IF  str_nav_type IN ('UM','UT')
   AND pCheckStopConditionMet <> 1
   THEN
      pCheckStopConditionMet := nhdplus_navigation.navigate_upmain(
          p_navigation_type    := str_nav_type
         ,p_start_flowline     := pCheckStartFlowline
         ,p_num_max_distance   := num_maximum_distance_km
         ,p_num_max_time       := num_maximum_flowtime_hour
         ,p_start_path_length  := pCheckStartPathLength
         ,p_start_path_time    := pCheckStartPathTime
         ,p_stop_condition_met := pCheckStopConditionMet
      );
      
      IF pDebug = 'TRUE'
      THEN
         SELECT COUNT(*) INTO num_count FROM tmp_navigation_working;
         RAISE DEBUG 'navigate upmain: %', num_count;
         
      END IF;
      
      IF str_nav_type = 'UT'
      THEN
         pCheckStopConditionMet := nhdplus_navigation.navigate_uptrib(
             p_navigation_type    := str_nav_type
            ,p_start_flowline     := pCheckStartFlowline
            ,p_num_max_distance   := num_maximum_distance_km
            ,p_num_max_time       := num_maximum_flowtime_hour
            ,p_start_path_length  := pCheckStartPathLength
            ,p_start_path_time    := pCheckStartPathTime
            ,p_stop_condition_met := pCheckStopConditionMet
         );
         
         IF pDebug = 'TRUE'
         THEN
            SELECT COUNT(*) INTO num_count FROM tmp_navigation_working;
            RAISE DEBUG 'navigate uptrib: %', num_count;
            
         END IF;
      
      END IF;
   
   END IF;

   --------------------------------------------------------------------------
   -- Step 100
   -- Process Downstream Variations
   --------------------------------------------------------------------------
   IF  str_nav_type IN ('DM','DD','PP')
   AND pCheckStopConditionMet <> 1
   THEN        
      pCheckStopConditionMet := nhdplus_navigation.navigate_dnmain(
          p_navigation_type    := str_nav_type
         ,p_start_flowline     := pCheckStartFlowline
         ,p_stop_flowline      := pCheckStopFlowline
         ,p_stop_comid         := pCheckStopComID
         ,p_stop_measure       := pCheckStopMeasure
         ,p_num_max_distance   := num_maximum_distance_km
         ,p_num_max_time       := num_maximum_flowtime_hour
         ,p_start_path_length  := pCheckStartPathLength
         ,p_start_path_time    := pCheckStartPathTime
         ,p_stop_condition_met := pCheckStopConditionMet
         ,p_debug              := pDebug 
      );

      IF str_nav_type = 'DD'
      THEN
         int_return_code := nhdplus_navigation.navigate_dndiv(
             p_navigation_type    := str_nav_type
            ,p_start_flowline     := pCheckStartFlowline
            ,p_stop_flowline      := pCheckStopFlowline
            ,p_num_max_distance   := num_maximum_distance_km
            ,p_num_max_time       := num_maximum_flowtime_hour
            ,p_start_path_length  := pCheckStartPathLength
            ,p_start_path_time    := pCheckStartPathTime
         );
         
      ELSIF str_nav_type = 'PP'
      THEN
         SELECT
         COUNT(*)
         INTO num_count
         FROM
         tmp_navigation_working a
         WHERE
         a.nhdplus_comid = pCheckStopFlowline.nhdplus_comid AND
         a.selected = 1;
/*
         IF num_count <> 1
         THEN
            pReturnCode    := 311;
            pStatusMessage := 'Stop ComID not in downmain path from start ComID.';
            RETURN;
                 
         END IF;
*/       
      END IF;
   
   END IF;
   
   --------------------------------------------------------------------------
   -- Step 110
   -- Load the results tables
   --------------------------------------------------------------------------
   IF  str_nav_type IN ('UM','UT')
   THEN
      INSERT INTO nhdplus_navigation.tmp_navigation_results(
          objectid
         ,session_id
         ,start_permanent_identifier
         ,permanent_identifier
         ,start_nhdplus_comid
         ,nhdplus_comid
         ,reachcode
         ,fmeasure
         ,tmeasure
         ,totaldist
         ,totaltime
         ,hydroseq
         ,levelpathid
         ,terminalpathid
         ,uphydroseq
         ,dnhydroseq
         ,pathlength
         ,lengthkm
         ,length_measure_ratio
         ,pathtime
         ,travtime
         ,time_measure_ratio
         ,ofmeasure
         ,otmeasure
         ,nhdplus_region
         ,nhdplus_version
      ) 
      SELECT 
       nextval('nhdplus_navigation.tmp_navigation_results_seq')
      ,pSessionID
      ,a.start_permanent_identifier
      ,a.permanent_identifier
      ,a.start_nhdplus_comid
      ,a.nhdplus_comid
      ,a.reachcode
      ,ROUND(a.ofmeasure,5)
      ,ROUND(a.otmeasure,5)
      ,a.totaldist
      ,a.totaltime
      ,a.hydroseq
      ,a.levelpathid
      ,a.terminalpathid
      ,a.uphydroseq
      ,a.dnhydroseq
      ,a.pathlength
      ,a.lengthkm
      ,a.length_measure_ratio
      ,a.pathtime
      ,a.travtime
      ,a.time_measure_ratio
      ,ROUND(a.fmeasure,5)
      ,ROUND(a.tmeasure,5) 
      ,a.nhdplus_region
      ,a.nhdplus_version
      FROM 
      tmp_navigation_working a 
      WHERE 
      a.selected >= 1 
      ORDER BY 
      a.hydroseq;
      
   ELSIF str_nav_type IN ('DM','DD','PP')
   THEN
      INSERT INTO nhdplus_navigation.tmp_navigation_results(
          objectid
         ,session_id
         ,start_permanent_identifier
         ,permanent_identifier
         ,start_nhdplus_comid
         ,nhdplus_comid
         ,reachcode
         ,fmeasure
         ,tmeasure
         ,totaldist
         ,totaltime
         ,hydroseq
         ,levelpathid
         ,terminalpathid
         ,uphydroseq
         ,dnhydroseq
         ,pathlength
         ,lengthkm
         ,length_measure_ratio
         ,pathtime
         ,travtime
         ,time_measure_ratio
         ,ofmeasure
         ,otmeasure
         ,nhdplus_region
         ,nhdplus_version
      ) 
      SELECT 
       nextval('nhdplus_navigation.tmp_navigation_results_seq')
      ,pSessionID
      ,a.start_permanent_identifier
      ,a.permanent_identifier
      ,a.start_nhdplus_comid
      ,a.nhdplus_comid
      ,a.reachcode
      ,ROUND(a.ofmeasure,5)
      ,ROUND(a.otmeasure,5)
      ,a.totaldist
      ,a.totaltime
      ,a.hydroseq
      ,a.levelpathid
      ,a.terminalpathid
      ,a.uphydroseq
      ,a.dnhydroseq
      ,a.pathlength
      ,a.lengthkm
      ,a.length_measure_ratio
      ,a.pathtime
      ,a.travtime
      ,a.time_measure_ratio
      ,ROUND(a.fmeasure,5)
      ,ROUND(a.tmeasure,5)
      ,a.nhdplus_region
      ,a.nhdplus_version
      FROM 
      tmp_navigation_working a 
      WHERE 
      a.selected >= 1 
      ORDER BY
      a.hydroseq DESC;
      
   END IF;
      
END;
$$;


ALTER FUNCTION nhdplus_navigation.navigate_vpu_core(pnavigationtype character varying, pstartcomid integer, pstartpermanentidentifier character varying, pstartreachcode character varying, pstartmeasure numeric, pstopcomid integer, pstoppermanentidentifier character varying, pstopreachcode character varying, pstopmeasure numeric, pmaxdistancekm numeric, pmaxflowtimehour numeric, psessionid character varying, pdebug character varying, OUT pcheckstartcomid integer, OUT pcheckstartpermanentidentifier character varying, OUT pcheckstartmeasure numeric, OUT pcheckstartpathlength numeric, OUT pcheckstartpathtime numeric, OUT pcheckstartincdist numeric, OUT pcheckstartinctime numeric, OUT pcheckstopcomid integer, OUT pcheckstoppermanentidentifier character varying, OUT pcheckstopmeasure numeric, OUT pcheckstopincdist numeric, OUT pcheckstopinctime numeric, OUT pcheckstopconditionmet numeric, OUT pcheckstartflowline nhdplus_navigation.flowline_rec, OUT pcheckstopflowline nhdplus_navigation.flowline_rec, OUT preturncode numeric, OUT pstatusmessage character varying) OWNER TO nhdplus_navigation;
