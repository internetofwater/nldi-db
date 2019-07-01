
CREATE OR REPLACE FUNCTION nhdplus_navigation.navigate_dnmain(p_navigation_type character varying, p_start_flowline nhdplus_navigation.flowline_rec, p_stop_flowline nhdplus_navigation.flowline_rec, p_stop_comid integer, p_stop_measure numeric, p_num_max_distance numeric, p_num_max_time numeric, p_start_path_length numeric, p_start_path_time numeric, INOUT p_stop_condition_met numeric, p_debug character varying DEFAULT 'FALSE'::character varying) RETURNS numeric
    LANGUAGE plpgsql
    AS $$ 
DECLARE
   boo_continue           BOOLEAN;
   boo_is_start_flowline  BOOLEAN;
   num_last_level_path    INTEGER;
   num_updated            INTEGER := 0;
   num_level_path_id      INTEGER;
   num_hydro_seq_no       INTEGER;
   num_min_hydro_seq      INTEGER;
   num_min_hydro_seq_dshs INTEGER;
   num_min_hydro_seq_dslp INTEGER;

   num_W_path_length      NUMERIC;
   num_W_lengthkm         NUMERIC;
   num_W_tomeas           NUMERIC;
   num_W_frommeas         NUMERIC;
   num_W_calc_meas        NUMERIC;
   num_W_calc_dis         NUMERIC;
   num_W_calc_time        NUMERIC;
   num_W_path_time        NUMERIC;
   num_W_trav_time        NUMERIC;
   str_message            VARCHAR(255);
   
