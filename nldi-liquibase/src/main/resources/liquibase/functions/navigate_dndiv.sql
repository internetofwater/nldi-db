
CREATE OR REPLACE FUNCTION nhdplus_navigation.navigate_dndiv(p_navigation_type character varying, p_start_flowline nhdplus_navigation.flowline_rec, p_stop_flowline nhdplus_navigation.flowline_rec, p_num_max_distance numeric, p_num_max_time numeric, p_start_path_length numeric, p_start_path_time numeric) RETURNS integer
    LANGUAGE plpgsql
    AS $$ 
DECLARE
   boo_continue             BOOLEAN := TRUE;
   num_first                INTEGER := 1;
   num_finished             INTEGER;
   num_updated              INTEGER;

   int_start_comid          INTEGER;
   num_start_measure        NUMERIC;
   num_termid               INTEGER;
   num_level_path_id        INTEGER;
   num_hydro_seq_no         INTEGER;

   num_last_level_path      INTEGER;
   num_min_hydro_seq        INTEGER;
   num_min_hydro_seq_dshs   INTEGER;
   num_min_hydro_seq_dslp   INTEGER;
   num_last_level_path_main INTEGER;
   num_last_hydro_seq_main  INTEGER;

   num_W_path_length        NUMERIC;
   num_W_lengthkm           NUMERIC;
   num_W_path_time          NUMERIC;
   num_W_trav_time          NUMERIC;
   num_W_tomeas             NUMERIC;
   num_W_frommeas           NUMERIC;
   num_W_calc_meas          NUMERIC;
   num_W_calc_time          NUMERIC;
   num_W_calc_dis           NUMERIC;

   num_starting_path_length NUMERIC;
   num_starting_path_time   NUMERIC;

   num_max_distance         NUMERIC;
   num_max_time             NUMERIC;
   num_dist_at_top          NUMERIC := 0;
   num_time_at_top          NUMERIC := 0;
   num_bottom_path_length   NUMERIC := 0;
   num_bottom_path_time     NUMERIC := 0;

   num_div_count            INTEGER;
   listDivs                 nhdplus_navigation.listDivs_rec[];
   boo_skip                 BOOLEAN;
   r                        RECORD;
   
