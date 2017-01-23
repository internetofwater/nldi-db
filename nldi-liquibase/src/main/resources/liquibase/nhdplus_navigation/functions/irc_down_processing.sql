
CREATE OR REPLACE FUNCTION nhdplus_navigation.irc_down_processing(p_navigation_type character varying, p_start_flowline nhdplus_navigation.flowline_rec, p_stop_flowline nhdplus_navigation.flowline_rec, p_num_max_distance numeric, p_num_max_time numeric, p_start_path_length numeric, p_start_path_time numeric, p_start_comid integer, p_start_permanent_identifier character varying, p_start_measure numeric, p_stop_comid integer, p_stop_permanent_identifier character varying, p_stop_measure numeric, p_start_inc_dist numeric, p_add_flowline_attributes character varying, p_add_flowline_geometry character varying, p_session_id character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$ 
DECLARE
   ary_used_comids     INTEGER[];
   num_used            NUMERIC := 0;
   num_found           INTEGER;
   num_inserted        INTEGER;
   boo_continue        BOOLEAN := TRUE;
   num_did_insertions  INTEGER := 0;
   num_updated         INTEGER;
   num_iterations      INTEGER;
   num_min_hydro_seq   INTEGER;
   num_W_path_length   NUMERIC;
   num_W_lengthkm      NUMERIC;
   num_W_tomeas        NUMERIC;
   num_W_frommeas      NUMERIC;
   num_W_calc_meas     NUMERIC;
   num_W_calc_dis      NUMERIC;
   num_W_calc_time     NUMERIC;
   num_W_path_time     NUMERIC;
   num_W_trav_time     NUMERIC;
   rec_connections     nhdplus_navigation.typ_connections;
   num_check           NUMERIC;
   
   curs_connections CURSOR(
      p_session_id  VARCHAR
   )
   IS
   SELECT DISTINCT 
    a.upcomid
   ,a.dncomid
   ,a.upunitid
   ,a.dnunitid 
   FROM 
   nhdplus.nhdplusconnect_np21 a
   JOIN
   nhdplus_navigation.tmp_navigation_results b
   ON
   a.upcomid = b.nhdplus_comid
   WHERE
   b.session_id = p_session_id;

BEGIN
   
   --------------------------------------------------------------------------
   -- Step 10
   -- Check over incoming parameters
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------
   -- Step 20
   -- Bail if we are able
   --------------------------------------------------------------------------
   SELECT 
   COUNT(*)
   INTO num_check
   FROM
   nhdplus.nhdplusconnect_np21 a
   WHERE
       a.upunitid = p_start_flowline.nhdplus_region
   AND a.upunittype = 'VPU';
   
   IF num_check = 0
   THEN
      RETURN 0;
      
   END IF;
   
   --------------------------------------------------------------------------
   -- Step 20
   -- Update totals before checking for connections
   --------------------------------------------------------------------------
   UPDATE nhdplus_navigation.tmp_navigation_results a 
   SET 
   totaldist = p_start_path_length - a.pathlength 
   WHERE 
       a.session_id = p_session_id
   AND a.totaldist IS NULL;

   UPDATE nhdplus_navigation.tmp_navigation_results a 
   SET 
   totaltime = p_start_path_time - a.pathtime 
   WHERE 
       a.session_id = p_session_id
   AND a.totaltime IS NULL;

   UPDATE nhdplus_navigation.tmp_navigation_results a 
   SET 
    tmeasure  = p_start_measure
   ,totaldist = p_start_inc_dist
   WHERE 
       a.session_id = p_session_id
   AND a.nhdplus_comid = p_start_comid;

   --------------------------------------------------------------------------
   -- Step 30
   -- Populate results table going down
   -- Do this until there are no more inserts from the prenavigated data
   --------------------------------------------------------------------------
   WHILE boo_continue
   LOOP
      boo_continue := FALSE;

      OPEN curs_connections(p_session_id);

      LOOP
         FETCH curs_connections INTO rec_connections;
         EXIT WHEN NOT FOUND;

         num_found := 0;

         IF ary_used_comids IS NOT NULL
         AND array_length(ary_used_comids,1) > 0
         THEN
            FOR i IN 1 .. array_length(ary_used_comids,1)
            LOOP
               IF ary_used_comids[i] = rec_connections.dncomid
               THEN
                  num_found := 1;
                  
               END IF;
                  
            END LOOP;
            
         END IF;

         IF num_found = 0
         THEN
            -- IRC connection has not yet been included in the results.  
            -- Add the approproate dnmain recults to a temp file.
            IF p_num_max_distance IS NOT NULL
            THEN
               INSERT INTO tmp_navigation_connections(
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
                  ,reachsmdate
                  ,ftype
                  ,fcode
                  ,gnis_id
                  ,wbarea_permanent_identifier
                  ,wbarea_nhdplus_comid
                  ,wbd_huc12
                  ,catchment_featureid
                  ,shape 
               ) 
               SELECT 
                a.start_permanent_identifier
               ,a.permanent_identifier
               ,a.start_nhdplus_comid
               ,a.nhdplus_comid
               ,a.reachcode
               ,a.fmeasure
               ,a.tmeasure
               ,NULL AS totaldist
               ,NULL AS totaltime
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
               ,a.fmeasure
               ,a.tmeasure
               ,a.nhdplus_region
               ,a.nhdplus_version
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.reachsmdate
                ELSE
                   NULL
                END 
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.ftype
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.fcode
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.gnis_id
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.wbarea_permanent_identifier
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.wbarea_nhdplus_comid
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.wbd_huc12
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.catchment_featureid
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                AND p_add_flowline_geometry = 'TRUE'
                THEN
                   a.shape
                ELSE
                   NULL
                END
               FROM 
               nhdplus_navigation.prep_connections_dm a 
               WHERE 
                   a.start_nhdplus_comid = rec_connections.dncomid
               AND a.pathlength + a.lengthkm >= p_start_path_length - p_num_max_distance
               AND a.nhdplus_comid NOT IN (SELECT b.nhdplus_comid FROM tmp_navigation_connections b)
               ORDER BY 
               a.hydroseq DESC;
               
               GET DIAGNOSTICS num_inserted = ROW_COUNT;

            ELSIF p_num_max_time IS NOT NULL
            THEN
               INSERT INTO tmp_navigation_connections(
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
                  ,reachsmdate
                  ,ftype
                  ,fcode
                  ,gnis_id
                  ,wbarea_permanent_identifier
                  ,wbarea_nhdplus_comid
                  ,wbd_huc12
                  ,catchment_featureid
                  ,shape 
               ) 
               SELECT 
                a.start_permanent_identifier
               ,a.permanent_identifier
               ,a.start_nhdplus_comid
               ,a.nhdplus_comid
               ,a.reachcode
               ,a.fmeasure
               ,a.tmeasure
               ,NULL AS totaldist
               ,NULL AS totaltime
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
               ,a.fmeasure
               ,a.tmeasure
               ,a.nhdplus_region
               ,a.nhdplus_version
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.reachsmdate
                ELSE
                   NULL
                END 
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.ftype
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.fcode
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.gnis_id
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.wbarea_permanent_identifier
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.wbarea_nhdplus_comid
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.wbd_huc12
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.catchment_featureid
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                AND p_add_flowline_geometry = 'TRUE'
                THEN
                   a.shape
                ELSE
                   NULL
                END
               FROM 
               nhdplus_navigation.prep_connections_dm a 
               WHERE 
                   a.start_nhdplus_comid = rec_connections.dncomid 
               AND a.pathtime + a.travtime >= p_start_path_time - p_num_max_time 
               AND a.nhdplus_comid NOT IN (SELECT b.nhdplus_comid FROM tmp_navigation_connections b)
               ORDER BY 
               a.hydroseq DESC;
               
               GET DIAGNOSTICS num_inserted = ROW_COUNT;

            ELSIF p_navigation_type = 'PP'
            THEN
               INSERT INTO tmp_navigation_connections(
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
                  ,reachsmdate
                  ,ftype
                  ,fcode
                  ,gnis_id
                  ,wbarea_permanent_identifier
                  ,wbarea_nhdplus_comid
                  ,wbd_huc12
                  ,catchment_featureid
                  ,shape 
               ) 
               SELECT 
                a.start_permanent_identifier
               ,a.permanent_identifier
               ,a.start_nhdplus_comid
               ,a.nhdplus_comid
               ,a.reachcode
               ,a.fmeasure
               ,a.tmeasure
               ,NULL AS totaldist
               ,NULL AS totaltime
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
               ,a.fmeasure
               ,a.tmeasure
               ,a.nhdplus_region
               ,a.nhdplus_version
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.reachsmdate
                ELSE
                   NULL
                END 
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.ftype
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.fcode
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.gnis_id
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.wbarea_permanent_identifier
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.wbarea_nhdplus_comid
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.wbd_huc12
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.catchment_featureid
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                AND p_add_flowline_geometry = 'TRUE'
                THEN
                   a.shape
                ELSE
                   NULL
                END
               FROM 
               nhdplus_navigation.prep_connections_dm a
               WHERE 
                   a.start_nhdplus_comid = rec_connections.dncomid
               AND a.hydroseq >= p_stop_flowline.hydroseq
               ORDER BY 
               a.hydroseq DESC;
               
               GET DIAGNOSTICS num_inserted = ROW_COUNT;
               
            ELSE
               INSERT INTO tmp_navigation_connections(
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
                  ,reachsmdate
                  ,ftype
                  ,fcode
                  ,gnis_id
                  ,wbarea_permanent_identifier
                  ,wbarea_nhdplus_comid
                  ,wbd_huc12
                  ,catchment_featureid
                  ,shape 
               ) 
               SELECT 
                a.start_permanent_identifier
               ,a.permanent_identifier
               ,a.start_nhdplus_comid
               ,a.nhdplus_comid
               ,a.reachcode
               ,a.fmeasure
               ,a.tmeasure
               ,NULL AS totaldist
               ,NULL AS totaltime
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
               ,a.fmeasure
               ,a.tmeasure
               ,a.nhdplus_region
               ,a.nhdplus_version
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.reachsmdate
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.ftype
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.fcode
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.gnis_id
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.wbarea_permanent_identifier
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.wbarea_nhdplus_comid
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.wbd_huc12
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.catchment_featureid
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                AND p_add_flowline_geometry = 'TRUE'
                THEN
                   a.shape
                ELSE
                   NULL
                END
               FROM 
               nhdplus_navigation.prep_connections_dm a 
               WHERE 
               a.start_nhdplus_comid = rec_connections.dncomid
               ORDER BY 
               a.hydroseq DESC;
               
               GET DIAGNOSTICS num_inserted = ROW_COUNT;

            END IF;

            IF num_inserted > 0
            THEN
               num_did_insertions := 1;
               boo_continue := TRUE;
               
            END IF;

            IF p_navigation_type = 'DD'
            THEN
               --Now add the dndiv results to a separate temp file, it necessary.
               --insert into temptable2 the dndiv nagivation results for the current tocomid
               INSERT INTO tmp_navigation_connections_dd(
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
                  ,dnhydroseq
                  ,pathlength
                  ,lengthkm
                  ,length_measure_ratio
                  ,pathtime
                  ,travtime
                  ,time_measure_ratio
                  ,ofmeasure
                  ,otmeasure
                  ,processed
                  ,nhdplus_region
                  ,nhdplus_version
                  ,reachsmdate
                  ,ftype
                  ,fcode
                  ,gnis_id
                  ,wbarea_permanent_identifier
                  ,wbarea_nhdplus_comid
                  ,wbd_huc12
                  ,catchment_featureid
                  ,shape
               ) 
               SELECT 
                a.start_permanent_identifier
               ,a.permanent_identifier
               ,a.start_nhdplus_comid
               ,a.nhdplus_comid
               ,a.reachcode
               ,a.fmeasure
               ,a.tmeasure
               ,NULL AS totaldist
               ,NULL AS totaltime
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
               ,a.fmeasure
               ,a.tmeasure
               ,NULL AS processed
               ,a.nhdplus_region
               ,a.nhdplus_version
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.reachsmdate
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.ftype
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.fcode
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.gnis_id
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.wbarea_permanent_identifier
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.wbarea_nhdplus_comid
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.wbd_huc12
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                THEN
                   a.catchment_featureid
                ELSE
                   NULL
                END
               ,CASE WHEN p_add_flowline_attributes = 'TRUE'
                AND p_add_flowline_geometry = 'TRUE'
                THEN
                   a.shape
                ELSE
                   NULL
                END
               FROM 
               nhdplus_navigation.prep_connections_dd a 
               WHERE 
               a.start_nhdplus_comid = rec_connections.dncomid
               ORDER BY
               a.hydroseq DESC;
               
               --Update total time and total distance along the main path in the connecting workspace.
               UPDATE tmp_navigation_connections a 
               SET 
               totaldist = p_start_path_length - a.pathlength 
               WHERE 
               a.totaldist IS NULL;

               --Populate totaltime field in navigation results table
               UPDATE tmp_navigation_connections a 
               SET 
               totaltime = p_start_path_time - a.pathtime 
               WHERE 
               a.totaltime IS NULL;

               --Update to1,totaldist of start record (based on user supplied startmeas)
               UPDATE tmp_navigation_connections a 
               SET 
                tmeasure  = p_start_measure
               ,totaldist = p_start_inc_dist
               WHERE 
               a.nhdplus_comid = p_start_comid;
               
               --Remove all comids in temptable2 that are along the main path.
               DELETE FROM tmp_navigation_connections_dd a 
               WHERE 
               EXISTS (
                  SELECT 
                  1 
                  FROM 
                  tmp_navigation_connections b 
                  WHERE 
                  a.nhdplus_comid = b.nhdplus_comid
               );

               --temptable2 will now contain ONLY the divergent paths
               --need to fill totaldist and totaltime along these paths.

               --fill the totaltime and totaldist for the top hydroseq of each divergent path.

               num_iterations := 1;
               UPDATE tmp_navigation_connections_dd a 
               SET 
                processed = num_iterations
               ,totaldist = a.lengthkm + (
                   SELECT DISTINCT 
                   b.totaldist 
                   FROM 
                   tmp_navigation_connections b 
                   WHERE 
                   a.uphydroseq = b.hydroseq 
                )
               ,totaltime = a.travtime + (
                   SELECT DISTINCT 
                   totaltime 
                   FROM 
                   tmp_navigation_connections c 
                   WHERE 
                   a.uphydroseq = c.hydroseq 
                ) 
               WHERE EXISTS (
                  SELECT 
                  1 
                  FROM 
                  tmp_navigation_connections d 
                  WHERE 
                  a.uphydroseq = d.hydroseq 
               );

               GET DIAGNOSTICS num_updated = ROW_COUNT;

               -- fill totaltime and totaldist for the 'next' comids along each divergent path, 
               -- until no more updates are possible.
               num_iterations := 2;

               WHILE num_updated > 0
               LOOP
                  UPDATE tmp_navigation_connections_dd a 
                  SET 
                   processed = num_iterations
                  ,totaldist = a.lengthkm + (
                      SELECT 
                      MAX(b.totaldist)
                      FROM 
                      tmp_navigation_connections_dd b 
                      WHERE 
                      a.uphydroseq = b.hydroseq 
                   )
                  ,totaltime = travtime + (
                      SELECT 
                      MAX(c.totaltime) 
                      FROM 
                      tmp_navigation_connections_dd c 
                      WHERE 
                      a.uphydroseq = c.hydroseq 
                   ) 
                  WHERE 
                      a.processed IS NULL 
                  AND EXISTS (
                     SELECT 
                     1 
                     FROM 
                     tmp_navigation_connections_dd d 
                     WHERE 
                         d.hydroseq = a.uphydroseq
                     AND d.processed IS NOT NULL 
                  );

                  GET DIAGNOSTICS num_updated = ROW_COUNT;

                  IF num_updated = 0
                  THEN
                     --the 'min' function is most likely not necessary.  I left it there to make
                     --certain that the query does not
                     --return multiple values.
                     UPDATE tmp_navigation_connections_dd a 
                     SET 
                      processed = num_iterations
                     ,totaldist = a.lengthkm + (
                         SELECT 
                         MIN(b.totaldist) 
                         FROM 
                         tmp_navigation_connections_dd b 
                         WHERE 
                             b.dnhydroseq = a.hydroseq 
                         AND b.processed IS NOT NULL 
                      )
                     ,totaltime = a.travtime + (
                         SELECT 
                         MIN(c.totaltime) 
                         FROM 
                         tmp_navigation_connections_dd c 
                         WHERE 
                             c.dnhydroseq = a.hydroseq 
                         AND c.processed IS NOT NULL 
                      )  
                     WHERE 
                         a.processed IS NULL
                     AND EXISTS (
                        SELECT 
                        1 
                        FROM 
                        tmp_navigation_connections_dd d 
                        WHERE 
                            d.dnhydroseq = a.hydroseq 
                        AND d.processed IS NOT NULL 
                     );

                     GET DIAGNOSTICS num_updated = ROW_COUNT;

                  END IF;

                  num_iterations := num_iterations + 1;

               END LOOP;

               --Remove all comids in temptable2 where totaldist and total time are null
               DELETE FROM tmp_navigation_connections_dd a
               WHERE 
               a.totaldist IS NULL;

               --remove anything longer than 'max'
               IF p_num_max_distance IS NOT NULL
               THEN
                  --Remove all comids in temptable2 where distance traveled is too long
                  DELETE FROM tmp_navigation_connections_dd a
                  WHERE 
                  a.totaldist - a.lengthkm > p_num_max_distance;

               ELSIF p_num_max_time IS NOT NULL
               THEN
                  --Remove all comids in temptable2 where time traveled is too long
                  DELETE FROM tmp_navigation_connections_dd a
                  WHERE 
                  a.totaltime - a.travtime > p_num_max_time;

               END IF;

            END IF;

            num_used := num_used + 1;
            ary_used_comids[num_used] := rec_connections.dncomid;

         END IF;

      END LOOP;

      CLOSE curs_connections;

      --Add all IRC results for this pass to the navigation results.
      --IF num_inserted > 0
      IF num_did_insertions > 0
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
            ,reachsmdate
            ,ftype
            ,fcode
            ,gnis_id
            ,wbarea_permanent_identifier
            ,wbarea_nhdplus_comid
            ,wbd_huc12
            ,catchment_featureid
            ,shape 
         ) 
         SELECT DISTINCT 
          nextval('nhdplus_navigation.tmp_navigation_results_seq')
         ,p_session_id
         ,a.start_permanent_identifier
         ,a.permanent_identifier
         ,a.start_nhdplus_comid
         ,a.nhdplus_comid
         ,a.reachcode
         ,a.fmeasure
         ,a.tmeasure
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
         ,a.ofmeasure
         ,a.otmeasure
         ,a.nhdplus_region
         ,a.nhdplus_version
         ,a.reachsmdate
         ,a.ftype
         ,a.fcode
         ,a.gnis_id
         ,a.wbarea_permanent_identifier
         ,a.wbarea_nhdplus_comid
         ,a.wbd_huc12
         ,a.catchment_featureid
         ,a.shape
         FROM
         tmp_navigation_connections a 
         ORDER BY 
         a.hydroseq DESC;

         --Add the divergent path records too.
         IF p_navigation_type = 'DD'
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
               ,reachsmdate
               ,ftype
               ,fcode
               ,gnis_id
               ,wbarea_permanent_identifier
               ,wbarea_nhdplus_comid
               ,wbd_huc12
               ,catchment_featureid
               ,shape
            ) 
            SELECT DISTINCT 
             nextval('nhdplus_navigation.tmp_navigation_results_seq')
            ,p_session_id
            ,a.start_permanent_identifier
            ,a.permanent_identifier
            ,a.start_nhdplus_comid
            ,a.nhdplus_comid
            ,a.reachcode
            ,a.fmeasure
            ,a.tmeasure
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
            ,a.ofmeasure
            ,a.otmeasure
            ,a.nhdplus_region
            ,a.nhdplus_version
            ,a.reachsmdate
            ,a.ftype
            ,a.fcode
            ,a.gnis_id
            ,a.wbarea_permanent_identifier
            ,a.wbarea_nhdplus_comid
            ,a.wbd_huc12
            ,a.catchment_featureid
            ,a.shape
            FROM 
            tmp_navigation_connections_dd a 
            WHERE 
            a.totaldist IS NOT NULL 
            ORDER BY 
            a.hydroseq DESC;

         END IF;

      END IF;

      TRUNCATE TABLE tmp_navigation_connections;

      IF p_navigation_type = 'DD'
      THEN
         TRUNCATE TABLE tmp_navigation_connections_dd;
         
      END IF;
      
   END LOOP;

   IF num_did_insertions = 1
   THEN
      --Adjust measures and totals at the bottom of paths, if necessary
      IF p_navigation_type IN ('DM','PP')
      THEN
         --Find Hydroseq of last record in the navigation.
         SELECT 
         MIN(a.hydroseq) 
         INTO num_min_hydro_seq
         FROM 
         nhdplus_navigation.tmp_navigation_results a
         WHERE
         a.session_id = p_session_id;

         --Get data needed to adjust measures and totals
         SELECT 
          a.pathlength
         ,a.lengthkm
         ,a.pathtime
         ,a.travtime
         ,a.tmeasure
         ,a.fmeasure 
         INTO 
          num_W_path_length
         ,num_W_lengthkm
         ,num_W_path_time
         ,num_W_trav_time
         ,num_W_tomeas
         ,num_W_frommeas
         FROM 
         nhdplus_navigation.tmp_navigation_results a 
         WHERE 
             a.session_id = p_session_id
         AND a.hydroseq = num_min_hydro_seq;

         IF p_num_max_distance IS NOT NULL
         AND num_W_path_length < p_start_path_length - p_num_max_distance
         THEN
            num_W_calc_meas := nhdplus_navigation.measure_at_distance(
                p_fmeasure  := num_W_frommeas
               ,p_tmeasure  := num_W_tomeas
               ,p_length    := num_W_lengthkm
               ,p_distance  := (num_W_path_length + num_W_lengthkm) - (p_start_path_length - p_num_max_distance)
               ,p_half      := 'TOP'
            );

            num_W_calc_time := nhdplus_navigation.included_distance(
                p_fmeasure  := num_W_frommeas
               ,p_tmeasure  := num_W_tomeas
               ,p_length    := num_W_trav_time
               ,p_measure   := num_W_calc_meas
               ,p_half      := 'TOP'
            );

            UPDATE nhdplus_navigation.tmp_navigation_results a 
            SET 
             fmeasure  = ROUND(num_W_calc_meas,5)
            ,totaldist = p_num_max_distance
            ,totaltime = p_start_path_time - (num_W_path_time + (num_W_trav_time - num_W_calc_time)) 
            WHERE 
                a.session_id = p_session_id
            AND a.hydroseq = num_min_hydro_seq;

         ELSIF p_num_max_time IS NOT NULL
         AND num_W_path_length < p_start_path_time - p_num_max_time
         THEN
            num_W_calc_meas := nhdplus_navigation.measure_at_distance(
                p_fmeasure  := num_W_frommeas
               ,p_tmeasure  := num_W_tomeas
               ,p_length    := num_W_trav_time
               ,p_distance  := (num_W_path_time + num_W_trav_time) - (p_start_path_time - p_num_max_time)
               ,p_half      := 'TOP'
            );

            num_W_calc_time := nhdplus_navigation.included_distance(
                p_fmeasure  := num_W_frommeas
               ,p_tmeasure  := num_W_tomeas
               ,p_length    := num_W_lengthkm
               ,p_measure   := num_W_calc_meas
               ,p_half      := 'TOP'
            );

            UPDATE nhdplus_navigation.tmp_navigation_results a 
            SET 
             fmeasure  = ROUND(num_W_calc_meas,5)
            ,totaldist = p_start_path_length - (num_W_path_length + (num_W_lengthkm - num_W_calc_dis))
            ,totaltime = p_num_max_time
            WHERE 
                a.session_id = p_session_id
            AND a.hydroseq   = num_min_hydro_seq;

         ELSIF p_stop_comid IS NOT NULL
         THEN
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
            
            UPDATE nhdplus_navigation.tmp_navigation_results a 
            SET 
             fmeasure  = ROUND(num_W_calc_meas,5)
            ,totaldist = p_start_path_length - (num_W_path_length + (num_W_lengthkm - num_W_calc_dis))
            ,totaltime = p_start_path_time - (num_W_path_time + (num_W_trav_time - num_W_calc_time))
            WHERE 
                a.session_id = p_session_id
            AND a.hydroseq = num_min_hydro_seq;

         END IF;

      ELSIF p_navigation_type = 'DD'
      THEN
         IF p_num_max_distance IS NOT NULL
         THEN
            UPDATE nhdplus_navigation.tmp_navigation_results a 
            SET 
             fmeasure  = ROUND(a.otmeasure - (((a.otmeasure - a.ofmeasure) / a.lengthkm) * (p_num_max_distance - (a.totaldist - a.lengthkm))),5)
            ,totaldist = p_num_max_distance 
            WHERE 
                a.session_id = p_session_id
            AND a.ofmeasure IS NOT NULL 
            AND a.ofmeasure = a.fmeasure
            AND a.totaldist > p_num_max_distance;

            UPDATE nhdplus_navigation.tmp_navigation_results a 
            SET 
            totaltime = (a.totaltime - a.travtime) + (a.travtime * ((a.tmeasure - a.fmeasure) / (a.otmeasure - a.ofmeasure))) 
            WHERE 
                a.session_id = p_session_id
            AND a.ofmeasure IS NOT NULL
            AND a.ofmeasure <> a.fmeasure
            AND a.totaldist = p_num_max_distance;

         ELSIF p_num_max_time > 0
         THEN
            UPDATE nhdplus_navigation.tmp_navigation_results a 
            SET 
             fmeasure  = ROUND(a.otmeasure - (((a.otmeasure - a.ofmeasure) / a.travtime) * (p_num_max_time - (a.totaltime - a.travtime))),5)
            ,totaltime = p_num_max_time 
            WHERE 
                a.session_id = p_session_id
            AND a.ofmeasure IS NOT NULL
            AND a.ofmeasure = a.fmeasure
            AND a.totaltime > p_num_max_time;

            UPDATE nhdplus_navigation.tmp_navigation_results a 
            SET
            totaldist = (a.totaldist - a.lengthkm) + (a.lengthkm * ((a.tmeasure - a.fmeasure) / (a.otmeasure - a.ofmeasure))) 
            WHERE
                a.session_id = p_session_id
            AND a.ofmeasure IS NOT NULL
            AND a.ofmeasure <> a.fmeasure 
            AND a.totaltime = p_num_max_time;

         END IF;

      END IF;

   END IF;
   
   RETURN 0;
   
END;
$$;


ALTER FUNCTION nhdplus_navigation.irc_down_processing(p_navigation_type character varying, p_start_flowline nhdplus_navigation.flowline_rec, p_stop_flowline nhdplus_navigation.flowline_rec, p_num_max_distance numeric, p_num_max_time numeric, p_start_path_length numeric, p_start_path_time numeric, p_start_comid integer, p_start_permanent_identifier character varying, p_start_measure numeric, p_stop_comid integer, p_stop_permanent_identifier character varying, p_stop_measure numeric, p_start_inc_dist numeric, p_add_flowline_attributes character varying, p_add_flowline_geometry character varying, p_session_id character varying) owner to nhdplus;
