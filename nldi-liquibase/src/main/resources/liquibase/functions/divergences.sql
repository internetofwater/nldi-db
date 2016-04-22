
CREATE OR REPLACE FUNCTION nhdplus_navigation.divergences(INOUT p_list_divs nhdplus_navigation.listdivs_rec[], INOUT p_divergence_count numeric) RETURNS record
    LANGUAGE plpgsql
    AS $$ 
DECLARE
   int_found            INTEGER;
   int_temp             INTEGER;
   rec_divergences      nhdplus_navigation.type_recdivs;
   rec_flowline         nhdplus_navigation.flowline_rec;
   rec_mega_divergences nhdplus_navigation.typ_rec_mega_divergences;
   str_status_message   VARCHAR(4000);
   num_return_code      NUMERIC;
   str_dummy            VARCHAR(4000);
   int_dummy            INTEGER;
   num_dummy            NUMERIC;
   r                    RECORD;
   
   curs_divergences CURSOR FOR
   SELECT 
    a.permanent_identifier
   ,a.nhdplus_comid
   ,a.reachcode
   ,a.hydroseq
   ,a.pathlength
   ,a.terminalpathid
   ,a.levelpathid
   ,a.uphydroseq
   ,a.uplevelpathid
   ,a.dnhydroseq
   ,a.dnlevelpathid
   ,a.dnminorhyd
   ,a.divergence
   ,a.dndraincount
   ,a.fmeasure
   ,a.tmeasure
   ,a.lengthkm
   ,a.travtime
   ,a.pathtime
   ,a.selected
   ,a.ofmeasure
   ,a.otmeasure
   ,a.totaldist
   ,a.totaltime 
   ,a.nhdplus_region
   FROM 
   tmp_navigation_working a 
   WHERE 
       a.selected     =  1 
   AND a.dndraincount >= 2 
   ORDER BY 
   a.hydroseq DESC;
   
   curs_mega_divergences CURSOR(
      p_comid INTEGER
   ) IS
   SELECT 
    a.fromcomid
   ,b.nhdplus_comid
   ,b.hydroseq 
   FROM 
   nhdplus.megadiv_np21 a
   JOIN
   tmp_navigation_working b
   ON
   a.tocomid = b.nhdplus_comid
   WHERE 
   a.fromcomid = p_comid 
   ORDER BY 
   b.hydroseq DESC;

