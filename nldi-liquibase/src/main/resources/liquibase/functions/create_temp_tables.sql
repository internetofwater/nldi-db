
CREATE FUNCTION nhdplus_navigation.create_temp_tables() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN
   
   ----------------------------------------------------------------------------
   -- Step 10
   -- Create tmp_navigation_connections temp table
   ----------------------------------------------------------------------------
   IF nhdplus_navigation.temp_table_exists('tmp_navigation_connections')
   THEN
      TRUNCATE TABLE tmp_navigation_connections;
      
   ELSE
      CREATE TEMPORARY TABLE tmp_navigation_connections(
          start_permanent_identifier  VARCHAR(40)
         ,permanent_identifier        VARCHAR(40)
         ,start_nhdplus_comid         INTEGER
         ,nhdplus_comid               INTEGER
         ,reachcode                   VARCHAR(14)
         ,fmeasure                    NUMERIC
         ,tmeasure                    NUMERIC
         ,totaldist                   NUMERIC
         ,totaltime                   NUMERIC
         ,hydroseq                    INTEGER
         ,levelpathid                 INTEGER
         ,terminalpathid              INTEGER
         ,uphydroseq                  INTEGER
         ,dnhydroseq                  INTEGER
         ,pathlength                  NUMERIC
         ,lengthkm                    NUMERIC
         ,length_measure_ratio        NUMERIC
         ,pathtime                    NUMERIC
         ,travtime                    NUMERIC
         ,time_measure_ratio          NUMERIC
         ,ofmeasure                   NUMERIC
         ,otmeasure                   NUMERIC
         ,nhdplus_region              VARCHAR(3)
         ,nhdplus_version             VARCHAR(6)
         ,reachsmdate                 DATE
         ,ftype                       INTEGER
         ,fcode                       INTEGER
         ,gnis_id                     VARCHAR(10)
         ,wbarea_permanent_identifier VARCHAR(40)
         ,wbarea_nhdplus_comid        INTEGER
         ,wbd_huc12                   VARCHAR(12)
         ,catchment_featureid         INTEGER
         ,shape                       geometry
      );

      CREATE UNIQUE INDEX tmp_navigation_connections_pk 
      ON tmp_navigation_connections(permanent_identifier);
      
      CREATE UNIQUE INDEX tmp_navigation_connections_pk2 
      ON tmp_navigation_connections(nhdplus_comid);

      CREATE INDEX tmp_navigation_connections_08i 
      ON tmp_navigation_connections(hydroseq);

      CREATE INDEX tmp_navigation_connections_09i 
      ON tmp_navigation_connections(levelpathid);

      CREATE INDEX tmp_navigation_connections_10i 
      ON tmp_navigation_connections(terminalpathid);

      CREATE INDEX tmp_navigation_connections_13i 
      ON tmp_navigation_connections(pathlength);

      CREATE INDEX tmp_navigation_connections_16i 
      ON tmp_navigation_connections(pathtime);

   END IF;

   ----------------------------------------------------------------------------
   -- Step 20
   -- Create tmp_navigation_connections_dd temp table
   ----------------------------------------------------------------------------
   IF nhdplus_navigation.temp_table_exists('tmp_navigation_connections_dd')
   THEN
      TRUNCATE TABLE tmp_navigation_connections_dd;
      
   ELSE
      CREATE TEMPORARY TABLE tmp_navigation_connections_dd(
          start_permanent_identifier  VARCHAR(40)
         ,permanent_identifier        VARCHAR(40)
         ,start_nhdplus_comid         INTEGER
         ,nhdplus_comid               INTEGER
         ,reachcode                   VARCHAR(14)
         ,fmeasure                    NUMERIC
         ,tmeasure                    NUMERIC
         ,totaldist                   NUMERIC
         ,totaltime                   NUMERIC
         ,hydroseq                    INTEGER
         ,levelpathid                 INTEGER
         ,terminalpathid              INTEGER
         ,uphydroseq                  INTEGER
         ,dnhydroseq                  INTEGER
         ,pathlength                  NUMERIC
         ,lengthkm                    NUMERIC
         ,length_measure_ratio        NUMERIC
         ,pathtime                    NUMERIC
         ,travtime                    NUMERIC
         ,time_measure_ratio          NUMERIC
         ,ofmeasure                   NUMERIC
         ,otmeasure                   NUMERIC
         ,processed                   NUMERIC(11)
         ,nhdplus_region              VARCHAR(3)
         ,nhdplus_version             VARCHAR(6)
         ,reachsmdate                 DATE
         ,ftype                       NUMERIC(3)
         ,fcode                       NUMERIC(5)
         ,gnis_id                     VARCHAR(10)
         ,wbarea_permanent_identifier VARCHAR(40)
         ,wbarea_nhdplus_comid        INTEGER
         ,wbd_huc12                   VARCHAR(12)
         ,catchment_featureid         INTEGER
         ,shape                       geometry
      );

      CREATE UNIQUE INDEX tmp_navigation_connections_dd_pk
      ON tmp_navigation_connections_dd(permanent_identifier);
      
      CREATE UNIQUE INDEX tmp_navigation_connections_dd_pk2
      ON tmp_navigation_connections_dd(nhdplus_comid);

      CREATE INDEX tmp_navigation_connections_dd_08i 
      ON tmp_navigation_connections_dd(hydroseq);

      CREATE INDEX tmp_navigation_connections_dd_09i 
      ON tmp_navigation_connections_dd(levelpathid);

      CREATE INDEX tmp_navigation_connections_dd_10i 
      ON tmp_navigation_connections_dd(terminalpathid);

      CREATE INDEX tmp_navigation_connections_dd_13i 
      ON tmp_navigation_connections_dd(pathlength);

      CREATE INDEX tmp_navigation_connections_dd_16i 
      ON tmp_navigation_connections_dd(pathtime);

      CREATE INDEX tmp_navigation_connections_dd_21i 
      ON tmp_navigation_connections_dd(processed);
      
   END IF;
   
   ----------------------------------------------------------------------------
   -- Step 30
   -- Create tmp_navigation_uptrib temp table
   ----------------------------------------------------------------------------
   IF nhdplus_navigation.temp_table_exists('tmp_navigation_uptrib')
   THEN
      TRUNCATE TABLE tmp_navigation_uptrib;
      
   ELSE
      CREATE TEMPORARY TABLE tmp_navigation_uptrib(
          fromlevelpathid             INTEGER
         ,minhs                       INTEGER
      );

      CREATE UNIQUE INDEX tmp_navigation_uptrib_pk
      ON tmp_navigation_uptrib(fromlevelpathid);

   END IF;
   
   ----------------------------------------------------------------------------
   -- Step 40
   -- Create tmp_navigation_working temp table
   ----------------------------------------------------------------------------
   IF nhdplus_navigation.temp_table_exists('tmp_navigation_working')
   THEN
      TRUNCATE TABLE tmp_navigation_working;
      
   ELSE
      CREATE TEMPORARY TABLE tmp_navigation_working(
          start_permanent_identifier  VARCHAR(40)
         ,permanent_identifier        VARCHAR(40)
         ,start_nhdplus_comid         INTEGER
         ,nhdplus_comid               INTEGER
         ,reachcode                   VARCHAR(14)
         ,fmeasure                    NUMERIC
         ,tmeasure                    NUMERIC
         ,totaldist                   NUMERIC
         ,totaltime                   NUMERIC
         ,hydroseq                    INTEGER
         ,levelpathid                 INTEGER
         ,terminalpathid              INTEGER
         ,uphydroseq                  INTEGER
         ,uplevelpathid               INTEGER
         ,dnhydroseq                  INTEGER
         ,dnlevelpathid               INTEGER
         ,dnminorhyd                  INTEGER
         ,divergence                  INTEGER
         ,dndraincount                INTEGER
         ,pathlength                  NUMERIC
         ,lengthkm                    NUMERIC
         ,length_measure_ratio        NUMERIC
         ,pathtime                    NUMERIC
         ,travtime                    NUMERIC
         ,time_measure_ratio          NUMERIC
         ,ofmeasure                   NUMERIC
         ,otmeasure                   NUMERIC
         ,selected                    INTEGER
         ,nhdplus_region              VARCHAR(3)
         ,nhdplus_version             VARCHAR(6)
         ,reachsmdate                 DATE
      );

      CREATE UNIQUE INDEX tmp_navigation_working_pk
      ON tmp_navigation_working(permanent_identifier);
      
      CREATE UNIQUE INDEX tmp_navigation_working_pk2
      ON tmp_navigation_working(permanent_identifier);

      CREATE INDEX tmp_navigation_working_03i 
      ON tmp_navigation_working(reachcode);

      CREATE INDEX tmp_navigation_working_08i 
      ON tmp_navigation_working(hydroseq);
      
      CREATE INDEX tmp_navigation_working_09i 
      ON tmp_navigation_working(levelpathid);

      CREATE INDEX tmp_navigation_working_10i 
      ON tmp_navigation_working(terminalpathid);

      CREATE INDEX tmp_navigation_working_13i 
      ON tmp_navigation_working(pathlength);

      CREATE INDEX tmp_navigation_working_16i 
      ON tmp_navigation_working(pathtime);

      CREATE INDEX tmp_navigation_working_17i 
      ON tmp_navigation_working(dndraincount);

      CREATE INDEX tmp_navigation_working_26i 
      ON tmp_navigation_working(selected);

   END IF;

   ----------------------------------------------------------------------------
   -- Step 70
   -- I guess that went okay
   ----------------------------------------------------------------------------
   RETURN 0;
   
END;
$$;


ALTER FUNCTION nhdplus_navigation.create_temp_tables() OWNER TO nhdplus_navigation;
