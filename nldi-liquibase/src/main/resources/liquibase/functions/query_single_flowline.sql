CREATE OR REPLACE FUNCTION nhdplus_navigation.query_single_flowline(p_navigation_type character varying, p_comid integer, p_permanent_identifier character varying, p_hydrosequence numeric, p_reachcode character varying, p_measure numeric, p_check_intent character varying, OUT p_output nhdplus_navigation.flowline_rec, OUT p_check_comid integer, OUT p_check_permanent_identifier character varying, OUT p_check_measure numeric, OUT p_return_code numeric, OUT p_status_message character varying) RETURNS record
    LANGUAGE plpgsql
    AS $$ 
DECLARE
   str_qc           VARCHAR(4000);
   str_exception    VARCHAR(4000);
   
BEGIN
   
   --------------------------------------------------------------------------
   -- Step 10
   -- Check over incoming parameters
   --------------------------------------------------------------------------
   p_check_measure := p_measure;
   
   IF  p_comid IS NULL
   AND p_permanent_identifier IS NULL
   AND p_reachcode IS NULL
   AND p_hydrosequence IS NULL
   THEN
      str_exception := 'procedure requires either hydrosequence, comid or reachcode' || CHR(10) ||
         'permanent_identifier = ' || p_permanent_identifier || CHR(10) ||
         'reachcode = ' || p_reachcode || CHR(10) ||
         'hydrosequence = ' || p_hydrosequence;
         
      RAISE EXCEPTION '%',str_exception;

   END IF;
   
   --------------------------------------------------------------------------
   -- Step 10
   -- Check over incoming parameters
   --------------------------------------------------------------------------
   IF p_hydrosequence IS NOT NULL
   THEN
      str_qc := 'Hydrosequence ' || p_hydrosequence;
      
      SELECT 
       a.permanent_identifier
      ,a.comid
      ,a.reachcode
      ,a.fmeasure
      ,a.tmeasure
      ,a.hydroseq
      ,a.pathlength
      ,a.lengthkm
      ,a.lengthkm / (a.tmeasure - a.fmeasure)
      ,a.pathtime 
      ,a.travtime
      ,a.travtime / (a.tmeasure - a.fmeasure)
      ,a.divergence
      ,a.uphydroseq
      ,a.uplevelpathid
      ,a.dnhydroseq
      ,a.dnlevelpathid
      ,a.terminalpathid
      ,a.levelpathid
      ,a.nhdplus_region
      ,a.nhdplus_version
      INTO STRICT p_output
      FROM 
      nhdplus.plusflowlinevaa_np21 a
      WHERE
      a.hydroseq = p_hydrosequence;
      
      p_check_permanent_identifier := p_output.permanent_identifier;
      
      IF p_check_measure IS NULL
      AND p_navigation_type IN ('DM','DD','PP')
      THEN
         p_check_measure := p_output.tmeasure;
      
      ELSIF p_check_measure IS NULL
      THEN  
         p_check_measure := p_output.fmeasure;
      
      END IF;
      
   ELSIF p_comid IS NOT NULL
   THEN
      str_qc := 'Flowline ' || p_comid::text;
      
      IF p_check_measure IS NULL
      THEN
         SELECT 
          a.permanent_identifier
         ,a.comid
         ,a.reachcode
         ,a.fmeasure
         ,a.tmeasure
         ,a.hydroseq
         ,a.pathlength
         ,a.lengthkm
         ,a.lengthkm / (a.tmeasure - a.fmeasure)
         ,a.pathtime 
         ,a.travtime
         ,a.travtime / (a.tmeasure - a.fmeasure)
         ,a.divergence
         ,a.uphydroseq
         ,a.uplevelpathid
         ,a.dnhydroseq
         ,a.dnlevelpathid
         ,a.terminalpathid
         ,a.levelpathid
         ,a.nhdplus_region
         ,a.nhdplus_version
         INTO STRICT p_output
         FROM
         nhdplus.plusflowlinevaa_np21 a
         WHERE 
         a.comid = p_comid;
         
         p_check_comid := p_output.nhdplus_comid;
         p_check_permanent_identifier := p_output.permanent_identifier;
         
         IF p_navigation_type IN ('DM','DD','PP')
         THEN
            p_check_measure := p_output.tmeasure;

         ELSE
            p_check_measure := p_output.fmeasure;

         END IF;
      
      ELSE
         SELECT 
          a.permanent_identifier
         ,a.comid
         ,a.reachcode
         ,a.fmeasure
         ,a.tmeasure
         ,a.hydroseq
         ,a.pathlength
         ,a.lengthkm
         ,a.lengthkm / (a.tmeasure - a.fmeasure)
         ,a.pathtime 
         ,a.travtime
         ,a.travtime / (a.tmeasure - a.fmeasure)
         ,a.divergence
         ,a.uphydroseq
         ,a.uplevelpathid
         ,a.dnhydroseq
         ,a.dnlevelpathid
         ,a.terminalpathid
         ,a.levelpathid
         ,a.nhdplus_region
         ,a.nhdplus_version
         INTO STRICT p_output
         FROM
         nhdplus.plusflowlinevaa_np21 a
         WHERE 
         a.comid = p_comid
         AND (
            p_check_measure = a.fmeasure
            OR
            (a.fmeasure < p_check_measure AND a.tmeasure >= p_check_measure)
         );
      
         p_check_comid := p_output.nhdplus_comid;
         p_check_permanent_identifier := p_output.permanent_identifier;
      
      END IF;
      
   ELSIF p_permanent_identifier IS NOT NULL
   THEN
      str_qc := 'Flowline ' || p_permanent_identifier;
      
      IF p_check_measure IS NULL
      THEN
         SELECT 
          a.permanent_identifier
         ,a.comid
         ,a.reachcode
         ,a.fmeasure
         ,a.tmeasure
         ,a.hydroseq
         ,a.pathlength
         ,a.lengthkm
         ,a.lengthkm / (a.tmeasure - a.fmeasure)
         ,a.pathtime 
         ,a.travtime
         ,a.travtime / (a.tmeasure - a.fmeasure)
         ,a.divergence
         ,a.uphydroseq
         ,a.uplevelpathid
         ,a.dnhydroseq
         ,a.dnlevelpathid
         ,a.terminalpathid
         ,a.levelpathid
         ,a.nhdplus_region
         ,a.nhdplus_version
         INTO STRICT p_output
         FROM
         nhdplus.plusflowlinevaa_np21 a
         WHERE 
         a.permanent_identifier = p_permanent_identifier;
         
         p_check_comid := p_output.nhdplus_comid;
         p_check_permanent_identifier := p_output.permanent_identifier;

         IF p_navigation_type IN ('DM','DD','PP')
         THEN
            p_check_measure := p_output.tmeasure;

         ELSE
            p_check_measure := p_output.fmeasure;

         END IF;
      
      ELSE
         SELECT 
          a.permanent_identifier
         ,a.comid
         ,a.reachcode
         ,a.fmeasure
         ,a.tmeasure
         ,a.hydroseq
         ,a.pathlength
         ,a.lengthkm
         ,a.lengthkm / (a.tmeasure - a.fmeasure)
         ,a.pathtime 
         ,a.travtime
         ,a.travtime / (a.tmeasure - a.fmeasure)
         ,a.divergence
         ,a.uphydroseq
         ,a.uplevelpathid
         ,a.dnhydroseq
         ,a.dnlevelpathid
         ,a.terminalpathid
         ,a.levelpathid
         ,a.nhdplus_region
         ,a.nhdplus_version
         INTO STRICT p_output
         FROM
         nhdplus.plusflowlinevaa_np21 a
         WHERE 
             a.permanent_identifier = p_permanent_identifier      
         AND (
               p_check_measure = a.fmeasure
               OR
               (a.fmeasure < p_check_measure AND a.tmeasure >= p_check_measure)
            );

            p_check_comid := p_output.nhdplus_comid;
            p_check_permanent_identifier := p_output.permanent_identifier;
      
      END IF;
      
   ELSIF p_reachcode IS NOT NULL
   THEN
      IF p_check_measure IS NULL
      AND p_navigation_type IN ('DM','DD','PP')
      THEN
         p_check_measure := 100;
      
      ELSIF p_check_measure IS NULL
      THEN  
         p_check_measure := 0;
      
      END IF;
      
      str_qc := 'Reach code ' || p_reachcode;
      
      IF p_check_measure = 0
      THEN
         SELECT 
          a.permanent_identifier
         ,a.comid
         ,a.reachcode
         ,a.fmeasure
         ,a.tmeasure
         ,a.hydroseq
         ,a.pathlength
         ,a.lengthkm
         ,a.lengthkm / (a.tmeasure - a.fmeasure)
         ,a.pathtime
         ,a.travtime
         ,a.travtime / (a.tmeasure - a.fmeasure)
         ,a.divergence
         ,a.uphydroseq
         ,a.uplevelpathid
         ,a.dnhydroseq
         ,a.dnlevelpathid
         ,a.terminalpathid
         ,a.levelpathid
         ,a.nhdplus_region
         ,a.nhdplus_version
         INTO STRICT p_output
         FROM
         nhdplus.plusflowlinevaa_np21 a
         WHERE 
             a.reachcode = p_reachcode 
         AND a.fmeasure = 0;
         
      ELSE
         SELECT 
          a.permanent_identifier
         ,a.comid
         ,a.reachcode
         ,a.fmeasure
         ,a.tmeasure
         ,a.hydroseq
         ,a.pathlength
         ,a.lengthkm
         ,a.lengthkm / (a.tmeasure - a.fmeasure)
         ,a.pathtime 
         ,a.travtime
         ,a.travtime / (a.tmeasure - a.fmeasure)
         ,a.divergence
         ,a.uphydroseq
         ,a.uplevelpathid
         ,a.dnhydroseq
         ,a.dnlevelpathid
         ,a.terminalpathid
         ,a.levelpathid
         ,a.nhdplus_region
         ,a.nhdplus_version
         INTO STRICT p_output
         FROM
         nhdplus.plusflowlinevaa_np21 a
         JOIN
         nhdplus.nhdflowline_np21 b
         ON
         a.permanent_identifier = b.permanent_identifier
         WHERE 
             b.reachcode = p_reachcode 
         AND (
            (p_check_measure = 0 AND a.fmeasure = 0)
            OR
            (a.fmeasure < p_check_measure AND a.tmeasure >= p_check_measure)
         );
      
      END IF;
      
      p_check_comid := p_output.nhdplus_comid;
      p_check_permanent_identifier := p_output.permanent_identifier;
      
   END IF;
   
   p_return_code := 0;
   RETURN;

EXCEPTION
   WHEN no_data_found
   THEN
      IF p_check_measure IS NULL
      THEN
         p_status_message := str_qc || ' not found in NHDPlus stream network.';

      ELSE
         p_status_message := str_qc || ' at measure ' || p_check_measure::text || ' not found in NHDPlus stream network.';

      END IF;
         
      p_return_code := 999;
      RETURN;
      
   WHEN OTHERS
   THEN
      RAISE;
   
END;
$$;

ALTER FUNCTION nhdplus_navigation.query_single_flowline(p_navigation_type character varying, p_comid integer, p_permanent_identifier character varying, p_hydrosequence numeric, p_reachcode character varying, p_measure numeric, p_check_intent character varying, OUT p_output nhdplus_navigation.flowline_rec, OUT p_check_comid integer, OUT p_check_permanent_identifier character varying, OUT p_check_measure numeric, OUT p_return_code numeric, OUT p_status_message character varying) OWNER TO nhdplus_navigation;