BEGIN
   
   --------------------------------------------------------------------------
   -- Step 10
   -- Get the last levelpath and hs to make sure a navigation from
   -- a divergence does not go past this point.
   --------------------------------------------------------------------------
   SELECT 
    a.hydroseq 
   ,a.levelpathid 
   INTO 
    num_last_hydro_seq_main
   ,num_last_level_path_main
   FROM 
   tmp_navigation_working a 
   WHERE 
       a.selected = 1 
   AND a.hydroseq = ( 
      SELECT 
      MIN(b.hydroseq) 
      FROM 
      tmp_navigation_working b 
      WHERE 
      b.selected = 1 
   );

   num_finished  := 0;
   num_div_count := 0;
   num_updated   := 0;

   WHILE num_finished = 0
   LOOP
      num_finished := 1;
      
      r := nhdplus_navigation.divergences(
          p_list_divs        := listDivs
         ,p_divergence_count := num_div_count
      );
      listDivs      := r.p_list_divs;
      num_div_count := r.p_divergence_count;

      IF listDivs IS NOT NULL
      AND array_length(listDivs,1) > 0
      THEN
         FOR i IN 1 .. array_length(listDivs,1)
         LOOP
            --If this drain divergence has not been procesed...
            IF listDivs[i].done = 0
            THEN
               listDivs[i] := (
                   listDivs[i].permanent_identifier
                  ,listDivs[i].nhdplus_comid
                  ,listDivs[i].fmeasure
                  ,listDivs[i].tmeasure
                  ,listDivs[i].hydroseq
                  ,listDivs[i].pathlength
                  ,listDivs[i].pathtime
                  ,listDivs[i].lengthkm
                  ,listDivs[i].travtime
                  ,listDivs[i].terminalpathid
                  ,listDivs[i].levelpathid
                  ,listDivs[i].uphydroseq
                  ,listDivs[i].divergence
                  ,1        -- done
                  ,listDivs[i].nhdplus_region
                  ,listDivs[i].nhdplus_version         
               )::nhdplus_navigation.listDivs_rec;
   
               num_finished      := 0;
   
               int_start_comid   := listDivs[i].nhdplus_comid;
               num_start_measure := listDivs[i].tmeasure;
               num_termid        := listDivs[i].terminalpathid;
               num_hydro_seq_no  := listDivs[i].hydroseq;
               num_level_path_id := listDivs[i].levelpathid;
   
               num_first    := 1;
               boo_continue := TRUE;
               boo_skip     := FALSE;
   
               -------------------------------------------------
               --Special DownMain navigation
               --   Stop navigating if a levelpath has already
               --   been navigated.
               -------------------------------------------------
               BEGIN
                  SELECT DISTINCT 
                   a.pathlength
                  ,a.pathtime
                  ,a.totaldist
                  ,a.totaltime 
                  INTO STRICT
                   num_starting_path_length
                  ,num_starting_path_time
                  ,num_dist_at_top
                  ,num_time_at_top
                  FROM 
                  tmp_navigation_working a 
                  WHERE 
                  a.hydroseq = listDivs[i].uphydroseq;
   
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     --------------------------------------------------------
                     -- This situation seems to occur when the service
                     -- encounters an intersection whereby two branches
                     -- touch but do not merge.  This step is checking that
                     -- the upstream flowline is in the list, but in this
                     -- case it never is.
                     --------------------------------------------------------
                     IF listDivs[i].divergence >= 2
                     THEN
                        -- We assume that this is OK
                        boo_skip := TRUE;
                        
                     ELSE
                        RAISE EXCEPTION 'err';
                        
                     END IF;
   
                  WHEN OTHERS
                  THEN
                     RAISE EXCEPTION 'err';
   
               END;
   
               IF boo_skip = FALSE
               THEN
                  IF num_dist_at_top IS NULL
                  THEN
                     --upstream hydroseq is along the main path
                     num_dist_at_top := p_start_path_length - num_starting_path_length;
                     
                  END IF;
   
                  IF num_time_at_top IS NULL
                  THEN
                     --upstream hydroseq is along the main path
                     num_time_at_top := p_start_path_time - num_starting_path_time;
                     
                  END IF;
   
                  --Adjust StartingPL and maxdistance for this start
                  IF p_num_max_distance IS NOT NULL
                  THEN
                     num_max_distance       := p_num_max_distance - num_dist_at_top; -- distance yet to travel
                     num_bottom_path_length := listDivs[i].pathlength + listDivs[i].lengthkm - num_max_distance;
   
                     IF num_max_distance <= 0
                     THEN
                        boo_continue := FALSE;
                        
                     END IF;
   
                  ELSIF p_num_max_time IS NOT NULL
                  THEN
                     num_max_time         := p_num_max_distance - num_time_at_top;
                     num_bottom_path_time := listDivs[i].pathtime + listDivs[i].travtime - num_max_time;
   
                     IF num_max_time <= 0
                     THEN
                        boo_continue := FALSE;
                        
                     END IF;
   
                  END IF;
   
                  --------------------------------------------------------------
                  -- DOWN MAIN loop
                  --------------------------------------------------------------
                  IF boo_continue
                  THEN
                     num_last_level_path := 0;
                     boo_continue := TRUE;
   
                     WHILE boo_continue
                     LOOP
                        --Set the starting hydroseqno for downstream levelpaths that are
                        --NOT the initial query
                        IF num_first = 0
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
                           num_first := 0;
   
                           IF p_num_max_distance IS NOT NULL
                           THEN
                              IF num_last_level_path_main <> num_level_path_id
                              THEN
                                 UPDATE tmp_navigation_working a 
                                 SET 
                                  selected  = 1
                                 ,ofmeasure = a.fmeasure
                                 ,otmeasure = a.tmeasure
                                 ,totaldist = num_dist_at_top + (
                                     SELECT 
                                     SUM(b.lengthkm) 
                                     FROM 
                                     tmp_navigation_working b 
                                     WHERE 
                                         b.levelpathid =  num_level_path_id
                                     AND b.hydroseq    <= num_hydro_seq_no
                                     AND b.hydroseq    >= a.hydroseq
                                  )
                                 ,totaltime = num_time_at_top + (
                                     SELECT 
                                     SUM(c.travtime) 
                                     FROM 
                                     tmp_navigation_working c 
                                     WHERE 
                                         c.levelpathid =  num_level_path_id
                                     AND c.hydroseq    <= num_hydro_seq_no
                                     AND c.hydroseq    >= a.hydroseq
                                  ) 
                                 WHERE 
                                     a.selected    =  0
                                 AND a.levelpathid =  num_level_path_id
                                 AND a.hydroseq    <= num_hydro_seq_no
                                 AND a.hydroseq    <> 0
                                 AND a.pathlength + a.lengthkm >= num_bottom_path_length;
   
                                 GET DIAGNOSTICS num_updated = ROW_COUNT;
   
                              ELSE
                                 --Special case to make sure we don't go
                                 --past the main path end point
                                 UPDATE tmp_navigation_working a 
                                 SET 
                                  selected  = 1 
                                 ,ofmeasure = a.fmeasure
                                 ,otmeasure = a.tmeasure
                                 ,totaldist = num_dist_at_top + (
                                     SELECT 
                                     SUM(b.lengthkm) 
                                     FROM 
                                     tmp_navigation_working b
                                     WHERE 
                                         b.levelpathid =  num_level_path_id
                                     AND b.hydroseq   <= num_hydro_seq_no 
                                     AND b.hydroseq   >= a.hydroseq 
                                  )
                                 ,totaltime = num_time_at_top + (
                                     SELECT
                                     SUM(c.travtime)
                                     FROM
                                     tmp_navigation_working c
                                     WHERE
                                         c.levelpathid =  num_level_path_id
                                     AND c.hydroseq    <= num_hydro_seq_no
                                     AND c.hydroseq    >= a.hydroseq
                                  )
                                 WHERE
                                     a.selected    =  0
                                 AND a.levelpathid =  num_level_path_id
                                 AND a.hydroseq    <= num_hydro_seq_no
                                 AND a.hydroseq    >  num_last_hydro_seq_main
                                 AND a.pathlength + a.lengthkm > num_bottom_path_length;
   
                                 GET DIAGNOSTICS num_updated = ROW_COUNT;
   
                              END IF;
   
                           ELSIF p_num_max_time IS NOT NULL
                           THEN
                              IF num_last_level_path_main <> num_level_path_id
                              THEN
                                 UPDATE tmp_navigation_working a 
                                 SET 
                                  selected  = 1
                                 ,ofmeasure = a.fmeasure
                                 ,otmeasure = a.tmeasure
                                 ,totaltime = num_time_at_top + (
                                     SELECT 
                                     SUM(b.travtime) 
                                     FROM 
                                     tmp_navigation_working b 
                                     WHERE 
                                         b.levelpathid =  num_level_path_id
                                     AND b.hydroseq    <= num_hydro_seq_no
                                     AND b.hydroseq    >= a.hydroseq 
                                  )
                                 ,totaldist = num_dist_at_top + (
                                     SELECT
                                     SUM(c.lengthkm)
                                     FROM
                                     tmp_navigation_working c
                                     WHERE
                                         c.levelpathid =  num_level_path_id
                                     AND c.hydroseq    <= num_hydro_seq_no
                                     AND c.hydroseq    >= a.hydroseq
                                  )
                                 WHERE 
                                     a.selected    =  0
                                 AND a.levelpathid =  num_level_path_id
                                 AND a.hydroseq    <= num_hydro_seq_no
                                 AND a.hydroseq    <> 0
                                 AND a.pathtime + a.travtime > num_bottom_path_time;
   
                                 GET DIAGNOSTICS num_updated = ROW_COUNT;
   
                              ELSE
                                 --Special case to make sure we don't go
                                 --past the main path end point
                                 UPDATE tmp_navigation_working a 
                                 SET 
                                  selected  = 1
                                 ,ofmeasure = a.fmeasure
                                 ,otmeasure = a.tmeasure
                                 ,totaltime = num_time_at_top + (
                                     SELECT 
                                     SUM(b.travtime) 
                                     FROM 
                                     tmp_navigation_working b 
                                     WHERE 
                                         b.levelpathid =  num_level_path_id
                                     AND b.hydroseq    <= num_hydro_seq_no
                                     AND b.hydroseq    >= a.hydroseq 
                                  )
                                 ,totaldist = num_dist_at_top + (
                                     SELECT 
                                     SUM(c.lengthkm) 
                                     FROM 
                                     tmp_navigation_working c 
                                     WHERE 
                                         c.levelpathid =  num_level_path_id
                                     AND c.hydroseq    <= num_hydro_seq_no
                                     AND c.hydroseq    >= a.hydroseq 
                                  ) 
                                 WHERE 
                                     a.selected    =  0
                                 AND a.levelpathid =  num_level_path_id
                                 AND a.hydroseq    <= num_hydro_seq_no
                                 AND a.hydroseq    >  num_last_hydro_seq_main
                                 AND a.pathtime + a.travtime > num_bottom_path_time;
   
                                 GET DIAGNOSTICS num_updated = ROW_COUNT;
   
                              END IF;
                              
                           ELSE
                              --Neither maxdistance or maxtime
                              UPDATE tmp_navigation_working a 
                              SET 
                               selected  = 1
                              ,ofmeasure = a.fmeasure
                              ,otmeasure = a.tmeasure
                              ,totaldist = num_dist_at_top + (
                                  SELECT 
                                  SUM(b.lengthkm) 
                                  FROM 
                                  tmp_navigation_working b 
                                  WHERE 
                                      b.levelpathid =  num_level_path_id
                                  AND b.hydroseq    <= num_hydro_seq_no
                                  AND b.hydroseq    >= a.hydroseq 
                               )
                              ,totaltime = num_time_at_top + (
                                  SELECT 
                                  SUM(c.travtime) 
                                  FROM 
                                  tmp_navigation_working c 
                                  WHERE 
                                      c.levelpathid = num_level_path_id
                                  AND c.hydroseq <= num_hydro_seq_no
                                  AND c.hydroseq >= a.hydroseq 
                               ) 
                              WHERE 
                                  a.selected    =  0
                              AND a.levelpathid =  num_level_path_id
                              AND a.hydroseq    <= num_hydro_seq_no
                              AND a.hydroseq    <> 0;
   
                              GET DIAGNOSTICS num_updated = ROW_COUNT;
   
                           END IF;
   
                           IF num_updated > 0
                           THEN
                              --Find Hydroseq of last record just updated.
                              SELECT 
                              MIN(a.hydroseq) 
                              INTO num_min_hydro_seq
                              FROM 
                              tmp_navigation_working a 
                              WHERE 
                                  a.selected    =  1
                              AND a.levelpathid =  num_level_path_id
                              AND a.hydroseq    <= num_hydro_seq_no;
   
                              --Get infomation from the working record for the min hs to ...
                              --    prepare for next iteration
                              --    update to1, totaldist if max distance has been reached.
                              SELECT 
                               a.dnhydroseq
                              ,a.dnlevelpathid
                              ,a.pathlength
                              ,a.lengthkm
                              ,a.pathtime
                              ,a.travtime
                              ,a.tmeasure
                              ,a.fmeasure
                              ,a.totaldist
                              ,a.totaltime 
                              INTO 
                               num_min_hydro_seq_dshs
                              ,num_min_hydro_seq_dslp
                              ,num_W_path_length
                              ,num_W_lengthkm
                              ,num_W_path_time
                              ,num_W_trav_time
                              ,num_W_tomeas
                              ,num_W_frommeas
                              ,num_dist_at_top
                              ,num_time_at_top
                              FROM 
                              tmp_navigation_working a 
                              WHERE 
                              a.hydroseq = num_min_hydro_seq;
   
                              --Need numMinDsHS, numMinDSlp to prepare for next iteration of loop
                              --Need numWPathlength, numWlengthkm, numWtomeas, numWfrommeas to update to1 (and determine if to1 needs
                              --      to be updated)
                              --Update to1, totaldist based on distance, if necessary
                              IF p_num_max_distance IS NOT NULL
                              THEN
                                 IF num_W_path_length < num_bottom_path_length
                                 THEN
                                    IF num_W_tomeas IS NULL
                                    THEN
                                       NULL; --End NHDFlowline has null measures.  Do nothing.
                                       
                                    ELSE
                                       --Reset to1 with a calculated measure and totaldist with maxdistance
                                       num_W_calc_meas := nhdplus_navigation.measure_at_distance(
                                           p_fmeasure      := num_W_frommeas
                                          ,p_tmeasure      := num_W_tomeas
                                          ,p_length        := num_W_lengthkm
                                          ,p_distance      := (num_W_path_length + num_W_lengthkm) - num_bottom_path_length
                                          ,p_half          := 'TOP'
                                       );
                                       
                                       num_W_calc_time := nhdplus_navigation.included_distance(
                                           p_fmeasure      := num_W_frommeas
                                          ,p_tmeasure      := num_W_tomeas
                                          ,p_length        := num_W_trav_time
                                          ,p_measure       := num_W_calc_meas
                                          ,p_half          := 'TOP'
                                       );
   
                                       UPDATE tmp_navigation_working a
                                       SET 
                                        ofmeasure = num_W_calc_meas
                                       ,totaldist = p_num_max_distance
                                       ,totaltime = a.totaltime - a.travtime + num_W_calc_time 
                                       WHERE 
                                       a.hydroseq = num_min_hydro_seq;
   
                                    END IF;
   
                                    boo_continue := FALSE;
                          
                                 END IF;
   
                              ELSIF p_num_max_time IS NOT NULL
                              THEN
                                 IF num_W_path_time < num_bottom_path_time
                                 THEN
                                    IF num_W_tomeas IS NULL
                                    THEN
                                       NULL; --End NHDFlowline has null measures.  Do nothing.
                                       
                                    ELSE
                                       -- Reset to1 with a calculated measure and totaldist with maxdistance
                                       num_W_calc_meas:= nhdplus_navigation.measure_at_distance(
                                           p_fmeasure      := num_W_frommeas
                                          ,p_tmeasure      := num_W_tomeas
                                          ,p_length        := num_W_trav_time
                                          ,p_distance      := (num_W_path_time + num_W_trav_time) - num_bottom_path_time
                                          ,p_half          := 'TOP'
                                       );
   
                                       num_W_calc_dis := nhdplus_navigation.included_distance(
                                           p_fmeasure      := num_W_frommeas
                                          ,p_tmeasure      := num_W_tomeas
                                          ,p_length        := num_W_lengthkm
                                          ,p_measure       := num_W_calc_meas
                                          ,p_half          := 'TOP'
                                       );
   
                                       UPDATE tmp_navigation_working a 
                                       SET 
                                        ofmeasure = num_W_calc_meas
                                       ,totaltime = p_num_max_time
                                       ,totaldist = a.totaldist - a.lengthkm + num_W_calc_dis 
                                       WHERE 
                                       a.hydroseq = num_min_hydro_seq;
   
                                    END IF;
   
                                    boo_continue := FALSE;
   
                                 END IF;
   
                              END IF;
   
                           ELSE
                              boo_continue := FALSE;
   
                           END IF;
   
                        ELSE
                           boo_continue := FALSE;
   
                        END IF;
   
                     END LOOP;
   
                  END IF;
   
               END IF;
   
            END IF;
   
         END LOOP;
         
      END IF;

   END LOOP;
   
   RETURN 0;
   
END;
$$;


ALTER FUNCTION nhdplus_navigation.navigate_dndiv(p_navigation_type character varying, p_start_flowline nhdplus_navigation.flowline_rec, p_stop_flowline nhdplus_navigation.flowline_rec, p_num_max_distance numeric, p_num_max_time numeric, p_start_path_length numeric, p_start_path_time numeric) OWNER TO nhdplus_navigation;