BEGIN

   OPEN curs_divergences;
   LOOP
      FETCH curs_divergences INTO rec_divergences;
      IF NOT FOUND
      THEN
         EXIT;
         
      END IF;

      IF rec_divergences.dndraincount = 2
      THEN
         --two outflows
         --See if the minor downstream hs exists in the list already
         int_temp := rec_divergences.dnminorhyd;
         int_found := 0;

         IF p_list_divs IS NOT NULL
         AND array_length(p_list_divs,1) > 0
         THEN
            FOR i IN 1 .. array_length(p_list_divs,1)
            LOOP
               IF p_list_divs[i].hydroseq = int_temp
               THEN
                  int_found := 1;
                     
               END IF;
                  
            END LOOP;
            
         END IF;

         --If not - add it
         IF int_found = 0
         THEN
            --HS does not exist - so add
            r := nhdplus_navigation.query_single_flowline(
                p_navigation_type      := 'DM'
               ,p_comid                := NULL
               ,p_permanent_identifier := NULL
               ,p_hydrosequence        := int_temp
               ,p_reachcode            := NULL
               ,p_measure              := NULL
               ,p_check_intent         := NULL
            );
            rec_flowline       := r.p_output;
            int_dummy          := r.p_check_comid;
            num_dummy          := r.p_check_measure;
            num_return_code    := r.p_return_code;
            str_status_message := r.p_status_message;
            
            IF rec_flowline.nhdplus_comid IS NOT NULL
            THEN
               p_divergence_count := p_divergence_count + 1;
               
               p_list_divs[p_divergence_count] := (
                   rec_flowline.permanent_identifier -- permanent_identifier
                  ,rec_flowline.nhdplus_comid
                  ,rec_flowline.fmeasure         -- fmeasure
                  ,rec_flowline.tmeasure         -- tmeasure
                  ,rec_flowline.hydroseq         -- hydroseq
                  ,rec_flowline.pathlength       -- pathlength
                  ,rec_flowline.pathtime         -- pathtime
                  ,rec_flowline.lengthkm         -- lengthkm
                  ,rec_flowline.travtime         -- travtime
                  ,rec_flowline.terminalpathid   -- terminalpathid   
                  ,rec_flowline.levelpathid      -- levelpathid
                  ,rec_flowline.uphydroseq       -- uphydroseq
                  ,rec_flowline.divergence       -- divergence
                  ,0                             -- done
                  ,rec_flowline.nhdplus_region   -- nhdplus_region
                  ,rec_flowline.nhdplus_version  -- nhdplus_version
               )::nhdplus_navigation.listdivs_rec;
               
            END IF;
            
         END IF;
         
      ELSE
         OPEN curs_mega_divergences(
            rec_divergences.nhdplus_comid
         );

         LOOP
            FETCH curs_mega_divergences INTO rec_mega_divergences;
            EXIT WHEN NOT FOUND;

            r := nhdplus_navigation.query_single_flowline(
                p_navigation_type      := 'DM'
               ,p_comid                := rec_mega_divergences.comid
               ,p_permanent_identifier := NULL
               ,p_hydrosequence        := NULL
               ,p_reachcode            := NULL
               ,p_measure              := NULL
               ,p_check_intent         := NULL
            );
            rec_flowline       := r.p_output;
            num_return_code    := r.p_return_code;
            str_status_message := r.p_status_message;

            IF rec_flowline.nhdplus_comid IS NOT NULL
            THEN
               --See if the divergence exists in the list already
               int_temp  := rec_flowline.hydroseq;
               int_found := 0;
               
               IF p_list_divs IS NOT NULL
               AND array_length(p_list_divs,1) > 0
               THEN
                  FOR i IN 1 .. array_length(p_list_divs,1)
                  LOOP
                     IF p_list_divs[i].hydroseq = int_temp
                     THEN
                        int_found := 1;
                           
                     END IF;
                        
                  END LOOP;
                  
               END IF;

               IF int_found = 0
               THEN
                  --See if the divergence has already been navigated
                  SELECT 
                  a.selected 
                  INTO int_temp
                  FROM 
                  tmp_navigation_working a 
                  WHERE 
                  a.hydroseq = rec_flowline.hydroseq;

                  IF int_temp >= 1
                  THEN
                     int_found := 1;
                     
                  END IF;

               END IF;

               --If not - add it
               IF int_found = 0
               THEN
                  p_divergence_count := p_divergence_count + 1;
                  p_list_divs[p_divergence_count] := (
                      rec_flowline.permanent_identifier -- permanent_identifier
                     ,rec_flowline.nhdplus_comid        -- nhdplus_comid
                     ,rec_flowline.fmeasure             -- fmeasure
                     ,rec_flowline.tmeasure             -- tmeasure
                     ,rec_flowline.hydroseq             -- hydroseq
                     ,rec_flowline.pathlength           -- pathlength
                     ,rec_flowline.pathtime             -- pathtime
                     ,rec_flowline.lengthkm             -- lengthkm
                     ,rec_flowline.travtime             -- travtime
                     ,rec_flowline.terminalpathid       -- terminalpathid   
                     ,rec_flowline.levelpathid          -- levelpathid
                     ,rec_flowline.uphydroseq           -- uphydroseq
                     ,rec_flowline.divergence           -- divergence
                     ,0                                 -- done
                     ,rec_flowline.nhdplus_region       -- nhdplus_region
                     ,rec_flowline.nhdplus_version      -- nhdplus_version
                  )::nhdplus_navigation.listdivs_rec;
                  
               END IF;
               
            ELSE
               NULL;
               
            END IF;
            
         END LOOP;

         CLOSE curs_mega_divergences;

      END IF;

   END LOOP;

   CLOSE curs_divergences;
   
END;
$$;


ALTER FUNCTION nhdplus_navigation.divergences(INOUT p_list_divs nhdplus_navigation.listdivs_rec[], INOUT p_divergence_count numeric) OWNER TO nhdplus_navigation;
