
CREATE OR REPLACE FUNCTION nhdplus_navigation.start_path_length(p_navigation_type character varying, p_fmeasure numeric, p_tmeasure numeric, p_length numeric, p_measure numeric, p_path_length numeric, p_divergence numeric, p_up_hydro_seq numeric, p_type character varying) RETURNS numeric
    LANGUAGE plpgsql
    AS $$ 
DECLARE
   num_inc_dis           NUMERIC := 0;
   num_start_path_length NUMERIC := -1;
   num_uspl              NUMERIC;
   
BEGIN
   
   --------------------------------------------------------------------------
   -- Calculate Starting pathlength
   -- Normally, this is the pathlength plus the 'bottom included distance'
   -- When going up from a flowline that is div 2, the starting 
   -- pathlength is the pathlength of the upstream flowline minus the 
   -- 'top included distance'
   --------------------------------------------------------------------------
   IF p_navigation_type IN ('DM','DD','PP')
   OR p_divergence <> 2
   THEN
      -- Normal
      num_inc_dis := nhdplus_navigation.included_distance(
          p_fmeasure  := p_fmeasure
         ,p_tmeasure  := p_tmeasure
         ,p_length    := p_length
         ,p_measure   := p_measure
         ,p_half      := 'BOTTOM'
      );
      
      num_start_path_length := p_path_length + num_inc_dis;

   ELSE
      IF p_type = 'TIME'
      THEN
         SELECT 
         a.pathtime 
         INTO num_uspl
         FROM 
         nhdplus.plusflowlinevaa_np21 a 
         WHERE
         a.hydroseq = p_up_hydro_seq;
         
      ELSE
         SELECT
         a.pathlength
         INTO num_uspl
         FROM
         nhdplus.plusflowlinevaa_np21 a
         WHERE
         a.hydroseq = p_up_hydro_seq;
         
      END IF;

      num_inc_dis := nhdplus_navigation.included_distance(
          p_fmeasure  := p_fmeasure
         ,p_tmeasure  := p_tmeasure
         ,p_length    := p_length
         ,p_measure   := p_measure
         ,p_half      := 'TOP'
      );
      
      num_start_path_length := num_uspl - num_inc_dis;

   END IF;

   RETURN num_start_path_length;
   
END;
$$;


ALTER FUNCTION nhdplus_navigation.start_path_length(p_navigation_type character varying, p_fmeasure numeric, p_tmeasure numeric, p_length numeric, p_measure numeric, p_path_length numeric, p_divergence numeric, p_up_hydro_seq numeric, p_type character varying) OWNER TO nhdplus_navigation;
