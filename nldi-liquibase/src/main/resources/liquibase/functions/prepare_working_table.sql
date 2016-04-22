
CREATE OR REPLACE FUNCTION nhdplus_navigation.prepare_working_table(p_navigation_type character varying, p_num_max_distance numeric, p_num_max_time numeric, p_start_flowline nhdplus_navigation.flowline_rec, p_stop_flowline nhdplus_navigation.flowline_rec, p_start_path_length numeric, p_start_path_time numeric) RETURNS integer
    LANGUAGE plpgsql
    AS $$ 
DECLARE
BEGIN
   
   IF p_navigation_type IN ('UM','UT')
   THEN
      --Copy to working all flowlines with a greater hydroseq. (i.e. above the starting permid in the network)
      --If a max stop distance has been supplied, use that to further limit the record count in working.
      
      IF p_num_max_distance IS NOT NULL
      THEN
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
         )
         SELECT
          p_start_flowline.permanent_identifier
         ,a.permanent_identifier
         ,p_start_flowline.nhdplus_comid
         ,a.comid
         ,a.reachcode
         ,a.fmeasure
         ,a.tmeasure
         ,NULL AS totaldist
         ,NULL AS totaltime
         ,a.hydroseq
         ,a.levelpathid
         ,a.terminalpathid
         ,a.uphydroseq
         ,a.uplevelpathid
         ,a.dnhydroseq
         ,a.dnlevelpathid
         ,a.dnminorhyd
         ,a.divergence
         ,a.dndraincount
         ,a.pathlength
         ,a.lengthkm
         ,a.lengthkm / (a.tmeasure - a.fmeasure) AS length_measure_ratio
         ,a.pathtime
         ,a.travtime
         ,a.travtime / (a.tmeasure - a.fmeasure) AS time_measure_ratio
         ,NULL AS ofmeasure
         ,NULL AS otmeasure
         ,0
         ,a.nhdplus_region
         ,a.nhdplus_version
         FROM 
         nhdplus.plusflowlinevaa_np21 a 
         WHERE
             a.nhdplus_region = p_start_flowline.nhdplus_region
         AND a.hydroseq   >= p_start_flowline.hydroseq
         AND a.pathlength <= p_start_path_length + p_num_max_distance;
         
      ELSIF p_num_max_time IS NOT NULL
      THEN
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
         )
         SELECT
          p_start_flowline.permanent_identifier
         ,a.permanent_identifier
         ,p_start_flowline.nhdplus_comid
         ,a.comid
         ,a.reachcode
         ,a.fmeasure
         ,a.tmeasure
         ,NULL AS totaldist
         ,NULL AS totaltime
         ,a.hydroseq
         ,a.levelpathid
         ,a.terminalpathid
         ,a.uphydroseq
         ,a.uplevelpathid
         ,a.dnhydroseq
         ,a.dnlevelpathid
         ,a.dnminorhyd
         ,a.divergence
         ,a.dndraincount
         ,a.pathlength
         ,a.lengthkm
         ,a.lengthkm / (a.tmeasure - a.fmeasure) AS length_measure_ratio
         ,a.pathtime
         ,a.travtime
         ,a.travtime / (a.tmeasure - a.fmeasure) AS time_measure_ratio
         ,NULL AS ofmeasure
         ,NULL AS otmeasure
         ,0
         ,a.nhdplus_region
         ,a.nhdplus_version
         FROM 
         nhdplus.plusflowlinevaa_np21 a 
         WHERE
             a.nhdplus_region = p_start_flowline.nhdplus_region
         AND a.hydroseq >= p_start_flowline.hydroseq
         AND a.pathtime <= p_start_path_time + p_num_max_time;

      ELSE
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
         )
         SELECT
          p_start_flowline.permanent_identifier
         ,a.permanent_identifier
         ,p_start_flowline.nhdplus_comid
         ,a.comid
         ,a.reachcode
         ,a.fmeasure
         ,a.tmeasure
         ,NULL AS totaldist
         ,NULL AS totaltime
         ,a.hydroseq
         ,a.levelpathid
         ,a.terminalpathid
         ,a.uphydroseq
         ,a.uplevelpathid
         ,a.dnhydroseq
         ,a.dnlevelpathid
         ,a.dnminorhyd
         ,a.divergence
         ,a.dndraincount
         ,a.pathlength
         ,a.lengthkm
         ,a.lengthkm / (a.tmeasure - a.fmeasure) AS length_measure_ratio
         ,a.pathtime
         ,a.travtime
         ,a.travtime / (a.tmeasure - a.fmeasure) AS time_measure_ratio
         ,NULL AS ofmeasure
         ,NULL AS otmeasure
         ,0
         ,a.nhdplus_region
         ,a.nhdplus_version
         FROM 
         nhdplus.plusflowlinevaa_np21 a 
         WHERE
             a.nhdplus_region = p_start_flowline.nhdplus_region
         AND a.hydroseq >= p_start_flowline.hydroseq;

      END IF;

   ELSIF p_navigation_type IN ('DM','DD','PP')
   THEN
      --Copy to working all flowlines with a lesser hydroseq. (i.e. below the starting comid in the network)
      --If a max stop distance has been supplied, use that to further limit the record count in working.
      
      IF p_num_max_distance IS NOT NULL
      AND p_navigation_type = 'DM'
      THEN
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
         )
         SELECT
          p_start_flowline.permanent_identifier
         ,a.permanent_identifier
         ,p_start_flowline.nhdplus_comid
         ,a.comid
         ,a.reachcode
         ,a.frommeas
         ,a.tomeas
         ,NULL AS totaldist
         ,NULL AS totaltime
         ,a.hydroseq
         ,a.levelpathid
         ,a.terminalpathid
         ,a.uphydroseq
         ,a.uplevelpathid
         ,a.dnhydroseq
         ,a.dnlevelpathid
         ,a.dnminorhyd
         ,a.divergence
         ,a.dndraincount
         ,a.pathlength
         ,a.lengthkm
         ,a.lengthkm / (a.tmeasure - a.fmeasure) AS length_measure_ratio
         ,a.pathtime
         ,a.travtime
         ,a.travtime / (a.tmeasure - a.fmeasure) AS time_measure_ratio
         ,NULL AS ofmeasure
         ,NULL AS otmeasure
         ,0
         ,a.nhdplus_region
         ,a.nhdplus_version
         FROM 
         nhdplus.plusflowlinevaa_np21 a
         WHERE
             a.nhdplus_region = p_start_flowline.nhdplus_region
         AND a.hydroseq <= p_start_flowline.hydroseq 
         AND a.pathlength + a.lengthkm >= p_start_path_length - p_num_max_distance;

      ELSIF p_num_max_time IS NOT NULL
      AND p_navigation_type = 'DM'
      THEN
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
         )
         SELECT
          p_start_flowline.permanent_identifier
         ,a.permanent_identifier
         ,p_start_flowline.nhdplus_comid
         ,a.comid
         ,a.reachcode
         ,a.fmeasure
         ,a.tmeasure
         ,NULL AS totaldist
         ,NULL AS totaltime
         ,a.hydroseq
         ,a.levelpathid
         ,a.terminalpathid
         ,a.uphydroseq
         ,a.uplevelpathid
         ,a.dnhydroseq
         ,a.dnlevelpathid
         ,a.dnminorhyd
         ,a.divergence
         ,a.dndraincount
         ,a.pathlength
         ,a.lengthkm
         ,a.lengthkm / (a.tmeasure - a.fmeasure) AS length_measure_ratio
         ,a.pathtime
         ,a.travtime
         ,a.travtime / (a.tmeasure - a.fmeasure) AS time_measure_ratio
         ,NULL AS ofmeasure
         ,NULL AS otmeasure
         ,0
         ,a.nhdplus_region
         ,a.nhdplus_version
         FROM 
         nhdplus.plusflowlinevaa_np21 a
         WHERE
             a.nhdplus_region = p_start_flowline.nhdplus_region
         AND a.hydroseq <= p_start_flowline.hydroseq  
         AND a.pathtime + a.travtime >= p_start_path_time - p_num_max_time;

      ELSIF p_navigation_type = 'PP'
      THEN
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
         )
         SELECT
          p_start_flowline.permanent_identifier
         ,a.permanent_identifier
         ,p_start_flowline.nhdplus_comid
         ,a.comid
         ,a.reachcode
         ,a.fmeasure
         ,a.tmeasure
         ,NULL AS totaldist
         ,NULL AS totaltime
         ,a.hydroseq
         ,a.levelpathid
         ,a.terminalpathid
         ,a.uphydroseq
         ,a.uplevelpathid
         ,a.dnhydroseq
         ,a.dnlevelpathid
         ,a.dnminorhyd
         ,a.divergence
         ,a.dndraincount
         ,a.pathlength
         ,a.lengthkm
         ,a.lengthkm / (a.tmeasure - a.fmeasure) AS length_measure_ratio
         ,a.pathtime
         ,a.travtime
         ,a.travtime / (a.tmeasure - a.fmeasure) AS time_measure_ratio
         ,NULL AS ofmeasure
         ,NULL AS otmeasure
         ,0
         ,a.nhdplus_region
         ,a.nhdplus_version
         FROM 
         nhdplus.plusflowlinevaa_np21 a
         WHERE
             a.nhdplus_region = p_start_flowline.nhdplus_region
         AND a.hydroseq <= p_start_flowline.hydroseq  
         AND a.hydroseq >= p_stop_flowline.hydroseq;

      ELSE
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
         )
         SELECT
          p_start_flowline.permanent_identifier
         ,a.permanent_identifier
         ,p_start_flowline.nhdplus_comid
         ,a.comid
         ,a.reachcode
         ,a.fmeasure
         ,a.tmeasure
         ,NULL AS totaldist
         ,NULL AS totaltime
         ,a.hydroseq
         ,a.levelpathid
         ,a.terminalpathid
         ,a.uphydroseq
         ,a.uplevelpathid
         ,a.dnhydroseq
         ,a.dnlevelpathid
         ,a.dnminorhyd
         ,a.divergence
         ,a.dndraincount
         ,a.pathlength
         ,a.lengthkm
         ,a.lengthkm / (a.tmeasure - a.fmeasure) AS length_measure_ratio
         ,a.pathtime
         ,a.travtime
         ,a.travtime / (a.tmeasure - a.fmeasure) AS time_measure_ratio
         ,NULL AS ofmeasure
         ,NULL AS otmeasure
         ,0
         ,a.nhdplus_region
         ,a.nhdplus_version
         FROM 
         nhdplus.plusflowlinevaa_np21 a
         WHERE
             a.nhdplus_region = p_start_flowline.nhdplus_region
         AND a.hydroseq <= p_start_flowline.hydroseq;
         
      END IF;

   END IF;
   
   RETURN 0;
   
END;
$$;


ALTER FUNCTION nhdplus_navigation.prepare_working_table(p_navigation_type character varying, p_num_max_distance numeric, p_num_max_time numeric, p_start_flowline nhdplus_navigation.flowline_rec, p_stop_flowline nhdplus_navigation.flowline_rec, p_start_path_length numeric, p_start_path_time numeric) OWNER TO nhdplus_navigation;
