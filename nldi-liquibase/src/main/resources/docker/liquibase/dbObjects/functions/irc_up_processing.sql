
CREATE FUNCTION nhdplus_navigation.irc_up_processing(p_navigation_type character varying, p_start_flowline nhdplus_navigation.flowline_rec, p_num_max_distance numeric, p_num_max_time numeric, p_start_path_length numeric, p_start_path_time numeric, p_add_flowline_attributes character varying, p_add_flowline_geometry character varying, p_session_id character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$ 
DECLARE
   ary_used_comids     INTEGER[];
   num_used            INTEGER := 0;
   num_found           INTEGER;
   num_inserted        INTEGER;
   num_continue        INTEGER := 1;
   num_did_insertions  INTEGER := 0;
   num_max_hydro_seq   NUMERIC(10,0);
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
   
   curs_connections_ut CURSOR(
      p_session_id VARCHAR
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
   a.dncomid = b.nhdplus_comid
   WHERE
   b.session_id = p_session_id;
   
   curs_connections_um CURSOR(
      p_session_id VARCHAR
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
   a.dncomid = b.nhdplus_comid
   WHERE
       a.uphydroseq = a.upmainhydroseq
   AND b.session_id = p_session_id;
   
BEGIN

   --------------------------------------------------------------------------
   -- Step 10
   -- Check over incoming parameters
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------
   -- Step 20
   -- Bail if we are able
   --------------------------------------------------------------------------
   IF p_navigation_type = 'UT'
   THEN
      SELECT 
      COUNT(*)
      INTO num_check
      FROM
      nhdplus.nhdplusconnect_np21 a
      WHERE
          a.dnunittype = 'VPU'
      AND a.dnunitid   = p_start_flowline.nhdplus_region;
   
   ELSIF p_navigation_type = 'UM'
   THEN
      SELECT 
      COUNT(*)
      INTO num_check
      FROM
      nhdplus.nhdplusconnect_np21 a
      WHERE
          a.dnunittype = 'VPU'
      AND a.uphydroseq = a.upmainhydroseq
      AND a.dnunitid   = p_start_flowline.nhdplus_region;
      
   ELSE
      RAISE EXCEPTION 'err';
      
   END IF;
   
   IF num_check = 0
   THEN
      RETURN 0;
      
   END IF;
   
   --------------------------------------------------------------------------
   -- Step 30
   -- Loop through any connections found
   --------------------------------------------------------------------------
   WHILE num_continue = 1
   LOOP
      num_continue := 0;

      IF p_navigation_type = 'UT'
      THEN
         OPEN curs_connections_ut(p_session_id);

      ELSIF p_navigation_type = 'UM'
      THEN
         OPEN curs_connections_um(p_session_id);
         
      END IF;

      LOOP

      IF p_navigation_type = 'UT'
      THEN
         FETCH curs_connections_ut INTO rec_connections;
         EXIT WHEN NOT FOUND;

      ELSIF p_navigation_type = 'UM'
      THEN
         FETCH curs_connections_um INTO rec_connections;
         EXIT WHEN NOT FOUND;
            
      END IF;

         num_found := 0;

         IF ary_used_comids IS NOT NULL
         AND array_length(ary_used_comids,1) > 0
         THEN
            FOR i IN 1 .. array_length(ary_used_comids,1)
            LOOP
               IF ary_used_comids[i] = rec_connections.upcomid
               THEN
                  num_found := 1;
               
               END IF;
               
            END LOOP;
            
         END IF;

         IF num_found = 0
         THEN
            IF p_num_max_distance IS NOT NULL
            THEN
               IF p_navigation_type = 'UM'
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
                  nhdplus_navigation.prep_connections_um a
                  WHERE 
                      a.start_nhdplus_comid = rec_connections.upcomid 
                  AND a.pathlength <= p_start_path_length + p_num_max_distance 
                  AND a.nhdplus_comid NOT IN (SELECT b.nhdplus_comid FROM tmp_navigation_connections b)
                  ORDER BY 
                  a.hydroseq;
                  
               ELSIF p_navigation_type = 'UT'
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
                  nhdplus_navigation.prep_connections_ut a 
                  WHERE 
                      a.start_nhdplus_comid = rec_connections.upcomid 
                  AND a.pathlength <= p_start_path_length + p_num_max_distance
                  AND a.nhdplus_comid NOT IN (SELECT b.nhdplus_comid FROM tmp_navigation_connections b)
                  ORDER BY 
                  a.hydroseq;
                  
               END IF;

            ELSIF p_num_max_time IS NOT NULL
            THEN
               IF p_navigation_type = 'UM'
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
                  nhdplus_navigation.prep_connections_um a 
                  WHERE 
                      a.start_nhdplus_comid = rec_connections.upcomid
                  AND a.pathtime <= p_start_path_time + p_num_max_time
                  AND a.nhdplus_comid NOT IN (SELECT b.nhdplus_comid FROM tmp_navigation_connections b)
                  ORDER BY 
                  a.hydroseq;

               ELSIF p_navigation_type = 'UT'
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
                  nhdplus_navigation.prep_connections_ut a 
                  WHERE 
                      a.start_nhdplus_comid = rec_connections.upcomid
                  AND a.pathtime <= p_start_path_time + p_num_max_time
                  AND a.nhdplus_comid NOT IN (SELECT b.nhdplus_comid FROM tmp_navigation_connections b)
                  ORDER BY 
                  a.hydroseq;
               
               END IF;

            ELSE
               IF p_navigation_type = 'UM'
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
                  nhdplus_navigation.prep_connections_um a 
                  WHERE 
                      a.start_nhdplus_comid = rec_connections.upcomid
                  AND a.nhdplus_comid NOT IN (SELECT b.nhdplus_comid FROM tmp_navigation_connections b)
                  ORDER BY 
                  a.hydroseq;

               ELSIF p_navigation_type = 'UT'
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
                  nhdplus_navigation.prep_connections_ut a 
                  WHERE 
                      a.start_nhdplus_comid = rec_connections.upcomid
                  AND a.nhdplus_comid NOT IN (SELECT b.nhdplus_comid FROM tmp_navigation_connections b)
                  ORDER BY 
                  a.hydroseq;
                  
               END IF;

            END IF;

            GET DIAGNOSTICS num_inserted = ROW_COUNT;

            IF num_inserted > 0
            THEN
               num_did_insertions := 1;
               num_continue := 1;
               
            END IF;
            
            num_used := num_used + 1;
            ary_used_comids[num_used] := rec_connections.upcomid;

         END IF;

      END LOOP;

      IF p_navigation_type = 'UT'
      THEN
         CLOSE curs_connections_ut;

      ELSIF p_navigation_type = 'UM'
      THEN
         CLOSE curs_connections_um;

      END IF;

      IF num_inserted > 0
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
         ,ROUND(a.fmeasure,5)
         ,ROUND(a.tmeasure,5)
         ,ROUND(a.totaldist,16)
         ,ROUND(a.totaltime,16)
         ,a.hydroseq
         ,a.levelpathid
         ,a.terminalpathid
         ,a.uphydroseq
         ,a.dnhydroseq
         ,a.pathlength
         ,ROUND(a.lengthkm,16)
         ,ROUND(a.length_measure_ratio,16)
         ,a.pathtime
         ,ROUND(a.travtime,16)
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
         a.hydroseq;

      END IF;

      TRUNCATE TABLE tmp_navigation_connections;

   END LOOP;

   IF num_did_insertions = 1
   THEN
      --Adjust measures and totals at the bottom of paths, if necessary
      IF p_navigation_type = 'UM'
      THEN
         --Find Hydroseq of last record in the navigation.
         SELECT 
         MAX(a.hydroseq)
         INTO num_max_hydro_seq
         FROM
         nhdplus_navigation.tmp_navigation_results a
         WHERE
         a.session_id = p_session_id;

         -- Get data needed to adjust measures and totals
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
         AND a.hydroseq = num_max_hydro_seq;

         IF p_num_max_distance IS NOT NULL
         THEN
            IF num_W_path_length + num_W_lengthkm > p_start_path_length + p_num_max_distance
            THEN
               IF num_W_tomeas IS NULL
               THEN
                  NULL; --End NHDFlowline has null measures.  Do nothing.
                  
               ELSE
                  --Reset to1 with a calculated measure and totaldist with maxdistance and totaltime with calculated
                  --  totaltime
                  num_W_calc_meas := nhdplus_navigation.measure_at_distance(
                      p_fmeasure      := num_W_frommeas
                     ,p_tmeasure      := num_W_tomeas
                     ,p_length        := num_W_lengthkm
                     ,p_distance      := p_start_path_length + p_num_max_distance - num_W_path_length
                     ,p_half          := 'BOTTOM'
                  );

                  num_W_calc_time := nhdplus_navigation.included_distance(
                      p_fmeasure  := num_W_frommeas
                     ,p_tmeasure  := num_W_tomeas
                     ,p_length    := num_W_trav_time
                     ,p_measure   := num_W_calc_meas
                     ,p_half      := 'BOTTOM'
                  );

                  UPDATE nhdplus_navigation.tmp_navigation_results a 
                  SET 
                   tmeasure  = ROUND(num_W_calc_meas,5)
                  ,totaldist = ROUND(p_num_max_distance,16)
                  ,totaltime = ROUND(num_W_path_time + num_W_calc_time - p_start_path_time,16)
                  WHERE
                      a.session_id = p_session_id
                  AND a.hydroseq = num_max_hydro_seq;

               END IF;
               
            END IF;

         ELSIF p_num_max_time > 0
         THEN
            IF num_W_path_time + num_W_trav_time > p_start_path_time + p_num_max_time
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
                     ,p_distance      := p_start_path_time + p_num_max_time - num_W_path_time
                     ,p_half          := 'BOTTOM'
                  );
                  
                  num_W_calc_dis := nhdplus_navigation.included_distance(
                      p_fmeasure  := num_W_frommeas
                     ,p_tmeasure  := num_W_tomeas
                     ,p_length    := num_W_lengthkm
                     ,p_measure   := num_W_calc_meas
                     ,p_half      := 'BOTTOM'
                  );

                  UPDATE nhdplus_navigation.tmp_navigation_results a 
                  SET 
                   tmeasure  = ROUND(num_W_calc_meas,5)
                  ,totaldist = ROUND(num_W_path_length + num_W_calc_dis - p_start_path_length,16)
                  ,totaltime = ROUND(p_num_max_time,16)
                  WHERE 
                      a.session_id = p_session_id
                  AND a.hydroseq = num_max_hydro_seq;

               END IF;

            END IF;

         END IF;

      ELSIF p_navigation_type = 'UT'
      THEN
         IF p_num_max_distance IS NOT NULL
         THEN
            UPDATE nhdplus_navigation.tmp_navigation_results a 
            SET 
             tmeasure  = ROUND((a.fmeasure + ((a.tmeasure - a.fmeasure) / a.lengthkm) * ((p_start_path_length + p_num_max_distance) - a.pathlength)),5)
            ,totaldist = ROUND(p_num_max_distance,16)
            WHERE 
                a.session_id = p_session_id
            AND a.otmeasure = a.tmeasure
            AND a.pathlength + a.lengthkm > p_start_path_length + p_num_max_distance;

            UPDATE nhdplus_navigation.tmp_navigation_results a 
            SET 
            totaltime = ROUND((a.pathtime + (a.travtime - (a.travtime * ((a.otmeasure - a.tmeasure) / (a.otmeasure - a.ofmeasure))))) - p_start_path_time,16)
            WHERE 
                a.session_id = p_session_id
            AND a.otmeasure <> a.tmeasure
            AND a.pathlength + a.lengthkm > p_start_path_length + p_num_max_distance;

         ELSIF p_num_max_time IS NOT NULL
         THEN
            UPDATE nhdplus_navigation.tmp_navigation_results a 
            SET 
             tmeasure  = ROUND((a.fmeasure + ((a.tmeasure - a.fmeasure) / a.travtime) * ( (p_start_path_time + p_num_max_time) - a.pathtime)),5)
            ,totaltime = ROUND(p_num_max_time,16)
            WHERE
                a.session_id = p_session_id
            AND a.otmeasure = a.tmeasure
            AND a.pathtime + a.travtime > p_start_path_time + p_num_max_time;

            UPDATE nhdplus_navigation.tmp_navigation_results a 
            SET 
            totaldist = ROUND((a.pathlength + (a.lengthkm - (a.lengthkm * ((a.otmeasure - a.tmeasure) / (a.otmeasure - a.ofmeasure))))) - p_start_path_length,16)
            WHERE 
                a.session_id = p_session_id
            AND a.otmeasure <> a.tmeasure
            AND a.pathtime + a.travtime > p_start_path_time + p_num_max_time;

         END IF;

      END IF;

   END IF;
   
   RETURN 0;
   
END;
$$;


ALTER FUNCTION nhdplus_navigation.irc_up_processing(p_navigation_type character varying, p_start_flowline nhdplus_navigation.flowline_rec, p_num_max_distance numeric, p_num_max_time numeric, p_start_path_length numeric, p_start_path_time numeric, p_add_flowline_attributes character varying, p_add_flowline_geometry character varying, p_session_id character varying) OWNER TO nhdplus_navigation;
