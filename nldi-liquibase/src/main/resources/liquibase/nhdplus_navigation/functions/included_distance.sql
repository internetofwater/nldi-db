CREATE OR REPLACE FUNCTION nhdplus_navigation.included_distance(p_fmeasure numeric, p_tmeasure numeric, p_length numeric, p_measure numeric, p_half character varying) RETURNS numeric
    LANGUAGE plpgsql
    AS $$ 
DECLARE
   num_distance NUMERIC;
   str_half     VARCHAR(4000) := UPPER(p_half);
   
BEGIN
   -- Calculate Included Distance  
   -- (determine the distance along this permid to be included in the navigation)
   -- tmeasure - references the to measure which will actually be the from point of nhdflowline.
   -- fmeasure - references the from measure which will actually be the to point of nhdflowline.
   -- X is the measure supplied by the user
   -- Arrows indicate coordinate ordering - which is in agreement with the flow table

   --NHDFlowline C:   A(tmeasure)--->---X------>----->-----B(fmeasure)

   --Distance from A to X is the 'TOP'   (will need to be included in upstream navigations)
   --Distance from X to B is the 'BOTTOM' (will need to be included in downstream navigations)

   num_distance := p_length * ((p_tmeasure - p_measure) / (p_tmeasure - p_fmeasure));

   IF str_half = 'TOP'
   THEN
      RETURN num_distance;
      
   ELSIF str_half = 'BOTTOM'
   THEN
      RETURN p_length - num_distance;
   
   ELSE
      RAISE EXCEPTION 'err';
      
   END IF;
   
END;
$$;


ALTER FUNCTION nhdplus_navigation.included_distance(p_fmeasure numeric, p_tmeasure numeric, p_length numeric, p_measure numeric, p_half character varying) owner to nhdplus;
