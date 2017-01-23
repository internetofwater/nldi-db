
CREATE OR REPLACE FUNCTION nhdplus_navigation.measure_at_distance(p_fmeasure numeric, p_tmeasure numeric, p_length numeric, p_distance numeric, p_half character varying) RETURNS numeric
    LANGUAGE plpgsql
    AS $$ 
DECLARE
BEGIN
   
   -- Calculate Measure at a provided distance
   -- 'tmeasure' references the to measure which will actually be the from point of nhdflowline.
   -- 'fmeasure' references the from measure which will actually be the to point of nhdflowline.
   -- X is the measure supplied by the user
   -- Arrows indicate coordinate ordering - which is in agreement with the flow table
   --NHDFlowline C:   A(Tomeas)--->---X------>----->-----B(Frommeas)
   --Distance from A to X is the 'TOP'   (will need to be included in upstream navigations)
   --Distance from X to B is the 'BOTTOM' (will need to be included in downstream navigations)
   
   IF p_half = 'TOP'
   THEN
      RETURN ROUND(p_tmeasure - (((p_tmeasure - p_fmeasure) / p_length) * p_distance),5);
      
   ELSIF p_half = 'BOTTOM'
   THEN
      RETURN ROUND(p_fmeasure + (((p_tmeasure - p_fmeasure) / p_length) * p_distance),5);
   
   ELSE
      RAISE EXCEPTION 'err';
         
   END IF;
   
END;
$$;


ALTER FUNCTION nhdplus_navigation.measure_at_distance(p_fmeasure numeric, p_tmeasure numeric, p_length numeric, p_distance numeric, p_half character varying) owner to nhdplus;
