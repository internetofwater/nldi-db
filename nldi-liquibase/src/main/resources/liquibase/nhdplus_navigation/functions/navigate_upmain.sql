
CREATE OR REPLACE FUNCTION nhdplus_navigation.navigate_upmain(p_navigation_type character varying, p_start_flowline nhdplus_navigation.flowline_rec, p_num_max_distance numeric, p_num_max_time numeric, p_start_path_length numeric, p_start_path_time numeric, INOUT p_stop_condition_met numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $$ 
DECLARE
   boo_continue           BOOLEAN := TRUE;
   boo_is_first           BOOLEAN := TRUE;
   num_level_path_id      INTEGER;
   num_hydro_seq_no       INTEGER;
   num_max_hydro_seq      INTEGER;
   num_max_hydro_seq_ushs INTEGER;
   num_max_hydro_seq_uslp INTEGER;
   
   num_W_path_length      NUMERIC;
   num_W_lengthkm         NUMERIC;
   num_W_path_time        NUMERIC;
   num_W_trav_time        NUMERIC;
   num_W_tomeas           NUMERIC;
   num_W_frommeas         NUMERIC;
   num_W_calc_meas        NUMERIC;
   num_W_calc_time        NUMERIC;
   num_W_calc_dis         NUMERIC;
   
   num_updated            INTEGER := 0;
   r                      RECORD;
   
BEGIN
   
   --------------------------------------------------------------------------
   -- Step 10
   -- Get information about the starting comid
   -- This will always be the starting comid of the navigation itself
   --------------------------------------------------------------------------
   num_hydro_seq_no  := p_start_flowline.hydroseq;
   num_level_path_id := p_start_flowline.levelpathid;
   boo_continue      := TRUE;

   --------------------------------------------------------------------------
   -- Step 20
   -- MAIN loop
   --------------------------------------------------------------------------
   WHILE boo_continue
   LOOP
      --Set the starting hydroseqno for upstream levelpaths that are
      --NOT the initial query
      IF NOT boo_is_first
      THEN
         IF num_hydro_seq_no = num_max_hydro_seq_ushs
         THEN
            num_hydro_seq_no  := 0;
            
         ELSE
            num_hydro_seq_no  := num_max_hydro_seq_ushs;
            num_level_path_id := num_max_hydro_seq_uslp;
            
         END IF;
         
      END IF;

      IF num_hydro_seq_no <> 0
      THEN
         --There is an upstream levelpath
         --Upstream levelpaths exist on the initial query and
         --when a particular levelpath ends on a divergence = 2
         boo_is_first := FALSE;

         --Select (set selected = 1 ) for upstream levelpath

         IF p_num_max_distance IS NOT NULL
         THEN
            -- MaxDistance is the stop condition
            -- This is some screwy postgres shit
            WITH cte_update AS (
               UPDATE tmp_navigation_working a 
               SET 
                selected  = 1
               ,ofmeasure = a.fmeasure
               ,otmeasure = a.tmeasure 
               WHERE 
                   a.terminalpathid =  p_start_flowline.terminalpathid
               AND a.levelpathid    =  num_level_path_id 
               AND a.hydroseq       >= num_hydro_seq_no
               AND a.pathlength     <= p_start_path_length + p_num_max_distance
               RETURNING a.hydroseq
            )
            SELECT MAX(b.hydroseq) INTO num_max_hydro_seq FROM cte_update b;

         ELSIF p_num_max_time IS NOT NULL
         THEN
            --MaxTime is the stop condition
            WITH cte_update AS (
               UPDATE tmp_navigation_working a 
               SET 
                selected  = 1
               ,ofmeasure = a.fmeasure 
               ,otmeasure = a.tmeasure
               WHERE 
                   a.terminalpathid =  p_start_flowline.terminalpathid
               AND a.levelpathid    =  num_level_path_id 
               AND a.hydroseq       >= num_hydro_seq_no
               AND a.pathtime       <= p_start_path_time + p_num_max_time
               RETURNING a.hydroseq
            )
            SELECT MAX(b.hydroseq) INTO num_max_hydro_seq FROM cte_update b;
            
         ELSE
            --There is no stop condition
            WITH cte_update AS (
               UPDATE tmp_navigation_working a 
               SET 
                selected  = 1
               ,ofmeasure = a.fmeasure
               ,otmeasure = a.tmeasure 
               WHERE 
                   a.terminalpathid =  p_start_flowline.terminalpathid
               AND a.levelpathid    =  num_level_path_id 
               AND a.hydroseq       >= num_hydro_seq_no
               RETURNING a.hydroseq
            )
            SELECT MAX(b.hydroseq) INTO num_max_hydro_seq FROM cte_update b;
            
         END IF;
         
         GET DIAGNOSTICS num_updated = ROW_COUNT;

         IF num_updated > 0
         THEN
            -- Get infomation from the working record for the max hs to ...
            --  prepare for next iteration
            --  update to1, totaldist if max distance has been reached.
            SELECT 
            a.uphydroseq, 
            a.uplevelpathid, 
            a.pathlength, 
            a.lengthkm, 
            a.pathtime, 
            a.travtime, 
            a.tmeasure, 
            a.fmeasure 
            INTO 
             num_max_hydro_seq_ushs
            ,num_max_hydro_seq_uslp
            ,num_W_path_length
            ,num_W_lengthkm
            ,num_W_path_time
            ,num_W_trav_time
            ,num_W_tomeas
            ,num_W_frommeas
            FROM 
            tmp_navigation_working a 
            WHERE 
            a.hydroseq = num_max_hydro_seq;

            -----------------------------------------------------------------
            -- Need numMaxUsHS, numMaxUSlp to prepare for next iteration of loop
            -- Need numWPathlength, numWlengthkm, numWPathtime, numWTravtime, numWtomeas, numWfrommeas to update to1
            --  (and determine if to1 needs to be updated)
            -- Update to1, totaldist based on distance, and totaltime based on travel time if necessary
            -----------------------------------------------------------------
            IF p_num_max_distance IS NOT NULL
            THEN
               IF num_W_path_length + num_W_lengthkm > p_start_path_length + p_num_max_distance
               THEN
                  IF num_W_Tomeas IS NULL
                  THEN
                     --End NHDFlowline has null measures.  Do nothing.
                     NULL; 
                     
                  ELSE
                     -- Reset to1 with a calculated measure and totaldist with maxdistance 
                     -- and totaltime with calculated totaltime
                     num_W_calc_meas := nhdplus_navigation.measure_at_distance(
                         p_fmeasure      := num_W_frommeas
                        ,p_tmeasure      := num_W_tomeas
                        ,p_length        := num_W_lengthkm
                        ,p_distance      := p_start_path_length + p_num_max_distance - num_W_path_length
                        ,p_half          := 'BOTTOM'
                     );
                     
                     num_W_calc_time := nhdplus_navigation.included_distance(
                         p_fmeasure      := num_W_frommeas
                        ,p_tmeasure      := num_W_tomeas
                        ,p_length        := num_W_trav_time
                        ,p_measure       := num_w_calc_meas
                        ,p_half          := 'BOTTOM'
                     );

                     UPDATE tmp_navigation_working a 
                     SET 
                      otmeasure = num_W_calc_meas
                     ,totaldist = p_num_max_distance
                     ,totaltime = num_W_path_time + num_W_calc_time - p_start_path_time
                     WHERE 
                     a.hydroseq = num_max_hydro_seq;

                  END IF;

                  boo_continue := FALSE;

                  IF p_navigation_type = 'UM'
                  THEN
                     p_stop_condition_met := 1;
                     
                  END IF;
                  
               END IF;

            ELSIF p_num_max_time IS NOT NULL
            THEN
               IF num_W_path_time + num_W_trav_time > p_start_path_time + p_num_max_time
               THEN
                  IF num_W_tomeas IS NULL
                  THEN
                     NULL; --End NHDFlowline has null measures.  Do nothing.
                     
                  ELSE
                     --Reset to1 with a calculated measure and totaldist with maxdistance
                     num_W_calc_meas:= nhdplus_navigation.measure_at_distance(
                         p_fmeasure      := num_W_frommeas
                        ,p_tmeasure      := num_W_tomeas
                        ,p_length        := num_W_trav_time
                        ,p_distance      := p_start_path_time + p_num_max_time - num_W_path_time
                        ,p_half          := 'BOTTOM'
                     );
                     
                     num_W_calc_dis := nhdplus_navigation.included_distance(
                         p_fmeasure      := num_W_frommeas
                        ,p_tmeasure      := num_W_tomeas
                        ,p_length        := num_W_lengthkm
                        ,p_measure       := num_W_calc_meas
                        ,p_half          := 'BOTTOM'
                     );

                     UPDATE tmp_navigation_working a 
                     SET 
                      otmeasure = num_W_calc_meas
                     ,totaldist = num_W_path_length + num_W_calc_dis - p_start_path_length
                     ,totaltime = p_num_max_time
                     WHERE 
                     a.hydroseq = num_max_hydro_seq;

                  END IF;

                  boo_continue := FALSE;

                  IF p_navigation_type = 'UM'
                  THEN
                     p_stop_condition_met := 1;
                     
                  END IF;
                  
               END IF;

            END IF;

         ELSE
            boo_continue := FALSE;
            
         END IF;

      ELSE
         boo_continue := FALSE;

      END IF;

   END LOOP;
   
END;
$$;


ALTER FUNCTION nhdplus_navigation.navigate_upmain(p_navigation_type character varying, p_start_flowline nhdplus_navigation.flowline_rec, p_num_max_distance numeric, p_num_max_time numeric, p_start_path_length numeric, p_start_path_time numeric, INOUT p_stop_condition_met numeric) owner to ${NHDPLUS_SCHEMA_OWNER_USERNAME};
