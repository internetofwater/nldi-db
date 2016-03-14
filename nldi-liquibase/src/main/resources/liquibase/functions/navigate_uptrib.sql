
CREATE FUNCTION nhdplus_navigation.navigate_uptrib(p_navigation_type character varying, p_start_flowline nhdplus_navigation.flowline_rec, p_num_max_distance numeric, p_num_max_time numeric, p_start_path_length numeric, p_start_path_time numeric, INOUT p_stop_condition_met numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $$ 
DECLARE
   boo_continue           BOOLEAN := TRUE;
   num_selected_pre       INTEGER := -1;
   num_selected_post      INTEGER := -1;
   num_iteration          INTEGER :=  1;
   num_updated            INTEGER :=  0;
   
BEGIN
   
   --------------------------------------------------------------------------
   -- Step 10
   -- MAIN UPTRIB Loop - do until nothing more is selected
   --------------------------------------------------------------------------
   WHILE boo_continue
   LOOP
      -- GET PRE-UPDATE SELECTED count if NECESSARY
      IF num_selected_post = -1
      THEN
         SELECT 
         COUNT(*) 
         INTO num_selected_pre
         FROM 
         tmp_navigation_working a 
         WHERE 
         a.selected >= 1;

      ELSE
         num_selected_pre := num_selected_post;
         
      END IF;
      
      TRUNCATE TABLE tmp_navigation_uptrib;

      INSERT INTO tmp_navigation_uptrib
      SELECT
       b.fromlevelpathid
      ,MIN(b.fromhydroseq) AS minhs
      FROM
      tmp_navigation_working a
      JOIN
      nhdplus.plusflow_np21 b
      ON
      a.nhdplus_comid = b.tocomid
      WHERE
          a.selected = num_iteration
      AND b.nhdplus_region = p_start_flowline.nhdplus_region
      GROUP BY
      b.fromlevelpathid;

      --DO UPDATE
      num_iteration := num_iteration + 1;

      IF p_num_max_distance IS NOT NULL
      THEN
         UPDATE tmp_navigation_working a 
         SET 
          selected  = num_iteration
         ,ofmeasure = a.fmeasure
         ,otmeasure = a.tmeasure 
         WHERE 
             a.pathlength <= p_start_path_length + p_num_max_distance 
         AND a.hydroseq >= (
            SELECT 
            b.minHS 
            FROM 
            tmp_navigation_uptrib b 
            WHERE 
            b.fromlevelpathid = a.levelpathid
         );

      ELSIF p_num_max_time IS NOT NULL
      THEN
         UPDATE tmp_navigation_working a 
         SET 
          selected  = num_iteration
         ,ofmeasure = a.fmeasure
         ,otmeasure = a.tmeasure 
         WHERE 
             a.pathtime <= p_start_path_time + p_num_max_time
         AND a.hydroseq >= (
            SELECT
            b.minHS
            FROM
            tmp_navigation_uptrib b 
            WHERE
            b.fromlevelpathid = a.levelpathid
         );

      ELSE
         UPDATE tmp_navigation_working a 
         SET 
          selected  = num_iteration
         ,ofmeasure = a.fmeasure
         ,otmeasure = a.tmeasure 
         WHERE 
         a.hydroseq >= (
            SELECT 
            b.minHS 
            FROM 
            tmp_navigation_uptrib b
            WHERE 
            b.fromlevelpathid = a.levelpathid
         );

      END IF;

      GET DIAGNOSTICS num_updated = ROW_COUNT;

      --GET POST-UPDATE SELECTED count
      SELECT 
      COUNT(*) 
      INTO num_selected_post
      FROM 
      tmp_navigation_working a 
      WHERE 
      a.selected >= 1;

      IF num_selected_pre = num_selected_post
      THEN
         boo_continue := FALSE;
         
      END IF;

   END LOOP;

   --------------------------------------------------------------------------
   -- Update measures at the end of paths where necessary 
   -- if there is a stop distance.
   --------------------------------------------------------------------------
   IF p_num_max_distance IS NOT NULL
   THEN
      UPDATE tmp_navigation_working a 
      SET 
       otmeasure = (a.ofmeasure + ((a.otmeasure - a.ofmeasure) / a.lengthkm) * ((p_start_path_length + p_num_max_distance) - a.pathlength))
      ,totaldist = p_num_max_distance
      WHERE 
          a.selected >= 1
      AND a.otmeasure = a.tmeasure
      AND a.pathlength + lengthkm > p_start_path_length + p_num_max_distance;

      UPDATE tmp_navigation_working a 
      SET 
      totaltime = (a.pathtime + (a.travtime - (a.travtime * ((a.tmeasure - a.otmeasure) / (a.tmeasure - a.fmeasure))))) - p_start_path_time
      WHERE 
      a.selected >= 1 AND 
      a.otmeasure <> a.tmeasure AND 
      a.pathlength + a.lengthkm > p_start_path_length + p_num_max_distance;

   ELSIF p_num_max_time IS NOT NULL
   THEN
      UPDATE tmp_navigation_working a 
      SET 
       otmeasure = (a.ofmeasure + ((a.otmeasure - a.ofmeasure) / a.travtime) * ((p_start_path_time + p_num_max_time) - a.pathtime)) 
      ,totaltime = p_num_max_time
      WHERE 
          a.selected >= 1
      AND a.otmeasure = a.tmeasure
      AND a.pathtime + a.travtime > p_start_path_time + p_num_max_time;

      UPDATE tmp_navigation_working a 
      SET 
      totaldist = (a.pathlength + (a.lengthkm - (a.lengthkm * ((a.tmeasure - a.otmeasure) / (a.tmeasure - a.fmeasure))))) - p_start_path_length
      WHERE 
          a.selected >= 1
      AND a.otmeasure <> a.tmeasure
      AND a.pathtime + a.travtime > p_start_path_time + p_num_max_time;

   END IF;
   
   TRUNCATE TABLE tmp_navigation_uptrib;
   
END;
$$;


ALTER FUNCTION nhdplus_navigation.navigate_uptrib(p_navigation_type character varying, p_start_flowline nhdplus_navigation.flowline_rec, p_num_max_distance numeric, p_num_max_time numeric, p_start_path_length numeric, p_start_path_time numeric, INOUT p_stop_condition_met numeric) OWNER TO nhdplus_navigation;