BEGIN
   
   --------------------------------------------------------------------------
   -- Step 10
   -- Load information about the starting comid
   --------------------------------------------------------------------------
   num_hydro_seq_no  := p_start_flowline.hydroseq;
   num_level_path_id := p_start_flowline.levelpathid;

   --------------------------------------------------------------------------
   -- Step 20
   -- Prepare the main loop
   --------------------------------------------------------------------------
   num_last_level_path   := 0;
   boo_continue          := TRUE;
   boo_is_start_flowline := TRUE;
   
   IF p_debug = 'TRUE'
   THEN
       str_message := 'Starting downstream with hydroseq = ' || num_hydro_seq_no 
       || ' and levelpathid = ' || num_level_path_id;
       RAISE DEBUG '%', str_message;
       
   END IF;

   --------------------------------------------------------------------------
   -- Step 30
   -- Main Loop
   --------------------------------------------------------------------------
   WHILE boo_continue
   LOOP
      --Set the starting hydroseqno for upstream levelpaths that are
      --NOT the initial query
      IF NOT boo_is_start_flowline
      THEN
         num_level_path_id := num_min_hydro_seq_dslp;
         num_hydro_seq_no  := num_min_hydro_seq_dshs;
         
      END IF;

      IF num_last_level_path <> num_level_path_id
      AND num_level_path_id > 0
      AND num_hydro_seq_no > 0
      THEN
         --There is a downstream levelpath
         --Downstream levelpaths exist on the initial query and
         --when a particular levelpath ends and there is another below it
         num_last_level_path := num_level_path_id;
         boo_is_start_flowline := FALSE;

         IF p_num_max_distance IS NOT NULL
         THEN
            UPDATE tmp_navigation_working a 
            SET 
             selected  = 1
            ,ofmeasure = a.fmeasure
            ,otmeasure = a.tmeasure 
            WHERE
                a.terminalpathid =  p_start_flowline.terminalpathid
            AND a.levelpathid    =  num_level_path_id
            AND a.hydroseq       <= num_hydro_seq_no
            AND a.hydroseq       <> 0
            AND p_start_path_length - p_num_max_distance <= a.pathlength + a.lengthkm;
            
            GET DIAGNOSTICS num_updated = ROW_COUNT;
            
            IF p_debug = 'TRUE'
            THEN
               str_message := 'Adding ' || num_updated || ' records to selection.';
               RAISE DEBUG '%', str_message;
               
            END IF;

         ELSIF p_num_max_time IS NOT NULL
         THEN
            UPDATE tmp_navigation_working a 
            SET 
             selected  = 1
            ,ofmeasure = a.fmeasure
            ,otmeasure = a.tmeasure 
            WHERE 
                a.terminalpathid =  p_start_flowline.terminalpathid
            AND a.levelpathid    =  num_level_path_id
            AND a.hydroseq       <= num_hydro_seq_no
            AND a.hydroseq       <> 0
            AND p_start_path_time - p_num_max_time  <= a.pathtime + a.travtime;
            
            GET DIAGNOSTICS num_updated = ROW_COUNT;

         ELSIF p_stop_comid IS NOT NULL
         THEN
            UPDATE tmp_navigation_working a 
            SET 
             selected   = 1
            ,ofmeasure  = a.fmeasure
            ,otmeasure  = a.tmeasure
            WHERE 
                a.terminalpathid =  p_start_flowline.terminalpathid
            AND a.levelpathid    =  num_level_path_id
            AND a.hydroseq       <= num_hydro_seq_no
            AND a.hydroseq       >= p_stop_flowline.hydroseq;
            
            GET DIAGNOSTICS num_updated = ROW_COUNT;

         ELSE
            UPDATE tmp_navigation_working a 
            SET 
             selected  = 1
            ,ofmeasure = a.fmeasure
            ,otmeasure = a.tmeasure 
            WHERE 
                a.terminalpathid =  p_start_flowline.terminalpathid
            AND a.levelpathid    =  num_level_path_id
            AND a.hydroseq       <= num_hydro_seq_no
            AND a.hydroseq       <> 0;
            
            GET DIAGNOSTICS num_updated = ROW_COUNT;

         END IF;

         IF num_updated > 0
         THEN
            -----------------------------------------------------------------
            --Find Hydroseq of last record just updated.
            -----------------------------------------------------------------
            SELECT 
            MIN(a.hydroseq) 
            INTO num_min_hydro_seq
            FROM 
            tmp_navigation_working a 
            WHERE 
                a.selected       =  1
            AND a.terminalpathid =  p_start_flowline.terminalpathid
            AND a.levelpathid    =  num_level_path_id
            AND a.hydroseq       <= num_hydro_seq_no;
            
            IF p_debug = 'TRUE'
            THEN
               str_message := '   Minimum Hydroseq is ' || num_min_hydro_seq;
               RAISE DEBUG '%', str_message;
               
            END IF;

            -----------------------------------------------------------------
            -- Get infomation from the working record for the min hs to ...
            -- Prepare for next iteration
            --    update to1, totaldist if max distance has been reached.
            -----------------------------------------------------------------
            SELECT 
             a.dnhydroseq
            ,a.dnlevelpathid
            ,a.pathlength
            ,a.lengthkm
            ,a.pathtime
            ,a.travtime
            ,a.tmeasure 
            ,a.fmeasure 
            INTO 
             num_min_hydro_seq_dshs
            ,num_min_hydro_seq_dslp
            ,num_W_path_length
            ,num_W_lengthkm
            ,num_W_path_time
            ,num_W_trav_time
            ,num_W_tomeas
            ,num_W_frommeas
            FROM 
            tmp_navigation_working a 
            WHERE 
            a.hydroseq = num_min_hydro_seq;

            IF p_debug = 'TRUE'
            THEN
               str_message := '   tmeasure is ' || CAST(num_W_tomeas AS VARCHAR);
               RAISE DEBUG '%', str_message;
               
            END IF;
            
            -----------------------------------------------------------------
            -- Need numMinDsHS, numMinDSlp to prepare for next iteration of loop
            -- Need the remaiing fields to update from1 
            -- (and determine if from1 needs to be updated)
            -- Update to1, totaldist based on distance, 
            -- totaltime based on time if necessary
            -----------------------------------------------------------------
            IF p_num_max_distance IS NOT NULL
            THEN
            
               IF p_debug = 'TRUE'
               THEN
                  IF num_W_path_length < p_start_path_length - p_num_max_distance
                  THEN
                     str_message := '   ' || CAST(num_W_path_length AS VARCHAR) ||
                     ' is less than ' || CAST(p_start_path_length - p_num_max_distance AS VARCHAR);
                     RAISE DEBUG '%', str_message;
                     
                  ELSE
                     str_message := '   ' || CAST(num_W_path_length AS VARCHAR) ||
                     ' is NOT less than ' || CAST(p_start_path_length - p_num_max_distance AS VARCHAR);
                     RAISE DEBUG '%', str_message;
                     
                  END IF;
                   
               END IF;

               IF num_W_path_length < p_start_path_length - p_num_max_distance
               THEN
                  IF num_W_tomeas IS NOT NULL
                  THEN
                     --Reset to1 with a calculated measure and totaldist with maxdistance
                     num_W_calc_meas := nhdplus_navigation.measure_at_distance(
                         p_fmeasure      := num_W_frommeas
                        ,p_tmeasure      := num_W_tomeas
                        ,p_length        := num_W_lengthkm
                        ,p_distance      := (num_W_path_length + num_W_lengthkm) - (p_start_path_length - p_num_max_distance)
                        ,p_half          := 'TOP'
                     );

                     num_W_calc_time := nhdplus_navigation.included_distance(
                         p_fmeasure  := num_W_frommeas
                        ,p_tmeasure  := num_W_tomeas
                        ,p_length    := num_W_trav_time
                        ,p_measure   := num_W_calc_meas
                        ,p_half      := 'TOP'
                     );

                     UPDATE tmp_navigation_working a 
                     SET 
                      ofmeasure = num_W_calc_meas
                     ,totaldist = p_num_max_distance
                     ,totaltime = p_start_path_time - (num_W_path_time + (num_W_trav_time - num_W_calc_time))
                     WHERE 
                     a.hydroseq = num_min_hydro_seq;
                     
                     IF p_debug = 'TRUE'
                     THEN
                        str_message := '   updating ' || CAST(num_min_hydro_seq AS VARCHAR) ||
                        ' with ofmeasure = ' || CAST(num_W_calc_meas AS VARCHAR) ||
                        ' and totaldist = ' || CAST(p_num_max_distance AS VARCHAR) ||
                        ' and totaltime = ' || CAST(p_start_path_time - (num_W_path_time + (num_W_trav_time - num_W_calc_time)) AS VARCHAR);
                        RAISE DEBUG '%', str_message;
                        
                     END IF;

                  END IF;

                  boo_continue := FALSE; --Have reached the max distance, so stop

                  IF p_navigation_type = 'DM'
                  THEN
                     p_stop_condition_met := 1;
                     
                  END IF;

               END IF;

            ELSIF p_num_max_time IS NOT NULL
            THEN
               IF num_W_path_time < p_start_path_time - p_num_max_time
               THEN
                  IF num_W_tomeas IS NULL
                  THEN
                     NULL; --End NHDFlowline has null measures.  Do nothing.
                     
                  ELSE
                     --Reset to1 with a calculated measure and totaldist with maxdistance
                     num_W_calc_meas := nhdplus_navigation.measure_at_distance(
                         p_fmeasure      := num_W_frommeas
                        ,p_tmeasure      := num_W_tomeas
                        ,p_length        := num_W_trav_time
                        ,p_distance      := (num_W_path_time + num_W_trav_time) - (p_start_path_time - p_num_max_time)
                        ,p_half          := 'TOP'
                     );

                     num_W_calc_dis := nhdplus_navigation.included_distance(
                         p_fmeasure  := num_W_frommeas
                        ,p_tmeasure  := num_W_tomeas
                        ,p_length    := num_W_lengthkm
                        ,p_measure   := num_W_calc_meas
                        ,p_half      := 'TOP'
                     );

                     UPDATE tmp_navigation_working a 
                     SET 
                      ofmeasure = num_W_calc_meas
                     ,totaldist = p_start_path_length - (num_W_path_length + (num_W_lengthkm - num_W_calc_dis))
                     ,totaltime = p_num_max_time
                     WHERE 
                     a.hydroseq = num_min_hydro_seq;

                  END IF;

                  boo_continue := FALSE; --Have reached the max time, so stop

                  IF p_navigation_type = 'DM'
                  THEN
                     p_stop_condition_met := 1;
                     
                  END IF;

               END IF;

            ELSIF p_stop_comid IS NOT NULL 
            AND p_navigation_type = 'PP'
            THEN
               IF num_min_hydro_seq = p_stop_flowline.hydroseq
               THEN
                  IF num_W_tomeas IS NULL
                  THEN
                     NULL; --End NHDFlowline has null measures.  Do nothing.
                     
                  ELSE
                     --Reset to1 with user provided measure
                     --Calculate totaldist and totaltime
                     num_W_calc_meas := p_stop_measure;
                     
                     num_W_calc_dis := nhdplus_navigation.included_distance(
                         p_fmeasure  := num_W_frommeas
                        ,p_tmeasure  := num_W_tomeas
                        ,p_length    := num_W_lengthkm
                        ,p_measure   := num_W_calc_meas
                        ,p_half      := 'TOP'
                     );
                     
                     num_W_calc_time := nhdplus_navigation.included_distance(
                         p_fmeasure  := num_W_frommeas
                        ,p_tmeasure  := num_W_tomeas
                        ,p_length    := num_W_trav_time
                        ,p_measure   := num_W_calc_meas
                        ,p_half      := 'TOP'
                     );

                     UPDATE tmp_navigation_working a 
                     SET 
                      ofmeasure = num_W_calc_meas
                     ,totaldist = p_start_path_length - (num_W_path_length + (num_W_lengthkm - num_W_calc_dis))
                     ,totaltime = p_start_path_time - (num_W_path_time + (num_W_trav_time - num_W_calc_time)) 
                     WHERE 
                     a.hydroseq = num_min_hydro_seq;

                  END IF;

                  boo_continue := FALSE; --Have reached the stop comid, so stop
                  p_stop_condition_met := 1;

               END IF;

            END IF;
            
         ELSE
            --No more updates, do nothing
            NULL;
            
         END IF;

      ELSE
         --There are no more downstream queries, so stop
         boo_continue := FALSE;
         
      END IF;

   END LOOP;
   
END;
$$;


ALTER FUNCTION nhdplus_navigation.navigate_dnmain(p_navigation_type character varying, p_start_flowline nhdplus_navigation.flowline_rec, p_stop_flowline nhdplus_navigation.flowline_rec, p_stop_comid integer, p_stop_measure numeric, p_num_max_distance numeric, p_num_max_time numeric, p_start_path_length numeric, p_start_path_time numeric, INOUT p_stop_condition_met numeric, p_debug character varying) owner to ${NHDPLUS_SCHEMA_OWNER_USERNAME};
