
CREATE OR REPLACE FUNCTION nhdplus_navigation.reference_calculations(p_navigation_type character varying, p_start_measure numeric, p_start_flowline nhdplus_navigation.flowline_rec, p_num_max_distance numeric, p_num_max_time numeric, OUT p_start_path_length numeric, OUT p_start_path_time numeric, OUT p_start_inc_dist numeric, OUT p_start_inc_time numeric) RETURNS record
    LANGUAGE plpgsql
    AS $$ 
DECLARE
   str_section   VARCHAR(10);
   
BEGIN
   
   IF p_navigation_type IN ('UM','UT')
   THEN
      str_section := 'TOP';
   
   ELSE
      str_section := 'BOTTOM';
   
   END IF;

   IF p_navigation_type IN ('UM','UT')
   AND p_start_measure = p_start_flowline.fmeasure
   AND (
      p_num_max_distance >= p_start_flowline.lengthkm
      OR
      p_num_max_time >= p_start_flowline.travtime
   )
   THEN
      p_start_path_length := p_start_flowline.pathlength;
      p_start_path_time   := p_start_flowline.pathtime;
      p_start_inc_dist    := p_start_flowline.lengthkm;
      p_start_inc_time    := p_start_flowline.travtime;
      
   ELSE
      --If going up, need starting pathlength, pathtime, and 'TOP' included distance or time.
      --If going down, need starting pathlength, pathtime, and 'BOTTOM' included distance or time.
      --Will be using the starting pathlength/pathtime to limit the number of records copied
      --     into the working table
      
      p_start_path_length := nhdplus_navigation.start_path_length(
          p_navigation_type := p_navigation_type
         ,p_fmeasure        := p_start_flowline.fmeasure
         ,p_tmeasure        := p_start_flowline.tmeasure
         ,p_length          := p_start_flowline.lengthkm
         ,p_measure         := p_start_measure
         ,p_path_length     := p_start_flowline.pathlength
         ,p_divergence      := p_start_flowline.divergence
         ,p_up_hydro_seq    := p_start_flowline.uphydroseq
         ,p_type            := 'DIST'
      );
      
      p_start_path_time := nhdplus_navigation.start_path_length(
          p_navigation_type := p_navigation_type
         ,p_fmeasure        := p_start_flowline.fmeasure
         ,p_tmeasure        := p_start_flowline.tmeasure
         ,p_length          := p_start_flowline.travtime
         ,p_measure         := p_start_measure
         ,p_path_length     := p_start_flowline.pathtime
         ,p_divergence      := p_start_flowline.divergence
         ,p_up_hydro_seq    := p_start_flowline.uphydroseq
         ,p_type            := 'TIME'
      );

      p_start_inc_dist := nhdplus_navigation.included_distance(
          p_fmeasure        := p_start_flowline.fmeasure
         ,p_tmeasure        := p_start_flowline.tmeasure
         ,p_length          := p_start_flowline.lengthkm
         ,p_measure         := p_start_measure
         ,p_half            := str_section
      );
      
      p_start_inc_time := nhdplus_navigation.included_distance(
          p_fmeasure        := p_start_flowline.fmeasure
         ,p_tmeasure        := p_start_flowline.tmeasure
         ,p_length          := p_start_flowline.travtime
         ,p_measure         := p_start_measure
         ,p_half            := str_section
      );

   END IF;
   
END;
$$;


ALTER FUNCTION nhdplus_navigation.reference_calculations(p_navigation_type character varying, p_start_measure numeric, p_start_flowline nhdplus_navigation.flowline_rec, p_num_max_distance numeric, p_num_max_time numeric, OUT p_start_path_length numeric, OUT p_start_path_time numeric, OUT p_start_inc_dist numeric, OUT p_start_inc_time numeric) owner to nhdplus;
