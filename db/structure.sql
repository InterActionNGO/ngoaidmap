--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: box2d; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE box2d;


--
-- Name: box2d_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION box2d_in(cstring) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'BOX2D_in';


--
-- Name: box2d_out(box2d); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION box2d_out(box2d) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'BOX2D_out';


--
-- Name: box2d; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE box2d (
    INTERNALLENGTH = 65,
    INPUT = box2d_in,
    OUTPUT = box2d_out,
    ALIGNMENT = int4,
    STORAGE = plain
);


--
-- Name: TYPE box2d; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TYPE box2d IS 'postgis type: A box composed of x min, ymin, xmax, ymax. Often used to return the 2d enclosing box of a geometry.';


--
-- Name: box2df; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE box2df;


--
-- Name: box2df_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION box2df_in(cstring) RETURNS box2df
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'box2df_in';


--
-- Name: box2df_out(box2df); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION box2df_out(box2df) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'box2df_out';


--
-- Name: box2df; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE box2df (
    INTERNALLENGTH = 16,
    INPUT = box2df_in,
    OUTPUT = box2df_out,
    ALIGNMENT = double,
    STORAGE = plain
);


--
-- Name: box3d; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE box3d;


--
-- Name: box3d_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION box3d_in(cstring) RETURNS box3d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'BOX3D_in';


--
-- Name: box3d_out(box3d); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION box3d_out(box3d) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'BOX3D_out';


--
-- Name: box3d; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE box3d (
    INTERNALLENGTH = 52,
    INPUT = box3d_in,
    OUTPUT = box3d_out,
    ALIGNMENT = double,
    STORAGE = plain
);


--
-- Name: TYPE box3d; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TYPE box3d IS 'postgis type: A box composed of x min, ymin, zmin, xmax, ymax, zmax. Often used to return the 3d extent of a geometry or collection of geometries.';


--
-- Name: geography; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE geography;


--
-- Name: geography_analyze(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geography_analyze(internal) RETURNS boolean
    LANGUAGE c STRICT
    AS '$libdir/postgis-2.1', 'gserialized_analyze_nd';


--
-- Name: geography_in(cstring, oid, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geography_in(cstring, oid, integer) RETURNS geography
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geography_in';


--
-- Name: geography_out(geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geography_out(geography) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geography_out';


--
-- Name: geography_recv(internal, oid, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geography_recv(internal, oid, integer) RETURNS geography
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geography_recv';


--
-- Name: geography_send(geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geography_send(geography) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geography_send';


--
-- Name: geography_typmod_in(cstring[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geography_typmod_in(cstring[]) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geography_typmod_in';


--
-- Name: geography_typmod_out(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geography_typmod_out(integer) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'postgis_typmod_out';


--
-- Name: geography; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE geography (
    INTERNALLENGTH = variable,
    INPUT = geography_in,
    OUTPUT = geography_out,
    RECEIVE = geography_recv,
    SEND = geography_send,
    TYPMOD_IN = geography_typmod_in,
    TYPMOD_OUT = geography_typmod_out,
    ANALYZE = geography_analyze,
    DELIMITER = ':',
    ALIGNMENT = double,
    STORAGE = main
);


--
-- Name: TYPE geography; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TYPE geography IS 'postgis type: Ellipsoidal spatial data type.';


--
-- Name: geometry; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE geometry;


--
-- Name: geometry_analyze(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_analyze(internal) RETURNS boolean
    LANGUAGE c STRICT
    AS '$libdir/postgis-2.1', 'gserialized_analyze_nd';


--
-- Name: geometry_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_in(cstring) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_in';


--
-- Name: geometry_out(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_out(geometry) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_out';


--
-- Name: geometry_recv(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_recv(internal) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_recv';


--
-- Name: geometry_send(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_send(geometry) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_send';


--
-- Name: geometry_typmod_in(cstring[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_typmod_in(cstring[]) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geometry_typmod_in';


--
-- Name: geometry_typmod_out(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_typmod_out(integer) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'postgis_typmod_out';


--
-- Name: geometry; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE geometry (
    INTERNALLENGTH = variable,
    INPUT = geometry_in,
    OUTPUT = geometry_out,
    RECEIVE = geometry_recv,
    SEND = geometry_send,
    TYPMOD_IN = geometry_typmod_in,
    TYPMOD_OUT = geometry_typmod_out,
    ANALYZE = geometry_analyze,
    DELIMITER = ':',
    ALIGNMENT = double,
    STORAGE = main
);


--
-- Name: TYPE geometry; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TYPE geometry IS 'postgis type: Planar spatial data type.';


--
-- Name: geometry_dump; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE geometry_dump AS (
  path integer[],
  geom geometry
);


--
-- Name: TYPE geometry_dump; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TYPE geometry_dump IS 'postgis type: A spatial datatype with two fields - geom (holding a geometry object) and path[] (a 1-d array holding the position of the geometry within the dumped object.)';


--
-- Name: gidx; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE gidx;


--
-- Name: gidx_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION gidx_in(cstring) RETURNS gidx
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'gidx_in';


--
-- Name: gidx_out(gidx); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION gidx_out(gidx) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'gidx_out';


--
-- Name: gidx; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE gidx (
    INTERNALLENGTH = variable,
    INPUT = gidx_in,
    OUTPUT = gidx_out,
    ALIGNMENT = double,
    STORAGE = plain
);


--
-- Name: intbig_gkey; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE intbig_gkey;


--
-- Name: _intbig_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _intbig_in(cstring) RETURNS intbig_gkey
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', '_intbig_in';


--
-- Name: _intbig_out(intbig_gkey); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _intbig_out(intbig_gkey) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', '_intbig_out';


--
-- Name: intbig_gkey; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE intbig_gkey (
    INTERNALLENGTH = variable,
    INPUT = _intbig_in,
    OUTPUT = _intbig_out,
    ALIGNMENT = int4,
    STORAGE = plain
);


--
-- Name: pgis_abs; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE pgis_abs;


--
-- Name: pgis_abs_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION pgis_abs_in(cstring) RETURNS pgis_abs
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'pgis_abs_in';


--
-- Name: pgis_abs_out(pgis_abs); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION pgis_abs_out(pgis_abs) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'pgis_abs_out';


--
-- Name: pgis_abs; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE pgis_abs (
    INTERNALLENGTH = 8,
    INPUT = pgis_abs_in,
    OUTPUT = pgis_abs_out,
    ALIGNMENT = double,
    STORAGE = plain
);


--
-- Name: query_int; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE query_int;


--
-- Name: bqarr_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION bqarr_in(cstring) RETURNS query_int
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'bqarr_in';


--
-- Name: bqarr_out(query_int); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION bqarr_out(query_int) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'bqarr_out';


--
-- Name: query_int; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE query_int (
    INTERNALLENGTH = variable,
    INPUT = bqarr_in,
    OUTPUT = bqarr_out,
    ALIGNMENT = int4,
    STORAGE = plain
);


--
-- Name: spheroid; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE spheroid;


--
-- Name: spheroid_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION spheroid_in(cstring) RETURNS spheroid
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'ellipsoid_in';


--
-- Name: spheroid_out(spheroid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION spheroid_out(spheroid) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'ellipsoid_out';


--
-- Name: spheroid; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE spheroid (
    INTERNALLENGTH = 65,
    INPUT = spheroid_in,
    OUTPUT = spheroid_out,
    ALIGNMENT = double,
    STORAGE = plain
);


--
-- Name: valid_detail; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE valid_detail AS (
  valid boolean,
  reason character varying,
  location geometry
);


--
-- Name: _int_contained(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _int_contained(integer[], integer[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', '_int_contained';


--
-- Name: FUNCTION _int_contained(integer[], integer[]); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION _int_contained(integer[], integer[]) IS 'contained in';


--
-- Name: _int_contains(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _int_contains(integer[], integer[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', '_int_contains';


--
-- Name: FUNCTION _int_contains(integer[], integer[]); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION _int_contains(integer[], integer[]) IS 'contains';


--
-- Name: _int_different(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _int_different(integer[], integer[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', '_int_different';


--
-- Name: FUNCTION _int_different(integer[], integer[]); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION _int_different(integer[], integer[]) IS 'different';


--
-- Name: _int_inter(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _int_inter(integer[], integer[]) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', '_int_inter';


--
-- Name: _int_overlap(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _int_overlap(integer[], integer[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', '_int_overlap';


--
-- Name: FUNCTION _int_overlap(integer[], integer[]); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION _int_overlap(integer[], integer[]) IS 'overlaps';


--
-- Name: _int_same(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _int_same(integer[], integer[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', '_int_same';


--
-- Name: FUNCTION _int_same(integer[], integer[]); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION _int_same(integer[], integer[]) IS 'same as';


--
-- Name: _int_union(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _int_union(integer[], integer[]) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', '_int_union';


--
-- Name: _postgis_deprecate(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _postgis_deprecate(oldname text, newname text, version text) RETURNS void
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
DECLARE
  curver_text text;
BEGIN
  --
  -- Raises a NOTICE if it was deprecated in this version,
  -- a WARNING if in a previous version (only up to minor version checked)
  --
    curver_text := '2.1.2';
    IF split_part(curver_text,'.',1)::int > split_part(version,'.',1)::int OR
       ( split_part(curver_text,'.',1) = split_part(version,'.',1) AND
         split_part(curver_text,'.',2) != split_part(version,'.',2) )
    THEN
      RAISE WARNING '% signature was deprecated in %. Please use %', oldname, version, newname;
    ELSE
      RAISE DEBUG '% signature was deprecated in %. Please use %', oldname, version, newname;
    END IF;
END;
$$;


--
-- Name: _postgis_join_selectivity(regclass, text, regclass, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _postgis_join_selectivity(regclass, text, regclass, text, text DEFAULT '2'::text) RETURNS double precision
    LANGUAGE c STRICT
    AS '$libdir/postgis-2.1', '_postgis_gserialized_joinsel';


--
-- Name: _postgis_selectivity(regclass, text, geometry, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _postgis_selectivity(tbl regclass, att_name text, geom geometry, mode text DEFAULT '2'::text) RETURNS double precision
    LANGUAGE c STRICT
    AS '$libdir/postgis-2.1', '_postgis_gserialized_sel';


--
-- Name: _postgis_stats(regclass, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _postgis_stats(tbl regclass, att_name text, text DEFAULT '2'::text) RETURNS text
    LANGUAGE c STRICT
    AS '$libdir/postgis-2.1', '_postgis_gserialized_stats';


--
-- Name: _st_3ddfullywithin(geometry, geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_3ddfullywithin(geom1 geometry, geom2 geometry, double precision) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'LWGEOM_dfullywithin3d';


--
-- Name: _st_3ddwithin(geometry, geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_3ddwithin(geom1 geometry, geom2 geometry, double precision) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'LWGEOM_dwithin3d';


--
-- Name: _st_3dintersects(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_3dintersects(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'intersects3d';


--
-- Name: _st_asgeojson(integer, geography, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_asgeojson(integer, geography, integer, integer) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geography_as_geojson';


--
-- Name: _st_asgeojson(integer, geometry, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_asgeojson(integer, geometry, integer, integer) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_asGeoJson';


--
-- Name: _st_asgml(integer, geography, integer, integer, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_asgml(integer, geography, integer, integer, text, text) RETURNS text
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-2.1', 'geography_as_gml';


--
-- Name: _st_asgml(integer, geometry, integer, integer, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_asgml(integer, geometry, integer, integer, text, text) RETURNS text
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-2.1', 'LWGEOM_asGML';


--
-- Name: _st_askml(integer, geography, integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_askml(integer, geography, integer, text) RETURNS text
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-2.1', 'geography_as_kml';


--
-- Name: _st_askml(integer, geometry, integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_askml(integer, geometry, integer, text) RETURNS text
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-2.1', 'LWGEOM_asKML';


--
-- Name: _st_asx3d(integer, geometry, integer, integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_asx3d(integer, geometry, integer, integer, text) RETURNS text
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-2.1', 'LWGEOM_asX3D';


--
-- Name: _st_bestsrid(geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_bestsrid(geography) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_BestSRID($1,$1)$_$;


--
-- Name: _st_bestsrid(geography, geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_bestsrid(geography, geography) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geography_bestsrid';


--
-- Name: _st_buffer(geometry, double precision, cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_buffer(geometry, double precision, cstring) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'buffer';


--
-- Name: _st_concavehull(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_concavehull(param_inputgeom geometry) RETURNS geometry
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
  DECLARE     
  vexhull GEOMETRY;
  var_resultgeom geometry;
  var_inputgeom geometry;
  vexring GEOMETRY;
  cavering GEOMETRY;
  cavept geometry[];
  seglength double precision;
  var_tempgeom geometry;
  scale_factor integer := 1;
  i integer;
  
  BEGIN

    -- First compute the ConvexHull of the geometry
    vexhull := ST_ConvexHull(param_inputgeom);
    var_inputgeom := param_inputgeom;
    --A point really has no concave hull
    IF ST_GeometryType(vexhull) = 'ST_Point' OR ST_GeometryType(vexHull) = 'ST_LineString' THEN
      RETURN vexhull;
    END IF;

    -- convert the hull perimeter to a linestring so we can manipulate individual points
    vexring := CASE WHEN ST_GeometryType(vexhull) = 'ST_LineString' THEN vexhull ELSE ST_ExteriorRing(vexhull) END;
    IF abs(ST_X(ST_PointN(vexring,1))) < 1 THEN --scale the geometry to prevent stupid precision errors - not sure it works so make low for now
      scale_factor := 100;
      vexring := ST_Scale(vexring, scale_factor,scale_factor);
      var_inputgeom := ST_Scale(var_inputgeom, scale_factor, scale_factor);
      --RAISE NOTICE 'Scaling';
    END IF;
    seglength := ST_Length(vexring)/least(ST_NPoints(vexring)*2,1000) ;

    vexring := ST_Segmentize(vexring, seglength);
    -- find the point on the original geom that is closest to each point of the convex hull and make a new linestring out of it.
    cavering := ST_Collect(
      ARRAY(

        SELECT 
          ST_ClosestPoint(var_inputgeom, pt ) As the_geom
          FROM (
            SELECT  ST_PointN(vexring, n ) As pt, n
              FROM 
              generate_series(1, ST_NPoints(vexring) ) As n
            ) As pt
        
        )
      )
    ; 
    

    var_resultgeom := ST_MakeLine(geom) 
      FROM ST_Dump(cavering) As foo;

    IF ST_IsSimple(var_resultgeom) THEN
      var_resultgeom := ST_MakePolygon(var_resultgeom);
      --RAISE NOTICE 'is Simple: %', var_resultgeom;
    ELSE 
      --RAISE NOTICE 'is not Simple: %', var_resultgeom;
      var_resultgeom := ST_ConvexHull(var_resultgeom);
    END IF;
    
    IF scale_factor > 1 THEN -- scale the result back
      var_resultgeom := ST_Scale(var_resultgeom, 1/scale_factor, 1/scale_factor);
    END IF;
    RETURN var_resultgeom;
  
  END;
$$;


--
-- Name: _st_contains(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_contains(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'contains';


--
-- Name: _st_containsproperly(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_containsproperly(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'containsproperly';


--
-- Name: _st_coveredby(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_coveredby(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'coveredby';


--
-- Name: _st_covers(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_covers(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'covers';


--
-- Name: _st_covers(geography, geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_covers(geography, geography) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'geography_covers';


--
-- Name: _st_crosses(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_crosses(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'crosses';


--
-- Name: _st_dfullywithin(geometry, geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_dfullywithin(geom1 geometry, geom2 geometry, double precision) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_dfullywithin';


--
-- Name: _st_distance(geography, geography, double precision, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_distance(geography, geography, double precision, boolean) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'geography_distance';


--
-- Name: _st_distancetree(geography, geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_distancetree(geography, geography) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_DistanceTree($1, $2, 0.0, true)$_$;


--
-- Name: _st_distancetree(geography, geography, double precision, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_distancetree(geography, geography, double precision, boolean) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'geography_distance_tree';


--
-- Name: _st_distanceuncached(geography, geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_distanceuncached(geography, geography) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_DistanceUnCached($1, $2, 0.0, true)$_$;


--
-- Name: _st_distanceuncached(geography, geography, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_distanceuncached(geography, geography, boolean) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_DistanceUnCached($1, $2, 0.0, $3)$_$;


--
-- Name: _st_distanceuncached(geography, geography, double precision, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_distanceuncached(geography, geography, double precision, boolean) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'geography_distance_uncached';


--
-- Name: _st_dumppoints(geometry, integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_dumppoints(the_geom geometry, cur_path integer[]) RETURNS SETOF geometry_dump
    LANGUAGE plpgsql
    AS $$
DECLARE
  tmp geometry_dump;
  tmp2 geometry_dump;
  nb_points integer;
  nb_geom integer;
  i integer;
  j integer;
  g geometry;
  
BEGIN
  
  -- RAISE DEBUG '%,%', cur_path, ST_GeometryType(the_geom);

  -- Special case collections : iterate and return the DumpPoints of the geometries

  IF (ST_IsCollection(the_geom)) THEN
 
    i = 1;
    FOR tmp2 IN SELECT (ST_Dump(the_geom)).* LOOP

      FOR tmp IN SELECT * FROM _ST_DumpPoints(tmp2.geom, cur_path || tmp2.path) LOOP
      RETURN NEXT tmp;
      END LOOP;
      i = i + 1;
      
    END LOOP;

    RETURN;
  END IF;
  

  -- Special case (POLYGON) : return the points of the rings of a polygon
  IF (ST_GeometryType(the_geom) = 'ST_Polygon') THEN

    FOR tmp IN SELECT * FROM _ST_DumpPoints(ST_ExteriorRing(the_geom), cur_path || ARRAY[1]) LOOP
      RETURN NEXT tmp;
    END LOOP;
    
    j := ST_NumInteriorRings(the_geom);
    FOR i IN 1..j LOOP
        FOR tmp IN SELECT * FROM _ST_DumpPoints(ST_InteriorRingN(the_geom, i), cur_path || ARRAY[i+1]) LOOP
          RETURN NEXT tmp;
        END LOOP;
    END LOOP;
    
    RETURN;
  END IF;

  -- Special case (TRIANGLE) : return the points of the external rings of a TRIANGLE
  IF (ST_GeometryType(the_geom) = 'ST_Triangle') THEN

    FOR tmp IN SELECT * FROM _ST_DumpPoints(ST_ExteriorRing(the_geom), cur_path || ARRAY[1]) LOOP
      RETURN NEXT tmp;
    END LOOP;
    
    RETURN;
  END IF;

    
  -- Special case (POINT) : return the point
  IF (ST_GeometryType(the_geom) = 'ST_Point') THEN

    tmp.path = cur_path || ARRAY[1];
    tmp.geom = the_geom;

    RETURN NEXT tmp;
    RETURN;

  END IF;


  -- Use ST_NumPoints rather than ST_NPoints to have a NULL value if the_geom isn't
  -- a LINESTRING, CIRCULARSTRING.
  SELECT ST_NumPoints(the_geom) INTO nb_points;

  -- This should never happen
  IF (nb_points IS NULL) THEN
    RAISE EXCEPTION 'Unexpected error while dumping geometry %', ST_AsText(the_geom);
  END IF;

  FOR i IN 1..nb_points LOOP
    tmp.path = cur_path || ARRAY[i];
    tmp.geom := ST_PointN(the_geom, i);
    RETURN NEXT tmp;
  END LOOP;
   
END
$$;


--
-- Name: _st_dwithin(geometry, geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_dwithin(geom1 geometry, geom2 geometry, double precision) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'LWGEOM_dwithin';


--
-- Name: _st_dwithin(geography, geography, double precision, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_dwithin(geography, geography, double precision, boolean) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'geography_dwithin';


--
-- Name: _st_dwithinuncached(geography, geography, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_dwithinuncached(geography, geography, double precision) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && _ST_Expand($2,$3) AND $2 && _ST_Expand($1,$3) AND _ST_DWithinUnCached($1, $2, $3, true)$_$;


--
-- Name: _st_dwithinuncached(geography, geography, double precision, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_dwithinuncached(geography, geography, double precision, boolean) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'geography_dwithin_uncached';


--
-- Name: _st_equals(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_equals(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'ST_Equals';


--
-- Name: _st_expand(geography, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_expand(geography, double precision) RETURNS geography
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geography_expand';


--
-- Name: _st_geomfromgml(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_geomfromgml(text, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-2.1', 'geom_from_gml';


--
-- Name: _st_intersects(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_intersects(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'intersects';


--
-- Name: _st_linecrossingdirection(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_linecrossingdirection(geom1 geometry, geom2 geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'ST_LineCrossingDirection';


--
-- Name: _st_longestline(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_longestline(geom1 geometry, geom2 geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_longestline2d';


--
-- Name: _st_maxdistance(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_maxdistance(geom1 geometry, geom2 geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_maxdistance2d_linestring';


--
-- Name: _st_orderingequals(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_orderingequals(geometrya geometry, geometryb geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'LWGEOM_same';


--
-- Name: _st_overlaps(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_overlaps(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'overlaps';


--
-- Name: _st_pointoutside(geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_pointoutside(geography) RETURNS geography
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geography_point_outside';


--
-- Name: _st_touches(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_touches(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'touches';


--
-- Name: _st_within(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _st_within(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT _ST_Contains($2,$1)$_$;


--
-- Name: addauth(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION addauth(text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$ 
DECLARE
  lockid alias for $1;
  okay boolean;
  myrec record;
BEGIN
  -- check to see if table exists
  --  if not, CREATE TEMP TABLE mylock (transid xid, lockcode text)
  okay := 'f';
  FOR myrec IN SELECT * FROM pg_class WHERE relname = 'temp_lock_have_table' LOOP
    okay := 't';
  END LOOP; 
  IF (okay <> 't') THEN 
    CREATE TEMP TABLE temp_lock_have_table (transid xid, lockcode text);
      -- this will only work from pgsql7.4 up
      -- ON COMMIT DELETE ROWS;
  END IF;

  --  INSERT INTO mylock VALUES ( $1)
--  EXECUTE 'INSERT INTO temp_lock_have_table VALUES ( '||
--    quote_literal(getTransactionID()) || ',' ||
--    quote_literal(lockid) ||')';

  INSERT INTO temp_lock_have_table VALUES (getTransactionID(), lockid);

  RETURN true::boolean;
END;
$_$;


--
-- Name: FUNCTION addauth(text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION addauth(text) IS 'args: auth_token - Add an authorization token to be used in current transaction.';


--
-- Name: addgeometrycolumn(character varying, character varying, integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION addgeometrycolumn(character varying, character varying, integer, character varying, integer) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
  ret  text;
BEGIN
  SELECT AddGeometryColumn('','',$1,$2,$3,$4,$5) into ret;
  RETURN ret;
END;
$_$;


--
-- Name: addgeometrycolumn(character varying, character varying, character varying, integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION addgeometrycolumn(character varying, character varying, character varying, integer, character varying, integer) RETURNS text
    LANGUAGE plpgsql STABLE STRICT
    AS $_$
DECLARE
  ret  text;
BEGIN
  SELECT AddGeometryColumn('',$1,$2,$3,$4,$5,$6) into ret;
  RETURN ret;
END;
$_$;


--
-- Name: addgeometrycolumn(character varying, character varying, integer, character varying, integer, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION addgeometrycolumn(table_name character varying, column_name character varying, new_srid integer, new_type character varying, new_dim integer, use_typmod boolean DEFAULT true) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
  ret  text;
BEGIN
  SELECT AddGeometryColumn('','',$1,$2,$3,$4,$5, $6) into ret;
  RETURN ret;
END;
$_$;


--
-- Name: FUNCTION addgeometrycolumn(table_name character varying, column_name character varying, new_srid integer, new_type character varying, new_dim integer, use_typmod boolean); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION addgeometrycolumn(table_name character varying, column_name character varying, new_srid integer, new_type character varying, new_dim integer, use_typmod boolean) IS 'args: table_name, column_name, srid, type, dimension, use_typmod=true - Adds a geometry column to an existing table of attributes. By default uses type modifier to define rather than constraints. Pass in false for use_typmod to get old check constraint based behavior';


--
-- Name: addgeometrycolumn(character varying, character varying, character varying, character varying, integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION addgeometrycolumn(character varying, character varying, character varying, character varying, integer, character varying, integer) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
  catalog_name alias for $1;
  schema_name alias for $2;
  table_name alias for $3;
  column_name alias for $4;
  new_srid alias for $5;
  new_type alias for $6;
  new_dim alias for $7;
  rec RECORD;
  sr varchar;
  real_schema name;
  sql text;

BEGIN

  -- Verify geometry type
  IF ( NOT ( (new_type = 'GEOMETRY') OR
         (new_type = 'GEOMETRYCOLLECTION') OR
         (new_type = 'POINT') OR
         (new_type = 'MULTIPOINT') OR
         (new_type = 'POLYGON') OR
         (new_type = 'MULTIPOLYGON') OR
         (new_type = 'LINESTRING') OR
         (new_type = 'MULTILINESTRING') OR
         (new_type = 'GEOMETRYCOLLECTIONM') OR
         (new_type = 'POINTM') OR
         (new_type = 'MULTIPOINTM') OR
         (new_type = 'POLYGONM') OR
         (new_type = 'MULTIPOLYGONM') OR
         (new_type = 'LINESTRINGM') OR
         (new_type = 'MULTILINESTRINGM') OR
         (new_type = 'CIRCULARSTRING') OR
         (new_type = 'CIRCULARSTRINGM') OR
         (new_type = 'COMPOUNDCURVE') OR
         (new_type = 'COMPOUNDCURVEM') OR
         (new_type = 'CURVEPOLYGON') OR
         (new_type = 'CURVEPOLYGONM') OR
         (new_type = 'MULTICURVE') OR
         (new_type = 'MULTICURVEM') OR
         (new_type = 'MULTISURFACE') OR
         (new_type = 'MULTISURFACEM')) )
  THEN
    RAISE EXCEPTION 'Invalid type name - valid ones are:
  POINT, MULTIPOINT,
  LINESTRING, MULTILINESTRING,
  POLYGON, MULTIPOLYGON,
  CIRCULARSTRING, COMPOUNDCURVE, MULTICURVE,
  CURVEPOLYGON, MULTISURFACE,
  GEOMETRY, GEOMETRYCOLLECTION,
  POINTM, MULTIPOINTM,
  LINESTRINGM, MULTILINESTRINGM,
  POLYGONM, MULTIPOLYGONM,
  CIRCULARSTRINGM, COMPOUNDCURVEM, MULTICURVEM
  CURVEPOLYGONM, MULTISURFACEM,
  or GEOMETRYCOLLECTIONM';
    RETURN 'fail';
  END IF;


  -- Verify dimension
  IF ( (new_dim >4) OR (new_dim <0) ) THEN
    RAISE EXCEPTION 'invalid dimension';
    RETURN 'fail';
  END IF;

  IF ( (new_type LIKE '%M') AND (new_dim!=3) ) THEN
    RAISE EXCEPTION 'TypeM needs 3 dimensions';
    RETURN 'fail';
  END IF;


  -- Verify SRID
  IF ( new_srid != -1 ) THEN
    SELECT SRID INTO sr FROM spatial_ref_sys WHERE SRID = new_srid;
    IF NOT FOUND THEN
      RAISE EXCEPTION 'AddGeometryColumns() - invalid SRID';
      RETURN 'fail';
    END IF;
  END IF;


  -- Verify schema
  IF ( schema_name IS NOT NULL AND schema_name != '' ) THEN
    sql := 'SELECT nspname FROM pg_namespace ' ||
      'WHERE text(nspname) = ' || quote_literal(schema_name) ||
      'LIMIT 1';
    RAISE DEBUG '%', sql;
    EXECUTE sql INTO real_schema;

    IF ( real_schema IS NULL ) THEN
      RAISE EXCEPTION 'Schema % is not a valid schemaname', quote_literal(schema_name);
      RETURN 'fail';
    END IF;
  END IF;

  IF ( real_schema IS NULL ) THEN
    RAISE DEBUG 'Detecting schema';
    sql := 'SELECT n.nspname AS schemaname ' ||
      'FROM pg_catalog.pg_class c ' ||
        'JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace ' ||
      'WHERE c.relkind = ' || quote_literal('r') ||
      ' AND n.nspname NOT IN (' || quote_literal('pg_catalog') || ', ' || quote_literal('pg_toast') || ')' ||
      ' AND pg_catalog.pg_table_is_visible(c.oid)' ||
      ' AND c.relname = ' || quote_literal(table_name);
    RAISE DEBUG '%', sql;
    EXECUTE sql INTO real_schema;

    IF ( real_schema IS NULL ) THEN
      RAISE EXCEPTION 'Table % does not occur in the search_path', quote_literal(table_name);
      RETURN 'fail';
    END IF;
  END IF;


  -- Add geometry column to table
  sql := 'ALTER TABLE ' ||
    quote_ident(real_schema) || '.' || quote_ident(table_name)
    || ' ADD COLUMN ' || quote_ident(column_name) ||
    ' geometry ';
  RAISE DEBUG '%', sql;
  EXECUTE sql;


  -- Delete stale record in geometry_columns (if any)
  sql := 'DELETE FROM geometry_columns WHERE
    f_table_catalog = ' || quote_literal('') ||
    ' AND f_table_schema = ' ||
    quote_literal(real_schema) ||
    ' AND f_table_name = ' || quote_literal(table_name) ||
    ' AND f_geometry_column = ' || quote_literal(column_name);
  RAISE DEBUG '%', sql;
  EXECUTE sql;


  -- Add record in geometry_columns
  sql := 'INSERT INTO geometry_columns (f_table_catalog,f_table_schema,f_table_name,' ||
                      'f_geometry_column,coord_dimension,srid,type)' ||
    ' VALUES (' ||
    quote_literal('') || ',' ||
    quote_literal(real_schema) || ',' ||
    quote_literal(table_name) || ',' ||
    quote_literal(column_name) || ',' ||
    new_dim::text || ',' ||
    new_srid::text || ',' ||
    quote_literal(new_type) || ')';
  RAISE DEBUG '%', sql;
  EXECUTE sql;


  -- Add table CHECKs
  sql := 'ALTER TABLE ' ||
    quote_ident(real_schema) || '.' || quote_ident(table_name)
    || ' ADD CONSTRAINT '
    || quote_ident('enforce_srid_' || column_name)
    || ' CHECK (ST_SRID(' || quote_ident(column_name) ||
    ') = ' || new_srid::text || ')' ;
  RAISE DEBUG '%', sql;
  EXECUTE sql;

  sql := 'ALTER TABLE ' ||
    quote_ident(real_schema) || '.' || quote_ident(table_name)
    || ' ADD CONSTRAINT '
    || quote_ident('enforce_dims_' || column_name)
    || ' CHECK (ST_NDims(' || quote_ident(column_name) ||
    ') = ' || new_dim::text || ')' ;
  RAISE DEBUG '%', sql;
  EXECUTE sql;

  IF ( NOT (new_type = 'GEOMETRY')) THEN
    sql := 'ALTER TABLE ' ||
      quote_ident(real_schema) || '.' || quote_ident(table_name) || ' ADD CONSTRAINT ' ||
      quote_ident('enforce_geotype_' || column_name) ||
      ' CHECK (GeometryType(' ||
      quote_ident(column_name) || ')=' ||
      quote_literal(new_type) || ' OR (' ||
      quote_ident(column_name) || ') is null)';
    RAISE DEBUG '%', sql;
    EXECUTE sql;
  END IF;

  RETURN
    real_schema || '.' ||
    table_name || '.' || column_name ||
    ' SRID:' || new_srid::text ||
    ' TYPE:' || new_type ||
    ' DIMS:' || new_dim::text || ' ';
END;
$_$;


--
-- Name: addgeometrycolumn(character varying, character varying, character varying, integer, character varying, integer, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION addgeometrycolumn(schema_name character varying, table_name character varying, column_name character varying, new_srid integer, new_type character varying, new_dim integer, use_typmod boolean DEFAULT true) RETURNS text
    LANGUAGE plpgsql STABLE STRICT
    AS $_$
DECLARE
  ret  text;
BEGIN
  SELECT AddGeometryColumn('',$1,$2,$3,$4,$5,$6,$7) into ret;
  RETURN ret;
END;
$_$;


--
-- Name: FUNCTION addgeometrycolumn(schema_name character varying, table_name character varying, column_name character varying, new_srid integer, new_type character varying, new_dim integer, use_typmod boolean); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION addgeometrycolumn(schema_name character varying, table_name character varying, column_name character varying, new_srid integer, new_type character varying, new_dim integer, use_typmod boolean) IS 'args: schema_name, table_name, column_name, srid, type, dimension, use_typmod=true - Adds a geometry column to an existing table of attributes. By default uses type modifier to define rather than constraints. Pass in false for use_typmod to get old check constraint based behavior';


--
-- Name: addgeometrycolumn(character varying, character varying, character varying, character varying, integer, character varying, integer, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION addgeometrycolumn(catalog_name character varying, schema_name character varying, table_name character varying, column_name character varying, new_srid_in integer, new_type character varying, new_dim integer, use_typmod boolean DEFAULT true) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $$
DECLARE
  rec RECORD;
  sr varchar;
  real_schema name;
  sql text;
  new_srid integer;

BEGIN

  -- Verify geometry type
  IF (postgis_type_name(new_type,new_dim) IS NULL )
  THEN
    RAISE EXCEPTION 'Invalid type name "%(%)" - valid ones are:
  POINT, MULTIPOINT,
  LINESTRING, MULTILINESTRING,
  POLYGON, MULTIPOLYGON,
  CIRCULARSTRING, COMPOUNDCURVE, MULTICURVE,
  CURVEPOLYGON, MULTISURFACE,
  GEOMETRY, GEOMETRYCOLLECTION,
  POINTM, MULTIPOINTM,
  LINESTRINGM, MULTILINESTRINGM,
  POLYGONM, MULTIPOLYGONM,
  CIRCULARSTRINGM, COMPOUNDCURVEM, MULTICURVEM
  CURVEPOLYGONM, MULTISURFACEM, TRIANGLE, TRIANGLEM,
  POLYHEDRALSURFACE, POLYHEDRALSURFACEM, TIN, TINM
  or GEOMETRYCOLLECTIONM', new_type, new_dim;
    RETURN 'fail';
  END IF;


  -- Verify dimension
  IF ( (new_dim >4) OR (new_dim <2) ) THEN
    RAISE EXCEPTION 'invalid dimension';
    RETURN 'fail';
  END IF;

  IF ( (new_type LIKE '%M') AND (new_dim!=3) ) THEN
    RAISE EXCEPTION 'TypeM needs 3 dimensions';
    RETURN 'fail';
  END IF;


  -- Verify SRID
  IF ( new_srid_in > 0 ) THEN
    IF new_srid_in > 998999 THEN
      RAISE EXCEPTION 'AddGeometryColumn() - SRID must be <= %', 998999;
    END IF;
    new_srid := new_srid_in;
    SELECT SRID INTO sr FROM spatial_ref_sys WHERE SRID = new_srid;
    IF NOT FOUND THEN
      RAISE EXCEPTION 'AddGeometryColumn() - invalid SRID';
      RETURN 'fail';
    END IF;
  ELSE
    new_srid := ST_SRID('POINT EMPTY'::geometry);
    IF ( new_srid_in != new_srid ) THEN
      RAISE NOTICE 'SRID value % converted to the officially unknown SRID value %', new_srid_in, new_srid;
    END IF;
  END IF;


  -- Verify schema
  IF ( schema_name IS NOT NULL AND schema_name != '' ) THEN
    sql := 'SELECT nspname FROM pg_namespace ' ||
      'WHERE text(nspname) = ' || quote_literal(schema_name) ||
      'LIMIT 1';
    RAISE DEBUG '%', sql;
    EXECUTE sql INTO real_schema;

    IF ( real_schema IS NULL ) THEN
      RAISE EXCEPTION 'Schema % is not a valid schemaname', quote_literal(schema_name);
      RETURN 'fail';
    END IF;
  END IF;

  IF ( real_schema IS NULL ) THEN
    RAISE DEBUG 'Detecting schema';
    sql := 'SELECT n.nspname AS schemaname ' ||
      'FROM pg_catalog.pg_class c ' ||
        'JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace ' ||
      'WHERE c.relkind = ' || quote_literal('r') ||
      ' AND n.nspname NOT IN (' || quote_literal('pg_catalog') || ', ' || quote_literal('pg_toast') || ')' ||
      ' AND pg_catalog.pg_table_is_visible(c.oid)' ||
      ' AND c.relname = ' || quote_literal(table_name);
    RAISE DEBUG '%', sql;
    EXECUTE sql INTO real_schema;

    IF ( real_schema IS NULL ) THEN
      RAISE EXCEPTION 'Table % does not occur in the search_path', quote_literal(table_name);
      RETURN 'fail';
    END IF;
  END IF;


  -- Add geometry column to table
  IF use_typmod THEN
       sql := 'ALTER TABLE ' ||
            quote_ident(real_schema) || '.' || quote_ident(table_name)
            || ' ADD COLUMN ' || quote_ident(column_name) ||
            ' geometry(' || postgis_type_name(new_type, new_dim) || ', ' || new_srid::text || ')';
        RAISE DEBUG '%', sql;
  ELSE
        sql := 'ALTER TABLE ' ||
            quote_ident(real_schema) || '.' || quote_ident(table_name)
            || ' ADD COLUMN ' || quote_ident(column_name) ||
            ' geometry ';
        RAISE DEBUG '%', sql;
    END IF;
  EXECUTE sql;

  IF NOT use_typmod THEN
        -- Add table CHECKs
        sql := 'ALTER TABLE ' ||
            quote_ident(real_schema) || '.' || quote_ident(table_name)
            || ' ADD CONSTRAINT '
            || quote_ident('enforce_srid_' || column_name)
            || ' CHECK (st_srid(' || quote_ident(column_name) ||
            ') = ' || new_srid::text || ')' ;
        RAISE DEBUG '%', sql;
        EXECUTE sql;
    
        sql := 'ALTER TABLE ' ||
            quote_ident(real_schema) || '.' || quote_ident(table_name)
            || ' ADD CONSTRAINT '
            || quote_ident('enforce_dims_' || column_name)
            || ' CHECK (st_ndims(' || quote_ident(column_name) ||
            ') = ' || new_dim::text || ')' ;
        RAISE DEBUG '%', sql;
        EXECUTE sql;
    
        IF ( NOT (new_type = 'GEOMETRY')) THEN
            sql := 'ALTER TABLE ' ||
                quote_ident(real_schema) || '.' || quote_ident(table_name) || ' ADD CONSTRAINT ' ||
                quote_ident('enforce_geotype_' || column_name) ||
                ' CHECK (GeometryType(' ||
                quote_ident(column_name) || ')=' ||
                quote_literal(new_type) || ' OR (' ||
                quote_ident(column_name) || ') is null)';
            RAISE DEBUG '%', sql;
            EXECUTE sql;
        END IF;
    END IF;

  RETURN
    real_schema || '.' ||
    table_name || '.' || column_name ||
    ' SRID:' || new_srid::text ||
    ' TYPE:' || new_type ||
    ' DIMS:' || new_dim::text || ' ';
END;
$$;


--
-- Name: FUNCTION addgeometrycolumn(catalog_name character varying, schema_name character varying, table_name character varying, column_name character varying, new_srid_in integer, new_type character varying, new_dim integer, use_typmod boolean); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION addgeometrycolumn(catalog_name character varying, schema_name character varying, table_name character varying, column_name character varying, new_srid_in integer, new_type character varying, new_dim integer, use_typmod boolean) IS 'args: catalog_name, schema_name, table_name, column_name, srid, type, dimension, use_typmod=true - Adds a geometry column to an existing table of attributes. By default uses type modifier to define rather than constraints. Pass in false for use_typmod to get old check constraint based behavior';


--
-- Name: affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT affine($1,  $2, $3, 0,  $4, $5, 0,  0, 0, 1,  $6, $7, 0)$_$;


--
-- Name: asgml(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION asgml(geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML(2, $1, 15, 0)$_$;


--
-- Name: asgml(geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION asgml(geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML(2, $1, $2, 0)$_$;


--
-- Name: askml(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION askml(geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML(2, transform($1,4326), 15)$_$;


--
-- Name: askml(geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION askml(geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML(2, transform($1,4326), $2)$_$;


--
-- Name: askml(integer, geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION askml(integer, geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML($1, transform($2,4326), $3)$_$;


--
-- Name: bdmpolyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION bdmpolyfromtext(text, integer) RETURNS geometry
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
  geomtext alias for $1;
  srid alias for $2;
  mline geometry;
  geom geometry;
BEGIN
  mline := MultiLineStringFromText(geomtext, srid);

  IF mline IS NULL
  THEN
    RAISE EXCEPTION 'Input is not a MultiLinestring';
  END IF;

  geom := multi(BuildArea(mline));

  RETURN geom;
END;
$_$;


--
-- Name: bdpolyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION bdpolyfromtext(text, integer) RETURNS geometry
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
  geomtext alias for $1;
  srid alias for $2;
  mline geometry;
  geom geometry;
BEGIN
  mline := MultiLineStringFromText(geomtext, srid);

  IF mline IS NULL
  THEN
    RAISE EXCEPTION 'Input is not a MultiLinestring';
  END IF;

  geom := BuildArea(mline);

  IF GeometryType(geom) != 'POLYGON'
  THEN
    RAISE EXCEPTION 'Input returns more then a single polygon, try using BdMPolyFromText instead';
  END IF;

  RETURN geom;
END;
$_$;


--
-- Name: boolop(integer[], query_int); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION boolop(integer[], query_int) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'boolop';


--
-- Name: FUNCTION boolop(integer[], query_int); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION boolop(integer[], query_int) IS 'boolean operation with array';


--
-- Name: box(box3d); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION box(box3d) RETURNS box
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'BOX3D_to_BOX';


--
-- Name: box(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION box(geometry) RETURNS box
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_to_BOX';


--
-- Name: box2d(box3d); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION box2d(box3d) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'BOX3D_to_BOX2D';


--
-- Name: box2d(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION box2d(geometry) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_to_BOX2D';


--
-- Name: FUNCTION box2d(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION box2d(geometry) IS 'args: geomA - Returns a BOX2D representing the maximum extents of the geometry.';


--
-- Name: box3d(box2d); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION box3d(box2d) RETURNS box3d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'BOX2D_to_BOX3D';


--
-- Name: box3d(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION box3d(geometry) RETURNS box3d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_to_BOX3D';


--
-- Name: FUNCTION box3d(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION box3d(geometry) IS 'args: geomA - Returns a BOX3D representing the maximum extents of the geometry.';


--
-- Name: box3dtobox(box3d); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION box3dtobox(box3d) RETURNS box
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT box($1)$_$;


--
-- Name: buffer(geometry, double precision, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION buffer(geometry, double precision, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_Buffer($1, $2, $3)$_$;


--
-- Name: bytea(geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION bytea(geography) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_to_bytea';


--
-- Name: bytea(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION bytea(geometry) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_to_bytea';


--
-- Name: checkauth(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION checkauth(text, text) RETURNS integer
    LANGUAGE sql
    AS $_$ SELECT CheckAuth('', $1, $2) $_$;


--
-- Name: FUNCTION checkauth(text, text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION checkauth(text, text) IS 'args: a_table_name, a_key_column_name - Creates trigger on a table to prevent/allow updates and deletes of rows based on authorization token.';


--
-- Name: checkauth(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION checkauth(text, text, text) RETURNS integer
    LANGUAGE plpgsql
    AS $_$ 
DECLARE
  schema text;
BEGIN
  IF NOT LongTransactionsEnabled() THEN
    RAISE EXCEPTION 'Long transaction support disabled, use EnableLongTransaction() to enable.';
  END IF;

  if ( $1 != '' ) THEN
    schema = $1;
  ELSE
    SELECT current_schema() into schema;
  END IF;

  -- TODO: check for an already existing trigger ?

  EXECUTE 'CREATE TRIGGER check_auth BEFORE UPDATE OR DELETE ON ' 
    || quote_ident(schema) || '.' || quote_ident($2)
    ||' FOR EACH ROW EXECUTE PROCEDURE CheckAuthTrigger('
    || quote_literal($3) || ')';

  RETURN 0;
END;
$_$;


--
-- Name: FUNCTION checkauth(text, text, text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION checkauth(text, text, text) IS 'args: a_schema_name, a_table_name, a_key_column_name - Creates trigger on a table to prevent/allow updates and deletes of rows based on authorization token.';


--
-- Name: checkauthtrigger(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION checkauthtrigger() RETURNS trigger
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'check_authorization';


--
-- Name: disablelongtransactions(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION disablelongtransactions() RETURNS text
    LANGUAGE plpgsql
    AS $$ 
DECLARE
  rec RECORD;

BEGIN

  --
  -- Drop all triggers applied by CheckAuth()
  --
  FOR rec IN
    SELECT c.relname, t.tgname, t.tgargs FROM pg_trigger t, pg_class c, pg_proc p
    WHERE p.proname = 'checkauthtrigger' and t.tgfoid = p.oid and t.tgrelid = c.oid
  LOOP
    EXECUTE 'DROP TRIGGER ' || quote_ident(rec.tgname) ||
      ' ON ' || quote_ident(rec.relname);
  END LOOP;

  --
  -- Drop the authorization_table table
  --
  FOR rec IN SELECT * FROM pg_class WHERE relname = 'authorization_table' LOOP
    DROP TABLE authorization_table;
  END LOOP;

  --
  -- Drop the authorized_tables view
  --
  FOR rec IN SELECT * FROM pg_class WHERE relname = 'authorized_tables' LOOP
    DROP VIEW authorized_tables;
  END LOOP;

  RETURN 'Long transactions support disabled';
END;
$$;


--
-- Name: FUNCTION disablelongtransactions(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION disablelongtransactions() IS 'Disable long transaction support. This function removes the long transaction support metadata tables, and drops all triggers attached to lock-checked tables.';


--
-- Name: dropgeometrycolumn(character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dropgeometrycolumn(table_name character varying, column_name character varying) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
  ret text;
BEGIN
  SELECT DropGeometryColumn('','',$1,$2) into ret;
  RETURN ret;
END;
$_$;


--
-- Name: FUNCTION dropgeometrycolumn(table_name character varying, column_name character varying); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION dropgeometrycolumn(table_name character varying, column_name character varying) IS 'args: table_name, column_name - Removes a geometry column from a spatial table.';


--
-- Name: dropgeometrycolumn(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dropgeometrycolumn(schema_name character varying, table_name character varying, column_name character varying) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
  ret text;
BEGIN
  SELECT DropGeometryColumn('',$1,$2,$3) into ret;
  RETURN ret;
END;
$_$;


--
-- Name: FUNCTION dropgeometrycolumn(schema_name character varying, table_name character varying, column_name character varying); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION dropgeometrycolumn(schema_name character varying, table_name character varying, column_name character varying) IS 'args: schema_name, table_name, column_name - Removes a geometry column from a spatial table.';


--
-- Name: dropgeometrycolumn(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dropgeometrycolumn(catalog_name character varying, schema_name character varying, table_name character varying, column_name character varying) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $$
DECLARE
  myrec RECORD;
  okay boolean;
  real_schema name;

BEGIN


  -- Find, check or fix schema_name
  IF ( schema_name != '' ) THEN
    okay = false;

    FOR myrec IN SELECT nspname FROM pg_namespace WHERE text(nspname) = schema_name LOOP
      okay := true;
    END LOOP;

    IF ( okay <>  true ) THEN
      RAISE NOTICE 'Invalid schema name - using current_schema()';
      SELECT current_schema() into real_schema;
    ELSE
      real_schema = schema_name;
    END IF;
  ELSE
    SELECT current_schema() into real_schema;
  END IF;

  -- Find out if the column is in the geometry_columns table
  okay = false;
  FOR myrec IN SELECT * from geometry_columns where f_table_schema = text(real_schema) and f_table_name = table_name and f_geometry_column = column_name LOOP
    okay := true;
  END LOOP;
  IF (okay <> true) THEN
    RAISE EXCEPTION 'column not found in geometry_columns table';
    RETURN false;
  END IF;

  -- Remove table column
  EXECUTE 'ALTER TABLE ' || quote_ident(real_schema) || '.' ||
    quote_ident(table_name) || ' DROP COLUMN ' ||
    quote_ident(column_name);

  RETURN real_schema || '.' || table_name || '.' || column_name ||' effectively removed.';

END;
$$;


--
-- Name: FUNCTION dropgeometrycolumn(catalog_name character varying, schema_name character varying, table_name character varying, column_name character varying); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION dropgeometrycolumn(catalog_name character varying, schema_name character varying, table_name character varying, column_name character varying) IS 'args: catalog_name, schema_name, table_name, column_name - Removes a geometry column from a spatial table.';


--
-- Name: dropgeometrytable(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dropgeometrytable(table_name character varying) RETURNS text
    LANGUAGE sql STRICT
    AS $_$ SELECT DropGeometryTable('','',$1) $_$;


--
-- Name: FUNCTION dropgeometrytable(table_name character varying); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION dropgeometrytable(table_name character varying) IS 'args: table_name - Drops a table and all its references in geometry_columns.';


--
-- Name: dropgeometrytable(character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dropgeometrytable(schema_name character varying, table_name character varying) RETURNS text
    LANGUAGE sql STRICT
    AS $_$ SELECT DropGeometryTable('',$1,$2) $_$;


--
-- Name: FUNCTION dropgeometrytable(schema_name character varying, table_name character varying); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION dropgeometrytable(schema_name character varying, table_name character varying) IS 'args: schema_name, table_name - Drops a table and all its references in geometry_columns.';


--
-- Name: dropgeometrytable(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dropgeometrytable(catalog_name character varying, schema_name character varying, table_name character varying) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $$
DECLARE
  real_schema name;

BEGIN

  IF ( schema_name = '' ) THEN
    SELECT current_schema() into real_schema;
  ELSE
    real_schema = schema_name;
  END IF;

  -- TODO: Should we warn if table doesn't exist probably instead just saying dropped
  -- Remove table
  EXECUTE 'DROP TABLE IF EXISTS '
    || quote_ident(real_schema) || '.' ||
    quote_ident(table_name) || ' RESTRICT';

  RETURN
    real_schema || '.' ||
    table_name ||' dropped.';

END;
$$;


--
-- Name: FUNCTION dropgeometrytable(catalog_name character varying, schema_name character varying, table_name character varying); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION dropgeometrytable(catalog_name character varying, schema_name character varying, table_name character varying) IS 'args: catalog_name, schema_name, table_name - Drops a table and all its references in geometry_columns.';


--
-- Name: enablelongtransactions(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION enablelongtransactions() RETURNS text
    LANGUAGE plpgsql
    AS $$ 
DECLARE
  "query" text;
  exists bool;
  rec RECORD;

BEGIN

  exists = 'f';
  FOR rec IN SELECT * FROM pg_class WHERE relname = 'authorization_table'
  LOOP
    exists = 't';
  END LOOP;

  IF NOT exists
  THEN
    "query" = 'CREATE TABLE authorization_table (
      toid oid, -- table oid
      rid text, -- row id
      expires timestamp,
      authid text
    )';
    EXECUTE "query";
  END IF;

  exists = 'f';
  FOR rec IN SELECT * FROM pg_class WHERE relname = 'authorized_tables'
  LOOP
    exists = 't';
  END LOOP;

  IF NOT exists THEN
    "query" = 'CREATE VIEW authorized_tables AS ' ||
      'SELECT ' ||
      'n.nspname as schema, ' ||
      'c.relname as table, trim(' ||
      quote_literal(chr(92) || '000') ||
      ' from t.tgargs) as id_column ' ||
      'FROM pg_trigger t, pg_class c, pg_proc p ' ||
      ', pg_namespace n ' ||
      'WHERE p.proname = ' || quote_literal('checkauthtrigger') ||
      ' AND c.relnamespace = n.oid' ||
      ' AND t.tgfoid = p.oid and t.tgrelid = c.oid';
    EXECUTE "query";
  END IF;

  RETURN 'Long transactions support enabled';
END;
$$;


--
-- Name: FUNCTION enablelongtransactions(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION enablelongtransactions() IS 'Enable long transaction support. This function creates the required metadata tables, needs to be called once before using the other functions in this section. Calling it twice is harmless.';


--
-- Name: equals(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION equals(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'ST_Equals';


--
-- Name: find_extent(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION find_extent(text, text) RETURNS box2d
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
  tablename alias for $1;
  columnname alias for $2;
  myrec RECORD;

BEGIN
  FOR myrec IN EXECUTE 'SELECT extent("' || columnname || '") FROM "' || tablename || '"' LOOP
    return myrec.extent;
  END LOOP;
END;
$_$;


--
-- Name: find_extent(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION find_extent(text, text, text) RETURNS box2d
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
  schemaname alias for $1;
  tablename alias for $2;
  columnname alias for $3;
  myrec RECORD;

BEGIN
  FOR myrec IN EXECUTE 'SELECT extent("' || columnname || '") FROM "' || schemaname || '"."' || tablename || '"' LOOP
    return myrec.extent;
  END LOOP;
END;
$_$;


--
-- Name: find_srid(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION find_srid(character varying, character varying, character varying) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
  schem text;
  tabl text;
  sr int4;
BEGIN
  IF $1 IS NULL THEN
    RAISE EXCEPTION 'find_srid() - schema is NULL!';
  END IF;
  IF $2 IS NULL THEN
    RAISE EXCEPTION 'find_srid() - table name is NULL!';
  END IF;
  IF $3 IS NULL THEN
    RAISE EXCEPTION 'find_srid() - column name is NULL!';
  END IF;
  schem = $1;
  tabl = $2;
-- if the table contains a . and the schema is empty
-- split the table into a schema and a table
-- otherwise drop through to default behavior
  IF ( schem = '' and tabl LIKE '%.%' ) THEN
   schem = substr(tabl,1,strpos(tabl,'.')-1);
   tabl = substr(tabl,length(schem)+2);
  ELSE
   schem = schem || '%';
  END IF;

  select SRID into sr from geometry_columns where f_table_schema like schem and f_table_name = tabl and f_geometry_column = $3;
  IF NOT FOUND THEN
     RAISE EXCEPTION 'find_srid() - couldnt find the corresponding SRID - is the geometry registered in the GEOMETRY_COLUMNS table?  Is there an uppercase/lowercase missmatch?';
  END IF;
  return sr;
END;
$_$;


--
-- Name: FUNCTION find_srid(character varying, character varying, character varying); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION find_srid(character varying, character varying, character varying) IS 'args: a_schema_name, a_table_name, a_geomfield_name - The syntax is find_srid(a_db_schema, a_table, a_column) and the function returns the integer SRID of the specified column by searching through the GEOMETRY_COLUMNS table.';


--
-- Name: fix_geometry_columns(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fix_geometry_columns() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
  mislinked record;
  result text;
  linked integer;
  deleted integer;
  foundschema integer;
BEGIN

  -- Since 7.3 schema support has been added.
  -- Previous postgis versions used to put the database name in
  -- the schema column. This needs to be fixed, so we try to
  -- set the correct schema for each geometry_colums record
  -- looking at table, column, type and srid.
  UPDATE geometry_columns SET f_table_schema = n.nspname
    FROM pg_namespace n, pg_class c, pg_attribute a,
      pg_constraint sridcheck, pg_constraint typecheck
      WHERE ( f_table_schema is NULL
    OR f_table_schema = ''
      OR f_table_schema NOT IN (
          SELECT nspname::varchar
          FROM pg_namespace nn, pg_class cc, pg_attribute aa
          WHERE cc.relnamespace = nn.oid
          AND cc.relname = f_table_name::name
          AND aa.attrelid = cc.oid
          AND aa.attname = f_geometry_column::name))
      AND f_table_name::name = c.relname
      AND c.oid = a.attrelid
      AND c.relnamespace = n.oid
      AND f_geometry_column::name = a.attname

      AND sridcheck.conrelid = c.oid
    AND sridcheck.consrc LIKE '(srid(% = %)'
      AND sridcheck.consrc ~ textcat(' = ', srid::text)

      AND typecheck.conrelid = c.oid
    AND typecheck.consrc LIKE
    '((geometrytype(%) = ''%''::text) OR (% IS NULL))'
      AND typecheck.consrc ~ textcat(' = ''', type::text)

      AND NOT EXISTS (
          SELECT oid FROM geometry_columns gc
          WHERE c.relname::varchar = gc.f_table_name
          AND n.nspname::varchar = gc.f_table_schema
          AND a.attname::varchar = gc.f_geometry_column
      );

  GET DIAGNOSTICS foundschema = ROW_COUNT;

  -- no linkage to system table needed
  return 'fixed:'||foundschema::text;

END;
$$;


--
-- Name: g_int_compress(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION g_int_compress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'g_int_compress';


--
-- Name: g_int_consistent(internal, integer[], integer, oid, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION g_int_consistent(internal, integer[], integer, oid, internal) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'g_int_consistent';


--
-- Name: g_int_decompress(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION g_int_decompress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'g_int_decompress';


--
-- Name: g_int_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION g_int_penalty(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'g_int_penalty';


--
-- Name: g_int_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION g_int_picksplit(internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'g_int_picksplit';


--
-- Name: g_int_same(integer[], integer[], internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION g_int_same(integer[], integer[], internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'g_int_same';


--
-- Name: g_int_union(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION g_int_union(internal, internal) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'g_int_union';


--
-- Name: g_intbig_compress(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION g_intbig_compress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'g_intbig_compress';


--
-- Name: g_intbig_consistent(internal, internal, integer, oid, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION g_intbig_consistent(internal, internal, integer, oid, internal) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'g_intbig_consistent';


--
-- Name: g_intbig_decompress(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION g_intbig_decompress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'g_intbig_decompress';


--
-- Name: g_intbig_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION g_intbig_penalty(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'g_intbig_penalty';


--
-- Name: g_intbig_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION g_intbig_picksplit(internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'g_intbig_picksplit';


--
-- Name: g_intbig_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION g_intbig_same(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'g_intbig_same';


--
-- Name: g_intbig_union(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION g_intbig_union(internal, internal) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'g_intbig_union';


--
-- Name: geography(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geography(bytea) RETURNS geography
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_from_bytea';


--
-- Name: geography(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geography(geometry) RETURNS geography
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geography_from_geometry';


--
-- Name: geography(geography, integer, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geography(geography, integer, boolean) RETURNS geography
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geography_enforce_typmod';


--
-- Name: geography_cmp(geography, geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geography_cmp(geography, geography) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geography_cmp';


--
-- Name: geography_eq(geography, geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geography_eq(geography, geography) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geography_eq';


--
-- Name: geography_ge(geography, geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geography_ge(geography, geography) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geography_ge';


--
-- Name: geography_gist_compress(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geography_gist_compress(internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'gserialized_gist_compress';


--
-- Name: geography_gist_consistent(internal, geography, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geography_gist_consistent(internal, geography, integer) RETURNS boolean
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'gserialized_gist_consistent';


--
-- Name: geography_gist_decompress(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geography_gist_decompress(internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'gserialized_gist_decompress';


--
-- Name: geography_gist_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geography_gist_penalty(internal, internal, internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'gserialized_gist_penalty';


--
-- Name: geography_gist_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geography_gist_picksplit(internal, internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'gserialized_gist_picksplit';


--
-- Name: geography_gist_same(box2d, box2d, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geography_gist_same(box2d, box2d, internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'gserialized_gist_same';


--
-- Name: geography_gist_union(bytea, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geography_gist_union(bytea, internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'gserialized_gist_union';


--
-- Name: geography_gt(geography, geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geography_gt(geography, geography) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geography_gt';


--
-- Name: geography_le(geography, geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geography_le(geography, geography) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geography_le';


--
-- Name: geography_lt(geography, geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geography_lt(geography, geography) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geography_lt';


--
-- Name: geography_overlaps(geography, geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geography_overlaps(geography, geography) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'gserialized_overlaps';


--
-- Name: geomcollfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geomcollfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE
  WHEN geometrytype(GeomFromText($1)) = 'GEOMETRYCOLLECTION'
  THEN GeomFromText($1)
  ELSE NULL END
  $_$;


--
-- Name: geomcollfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geomcollfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE
  WHEN geometrytype(GeomFromText($1, $2)) = 'GEOMETRYCOLLECTION'
  THEN GeomFromText($1,$2)
  ELSE NULL END
  $_$;


--
-- Name: geomcollfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geomcollfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE
  WHEN geometrytype(GeomFromWKB($1)) = 'GEOMETRYCOLLECTION'
  THEN GeomFromWKB($1)
  ELSE NULL END
  $_$;


--
-- Name: geomcollfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geomcollfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE
  WHEN geometrytype(GeomFromWKB($1, $2)) = 'GEOMETRYCOLLECTION'
  THEN GeomFromWKB($1, $2)
  ELSE NULL END
  $_$;


--
-- Name: geometry(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry(bytea) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_from_bytea';


--
-- Name: geometry(path); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry(path) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'path_to_geometry';


--
-- Name: geometry(point); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry(point) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'point_to_geometry';


--
-- Name: geometry(polygon); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry(polygon) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'polygon_to_geometry';


--
-- Name: geometry(box2d); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry(box2d) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'BOX2D_to_LWGEOM';


--
-- Name: geometry(box3d); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry(box3d) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'BOX3D_to_LWGEOM';


--
-- Name: geometry(geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry(geography) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geometry_from_geography';


--
-- Name: geometry(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry(text) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'parse_WKT_lwgeom';


--
-- Name: geometry(geometry, integer, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry(geometry, integer, boolean) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geometry_enforce_typmod';


--
-- Name: geometry_above(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_above(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'gserialized_above_2d';


--
-- Name: geometry_below(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_below(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'gserialized_below_2d';


--
-- Name: geometry_cmp(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_cmp(geom1 geometry, geom2 geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'lwgeom_cmp';


--
-- Name: geometry_contains(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_contains(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'gserialized_contains_2d';


--
-- Name: geometry_distance_box(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_distance_box(geom1 geometry, geom2 geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'gserialized_distance_box_2d';


--
-- Name: geometry_distance_centroid(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_distance_centroid(geom1 geometry, geom2 geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'gserialized_distance_centroid_2d';


--
-- Name: geometry_eq(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_eq(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'lwgeom_eq';


--
-- Name: geometry_ge(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_ge(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'lwgeom_ge';


--
-- Name: geometry_gist_compress_2d(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_gist_compress_2d(internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'gserialized_gist_compress_2d';


--
-- Name: geometry_gist_compress_nd(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_gist_compress_nd(internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'gserialized_gist_compress';


--
-- Name: geometry_gist_consistent_2d(internal, geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_gist_consistent_2d(internal, geometry, integer) RETURNS boolean
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'gserialized_gist_consistent_2d';


--
-- Name: geometry_gist_consistent_nd(internal, geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_gist_consistent_nd(internal, geometry, integer) RETURNS boolean
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'gserialized_gist_consistent';


--
-- Name: geometry_gist_decompress_2d(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_gist_decompress_2d(internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'gserialized_gist_decompress_2d';


--
-- Name: geometry_gist_decompress_nd(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_gist_decompress_nd(internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'gserialized_gist_decompress';


--
-- Name: geometry_gist_distance_2d(internal, geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_gist_distance_2d(internal, geometry, integer) RETURNS double precision
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'gserialized_gist_distance_2d';


--
-- Name: geometry_gist_penalty_2d(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_gist_penalty_2d(internal, internal, internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'gserialized_gist_penalty_2d';


--
-- Name: geometry_gist_penalty_nd(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_gist_penalty_nd(internal, internal, internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'gserialized_gist_penalty';


--
-- Name: geometry_gist_picksplit_2d(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_gist_picksplit_2d(internal, internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'gserialized_gist_picksplit_2d';


--
-- Name: geometry_gist_picksplit_nd(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_gist_picksplit_nd(internal, internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'gserialized_gist_picksplit';


--
-- Name: geometry_gist_same_2d(geometry, geometry, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_gist_same_2d(geom1 geometry, geom2 geometry, internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'gserialized_gist_same_2d';


--
-- Name: geometry_gist_same_nd(geometry, geometry, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_gist_same_nd(geometry, geometry, internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'gserialized_gist_same';


--
-- Name: geometry_gist_union_2d(bytea, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_gist_union_2d(bytea, internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'gserialized_gist_union_2d';


--
-- Name: geometry_gist_union_nd(bytea, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_gist_union_nd(bytea, internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'gserialized_gist_union';


--
-- Name: geometry_gt(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_gt(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'lwgeom_gt';


--
-- Name: geometry_le(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_le(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'lwgeom_le';


--
-- Name: geometry_left(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_left(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'gserialized_left_2d';


--
-- Name: geometry_lt(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_lt(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'lwgeom_lt';


--
-- Name: geometry_overabove(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_overabove(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'gserialized_overabove_2d';


--
-- Name: geometry_overbelow(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_overbelow(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'gserialized_overbelow_2d';


--
-- Name: geometry_overlaps(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_overlaps(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'gserialized_overlaps_2d';


--
-- Name: geometry_overlaps_nd(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_overlaps_nd(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'gserialized_overlaps';


--
-- Name: geometry_overleft(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_overleft(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'gserialized_overleft_2d';


--
-- Name: geometry_overright(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_overright(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'gserialized_overright_2d';


--
-- Name: geometry_right(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_right(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'gserialized_right_2d';


--
-- Name: geometry_same(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_same(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'gserialized_same_2d';


--
-- Name: geometry_within(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometry_within(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'gserialized_within_2d';


--
-- Name: geometrytype(geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometrytype(geography) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_getTYPE';


--
-- Name: geometrytype(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geometrytype(geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_getTYPE';


--
-- Name: FUNCTION geometrytype(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION geometrytype(geometry) IS 'args: geomA - Returns the type of the geometry as a string. Eg: LINESTRING, POLYGON, MULTIPOINT, etc.';


--
-- Name: geomfromewkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geomfromewkb(bytea) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOMFromWKB';


--
-- Name: geomfromewkt(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geomfromewkt(text) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'parse_WKT_lwgeom';


--
-- Name: geomfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geomfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT geometryfromtext($1)$_$;


--
-- Name: geomfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geomfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT geometryfromtext($1, $2)$_$;


--
-- Name: geomfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geomfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT setSRID(GeomFromWKB($1), $2)$_$;


--
-- Name: get_proj4_from_srid(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION get_proj4_from_srid(integer) RETURNS text
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
BEGIN
  RETURN proj4text::text FROM spatial_ref_sys WHERE srid= $1;
END;
$_$;


--
-- Name: gettransactionid(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION gettransactionid() RETURNS xid
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'getTransactionID';


--
-- Name: ginint4_consistent(internal, smallint, internal, integer, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ginint4_consistent(internal, smallint, internal, integer, internal, internal) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'ginint4_consistent';


--
-- Name: ginint4_queryextract(internal, internal, smallint, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ginint4_queryextract(internal, internal, smallint, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'ginint4_queryextract';


--
-- Name: gserialized_gist_joinsel_2d(internal, oid, internal, smallint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION gserialized_gist_joinsel_2d(internal, oid, internal, smallint) RETURNS double precision
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'gserialized_gist_joinsel_2d';


--
-- Name: gserialized_gist_joinsel_nd(internal, oid, internal, smallint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION gserialized_gist_joinsel_nd(internal, oid, internal, smallint) RETURNS double precision
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'gserialized_gist_joinsel_nd';


--
-- Name: gserialized_gist_sel_2d(internal, oid, internal, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION gserialized_gist_sel_2d(internal, oid, internal, integer) RETURNS double precision
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'gserialized_gist_sel_2d';


--
-- Name: gserialized_gist_sel_nd(internal, oid, internal, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION gserialized_gist_sel_nd(internal, oid, internal, integer) RETURNS double precision
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'gserialized_gist_sel_nd';


--
-- Name: icount(integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION icount(integer[]) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'icount';


--
-- Name: idx(integer[], integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION idx(integer[], integer) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'idx';


--
-- Name: intarray_del_elem(integer[], integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION intarray_del_elem(integer[], integer) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'intarray_del_elem';


--
-- Name: intarray_push_array(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION intarray_push_array(integer[], integer[]) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'intarray_push_array';


--
-- Name: intarray_push_elem(integer[], integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION intarray_push_elem(integer[], integer) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'intarray_push_elem';


--
-- Name: intset(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION intset(integer) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'intset';


--
-- Name: intset_subtract(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION intset_subtract(integer[], integer[]) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'intset_subtract';


--
-- Name: intset_union_elem(integer[], integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION intset_union_elem(integer[], integer) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'intset_union_elem';


--
-- Name: linefromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION linefromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'LINESTRING'
  THEN GeomFromText($1)
  ELSE NULL END
  $_$;


--
-- Name: linefromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION linefromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = 'LINESTRING'
  THEN GeomFromText($1,$2)
  ELSE NULL END
  $_$;


--
-- Name: linefromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION linefromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'LINESTRING'
  THEN GeomFromWKB($1)
  ELSE NULL END
  $_$;


--
-- Name: linefromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION linefromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'LINESTRING'
  THEN GeomFromWKB($1, $2)
  ELSE NULL END
  $_$;


--
-- Name: linestringfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION linestringfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT LineFromText($1)$_$;


--
-- Name: linestringfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION linestringfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT LineFromText($1, $2)$_$;


--
-- Name: linestringfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION linestringfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'LINESTRING'
  THEN GeomFromWKB($1)
  ELSE NULL END
  $_$;


--
-- Name: linestringfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION linestringfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'LINESTRING'
  THEN GeomFromWKB($1, $2)
  ELSE NULL END
  $_$;


--
-- Name: locate_along_measure(geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION locate_along_measure(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT locate_between_measures($1, $2, $2) $_$;


--
-- Name: lockrow(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lockrow(text, text, text) RETURNS integer
    LANGUAGE sql STRICT
    AS $_$ SELECT LockRow(current_schema(), $1, $2, $3, now()::timestamp+'1:00'); $_$;


--
-- Name: FUNCTION lockrow(text, text, text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION lockrow(text, text, text) IS 'args: a_table_name, a_row_key, an_auth_token - Set lock/authorization for specific row in table';


--
-- Name: lockrow(text, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lockrow(text, text, text, text) RETURNS integer
    LANGUAGE sql STRICT
    AS $_$ SELECT LockRow($1, $2, $3, $4, now()::timestamp+'1:00'); $_$;


--
-- Name: lockrow(text, text, text, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lockrow(text, text, text, timestamp without time zone) RETURNS integer
    LANGUAGE sql STRICT
    AS $_$ SELECT LockRow(current_schema(), $1, $2, $3, $4); $_$;


--
-- Name: FUNCTION lockrow(text, text, text, timestamp without time zone); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION lockrow(text, text, text, timestamp without time zone) IS 'args: a_table_name, a_row_key, an_auth_token, expire_dt - Set lock/authorization for specific row in table';


--
-- Name: lockrow(text, text, text, text, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lockrow(text, text, text, text, timestamp without time zone) RETURNS integer
    LANGUAGE plpgsql STRICT
    AS $_$ 
DECLARE
  myschema alias for $1;
  mytable alias for $2;
  myrid   alias for $3;
  authid alias for $4;
  expires alias for $5;
  ret int;
  mytoid oid;
  myrec RECORD;
  
BEGIN

  IF NOT LongTransactionsEnabled() THEN
    RAISE EXCEPTION 'Long transaction support disabled, use EnableLongTransaction() to enable.';
  END IF;

  EXECUTE 'DELETE FROM authorization_table WHERE expires < now()'; 

  SELECT c.oid INTO mytoid FROM pg_class c, pg_namespace n
    WHERE c.relname = mytable
    AND c.relnamespace = n.oid
    AND n.nspname = myschema;

  -- RAISE NOTICE 'toid: %', mytoid;

  FOR myrec IN SELECT * FROM authorization_table WHERE 
    toid = mytoid AND rid = myrid
  LOOP
    IF myrec.authid != authid THEN
      RETURN 0;
    ELSE
      RETURN 1;
    END IF;
  END LOOP;

  EXECUTE 'INSERT INTO authorization_table VALUES ('||
    quote_literal(mytoid::text)||','||quote_literal(myrid)||
    ','||quote_literal(expires::text)||
    ','||quote_literal(authid) ||')';

  GET DIAGNOSTICS ret = ROW_COUNT;

  RETURN ret;
END;
$_$;


--
-- Name: FUNCTION lockrow(text, text, text, text, timestamp without time zone); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION lockrow(text, text, text, text, timestamp without time zone) IS 'args: a_schema_name, a_table_name, a_row_key, an_auth_token, expire_dt - Set lock/authorization for specific row in table';


--
-- Name: longtransactionsenabled(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION longtransactionsenabled() RETURNS boolean
    LANGUAGE plpgsql
    AS $$ 
DECLARE
  rec RECORD;
BEGIN
  FOR rec IN SELECT oid FROM pg_class WHERE relname = 'authorized_tables'
  LOOP
    return 't';
  END LOOP;
  return 'f';
END;
$$;


--
-- Name: mlinefromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mlinefromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'MULTILINESTRING'
  THEN GeomFromText($1)
  ELSE NULL END
  $_$;


--
-- Name: mlinefromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mlinefromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE
  WHEN geometrytype(GeomFromText($1, $2)) = 'MULTILINESTRING'
  THEN GeomFromText($1,$2)
  ELSE NULL END
  $_$;


--
-- Name: mlinefromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mlinefromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTILINESTRING'
  THEN GeomFromWKB($1)
  ELSE NULL END
  $_$;


--
-- Name: mlinefromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mlinefromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'MULTILINESTRING'
  THEN GeomFromWKB($1, $2)
  ELSE NULL END
  $_$;


--
-- Name: mpointfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mpointfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'MULTIPOINT'
  THEN GeomFromText($1)
  ELSE NULL END
  $_$;


--
-- Name: mpointfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mpointfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromText($1,$2)) = 'MULTIPOINT'
  THEN GeomFromText($1,$2)
  ELSE NULL END
  $_$;


--
-- Name: mpointfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mpointfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTIPOINT'
  THEN GeomFromWKB($1)
  ELSE NULL END
  $_$;


--
-- Name: mpointfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mpointfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromWKB($1,$2)) = 'MULTIPOINT'
  THEN GeomFromWKB($1, $2)
  ELSE NULL END
  $_$;


--
-- Name: mpolyfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mpolyfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'MULTIPOLYGON'
  THEN GeomFromText($1)
  ELSE NULL END
  $_$;


--
-- Name: mpolyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mpolyfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = 'MULTIPOLYGON'
  THEN GeomFromText($1,$2)
  ELSE NULL END
  $_$;


--
-- Name: mpolyfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mpolyfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTIPOLYGON'
  THEN GeomFromWKB($1)
  ELSE NULL END
  $_$;


--
-- Name: mpolyfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mpolyfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'MULTIPOLYGON'
  THEN GeomFromWKB($1, $2)
  ELSE NULL END
  $_$;


--
-- Name: multilinefromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION multilinefromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTILINESTRING'
  THEN GeomFromWKB($1)
  ELSE NULL END
  $_$;


--
-- Name: multilinefromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION multilinefromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'MULTILINESTRING'
  THEN GeomFromWKB($1, $2)
  ELSE NULL END
  $_$;


--
-- Name: multilinestringfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION multilinestringfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_MLineFromText($1)$_$;


--
-- Name: multilinestringfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION multilinestringfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MLineFromText($1, $2)$_$;


--
-- Name: multipointfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION multipointfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MPointFromText($1)$_$;


--
-- Name: multipointfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION multipointfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MPointFromText($1, $2)$_$;


--
-- Name: multipointfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION multipointfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTIPOINT'
  THEN GeomFromWKB($1)
  ELSE NULL END
  $_$;


--
-- Name: multipointfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION multipointfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromWKB($1,$2)) = 'MULTIPOINT'
  THEN GeomFromWKB($1, $2)
  ELSE NULL END
  $_$;


--
-- Name: multipolyfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION multipolyfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTIPOLYGON'
  THEN GeomFromWKB($1)
  ELSE NULL END
  $_$;


--
-- Name: multipolyfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION multipolyfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'MULTIPOLYGON'
  THEN GeomFromWKB($1, $2)
  ELSE NULL END
  $_$;


--
-- Name: multipolygonfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION multipolygonfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MPolyFromText($1)$_$;


--
-- Name: multipolygonfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION multipolygonfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MPolyFromText($1, $2)$_$;


--
-- Name: path(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION path(geometry) RETURNS path
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geometry_to_path';


--
-- Name: pgis_geometry_accum_finalfn(pgis_abs); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION pgis_geometry_accum_finalfn(pgis_abs) RETURNS geometry[]
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'pgis_geometry_accum_finalfn';


--
-- Name: pgis_geometry_accum_transfn(pgis_abs, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION pgis_geometry_accum_transfn(pgis_abs, geometry) RETURNS pgis_abs
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'pgis_geometry_accum_transfn';


--
-- Name: pgis_geometry_collect_finalfn(pgis_abs); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION pgis_geometry_collect_finalfn(pgis_abs) RETURNS geometry
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'pgis_geometry_collect_finalfn';


--
-- Name: pgis_geometry_makeline_finalfn(pgis_abs); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION pgis_geometry_makeline_finalfn(pgis_abs) RETURNS geometry
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'pgis_geometry_makeline_finalfn';


--
-- Name: pgis_geometry_polygonize_finalfn(pgis_abs); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION pgis_geometry_polygonize_finalfn(pgis_abs) RETURNS geometry
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'pgis_geometry_polygonize_finalfn';


--
-- Name: pgis_geometry_union_finalfn(pgis_abs); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION pgis_geometry_union_finalfn(pgis_abs) RETURNS geometry
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'pgis_geometry_union_finalfn';


--
-- Name: point(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION point(geometry) RETURNS point
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geometry_to_point';


--
-- Name: pointfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION pointfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'POINT'
  THEN GeomFromText($1)
  ELSE NULL END
  $_$;


--
-- Name: pointfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION pointfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = 'POINT'
  THEN GeomFromText($1,$2)
  ELSE NULL END
  $_$;


--
-- Name: pointfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION pointfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'POINT'
  THEN GeomFromWKB($1)
  ELSE NULL END
  $_$;


--
-- Name: pointfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION pointfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'POINT'
  THEN GeomFromWKB($1, $2)
  ELSE NULL END
  $_$;


--
-- Name: polyfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION polyfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'POLYGON'
  THEN GeomFromText($1)
  ELSE NULL END
  $_$;


--
-- Name: polyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION polyfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = 'POLYGON'
  THEN GeomFromText($1,$2)
  ELSE NULL END
  $_$;


--
-- Name: polyfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION polyfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'POLYGON'
  THEN GeomFromWKB($1)
  ELSE NULL END
  $_$;


--
-- Name: polyfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION polyfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'POLYGON'
  THEN GeomFromWKB($1, $2)
  ELSE NULL END
  $_$;


--
-- Name: polygon(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION polygon(geometry) RETURNS polygon
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geometry_to_polygon';


--
-- Name: polygonfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION polygonfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT PolyFromText($1)$_$;


--
-- Name: polygonfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION polygonfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT PolyFromText($1, $2)$_$;


--
-- Name: polygonfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION polygonfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'POLYGON'
  THEN GeomFromWKB($1)
  ELSE NULL END
  $_$;


--
-- Name: polygonfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION polygonfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(GeomFromWKB($1,$2)) = 'POLYGON'
  THEN GeomFromWKB($1, $2)
  ELSE NULL END
  $_$;


--
-- Name: populate_geometry_columns(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION populate_geometry_columns() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
  inserted    integer;
  oldcount    integer;
  probed      integer;
  stale       integer;
  gcs         RECORD;
  gc          RECORD;
  gsrid       integer;
  gndims      integer;
  gtype       text;
  query       text;
  gc_is_valid boolean;

BEGIN
  SELECT count(*) INTO oldcount FROM geometry_columns;
  inserted := 0;

  EXECUTE 'TRUNCATE geometry_columns';

  -- Count the number of geometry columns in all tables and views
  SELECT count(DISTINCT c.oid) INTO probed
  FROM pg_class c,
     pg_attribute a,
     pg_type t,
     pg_namespace n
  WHERE (c.relkind = 'r' OR c.relkind = 'v')
  AND t.typname = 'geometry'
  AND a.attisdropped = false
  AND a.atttypid = t.oid
  AND a.attrelid = c.oid
  AND c.relnamespace = n.oid
  AND n.nspname NOT ILIKE 'pg_temp%';

  -- Iterate through all non-dropped geometry columns
  RAISE DEBUG 'Processing Tables.....';

  FOR gcs IN
  SELECT DISTINCT ON (c.oid) c.oid, n.nspname, c.relname
    FROM pg_class c,
       pg_attribute a,
       pg_type t,
       pg_namespace n
    WHERE c.relkind = 'r'
    AND t.typname = 'geometry'
    AND a.attisdropped = false
    AND a.atttypid = t.oid
    AND a.attrelid = c.oid
    AND c.relnamespace = n.oid
    AND n.nspname NOT ILIKE 'pg_temp%'
  LOOP

  inserted := inserted + populate_geometry_columns(gcs.oid);
  END LOOP;

  -- Add views to geometry columns table
  RAISE DEBUG 'Processing Views.....';
  FOR gcs IN
  SELECT DISTINCT ON (c.oid) c.oid, n.nspname, c.relname
    FROM pg_class c,
       pg_attribute a,
       pg_type t,
       pg_namespace n
    WHERE c.relkind = 'v'
    AND t.typname = 'geometry'
    AND a.attisdropped = false
    AND a.atttypid = t.oid
    AND a.attrelid = c.oid
    AND c.relnamespace = n.oid
  LOOP

  inserted := inserted + populate_geometry_columns(gcs.oid);
  END LOOP;

  IF oldcount > inserted THEN
  stale = oldcount-inserted;
  ELSE
  stale = 0;
  END IF;

  RETURN 'probed:' ||probed|| ' inserted:'||inserted|| ' conflicts:'||probed-inserted|| ' deleted:'||stale;
END

$$;


--
-- Name: populate_geometry_columns(oid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION populate_geometry_columns(tbl_oid oid) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
  gcs         RECORD;
  gc          RECORD;
  gsrid       integer;
  gndims      integer;
  gtype       text;
  query       text;
  gc_is_valid boolean;
  inserted    integer;

BEGIN
  inserted := 0;

  -- Iterate through all geometry columns in this table
  FOR gcs IN
  SELECT n.nspname, c.relname, a.attname
    FROM pg_class c,
       pg_attribute a,
       pg_type t,
       pg_namespace n
    WHERE c.relkind = 'r'
    AND t.typname = 'geometry'
    AND a.attisdropped = false
    AND a.atttypid = t.oid
    AND a.attrelid = c.oid
    AND c.relnamespace = n.oid
    AND n.nspname NOT ILIKE 'pg_temp%'
    AND c.oid = tbl_oid
  LOOP

  RAISE DEBUG 'Processing table %.%.%', gcs.nspname, gcs.relname, gcs.attname;

  DELETE FROM geometry_columns
    WHERE f_table_schema = quote_ident(gcs.nspname)
    AND f_table_name = quote_ident(gcs.relname)
    AND f_geometry_column = quote_ident(gcs.attname);

  gc_is_valid := true;

  -- Try to find srid check from system tables (pg_constraint)
  gsrid :=
    (SELECT replace(replace(split_part(s.consrc, ' = ', 2), ')', ''), '(', '')
     FROM pg_class c, pg_namespace n, pg_attribute a, pg_constraint s
     WHERE n.nspname = gcs.nspname
     AND c.relname = gcs.relname
     AND a.attname = gcs.attname
     AND a.attrelid = c.oid
     AND s.connamespace = n.oid
     AND s.conrelid = c.oid
     AND a.attnum = ANY (s.conkey)
     AND s.consrc LIKE '%srid(% = %');
  IF (gsrid IS NULL) THEN
    -- Try to find srid from the geometry itself
    EXECUTE 'SELECT srid(' || quote_ident(gcs.attname) || ')
         FROM ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
         WHERE ' || quote_ident(gcs.attname) || ' IS NOT NULL LIMIT 1'
      INTO gc;
    gsrid := gc.srid;

    -- Try to apply srid check to column
    IF (gsrid IS NOT NULL) THEN
      BEGIN
        EXECUTE 'ALTER TABLE ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
             ADD CONSTRAINT ' || quote_ident('enforce_srid_' || gcs.attname) || '
             CHECK (srid(' || quote_ident(gcs.attname) || ') = ' || gsrid || ')';
      EXCEPTION
        WHEN check_violation THEN
          RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not apply constraint CHECK (srid(%) = %)', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname), quote_ident(gcs.attname), gsrid;
          gc_is_valid := false;
      END;
    END IF;
  END IF;

  -- Try to find ndims check from system tables (pg_constraint)
  gndims :=
    (SELECT replace(split_part(s.consrc, ' = ', 2), ')', '')
     FROM pg_class c, pg_namespace n, pg_attribute a, pg_constraint s
     WHERE n.nspname = gcs.nspname
     AND c.relname = gcs.relname
     AND a.attname = gcs.attname
     AND a.attrelid = c.oid
     AND s.connamespace = n.oid
     AND s.conrelid = c.oid
     AND a.attnum = ANY (s.conkey)
     AND s.consrc LIKE '%ndims(% = %');
  IF (gndims IS NULL) THEN
    -- Try to find ndims from the geometry itself
    EXECUTE 'SELECT ndims(' || quote_ident(gcs.attname) || ')
         FROM ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
         WHERE ' || quote_ident(gcs.attname) || ' IS NOT NULL LIMIT 1'
      INTO gc;
    gndims := gc.ndims;

    -- Try to apply ndims check to column
    IF (gndims IS NOT NULL) THEN
      BEGIN
        EXECUTE 'ALTER TABLE ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
             ADD CONSTRAINT ' || quote_ident('enforce_dims_' || gcs.attname) || '
             CHECK (ndims(' || quote_ident(gcs.attname) || ') = '||gndims||')';
      EXCEPTION
        WHEN check_violation THEN
          RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not apply constraint CHECK (ndims(%) = %)', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname), quote_ident(gcs.attname), gndims;
          gc_is_valid := false;
      END;
    END IF;
  END IF;

  -- Try to find geotype check from system tables (pg_constraint)
  gtype :=
    (SELECT replace(split_part(s.consrc, '''', 2), ')', '')
     FROM pg_class c, pg_namespace n, pg_attribute a, pg_constraint s
     WHERE n.nspname = gcs.nspname
     AND c.relname = gcs.relname
     AND a.attname = gcs.attname
     AND a.attrelid = c.oid
       AND s.connamespace = n.oid
     AND s.conrelid = c.oid
     AND a.attnum = ANY (s.conkey)
     AND s.consrc LIKE '%geometrytype(% = %');
  IF (gtype IS NULL) THEN
    -- Try to find geotype from the geometry itself
    EXECUTE 'SELECT geometrytype(' || quote_ident(gcs.attname) || ')
         FROM ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
         WHERE ' || quote_ident(gcs.attname) || ' IS NOT NULL LIMIT 1'
      INTO gc;
    gtype := gc.geometrytype;
    --IF (gtype IS NULL) THEN
    --    gtype := 'GEOMETRY';
    --END IF;

    -- Try to apply geometrytype check to column
    IF (gtype IS NOT NULL) THEN
      BEGIN
        EXECUTE 'ALTER TABLE ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
        ADD CONSTRAINT ' || quote_ident('enforce_geotype_' || gcs.attname) || '
        CHECK ((geometrytype(' || quote_ident(gcs.attname) || ') = ' || quote_literal(gtype) || ') OR (' || quote_ident(gcs.attname) || ' IS NULL))';
      EXCEPTION
        WHEN check_violation THEN
          -- No geometry check can be applied. This column contains a number of geometry types.
          RAISE WARNING 'Could not add geometry type check (%) to table column: %.%.%', gtype, quote_ident(gcs.nspname),quote_ident(gcs.relname),quote_ident(gcs.attname);
      END;
    END IF;
  END IF;

  IF (gsrid IS NULL) THEN
    RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not determine the srid', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname);
  ELSIF (gndims IS NULL) THEN
    RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not determine the number of dimensions', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname);
  ELSIF (gtype IS NULL) THEN
    RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not determine the geometry type', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname);
  ELSE
    -- Only insert into geometry_columns if table constraints could be applied.
    IF (gc_is_valid) THEN
      INSERT INTO geometry_columns (f_table_catalog,f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
      VALUES ('', gcs.nspname, gcs.relname, gcs.attname, gndims, gsrid, gtype);
      inserted := inserted + 1;
    END IF;
  END IF;
  END LOOP;

  -- Add views to geometry columns table
  FOR gcs IN
  SELECT n.nspname, c.relname, a.attname
    FROM pg_class c,
       pg_attribute a,
       pg_type t,
       pg_namespace n
    WHERE c.relkind = 'v'
    AND t.typname = 'geometry'
    AND a.attisdropped = false
    AND a.atttypid = t.oid
    AND a.attrelid = c.oid
    AND c.relnamespace = n.oid
    AND n.nspname NOT ILIKE 'pg_temp%'
    AND c.oid = tbl_oid
  LOOP
    RAISE DEBUG 'Processing view %.%.%', gcs.nspname, gcs.relname, gcs.attname;

    EXECUTE 'SELECT ndims(' || quote_ident(gcs.attname) || ')
         FROM ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
         WHERE ' || quote_ident(gcs.attname) || ' IS NOT NULL LIMIT 1'
      INTO gc;
    gndims := gc.ndims;

    EXECUTE 'SELECT srid(' || quote_ident(gcs.attname) || ')
         FROM ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
         WHERE ' || quote_ident(gcs.attname) || ' IS NOT NULL LIMIT 1'
      INTO gc;
    gsrid := gc.srid;

    EXECUTE 'SELECT geometrytype(' || quote_ident(gcs.attname) || ')
         FROM ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
         WHERE ' || quote_ident(gcs.attname) || ' IS NOT NULL LIMIT 1'
      INTO gc;
    gtype := gc.geometrytype;

    IF (gndims IS NULL) THEN
      RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not determine ndims', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname);
    ELSIF (gsrid IS NULL) THEN
      RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not determine srid', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname);
    ELSIF (gtype IS NULL) THEN
      RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not determine gtype', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname);
    ELSE
      query := 'INSERT INTO geometry_columns (f_table_catalog,f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type) ' ||
           'VALUES ('''', ' || quote_literal(gcs.nspname) || ',' || quote_literal(gcs.relname) || ',' || quote_literal(gcs.attname) || ',' || gndims || ',' || gsrid || ',' || quote_literal(gtype) || ')';
      EXECUTE query;
      inserted := inserted + 1;
    END IF;
  END LOOP;

  RETURN inserted;
END

$$;


--
-- Name: populate_geometry_columns(boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION populate_geometry_columns(use_typmod boolean DEFAULT true) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
  inserted    integer;
  oldcount    integer;
  probed      integer;
  stale       integer;
  gcs         RECORD;
  gc          RECORD;
  gsrid       integer;
  gndims      integer;
  gtype       text;
  query       text;
  gc_is_valid boolean;

BEGIN
  SELECT count(*) INTO oldcount FROM geometry_columns;
  inserted := 0;

  -- Count the number of geometry columns in all tables and views
  SELECT count(DISTINCT c.oid) INTO probed
  FROM pg_class c,
     pg_attribute a,
     pg_type t,
     pg_namespace n
  WHERE (c.relkind = 'r' OR c.relkind = 'v')
    AND t.typname = 'geometry'
    AND a.attisdropped = false
    AND a.atttypid = t.oid
    AND a.attrelid = c.oid
    AND c.relnamespace = n.oid
    AND n.nspname NOT ILIKE 'pg_temp%' AND c.relname != 'raster_columns' ;

  -- Iterate through all non-dropped geometry columns
  RAISE DEBUG 'Processing Tables.....';

  FOR gcs IN
  SELECT DISTINCT ON (c.oid) c.oid, n.nspname, c.relname
    FROM pg_class c,
       pg_attribute a,
       pg_type t,
       pg_namespace n
    WHERE c.relkind = 'r'
    AND t.typname = 'geometry'
    AND a.attisdropped = false
    AND a.atttypid = t.oid
    AND a.attrelid = c.oid
    AND c.relnamespace = n.oid
    AND n.nspname NOT ILIKE 'pg_temp%' AND c.relname != 'raster_columns' 
  LOOP

    inserted := inserted + populate_geometry_columns(gcs.oid, use_typmod);
  END LOOP;

  IF oldcount > inserted THEN
      stale = oldcount-inserted;
  ELSE
      stale = 0;
  END IF;

  RETURN 'probed:' ||probed|| ' inserted:'||inserted;
END

$$;


--
-- Name: FUNCTION populate_geometry_columns(use_typmod boolean); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION populate_geometry_columns(use_typmod boolean) IS 'args: use_typmod=true - Ensures geometry columns are defined with type modifiers or have appropriate spatial constraints This ensures they will be registered correctly in geometry_columns view. By default will convert all geometry columns with no type modifier to ones with type modifiers. To get old behavior set use_typmod=false';


--
-- Name: populate_geometry_columns(oid, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION populate_geometry_columns(tbl_oid oid, use_typmod boolean DEFAULT true) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
  gcs         RECORD;
  gc          RECORD;
  gc_old      RECORD;
  gsrid       integer;
  gndims      integer;
  gtype       text;
  query       text;
  gc_is_valid boolean;
  inserted    integer;
  constraint_successful boolean := false;

BEGIN
  inserted := 0;

  -- Iterate through all geometry columns in this table
  FOR gcs IN
  SELECT n.nspname, c.relname, a.attname
    FROM pg_class c,
       pg_attribute a,
       pg_type t,
       pg_namespace n
    WHERE c.relkind = 'r'
    AND t.typname = 'geometry'
    AND a.attisdropped = false
    AND a.atttypid = t.oid
    AND a.attrelid = c.oid
    AND c.relnamespace = n.oid
    AND n.nspname NOT ILIKE 'pg_temp%'
    AND c.oid = tbl_oid
  LOOP

        RAISE DEBUG 'Processing column %.%.%', gcs.nspname, gcs.relname, gcs.attname;
    
        gc_is_valid := true;
        -- Find the srid, coord_dimension, and type of current geometry
        -- in geometry_columns -- which is now a view
        
        SELECT type, srid, coord_dimension INTO gc_old 
            FROM geometry_columns 
            WHERE f_table_schema = gcs.nspname AND f_table_name = gcs.relname AND f_geometry_column = gcs.attname; 
            
        IF upper(gc_old.type) = 'GEOMETRY' THEN
        -- This is an unconstrained geometry we need to do something
        -- We need to figure out what to set the type by inspecting the data
            EXECUTE 'SELECT st_srid(' || quote_ident(gcs.attname) || ') As srid, GeometryType(' || quote_ident(gcs.attname) || ') As type, ST_NDims(' || quote_ident(gcs.attname) || ') As dims ' ||
                     ' FROM ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || 
                     ' WHERE ' || quote_ident(gcs.attname) || ' IS NOT NULL LIMIT 1;'
                INTO gc;
            IF gc IS NULL THEN -- there is no data so we can not determine geometry type
              RAISE WARNING 'No data in table %.%, so no information to determine geometry type and srid', gcs.nspname, gcs.relname;
              RETURN 0;
            END IF;
            gsrid := gc.srid; gtype := gc.type; gndims := gc.dims;
              
            IF use_typmod THEN
                BEGIN
                    EXECUTE 'ALTER TABLE ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || ' ALTER COLUMN ' || quote_ident(gcs.attname) || 
                        ' TYPE geometry(' || postgis_type_name(gtype, gndims, true) || ', ' || gsrid::text  || ') ';
                    inserted := inserted + 1;
                EXCEPTION
                        WHEN invalid_parameter_value OR feature_not_supported THEN
                        RAISE WARNING 'Could not convert ''%'' in ''%.%'' to use typmod with srid %, type %: %', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname), gsrid, postgis_type_name(gtype, gndims, true), SQLERRM;
                            gc_is_valid := false;
                END;
                
            ELSE
                -- Try to apply srid check to column
              constraint_successful = false;
                IF (gsrid > 0 AND postgis_constraint_srid(gcs.nspname, gcs.relname,gcs.attname) IS NULL ) THEN
                    BEGIN
                        EXECUTE 'ALTER TABLE ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || 
                                 ' ADD CONSTRAINT ' || quote_ident('enforce_srid_' || gcs.attname) || 
                                 ' CHECK (st_srid(' || quote_ident(gcs.attname) || ') = ' || gsrid || ')';
                        constraint_successful := true;
                    EXCEPTION
                        WHEN check_violation THEN
                            RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not apply constraint CHECK (st_srid(%) = %)', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname), quote_ident(gcs.attname), gsrid;
                            gc_is_valid := false;
                    END;
                END IF;
                
                -- Try to apply ndims check to column
                IF (gndims IS NOT NULL AND postgis_constraint_dims(gcs.nspname, gcs.relname,gcs.attname) IS NULL ) THEN
                    BEGIN
                        EXECUTE 'ALTER TABLE ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
                                 ADD CONSTRAINT ' || quote_ident('enforce_dims_' || gcs.attname) || '
                                 CHECK (st_ndims(' || quote_ident(gcs.attname) || ') = '||gndims||')';
                        constraint_successful := true;
                    EXCEPTION
                        WHEN check_violation THEN
                            RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not apply constraint CHECK (st_ndims(%) = %)', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname), quote_ident(gcs.attname), gndims;
                            gc_is_valid := false;
                    END;
                END IF;
    
                -- Try to apply geometrytype check to column
                IF (gtype IS NOT NULL AND postgis_constraint_type(gcs.nspname, gcs.relname,gcs.attname) IS NULL ) THEN
                    BEGIN
                        EXECUTE 'ALTER TABLE ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
                        ADD CONSTRAINT ' || quote_ident('enforce_geotype_' || gcs.attname) || '
                        CHECK ((geometrytype(' || quote_ident(gcs.attname) || ') = ' || quote_literal(gtype) || ') OR (' || quote_ident(gcs.attname) || ' IS NULL))';
                        constraint_successful := true;
                    EXCEPTION
                        WHEN check_violation THEN
                            -- No geometry check can be applied. This column contains a number of geometry types.
                            RAISE WARNING 'Could not add geometry type check (%) to table column: %.%.%', gtype, quote_ident(gcs.nspname),quote_ident(gcs.relname),quote_ident(gcs.attname);
                    END;
                END IF;
                 --only count if we were successful in applying at least one constraint
                IF constraint_successful THEN
                  inserted := inserted + 1;
                END IF;
            END IF;         
      END IF;

  END LOOP;

  RETURN inserted;
END

$$;


--
-- Name: FUNCTION populate_geometry_columns(tbl_oid oid, use_typmod boolean); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION populate_geometry_columns(tbl_oid oid, use_typmod boolean) IS 'args: relation_oid, use_typmod=true - Ensures geometry columns are defined with type modifiers or have appropriate spatial constraints This ensures they will be registered correctly in geometry_columns view. By default will convert all geometry columns with no type modifier to ones with type modifiers. To get old behavior set use_typmod=false';


--
-- Name: postgis_addbbox(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION postgis_addbbox(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_addBBOX';


--
-- Name: FUNCTION postgis_addbbox(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION postgis_addbbox(geometry) IS 'args: geomA - Add bounding box to the geometry.';


--
-- Name: postgis_cache_bbox(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION postgis_cache_bbox() RETURNS trigger
    LANGUAGE c
    AS '$libdir/postgis-2.1', 'cache_bbox';


--
-- Name: postgis_constraint_dims(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION postgis_constraint_dims(geomschema text, geomtable text, geomcolumn text) RETURNS integer
    LANGUAGE sql STABLE STRICT
    AS $_$
SELECT  replace(split_part(s.consrc, ' = ', 2), ')', '')::integer
     FROM pg_class c, pg_namespace n, pg_attribute a, pg_constraint s
     WHERE n.nspname = $1
     AND c.relname = $2
     AND a.attname = $3
     AND a.attrelid = c.oid
     AND s.connamespace = n.oid
     AND s.conrelid = c.oid
     AND a.attnum = ANY (s.conkey)
     AND s.consrc LIKE '%ndims(% = %';
$_$;


--
-- Name: postgis_constraint_srid(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION postgis_constraint_srid(geomschema text, geomtable text, geomcolumn text) RETURNS integer
    LANGUAGE sql STABLE STRICT
    AS $_$
SELECT replace(replace(split_part(s.consrc, ' = ', 2), ')', ''), '(', '')::integer
     FROM pg_class c, pg_namespace n, pg_attribute a, pg_constraint s
     WHERE n.nspname = $1
     AND c.relname = $2
     AND a.attname = $3
     AND a.attrelid = c.oid
     AND s.connamespace = n.oid
     AND s.conrelid = c.oid
     AND a.attnum = ANY (s.conkey)
     AND s.consrc LIKE '%srid(% = %';
$_$;


--
-- Name: postgis_constraint_type(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION postgis_constraint_type(geomschema text, geomtable text, geomcolumn text) RETURNS character varying
    LANGUAGE sql STABLE STRICT
    AS $_$
SELECT  replace(split_part(s.consrc, '''', 2), ')', '')::varchar    
     FROM pg_class c, pg_namespace n, pg_attribute a, pg_constraint s
     WHERE n.nspname = $1
     AND c.relname = $2
     AND a.attname = $3
     AND a.attrelid = c.oid
     AND s.connamespace = n.oid
     AND s.conrelid = c.oid
     AND a.attnum = ANY (s.conkey)
     AND s.consrc LIKE '%geometrytype(% = %';
$_$;


--
-- Name: postgis_dropbbox(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION postgis_dropbbox(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_dropBBOX';


--
-- Name: FUNCTION postgis_dropbbox(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION postgis_dropbbox(geometry) IS 'args: geomA - Drop the bounding box cache from the geometry.';


--
-- Name: postgis_full_version(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION postgis_full_version() RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
  libver text;
  svnver text;
  projver text;
  geosver text;
  sfcgalver text;
  cgalver text;
  gdalver text;
  libxmlver text;
  dbproc text;
  relproc text;
  fullver text;
  rast_lib_ver text;
  rast_scr_ver text;
  topo_scr_ver text;
  json_lib_ver text;
BEGIN
  SELECT postgis_lib_version() INTO libver;
  SELECT postgis_proj_version() INTO projver;
  SELECT postgis_geos_version() INTO geosver;
  SELECT postgis_libjson_version() INTO json_lib_ver;
  BEGIN
    SELECT postgis_gdal_version() INTO gdalver;
  EXCEPTION
    WHEN undefined_function THEN
      gdalver := NULL;
      RAISE NOTICE 'Function postgis_gdal_version() not found.  Is raster support enabled and rtpostgis.sql installed?';
  END;
  BEGIN
    SELECT postgis_sfcgal_version() INTO sfcgalver;
  EXCEPTION
    WHEN undefined_function THEN
      sfcgalver := NULL;
  END;
  SELECT postgis_libxml_version() INTO libxmlver;
  SELECT postgis_scripts_installed() INTO dbproc;
  SELECT postgis_scripts_released() INTO relproc;
  select postgis_svn_version() INTO svnver;
  BEGIN
    SELECT topology.postgis_topology_scripts_installed() INTO topo_scr_ver;
  EXCEPTION
    WHEN undefined_function OR invalid_schema_name THEN
      topo_scr_ver := NULL;
      RAISE NOTICE 'Function postgis_topology_scripts_installed() not found. Is topology support enabled and topology.sql installed?';
    WHEN insufficient_privilege THEN
      RAISE NOTICE 'Topology support cannot be inspected. Is current user granted USAGE on schema "topology" ?';
    WHEN OTHERS THEN
      RAISE NOTICE 'Function postgis_topology_scripts_installed() could not be called: % (%)', SQLERRM, SQLSTATE;
  END;

  BEGIN
    SELECT postgis_raster_scripts_installed() INTO rast_scr_ver;
  EXCEPTION
    WHEN undefined_function THEN
      rast_scr_ver := NULL;
      RAISE NOTICE 'Function postgis_raster_scripts_installed() not found. Is raster support enabled and rtpostgis.sql installed?';
  END;

  BEGIN
    SELECT postgis_raster_lib_version() INTO rast_lib_ver;
  EXCEPTION
    WHEN undefined_function THEN
      rast_lib_ver := NULL;
      RAISE NOTICE 'Function postgis_raster_lib_version() not found. Is raster support enabled and rtpostgis.sql installed?';
  END;

  fullver = 'POSTGIS="' || libver;

  IF  svnver IS NOT NULL THEN
    fullver = fullver || ' r' || svnver;
  END IF;

  fullver = fullver || '"';

  IF  geosver IS NOT NULL THEN
    fullver = fullver || ' GEOS="' || geosver || '"';
  END IF;

  IF  sfcgalver IS NOT NULL THEN
    fullver = fullver || ' SFCGAL="' || sfcgalver || '"';
  END IF;

  IF  projver IS NOT NULL THEN
    fullver = fullver || ' PROJ="' || projver || '"';
  END IF;

  IF  gdalver IS NOT NULL THEN
    fullver = fullver || ' GDAL="' || gdalver || '"';
  END IF;

  IF  libxmlver IS NOT NULL THEN
    fullver = fullver || ' LIBXML="' || libxmlver || '"';
  END IF;

  IF json_lib_ver IS NOT NULL THEN
    fullver = fullver || ' LIBJSON="' || json_lib_ver || '"';
  END IF;

  -- fullver = fullver || ' DBPROC="' || dbproc || '"';
  -- fullver = fullver || ' RELPROC="' || relproc || '"';

  IF dbproc != relproc THEN
    fullver = fullver || ' (core procs from "' || dbproc || '" need upgrade)';
  END IF;

  IF topo_scr_ver IS NOT NULL THEN
    fullver = fullver || ' TOPOLOGY';
    IF topo_scr_ver != relproc THEN
      fullver = fullver || ' (topology procs from "' || topo_scr_ver || '" need upgrade)';
    END IF;
  END IF;

  IF rast_lib_ver IS NOT NULL THEN
    fullver = fullver || ' RASTER';
    IF rast_lib_ver != relproc THEN
      fullver = fullver || ' (raster lib from "' || rast_lib_ver || '" need upgrade)';
    END IF;
  END IF;

  IF rast_scr_ver IS NOT NULL AND rast_scr_ver != relproc THEN
    fullver = fullver || ' (raster procs from "' || rast_scr_ver || '" need upgrade)';
  END IF;

  RETURN fullver;
END
$$;


--
-- Name: FUNCTION postgis_full_version(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION postgis_full_version() IS 'Reports full postgis version and build configuration infos.';


--
-- Name: postgis_geos_version(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION postgis_geos_version() RETURNS text
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-2.1', 'postgis_geos_version';


--
-- Name: FUNCTION postgis_geos_version(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION postgis_geos_version() IS 'Returns the version number of the GEOS library.';


--
-- Name: postgis_getbbox(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION postgis_getbbox(geometry) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_to_BOX2D';


--
-- Name: postgis_hasbbox(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION postgis_hasbbox(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_hasBBOX';


--
-- Name: FUNCTION postgis_hasbbox(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION postgis_hasbbox(geometry) IS 'args: geomA - Returns TRUE if the bbox of this geometry is cached, FALSE otherwise.';


--
-- Name: postgis_lib_build_date(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION postgis_lib_build_date() RETURNS text
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-2.1', 'postgis_lib_build_date';


--
-- Name: FUNCTION postgis_lib_build_date(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION postgis_lib_build_date() IS 'Returns build date of the PostGIS library.';


--
-- Name: postgis_lib_version(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION postgis_lib_version() RETURNS text
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-2.1', 'postgis_lib_version';


--
-- Name: FUNCTION postgis_lib_version(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION postgis_lib_version() IS 'Returns the version number of the PostGIS library.';


--
-- Name: postgis_libjson_version(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION postgis_libjson_version() RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'postgis_libjson_version';


--
-- Name: postgis_libxml_version(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION postgis_libxml_version() RETURNS text
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-2.1', 'postgis_libxml_version';


--
-- Name: FUNCTION postgis_libxml_version(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION postgis_libxml_version() IS 'Returns the version number of the libxml2 library.';


--
-- Name: postgis_noop(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION postgis_noop(geometry) RETURNS geometry
    LANGUAGE c STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_noop';


--
-- Name: postgis_proj_version(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION postgis_proj_version() RETURNS text
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-2.1', 'postgis_proj_version';


--
-- Name: FUNCTION postgis_proj_version(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION postgis_proj_version() IS 'Returns the version number of the PROJ4 library.';


--
-- Name: postgis_scripts_build_date(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION postgis_scripts_build_date() RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$SELECT '2014-04-07 08:48:40'::text AS version$$;


--
-- Name: FUNCTION postgis_scripts_build_date(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION postgis_scripts_build_date() IS 'Returns build date of the PostGIS scripts.';


--
-- Name: postgis_scripts_installed(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION postgis_scripts_installed() RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$ SELECT '2.1.2'::text || ' r' || 12389::text AS version $$;


--
-- Name: FUNCTION postgis_scripts_installed(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION postgis_scripts_installed() IS 'Returns version of the postgis scripts installed in this database.';


--
-- Name: postgis_scripts_released(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION postgis_scripts_released() RETURNS text
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-2.1', 'postgis_scripts_released';


--
-- Name: FUNCTION postgis_scripts_released(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION postgis_scripts_released() IS 'Returns the version number of the postgis.sql script released with the installed postgis lib.';


--
-- Name: postgis_svn_version(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION postgis_svn_version() RETURNS text
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-2.1', 'postgis_svn_version';


--
-- Name: postgis_transform_geometry(geometry, text, text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION postgis_transform_geometry(geometry, text, text, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'transform_geom';


--
-- Name: postgis_type_name(character varying, integer, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION postgis_type_name(geomname character varying, coord_dimension integer, use_new_name boolean DEFAULT true) RETURNS character varying
    LANGUAGE sql IMMUTABLE STRICT COST 200
    AS $_$
 SELECT CASE WHEN $3 THEN new_name ELSE old_name END As geomname
  FROM 
  ( VALUES
     ('GEOMETRY', 'Geometry', 2) ,
      ('GEOMETRY', 'GeometryZ', 3) ,
      ('GEOMETRY', 'GeometryZM', 4) ,
      ('GEOMETRYCOLLECTION', 'GeometryCollection', 2) ,
      ('GEOMETRYCOLLECTION', 'GeometryCollectionZ', 3) ,
      ('GEOMETRYCOLLECTIONM', 'GeometryCollectionM', 3) ,
      ('GEOMETRYCOLLECTION', 'GeometryCollectionZM', 4) ,
      
      ('POINT', 'Point',2) ,
      ('POINTM','PointM',3) ,
      ('POINT', 'PointZ',3) ,
      ('POINT', 'PointZM',4) ,
      
      ('MULTIPOINT','MultiPoint',2) ,
      ('MULTIPOINT','MultiPointZ',3) ,
      ('MULTIPOINTM','MultiPointM',3) ,
      ('MULTIPOINT','MultiPointZM',4) ,
      
      ('POLYGON', 'Polygon',2) ,
      ('POLYGON', 'PolygonZ',3) ,
      ('POLYGONM', 'PolygonM',3) ,
      ('POLYGON', 'PolygonZM',4) ,
      
      ('MULTIPOLYGON', 'MultiPolygon',2) ,
      ('MULTIPOLYGON', 'MultiPolygonZ',3) ,
      ('MULTIPOLYGONM', 'MultiPolygonM',3) ,
      ('MULTIPOLYGON', 'MultiPolygonZM',4) ,
      
      ('MULTILINESTRING', 'MultiLineString',2) ,
      ('MULTILINESTRING', 'MultiLineStringZ',3) ,
      ('MULTILINESTRINGM', 'MultiLineStringM',3) ,
      ('MULTILINESTRING', 'MultiLineStringZM',4) ,
      
      ('LINESTRING', 'LineString',2) ,
      ('LINESTRING', 'LineStringZ',3) ,
      ('LINESTRINGM', 'LineStringM',3) ,
      ('LINESTRING', 'LineStringZM',4) ,
      
      ('CIRCULARSTRING', 'CircularString',2) ,
      ('CIRCULARSTRING', 'CircularStringZ',3) ,
      ('CIRCULARSTRINGM', 'CircularStringM',3) ,
      ('CIRCULARSTRING', 'CircularStringZM',4) ,
      
      ('COMPOUNDCURVE', 'CompoundCurve',2) ,
      ('COMPOUNDCURVE', 'CompoundCurveZ',3) ,
      ('COMPOUNDCURVEM', 'CompoundCurveM',3) ,
      ('COMPOUNDCURVE', 'CompoundCurveZM',4) ,
      
      ('CURVEPOLYGON', 'CurvePolygon',2) ,
      ('CURVEPOLYGON', 'CurvePolygonZ',3) ,
      ('CURVEPOLYGONM', 'CurvePolygonM',3) ,
      ('CURVEPOLYGON', 'CurvePolygonZM',4) ,
      
      ('MULTICURVE', 'MultiCurve',2 ) ,
      ('MULTICURVE', 'MultiCurveZ',3 ) ,
      ('MULTICURVEM', 'MultiCurveM',3 ) ,
      ('MULTICURVE', 'MultiCurveZM',4 ) ,
      
      ('MULTISURFACE', 'MultiSurface', 2) ,
      ('MULTISURFACE', 'MultiSurfaceZ', 3) ,
      ('MULTISURFACEM', 'MultiSurfaceM', 3) ,
      ('MULTISURFACE', 'MultiSurfaceZM', 4) ,
      
      ('POLYHEDRALSURFACE', 'PolyhedralSurface',2) ,
      ('POLYHEDRALSURFACE', 'PolyhedralSurfaceZ',3) ,
      ('POLYHEDRALSURFACEM', 'PolyhedralSurfaceM',3) ,
      ('POLYHEDRALSURFACE', 'PolyhedralSurfaceZM',4) ,
      
      ('TRIANGLE', 'Triangle',2) ,
      ('TRIANGLE', 'TriangleZ',3) ,
      ('TRIANGLEM', 'TriangleM',3) ,
      ('TRIANGLE', 'TriangleZM',4) ,

      ('TIN', 'Tin', 2),
      ('TIN', 'TinZ', 3),
      ('TIN', 'TinM', 3),
      ('TIN', 'TinZM', 4) )
       As g(old_name, new_name, coord_dimension)
    WHERE (upper(old_name) = upper($1) OR upper(new_name) = upper($1))
      AND coord_dimension = $2;
$_$;


--
-- Name: postgis_typmod_dims(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION postgis_typmod_dims(integer) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'postgis_typmod_dims';


--
-- Name: postgis_typmod_srid(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION postgis_typmod_srid(integer) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'postgis_typmod_srid';


--
-- Name: postgis_typmod_type(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION postgis_typmod_type(integer) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'postgis_typmod_type';


--
-- Name: postgis_version(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION postgis_version() RETURNS text
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-2.1', 'postgis_version';


--
-- Name: FUNCTION postgis_version(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION postgis_version() IS 'Returns PostGIS version number and compile-time options.';


--
-- Name: probe_geometry_columns(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION probe_geometry_columns() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
  inserted integer;
  oldcount integer;
  probed integer;
  stale integer;
BEGIN

  SELECT count(*) INTO oldcount FROM geometry_columns;

  SELECT count(*) INTO probed
    FROM pg_class c, pg_attribute a, pg_type t,
      pg_namespace n,
      pg_constraint sridcheck, pg_constraint typecheck

    WHERE t.typname = 'geometry'
    AND a.atttypid = t.oid
    AND a.attrelid = c.oid
    AND c.relnamespace = n.oid
    AND sridcheck.connamespace = n.oid
    AND typecheck.connamespace = n.oid
    AND sridcheck.conrelid = c.oid
    AND sridcheck.consrc LIKE '(srid('||a.attname||') = %)'
    AND typecheck.conrelid = c.oid
    AND typecheck.consrc LIKE
    '((geometrytype('||a.attname||') = ''%''::text) OR (% IS NULL))'
    ;

  INSERT INTO geometry_columns SELECT
    ''::varchar as f_table_catalogue,
    n.nspname::varchar as f_table_schema,
    c.relname::varchar as f_table_name,
    a.attname::varchar as f_geometry_column,
    2 as coord_dimension,
    trim(both  ' =)' from
      replace(replace(split_part(
        sridcheck.consrc, ' = ', 2), ')', ''), '(', ''))::integer AS srid,
    trim(both ' =)''' from substr(typecheck.consrc,
      strpos(typecheck.consrc, '='),
      strpos(typecheck.consrc, '::')-
      strpos(typecheck.consrc, '=')
      ))::varchar as type
    FROM pg_class c, pg_attribute a, pg_type t,
      pg_namespace n,
      pg_constraint sridcheck, pg_constraint typecheck
    WHERE t.typname = 'geometry'
    AND a.atttypid = t.oid
    AND a.attrelid = c.oid
    AND c.relnamespace = n.oid
    AND sridcheck.connamespace = n.oid
    AND typecheck.connamespace = n.oid
    AND sridcheck.conrelid = c.oid
    AND sridcheck.consrc LIKE '(st_srid('||a.attname||') = %)'
    AND typecheck.conrelid = c.oid
    AND typecheck.consrc LIKE
    '((geometrytype('||a.attname||') = ''%''::text) OR (% IS NULL))'

      AND NOT EXISTS (
          SELECT oid FROM geometry_columns gc
          WHERE c.relname::varchar = gc.f_table_name
          AND n.nspname::varchar = gc.f_table_schema
          AND a.attname::varchar = gc.f_geometry_column
      );

  GET DIAGNOSTICS inserted = ROW_COUNT;

  IF oldcount > probed THEN
    stale = oldcount-probed;
  ELSE
    stale = 0;
  END IF;

  RETURN 'probed:'||probed::text||
    ' inserted:'||inserted::text||
    ' conflicts:'||(probed-inserted)::text||
    ' stale:'||stale::text;
END

$$;


--
-- Name: querytree(query_int); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION querytree(query_int) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'querytree';


--
-- Name: rboolop(query_int, integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION rboolop(query_int, integer[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'rboolop';


--
-- Name: FUNCTION rboolop(query_int, integer[]); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION rboolop(query_int, integer[]) IS 'boolean operation with array';


--
-- Name: rename_geometry_table_constraints(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION rename_geometry_table_constraints() RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT 'rename_geometry_table_constraint() is obsoleted'::text
$$;


--
-- Name: rotate(geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION rotate(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT rotateZ($1, $2)$_$;


--
-- Name: rotatex(geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION rotatex(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT affine($1, 1, 0, 0, 0, cos($2), -sin($2), 0, sin($2), cos($2), 0, 0, 0)$_$;


--
-- Name: rotatey(geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION rotatey(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT affine($1,  cos($2), 0, sin($2),  0, 1, 0,  -sin($2), 0, cos($2), 0,  0, 0)$_$;


--
-- Name: rotatez(geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION rotatez(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT affine($1,  cos($2), -sin($2), 0,  sin($2), cos($2), 0,  0, 0, 1,  0, 0, 0)$_$;


--
-- Name: scale(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION scale(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT scale($1, $2, $3, 1)$_$;


--
-- Name: scale(geometry, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION scale(geometry, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT affine($1,  $2, 0, 0,  0, $3, 0,  0, 0, $4,  0, 0, 0)$_$;


--
-- Name: se_envelopesintersect(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION se_envelopesintersect(geometry, geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ 
  SELECT $1 && $2
  $_$;


--
-- Name: se_locatealong(geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION se_locatealong(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT locate_between_measures($1, $2, $2) $_$;


--
-- Name: snaptogrid(geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION snaptogrid(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT SnapToGrid($1, 0, 0, $2, $2)$_$;


--
-- Name: snaptogrid(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION snaptogrid(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT SnapToGrid($1, 0, 0, $2, $3)$_$;


--
-- Name: somefunc(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION somefunc() RETURNS integer
    LANGUAGE plpgsql
    AS $$

DECLARE
    quantity integer := 30;
    BEGIN
        RAISE NOTICE 'Quantity here is %', quantity;  -- Prints 30
      quantity := 50;
          --
        -- Create a subblock
            --
          DECLARE
                  quantity integer := 80;
                BEGIN
                  RAISE NOTICE 'Quantity here is %', quantity;  -- Prints 80
                    RAISE NOTICE 'Outer quantity here is %', outerblock.quantity;  -- Prints 50
                  END;

                      RAISE NOTICE 'Quantity here is %', quantity;  -- Prints 50

                    RETURN quantity;
                    END;
                    $$;


--
-- Name: sort(integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION sort(integer[]) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'sort';


--
-- Name: sort(integer[], text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION sort(integer[], text) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'sort';


--
-- Name: sort_asc(integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION sort_asc(integer[]) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'sort_asc';


--
-- Name: sort_desc(integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION sort_desc(integer[]) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'sort_desc';


--
-- Name: st_3dclosestpoint(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_3dclosestpoint(geom1 geometry, geom2 geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'LWGEOM_closestpoint3d';


--
-- Name: FUNCTION st_3dclosestpoint(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_3dclosestpoint(geom1 geometry, geom2 geometry) IS 'args: g1, g2 - Returns the 3-dimensional point on g1 that is closest to g2. This is the first point of the 3D shortest line.';


--
-- Name: st_3ddfullywithin(geometry, geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_3ddfullywithin(geom1 geometry, geom2 geometry, double precision) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && ST_Expand($2,$3) AND $2 && ST_Expand($1,$3) AND _ST_3DDFullyWithin($1, $2, $3)$_$;


--
-- Name: FUNCTION st_3ddfullywithin(geom1 geometry, geom2 geometry, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_3ddfullywithin(geom1 geometry, geom2 geometry, double precision) IS 'args: g1, g2, distance - Returns true if all of the 3D geometries are within the specified distance of one another.';


--
-- Name: st_3ddistance(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_3ddistance(geom1 geometry, geom2 geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'distance3d';


--
-- Name: FUNCTION st_3ddistance(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_3ddistance(geom1 geometry, geom2 geometry) IS 'args: g1, g2 - For geometry type Returns the 3-dimensional cartesian minimum distance (based on spatial ref) between two geometries in projected units.';


--
-- Name: st_3ddwithin(geometry, geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_3ddwithin(geom1 geometry, geom2 geometry, double precision) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && ST_Expand($2,$3) AND $2 && ST_Expand($1,$3) AND _ST_3DDWithin($1, $2, $3)$_$;


--
-- Name: FUNCTION st_3ddwithin(geom1 geometry, geom2 geometry, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_3ddwithin(geom1 geometry, geom2 geometry, double precision) IS 'args: g1, g2, distance_of_srid - For 3d (z) geometry type Returns true if two geometries 3d distance is within number of units.';


--
-- Name: st_3dintersects(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_3dintersects(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && $2 AND _ST_3DIntersects($1, $2)$_$;


--
-- Name: FUNCTION st_3dintersects(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_3dintersects(geom1 geometry, geom2 geometry) IS 'args: geomA, geomB - Returns TRUE if the Geometries "spatially intersect" in 3d - only for points and linestrings';


--
-- Name: st_3dlength(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_3dlength(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_length_linestring';


--
-- Name: FUNCTION st_3dlength(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_3dlength(geometry) IS 'args: a_3dlinestring - Returns the 3-dimensional or 2-dimensional length of the geometry if it is a linestring or multi-linestring.';


--
-- Name: st_3dlength_spheroid(geometry, spheroid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_3dlength_spheroid(geometry, spheroid) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'LWGEOM_length_ellipsoid_linestring';


--
-- Name: FUNCTION st_3dlength_spheroid(geometry, spheroid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_3dlength_spheroid(geometry, spheroid) IS 'args: a_linestring, a_spheroid - Calculates the length of a geometry on an ellipsoid, taking the elevation into account. This is just an alias for ST_Length_Spheroid.';


--
-- Name: st_3dlongestline(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_3dlongestline(geom1 geometry, geom2 geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'LWGEOM_longestline3d';


--
-- Name: FUNCTION st_3dlongestline(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_3dlongestline(geom1 geometry, geom2 geometry) IS 'args: g1, g2 - Returns the 3-dimensional longest line between two geometries';


--
-- Name: st_3dmakebox(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_3dmakebox(geom1 geometry, geom2 geometry) RETURNS box3d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'BOX3D_construct';


--
-- Name: FUNCTION st_3dmakebox(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_3dmakebox(geom1 geometry, geom2 geometry) IS 'args: point3DLowLeftBottom, point3DUpRightTop - Creates a BOX3D defined by the given 3d point geometries.';


--
-- Name: st_3dmaxdistance(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_3dmaxdistance(geom1 geometry, geom2 geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'LWGEOM_maxdistance3d';


--
-- Name: FUNCTION st_3dmaxdistance(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_3dmaxdistance(geom1 geometry, geom2 geometry) IS 'args: g1, g2 - For geometry type Returns the 3-dimensional cartesian maximum distance (based on spatial ref) between two geometries in projected units.';


--
-- Name: st_3dperimeter(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_3dperimeter(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_perimeter_poly';


--
-- Name: FUNCTION st_3dperimeter(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_3dperimeter(geometry) IS 'args: geomA - Returns the 3-dimensional perimeter of the geometry, if it is a polygon or multi-polygon.';


--
-- Name: st_3dshortestline(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_3dshortestline(geom1 geometry, geom2 geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'LWGEOM_shortestline3d';


--
-- Name: FUNCTION st_3dshortestline(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_3dshortestline(geom1 geometry, geom2 geometry) IS 'args: g1, g2 - Returns the 3-dimensional shortest line between two geometries';


--
-- Name: st_addmeasure(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_addmeasure(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'ST_AddMeasure';


--
-- Name: FUNCTION st_addmeasure(geometry, double precision, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_addmeasure(geometry, double precision, double precision) IS 'args: geom_mline, measure_start, measure_end - Return a derived geometry with measure elements linearly interpolated between the start and end points. If the geometry has no measure dimension, one is added. If the geometry has a measure dimension, it is over-written with new values. Only LINESTRINGS and MULTILINESTRINGS are supported.';


--
-- Name: st_addpoint(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_addpoint(geom1 geometry, geom2 geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_addpoint';


--
-- Name: FUNCTION st_addpoint(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_addpoint(geom1 geometry, geom2 geometry) IS 'args: linestring, point - Adds a point to a LineString before point <position> (0-based index).';


--
-- Name: st_addpoint(geometry, geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_addpoint(geom1 geometry, geom2 geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_addpoint';


--
-- Name: FUNCTION st_addpoint(geom1 geometry, geom2 geometry, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_addpoint(geom1 geometry, geom2 geometry, integer) IS 'args: linestring, point, position - Adds a point to a LineString before point <position> (0-based index).';


--
-- Name: st_affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_Affine($1,  $2, $3, 0,  $4, $5, 0,  0, 0, 1,  $6, $7, 0)$_$;


--
-- Name: FUNCTION st_affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision) IS 'args: geomA, a, b, d, e, xoff, yoff - Applies a 3d affine transformation to the geometry to do things like translate, rotate, scale in one step.';


--
-- Name: st_affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_affine';


--
-- Name: FUNCTION st_affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision) IS 'args: geomA, a, b, c, d, e, f, g, h, i, xoff, yoff, zoff - Applies a 3d affine transformation to the geometry to do things like translate, rotate, scale in one step.';


--
-- Name: st_area(geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_area(geography) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_Area($1, true)$_$;


--
-- Name: st_area(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_area(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'area';


--
-- Name: FUNCTION st_area(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_area(geometry) IS 'args: g1 - Returns the area of the surface if it is a polygon or multi-polygon. For "geometry" type area is in SRID units. For "geography" area is in square meters.';


--
-- Name: st_area(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_area(text) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_Area($1::geometry);  $_$;


--
-- Name: st_area(geography, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_area(geog geography, use_spheroid boolean DEFAULT true) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'geography_area';


--
-- Name: FUNCTION st_area(geog geography, use_spheroid boolean); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_area(geog geography, use_spheroid boolean) IS 'args: geog, use_spheroid=true - Returns the area of the surface if it is a polygon or multi-polygon. For "geometry" type area is in SRID units. For "geography" area is in square meters.';


--
-- Name: st_area2d(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_area2d(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_area_polygon';


--
-- Name: st_asbinary(geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asbinary(geography) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_asBinary';


--
-- Name: FUNCTION st_asbinary(geography); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_asbinary(geography) IS 'args: g1 - Return the Well-Known Binary (WKB) representation of the geometry/geography without SRID meta data.';


--
-- Name: st_asbinary(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asbinary(geometry) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_asBinary';


--
-- Name: FUNCTION st_asbinary(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_asbinary(geometry) IS 'args: g1 - Return the Well-Known Binary (WKB) representation of the geometry/geography without SRID meta data.';


--
-- Name: st_asbinary(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asbinary(text) RETURNS bytea
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsBinary($1::geometry);  $_$;


--
-- Name: st_asbinary(geography, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asbinary(geography, text) RETURNS bytea
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsBinary($1::geometry, $2);  $_$;


--
-- Name: FUNCTION st_asbinary(geography, text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_asbinary(geography, text) IS 'args: g1, NDR_or_XDR - Return the Well-Known Binary (WKB) representation of the geometry/geography without SRID meta data.';


--
-- Name: st_asbinary(geometry, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asbinary(geometry, text) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_asBinary';


--
-- Name: FUNCTION st_asbinary(geometry, text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_asbinary(geometry, text) IS 'args: g1, NDR_or_XDR - Return the Well-Known Binary (WKB) representation of the geometry/geography without SRID meta data.';


--
-- Name: st_asewkb(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asewkb(geometry) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'WKBFromLWGEOM';


--
-- Name: FUNCTION st_asewkb(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_asewkb(geometry) IS 'args: g1 - Return the Well-Known Binary (WKB) representation of the geometry with SRID meta data.';


--
-- Name: st_asewkb(geometry, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asewkb(geometry, text) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'WKBFromLWGEOM';


--
-- Name: FUNCTION st_asewkb(geometry, text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_asewkb(geometry, text) IS 'args: g1, NDR_or_XDR - Return the Well-Known Binary (WKB) representation of the geometry with SRID meta data.';


--
-- Name: st_asewkt(geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asewkt(geography) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_asEWKT';


--
-- Name: FUNCTION st_asewkt(geography); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_asewkt(geography) IS 'args: g1 - Return the Well-Known Text (WKT) representation of the geometry with SRID meta data.';


--
-- Name: st_asewkt(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asewkt(geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_asEWKT';


--
-- Name: FUNCTION st_asewkt(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_asewkt(geometry) IS 'args: g1 - Return the Well-Known Text (WKT) representation of the geometry with SRID meta data.';


--
-- Name: st_asewkt(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asewkt(text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsEWKT($1::geometry);  $_$;


--
-- Name: st_asgeojson(geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgeojson(geography) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGeoJson(1, $1, 15, 0)$_$;


--
-- Name: st_asgeojson(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgeojson(geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGeoJson(1, $1, 15, 0)$_$;


--
-- Name: st_asgeojson(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgeojson(text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT _ST_AsGeoJson(1, $1::geometry,15,0);  $_$;


--
-- Name: st_asgeojson(integer, geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgeojson(integer, geography) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGeoJson($1, $2, 15, 0)$_$;


--
-- Name: st_asgeojson(integer, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgeojson(integer, geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGeoJson($1, $2, 15, 0)$_$;


--
-- Name: st_asgeojson(geography, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgeojson(geography, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGeoJson(1, $1, $2, 0)$_$;


--
-- Name: st_asgeojson(geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgeojson(geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGeoJson(1, $1, $2, 0)$_$;


--
-- Name: st_asgeojson(geography, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgeojson(geog geography, maxdecimaldigits integer DEFAULT 15, options integer DEFAULT 0) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT _ST_AsGeoJson(1, $1, $2, $3); $_$;


--
-- Name: FUNCTION st_asgeojson(geog geography, maxdecimaldigits integer, options integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_asgeojson(geog geography, maxdecimaldigits integer, options integer) IS 'args: geog, maxdecimaldigits=15, options=0 - Return the geometry as a GeoJSON element.';


--
-- Name: st_asgeojson(geometry, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgeojson(geom geometry, maxdecimaldigits integer DEFAULT 15, options integer DEFAULT 0) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT _ST_AsGeoJson(1, $1, $2, $3); $_$;


--
-- Name: FUNCTION st_asgeojson(geom geometry, maxdecimaldigits integer, options integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_asgeojson(geom geometry, maxdecimaldigits integer, options integer) IS 'args: geom, maxdecimaldigits=15, options=0 - Return the geometry as a GeoJSON element.';


--
-- Name: st_asgeojson(integer, geography, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgeojson(integer, geography, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGeoJson($1, $2, $3, 0)$_$;


--
-- Name: st_asgeojson(integer, geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgeojson(integer, geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGeoJson($1, $2, $3, 0)$_$;


--
-- Name: st_asgeojson(integer, geography, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgeojson(gj_version integer, geog geography, maxdecimaldigits integer DEFAULT 15, options integer DEFAULT 0) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT _ST_AsGeoJson($1, $2, $3, $4); $_$;


--
-- Name: FUNCTION st_asgeojson(gj_version integer, geog geography, maxdecimaldigits integer, options integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_asgeojson(gj_version integer, geog geography, maxdecimaldigits integer, options integer) IS 'args: gj_version, geog, maxdecimaldigits=15, options=0 - Return the geometry as a GeoJSON element.';


--
-- Name: st_asgeojson(integer, geometry, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgeojson(gj_version integer, geom geometry, maxdecimaldigits integer DEFAULT 15, options integer DEFAULT 0) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT _ST_AsGeoJson($1, $2, $3, $4); $_$;


--
-- Name: FUNCTION st_asgeojson(gj_version integer, geom geometry, maxdecimaldigits integer, options integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_asgeojson(gj_version integer, geom geometry, maxdecimaldigits integer, options integer) IS 'args: gj_version, geom, maxdecimaldigits=15, options=0 - Return the geometry as a GeoJSON element.';


--
-- Name: st_asgml(geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgml(geography) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML(2, $1, 15, 0)$_$;


--
-- Name: st_asgml(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgml(geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML(2, $1, 15, 0)$_$;


--
-- Name: st_asgml(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgml(text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT _ST_AsGML(2,$1::geometry,15,0, NULL, NULL);  $_$;


--
-- Name: st_asgml(integer, geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgml(integer, geography) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML($1, $2, 15, 0)$_$;


--
-- Name: st_asgml(integer, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgml(integer, geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML($1, $2, 15, 0)$_$;


--
-- Name: st_asgml(geography, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgml(geography, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML(2, $1, $2, 0)$_$;


--
-- Name: st_asgml(geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgml(geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML(2, $1, $2, 0)$_$;


--
-- Name: st_asgml(geography, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgml(geog geography, maxdecimaldigits integer DEFAULT 15, options integer DEFAULT 0) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML(2, $1, $2, $3, null, null)$_$;


--
-- Name: st_asgml(geometry, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgml(geom geometry, maxdecimaldigits integer DEFAULT 15, options integer DEFAULT 0) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT _ST_AsGML(2, $1, $2, $3, null, null); $_$;


--
-- Name: st_asgml(integer, geography, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgml(integer, geography, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML($1, $2, $3, 0)$_$;


--
-- Name: st_asgml(integer, geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgml(integer, geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML($1, $2, $3, 0)$_$;


--
-- Name: st_asgml(integer, geography, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgml(integer, geography, integer, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML($1, $2, $3, $4)$_$;


--
-- Name: st_asgml(integer, geometry, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgml(integer, geometry, integer, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML($1, $2, $3, $4)$_$;


--
-- Name: st_asgml(integer, geography, integer, integer, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgml(version integer, geog geography, maxdecimaldigits integer DEFAULT 15, options integer DEFAULT 0, nprefix text DEFAULT NULL::text, id text DEFAULT NULL::text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $_$ SELECT _ST_AsGML($1, $2, $3, $4, $5, $6);$_$;


--
-- Name: FUNCTION st_asgml(version integer, geog geography, maxdecimaldigits integer, options integer, nprefix text, id text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_asgml(version integer, geog geography, maxdecimaldigits integer, options integer, nprefix text, id text) IS 'args: version, geog, maxdecimaldigits=15, options=0, nprefix=null, id=null - Return the geometry as a GML version 2 or 3 element.';


--
-- Name: st_asgml(integer, geometry, integer, integer, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgml(version integer, geom geometry, maxdecimaldigits integer DEFAULT 15, options integer DEFAULT 0, nprefix text DEFAULT NULL::text, id text DEFAULT NULL::text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $_$ SELECT _ST_AsGML($1, $2, $3, $4, $5, $6); $_$;


--
-- Name: FUNCTION st_asgml(version integer, geom geometry, maxdecimaldigits integer, options integer, nprefix text, id text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_asgml(version integer, geom geometry, maxdecimaldigits integer, options integer, nprefix text, id text) IS 'args: version, geom, maxdecimaldigits=15, options=0, nprefix=null, id=null - Return the geometry as a GML version 2 or 3 element.';


--
-- Name: st_ashexewkb(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_ashexewkb(geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_asHEXEWKB';


--
-- Name: FUNCTION st_ashexewkb(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_ashexewkb(geometry) IS 'args: g1 - Returns a Geometry in HEXEWKB format (as text) using either little-endian (NDR) or big-endian (XDR) encoding.';


--
-- Name: st_ashexewkb(geometry, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_ashexewkb(geometry, text) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_asHEXEWKB';


--
-- Name: FUNCTION st_ashexewkb(geometry, text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_ashexewkb(geometry, text) IS 'args: g1, NDRorXDR - Returns a Geometry in HEXEWKB format (as text) using either little-endian (NDR) or big-endian (XDR) encoding.';


--
-- Name: st_askml(geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_askml(geography) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML(2, $1, 15)$_$;


--
-- Name: st_askml(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_askml(geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML(2, ST_Transform($1,4326), 15)$_$;


--
-- Name: st_askml(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_askml(text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT _ST_AsKML(2, $1::geometry, 15, null);  $_$;


--
-- Name: st_askml(geography, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_askml(geog geography, maxdecimaldigits integer DEFAULT 15) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML(2, $1, $2, null)$_$;


--
-- Name: FUNCTION st_askml(geog geography, maxdecimaldigits integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_askml(geog geography, maxdecimaldigits integer) IS 'args: geog, maxdecimaldigits=15 - Return the geometry as a KML element. Several variants. Default version=2, default precision=15';


--
-- Name: st_askml(geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_askml(geom geometry, maxdecimaldigits integer DEFAULT 15) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT _ST_AsKML(2, ST_Transform($1,4326), $2, null); $_$;


--
-- Name: FUNCTION st_askml(geom geometry, maxdecimaldigits integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_askml(geom geometry, maxdecimaldigits integer) IS 'args: geom, maxdecimaldigits=15 - Return the geometry as a KML element. Several variants. Default version=2, default precision=15';


--
-- Name: st_askml(integer, geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_askml(integer, geography) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML($1, $2, 15)$_$;


--
-- Name: st_askml(integer, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_askml(integer, geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML($1, ST_Transform($2,4326), 15)$_$;


--
-- Name: st_askml(integer, geography, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_askml(integer, geography, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML($1, $2, $3)$_$;


--
-- Name: st_askml(integer, geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_askml(integer, geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML($1, ST_Transform($2,4326), $3)$_$;


--
-- Name: st_askml(integer, geography, integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_askml(version integer, geog geography, maxdecimaldigits integer DEFAULT 15, nprefix text DEFAULT NULL::text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT _ST_AsKML($1, $2, $3, $4)$_$;


--
-- Name: FUNCTION st_askml(version integer, geog geography, maxdecimaldigits integer, nprefix text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_askml(version integer, geog geography, maxdecimaldigits integer, nprefix text) IS 'args: version, geog, maxdecimaldigits=15, nprefix=NULL - Return the geometry as a KML element. Several variants. Default version=2, default precision=15';


--
-- Name: st_askml(integer, geometry, integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_askml(version integer, geom geometry, maxdecimaldigits integer DEFAULT 15, nprefix text DEFAULT NULL::text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $_$ SELECT _ST_AsKML($1, ST_Transform($2,4326), $3, $4); $_$;


--
-- Name: FUNCTION st_askml(version integer, geom geometry, maxdecimaldigits integer, nprefix text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_askml(version integer, geom geometry, maxdecimaldigits integer, nprefix text) IS 'args: version, geom, maxdecimaldigits=15, nprefix=NULL - Return the geometry as a KML element. Several variants. Default version=2, default precision=15';


--
-- Name: st_aslatlontext(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_aslatlontext(geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsLatLonText($1, '') $_$;


--
-- Name: FUNCTION st_aslatlontext(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_aslatlontext(geometry) IS 'args: pt - Return the Degrees, Minutes, Seconds representation of the given point.';


--
-- Name: st_aslatlontext(geometry, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_aslatlontext(geometry, text) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_to_latlon';


--
-- Name: FUNCTION st_aslatlontext(geometry, text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_aslatlontext(geometry, text) IS 'args: pt, format - Return the Degrees, Minutes, Seconds representation of the given point.';


--
-- Name: st_assvg(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_assvg(text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsSVG($1::geometry,0,15);  $_$;


--
-- Name: st_assvg(geography, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_assvg(geog geography, rel integer DEFAULT 0, maxdecimaldigits integer DEFAULT 15) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geography_as_svg';


--
-- Name: FUNCTION st_assvg(geog geography, rel integer, maxdecimaldigits integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_assvg(geog geography, rel integer, maxdecimaldigits integer) IS 'args: geog, rel=0, maxdecimaldigits=15 - Returns a Geometry in SVG path data given a geometry or geography object.';


--
-- Name: st_assvg(geometry, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_assvg(geom geometry, rel integer DEFAULT 0, maxdecimaldigits integer DEFAULT 15) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_asSVG';


--
-- Name: FUNCTION st_assvg(geom geometry, rel integer, maxdecimaldigits integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_assvg(geom geometry, rel integer, maxdecimaldigits integer) IS 'args: geom, rel=0, maxdecimaldigits=15 - Returns a Geometry in SVG path data given a geometry or geography object.';


--
-- Name: st_astext(geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_astext(geography) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_asText';


--
-- Name: FUNCTION st_astext(geography); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_astext(geography) IS 'args: g1 - Return the Well-Known Text (WKT) representation of the geometry/geography without SRID metadata.';


--
-- Name: st_astext(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_astext(geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_asText';


--
-- Name: FUNCTION st_astext(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_astext(geometry) IS 'args: g1 - Return the Well-Known Text (WKT) representation of the geometry/geography without SRID metadata.';


--
-- Name: st_astext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_astext(text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsText($1::geometry);  $_$;


--
-- Name: st_asx3d(geometry, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asx3d(geom geometry, maxdecimaldigits integer DEFAULT 15, options integer DEFAULT 0) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT _ST_AsX3D(3,$1,$2,$3,'');$_$;


--
-- Name: FUNCTION st_asx3d(geom geometry, maxdecimaldigits integer, options integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_asx3d(geom geometry, maxdecimaldigits integer, options integer) IS 'args: g1, maxdecimaldigits=15, options=0 - Returns a Geometry in X3D xml node element format: ISO-IEC-19776-1.2-X3DEncodings-XML';


--
-- Name: st_azimuth(geography, geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_azimuth(geog1 geography, geog2 geography) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'geography_azimuth';


--
-- Name: FUNCTION st_azimuth(geog1 geography, geog2 geography); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_azimuth(geog1 geography, geog2 geography) IS 'args: pointA, pointB - Returns the north-based azimuth as the angle in radians measured clockwise from the vertical on pointA to pointB.';


--
-- Name: st_azimuth(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_azimuth(geom1 geometry, geom2 geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_azimuth';


--
-- Name: FUNCTION st_azimuth(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_azimuth(geom1 geometry, geom2 geometry) IS 'args: pointA, pointB - Returns the north-based azimuth as the angle in radians measured clockwise from the vertical on pointA to pointB.';


--
-- Name: st_bdmpolyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_bdmpolyfromtext(text, integer) RETURNS geometry
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
  geomtext alias for $1;
  srid alias for $2;
  mline geometry;
  geom geometry;
BEGIN
  mline := ST_MultiLineStringFromText(geomtext, srid);

  IF mline IS NULL
  THEN
    RAISE EXCEPTION 'Input is not a MultiLinestring';
  END IF;

  geom := ST_Multi(ST_BuildArea(mline));

  RETURN geom;
END;
$_$;


--
-- Name: FUNCTION st_bdmpolyfromtext(text, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_bdmpolyfromtext(text, integer) IS 'args: WKT, srid - Construct a MultiPolygon given an arbitrary collection of closed linestrings as a MultiLineString text representation Well-Known text representation.';


--
-- Name: st_bdpolyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_bdpolyfromtext(text, integer) RETURNS geometry
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
  geomtext alias for $1;
  srid alias for $2;
  mline geometry;
  geom geometry;
BEGIN
  mline := ST_MultiLineStringFromText(geomtext, srid);

  IF mline IS NULL
  THEN
    RAISE EXCEPTION 'Input is not a MultiLinestring';
  END IF;

  geom := ST_BuildArea(mline);

  IF GeometryType(geom) != 'POLYGON'
  THEN
    RAISE EXCEPTION 'Input returns more then a single polygon, try using BdMPolyFromText instead';
  END IF;

  RETURN geom;
END;
$_$;


--
-- Name: FUNCTION st_bdpolyfromtext(text, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_bdpolyfromtext(text, integer) IS 'args: WKT, srid - Construct a Polygon given an arbitrary collection of closed linestrings as a MultiLineString Well-Known text representation.';


--
-- Name: st_boundary(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_boundary(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'boundary';


--
-- Name: FUNCTION st_boundary(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_boundary(geometry) IS 'args: geomA - Returns the closure of the combinatorial boundary of this Geometry.';


--
-- Name: st_box2dfromgeohash(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_box2dfromgeohash(text, integer DEFAULT NULL::integer) RETURNS box2d
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-2.1', 'box2d_from_geohash';


--
-- Name: FUNCTION st_box2dfromgeohash(text, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_box2dfromgeohash(text, integer) IS 'args: geohash, precision=full_precision_of_geohash - Return a BOX2D from a GeoHash string.';


--
-- Name: st_buffer(geography, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_buffer(geography, double precision) RETURNS geography
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT geography(ST_Transform(ST_Buffer(ST_Transform(geometry($1), _ST_BestSRID($1)), $2), 4326))$_$;


--
-- Name: FUNCTION st_buffer(geography, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_buffer(geography, double precision) IS 'args: g1, radius_of_buffer_in_meters - (T) For geometry: Returns a geometry that represents all points whose distance from this Geometry is less than or equal to distance. Calculations are in the Spatial Reference System of this Geometry. For geography: Uses a planar transform wrapper. Introduced in 1.5 support for different end cap and mitre settings to control shape. buffer_style options: quad_segs=#,endcap=round|flat|square,join=round|mitre|bevel,mitre_limit=#.#';


--
-- Name: st_buffer(geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_buffer(geometry, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'buffer';


--
-- Name: FUNCTION st_buffer(geometry, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_buffer(geometry, double precision) IS 'args: g1, radius_of_buffer - (T) For geometry: Returns a geometry that represents all points whose distance from this Geometry is less than or equal to distance. Calculations are in the Spatial Reference System of this Geometry. For geography: Uses a planar transform wrapper. Introduced in 1.5 support for different end cap and mitre settings to control shape. buffer_style options: quad_segs=#,endcap=round|flat|square,join=round|mitre|bevel,mitre_limit=#.#';


--
-- Name: st_buffer(text, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_buffer(text, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_Buffer($1::geometry, $2);  $_$;


--
-- Name: st_buffer(geometry, double precision, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_buffer(geometry, double precision, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT _ST_Buffer($1, $2,
    CAST('quad_segs='||CAST($3 AS text) as cstring))
     $_$;


--
-- Name: FUNCTION st_buffer(geometry, double precision, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_buffer(geometry, double precision, integer) IS 'args: g1, radius_of_buffer, num_seg_quarter_circle - (T) For geometry: Returns a geometry that represents all points whose distance from this Geometry is less than or equal to distance. Calculations are in the Spatial Reference System of this Geometry. For geography: Uses a planar transform wrapper. Introduced in 1.5 support for different end cap and mitre settings to control shape. buffer_style options: quad_segs=#,endcap=round|flat|square,join=round|mitre|bevel,mitre_limit=#.#';


--
-- Name: st_buffer(geometry, double precision, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_buffer(geometry, double precision, text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT _ST_Buffer($1, $2,
    CAST( regexp_replace($3, '^[0123456789]+$',
      'quad_segs='||$3) AS cstring)
    )
     $_$;


--
-- Name: FUNCTION st_buffer(geometry, double precision, text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_buffer(geometry, double precision, text) IS 'args: g1, radius_of_buffer, buffer_style_parameters - (T) For geometry: Returns a geometry that represents all points whose distance from this Geometry is less than or equal to distance. Calculations are in the Spatial Reference System of this Geometry. For geography: Uses a planar transform wrapper. Introduced in 1.5 support for different end cap and mitre settings to control shape. buffer_style options: quad_segs=#,endcap=round|flat|square,join=round|mitre|bevel,mitre_limit=#.#';


--
-- Name: st_buildarea(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_buildarea(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'ST_BuildArea';


--
-- Name: FUNCTION st_buildarea(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_buildarea(geometry) IS 'args: A - Creates an areal geometry formed by the constituent linework of given geometry';


--
-- Name: st_centroid(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_centroid(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'centroid';


--
-- Name: FUNCTION st_centroid(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_centroid(geometry) IS 'args: g1 - Returns the geometric center of a geometry.';


--
-- Name: st_cleangeometry(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_cleangeometry(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'ST_CleanGeometry';


--
-- Name: st_closestpoint(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_closestpoint(geom1 geometry, geom2 geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_closestpoint';


--
-- Name: FUNCTION st_closestpoint(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_closestpoint(geom1 geometry, geom2 geometry) IS 'args: g1, g2 - Returns the 2-dimensional point on g1 that is closest to g2. This is the first point of the shortest line.';


--
-- Name: st_collect(geometry[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_collect(geometry[]) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_collect_garray';


--
-- Name: FUNCTION st_collect(geometry[]); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_collect(geometry[]) IS 'args: g1_array - Return a specified ST_Geometry value from a collection of other geometries.';


--
-- Name: st_collect(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_collect(geom1 geometry, geom2 geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-2.1', 'LWGEOM_collect';


--
-- Name: FUNCTION st_collect(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_collect(geom1 geometry, geom2 geometry) IS 'args: g1, g2 - Return a specified ST_Geometry value from a collection of other geometries.';


--
-- Name: st_collectionextract(geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_collectionextract(geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'ST_CollectionExtract';


--
-- Name: FUNCTION st_collectionextract(geometry, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_collectionextract(geometry, integer) IS 'args: collection, type - Given a (multi)geometry, returns a (multi)geometry consisting only of elements of the specified type.';


--
-- Name: st_collectionhomogenize(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_collectionhomogenize(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'ST_CollectionHomogenize';


--
-- Name: FUNCTION st_collectionhomogenize(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_collectionhomogenize(geometry) IS 'args: collection - Given a geometry collection, returns the "simplest" representation of the contents.';


--
-- Name: st_combine_bbox(box2d, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_combine_bbox(box2d, geometry) RETURNS box2d
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-2.1', 'BOX2D_combine';


--
-- Name: st_combine_bbox(box3d, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_combine_bbox(box3d, geometry) RETURNS box3d
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-2.1', 'BOX3D_combine';


--
-- Name: st_concavehull(geometry, double precision, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_concavehull(param_geom geometry, param_pctconvex double precision, param_allow_holes boolean DEFAULT false) RETURNS geometry
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
  DECLARE
    var_convhull geometry := ST_ConvexHull(param_geom);
    var_param_geom geometry := param_geom;
    var_initarea float := ST_Area(var_convhull);
    var_newarea float := var_initarea;
    var_div integer := 6; 
    var_tempgeom geometry;
    var_tempgeom2 geometry;
    var_cent geometry;
    var_geoms geometry[4]; 
    var_enline geometry;
    var_resultgeom geometry;
    var_atempgeoms geometry[];
    var_buf float := 1; 
  BEGIN
    -- We start with convex hull as our base
    var_resultgeom := var_convhull;
    
    IF param_pctconvex = 1 THEN
      return var_resultgeom;
    ELSIF ST_GeometryType(var_param_geom) = 'ST_Polygon' THEN -- it is as concave as it is going to get
      IF param_allow_holes THEN -- leave the holes
        RETURN var_param_geom;
      ELSE -- remove the holes
        var_resultgeom := ST_MakePolygon(ST_ExteriorRing(var_param_geom));
        RETURN var_resultgeom;
      END IF;
    END IF;
    IF ST_Dimension(var_resultgeom) > 1 AND param_pctconvex BETWEEN 0 and 0.98 THEN
    -- get linestring that forms envelope of geometry
      var_enline := ST_Boundary(ST_Envelope(var_param_geom));
      var_buf := ST_Length(var_enline)/1000.0;
      IF ST_GeometryType(var_param_geom) = 'ST_MultiPoint' AND ST_NumGeometries(var_param_geom) BETWEEN 4 and 200 THEN
      -- we make polygons out of points since they are easier to cave in. 
      -- Note we limit to between 4 and 200 points because this process is slow and gets quadratically slow
        var_buf := sqrt(ST_Area(var_convhull)*0.8/(ST_NumGeometries(var_param_geom)*ST_NumGeometries(var_param_geom)));
        var_atempgeoms := ARRAY(SELECT geom FROM ST_DumpPoints(var_param_geom));
        -- 5 and 10 and just fudge factors
        var_tempgeom := ST_Union(ARRAY(SELECT geom
            FROM (
            -- fuse near neighbors together
            SELECT DISTINCT ON (i) i,  ST_Distance(var_atempgeoms[i],var_atempgeoms[j]), ST_Buffer(ST_MakeLine(var_atempgeoms[i], var_atempgeoms[j]) , var_buf*5, 'quad_segs=3') As geom
                FROM generate_series(1,array_upper(var_atempgeoms, 1)) As i
                  INNER JOIN generate_series(1,array_upper(var_atempgeoms, 1)) As j 
                    ON (
                 NOT ST_Intersects(var_atempgeoms[i],var_atempgeoms[j])
                  AND ST_DWithin(var_atempgeoms[i],var_atempgeoms[j], var_buf*10)
                  )
                UNION ALL
            -- catch the ones with no near neighbors
                SELECT i, 0, ST_Buffer(var_atempgeoms[i] , var_buf*10, 'quad_segs=3') As geom
                FROM generate_series(1,array_upper(var_atempgeoms, 1)) As i
                  LEFT JOIN generate_series(ceiling(array_upper(var_atempgeoms,1)/2)::integer,array_upper(var_atempgeoms, 1)) As j 
                    ON (
                 NOT ST_Intersects(var_atempgeoms[i],var_atempgeoms[j])
                  AND ST_DWithin(var_atempgeoms[i],var_atempgeoms[j], var_buf*10) 
                  )
                  WHERE j IS NULL
                ORDER BY 1, 2
              ) As foo  ) );
        IF ST_IsValid(var_tempgeom) AND ST_GeometryType(var_tempgeom) = 'ST_Polygon' THEN
          var_tempgeom := ST_ForceSFS(ST_Intersection(var_tempgeom, var_convhull));
          IF param_allow_holes THEN
            var_param_geom := var_tempgeom;
          ELSE
            var_param_geom := ST_MakePolygon(ST_ExteriorRing(var_tempgeom));
          END IF;
          return var_param_geom;
        ELSIF ST_IsValid(var_tempgeom) THEN
          var_param_geom := ST_ForceSFS(ST_Intersection(var_tempgeom, var_convhull)); 
        END IF;
      END IF;

      IF ST_GeometryType(var_param_geom) = 'ST_Polygon' THEN
        IF NOT param_allow_holes THEN
          var_param_geom := ST_MakePolygon(ST_ExteriorRing(var_param_geom));
        END IF;
        return var_param_geom;
      END IF;
            var_cent := ST_Centroid(var_param_geom);
            IF (ST_XMax(var_enline) - ST_XMin(var_enline) ) > var_buf AND (ST_YMax(var_enline) - ST_YMin(var_enline) ) > var_buf THEN
                    IF ST_Dwithin(ST_Centroid(var_convhull) , ST_Centroid(ST_Envelope(var_param_geom)), var_buf/2) THEN
                -- If the geometric dimension is > 1 and the object is symettric (cutting at centroid will not work -- offset a bit)
                        var_cent := ST_Translate(var_cent, (ST_XMax(var_enline) - ST_XMin(var_enline))/1000,  (ST_YMAX(var_enline) - ST_YMin(var_enline))/1000);
                    ELSE
                        -- uses closest point on geometry to centroid. I can't explain why we are doing this
                        var_cent := ST_ClosestPoint(var_param_geom,var_cent);
                    END IF;
                    IF ST_DWithin(var_cent, var_enline,var_buf) THEN
                        var_cent := ST_centroid(ST_Envelope(var_param_geom));
                    END IF;
                    -- break envelope into 4 triangles about the centroid of the geometry and returned the clipped geometry in each quadrant
                    FOR i in 1 .. 4 LOOP
                       var_geoms[i] := ST_MakePolygon(ST_MakeLine(ARRAY[ST_PointN(var_enline,i), ST_PointN(var_enline,i+1), var_cent, ST_PointN(var_enline,i)]));
                       var_geoms[i] := ST_ForceSFS(ST_Intersection(var_param_geom, ST_Buffer(var_geoms[i],var_buf)));
                       IF ST_IsValid(var_geoms[i]) THEN 
                            
                       ELSE
                            var_geoms[i] := ST_BuildArea(ST_MakeLine(ARRAY[ST_PointN(var_enline,i), ST_PointN(var_enline,i+1), var_cent, ST_PointN(var_enline,i)]));
                       END IF; 
                    END LOOP;
                    var_tempgeom := ST_Union(ARRAY[ST_ConvexHull(var_geoms[1]), ST_ConvexHull(var_geoms[2]) , ST_ConvexHull(var_geoms[3]), ST_ConvexHull(var_geoms[4])]); 
                    --RAISE NOTICE 'Curr vex % ', ST_AsText(var_tempgeom);
                    IF ST_Area(var_tempgeom) <= var_newarea AND ST_IsValid(var_tempgeom)  THEN --AND ST_GeometryType(var_tempgeom) ILIKE '%Polygon'
                        
                        var_tempgeom := ST_Buffer(ST_ConcaveHull(var_geoms[1],least(param_pctconvex + param_pctconvex/var_div),true),var_buf, 'quad_segs=2');
                        FOR i IN 1 .. 4 LOOP
                            var_geoms[i] := ST_Buffer(ST_ConcaveHull(var_geoms[i],least(param_pctconvex + param_pctconvex/var_div),true), var_buf, 'quad_segs=2');
                            IF ST_IsValid(var_geoms[i]) Then
                                var_tempgeom := ST_Union(var_tempgeom, var_geoms[i]);
                            ELSE
                                RAISE NOTICE 'Not valid % %', i, ST_AsText(var_tempgeom);
                                var_tempgeom := ST_Union(var_tempgeom, ST_ConvexHull(var_geoms[i]));
                            END IF; 
                        END LOOP;

                        --RAISE NOTICE 'Curr concave % ', ST_AsText(var_tempgeom);
                        IF ST_IsValid(var_tempgeom) THEN
                            var_resultgeom := var_tempgeom;
                        END IF;
                        var_newarea := ST_Area(var_resultgeom);
                    ELSIF ST_IsValid(var_tempgeom) THEN
                        var_resultgeom := var_tempgeom;
                    END IF;

                    IF ST_NumGeometries(var_resultgeom) > 1  THEN
                        var_tempgeom := _ST_ConcaveHull(var_resultgeom);
                        IF ST_IsValid(var_tempgeom) AND ST_GeometryType(var_tempgeom) ILIKE 'ST_Polygon' THEN
                            var_resultgeom := var_tempgeom;
                        ELSE
                            var_resultgeom := ST_Buffer(var_tempgeom,var_buf, 'quad_segs=2');
                        END IF;
                    END IF;
                    IF param_allow_holes = false THEN 
                    -- only keep exterior ring since we do not want holes
                        var_resultgeom := ST_MakePolygon(ST_ExteriorRing(var_resultgeom));
                    END IF;
                ELSE
                    var_resultgeom := ST_Buffer(var_resultgeom,var_buf);
                END IF;
                var_resultgeom := ST_ForceSFS(ST_Intersection(var_resultgeom, ST_ConvexHull(var_param_geom)));
            ELSE
                -- dimensions are too small to cut
                var_resultgeom := _ST_ConcaveHull(var_param_geom);
            END IF;
            RETURN var_resultgeom;
  END;
$$;


--
-- Name: FUNCTION st_concavehull(param_geom geometry, param_pctconvex double precision, param_allow_holes boolean); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_concavehull(param_geom geometry, param_pctconvex double precision, param_allow_holes boolean) IS 'args: geomA, target_percent, allow_holes=false - The concave hull of a geometry represents a possibly concave geometry that encloses all geometries within the set. You can think of it as shrink wrapping.';


--
-- Name: st_contains(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_contains(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && $2 AND _ST_Contains($1,$2)$_$;


--
-- Name: FUNCTION st_contains(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_contains(geom1 geometry, geom2 geometry) IS 'args: geomA, geomB - Returns true if and only if no points of B lie in the exterior of A, and at least one point of the interior of B lies in the interior of A.';


--
-- Name: st_containsproperly(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_containsproperly(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && $2 AND _ST_ContainsProperly($1,$2)$_$;


--
-- Name: FUNCTION st_containsproperly(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_containsproperly(geom1 geometry, geom2 geometry) IS 'args: geomA, geomB - Returns true if B intersects the interior of A but not the boundary (or exterior). A does not contain properly itself, but does contain itself.';


--
-- Name: st_convexhull(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_convexhull(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'convexhull';


--
-- Name: FUNCTION st_convexhull(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_convexhull(geometry) IS 'args: geomA - The convex hull of a geometry represents the minimum convex geometry that encloses all geometries within the set.';


--
-- Name: st_coorddim(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_coorddim(geometry geometry) RETURNS smallint
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_ndims';


--
-- Name: FUNCTION st_coorddim(geometry geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_coorddim(geometry geometry) IS 'args: geomA - Return the coordinate dimension of the ST_Geometry value.';


--
-- Name: st_coveredby(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_coveredby(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && $2 AND _ST_CoveredBy($1,$2)$_$;


--
-- Name: FUNCTION st_coveredby(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_coveredby(geom1 geometry, geom2 geometry) IS 'args: geomA, geomB - Returns 1 (TRUE) if no point in Geometry/Geography A is outside Geometry/Geography B';


--
-- Name: st_coveredby(geography, geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_coveredby(geography, geography) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && $2 AND _ST_Covers($2, $1)$_$;


--
-- Name: FUNCTION st_coveredby(geography, geography); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_coveredby(geography, geography) IS 'args: geogA, geogB - Returns 1 (TRUE) if no point in Geometry/Geography A is outside Geometry/Geography B';


--
-- Name: st_coveredby(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_coveredby(text, text) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$ SELECT ST_CoveredBy($1::geometry, $2::geometry);  $_$;


--
-- Name: st_covers(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_covers(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && $2 AND _ST_Covers($1,$2)$_$;


--
-- Name: FUNCTION st_covers(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_covers(geom1 geometry, geom2 geometry) IS 'args: geomA, geomB - Returns 1 (TRUE) if no point in Geometry B is outside Geometry A';


--
-- Name: st_covers(geography, geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_covers(geography, geography) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && $2 AND _ST_Covers($1, $2)$_$;


--
-- Name: FUNCTION st_covers(geography, geography); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_covers(geography, geography) IS 'args: geogpolyA, geogpointB - Returns 1 (TRUE) if no point in Geometry B is outside Geometry A';


--
-- Name: st_covers(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_covers(text, text) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$ SELECT ST_Covers($1::geometry, $2::geometry);  $_$;


--
-- Name: st_crosses(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_crosses(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && $2 AND _ST_Crosses($1,$2)$_$;


--
-- Name: FUNCTION st_crosses(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_crosses(geom1 geometry, geom2 geometry) IS 'args: g1, g2 - Returns TRUE if the supplied geometries have some, but not all, interior points in common.';


--
-- Name: st_curvetoline(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_curvetoline(geometry) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_CurveToLine($1, 32)$_$;


--
-- Name: FUNCTION st_curvetoline(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_curvetoline(geometry) IS 'args: curveGeom - Converts a CIRCULARSTRING/CURVEDPOLYGON to a LINESTRING/POLYGON';


--
-- Name: st_curvetoline(geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_curvetoline(geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_curve_segmentize';


--
-- Name: FUNCTION st_curvetoline(geometry, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_curvetoline(geometry, integer) IS 'args: curveGeom, segments_per_qtr_circle - Converts a CIRCULARSTRING/CURVEDPOLYGON to a LINESTRING/POLYGON';


--
-- Name: st_delaunaytriangles(geometry, double precision, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_delaunaytriangles(g1 geometry, tolerance double precision DEFAULT 0.0, flags integer DEFAULT 0) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'ST_DelaunayTriangles';


--
-- Name: FUNCTION st_delaunaytriangles(g1 geometry, tolerance double precision, flags integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_delaunaytriangles(g1 geometry, tolerance double precision, flags integer) IS 'args: g1, tolerance, flags - Return a Delaunay triangulation around the given input points.';


--
-- Name: st_dfullywithin(geometry, geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_dfullywithin(geom1 geometry, geom2 geometry, double precision) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && ST_Expand($2,$3) AND $2 && ST_Expand($1,$3) AND _ST_DFullyWithin(ST_ConvexHull($1), ST_ConvexHull($2), $3)$_$;


--
-- Name: FUNCTION st_dfullywithin(geom1 geometry, geom2 geometry, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_dfullywithin(geom1 geometry, geom2 geometry, double precision) IS 'args: g1, g2, distance - Returns true if all of the geometries are within the specified distance of one another';


--
-- Name: st_difference(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_difference(geom1 geometry, geom2 geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'difference';


--
-- Name: FUNCTION st_difference(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_difference(geom1 geometry, geom2 geometry) IS 'args: geomA, geomB - Returns a geometry that represents that part of geometry A that does not intersect with geometry B.';


--
-- Name: st_dimension(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_dimension(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_dimension';


--
-- Name: FUNCTION st_dimension(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_dimension(geometry) IS 'args: g - The inherent dimension of this Geometry object, which must be less than or equal to the coordinate dimension.';


--
-- Name: st_disjoint(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_disjoint(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'disjoint';


--
-- Name: FUNCTION st_disjoint(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_disjoint(geom1 geometry, geom2 geometry) IS 'args: A, B - Returns TRUE if the Geometries do not "spatially intersect" - if they do not share any space together.';


--
-- Name: st_distance(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_distance(geom1 geometry, geom2 geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'distance';


--
-- Name: FUNCTION st_distance(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_distance(geom1 geometry, geom2 geometry) IS 'args: g1, g2 - For geometry type Returns the 2-dimensional cartesian minimum distance (based on spatial ref) between two geometries in projected units. For geography type defaults to return spheroidal minimum distance between two geographies in meters.';


--
-- Name: st_distance(geography, geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_distance(geography, geography) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_Distance($1, $2, 0.0, true)$_$;


--
-- Name: FUNCTION st_distance(geography, geography); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_distance(geography, geography) IS 'args: gg1, gg2 - For geometry type Returns the 2-dimensional cartesian minimum distance (based on spatial ref) between two geometries in projected units. For geography type defaults to return spheroidal minimum distance between two geographies in meters.';


--
-- Name: st_distance(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_distance(text, text) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_Distance($1::geometry, $2::geometry);  $_$;


--
-- Name: st_distance(geography, geography, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_distance(geography, geography, boolean) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_Distance($1, $2, 0.0, $3)$_$;


--
-- Name: FUNCTION st_distance(geography, geography, boolean); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_distance(geography, geography, boolean) IS 'args: gg1, gg2, use_spheroid - For geometry type Returns the 2-dimensional cartesian minimum distance (based on spatial ref) between two geometries in projected units. For geography type defaults to return spheroidal minimum distance between two geographies in meters.';


--
-- Name: st_distance_sphere(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_distance_sphere(geom1 geometry, geom2 geometry) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT COST 300
    AS $_$
  select st_distance(geography($1),geography($2),false)
  $_$;


--
-- Name: FUNCTION st_distance_sphere(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_distance_sphere(geom1 geometry, geom2 geometry) IS 'args: geomlonlatA, geomlonlatB - Returns minimum distance in meters between two lon/lat geometries. Uses a spherical earth and radius of 6370986 meters. Faster than ST_Distance_Spheroid , but less accurate. PostGIS versions prior to 1.5 only implemented for points.';


--
-- Name: st_distance_spheroid(geometry, geometry, spheroid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_distance_spheroid(geom1 geometry, geom2 geometry, spheroid) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'LWGEOM_distance_ellipsoid';


--
-- Name: FUNCTION st_distance_spheroid(geom1 geometry, geom2 geometry, spheroid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_distance_spheroid(geom1 geometry, geom2 geometry, spheroid) IS 'args: geomlonlatA, geomlonlatB, measurement_spheroid - Returns the minimum distance between two lon/lat geometries given a particular spheroid. PostGIS versions prior to 1.5 only support points.';


--
-- Name: st_dump(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_dump(geometry) RETURNS SETOF geometry_dump
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_dump';


--
-- Name: FUNCTION st_dump(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_dump(geometry) IS 'args: g1 - Returns a set of geometry_dump (geom,path) rows, that make up a geometry g1.';


--
-- Name: st_dumppoints(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_dumppoints(geometry) RETURNS SETOF geometry_dump
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_dumppoints';


--
-- Name: FUNCTION st_dumppoints(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_dumppoints(geometry) IS 'args: geom - Returns a set of geometry_dump (geom,path) rows of all points that make up a geometry.';


--
-- Name: st_dumprings(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_dumprings(geometry) RETURNS SETOF geometry_dump
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_dump_rings';


--
-- Name: FUNCTION st_dumprings(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_dumprings(geometry) IS 'args: a_polygon - Returns a set of geometry_dump rows, representing the exterior and interior rings of a polygon.';


--
-- Name: st_dwithin(geometry, geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_dwithin(geom1 geometry, geom2 geometry, double precision) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && ST_Expand($2,$3) AND $2 && ST_Expand($1,$3) AND _ST_DWithin($1, $2, $3)$_$;


--
-- Name: FUNCTION st_dwithin(geom1 geometry, geom2 geometry, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_dwithin(geom1 geometry, geom2 geometry, double precision) IS 'args: g1, g2, distance_of_srid - Returns true if the geometries are within the specified distance of one another. For geometry units are in those of spatial reference and For geography units are in meters and measurement is defaulted to use_spheroid=true (measure around spheroid), for faster check, use_spheroid=false to measure along sphere.';


--
-- Name: st_dwithin(geography, geography, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_dwithin(geography, geography, double precision) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && _ST_Expand($2,$3) AND $2 && _ST_Expand($1,$3) AND _ST_DWithin($1, $2, $3, true)$_$;


--
-- Name: FUNCTION st_dwithin(geography, geography, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_dwithin(geography, geography, double precision) IS 'args: gg1, gg2, distance_meters - Returns true if the geometries are within the specified distance of one another. For geometry units are in those of spatial reference and For geography units are in meters and measurement is defaulted to use_spheroid=true (measure around spheroid), for faster check, use_spheroid=false to measure along sphere.';


--
-- Name: st_dwithin(text, text, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_dwithin(text, text, double precision) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$ SELECT ST_DWithin($1::geometry, $2::geometry, $3);  $_$;


--
-- Name: st_dwithin(geography, geography, double precision, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_dwithin(geography, geography, double precision, boolean) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && _ST_Expand($2,$3) AND $2 && _ST_Expand($1,$3) AND _ST_DWithin($1, $2, $3, $4)$_$;


--
-- Name: FUNCTION st_dwithin(geography, geography, double precision, boolean); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_dwithin(geography, geography, double precision, boolean) IS 'args: gg1, gg2, distance_meters, use_spheroid - Returns true if the geometries are within the specified distance of one another. For geometry units are in those of spatial reference and For geography units are in meters and measurement is defaulted to use_spheroid=true (measure around spheroid), for faster check, use_spheroid=false to measure along sphere.';


--
-- Name: st_endpoint(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_endpoint(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_endpoint_linestring';


--
-- Name: FUNCTION st_endpoint(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_endpoint(geometry) IS 'args: g - Returns the last point of a LINESTRING geometry as a POINT.';


--
-- Name: st_envelope(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_envelope(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_envelope';


--
-- Name: FUNCTION st_envelope(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_envelope(geometry) IS 'args: g1 - Returns a geometry representing the double precision (float8) bounding box of the supplied geometry.';


--
-- Name: st_equals(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_equals(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 ~= $2 AND _ST_Equals($1,$2)$_$;


--
-- Name: FUNCTION st_equals(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_equals(geom1 geometry, geom2 geometry) IS 'args: A, B - Returns true if the given geometries represent the same geometry. Directionality is ignored.';


--
-- Name: st_estimated_extent(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_estimated_extent(text, text) RETURNS box2d
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT _postgis_deprecate('ST_Estimated_Extent', 'ST_EstimatedExtent', '2.1.0');
    -- We use security invoker instead of security definer 
    -- to prevent malicious injection of a same named different function
    -- that would be run under elevated permissions
    SELECT ST_EstimatedExtent($1, $2);
  $_$;


--
-- Name: st_estimated_extent(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_estimated_extent(text, text, text) RETURNS box2d
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT _postgis_deprecate('ST_Estimated_Extent', 'ST_EstimatedExtent', '2.1.0');
    -- We use security invoker instead of security definer 
    -- to prevent malicious injection of a different same named function
    SELECT ST_EstimatedExtent($1, $2, $3);
  $_$;


--
-- Name: st_estimatedextent(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_estimatedextent(text, text) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT SECURITY DEFINER
    AS '$libdir/postgis-2.1', 'gserialized_estimated_extent';


--
-- Name: FUNCTION st_estimatedextent(text, text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_estimatedextent(text, text) IS 'args: table_name, geocolumn_name - Return the estimated extent of the given spatial table. The estimated is taken from the geometry columns statistics. The current schema will be used if not specified.';


--
-- Name: st_estimatedextent(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_estimatedextent(text, text, text) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT SECURITY DEFINER
    AS '$libdir/postgis-2.1', 'gserialized_estimated_extent';


--
-- Name: FUNCTION st_estimatedextent(text, text, text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_estimatedextent(text, text, text) IS 'args: schema_name, table_name, geocolumn_name - Return the estimated extent of the given spatial table. The estimated is taken from the geometry columns statistics. The current schema will be used if not specified.';


--
-- Name: st_expand(box2d, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_expand(box2d, double precision) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'BOX2D_expand';


--
-- Name: FUNCTION st_expand(box2d, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_expand(box2d, double precision) IS 'args: g1, units_to_expand - Returns bounding box expanded in all directions from the bounding box of the input geometry. Uses double-precision';


--
-- Name: st_expand(box3d, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_expand(box3d, double precision) RETURNS box3d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'BOX3D_expand';


--
-- Name: FUNCTION st_expand(box3d, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_expand(box3d, double precision) IS 'args: g1, units_to_expand - Returns bounding box expanded in all directions from the bounding box of the input geometry. Uses double-precision';


--
-- Name: st_expand(geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_expand(geometry, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_expand';


--
-- Name: FUNCTION st_expand(geometry, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_expand(geometry, double precision) IS 'args: g1, units_to_expand - Returns bounding box expanded in all directions from the bounding box of the input geometry. Uses double-precision';


--
-- Name: st_exteriorring(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_exteriorring(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_exteriorring_polygon';


--
-- Name: FUNCTION st_exteriorring(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_exteriorring(geometry) IS 'args: a_polygon - Returns a line string representing the exterior ring of the POLYGON geometry. Return NULL if the geometry is not a polygon. Will not work with MULTIPOLYGON';


--
-- Name: st_find_extent(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_find_extent(text, text) RETURNS box2d
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
  tablename alias for $1;
  columnname alias for $2;
  myrec RECORD;

BEGIN
  FOR myrec IN EXECUTE 'SELECT ST_Extent("' || columnname || '") As extent FROM "' || tablename || '"' LOOP
    return myrec.extent;
  END LOOP;
END;
$_$;


--
-- Name: st_find_extent(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_find_extent(text, text, text) RETURNS box2d
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
  schemaname alias for $1;
  tablename alias for $2;
  columnname alias for $3;
  myrec RECORD;

BEGIN
  FOR myrec IN EXECUTE 'SELECT ST_Extent("' || columnname || '") As extent FROM "' || schemaname || '"."' || tablename || '"' LOOP
    return myrec.extent;
  END LOOP;
END;
$_$;


--
-- Name: st_flipcoordinates(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_flipcoordinates(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'ST_FlipCoordinates';


--
-- Name: FUNCTION st_flipcoordinates(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_flipcoordinates(geometry) IS 'args: geom - Returns a version of the given geometry with X and Y axis flipped. Useful for people who have built latitude/longitude features and need to fix them.';


--
-- Name: st_force2d(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_force2d(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_force_2d';


--
-- Name: FUNCTION st_force2d(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_force2d(geometry) IS 'args: geomA - Forces the geometries into a "2-dimensional mode" so that all output representations will only have the X and Y coordinates.';


--
-- Name: st_force3d(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_force3d(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_force_3dz';


--
-- Name: FUNCTION st_force3d(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_force3d(geometry) IS 'args: geomA - Forces the geometries into XYZ mode. This is an alias for ST_Force3DZ.';


--
-- Name: st_force3dm(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_force3dm(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_force_3dm';


--
-- Name: FUNCTION st_force3dm(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_force3dm(geometry) IS 'args: geomA - Forces the geometries into XYM mode.';


--
-- Name: st_force3dz(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_force3dz(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_force_3dz';


--
-- Name: FUNCTION st_force3dz(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_force3dz(geometry) IS 'args: geomA - Forces the geometries into XYZ mode. This is a synonym for ST_Force3D.';


--
-- Name: st_force4d(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_force4d(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_force_4d';


--
-- Name: FUNCTION st_force4d(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_force4d(geometry) IS 'args: geomA - Forces the geometries into XYZM mode.';


--
-- Name: st_force_2d(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_force_2d(geometry) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT _postgis_deprecate('ST_Force_2d', 'ST_Force2D', '2.1.0');
    SELECT ST_Force2D($1);
  $_$;


--
-- Name: st_force_3d(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_force_3d(geometry) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT _postgis_deprecate('ST_Force_3d', 'ST_Force3D', '2.1.0');
    SELECT ST_Force3D($1);
  $_$;


--
-- Name: st_force_3dm(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_force_3dm(geometry) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT _postgis_deprecate('ST_Force_3dm', 'ST_Force3DM', '2.1.0');
    SELECT ST_Force3DM($1);
  $_$;


--
-- Name: st_force_3dz(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_force_3dz(geometry) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT _postgis_deprecate('ST_Force_3dz', 'ST_Force3DZ', '2.1.0');
    SELECT ST_Force3DZ($1);
  $_$;


--
-- Name: st_force_4d(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_force_4d(geometry) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT _postgis_deprecate('ST_Force_4d', 'ST_Force4D', '2.1.0');
    SELECT ST_Force4D($1);
  $_$;


--
-- Name: st_force_collection(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_force_collection(geometry) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT _postgis_deprecate('ST_Force_Collection', 'ST_ForceCollection', '2.1.0');
    SELECT ST_ForceCollection($1);
  $_$;


--
-- Name: st_forcecollection(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_forcecollection(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_force_collection';


--
-- Name: FUNCTION st_forcecollection(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_forcecollection(geometry) IS 'args: geomA - Converts the geometry into a GEOMETRYCOLLECTION.';


--
-- Name: st_forcerhr(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_forcerhr(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_force_clockwise_poly';


--
-- Name: FUNCTION st_forcerhr(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_forcerhr(geometry) IS 'args: g - Forces the orientation of the vertices in a polygon to follow the Right-Hand-Rule.';


--
-- Name: st_forcesfs(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_forcesfs(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_force_sfs';


--
-- Name: FUNCTION st_forcesfs(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_forcesfs(geometry) IS 'args: geomA - Forces the geometries to use SFS 1.1 geometry types only.';


--
-- Name: st_forcesfs(geometry, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_forcesfs(geometry, version text) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_force_sfs';


--
-- Name: FUNCTION st_forcesfs(geometry, version text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_forcesfs(geometry, version text) IS 'args: geomA, version - Forces the geometries to use SFS 1.1 geometry types only.';


--
-- Name: st_geogfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_geogfromtext(text) RETURNS geography
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geography_from_text';


--
-- Name: FUNCTION st_geogfromtext(text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_geogfromtext(text) IS 'args: EWKT - Return a specified geography value from Well-Known Text representation or extended (WKT).';


--
-- Name: st_geogfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_geogfromwkb(bytea) RETURNS geography
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geography_from_binary';


--
-- Name: FUNCTION st_geogfromwkb(bytea); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_geogfromwkb(bytea) IS 'args: geom - Creates a geography instance from a Well-Known Binary geometry representation (WKB) or extended Well Known Binary (EWKB).';


--
-- Name: st_geographyfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_geographyfromtext(text) RETURNS geography
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geography_from_text';


--
-- Name: FUNCTION st_geographyfromtext(text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_geographyfromtext(text) IS 'args: EWKT - Return a specified geography value from Well-Known Text representation or extended (WKT).';


--
-- Name: st_geohash(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_geohash(geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_GeoHash($1, 0)$_$;


--
-- Name: st_geohash(geography, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_geohash(geog geography, maxchars integer DEFAULT 0) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'ST_GeoHash';


--
-- Name: st_geohash(geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_geohash(geom geometry, maxchars integer DEFAULT 0) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'ST_GeoHash';


--
-- Name: FUNCTION st_geohash(geom geometry, maxchars integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_geohash(geom geometry, maxchars integer) IS 'args: geom, maxchars=full_precision_of_point - Return a GeoHash representation of the geometry.';


--
-- Name: st_geomcollfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_geomcollfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE
  WHEN geometrytype(ST_GeomFromText($1)) = 'GEOMETRYCOLLECTION'
  THEN ST_GeomFromText($1)
  ELSE NULL END
  $_$;


--
-- Name: FUNCTION st_geomcollfromtext(text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_geomcollfromtext(text) IS 'args: WKT - Makes a collection Geometry from collection WKT with the given SRID. If SRID is not give, it defaults to 0.';


--
-- Name: st_geomcollfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_geomcollfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE
  WHEN geometrytype(ST_GeomFromText($1, $2)) = 'GEOMETRYCOLLECTION'
  THEN ST_GeomFromText($1,$2)
  ELSE NULL END
  $_$;


--
-- Name: FUNCTION st_geomcollfromtext(text, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_geomcollfromtext(text, integer) IS 'args: WKT, srid - Makes a collection Geometry from collection WKT with the given SRID. If SRID is not give, it defaults to 0.';


--
-- Name: st_geomcollfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_geomcollfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE
  WHEN geometrytype(ST_GeomFromWKB($1)) = 'GEOMETRYCOLLECTION'
  THEN ST_GeomFromWKB($1)
  ELSE NULL END
  $_$;


--
-- Name: st_geomcollfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_geomcollfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE
  WHEN geometrytype(ST_GeomFromWKB($1, $2)) = 'GEOMETRYCOLLECTION'
  THEN ST_GeomFromWKB($1, $2)
  ELSE NULL END
  $_$;


--
-- Name: st_geometryfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_geometryfromtext(text) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_from_text';


--
-- Name: FUNCTION st_geometryfromtext(text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_geometryfromtext(text) IS 'args: WKT - Return a specified ST_Geometry value from Well-Known Text representation (WKT). This is an alias name for ST_GeomFromText';


--
-- Name: st_geometryfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_geometryfromtext(text, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_from_text';


--
-- Name: FUNCTION st_geometryfromtext(text, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_geometryfromtext(text, integer) IS 'args: WKT, srid - Return a specified ST_Geometry value from Well-Known Text representation (WKT). This is an alias name for ST_GeomFromText';


--
-- Name: st_geometryn(geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_geometryn(geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_geometryn_collection';


--
-- Name: FUNCTION st_geometryn(geometry, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_geometryn(geometry, integer) IS 'args: geomA, n - Return the 1-based Nth geometry if the geometry is a GEOMETRYCOLLECTION, (MULTI)POINT, (MULTI)LINESTRING, MULTICURVE or (MULTI)POLYGON, POLYHEDRALSURFACE Otherwise, return NULL.';


--
-- Name: st_geometrytype(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_geometrytype(geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geometry_geometrytype';


--
-- Name: FUNCTION st_geometrytype(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_geometrytype(geometry) IS 'args: g1 - Return the geometry type of the ST_Geometry value.';


--
-- Name: st_geomfromewkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_geomfromewkb(bytea) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOMFromWKB';


--
-- Name: FUNCTION st_geomfromewkb(bytea); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_geomfromewkb(bytea) IS 'args: EWKB - Return a specified ST_Geometry value from Extended Well-Known Binary representation (EWKB).';


--
-- Name: st_geomfromewkt(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_geomfromewkt(text) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'parse_WKT_lwgeom';


--
-- Name: FUNCTION st_geomfromewkt(text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_geomfromewkt(text) IS 'args: EWKT - Return a specified ST_Geometry value from Extended Well-Known Text representation (EWKT).';


--
-- Name: st_geomfromgeohash(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_geomfromgeohash(text, integer DEFAULT NULL::integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE
    AS $_$ SELECT CAST(ST_Box2dFromGeoHash($1, $2) AS geometry); $_$;


--
-- Name: FUNCTION st_geomfromgeohash(text, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_geomfromgeohash(text, integer) IS 'args: geohash, precision=full_precision_of_geohash - Return a geometry from a GeoHash string.';


--
-- Name: st_geomfromgeojson(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_geomfromgeojson(text) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geom_from_geojson';


--
-- Name: FUNCTION st_geomfromgeojson(text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_geomfromgeojson(text) IS 'args: geomjson - Takes as input a geojson representation of a geometry and outputs a PostGIS geometry object';


--
-- Name: st_geomfromgml(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_geomfromgml(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_GeomFromGML($1, 0)$_$;


--
-- Name: FUNCTION st_geomfromgml(text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_geomfromgml(text) IS 'args: geomgml - Takes as input GML representation of geometry and outputs a PostGIS geometry object';


--
-- Name: st_geomfromgml(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_geomfromgml(text, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geom_from_gml';


--
-- Name: FUNCTION st_geomfromgml(text, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_geomfromgml(text, integer) IS 'args: geomgml, srid - Takes as input GML representation of geometry and outputs a PostGIS geometry object';


--
-- Name: st_geomfromkml(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_geomfromkml(text) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geom_from_kml';


--
-- Name: FUNCTION st_geomfromkml(text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_geomfromkml(text) IS 'args: geomkml - Takes as input KML representation of geometry and outputs a PostGIS geometry object';


--
-- Name: st_geomfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_geomfromtext(text) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_from_text';


--
-- Name: FUNCTION st_geomfromtext(text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_geomfromtext(text) IS 'args: WKT - Return a specified ST_Geometry value from Well-Known Text representation (WKT).';


--
-- Name: st_geomfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_geomfromtext(text, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_from_text';


--
-- Name: FUNCTION st_geomfromtext(text, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_geomfromtext(text, integer) IS 'args: WKT, srid - Return a specified ST_Geometry value from Well-Known Text representation (WKT).';


--
-- Name: st_geomfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_geomfromwkb(bytea) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_from_WKB';


--
-- Name: FUNCTION st_geomfromwkb(bytea); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_geomfromwkb(bytea) IS 'args: geom - Makes a geometry from WKB with the given SRID';


--
-- Name: st_geomfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_geomfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_SetSRID(ST_GeomFromWKB($1), $2)$_$;


--
-- Name: FUNCTION st_geomfromwkb(bytea, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_geomfromwkb(bytea, integer) IS 'args: geom, srid - Makes a geometry from WKB with the given SRID';


--
-- Name: st_gmltosql(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_gmltosql(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_GeomFromGML($1, 0)$_$;


--
-- Name: FUNCTION st_gmltosql(text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_gmltosql(text) IS 'args: geomgml - Return a specified ST_Geometry value from GML representation. This is an alias name for ST_GeomFromGML';


--
-- Name: st_gmltosql(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_gmltosql(text, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geom_from_gml';


--
-- Name: FUNCTION st_gmltosql(text, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_gmltosql(text, integer) IS 'args: geomgml, srid - Return a specified ST_Geometry value from GML representation. This is an alias name for ST_GeomFromGML';


--
-- Name: st_hasarc(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_hasarc(geometry geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_has_arc';


--
-- Name: FUNCTION st_hasarc(geometry geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_hasarc(geometry geometry) IS 'args: geomA - Returns true if a geometry or geometry collection contains a circular string';


--
-- Name: st_hausdorffdistance(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_hausdorffdistance(geom1 geometry, geom2 geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'hausdorffdistance';


--
-- Name: FUNCTION st_hausdorffdistance(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_hausdorffdistance(geom1 geometry, geom2 geometry) IS 'args: g1, g2 - Returns the Hausdorff distance between two geometries. Basically a measure of how similar or dissimilar 2 geometries are. Units are in the units of the spatial reference system of the geometries.';


--
-- Name: st_hausdorffdistance(geometry, geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_hausdorffdistance(geom1 geometry, geom2 geometry, double precision) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'hausdorffdistancedensify';


--
-- Name: FUNCTION st_hausdorffdistance(geom1 geometry, geom2 geometry, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_hausdorffdistance(geom1 geometry, geom2 geometry, double precision) IS 'args: g1, g2, densifyFrac - Returns the Hausdorff distance between two geometries. Basically a measure of how similar or dissimilar 2 geometries are. Units are in the units of the spatial reference system of the geometries.';


--
-- Name: st_interiorringn(geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_interiorringn(geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_interiorringn_polygon';


--
-- Name: FUNCTION st_interiorringn(geometry, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_interiorringn(geometry, integer) IS 'args: a_polygon, n - Return the Nth interior linestring ring of the polygon geometry. Return NULL if the geometry is not a polygon or the given N is out of range.';


--
-- Name: st_interpolatepoint(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_interpolatepoint(line geometry, point geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'ST_InterpolatePoint';


--
-- Name: FUNCTION st_interpolatepoint(line geometry, point geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_interpolatepoint(line geometry, point geometry) IS 'args: line, point - Return the value of the measure dimension of a geometry at the point closed to the provided point.';


--
-- Name: st_intersection(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_intersection(geom1 geometry, geom2 geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'intersection';


--
-- Name: FUNCTION st_intersection(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_intersection(geom1 geometry, geom2 geometry) IS 'args: geomA, geomB - (T) Returns a geometry that represents the shared portion of geomA and geomB. The geography implementation does a transform to geometry to do the intersection and then transform back to WGS84.';


--
-- Name: st_intersection(geography, geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_intersection(geography, geography) RETURNS geography
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT geography(ST_Transform(ST_Intersection(ST_Transform(geometry($1), _ST_BestSRID($1, $2)), ST_Transform(geometry($2), _ST_BestSRID($1, $2))), 4326))$_$;


--
-- Name: FUNCTION st_intersection(geography, geography); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_intersection(geography, geography) IS 'args: geogA, geogB - (T) Returns a geometry that represents the shared portion of geomA and geomB. The geography implementation does a transform to geometry to do the intersection and then transform back to WGS84.';


--
-- Name: st_intersection(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_intersection(text, text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_Intersection($1::geometry, $2::geometry);  $_$;


--
-- Name: st_intersects(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_intersects(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && $2 AND _ST_Intersects($1,$2)$_$;


--
-- Name: FUNCTION st_intersects(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_intersects(geom1 geometry, geom2 geometry) IS 'args: geomA, geomB - Returns TRUE if the Geometries/Geography "spatially intersect in 2D" - (share any portion of space) and FALSE if they dont (they are Disjoint). For geography -- tolerance is 0.00001 meters (so any points that close are considered to intersect)';


--
-- Name: st_intersects(geography, geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_intersects(geography, geography) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && $2 AND _ST_Distance($1, $2, 0.0, false) < 0.00001$_$;


--
-- Name: FUNCTION st_intersects(geography, geography); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_intersects(geography, geography) IS 'args: geogA, geogB - Returns TRUE if the Geometries/Geography "spatially intersect in 2D" - (share any portion of space) and FALSE if they dont (they are Disjoint). For geography -- tolerance is 0.00001 meters (so any points that close are considered to intersect)';


--
-- Name: st_intersects(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_intersects(text, text) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$ SELECT ST_Intersects($1::geometry, $2::geometry);  $_$;


--
-- Name: st_isclosed(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_isclosed(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_isclosed';


--
-- Name: FUNCTION st_isclosed(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_isclosed(geometry) IS 'args: g - Returns TRUE if the LINESTRINGs start and end points are coincident. For Polyhedral surface is closed (volumetric).';


--
-- Name: st_iscollection(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_iscollection(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'ST_IsCollection';


--
-- Name: FUNCTION st_iscollection(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_iscollection(geometry) IS 'args: g - Returns TRUE if the argument is a collection (MULTI*, GEOMETRYCOLLECTION, ...)';


--
-- Name: st_isempty(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_isempty(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_isempty';


--
-- Name: FUNCTION st_isempty(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_isempty(geometry) IS 'args: geomA - Returns true if this Geometry is an empty geometrycollection, polygon, point etc.';


--
-- Name: st_isring(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_isring(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'isring';


--
-- Name: FUNCTION st_isring(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_isring(geometry) IS 'args: g - Returns TRUE if this LINESTRING is both closed and simple.';


--
-- Name: st_issimple(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_issimple(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'issimple';


--
-- Name: FUNCTION st_issimple(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_issimple(geometry) IS 'args: geomA - Returns (TRUE) if this Geometry has no anomalous geometric points, such as self intersection or self tangency.';


--
-- Name: st_isvalid(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_isvalid(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'isvalid';


--
-- Name: FUNCTION st_isvalid(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_isvalid(geometry) IS 'args: g - Returns true if the ST_Geometry is well formed.';


--
-- Name: st_isvalid(geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_isvalid(geometry, integer) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT (ST_isValidDetail($1, $2)).valid$_$;


--
-- Name: FUNCTION st_isvalid(geometry, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_isvalid(geometry, integer) IS 'args: g, flags - Returns true if the ST_Geometry is well formed.';


--
-- Name: st_isvaliddetail(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_isvaliddetail(geometry) RETURNS valid_detail
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'isvaliddetail';


--
-- Name: FUNCTION st_isvaliddetail(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_isvaliddetail(geometry) IS 'args: geom - Returns a valid_detail (valid,reason,location) row stating if a geometry is valid or not and if not valid, a reason why and a location where.';


--
-- Name: st_isvaliddetail(geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_isvaliddetail(geometry, integer) RETURNS valid_detail
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'isvaliddetail';


--
-- Name: FUNCTION st_isvaliddetail(geometry, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_isvaliddetail(geometry, integer) IS 'args: geom, flags - Returns a valid_detail (valid,reason,location) row stating if a geometry is valid or not and if not valid, a reason why and a location where.';


--
-- Name: st_isvalidreason(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_isvalidreason(geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'isvalidreason';


--
-- Name: FUNCTION st_isvalidreason(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_isvalidreason(geometry) IS 'args: geomA - Returns text stating if a geometry is valid or not and if not valid, a reason why.';


--
-- Name: st_isvalidreason(geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_isvalidreason(geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
SELECT CASE WHEN valid THEN 'Valid Geometry' ELSE reason END FROM (
  SELECT (ST_isValidDetail($1, $2)).*
) foo
  $_$;


--
-- Name: FUNCTION st_isvalidreason(geometry, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_isvalidreason(geometry, integer) IS 'args: geomA, flags - Returns text stating if a geometry is valid or not and if not valid, a reason why.';


--
-- Name: st_length(geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_length(geography) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT ST_Length($1, true)$_$;


--
-- Name: st_length(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_length(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_length2d_linestring';


--
-- Name: FUNCTION st_length(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_length(geometry) IS 'args: a_2dlinestring - Returns the 2d length of the geometry if it is a linestring or multilinestring. geometry are in units of spatial reference and geography are in meters (default spheroid)';


--
-- Name: st_length(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_length(text) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_Length($1::geometry);  $_$;


--
-- Name: st_length(geography, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_length(geog geography, use_spheroid boolean DEFAULT true) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'geography_length';


--
-- Name: FUNCTION st_length(geog geography, use_spheroid boolean); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_length(geog geography, use_spheroid boolean) IS 'args: geog, use_spheroid=true - Returns the 2d length of the geometry if it is a linestring or multilinestring. geometry are in units of spatial reference and geography are in meters (default spheroid)';


--
-- Name: st_length2d(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_length2d(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_length2d_linestring';


--
-- Name: FUNCTION st_length2d(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_length2d(geometry) IS 'args: a_2dlinestring - Returns the 2-dimensional length of the geometry if it is a linestring or multi-linestring. This is an alias for ST_Length';


--
-- Name: st_length2d_spheroid(geometry, spheroid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_length2d_spheroid(geometry, spheroid) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'LWGEOM_length2d_ellipsoid';


--
-- Name: FUNCTION st_length2d_spheroid(geometry, spheroid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_length2d_spheroid(geometry, spheroid) IS 'args: a_linestring, a_spheroid - Calculates the 2D length of a linestring/multilinestring on an ellipsoid. This is useful if the coordinates of the geometry are in longitude/latitude and a length is desired without reprojection.';


--
-- Name: st_length_spheroid(geometry, spheroid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_length_spheroid(geometry, spheroid) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'LWGEOM_length_ellipsoid_linestring';


--
-- Name: FUNCTION st_length_spheroid(geometry, spheroid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_length_spheroid(geometry, spheroid) IS 'args: a_linestring, a_spheroid - Calculates the 2D or 3D length of a linestring/multilinestring on an ellipsoid. This is useful if the coordinates of the geometry are in longitude/latitude and a length is desired without reprojection.';


--
-- Name: st_line_interpolate_point(geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_line_interpolate_point(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT _postgis_deprecate('ST_Line_Interpolate_Point', 'ST_LineInterpolatePoint', '2.1.0');
    SELECT ST_LineInterpolatePoint($1, $2);
  $_$;


--
-- Name: st_line_locate_point(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_line_locate_point(geom1 geometry, geom2 geometry) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT _postgis_deprecate('ST_Line_Locate_Point', 'ST_LineLocatePoint', '2.1.0');
     SELECT ST_LineLocatePoint($1, $2);
  $_$;


--
-- Name: st_line_substring(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_line_substring(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT _postgis_deprecate('ST_Line_Substring', 'ST_LineSubstring', '2.1.0');
     SELECT ST_LineSubstring($1, $2, $3);
  $_$;


--
-- Name: st_linecrossingdirection(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_linecrossingdirection(geom1 geometry, geom2 geometry) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $_$ SELECT CASE WHEN NOT $1 && $2 THEN 0 ELSE _ST_LineCrossingDirection($1,$2) END $_$;


--
-- Name: FUNCTION st_linecrossingdirection(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_linecrossingdirection(geom1 geometry, geom2 geometry) IS 'args: linestringA, linestringB - Given 2 linestrings, returns a number between -3 and 3 denoting what kind of crossing behavior. 0 is no crossing.';


--
-- Name: st_linefrommultipoint(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_linefrommultipoint(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_line_from_mpoint';


--
-- Name: FUNCTION st_linefrommultipoint(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_linefrommultipoint(geometry) IS 'args: aMultiPoint - Creates a LineString from a MultiPoint geometry.';


--
-- Name: st_linefromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_linefromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromText($1)) = 'LINESTRING'
  THEN ST_GeomFromText($1)
  ELSE NULL END
  $_$;


--
-- Name: FUNCTION st_linefromtext(text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_linefromtext(text) IS 'args: WKT - Makes a Geometry from WKT representation with the given SRID. If SRID is not given, it defaults to 0.';


--
-- Name: st_linefromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_linefromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromText($1, $2)) = 'LINESTRING'
  THEN ST_GeomFromText($1,$2)
  ELSE NULL END
  $_$;


--
-- Name: FUNCTION st_linefromtext(text, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_linefromtext(text, integer) IS 'args: WKT, srid - Makes a Geometry from WKT representation with the given SRID. If SRID is not given, it defaults to 0.';


--
-- Name: st_linefromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_linefromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1)) = 'LINESTRING'
  THEN ST_GeomFromWKB($1)
  ELSE NULL END
  $_$;


--
-- Name: FUNCTION st_linefromwkb(bytea); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_linefromwkb(bytea) IS 'args: WKB - Makes a LINESTRING from WKB with the given SRID';


--
-- Name: st_linefromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_linefromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1, $2)) = 'LINESTRING'
  THEN ST_GeomFromWKB($1, $2)
  ELSE NULL END
  $_$;


--
-- Name: FUNCTION st_linefromwkb(bytea, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_linefromwkb(bytea, integer) IS 'args: WKB, srid - Makes a LINESTRING from WKB with the given SRID';


--
-- Name: st_lineinterpolatepoint(geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_lineinterpolatepoint(geometry, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_line_interpolate_point';


--
-- Name: FUNCTION st_lineinterpolatepoint(geometry, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_lineinterpolatepoint(geometry, double precision) IS 'args: a_linestring, a_fraction - Returns a point interpolated along a line. Second argument is a float8 between 0 and 1 representing fraction of total length of linestring the point has to be located.';


--
-- Name: st_linelocatepoint(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_linelocatepoint(geom1 geometry, geom2 geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_line_locate_point';


--
-- Name: FUNCTION st_linelocatepoint(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_linelocatepoint(geom1 geometry, geom2 geometry) IS 'args: a_linestring, a_point - Returns a float between 0 and 1 representing the location of the closest point on LineString to the given Point, as a fraction of total 2d line length.';


--
-- Name: st_linemerge(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_linemerge(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'linemerge';


--
-- Name: FUNCTION st_linemerge(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_linemerge(geometry) IS 'args: amultilinestring - Returns a (set of) LineString(s) formed by sewing together a MULTILINESTRING.';


--
-- Name: st_linestringfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_linestringfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1)) = 'LINESTRING'
  THEN ST_GeomFromWKB($1)
  ELSE NULL END
  $_$;


--
-- Name: FUNCTION st_linestringfromwkb(bytea); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_linestringfromwkb(bytea) IS 'args: WKB - Makes a geometry from WKB with the given SRID.';


--
-- Name: st_linestringfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_linestringfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1, $2)) = 'LINESTRING'
  THEN ST_GeomFromWKB($1, $2)
  ELSE NULL END
  $_$;


--
-- Name: FUNCTION st_linestringfromwkb(bytea, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_linestringfromwkb(bytea, integer) IS 'args: WKB, srid - Makes a geometry from WKB with the given SRID.';


--
-- Name: st_linesubstring(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_linesubstring(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_line_substring';


--
-- Name: FUNCTION st_linesubstring(geometry, double precision, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_linesubstring(geometry, double precision, double precision) IS 'args: a_linestring, startfraction, endfraction - Return a linestring being a substring of the input one starting and ending at the given fractions of total 2d length. Second and third arguments are float8 values between 0 and 1.';


--
-- Name: st_linetocurve(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_linetocurve(geometry geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_line_desegmentize';


--
-- Name: FUNCTION st_linetocurve(geometry geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_linetocurve(geometry geometry) IS 'args: geomANoncircular - Converts a LINESTRING/POLYGON to a CIRCULARSTRING, CURVED POLYGON';


--
-- Name: st_locate_along_measure(geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_locate_along_measure(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_locate_between_measures($1, $2, $2) $_$;


--
-- Name: st_locate_between_measures(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_locate_between_measures(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_locate_between_m';


--
-- Name: st_locatealong(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_locatealong(geometry geometry, measure double precision, leftrightoffset double precision DEFAULT 0.0) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'ST_LocateAlong';


--
-- Name: FUNCTION st_locatealong(geometry geometry, measure double precision, leftrightoffset double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_locatealong(geometry geometry, measure double precision, leftrightoffset double precision) IS 'args: ageom_with_measure, a_measure, offset - Return a derived geometry collection value with elements that match the specified measure. Polygonal elements are not supported.';


--
-- Name: st_locatebetween(geometry, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_locatebetween(geometry geometry, frommeasure double precision, tomeasure double precision, leftrightoffset double precision DEFAULT 0.0) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'ST_LocateBetween';


--
-- Name: FUNCTION st_locatebetween(geometry geometry, frommeasure double precision, tomeasure double precision, leftrightoffset double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_locatebetween(geometry geometry, frommeasure double precision, tomeasure double precision, leftrightoffset double precision) IS 'args: geomA, measure_start, measure_end, offset - Return a derived geometry collection value with elements that match the specified range of measures inclusively. Polygonal elements are not supported.';


--
-- Name: st_locatebetweenelevations(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_locatebetweenelevations(geometry geometry, fromelevation double precision, toelevation double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'ST_LocateBetweenElevations';


--
-- Name: FUNCTION st_locatebetweenelevations(geometry geometry, fromelevation double precision, toelevation double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_locatebetweenelevations(geometry geometry, fromelevation double precision, toelevation double precision) IS 'args: geom_mline, elevation_start, elevation_end - Return a derived geometry (collection) value with elements that intersect the specified range of elevations inclusively. Only 3D, 4D LINESTRINGS and MULTILINESTRINGS are supported.';


--
-- Name: st_longestline(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_longestline(geom1 geometry, geom2 geometry) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_LongestLine(ST_ConvexHull($1), ST_ConvexHull($2))$_$;


--
-- Name: FUNCTION st_longestline(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_longestline(geom1 geometry, geom2 geometry) IS 'args: g1, g2 - Returns the 2-dimensional longest line points of two geometries. The function will only return the first longest line if more than one, that the function finds. The line returned will always start in g1 and end in g2. The length of the line this function returns will always be the same as st_maxdistance returns for g1 and g2.';


--
-- Name: st_m(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_m(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_m_point';


--
-- Name: FUNCTION st_m(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_m(geometry) IS 'args: a_point - Return the M coordinate of the point, or NULL if not available. Input must be a point.';


--
-- Name: st_makebox2d(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_makebox2d(geom1 geometry, geom2 geometry) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'BOX2D_construct';


--
-- Name: FUNCTION st_makebox2d(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_makebox2d(geom1 geometry, geom2 geometry) IS 'args: pointLowLeft, pointUpRight - Creates a BOX2D defined by the given point geometries.';


--
-- Name: st_makeenvelope(double precision, double precision, double precision, double precision, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_makeenvelope(double precision, double precision, double precision, double precision, integer DEFAULT 0) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'ST_MakeEnvelope';


--
-- Name: FUNCTION st_makeenvelope(double precision, double precision, double precision, double precision, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_makeenvelope(double precision, double precision, double precision, double precision, integer) IS 'args: xmin, ymin, xmax, ymax, srid=unknown - Creates a rectangular Polygon formed from the given minimums and maximums. Input values must be in SRS specified by the SRID.';


--
-- Name: st_makeline(geometry[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_makeline(geometry[]) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_makeline_garray';


--
-- Name: FUNCTION st_makeline(geometry[]); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_makeline(geometry[]) IS 'args: geoms_array - Creates a Linestring from point or line geometries.';


--
-- Name: st_makeline(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_makeline(geom1 geometry, geom2 geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_makeline';


--
-- Name: FUNCTION st_makeline(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_makeline(geom1 geometry, geom2 geometry) IS 'args: geom1, geom2 - Creates a Linestring from point or line geometries.';


--
-- Name: st_makepoint(double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_makepoint(double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_makepoint';


--
-- Name: FUNCTION st_makepoint(double precision, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_makepoint(double precision, double precision) IS 'args: x, y - Creates a 2D,3DZ or 4D point geometry.';


--
-- Name: st_makepoint(double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_makepoint(double precision, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_makepoint';


--
-- Name: FUNCTION st_makepoint(double precision, double precision, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_makepoint(double precision, double precision, double precision) IS 'args: x, y, z - Creates a 2D,3DZ or 4D point geometry.';


--
-- Name: st_makepoint(double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_makepoint(double precision, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_makepoint';


--
-- Name: FUNCTION st_makepoint(double precision, double precision, double precision, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_makepoint(double precision, double precision, double precision, double precision) IS 'args: x, y, z, m - Creates a 2D,3DZ or 4D point geometry.';


--
-- Name: st_makepointm(double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_makepointm(double precision, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_makepoint3dm';


--
-- Name: FUNCTION st_makepointm(double precision, double precision, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_makepointm(double precision, double precision, double precision) IS 'args: x, y, m - Creates a point geometry with an x y and m coordinate.';


--
-- Name: st_makepolygon(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_makepolygon(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_makepoly';


--
-- Name: FUNCTION st_makepolygon(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_makepolygon(geometry) IS 'args: linestring - Creates a Polygon formed by the given shell. Input geometries must be closed LINESTRINGS.';


--
-- Name: st_makepolygon(geometry, geometry[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_makepolygon(geometry, geometry[]) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_makepoly';


--
-- Name: FUNCTION st_makepolygon(geometry, geometry[]); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_makepolygon(geometry, geometry[]) IS 'args: outerlinestring, interiorlinestrings - Creates a Polygon formed by the given shell. Input geometries must be closed LINESTRINGS.';


--
-- Name: st_makevalid(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_makevalid(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'ST_MakeValid';


--
-- Name: FUNCTION st_makevalid(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_makevalid(geometry) IS 'args: input - Attempts to make an invalid geometry valid without losing vertices.';


--
-- Name: st_maxdistance(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_maxdistance(geom1 geometry, geom2 geometry) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_MaxDistance(ST_ConvexHull($1), ST_ConvexHull($2))$_$;


--
-- Name: FUNCTION st_maxdistance(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_maxdistance(geom1 geometry, geom2 geometry) IS 'args: g1, g2 - Returns the 2-dimensional largest distance between two geometries in projected units.';


--
-- Name: st_mem_size(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_mem_size(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_mem_size';


--
-- Name: FUNCTION st_mem_size(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_mem_size(geometry) IS 'args: geomA - Returns the amount of space (in bytes) the geometry takes.';


--
-- Name: st_minimumboundingcircle(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_minimumboundingcircle(geometry) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_MinimumBoundingCircle($1, 48)$_$;


--
-- Name: st_minimumboundingcircle(geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_minimumboundingcircle(inputgeom geometry, segs_per_quarter integer DEFAULT 48) RETURNS geometry
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
  DECLARE
  hull GEOMETRY;
  ring GEOMETRY;
  center GEOMETRY;
  radius DOUBLE PRECISION;
  dist DOUBLE PRECISION;
  d DOUBLE PRECISION;
  idx1 integer;
  idx2 integer;
  l1 GEOMETRY;
  l2 GEOMETRY;
  p1 GEOMETRY;
  p2 GEOMETRY;
  a1 DOUBLE PRECISION;
  a2 DOUBLE PRECISION;


  BEGIN

  -- First compute the ConvexHull of the geometry
  hull = ST_ConvexHull(inputgeom);
  --A point really has no MBC
  IF ST_GeometryType(hull) = 'ST_Point' THEN
    RETURN hull;
  END IF;
  -- convert the hull perimeter to a linestring so we can manipulate individual points
  --If its already a linestring force it to a closed linestring
  ring = CASE WHEN ST_GeometryType(hull) = 'ST_LineString' THEN ST_AddPoint(hull, ST_StartPoint(hull)) ELSE ST_ExteriorRing(hull) END;

  dist = 0;
  -- Brute Force - check every pair
  FOR i in 1 .. (ST_NumPoints(ring)-2)
    LOOP
      FOR j in i .. (ST_NumPoints(ring)-1)
        LOOP
        d = ST_Distance(ST_PointN(ring,i),ST_PointN(ring,j));
        -- Check the distance and update if larger
        IF (d > dist) THEN
          dist = d;
          idx1 = i;
          idx2 = j;
        END IF;
      END LOOP;
    END LOOP;

  -- We now have the diameter of the convex hull.  The following line returns it if desired.
  -- RETURN ST_MakeLine(ST_PointN(ring,idx1),ST_PointN(ring,idx2));

  -- Now for the Minimum Bounding Circle.  Since we know the two points furthest from each
  -- other, the MBC must go through those two points. Start with those points as a diameter of a circle.

  -- The radius is half the distance between them and the center is midway between them
  radius = ST_Distance(ST_PointN(ring,idx1),ST_PointN(ring,idx2)) / 2.0;
  center = ST_LineInterpolatePoint(ST_MakeLine(ST_PointN(ring,idx1),ST_PointN(ring,idx2)),0.5);

  -- Loop through each vertex and check if the distance from the center to the point
  -- is greater than the current radius.
  FOR k in 1 .. (ST_NumPoints(ring)-1)
    LOOP
    IF(k <> idx1 and k <> idx2) THEN
      dist = ST_Distance(center,ST_PointN(ring,k));
      IF (dist > radius) THEN
        -- We have to expand the circle.  The new circle must pass trhough
        -- three points - the two original diameters and this point.

        -- Draw a line from the first diameter to this point
        l1 = ST_Makeline(ST_PointN(ring,idx1),ST_PointN(ring,k));
        -- Compute the midpoint
        p1 = ST_LineInterpolatePoint(l1,0.5);
        -- Rotate the line 90 degrees around the midpoint (perpendicular bisector)
        l1 = ST_Rotate(l1,pi()/2,p1);
        --  Compute the azimuth of the bisector
        a1 = ST_Azimuth(ST_PointN(l1,1),ST_PointN(l1,2));
        --  Extend the line in each direction the new computed distance to insure they will intersect
        l1 = ST_AddPoint(l1,ST_Makepoint(ST_X(ST_PointN(l1,2))+sin(a1)*dist,ST_Y(ST_PointN(l1,2))+cos(a1)*dist),-1);
        l1 = ST_AddPoint(l1,ST_Makepoint(ST_X(ST_PointN(l1,1))-sin(a1)*dist,ST_Y(ST_PointN(l1,1))-cos(a1)*dist),0);

        -- Repeat for the line from the point to the other diameter point
        l2 = ST_Makeline(ST_PointN(ring,idx2),ST_PointN(ring,k));
        p2 = ST_LineInterpolatePoint(l2,0.5);
        l2 = ST_Rotate(l2,pi()/2,p2);
        a2 = ST_Azimuth(ST_PointN(l2,1),ST_PointN(l2,2));
        l2 = ST_AddPoint(l2,ST_Makepoint(ST_X(ST_PointN(l2,2))+sin(a2)*dist,ST_Y(ST_PointN(l2,2))+cos(a2)*dist),-1);
        l2 = ST_AddPoint(l2,ST_Makepoint(ST_X(ST_PointN(l2,1))-sin(a2)*dist,ST_Y(ST_PointN(l2,1))-cos(a2)*dist),0);

        -- The new center is the intersection of the two bisectors
        center = ST_Intersection(l1,l2);
        -- The new radius is the distance to any of the three points
        radius = ST_Distance(center,ST_PointN(ring,idx1));
      END IF;
    END IF;
    END LOOP;
  --DONE!!  Return the MBC via the buffer command
  RETURN ST_Buffer(center,radius,segs_per_quarter);

  END;
$$;


--
-- Name: FUNCTION st_minimumboundingcircle(inputgeom geometry, segs_per_quarter integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_minimumboundingcircle(inputgeom geometry, segs_per_quarter integer) IS 'args: geomA, num_segs_per_qt_circ=48 - Returns the smallest circle polygon that can fully contain a geometry. Default uses 48 segments per quarter circle.';


--
-- Name: st_mlinefromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_mlinefromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromText($1)) = 'MULTILINESTRING'
  THEN ST_GeomFromText($1)
  ELSE NULL END
  $_$;


--
-- Name: FUNCTION st_mlinefromtext(text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_mlinefromtext(text) IS 'args: WKT - Return a specified ST_MultiLineString value from WKT representation.';


--
-- Name: st_mlinefromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_mlinefromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE
  WHEN geometrytype(ST_GeomFromText($1, $2)) = 'MULTILINESTRING'
  THEN ST_GeomFromText($1,$2)
  ELSE NULL END
  $_$;


--
-- Name: FUNCTION st_mlinefromtext(text, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_mlinefromtext(text, integer) IS 'args: WKT, srid - Return a specified ST_MultiLineString value from WKT representation.';


--
-- Name: st_mlinefromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_mlinefromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1)) = 'MULTILINESTRING'
  THEN ST_GeomFromWKB($1)
  ELSE NULL END
  $_$;


--
-- Name: st_mlinefromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_mlinefromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1, $2)) = 'MULTILINESTRING'
  THEN ST_GeomFromWKB($1, $2)
  ELSE NULL END
  $_$;


--
-- Name: st_mpointfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_mpointfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromText($1)) = 'MULTIPOINT'
  THEN ST_GeomFromText($1)
  ELSE NULL END
  $_$;


--
-- Name: FUNCTION st_mpointfromtext(text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_mpointfromtext(text) IS 'args: WKT - Makes a Geometry from WKT with the given SRID. If SRID is not give, it defaults to 0.';


--
-- Name: st_mpointfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_mpointfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromText($1, $2)) = 'MULTIPOINT'
  THEN ST_GeomFromText($1, $2)
  ELSE NULL END
  $_$;


--
-- Name: FUNCTION st_mpointfromtext(text, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_mpointfromtext(text, integer) IS 'args: WKT, srid - Makes a Geometry from WKT with the given SRID. If SRID is not give, it defaults to 0.';


--
-- Name: st_mpointfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_mpointfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1)) = 'MULTIPOINT'
  THEN ST_GeomFromWKB($1)
  ELSE NULL END
  $_$;


--
-- Name: st_mpointfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_mpointfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1, $2)) = 'MULTIPOINT'
  THEN ST_GeomFromWKB($1, $2)
  ELSE NULL END
  $_$;


--
-- Name: st_mpolyfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_mpolyfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromText($1)) = 'MULTIPOLYGON'
  THEN ST_GeomFromText($1)
  ELSE NULL END
  $_$;


--
-- Name: FUNCTION st_mpolyfromtext(text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_mpolyfromtext(text) IS 'args: WKT - Makes a MultiPolygon Geometry from WKT with the given SRID. If SRID is not give, it defaults to 0.';


--
-- Name: st_mpolyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_mpolyfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromText($1, $2)) = 'MULTIPOLYGON'
  THEN ST_GeomFromText($1,$2)
  ELSE NULL END
  $_$;


--
-- Name: FUNCTION st_mpolyfromtext(text, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_mpolyfromtext(text, integer) IS 'args: WKT, srid - Makes a MultiPolygon Geometry from WKT with the given SRID. If SRID is not give, it defaults to 0.';


--
-- Name: st_mpolyfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_mpolyfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1)) = 'MULTIPOLYGON'
  THEN ST_GeomFromWKB($1)
  ELSE NULL END
  $_$;


--
-- Name: st_mpolyfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_mpolyfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1, $2)) = 'MULTIPOLYGON'
  THEN ST_GeomFromWKB($1, $2)
  ELSE NULL END
  $_$;


--
-- Name: st_multi(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_multi(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_force_multi';


--
-- Name: FUNCTION st_multi(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_multi(geometry) IS 'args: g1 - Returns the geometry as a MULTI* geometry. If the geometry is already a MULTI*, it is returned unchanged.';


--
-- Name: st_multilinefromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_multilinefromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1)) = 'MULTILINESTRING'
  THEN ST_GeomFromWKB($1)
  ELSE NULL END
  $_$;


--
-- Name: st_multilinestringfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_multilinestringfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_MLineFromText($1)$_$;


--
-- Name: st_multilinestringfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_multilinestringfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_MLineFromText($1, $2)$_$;


--
-- Name: st_multipointfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_multipointfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_MPointFromText($1)$_$;


--
-- Name: st_multipointfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_multipointfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1)) = 'MULTIPOINT'
  THEN ST_GeomFromWKB($1)
  ELSE NULL END
  $_$;


--
-- Name: st_multipointfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_multipointfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1,$2)) = 'MULTIPOINT'
  THEN ST_GeomFromWKB($1, $2)
  ELSE NULL END
  $_$;


--
-- Name: st_multipolyfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_multipolyfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1)) = 'MULTIPOLYGON'
  THEN ST_GeomFromWKB($1)
  ELSE NULL END
  $_$;


--
-- Name: st_multipolyfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_multipolyfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1, $2)) = 'MULTIPOLYGON'
  THEN ST_GeomFromWKB($1, $2)
  ELSE NULL END
  $_$;


--
-- Name: st_multipolygonfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_multipolygonfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_MPolyFromText($1)$_$;


--
-- Name: st_multipolygonfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_multipolygonfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_MPolyFromText($1, $2)$_$;


--
-- Name: st_ndims(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_ndims(geometry) RETURNS smallint
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_ndims';


--
-- Name: FUNCTION st_ndims(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_ndims(geometry) IS 'args: g1 - Returns coordinate dimension of the geometry as a small int. Values are: 2,3 or 4.';


--
-- Name: st_node(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_node(g geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'ST_Node';


--
-- Name: FUNCTION st_node(g geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_node(g geometry) IS 'args: geom - Node a set of linestrings.';


--
-- Name: st_npoints(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_npoints(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_npoints';


--
-- Name: FUNCTION st_npoints(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_npoints(geometry) IS 'args: g1 - Return the number of points (vertexes) in a geometry.';


--
-- Name: st_nrings(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_nrings(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_nrings';


--
-- Name: FUNCTION st_nrings(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_nrings(geometry) IS 'args: geomA - If the geometry is a polygon or multi-polygon returns the number of rings.';


--
-- Name: st_numgeometries(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_numgeometries(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_numgeometries_collection';


--
-- Name: FUNCTION st_numgeometries(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_numgeometries(geometry) IS 'args: geom - If geometry is a GEOMETRYCOLLECTION (or MULTI*) return the number of geometries, for single geometries will return 1, otherwise return NULL.';


--
-- Name: st_numinteriorring(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_numinteriorring(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_numinteriorrings_polygon';


--
-- Name: FUNCTION st_numinteriorring(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_numinteriorring(geometry) IS 'args: a_polygon - Return the number of interior rings of the first polygon in the geometry. Synonym to ST_NumInteriorRings.';


--
-- Name: st_numinteriorrings(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_numinteriorrings(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_numinteriorrings_polygon';


--
-- Name: FUNCTION st_numinteriorrings(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_numinteriorrings(geometry) IS 'args: a_polygon - Return the number of interior rings of the first polygon in the geometry. This will work with both POLYGON and MULTIPOLYGON types but only looks at the first polygon. Return NULL if there is no polygon in the geometry.';


--
-- Name: st_numpatches(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_numpatches(geometry) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN ST_GeometryType($1) = 'ST_PolyhedralSurface'
  THEN ST_NumGeometries($1)
  ELSE NULL END
  $_$;


--
-- Name: FUNCTION st_numpatches(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_numpatches(geometry) IS 'args: g1 - Return the number of faces on a Polyhedral Surface. Will return null for non-polyhedral geometries.';


--
-- Name: st_numpoints(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_numpoints(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_numpoints_linestring';


--
-- Name: FUNCTION st_numpoints(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_numpoints(geometry) IS 'args: g1 - Return the number of points in an ST_LineString or ST_CircularString value.';


--
-- Name: st_offsetcurve(geometry, double precision, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_offsetcurve(line geometry, distance double precision, params text DEFAULT ''::text) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'ST_OffsetCurve';


--
-- Name: FUNCTION st_offsetcurve(line geometry, distance double precision, params text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_offsetcurve(line geometry, distance double precision, params text) IS 'args: line, signed_distance, style_parameters='' - Return an offset line at a given distance and side from an input line. Useful for computing parallel lines about a center line';


--
-- Name: st_orderingequals(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_orderingequals(geometrya geometry, geometryb geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ 
  SELECT $1 ~= $2 AND _ST_OrderingEquals($1, $2)
  $_$;


--
-- Name: FUNCTION st_orderingequals(geometrya geometry, geometryb geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_orderingequals(geometrya geometry, geometryb geometry) IS 'args: A, B - Returns true if the given geometries represent the same geometry and points are in the same directional order.';


--
-- Name: st_overlaps(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_overlaps(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && $2 AND _ST_Overlaps($1,$2)$_$;


--
-- Name: FUNCTION st_overlaps(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_overlaps(geom1 geometry, geom2 geometry) IS 'args: A, B - Returns TRUE if the Geometries share space, are of the same dimension, but are not completely contained by each other.';


--
-- Name: st_patchn(geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_patchn(geometry, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN ST_GeometryType($1) = 'ST_PolyhedralSurface'
  THEN ST_GeometryN($1, $2)
  ELSE NULL END
  $_$;


--
-- Name: FUNCTION st_patchn(geometry, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_patchn(geometry, integer) IS 'args: geomA, n - Return the 1-based Nth geometry (face) if the geometry is a POLYHEDRALSURFACE, POLYHEDRALSURFACEM. Otherwise, return NULL.';


--
-- Name: st_perimeter(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_perimeter(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_perimeter2d_poly';


--
-- Name: FUNCTION st_perimeter(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_perimeter(geometry) IS 'args: g1 - Return the length measurement of the boundary of an ST_Surface or ST_MultiSurface geometry or geography. (Polygon, Multipolygon). geometry measurement is in units of spatial reference and geography is in meters.';


--
-- Name: st_perimeter(geography, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_perimeter(geog geography, use_spheroid boolean DEFAULT true) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'geography_perimeter';


--
-- Name: FUNCTION st_perimeter(geog geography, use_spheroid boolean); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_perimeter(geog geography, use_spheroid boolean) IS 'args: geog, use_spheroid=true - Return the length measurement of the boundary of an ST_Surface or ST_MultiSurface geometry or geography. (Polygon, Multipolygon). geometry measurement is in units of spatial reference and geography is in meters.';


--
-- Name: st_perimeter2d(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_perimeter2d(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_perimeter2d_poly';


--
-- Name: FUNCTION st_perimeter2d(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_perimeter2d(geometry) IS 'args: geomA - Returns the 2-dimensional perimeter of the geometry, if it is a polygon or multi-polygon. This is currently an alias for ST_Perimeter.';


--
-- Name: st_point(double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_point(double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_makepoint';


--
-- Name: FUNCTION st_point(double precision, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_point(double precision, double precision) IS 'args: x_lon, y_lat - Returns an ST_Point with the given coordinate values. OGC alias for ST_MakePoint.';


--
-- Name: st_point_inside_circle(geometry, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_point_inside_circle(geometry, double precision, double precision, double precision) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_inside_circle_point';


--
-- Name: FUNCTION st_point_inside_circle(geometry, double precision, double precision, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_point_inside_circle(geometry, double precision, double precision, double precision) IS 'args: a_point, center_x, center_y, radius - Is the point geometry insert circle defined by center_x, center_y, radius';


--
-- Name: st_pointfromgeohash(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_pointfromgeohash(text, integer DEFAULT NULL::integer) RETURNS geometry
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-2.1', 'point_from_geohash';


--
-- Name: FUNCTION st_pointfromgeohash(text, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_pointfromgeohash(text, integer) IS 'args: geohash, precision=full_precision_of_geohash - Return a point from a GeoHash string.';


--
-- Name: st_pointfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_pointfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromText($1)) = 'POINT'
  THEN ST_GeomFromText($1)
  ELSE NULL END
  $_$;


--
-- Name: FUNCTION st_pointfromtext(text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_pointfromtext(text) IS 'args: WKT - Makes a point Geometry from WKT with the given SRID. If SRID is not given, it defaults to unknown.';


--
-- Name: st_pointfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_pointfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromText($1, $2)) = 'POINT'
  THEN ST_GeomFromText($1, $2)
  ELSE NULL END
  $_$;


--
-- Name: FUNCTION st_pointfromtext(text, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_pointfromtext(text, integer) IS 'args: WKT, srid - Makes a point Geometry from WKT with the given SRID. If SRID is not given, it defaults to unknown.';


--
-- Name: st_pointfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_pointfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1)) = 'POINT'
  THEN ST_GeomFromWKB($1)
  ELSE NULL END
  $_$;


--
-- Name: st_pointfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_pointfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1, $2)) = 'POINT'
  THEN ST_GeomFromWKB($1, $2)
  ELSE NULL END
  $_$;


--
-- Name: st_pointn(geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_pointn(geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_pointn_linestring';


--
-- Name: FUNCTION st_pointn(geometry, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_pointn(geometry, integer) IS 'args: a_linestring, n - Return the Nth point in the first linestring or circular linestring in the geometry. Return NULL if there is no linestring in the geometry.';


--
-- Name: st_pointonsurface(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_pointonsurface(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'pointonsurface';


--
-- Name: FUNCTION st_pointonsurface(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_pointonsurface(geometry) IS 'args: g1 - Returns a POINT guaranteed to lie on the surface.';


--
-- Name: st_polyfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_polyfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromText($1)) = 'POLYGON'
  THEN ST_GeomFromText($1)
  ELSE NULL END
  $_$;


--
-- Name: st_polyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_polyfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromText($1, $2)) = 'POLYGON'
  THEN ST_GeomFromText($1, $2)
  ELSE NULL END
  $_$;


--
-- Name: st_polyfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_polyfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1)) = 'POLYGON'
  THEN ST_GeomFromWKB($1)
  ELSE NULL END
  $_$;


--
-- Name: st_polyfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_polyfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1, $2)) = 'POLYGON'
  THEN ST_GeomFromWKB($1, $2)
  ELSE NULL END
  $_$;


--
-- Name: st_polygon(geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_polygon(geometry, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ 
  SELECT ST_SetSRID(ST_MakePolygon($1), $2)
  $_$;


--
-- Name: FUNCTION st_polygon(geometry, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_polygon(geometry, integer) IS 'args: aLineString, srid - Returns a polygon built from the specified linestring and SRID.';


--
-- Name: st_polygonfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_polygonfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_PolyFromText($1)$_$;


--
-- Name: FUNCTION st_polygonfromtext(text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_polygonfromtext(text) IS 'args: WKT - Makes a Geometry from WKT with the given SRID. If SRID is not give, it defaults to 0.';


--
-- Name: st_polygonfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_polygonfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_PolyFromText($1, $2)$_$;


--
-- Name: FUNCTION st_polygonfromtext(text, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_polygonfromtext(text, integer) IS 'args: WKT, srid - Makes a Geometry from WKT with the given SRID. If SRID is not give, it defaults to 0.';


--
-- Name: st_polygonfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_polygonfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1)) = 'POLYGON'
  THEN ST_GeomFromWKB($1)
  ELSE NULL END
  $_$;


--
-- Name: st_polygonfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_polygonfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1,$2)) = 'POLYGON'
  THEN ST_GeomFromWKB($1, $2)
  ELSE NULL END
  $_$;


--
-- Name: st_polygonize(geometry[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_polygonize(geometry[]) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'polygonize_garray';


--
-- Name: FUNCTION st_polygonize(geometry[]); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_polygonize(geometry[]) IS 'args: geom_array - Aggregate. Creates a GeometryCollection containing possible polygons formed from the constituent linework of a set of geometries.';


--
-- Name: st_project(geography, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_project(geog geography, distance double precision, azimuth double precision) RETURNS geography
    LANGUAGE c IMMUTABLE COST 100
    AS '$libdir/postgis-2.1', 'geography_project';


--
-- Name: FUNCTION st_project(geog geography, distance double precision, azimuth double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_project(geog geography, distance double precision, azimuth double precision) IS 'args: g1, distance, azimuth - Returns a POINT projected from a start point using a distance in meters and bearing (azimuth) in radians.';


--
-- Name: st_relate(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_relate(geom1 geometry, geom2 geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'relate_full';


--
-- Name: FUNCTION st_relate(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_relate(geom1 geometry, geom2 geometry) IS 'args: geomA, geomB - Returns true if this Geometry is spatially related to anotherGeometry, by testing for intersections between the Interior, Boundary and Exterior of the two geometries as specified by the values in the intersectionMatrixPattern. If no intersectionMatrixPattern is passed in, then returns the maximum intersectionMatrixPattern that relates the 2 geometries.';


--
-- Name: st_relate(geometry, geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_relate(geom1 geometry, geom2 geometry, integer) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'relate_full';


--
-- Name: FUNCTION st_relate(geom1 geometry, geom2 geometry, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_relate(geom1 geometry, geom2 geometry, integer) IS 'args: geomA, geomB, BoundaryNodeRule - Returns true if this Geometry is spatially related to anotherGeometry, by testing for intersections between the Interior, Boundary and Exterior of the two geometries as specified by the values in the intersectionMatrixPattern. If no intersectionMatrixPattern is passed in, then returns the maximum intersectionMatrixPattern that relates the 2 geometries.';


--
-- Name: st_relate(geometry, geometry, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_relate(geom1 geometry, geom2 geometry, text) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'relate_pattern';


--
-- Name: FUNCTION st_relate(geom1 geometry, geom2 geometry, text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_relate(geom1 geometry, geom2 geometry, text) IS 'args: geomA, geomB, intersectionMatrixPattern - Returns true if this Geometry is spatially related to anotherGeometry, by testing for intersections between the Interior, Boundary and Exterior of the two geometries as specified by the values in the intersectionMatrixPattern. If no intersectionMatrixPattern is passed in, then returns the maximum intersectionMatrixPattern that relates the 2 geometries.';


--
-- Name: st_relatematch(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_relatematch(text, text) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'ST_RelateMatch';


--
-- Name: FUNCTION st_relatematch(text, text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_relatematch(text, text) IS 'args: intersectionMatrix, intersectionMatrixPattern - Returns true if intersectionMattrixPattern1 implies intersectionMatrixPattern2';


--
-- Name: st_removepoint(geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_removepoint(geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_removepoint';


--
-- Name: FUNCTION st_removepoint(geometry, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_removepoint(geometry, integer) IS 'args: linestring, offset - Removes point from a linestring. Offset is 0-based.';


--
-- Name: st_removerepeatedpoints(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_removerepeatedpoints(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'ST_RemoveRepeatedPoints';


--
-- Name: FUNCTION st_removerepeatedpoints(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_removerepeatedpoints(geometry) IS 'args: geom - Returns a version of the given geometry with duplicated points removed.';


--
-- Name: st_reverse(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_reverse(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_reverse';


--
-- Name: FUNCTION st_reverse(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_reverse(geometry) IS 'args: g1 - Returns the geometry with vertex order reversed.';


--
-- Name: st_rotate(geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_rotate(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_Affine($1,  cos($2), -sin($2), 0,  sin($2), cos($2), 0,  0, 0, 1,  0, 0, 0)$_$;


--
-- Name: FUNCTION st_rotate(geometry, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_rotate(geometry, double precision) IS 'args: geomA, rotRadians - Rotate a geometry rotRadians counter-clockwise about an origin.';


--
-- Name: st_rotate(geometry, double precision, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_rotate(geometry, double precision, geometry) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_Affine($1,  cos($2), -sin($2), 0,  sin($2),  cos($2), 0, 0, 0, 1, ST_X($3) - cos($2) * ST_X($3) + sin($2) * ST_Y($3), ST_Y($3) - sin($2) * ST_X($3) - cos($2) * ST_Y($3), 0)$_$;


--
-- Name: FUNCTION st_rotate(geometry, double precision, geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_rotate(geometry, double precision, geometry) IS 'args: geomA, rotRadians, pointOrigin - Rotate a geometry rotRadians counter-clockwise about an origin.';


--
-- Name: st_rotate(geometry, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_rotate(geometry, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_Affine($1,  cos($2), -sin($2), 0,  sin($2),  cos($2), 0, 0, 0, 1, $3 - cos($2) * $3 + sin($2) * $4, $4 - sin($2) * $3 - cos($2) * $4, 0)$_$;


--
-- Name: FUNCTION st_rotate(geometry, double precision, double precision, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_rotate(geometry, double precision, double precision, double precision) IS 'args: geomA, rotRadians, x0, y0 - Rotate a geometry rotRadians counter-clockwise about an origin.';


--
-- Name: st_rotatex(geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_rotatex(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_Affine($1, 1, 0, 0, 0, cos($2), -sin($2), 0, sin($2), cos($2), 0, 0, 0)$_$;


--
-- Name: FUNCTION st_rotatex(geometry, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_rotatex(geometry, double precision) IS 'args: geomA, rotRadians - Rotate a geometry rotRadians about the X axis.';


--
-- Name: st_rotatey(geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_rotatey(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_Affine($1,  cos($2), 0, sin($2),  0, 1, 0,  -sin($2), 0, cos($2), 0,  0, 0)$_$;


--
-- Name: FUNCTION st_rotatey(geometry, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_rotatey(geometry, double precision) IS 'args: geomA, rotRadians - Rotate a geometry rotRadians about the Y axis.';


--
-- Name: st_rotatez(geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_rotatez(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_Rotate($1, $2)$_$;


--
-- Name: FUNCTION st_rotatez(geometry, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_rotatez(geometry, double precision) IS 'args: geomA, rotRadians - Rotate a geometry rotRadians about the Z axis.';


--
-- Name: st_scale(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_scale(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_Scale($1, $2, $3, 1)$_$;


--
-- Name: FUNCTION st_scale(geometry, double precision, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_scale(geometry, double precision, double precision) IS 'args: geomA, XFactor, YFactor - Scales the geometry to a new size by multiplying the ordinates with the parameters. Ie: ST_Scale(geom, Xfactor, Yfactor, Zfactor).';


--
-- Name: st_scale(geometry, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_scale(geometry, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_Affine($1,  $2, 0, 0,  0, $3, 0,  0, 0, $4,  0, 0, 0)$_$;


--
-- Name: FUNCTION st_scale(geometry, double precision, double precision, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_scale(geometry, double precision, double precision, double precision) IS 'args: geomA, XFactor, YFactor, ZFactor - Scales the geometry to a new size by multiplying the ordinates with the parameters. Ie: ST_Scale(geom, Xfactor, Yfactor, Zfactor).';


--
-- Name: st_segmentize(geography, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_segmentize(geog geography, max_segment_length double precision) RETURNS geography
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'geography_segmentize';


--
-- Name: FUNCTION st_segmentize(geog geography, max_segment_length double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_segmentize(geog geography, max_segment_length double precision) IS 'args: geog, max_segment_length - Return a modified geometry/geography having no segment longer than the given distance. Distance computation is performed in 2d only. For geometry, length units are in units of spatial reference. For geography, units are in meters.';


--
-- Name: st_segmentize(geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_segmentize(geometry, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_segmentize2d';


--
-- Name: FUNCTION st_segmentize(geometry, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_segmentize(geometry, double precision) IS 'args: geom, max_segment_length - Return a modified geometry/geography having no segment longer than the given distance. Distance computation is performed in 2d only. For geometry, length units are in units of spatial reference. For geography, units are in meters.';


--
-- Name: st_setpoint(geometry, integer, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_setpoint(geometry, integer, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_setpoint_linestring';


--
-- Name: FUNCTION st_setpoint(geometry, integer, geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_setpoint(geometry, integer, geometry) IS 'args: linestring, zerobasedposition, point - Replace point N of linestring with given point. Index is 0-based.';


--
-- Name: st_setsrid(geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_setsrid(geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_set_srid';


--
-- Name: FUNCTION st_setsrid(geometry, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_setsrid(geometry, integer) IS 'args: geom, srid - Sets the SRID on a geometry to a particular integer value.';


--
-- Name: st_sharedpaths(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_sharedpaths(geom1 geometry, geom2 geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'ST_SharedPaths';


--
-- Name: FUNCTION st_sharedpaths(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_sharedpaths(geom1 geometry, geom2 geometry) IS 'args: lineal1, lineal2 - Returns a collection containing paths shared by the two input linestrings/multilinestrings.';


--
-- Name: st_shift_longitude(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_shift_longitude(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_longitude_shift';


--
-- Name: FUNCTION st_shift_longitude(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_shift_longitude(geometry) IS 'args: geomA - Reads every point/vertex in every component of every feature in a geometry, and if the longitude coordinate is <0, adds 360 to it. The result would be a 0-360 version of the data to be plotted in a 180 centric map';


--
-- Name: st_shortestline(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_shortestline(geom1 geometry, geom2 geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_shortestline2d';


--
-- Name: FUNCTION st_shortestline(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_shortestline(geom1 geometry, geom2 geometry) IS 'args: g1, g2 - Returns the 2-dimensional shortest line between two geometries';


--
-- Name: st_simplify(geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_simplify(geometry, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_simplify2d';


--
-- Name: FUNCTION st_simplify(geometry, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_simplify(geometry, double precision) IS 'args: geomA, tolerance - Returns a "simplified" version of the given geometry using the Douglas-Peucker algorithm.';


--
-- Name: st_simplifypreservetopology(geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_simplifypreservetopology(geometry, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'topologypreservesimplify';


--
-- Name: FUNCTION st_simplifypreservetopology(geometry, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_simplifypreservetopology(geometry, double precision) IS 'args: geomA, tolerance - Returns a "simplified" version of the given geometry using the Douglas-Peucker algorithm. Will avoid creating derived geometries (polygons in particular) that are invalid.';


--
-- Name: st_snap(geometry, geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_snap(geom1 geometry, geom2 geometry, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'ST_Snap';


--
-- Name: FUNCTION st_snap(geom1 geometry, geom2 geometry, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_snap(geom1 geometry, geom2 geometry, double precision) IS 'args: input, reference, tolerance - Snap segments and vertices of input geometry to vertices of a reference geometry.';


--
-- Name: st_snaptogrid(geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_snaptogrid(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_SnapToGrid($1, 0, 0, $2, $2)$_$;


--
-- Name: FUNCTION st_snaptogrid(geometry, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_snaptogrid(geometry, double precision) IS 'args: geomA, size - Snap all points of the input geometry to a regular grid.';


--
-- Name: st_snaptogrid(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_snaptogrid(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_SnapToGrid($1, 0, 0, $2, $3)$_$;


--
-- Name: FUNCTION st_snaptogrid(geometry, double precision, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_snaptogrid(geometry, double precision, double precision) IS 'args: geomA, sizeX, sizeY - Snap all points of the input geometry to a regular grid.';


--
-- Name: st_snaptogrid(geometry, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_snaptogrid(geometry, double precision, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_snaptogrid';


--
-- Name: FUNCTION st_snaptogrid(geometry, double precision, double precision, double precision, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_snaptogrid(geometry, double precision, double precision, double precision, double precision) IS 'args: geomA, originX, originY, sizeX, sizeY - Snap all points of the input geometry to a regular grid.';


--
-- Name: st_snaptogrid(geometry, geometry, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_snaptogrid(geom1 geometry, geom2 geometry, double precision, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_snaptogrid_pointoff';


--
-- Name: FUNCTION st_snaptogrid(geom1 geometry, geom2 geometry, double precision, double precision, double precision, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_snaptogrid(geom1 geometry, geom2 geometry, double precision, double precision, double precision, double precision) IS 'args: geomA, pointOrigin, sizeX, sizeY, sizeZ, sizeM - Snap all points of the input geometry to a regular grid.';


--
-- Name: st_split(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_split(geom1 geometry, geom2 geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.1', 'ST_Split';


--
-- Name: FUNCTION st_split(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_split(geom1 geometry, geom2 geometry) IS 'args: input, blade - Returns a collection of geometries resulting by splitting a geometry.';


--
-- Name: st_srid(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_srid(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_get_srid';


--
-- Name: FUNCTION st_srid(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_srid(geometry) IS 'args: g1 - Returns the spatial reference identifier for the ST_Geometry as defined in spatial_ref_sys table.';


--
-- Name: st_startpoint(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_startpoint(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_startpoint_linestring';


--
-- Name: FUNCTION st_startpoint(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_startpoint(geometry) IS 'args: geomA - Returns the first point of a LINESTRING geometry as a POINT.';


--
-- Name: st_summary(geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_summary(geography) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_summary';


--
-- Name: FUNCTION st_summary(geography); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_summary(geography) IS 'args: g - Returns a text summary of the contents of the geometry.';


--
-- Name: st_summary(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_summary(geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_summary';


--
-- Name: FUNCTION st_summary(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_summary(geometry) IS 'args: g - Returns a text summary of the contents of the geometry.';


--
-- Name: st_symdifference(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_symdifference(geom1 geometry, geom2 geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'symdifference';


--
-- Name: FUNCTION st_symdifference(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_symdifference(geom1 geometry, geom2 geometry) IS 'args: geomA, geomB - Returns a geometry that represents the portions of A and B that do not intersect. It is called a symmetric difference because ST_SymDifference(A,B) = ST_SymDifference(B,A).';


--
-- Name: st_symmetricdifference(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_symmetricdifference(geom1 geometry, geom2 geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'symdifference';


--
-- Name: st_touches(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_touches(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && $2 AND _ST_Touches($1,$2)$_$;


--
-- Name: FUNCTION st_touches(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_touches(geom1 geometry, geom2 geometry) IS 'args: g1, g2 - Returns TRUE if the geometries have at least one point in common, but their interiors do not intersect.';


--
-- Name: st_transform(geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_transform(geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'transform';


--
-- Name: FUNCTION st_transform(geometry, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_transform(geometry, integer) IS 'args: g1, srid - Returns a new geometry with its coordinates transformed to the SRID referenced by the integer parameter.';


--
-- Name: st_translate(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_translate(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_Translate($1, $2, $3, 0)$_$;


--
-- Name: FUNCTION st_translate(geometry, double precision, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_translate(geometry, double precision, double precision) IS 'args: g1, deltax, deltay - Translates the geometry to a new location using the numeric parameters as offsets. Ie: ST_Translate(geom, X, Y) or ST_Translate(geom, X, Y,Z).';


--
-- Name: st_translate(geometry, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_translate(geometry, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_Affine($1, 1, 0, 0, 0, 1, 0, 0, 0, 1, $2, $3, $4)$_$;


--
-- Name: FUNCTION st_translate(geometry, double precision, double precision, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_translate(geometry, double precision, double precision, double precision) IS 'args: g1, deltax, deltay, deltaz - Translates the geometry to a new location using the numeric parameters as offsets. Ie: ST_Translate(geom, X, Y) or ST_Translate(geom, X, Y,Z).';


--
-- Name: st_transscale(geometry, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_transscale(geometry, double precision, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_Affine($1,  $4, 0, 0,  0, $5, 0,
    0, 0, 1,  $2 * $4, $3 * $5, 0)$_$;


--
-- Name: FUNCTION st_transscale(geometry, double precision, double precision, double precision, double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_transscale(geometry, double precision, double precision, double precision, double precision) IS 'args: geomA, deltaX, deltaY, XFactor, YFactor - Translates the geometry using the deltaX and deltaY args, then scales it using the XFactor, YFactor args, working in 2D only.';


--
-- Name: st_unaryunion(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_unaryunion(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'ST_UnaryUnion';


--
-- Name: FUNCTION st_unaryunion(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_unaryunion(geometry) IS 'args: geom - Like ST_Union, but working at the geometry component level.';


--
-- Name: st_union(geometry[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_union(geometry[]) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'pgis_union_geometry_array';


--
-- Name: FUNCTION st_union(geometry[]); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_union(geometry[]) IS 'args: g1_array - Returns a geometry that represents the point set union of the Geometries.';


--
-- Name: st_union(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_union(geom1 geometry, geom2 geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'geomunion';


--
-- Name: FUNCTION st_union(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_union(geom1 geometry, geom2 geometry) IS 'args: g1, g2 - Returns a geometry that represents the point set union of the Geometries.';


--
-- Name: st_within(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_within(geom1 geometry, geom2 geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && $2 AND _ST_Contains($2,$1)$_$;


--
-- Name: FUNCTION st_within(geom1 geometry, geom2 geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_within(geom1 geometry, geom2 geometry) IS 'args: A, B - Returns true if the geometry A is completely inside geometry B';


--
-- Name: st_wkbtosql(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_wkbtosql(wkb bytea) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_from_WKB';


--
-- Name: FUNCTION st_wkbtosql(wkb bytea); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_wkbtosql(wkb bytea) IS 'args: WKB - Return a specified ST_Geometry value from Well-Known Binary representation (WKB). This is an alias name for ST_GeomFromWKB that takes no srid';


--
-- Name: st_wkttosql(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_wkttosql(text) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_from_text';


--
-- Name: FUNCTION st_wkttosql(text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_wkttosql(text) IS 'args: WKT - Return a specified ST_Geometry value from Well-Known Text representation (WKT). This is an alias name for ST_GeomFromText';


--
-- Name: st_x(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_x(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_x_point';


--
-- Name: FUNCTION st_x(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_x(geometry) IS 'args: a_point - Return the X coordinate of the point, or NULL if not available. Input must be a point.';


--
-- Name: st_xmax(box3d); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_xmax(box3d) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'BOX3D_xmax';


--
-- Name: FUNCTION st_xmax(box3d); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_xmax(box3d) IS 'args: aGeomorBox2DorBox3D - Returns X maxima of a bounding box 2d or 3d or a geometry.';


--
-- Name: st_xmin(box3d); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_xmin(box3d) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'BOX3D_xmin';


--
-- Name: FUNCTION st_xmin(box3d); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_xmin(box3d) IS 'args: aGeomorBox2DorBox3D - Returns X minima of a bounding box 2d or 3d or a geometry.';


--
-- Name: st_y(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_y(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_y_point';


--
-- Name: FUNCTION st_y(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_y(geometry) IS 'args: a_point - Return the Y coordinate of the point, or NULL if not available. Input must be a point.';


--
-- Name: st_ymax(box3d); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_ymax(box3d) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'BOX3D_ymax';


--
-- Name: FUNCTION st_ymax(box3d); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_ymax(box3d) IS 'args: aGeomorBox2DorBox3D - Returns Y maxima of a bounding box 2d or 3d or a geometry.';


--
-- Name: st_ymin(box3d); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_ymin(box3d) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'BOX3D_ymin';


--
-- Name: FUNCTION st_ymin(box3d); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_ymin(box3d) IS 'args: aGeomorBox2DorBox3D - Returns Y minima of a bounding box 2d or 3d or a geometry.';


--
-- Name: st_z(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_z(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_z_point';


--
-- Name: FUNCTION st_z(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_z(geometry) IS 'args: a_point - Return the Z coordinate of the point, or NULL if not available. Input must be a point.';


--
-- Name: st_zmax(box3d); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_zmax(box3d) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'BOX3D_zmax';


--
-- Name: FUNCTION st_zmax(box3d); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_zmax(box3d) IS 'args: aGeomorBox2DorBox3D - Returns Z minima of a bounding box 2d or 3d or a geometry.';


--
-- Name: st_zmflag(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_zmflag(geometry) RETURNS smallint
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_zmflag';


--
-- Name: FUNCTION st_zmflag(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_zmflag(geometry) IS 'args: geomA - Returns ZM (dimension semantic) flag of the geometries as a small int. Values are: 0=2d, 1=3dm, 2=3dz, 3=4d.';


--
-- Name: st_zmin(box3d); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_zmin(box3d) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'BOX3D_zmin';


--
-- Name: FUNCTION st_zmin(box3d); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION st_zmin(box3d) IS 'args: aGeomorBox2DorBox3D - Returns Z minima of a bounding box 2d or 3d or a geometry.';


--
-- Name: subarray(integer[], integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION subarray(integer[], integer) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'subarray';


--
-- Name: subarray(integer[], integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION subarray(integer[], integer, integer) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'subarray';


--
-- Name: text(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION text(geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.1', 'LWGEOM_to_text';


--
-- Name: translate(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION translate(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT translate($1, $2, $3, 0)$_$;


--
-- Name: translate(geometry, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION translate(geometry, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT affine($1, 1, 0, 0, 0, 1, 0, 0, 0, 1, $2, $3, $4)$_$;


--
-- Name: transscale(geometry, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION transscale(geometry, double precision, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT affine($1,  $4, 0, 0,  0, $5, 0,
    0, 0, 1,  $2 * $4, $3 * $5, 0)$_$;


--
-- Name: uniq(integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION uniq(integer[]) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'uniq';


--
-- Name: unlockrows(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION unlockrows(text) RETURNS integer
    LANGUAGE plpgsql STRICT
    AS $_$ 
DECLARE
  ret int;
BEGIN

  IF NOT LongTransactionsEnabled() THEN
    RAISE EXCEPTION 'Long transaction support disabled, use EnableLongTransaction() to enable.';
  END IF;

  EXECUTE 'DELETE FROM authorization_table where authid = ' ||
    quote_literal($1);

  GET DIAGNOSTICS ret = ROW_COUNT;

  RETURN ret;
END;
$_$;


--
-- Name: FUNCTION unlockrows(text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION unlockrows(text) IS 'args: auth_token - Remove all locks held by specified authorization id. Returns the number of locks released.';


--
-- Name: updategeometrysrid(character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION updategeometrysrid(character varying, character varying, integer) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
  ret  text;
BEGIN
  SELECT UpdateGeometrySRID('','',$1,$2,$3) into ret;
  RETURN ret;
END;
$_$;


--
-- Name: FUNCTION updategeometrysrid(character varying, character varying, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION updategeometrysrid(character varying, character varying, integer) IS 'args: table_name, column_name, srid - Updates the SRID of all features in a geometry column, geometry_columns metadata and srid. If it was enforced with constraints, the constraints will be updated with new srid constraint. If the old was enforced by type definition, the type definition will be changed.';


--
-- Name: updategeometrysrid(character varying, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION updategeometrysrid(character varying, character varying, character varying, integer) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
  ret  text;
BEGIN
  SELECT UpdateGeometrySRID('',$1,$2,$3,$4) into ret;
  RETURN ret;
END;
$_$;


--
-- Name: FUNCTION updategeometrysrid(character varying, character varying, character varying, integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION updategeometrysrid(character varying, character varying, character varying, integer) IS 'args: schema_name, table_name, column_name, srid - Updates the SRID of all features in a geometry column, geometry_columns metadata and srid. If it was enforced with constraints, the constraints will be updated with new srid constraint. If the old was enforced by type definition, the type definition will be changed.';


--
-- Name: updategeometrysrid(character varying, character varying, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION updategeometrysrid(catalogn_name character varying, schema_name character varying, table_name character varying, column_name character varying, new_srid_in integer) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $$
DECLARE
  myrec RECORD;
  okay boolean;
  cname varchar;
  real_schema name;
  unknown_srid integer;
  new_srid integer := new_srid_in;

BEGIN


  -- Find, check or fix schema_name
  IF ( schema_name != '' ) THEN
    okay = false;

    FOR myrec IN SELECT nspname FROM pg_namespace WHERE text(nspname) = schema_name LOOP
      okay := true;
    END LOOP;

    IF ( okay <> true ) THEN
      RAISE EXCEPTION 'Invalid schema name';
    ELSE
      real_schema = schema_name;
    END IF;
  ELSE
    SELECT INTO real_schema current_schema()::text;
  END IF;

  -- Ensure that column_name is in geometry_columns
  okay = false;
  FOR myrec IN SELECT type, coord_dimension FROM geometry_columns WHERE f_table_schema = text(real_schema) and f_table_name = table_name and f_geometry_column = column_name LOOP
    okay := true;
  END LOOP;
  IF (NOT okay) THEN
    RAISE EXCEPTION 'column not found in geometry_columns table';
    RETURN false;
  END IF;

  -- Ensure that new_srid is valid
  IF ( new_srid > 0 ) THEN
    IF ( SELECT count(*) = 0 from spatial_ref_sys where srid = new_srid ) THEN
      RAISE EXCEPTION 'invalid SRID: % not found in spatial_ref_sys', new_srid;
      RETURN false;
    END IF;
  ELSE
    unknown_srid := ST_SRID('POINT EMPTY'::geometry);
    IF ( new_srid != unknown_srid ) THEN
      new_srid := unknown_srid;
      RAISE NOTICE 'SRID value % converted to the officially unknown SRID value %', new_srid_in, new_srid;
    END IF;
  END IF;

  IF postgis_constraint_srid(schema_name, table_name, column_name) IS NOT NULL THEN 
  -- srid was enforced with constraints before, keep it that way.
        -- Make up constraint name
        cname = 'enforce_srid_'  || column_name;
    
        -- Drop enforce_srid constraint
        EXECUTE 'ALTER TABLE ' || quote_ident(real_schema) ||
            '.' || quote_ident(table_name) ||
            ' DROP constraint ' || quote_ident(cname);
    
        -- Update geometries SRID
        EXECUTE 'UPDATE ' || quote_ident(real_schema) ||
            '.' || quote_ident(table_name) ||
            ' SET ' || quote_ident(column_name) ||
            ' = ST_SetSRID(' || quote_ident(column_name) ||
            ', ' || new_srid::text || ')';
            
        -- Reset enforce_srid constraint
        EXECUTE 'ALTER TABLE ' || quote_ident(real_schema) ||
            '.' || quote_ident(table_name) ||
            ' ADD constraint ' || quote_ident(cname) ||
            ' CHECK (st_srid(' || quote_ident(column_name) ||
            ') = ' || new_srid::text || ')';
    ELSE 
        -- We will use typmod to enforce if no srid constraints
        -- We are using postgis_type_name to lookup the new name 
        -- (in case Paul changes his mind and flips geometry_columns to return old upper case name) 
        EXECUTE 'ALTER TABLE ' || quote_ident(real_schema) || '.' || quote_ident(table_name) || 
        ' ALTER COLUMN ' || quote_ident(column_name) || ' TYPE  geometry(' || postgis_type_name(myrec.type, myrec.coord_dimension, true) || ', ' || new_srid::text || ') USING ST_SetSRID(' || quote_ident(column_name) || ',' || new_srid::text || ');' ;
    END IF;

  RETURN real_schema || '.' || table_name || '.' || column_name ||' SRID changed to ' || new_srid::text;

END;
$$;


--
-- Name: FUNCTION updategeometrysrid(catalogn_name character varying, schema_name character varying, table_name character varying, column_name character varying, new_srid_in integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION updategeometrysrid(catalogn_name character varying, schema_name character varying, table_name character varying, column_name character varying, new_srid_in integer) IS 'args: catalog_name, schema_name, table_name, column_name, srid - Updates the SRID of all features in a geometry column, geometry_columns metadata and srid. If it was enforced with constraints, the constraints will be updated with new srid constraint. If the old was enforced by type definition, the type definition will be changed.';


--
-- Name: accum(geometry); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE accum(geometry) (
    SFUNC = pgis_geometry_accum_transfn,
    STYPE = pgis_abs,
    FINALFUNC = pgis_geometry_accum_finalfn
);


--
-- Name: collect(geometry); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE collect(geometry) (
    SFUNC = pgis_geometry_accum_transfn,
    STYPE = pgis_abs,
    FINALFUNC = pgis_geometry_collect_finalfn
);


--
-- Name: makeline(geometry); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE makeline(geometry) (
    SFUNC = pgis_geometry_accum_transfn,
    STYPE = pgis_abs,
    FINALFUNC = pgis_geometry_makeline_finalfn
);


--
-- Name: memcollect(geometry); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE memcollect(geometry) (
    SFUNC = public.st_collect,
    STYPE = geometry
);


--
-- Name: polygonize(geometry); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE polygonize(geometry) (
    SFUNC = pgis_geometry_accum_transfn,
    STYPE = pgis_abs,
    FINALFUNC = pgis_geometry_polygonize_finalfn
);


--
-- Name: st_3dextent(geometry); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE st_3dextent(geometry) (
    SFUNC = public.st_combine_bbox,
    STYPE = box3d
);


--
-- Name: AGGREGATE st_3dextent(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON AGGREGATE st_3dextent(geometry) IS 'args: geomfield - an aggregate function that returns the box3D bounding box that bounds rows of geometries.';


--
-- Name: st_accum(geometry); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE st_accum(geometry) (
    SFUNC = pgis_geometry_accum_transfn,
    STYPE = pgis_abs,
    FINALFUNC = pgis_geometry_accum_finalfn
);


--
-- Name: AGGREGATE st_accum(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON AGGREGATE st_accum(geometry) IS 'args: geomfield - Aggregate. Constructs an array of geometries.';


--
-- Name: st_collect(geometry); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE st_collect(geometry) (
    SFUNC = pgis_geometry_accum_transfn,
    STYPE = pgis_abs,
    FINALFUNC = pgis_geometry_collect_finalfn
);


--
-- Name: AGGREGATE st_collect(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON AGGREGATE st_collect(geometry) IS 'args: g1field - Return a specified ST_Geometry value from a collection of other geometries.';


--
-- Name: st_extent(geometry); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE st_extent(geometry) (
    SFUNC = public.st_combine_bbox,
    STYPE = box3d,
    FINALFUNC = public.box2d
);


--
-- Name: AGGREGATE st_extent(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON AGGREGATE st_extent(geometry) IS 'args: geomfield - an aggregate function that returns the bounding box that bounds rows of geometries.';


--
-- Name: st_extent3d(geometry); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE st_extent3d(geometry) (
    SFUNC = public.st_combine_bbox,
    STYPE = box3d
);


--
-- Name: st_makeline(geometry); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE st_makeline(geometry) (
    SFUNC = pgis_geometry_accum_transfn,
    STYPE = pgis_abs,
    FINALFUNC = pgis_geometry_makeline_finalfn
);


--
-- Name: AGGREGATE st_makeline(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON AGGREGATE st_makeline(geometry) IS 'args: geoms - Creates a Linestring from point or line geometries.';


--
-- Name: st_memcollect(geometry); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE st_memcollect(geometry) (
    SFUNC = public.st_collect,
    STYPE = geometry
);


--
-- Name: st_memunion(geometry); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE st_memunion(geometry) (
    SFUNC = public.st_union,
    STYPE = geometry
);


--
-- Name: AGGREGATE st_memunion(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON AGGREGATE st_memunion(geometry) IS 'args: geomfield - Same as ST_Union, only memory-friendly (uses less memory and more processor time).';


--
-- Name: st_polygonize(geometry); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE st_polygonize(geometry) (
    SFUNC = pgis_geometry_accum_transfn,
    STYPE = pgis_abs,
    FINALFUNC = pgis_geometry_polygonize_finalfn
);


--
-- Name: AGGREGATE st_polygonize(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON AGGREGATE st_polygonize(geometry) IS 'args: geomfield - Aggregate. Creates a GeometryCollection containing possible polygons formed from the constituent linework of a set of geometries.';


--
-- Name: st_union(geometry); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE st_union(geometry) (
    SFUNC = pgis_geometry_accum_transfn,
    STYPE = pgis_abs,
    FINALFUNC = pgis_geometry_union_finalfn
);


--
-- Name: AGGREGATE st_union(geometry); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON AGGREGATE st_union(geometry) IS 'args: g1field - Returns a geometry that represents the point set union of the Geometries.';


--
-- Name: #; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR # (
    PROCEDURE = icount,
    RIGHTARG = integer[]
);


--
-- Name: #; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR # (
    PROCEDURE = idx,
    LEFTARG = integer[],
    RIGHTARG = integer
);


--
-- Name: &; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR & (
    PROCEDURE = _int_inter,
    LEFTARG = integer[],
    RIGHTARG = integer[],
    COMMUTATOR = &
);


--
-- Name: &&; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR && (
    PROCEDURE = geometry_overlaps,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = &&,
    RESTRICT = gserialized_gist_sel_2d,
    JOIN = gserialized_gist_joinsel_2d
);


--
-- Name: &&; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR && (
    PROCEDURE = geography_overlaps,
    LEFTARG = geography,
    RIGHTARG = geography,
    COMMUTATOR = &&,
    RESTRICT = gserialized_gist_sel_nd,
    JOIN = gserialized_gist_joinsel_nd
);


--
-- Name: &&; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR && (
    PROCEDURE = _int_overlap,
    LEFTARG = integer[],
    RIGHTARG = integer[],
    COMMUTATOR = &&,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: &&&; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR &&& (
    PROCEDURE = geometry_overlaps_nd,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = &&&,
    RESTRICT = gserialized_gist_sel_nd,
    JOIN = gserialized_gist_joinsel_nd
);


--
-- Name: &<; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR &< (
    PROCEDURE = geometry_overleft,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = &>,
    RESTRICT = positionsel,
    JOIN = positionjoinsel
);


--
-- Name: &<|; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR &<| (
    PROCEDURE = geometry_overbelow,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = |&>,
    RESTRICT = positionsel,
    JOIN = positionjoinsel
);


--
-- Name: &>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR &> (
    PROCEDURE = geometry_overright,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = &<,
    RESTRICT = positionsel,
    JOIN = positionjoinsel
);


--
-- Name: +; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR + (
    PROCEDURE = intarray_push_elem,
    LEFTARG = integer[],
    RIGHTARG = integer
);


--
-- Name: +; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR + (
    PROCEDURE = intarray_push_array,
    LEFTARG = integer[],
    RIGHTARG = integer[],
    COMMUTATOR = +
);


--
-- Name: -; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR - (
    PROCEDURE = intarray_del_elem,
    LEFTARG = integer[],
    RIGHTARG = integer
);


--
-- Name: -; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR - (
    PROCEDURE = intset_subtract,
    LEFTARG = integer[],
    RIGHTARG = integer[]
);


--
-- Name: <; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR < (
    PROCEDURE = geometry_lt,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: <; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR < (
    PROCEDURE = geography_lt,
    LEFTARG = geography,
    RIGHTARG = geography,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: <#>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR <#> (
    PROCEDURE = geometry_distance_box,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = <#>
);


--
-- Name: <->; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR <-> (
    PROCEDURE = geometry_distance_centroid,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = <->
);


--
-- Name: <<; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR << (
    PROCEDURE = geometry_left,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = >>,
    RESTRICT = positionsel,
    JOIN = positionjoinsel
);


--
-- Name: <<|; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR <<| (
    PROCEDURE = geometry_below,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = |>>,
    RESTRICT = positionsel,
    JOIN = positionjoinsel
);


--
-- Name: <=; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR <= (
    PROCEDURE = geometry_le,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: <=; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR <= (
    PROCEDURE = geography_le,
    LEFTARG = geography,
    RIGHTARG = geography,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: <@; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR <@ (
    PROCEDURE = _int_contained,
    LEFTARG = integer[],
    RIGHTARG = integer[],
    COMMUTATOR = @>,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: =; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR = (
    PROCEDURE = geometry_eq,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = =,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: =; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR = (
    PROCEDURE = geography_eq,
    LEFTARG = geography,
    RIGHTARG = geography,
    COMMUTATOR = =,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: >; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR > (
    PROCEDURE = geometry_gt,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: >; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR > (
    PROCEDURE = geography_gt,
    LEFTARG = geography,
    RIGHTARG = geography,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: >=; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR >= (
    PROCEDURE = geometry_ge,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: >=; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR >= (
    PROCEDURE = geography_ge,
    LEFTARG = geography,
    RIGHTARG = geography,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: >>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR >> (
    PROCEDURE = geometry_right,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = <<,
    RESTRICT = positionsel,
    JOIN = positionjoinsel
);


--
-- Name: @; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR @ (
    PROCEDURE = geometry_within,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = ~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: @; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR @ (
    PROCEDURE = _int_contains,
    LEFTARG = integer[],
    RIGHTARG = integer[],
    COMMUTATOR = ~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: @>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR @> (
    PROCEDURE = _int_contains,
    LEFTARG = integer[],
    RIGHTARG = integer[],
    COMMUTATOR = <@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: @@; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR @@ (
    PROCEDURE = boolop,
    LEFTARG = integer[],
    RIGHTARG = query_int,
    COMMUTATOR = ~~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: |; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR | (
    PROCEDURE = intset_union_elem,
    LEFTARG = integer[],
    RIGHTARG = integer
);


--
-- Name: |; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR | (
    PROCEDURE = _int_union,
    LEFTARG = integer[],
    RIGHTARG = integer[],
    COMMUTATOR = |
);


--
-- Name: |&>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR |&> (
    PROCEDURE = geometry_overabove,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = &<|,
    RESTRICT = positionsel,
    JOIN = positionjoinsel
);


--
-- Name: |>>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR |>> (
    PROCEDURE = geometry_above,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = <<|,
    RESTRICT = positionsel,
    JOIN = positionjoinsel
);


--
-- Name: ~; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ~ (
    PROCEDURE = geometry_contains,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = @,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: ~; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ~ (
    PROCEDURE = _int_contained,
    LEFTARG = integer[],
    RIGHTARG = integer[],
    COMMUTATOR = @,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: ~=; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ~= (
    PROCEDURE = geometry_same,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: ~~; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ~~ (
    PROCEDURE = rboolop,
    LEFTARG = query_int,
    RIGHTARG = integer[],
    COMMUTATOR = @@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: btree_geography_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS btree_geography_ops
    DEFAULT FOR TYPE geography USING btree AS
    OPERATOR 1 <(geography,geography) ,
    OPERATOR 2 <=(geography,geography) ,
    OPERATOR 3 =(geography,geography) ,
    OPERATOR 4 >=(geography,geography) ,
    OPERATOR 5 >(geography,geography) ,
    FUNCTION 1 (geography, geography) geography_cmp(geography,geography);


--
-- Name: btree_geometry_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS btree_geometry_ops
    DEFAULT FOR TYPE geometry USING btree AS
    OPERATOR 1 <(geometry,geometry) ,
    OPERATOR 2 <=(geometry,geometry) ,
    OPERATOR 3 =(geometry,geometry) ,
    OPERATOR 4 >=(geometry,geometry) ,
    OPERATOR 5 >(geometry,geometry) ,
    FUNCTION 1 (geometry, geometry) geometry_cmp(geometry,geometry);


--
-- Name: gin__int_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS gin__int_ops
    FOR TYPE integer[] USING gin AS
    STORAGE integer ,
    OPERATOR 3 &&(integer[],integer[]) ,
    OPERATOR 6 =(anyarray,anyarray) ,
    OPERATOR 7 @>(integer[],integer[]) ,
    OPERATOR 8 <@(integer[],integer[]) ,
    OPERATOR 13 @(integer[],integer[]) ,
    OPERATOR 14 ~(integer[],integer[]) ,
    OPERATOR 20 @@(integer[],query_int) ,
    FUNCTION 1 (integer[], integer[]) btint4cmp(integer,integer) ,
    FUNCTION 2 (integer[], integer[]) ginarrayextract(anyarray,internal) ,
    FUNCTION 3 (integer[], integer[]) ginint4_queryextract(internal,internal,smallint,internal,internal) ,
    FUNCTION 4 (integer[], integer[]) ginint4_consistent(internal,smallint,internal,integer,internal,internal);


--
-- Name: gist__int_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS gist__int_ops
    DEFAULT FOR TYPE integer[] USING gist AS
    OPERATOR 3 &&(integer[],integer[]) ,
    OPERATOR 6 =(anyarray,anyarray) ,
    OPERATOR 7 @>(integer[],integer[]) ,
    OPERATOR 8 <@(integer[],integer[]) ,
    OPERATOR 13 @(integer[],integer[]) ,
    OPERATOR 14 ~(integer[],integer[]) ,
    OPERATOR 20 @@(integer[],query_int) ,
    FUNCTION 1 (integer[], integer[]) g_int_consistent(internal,integer[],integer,oid,internal) ,
    FUNCTION 2 (integer[], integer[]) g_int_union(internal,internal) ,
    FUNCTION 3 (integer[], integer[]) g_int_compress(internal) ,
    FUNCTION 4 (integer[], integer[]) g_int_decompress(internal) ,
    FUNCTION 5 (integer[], integer[]) g_int_penalty(internal,internal,internal) ,
    FUNCTION 6 (integer[], integer[]) g_int_picksplit(internal,internal) ,
    FUNCTION 7 (integer[], integer[]) g_int_same(integer[],integer[],internal);


--
-- Name: gist__intbig_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS gist__intbig_ops
    FOR TYPE integer[] USING gist AS
    STORAGE intbig_gkey ,
    OPERATOR 3 &&(integer[],integer[]) ,
    OPERATOR 6 =(anyarray,anyarray) ,
    OPERATOR 7 @>(integer[],integer[]) ,
    OPERATOR 8 <@(integer[],integer[]) ,
    OPERATOR 13 @(integer[],integer[]) ,
    OPERATOR 14 ~(integer[],integer[]) ,
    OPERATOR 20 @@(integer[],query_int) ,
    FUNCTION 1 (integer[], integer[]) g_intbig_consistent(internal,internal,integer,oid,internal) ,
    FUNCTION 2 (integer[], integer[]) g_intbig_union(internal,internal) ,
    FUNCTION 3 (integer[], integer[]) g_intbig_compress(internal) ,
    FUNCTION 4 (integer[], integer[]) g_intbig_decompress(internal) ,
    FUNCTION 5 (integer[], integer[]) g_intbig_penalty(internal,internal,internal) ,
    FUNCTION 6 (integer[], integer[]) g_intbig_picksplit(internal,internal) ,
    FUNCTION 7 (integer[], integer[]) g_intbig_same(internal,internal,internal);


--
-- Name: gist_geography_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS gist_geography_ops
    DEFAULT FOR TYPE geography USING gist AS
    STORAGE gidx ,
    OPERATOR 3 &&(geography,geography) ,
    FUNCTION 1 (geography, geography) geography_gist_consistent(internal,geography,integer) ,
    FUNCTION 2 (geography, geography) geography_gist_union(bytea,internal) ,
    FUNCTION 3 (geography, geography) geography_gist_compress(internal) ,
    FUNCTION 4 (geography, geography) geography_gist_decompress(internal) ,
    FUNCTION 5 (geography, geography) geography_gist_penalty(internal,internal,internal) ,
    FUNCTION 6 (geography, geography) geography_gist_picksplit(internal,internal) ,
    FUNCTION 7 (geography, geography) geography_gist_same(box2d,box2d,internal);


--
-- Name: gist_geometry_ops_2d; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS gist_geometry_ops_2d
    DEFAULT FOR TYPE geometry USING gist AS
    STORAGE box2df ,
    OPERATOR 1 <<(geometry,geometry) ,
    OPERATOR 2 &<(geometry,geometry) ,
    OPERATOR 3 &&(geometry,geometry) ,
    OPERATOR 4 &>(geometry,geometry) ,
    OPERATOR 5 >>(geometry,geometry) ,
    OPERATOR 6 ~=(geometry,geometry) ,
    OPERATOR 7 ~(geometry,geometry) ,
    OPERATOR 8 @(geometry,geometry) ,
    OPERATOR 9 &<|(geometry,geometry) ,
    OPERATOR 10 <<|(geometry,geometry) ,
    OPERATOR 11 |>>(geometry,geometry) ,
    OPERATOR 12 |&>(geometry,geometry) ,
    OPERATOR 13 <->(geometry,geometry) FOR ORDER BY pg_catalog.float_ops ,
    OPERATOR 14 <#>(geometry,geometry) FOR ORDER BY pg_catalog.float_ops ,
    FUNCTION 1 (geometry, geometry) geometry_gist_consistent_2d(internal,geometry,integer) ,
    FUNCTION 2 (geometry, geometry) geometry_gist_union_2d(bytea,internal) ,
    FUNCTION 3 (geometry, geometry) geometry_gist_compress_2d(internal) ,
    FUNCTION 4 (geometry, geometry) geometry_gist_decompress_2d(internal) ,
    FUNCTION 5 (geometry, geometry) geometry_gist_penalty_2d(internal,internal,internal) ,
    FUNCTION 6 (geometry, geometry) geometry_gist_picksplit_2d(internal,internal) ,
    FUNCTION 7 (geometry, geometry) geometry_gist_same_2d(geometry,geometry,internal) ,
    FUNCTION 8 (geometry, geometry) geometry_gist_distance_2d(internal,geometry,integer);


--
-- Name: gist_geometry_ops_nd; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS gist_geometry_ops_nd
    FOR TYPE geometry USING gist AS
    STORAGE gidx ,
    OPERATOR 3 &&&(geometry,geometry) ,
    FUNCTION 1 (geometry, geometry) geometry_gist_consistent_nd(internal,geometry,integer) ,
    FUNCTION 2 (geometry, geometry) geometry_gist_union_nd(bytea,internal) ,
    FUNCTION 3 (geometry, geometry) geometry_gist_compress_nd(internal) ,
    FUNCTION 4 (geometry, geometry) geometry_gist_decompress_nd(internal) ,
    FUNCTION 5 (geometry, geometry) geometry_gist_penalty_nd(internal,internal,internal) ,
    FUNCTION 6 (geometry, geometry) geometry_gist_picksplit_nd(internal,internal) ,
    FUNCTION 7 (geometry, geometry) geometry_gist_same_nd(geometry,geometry,internal);


SET search_path = pg_catalog;

--
-- Name: CAST (public.box2d AS public.box3d); Type: CAST; Schema: pg_catalog; Owner: -
--

CREATE CAST (public.box2d AS public.box3d) WITH FUNCTION public.box3d(public.box2d) AS IMPLICIT;


--
-- Name: CAST (public.box2d AS public.geometry); Type: CAST; Schema: pg_catalog; Owner: -
--

CREATE CAST (public.box2d AS public.geometry) WITH FUNCTION public.geometry(public.box2d) AS IMPLICIT;


--
-- Name: CAST (public.box3d AS box); Type: CAST; Schema: pg_catalog; Owner: -
--

CREATE CAST (public.box3d AS box) WITH FUNCTION public.box(public.box3d) AS IMPLICIT;


--
-- Name: CAST (public.box3d AS public.box2d); Type: CAST; Schema: pg_catalog; Owner: -
--

CREATE CAST (public.box3d AS public.box2d) WITH FUNCTION public.box2d(public.box3d) AS IMPLICIT;


--
-- Name: CAST (public.box3d AS public.geometry); Type: CAST; Schema: pg_catalog; Owner: -
--

CREATE CAST (public.box3d AS public.geometry) WITH FUNCTION public.geometry(public.box3d) AS IMPLICIT;


--
-- Name: CAST (bytea AS public.geography); Type: CAST; Schema: pg_catalog; Owner: -
--

CREATE CAST (bytea AS public.geography) WITH FUNCTION public.geography(bytea) AS IMPLICIT;


--
-- Name: CAST (bytea AS public.geometry); Type: CAST; Schema: pg_catalog; Owner: -
--

CREATE CAST (bytea AS public.geometry) WITH FUNCTION public.geometry(bytea) AS IMPLICIT;


--
-- Name: CAST (public.geography AS bytea); Type: CAST; Schema: pg_catalog; Owner: -
--

CREATE CAST (public.geography AS bytea) WITH FUNCTION public.bytea(public.geography) AS IMPLICIT;


--
-- Name: CAST (public.geography AS public.geography); Type: CAST; Schema: pg_catalog; Owner: -
--

CREATE CAST (public.geography AS public.geography) WITH FUNCTION public.geography(public.geography, integer, boolean) AS IMPLICIT;


--
-- Name: CAST (public.geography AS public.geometry); Type: CAST; Schema: pg_catalog; Owner: -
--

CREATE CAST (public.geography AS public.geometry) WITH FUNCTION public.geometry(public.geography);


--
-- Name: CAST (public.geometry AS box); Type: CAST; Schema: pg_catalog; Owner: -
--

CREATE CAST (public.geometry AS box) WITH FUNCTION public.box(public.geometry) AS ASSIGNMENT;


--
-- Name: CAST (public.geometry AS public.box2d); Type: CAST; Schema: pg_catalog; Owner: -
--

CREATE CAST (public.geometry AS public.box2d) WITH FUNCTION public.box2d(public.geometry) AS IMPLICIT;


--
-- Name: CAST (public.geometry AS public.box3d); Type: CAST; Schema: pg_catalog; Owner: -
--

CREATE CAST (public.geometry AS public.box3d) WITH FUNCTION public.box3d(public.geometry) AS IMPLICIT;


--
-- Name: CAST (public.geometry AS bytea); Type: CAST; Schema: pg_catalog; Owner: -
--

CREATE CAST (public.geometry AS bytea) WITH FUNCTION public.bytea(public.geometry) AS IMPLICIT;


--
-- Name: CAST (public.geometry AS public.geography); Type: CAST; Schema: pg_catalog; Owner: -
--

CREATE CAST (public.geometry AS public.geography) WITH FUNCTION public.geography(public.geometry) AS IMPLICIT;


--
-- Name: CAST (public.geometry AS public.geometry); Type: CAST; Schema: pg_catalog; Owner: -
--

CREATE CAST (public.geometry AS public.geometry) WITH FUNCTION public.geometry(public.geometry, integer, boolean) AS IMPLICIT;


--
-- Name: CAST (public.geometry AS path); Type: CAST; Schema: pg_catalog; Owner: -
--

CREATE CAST (public.geometry AS path) WITH FUNCTION public.path(public.geometry);


--
-- Name: CAST (public.geometry AS point); Type: CAST; Schema: pg_catalog; Owner: -
--

CREATE CAST (public.geometry AS point) WITH FUNCTION public.point(public.geometry);


--
-- Name: CAST (public.geometry AS polygon); Type: CAST; Schema: pg_catalog; Owner: -
--

CREATE CAST (public.geometry AS polygon) WITH FUNCTION public.polygon(public.geometry);


--
-- Name: CAST (public.geometry AS text); Type: CAST; Schema: pg_catalog; Owner: -
--

CREATE CAST (public.geometry AS text) WITH FUNCTION public.text(public.geometry) AS IMPLICIT;


--
-- Name: CAST (path AS public.geometry); Type: CAST; Schema: pg_catalog; Owner: -
--

CREATE CAST (path AS public.geometry) WITH FUNCTION public.geometry(path);


--
-- Name: CAST (point AS public.geometry); Type: CAST; Schema: pg_catalog; Owner: -
--

CREATE CAST (point AS public.geometry) WITH FUNCTION public.geometry(point);


--
-- Name: CAST (polygon AS public.geometry); Type: CAST; Schema: pg_catalog; Owner: -
--

CREATE CAST (polygon AS public.geometry) WITH FUNCTION public.geometry(polygon);


--
-- Name: CAST (text AS public.geometry); Type: CAST; Schema: pg_catalog; Owner: -
--

CREATE CAST (text AS public.geometry) WITH FUNCTION public.geometry(text) AS IMPLICIT;


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: changes_history_records; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE changes_history_records (
    id integer NOT NULL,
    user_id integer,
    "when" timestamp without time zone,
    how text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    what_id integer,
    what_type character varying(255),
    reviewed boolean DEFAULT false,
    who_email character varying(255),
    who_organization character varying(255)
);


--
-- Name: changes_histories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE changes_histories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: changes_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE changes_histories_id_seq OWNED BY changes_history_records.id;


--
-- Name: changes_history_records_copy; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE changes_history_records_copy (
    id integer NOT NULL,
    user_id integer,
    "when" timestamp without time zone,
    how text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    what_id integer,
    what_type character varying(255),
    reviewed boolean,
    who_email character varying(255),
    who_organization character varying(255)
);


--
-- Name: clusters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE clusters (
    id integer NOT NULL,
    name character varying(255)
);


--
-- Name: clusters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE clusters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clusters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE clusters_id_seq OWNED BY clusters.id;


--
-- Name: clusters_projects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE clusters_projects (
    cluster_id integer,
    project_id integer
);


--
-- Name: countries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE countries (
    id integer NOT NULL,
    name character varying(255),
    code character varying(255),
    the_geom geometry,
    wiki_url character varying(255),
    wiki_description text,
    iso2_code character varying(255),
    iso3_code character varying(255),
    center_lat double precision,
    center_lon double precision,
    the_geom_geojson text,
    CONSTRAINT enforce_dims_the_geom CHECK ((st_ndims(the_geom) = 2)),
    CONSTRAINT enforce_geotype_the_geom CHECK (((geometrytype(the_geom) = 'MULTIPOLYGON'::text) OR (the_geom IS NULL))),
    CONSTRAINT enforce_srid_the_geom CHECK ((st_srid(the_geom) = 4326))
);


--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE countries_id_seq OWNED BY countries.id;


--
-- Name: countries_projects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE countries_projects (
    country_id integer NOT NULL,
    project_id integer NOT NULL
);


--
-- Name: data_denormalization; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE data_denormalization (
    project_id integer,
    project_name character varying(2000),
    project_description text,
    organization_id integer,
    organization_name character varying(2000),
    end_date date,
    regions text,
    regions_ids integer[],
    countries text,
    countries_ids integer[],
    sectors text,
    sector_ids integer[],
    clusters text,
    cluster_ids integer[],
    donors_ids integer[],
    is_active boolean,
    site_id integer,
    created_at timestamp without time zone,
    start_date date
);


--
-- Name: data_export; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE data_export (
    project_id integer,
    project_name character varying(2000),
    project_description text,
    organization_id integer,
    organization_name character varying(2000),
    implementing_organization text,
    partner_organizations text,
    cross_cutting_issues text,
    start_date date,
    end_date date,
    budget double precision,
    target text,
    estimated_people_reached bigint,
    project_contact_person character varying(255),
    project_contact_email character varying(255),
    project_contact_phone_number character varying(255),
    activities text,
    intervention_id character varying(255),
    additional_information text,
    awardee_type character varying(255),
    date_provided date,
    date_updated date,
    project_contact_position character varying(255),
    project_website character varying(255),
    verbatim_location text,
    calculation_of_number_of_people_reached text,
    project_needs text,
    sectors text,
    clusters text,
    project_tags text,
    countries text,
    regions_level1 text,
    regions_level2 text,
    regions_level3 text
);


--
-- Name: donations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE donations (
    id integer NOT NULL,
    donor_id integer,
    project_id integer,
    amount double precision,
    date date,
    office_id integer
);


--
-- Name: donations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE donations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: donations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE donations_id_seq OWNED BY donations.id;


--
-- Name: donors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE donors (
    id integer NOT NULL,
    name character varying(2000),
    description text,
    website character varying(255),
    twitter character varying(255),
    facebook character varying(255),
    contact_person_name character varying(255),
    contact_company character varying(255),
    contact_person_position character varying(255),
    contact_email character varying(255),
    contact_phone_number character varying(255),
    logo_file_name character varying(255),
    logo_content_type character varying(255),
    logo_file_size integer,
    logo_updated_at timestamp without time zone,
    site_specific_information text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    iati_organizationid character varying(255),
    organization_type character varying(255),
    organization_type_code integer
);


--
-- Name: donors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE donors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: donors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE donors_id_seq OWNED BY donors.id;


--
-- Name: geography_columns; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW geography_columns AS
 SELECT current_database() AS f_table_catalog,
    n.nspname AS f_table_schema,
    c.relname AS f_table_name,
    a.attname AS f_geography_column,
    postgis_typmod_dims(a.atttypmod) AS coord_dimension,
    postgis_typmod_srid(a.atttypmod) AS srid,
    postgis_typmod_type(a.atttypmod) AS type
   FROM pg_class c,
    pg_attribute a,
    pg_type t,
    pg_namespace n
  WHERE (((((((t.typname = 'geography'::name) AND (a.attisdropped = false)) AND (a.atttypid = t.oid)) AND (a.attrelid = c.oid)) AND (c.relnamespace = n.oid)) AND (NOT pg_is_other_temp_schema(c.relnamespace))) AND has_table_privilege(c.oid, 'SELECT'::text));


--
-- Name: geolocations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE geolocations (
    id integer NOT NULL,
    uid character varying,
    name character varying,
    latitude double precision,
    longitude double precision,
    fclass character varying,
    fcode character varying,
    country_code character varying,
    country_name character varying,
    country_uid character varying,
    cc2 character varying,
    admin1 character varying,
    admin2 character varying,
    admin3 character varying,
    admin4 character varying,
    provider character varying DEFAULT 'Geonames'::character varying,
    adm_level integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    g0 character varying,
    g1 character varying,
    g2 character varying,
    g3 character varying,
    g4 character varying,
    custom_geo_source character varying
);


--
-- Name: geolocations_projects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE geolocations_projects (
    geolocation_id integer,
    project_id integer
);


--
-- Name: geometry_columns; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW geometry_columns AS
 SELECT (current_database())::character varying(256) AS f_table_catalog,
    (n.nspname)::character varying(256) AS f_table_schema,
    (c.relname)::character varying(256) AS f_table_name,
    (a.attname)::character varying(256) AS f_geometry_column,
    COALESCE(NULLIF(postgis_typmod_dims(a.atttypmod), 2), postgis_constraint_dims((n.nspname)::text, (c.relname)::text, (a.attname)::text), 2) AS coord_dimension,
    COALESCE(NULLIF(postgis_typmod_srid(a.atttypmod), 0), postgis_constraint_srid((n.nspname)::text, (c.relname)::text, (a.attname)::text), 0) AS srid,
    (replace(replace(COALESCE(NULLIF(upper(postgis_typmod_type(a.atttypmod)), 'GEOMETRY'::text), (postgis_constraint_type((n.nspname)::text, (c.relname)::text, (a.attname)::text))::text, 'GEOMETRY'::text), 'ZM'::text, ''::text), 'Z'::text, ''::text))::character varying(30) AS type
   FROM pg_class c,
    pg_attribute a,
    pg_type t,
    pg_namespace n
  WHERE (((((((((t.typname = 'geometry'::name) AND (a.attisdropped = false)) AND (a.atttypid = t.oid)) AND (a.attrelid = c.oid)) AND (c.relnamespace = n.oid)) AND ((((c.relkind = 'r'::"char") OR (c.relkind = 'v'::"char")) OR (c.relkind = 'm'::"char")) OR (c.relkind = 'f'::"char"))) AND (NOT pg_is_other_temp_schema(c.relnamespace))) AND (NOT ((n.nspname = 'public'::name) AND (c.relname = 'raster_columns'::name)))) AND has_table_privilege(c.oid, 'SELECT'::text));


--
-- Name: layer_styles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE layer_styles (
    id integer NOT NULL,
    title character varying(255),
    name character varying(255)
);


--
-- Name: layer_styles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE layer_styles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: layer_styles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE layer_styles_id_seq OWNED BY layer_styles.id;


--
-- Name: layers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE layers (
    id integer NOT NULL,
    title character varying(255),
    description text,
    credits text,
    date timestamp without time zone,
    min double precision,
    max double precision,
    units character varying(255),
    status boolean,
    cartodb_table character varying(255),
    sql text,
    long_title character varying(255)
);


--
-- Name: layers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE layers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: layers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE layers_id_seq OWNED BY layers.id;


--
-- Name: media_resources; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE media_resources (
    id integer NOT NULL,
    "position" integer DEFAULT 0,
    element_id integer,
    element_type integer,
    picture_file_name character varying(255),
    picture_content_type character varying(255),
    picture_filesize integer,
    picture_updated_at timestamp without time zone,
    video_url character varying(255),
    video_embed_html text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    caption character varying(255),
    video_thumb_file_name character varying(255),
    video_thumb_content_type character varying(255),
    video_thumb_file_size integer,
    video_thumb_updated_at timestamp without time zone
);


--
-- Name: media_resources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_resources_id_seq OWNED BY media_resources.id;


--
-- Name: offices; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE offices (
    id integer NOT NULL,
    donor_id integer,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: offices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE offices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: offices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE offices_id_seq OWNED BY offices.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE organizations (
    id integer NOT NULL,
    name character varying(255),
    description text,
    budget double precision,
    website character varying(255),
    national_staff integer,
    twitter character varying(255),
    facebook character varying(255),
    hq_address character varying(255),
    contact_email character varying(255),
    contact_phone_number character varying(255),
    donation_address character varying(255),
    zip_code character varying(255),
    city character varying(255),
    state character varying(255),
    donation_phone_number character varying(255),
    donation_website character varying(255),
    site_specific_information text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    logo_file_name character varying(255),
    logo_content_type character varying(255),
    logo_file_size integer,
    logo_updated_at timestamp without time zone,
    international_staff character varying(255),
    contact_name character varying(255),
    contact_position character varying(255),
    contact_zip character varying(255),
    contact_city character varying(255),
    contact_state character varying(255),
    contact_country character varying(255),
    donation_country character varying(255),
    estimated_people_reached integer,
    private_funding double precision,
    usg_funding double precision,
    other_funding double precision,
    private_funding_spent double precision,
    usg_funding_spent double precision,
    other_funding_spent double precision,
    spent_funding_on_relief double precision,
    spent_funding_on_reconstruction double precision,
    percen_relief integer,
    percen_reconstruction integer,
    media_contact_name character varying(255),
    media_contact_position character varying(255),
    media_contact_phone_number character varying(255),
    media_contact_email character varying(255),
    main_data_contact_name character varying(255),
    main_data_contact_position character varying(255),
    main_data_contact_phone_number character varying(255),
    main_data_contact_email character varying(255),
    main_data_contact_zip character varying(255),
    main_data_contact_city character varying(255),
    main_data_contact_state character varying(255),
    main_data_contact_country character varying(255),
    organization_id character varying(255),
    organization_type character varying(255),
    organization_type_code integer,
    iati_organizationid character varying(255),
    publishing_to_iati boolean DEFAULT false,
    membership_status character varying(255) DEFAULT 'Non Member'::character varying,
    interaction_member boolean DEFAULT false
);


--
-- Name: organizations2; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE organizations2 (
    id integer NOT NULL,
    name character varying(255),
    description text,
    budget double precision,
    website character varying(255),
    national_staff integer,
    twitter character varying(255),
    facebook character varying(255),
    hq_address character varying(255),
    contact_email character varying(255),
    contact_phone_number character varying(255),
    donation_address character varying(255),
    zip_code character varying(255),
    city character varying(255),
    state character varying(255),
    donation_phone_number character varying(255),
    donation_website character varying(255),
    site_specific_information text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    logo_file_name character varying(255),
    logo_content_type character varying(255),
    logo_file_size integer,
    logo_updated_at timestamp without time zone,
    international_staff character varying(255),
    contact_name character varying(255),
    contact_position character varying(255),
    contact_zip character varying(255),
    contact_city character varying(255),
    contact_state character varying(255),
    contact_country character varying(255),
    donation_country character varying(255),
    estimated_people_reached integer,
    private_funding double precision,
    usg_funding double precision,
    other_funding double precision,
    private_funding_spent double precision,
    usg_funding_spent double precision,
    other_funding_spent double precision,
    spent_funding_on_relief double precision,
    spent_funding_on_reconstruction double precision,
    percen_relief integer,
    percen_reconstruction integer,
    media_contact_name character varying(255),
    media_contact_position character varying(255),
    media_contact_phone_number character varying(255),
    media_contact_email character varying(255)
);


--
-- Name: organizations2_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE organizations2_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations2_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE organizations2_id_seq OWNED BY organizations2.id;


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE organizations_id_seq OWNED BY organizations.id;


--
-- Name: organizations_projects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE organizations_projects (
    organization_id integer,
    project_id integer
);


--
-- Name: pages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pages (
    id integer NOT NULL,
    title character varying(255),
    body text,
    site_id integer,
    published boolean,
    permalink character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    parent_id integer,
    order_index integer
);


--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pages_id_seq OWNED BY pages.id;


--
-- Name: partners; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE partners (
    id integer NOT NULL,
    site_id integer,
    name character varying(255),
    url character varying(255),
    logo_file_name character varying(255),
    logo_content_type character varying(255),
    logo_file_size integer,
    logo_updated_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    label character varying(255)
);


--
-- Name: partners_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE partners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: partners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE partners_id_seq OWNED BY partners.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE projects (
    id integer NOT NULL,
    name character varying(2000),
    description text,
    primary_organization_id integer,
    implementing_organization text,
    partner_organizations text,
    cross_cutting_issues text,
    start_date date,
    end_date date,
    budget double precision,
    target text,
    estimated_people_reached bigint,
    contact_person character varying(255),
    contact_email character varying(255),
    contact_phone_number character varying(255),
    site_specific_information text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    the_geom geometry,
    activities text,
    intervention_id character varying(255),
    additional_information text,
    awardee_type character varying(255),
    date_provided date,
    date_updated date,
    contact_position character varying(255),
    website character varying(255),
    verbatim_location text,
    calculation_of_number_of_people_reached text,
    project_needs text,
    idprefugee_camp text,
    organization_id character varying(255),
    budget_currency character varying(255) DEFAULT 'USD'::character varying,
    budget_value_date date,
    target_project_reach double precision,
    actual_project_reach double precision,
    project_reach_unit character varying(255) DEFAULT 'individuals'::character varying,
    prime_awardee_id integer,
    geographical_scope character varying(255) DEFAULT 'regional'::character varying,
    CONSTRAINT enforce_dims_the_geom CHECK ((st_ndims(the_geom) = 2)),
    CONSTRAINT enforce_srid_the_geom CHECK ((st_srid(the_geom) = 4326))
);


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE projects_id_seq OWNED BY projects.id;


--
-- Name: projects_regions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE projects_regions (
    region_id integer,
    project_id integer
);


--
-- Name: projects_sectors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE projects_sectors (
    sector_id integer,
    project_id integer
);


--
-- Name: projects_sites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE projects_sites (
    project_id integer,
    site_id integer
);


--
-- Name: projects_synchronizations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE projects_synchronizations (
    id integer NOT NULL,
    projects_file_data text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: projects_synchronizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE projects_synchronizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_synchronizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE projects_synchronizations_id_seq OWNED BY projects_synchronizations.id;


--
-- Name: projects_tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE projects_tags (
    tag_id integer,
    project_id integer
);


--
-- Name: regions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE regions (
    id integer NOT NULL,
    name character varying(255),
    level integer,
    country_id integer,
    parent_region_id integer,
    the_geom geometry,
    gadm_id integer,
    wiki_url character varying(255),
    wiki_description text,
    code character varying(255),
    center_lat double precision,
    center_lon double precision,
    the_geom_geojson text,
    ia_name text,
    path character varying(255),
    CONSTRAINT enforce_dims_the_geom CHECK ((st_ndims(the_geom) = 2)),
    CONSTRAINT enforce_srid_the_geom CHECK ((st_srid(the_geom) = 4326))
);


--
-- Name: regions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE regions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE regions_id_seq OWNED BY regions.id;


--
-- Name: resources; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE resources (
    id integer NOT NULL,
    title character varying(255),
    url character varying(255),
    element_id integer,
    element_type integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    site_specific_information text
);


--
-- Name: resources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE resources_id_seq OWNED BY resources.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: sectors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sectors (
    id integer NOT NULL,
    name character varying(255),
    oecd_dac_name character varying(255),
    oecd_dac_purpose_code character varying(255),
    oec_dac_name character varying(255),
    sector_vocab_code character varying(255),
    oec_dac_purpose_code character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sectors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sectors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sectors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sectors_id_seq OWNED BY sectors.id;


--
-- Name: settings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE settings (
    id integer NOT NULL,
    data text
);


--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE settings_id_seq OWNED BY settings.id;


--
-- Name: site_layers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE site_layers (
    site_id integer,
    layer_id integer,
    layer_style_id integer
);


--
-- Name: sites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sites (
    id integer NOT NULL,
    name character varying(255),
    short_description text,
    long_description text,
    contact_email character varying(255),
    contact_person character varying(255),
    url character varying(255),
    permalink character varying(255),
    google_analytics_id character varying(255),
    logo_file_name character varying(255),
    logo_content_type character varying(255),
    logo_file_size integer,
    logo_updated_at timestamp without time zone,
    theme_id integer,
    blog_url character varying(255),
    word_for_clusters character varying(255),
    word_for_regions character varying(255),
    show_global_donations_raises boolean DEFAULT false,
    project_classification integer DEFAULT 0,
    geographic_context_country_id character varying,
    geographic_context_region_id integer,
    project_context_cluster_id integer,
    project_context_sector_id integer,
    project_context_organization_id integer,
    project_context_tags character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    geographic_context_geometry geometry,
    project_context_tags_ids character varying(255),
    status boolean DEFAULT false,
    visits double precision DEFAULT 0,
    visits_last_week double precision DEFAULT 0,
    aid_map_image_file_name character varying(255),
    aid_map_image_content_type character varying(255),
    aid_map_image_file_size integer,
    aid_map_image_updated_at timestamp without time zone,
    navigate_by_country boolean DEFAULT false,
    navigate_by_level1 boolean DEFAULT false,
    navigate_by_level2 boolean DEFAULT false,
    navigate_by_level3 boolean DEFAULT false,
    map_styles text,
    overview_map_lat double precision,
    overview_map_lon double precision,
    overview_map_zoom integer,
    internal_description text,
    featured boolean DEFAULT false,
    CONSTRAINT enforce_dims_geographic_context_geometry CHECK ((st_ndims(geographic_context_geometry) = 2)),
    CONSTRAINT enforce_srid_geographic_context_geometry CHECK ((st_srid(geographic_context_geometry) = 4326))
);


--
-- Name: sites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sites_id_seq OWNED BY sites.id;


--
-- Name: spatial_ref_sys; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE spatial_ref_sys (
    srid integer NOT NULL,
    auth_name character varying(256),
    auth_srid integer,
    srtext character varying(2048),
    proj4text character varying(2048),
    CONSTRAINT spatial_ref_sys_srid_check CHECK (((srid > 0) AND (srid < 999000)))
);


--
-- Name: stats; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE stats (
    id integer NOT NULL,
    site_id integer,
    visits integer,
    date date
);


--
-- Name: stats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stats_id_seq OWNED BY stats.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying(255),
    count integer DEFAULT 0
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: themes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE themes (
    id integer NOT NULL,
    name character varying(255),
    css_file character varying(255),
    thumbnail_path character varying(255),
    data text
);


--
-- Name: themes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE themes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: themes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE themes_id_seq OWNED BY themes.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    name character varying(100) DEFAULT ''::character varying,
    email character varying(100),
    crypted_password character varying(40),
    salt character varying(40),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    remember_token character varying(40),
    remember_token_expires_at timestamp without time zone,
    organization_id integer,
    role character varying(255),
    blocked boolean DEFAULT false,
    site_id character varying(255),
    description text,
    password_reset_token character varying(255),
    password_reset_sent_at timestamp without time zone,
    last_login timestamp without time zone,
    six_months_since_last_login_alert_sent boolean DEFAULT false,
    login_fails integer DEFAULT 0
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: v_projects; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW v_projects AS
 SELECT p.id,
    p.primary_organization_id,
        CASE
            WHEN ((p.end_date < now()) OR (p.end_date IS NULL)) THEN false
            ELSE true
        END AS is_active,
    st_astext(p.the_geom) AS the_geom,
    (('|'::text || array_to_string(array_agg(DISTINCT projects_sites.site_id), '|'::text)) || '|'::text) AS sites,
    (('|'::text || array_to_string(array_agg(DISTINCT countries_projects.country_id), '|'::text)) || '|'::text) AS countries,
    (('|'::text || array_to_string(array_agg(DISTINCT clusters_projects.cluster_id), '|'::text)) || '|'::text) AS clusters,
    (('|'::text || array_to_string(array_agg(DISTINCT projects_tags.tag_id), '|'::text)) || '|'::text) AS tags,
    (('|'::text || array_to_string(array_agg(DISTINCT projects_sectors.sector_id), '|'::text)) || '|'::text) AS sectors,
    (('|'::text || ( SELECT array_to_string(array_agg(DISTINCT regions.name), ' | '::text) AS array_to_string
           FROM ((projects_regions
      RIGHT JOIN projects ON ((projects_regions.project_id = projects.id)))
   LEFT JOIN regions ON ((projects_regions.region_id = regions.id)))
  WHERE ((projects.id = p.id) AND (regions.level = 1)))) || '|'::text) AS regions_level1,
    (('|'::text || ( SELECT array_to_string(array_agg(DISTINCT regions.name), ' | '::text) AS array_to_string
           FROM ((projects_regions
      RIGHT JOIN projects ON ((projects_regions.project_id = projects.id)))
   LEFT JOIN regions ON ((projects_regions.region_id = regions.id)))
  WHERE ((projects.id = p.id) AND (regions.level = 2)))) || '|'::text) AS regions_level2,
    (('|'::text || ( SELECT array_to_string(array_agg(DISTINCT regions.name), ' | '::text) AS array_to_string
           FROM ((projects_regions
      RIGHT JOIN projects ON ((projects_regions.project_id = projects.id)))
   LEFT JOIN regions ON ((projects_regions.region_id = regions.id)))
  WHERE ((projects.id = p.id) AND (regions.level = 3)))) || '|'::text) AS regions_level3
   FROM (((((projects p
   LEFT JOIN projects_sectors ON ((p.id = projects_sectors.project_id)))
   LEFT JOIN clusters_projects ON ((p.id = clusters_projects.project_id)))
   LEFT JOIN countries_projects ON ((p.id = countries_projects.project_id)))
   LEFT JOIN projects_tags ON ((p.id = projects_tags.project_id)))
   LEFT JOIN projects_sites ON ((p.id = projects_sites.project_id)))
  GROUP BY p.id, p.primary_organization_id, p.start_date, p.end_date, p.the_geom;


--
-- Name: v_regions_num_projects; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW v_regions_num_projects AS
 SELECT r3.id AS region_id,
    r3.name,
    count(p.id) AS num_projects,
    st_astext(st_makepoint(r3.center_lon, r3.center_lat)) AS geom,
    ('http://haiti.ngoaidmap.org/location/'::text || (r3.path)::text) AS url
   FROM (((regions r3
   JOIN projects_regions pr ON ((r3.id = pr.region_id)))
   JOIN projects p ON ((pr.project_id = p.id)))
   JOIN projects_sites ps ON ((p.id = ps.project_id)))
  WHERE ((r3.level = 3) AND (ps.site_id = 1))
  GROUP BY r3.id, r3.name, st_astext(st_makepoint(r3.center_lon, r3.center_lat)), ('http://haiti.ngoaidmap.org/location/'::text || (r3.path)::text);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY changes_history_records ALTER COLUMN id SET DEFAULT nextval('changes_histories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY clusters ALTER COLUMN id SET DEFAULT nextval('clusters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY countries ALTER COLUMN id SET DEFAULT nextval('countries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY donations ALTER COLUMN id SET DEFAULT nextval('donations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY donors ALTER COLUMN id SET DEFAULT nextval('donors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY layer_styles ALTER COLUMN id SET DEFAULT nextval('layer_styles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY layers ALTER COLUMN id SET DEFAULT nextval('layers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_resources ALTER COLUMN id SET DEFAULT nextval('media_resources_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY offices ALTER COLUMN id SET DEFAULT nextval('offices_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY organizations ALTER COLUMN id SET DEFAULT nextval('organizations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY organizations2 ALTER COLUMN id SET DEFAULT nextval('organizations2_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pages ALTER COLUMN id SET DEFAULT nextval('pages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY partners ALTER COLUMN id SET DEFAULT nextval('partners_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects ALTER COLUMN id SET DEFAULT nextval('projects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects_synchronizations ALTER COLUMN id SET DEFAULT nextval('projects_synchronizations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY regions ALTER COLUMN id SET DEFAULT nextval('regions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY resources ALTER COLUMN id SET DEFAULT nextval('resources_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sectors ALTER COLUMN id SET DEFAULT nextval('sectors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY settings ALTER COLUMN id SET DEFAULT nextval('settings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sites ALTER COLUMN id SET DEFAULT nextval('sites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stats ALTER COLUMN id SET DEFAULT nextval('stats_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY themes ALTER COLUMN id SET DEFAULT nextval('themes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: changes_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY changes_history_records
    ADD CONSTRAINT changes_histories_pkey PRIMARY KEY (id);


--
-- Name: changes_history_records_copy_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY changes_history_records_copy
    ADD CONSTRAINT changes_history_records_copy_pkey PRIMARY KEY (id);


--
-- Name: clusters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY clusters
    ADD CONSTRAINT clusters_pkey PRIMARY KEY (id);


--
-- Name: countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: countries_projects_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY countries_projects
    ADD CONSTRAINT countries_projects_pk PRIMARY KEY (country_id, project_id);


--
-- Name: donations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY donations
    ADD CONSTRAINT donations_pkey PRIMARY KEY (id);


--
-- Name: donors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY donors
    ADD CONSTRAINT donors_pkey PRIMARY KEY (id);


--
-- Name: geolocations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY geolocations
    ADD CONSTRAINT geolocations_pkey PRIMARY KEY (id);


--
-- Name: layer_styles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY layer_styles
    ADD CONSTRAINT layer_styles_pkey PRIMARY KEY (id);


--
-- Name: layers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY layers
    ADD CONSTRAINT layers_pkey PRIMARY KEY (id);


--
-- Name: media_resources_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY media_resources
    ADD CONSTRAINT media_resources_pkey PRIMARY KEY (id);


--
-- Name: offices_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY offices
    ADD CONSTRAINT offices_pkey PRIMARY KEY (id);


--
-- Name: organizations2_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY organizations2
    ADD CONSTRAINT organizations2_pkey PRIMARY KEY (id);


--
-- Name: organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: partners_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY partners
    ADD CONSTRAINT partners_pkey PRIMARY KEY (id);


--
-- Name: projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: projects_synchronizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY projects_synchronizations
    ADD CONSTRAINT projects_synchronizations_pkey PRIMARY KEY (id);


--
-- Name: regions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- Name: resources_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resources
    ADD CONSTRAINT resources_pkey PRIMARY KEY (id);


--
-- Name: sectors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sectors
    ADD CONSTRAINT sectors_pkey PRIMARY KEY (id);


--
-- Name: settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: sites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sites
    ADD CONSTRAINT sites_pkey PRIMARY KEY (id);


--
-- Name: spatial_ref_sys_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY spatial_ref_sys
    ADD CONSTRAINT spatial_ref_sys_pkey PRIMARY KEY (srid);


--
-- Name: stats_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stats
    ADD CONSTRAINT stats_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: themes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY themes
    ADD CONSTRAINT themes_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: data_denormalization_cluster_idsx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_denormalization_cluster_idsx ON data_denormalization USING gist (cluster_ids);


--
-- Name: data_denormalization_countries_idsx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_denormalization_countries_idsx ON data_denormalization USING gist (countries_ids);


--
-- Name: data_denormalization_donors_idsx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_denormalization_donors_idsx ON data_denormalization USING gist (donors_ids);


--
-- Name: data_denormalization_is_activex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_denormalization_is_activex ON data_denormalization USING btree (is_active);


--
-- Name: data_denormalization_organization_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_denormalization_organization_idx ON data_denormalization USING btree (organization_id);


--
-- Name: data_denormalization_organization_namex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_denormalization_organization_namex ON data_denormalization USING btree (organization_name);


--
-- Name: data_denormalization_project_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_denormalization_project_idx ON data_denormalization USING btree (project_id);


--
-- Name: data_denormalization_project_name_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_denormalization_project_name_idx ON data_denormalization USING btree (project_name);


--
-- Name: data_denormalization_regions_idsx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_denormalization_regions_idsx ON data_denormalization USING gist (regions_ids);


--
-- Name: data_denormalization_sector_idsx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_denormalization_sector_idsx ON data_denormalization USING gist (sector_ids);


--
-- Name: data_denormalization_site_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_denormalization_site_idx ON data_denormalization USING btree (site_id);


--
-- Name: index_changes_history_records_on_user_id_and_what_type_and_when; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_changes_history_records_on_user_id_and_what_type_and_when ON changes_history_records USING btree (user_id, what_type, "when");


--
-- Name: index_clusters_projects_on_cluster_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_clusters_projects_on_cluster_id ON clusters_projects USING btree (cluster_id);


--
-- Name: index_clusters_projects_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_clusters_projects_on_project_id ON clusters_projects USING btree (project_id);


--
-- Name: index_countries_on_the_geom; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_countries_on_the_geom ON countries USING gist (the_geom);


--
-- Name: index_countries_projects_on_country_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_countries_projects_on_country_id ON countries_projects USING btree (country_id);


--
-- Name: index_countries_projects_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_countries_projects_on_project_id ON countries_projects USING btree (project_id);


--
-- Name: index_donations_on_donor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_donor_id ON donations USING btree (donor_id);


--
-- Name: index_donations_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_project_id ON donations USING btree (project_id);


--
-- Name: index_donors_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donors_on_name ON donors USING btree (name);


--
-- Name: index_geolocations_on_country_code; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_geolocations_on_country_code ON geolocations USING btree (country_code);


--
-- Name: index_geolocations_on_country_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_geolocations_on_country_name ON geolocations USING btree (country_name);


--
-- Name: index_geolocations_on_g0; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_geolocations_on_g0 ON geolocations USING btree (g0);


--
-- Name: index_geolocations_on_g1; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_geolocations_on_g1 ON geolocations USING btree (g1);


--
-- Name: index_geolocations_on_g2; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_geolocations_on_g2 ON geolocations USING btree (g2);


--
-- Name: index_geolocations_on_g3; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_geolocations_on_g3 ON geolocations USING btree (g3);


--
-- Name: index_geolocations_on_g4; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_geolocations_on_g4 ON geolocations USING btree (g4);


--
-- Name: index_geolocations_on_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_geolocations_on_uid ON geolocations USING btree (uid);


--
-- Name: index_geolocations_projects_on_geolocation_id_and_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_geolocations_projects_on_geolocation_id_and_project_id ON geolocations_projects USING btree (geolocation_id, project_id);


--
-- Name: index_geolocations_projects_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_geolocations_projects_on_project_id ON geolocations_projects USING btree (project_id);


--
-- Name: index_media_resources_on_element_type_and_element_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_media_resources_on_element_type_and_element_id ON media_resources USING btree (element_type, element_id);


--
-- Name: index_organizations2_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_organizations2_on_name ON organizations2 USING btree (name);


--
-- Name: index_organizations_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_organizations_on_name ON organizations USING btree (name);


--
-- Name: index_organizations_projects_on_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_organizations_projects_on_organization_id ON organizations_projects USING btree (organization_id);


--
-- Name: index_organizations_projects_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_organizations_projects_on_project_id ON organizations_projects USING btree (project_id);


--
-- Name: index_pages_on_parent_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pages_on_parent_id ON pages USING btree (parent_id);


--
-- Name: index_pages_on_permalink; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pages_on_permalink ON pages USING btree (permalink);


--
-- Name: index_pages_on_site_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pages_on_site_id ON pages USING btree (site_id);


--
-- Name: index_partners_on_site_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_partners_on_site_id ON partners USING btree (site_id);


--
-- Name: index_projects_on_end_date; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_end_date ON projects USING btree (end_date);


--
-- Name: index_projects_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_name ON projects USING btree (name);


--
-- Name: index_projects_on_primary_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_primary_organization_id ON projects USING btree (primary_organization_id);


--
-- Name: index_projects_on_prime_awardee_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_prime_awardee_id ON projects USING btree (prime_awardee_id);


--
-- Name: index_projects_on_the_geom; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_the_geom ON projects USING gist (the_geom);


--
-- Name: index_projects_regions_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_regions_on_project_id ON projects_regions USING btree (project_id);


--
-- Name: index_projects_regions_on_region_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_regions_on_region_id ON projects_regions USING btree (region_id);


--
-- Name: index_projects_sectors_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_sectors_on_project_id ON projects_sectors USING btree (project_id);


--
-- Name: index_projects_sectors_on_sector_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_sectors_on_sector_id ON projects_sectors USING btree (sector_id);


--
-- Name: index_projects_sites_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_sites_on_project_id ON projects_sites USING btree (project_id);


--
-- Name: index_projects_sites_on_project_id_and_site_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_projects_sites_on_project_id_and_site_id ON projects_sites USING btree (project_id, site_id);


--
-- Name: index_projects_sites_on_site_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_sites_on_site_id ON projects_sites USING btree (site_id);


--
-- Name: index_projects_tags_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_tags_on_project_id ON projects_tags USING btree (project_id);


--
-- Name: index_projects_tags_on_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_tags_on_tag_id ON projects_tags USING btree (tag_id);


--
-- Name: index_regions_on_country_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_regions_on_country_id ON regions USING btree (country_id);


--
-- Name: index_regions_on_level; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_regions_on_level ON regions USING btree (level);


--
-- Name: index_regions_on_parent_region_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_regions_on_parent_region_id ON regions USING btree (parent_region_id);


--
-- Name: index_regions_on_the_geom; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_regions_on_the_geom ON regions USING gist (the_geom);


--
-- Name: index_resources_on_element_type_and_element_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_resources_on_element_type_and_element_id ON resources USING btree (element_type, element_id);


--
-- Name: index_site_layers_on_layer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_site_layers_on_layer_id ON site_layers USING btree (layer_id);


--
-- Name: index_site_layers_on_layer_style_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_site_layers_on_layer_style_id ON site_layers USING btree (layer_style_id);


--
-- Name: index_site_layers_on_site_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_site_layers_on_site_id ON site_layers USING btree (site_id);


--
-- Name: index_sites_on_geographic_context_geometry; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sites_on_geographic_context_geometry ON sites USING gist (geographic_context_geometry);


--
-- Name: index_sites_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sites_on_name ON sites USING btree (name);


--
-- Name: index_sites_on_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sites_on_status ON sites USING btree (status);


--
-- Name: index_sites_on_url; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sites_on_url ON sites USING btree (url);


--
-- Name: index_stats_on_site_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_stats_on_site_id ON stats USING btree (site_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: geometry_columns_delete; Type: RULE; Schema: public; Owner: -
--

CREATE RULE geometry_columns_delete AS
    ON DELETE TO geometry_columns DO INSTEAD NOTHING;


--
-- Name: geometry_columns_insert; Type: RULE; Schema: public; Owner: -
--

CREATE RULE geometry_columns_insert AS
    ON INSERT TO geometry_columns DO INSTEAD NOTHING;


--
-- Name: geometry_columns_update; Type: RULE; Schema: public; Owner: -
--

CREATE RULE geometry_columns_update AS
    ON UPDATE TO geometry_columns DO INSTEAD NOTHING;


--
-- Name: region_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects_regions
    ADD CONSTRAINT region_id_fk FOREIGN KEY (region_id) REFERENCES regions(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20101028113834');

INSERT INTO schema_migrations (version) VALUES ('20101028115129');

INSERT INTO schema_migrations (version) VALUES ('20101028133100');

INSERT INTO schema_migrations (version) VALUES ('20101028133927');

INSERT INTO schema_migrations (version) VALUES ('20101028134621');

INSERT INTO schema_migrations (version) VALUES ('20101028135048');

INSERT INTO schema_migrations (version) VALUES ('20101108162315');

INSERT INTO schema_migrations (version) VALUES ('20101108163209');

INSERT INTO schema_migrations (version) VALUES ('20101110105456');

INSERT INTO schema_migrations (version) VALUES ('20101110105502');

INSERT INTO schema_migrations (version) VALUES ('20101110114108');

INSERT INTO schema_migrations (version) VALUES ('20101110114438');

INSERT INTO schema_migrations (version) VALUES ('20101110161733');

INSERT INTO schema_migrations (version) VALUES ('20101110162254');

INSERT INTO schema_migrations (version) VALUES ('20101110162317');

INSERT INTO schema_migrations (version) VALUES ('20101110162603');

INSERT INTO schema_migrations (version) VALUES ('20101110163656');

INSERT INTO schema_migrations (version) VALUES ('20101116091100');

INSERT INTO schema_migrations (version) VALUES ('20101117100450');

INSERT INTO schema_migrations (version) VALUES ('20101117141706');

INSERT INTO schema_migrations (version) VALUES ('20101119102703');

INSERT INTO schema_migrations (version) VALUES ('20101122081057');

INSERT INTO schema_migrations (version) VALUES ('20101124120201');

INSERT INTO schema_migrations (version) VALUES ('20101124144950');

INSERT INTO schema_migrations (version) VALUES ('20101124155515');

INSERT INTO schema_migrations (version) VALUES ('20101124165848');

INSERT INTO schema_migrations (version) VALUES ('20101125162127');

INSERT INTO schema_migrations (version) VALUES ('20101125182340');

INSERT INTO schema_migrations (version) VALUES ('20101128172940');

INSERT INTO schema_migrations (version) VALUES ('20101128174136');

INSERT INTO schema_migrations (version) VALUES ('20101129152739');

INSERT INTO schema_migrations (version) VALUES ('20101130152816');

INSERT INTO schema_migrations (version) VALUES ('20101130164947');

INSERT INTO schema_migrations (version) VALUES ('20101201172805');

INSERT INTO schema_migrations (version) VALUES ('20101201174750');

INSERT INTO schema_migrations (version) VALUES ('20101202154700');

INSERT INTO schema_migrations (version) VALUES ('20101202171837');

INSERT INTO schema_migrations (version) VALUES ('20101202175526');

INSERT INTO schema_migrations (version) VALUES ('20101211105820');

INSERT INTO schema_migrations (version) VALUES ('20101211204623');

INSERT INTO schema_migrations (version) VALUES ('20101213130738');

INSERT INTO schema_migrations (version) VALUES ('20101214175852');

INSERT INTO schema_migrations (version) VALUES ('20101214185843');

INSERT INTO schema_migrations (version) VALUES ('20101216152205');

INSERT INTO schema_migrations (version) VALUES ('20101221102641');

INSERT INTO schema_migrations (version) VALUES ('20101221122740');

INSERT INTO schema_migrations (version) VALUES ('20101221125338');

INSERT INTO schema_migrations (version) VALUES ('20101221151517');

INSERT INTO schema_migrations (version) VALUES ('20101222065522');

INSERT INTO schema_migrations (version) VALUES ('20101222153232');

INSERT INTO schema_migrations (version) VALUES ('20101222162225');

INSERT INTO schema_migrations (version) VALUES ('20101223110143');

INSERT INTO schema_migrations (version) VALUES ('20101224091820');

INSERT INTO schema_migrations (version) VALUES ('20101227103614');

INSERT INTO schema_migrations (version) VALUES ('20110103105358');

INSERT INTO schema_migrations (version) VALUES ('20110104102847');

INSERT INTO schema_migrations (version) VALUES ('20110104104051');

INSERT INTO schema_migrations (version) VALUES ('20110104121538');

INSERT INTO schema_migrations (version) VALUES ('20110104190135');

INSERT INTO schema_migrations (version) VALUES ('20110107103059');

INSERT INTO schema_migrations (version) VALUES ('20110107190334');

INSERT INTO schema_migrations (version) VALUES ('20110110131044');

INSERT INTO schema_migrations (version) VALUES ('20110110191540');

INSERT INTO schema_migrations (version) VALUES ('20110110195011');

INSERT INTO schema_migrations (version) VALUES ('20110111113043');

INSERT INTO schema_migrations (version) VALUES ('20110208092114');

INSERT INTO schema_migrations (version) VALUES ('20110208105308');

INSERT INTO schema_migrations (version) VALUES ('20110602170808');

INSERT INTO schema_migrations (version) VALUES ('20111121131054');

INSERT INTO schema_migrations (version) VALUES ('20111201095952');

INSERT INTO schema_migrations (version) VALUES ('20111201114152');

INSERT INTO schema_migrations (version) VALUES ('20111201115943');

INSERT INTO schema_migrations (version) VALUES ('20111201145358');

INSERT INTO schema_migrations (version) VALUES ('20111226134501');

INSERT INTO schema_migrations (version) VALUES ('20120209122630');

INSERT INTO schema_migrations (version) VALUES ('20120210092657');

INSERT INTO schema_migrations (version) VALUES ('20120213165338');

INSERT INTO schema_migrations (version) VALUES ('20120214152607');

INSERT INTO schema_migrations (version) VALUES ('20120417111053');

INSERT INTO schema_migrations (version) VALUES ('20120504115709');

INSERT INTO schema_migrations (version) VALUES ('20130128100737');

INSERT INTO schema_migrations (version) VALUES ('20130128140613');

INSERT INTO schema_migrations (version) VALUES ('20130204150246');

INSERT INTO schema_migrations (version) VALUES ('20130211142500');

INSERT INTO schema_migrations (version) VALUES ('20130212123245');

INSERT INTO schema_migrations (version) VALUES ('20130218104721');

INSERT INTO schema_migrations (version) VALUES ('20130226145909');

INSERT INTO schema_migrations (version) VALUES ('20130304121255');

INSERT INTO schema_migrations (version) VALUES ('20130321180629');

INSERT INTO schema_migrations (version) VALUES ('20130325152416');

INSERT INTO schema_migrations (version) VALUES ('20130325161448');

INSERT INTO schema_migrations (version) VALUES ('20130325172919');

INSERT INTO schema_migrations (version) VALUES ('20130419200211');

INSERT INTO schema_migrations (version) VALUES ('20130419201156');

INSERT INTO schema_migrations (version) VALUES ('20130419202532');

INSERT INTO schema_migrations (version) VALUES ('20131126085647');

INSERT INTO schema_migrations (version) VALUES ('20131126085813');

INSERT INTO schema_migrations (version) VALUES ('20131126093052');

INSERT INTO schema_migrations (version) VALUES ('20131212114120');

INSERT INTO schema_migrations (version) VALUES ('20131212114555');

INSERT INTO schema_migrations (version) VALUES ('20131212155239');

INSERT INTO schema_migrations (version) VALUES ('20131212163356');

INSERT INTO schema_migrations (version) VALUES ('20140109151033');

INSERT INTO schema_migrations (version) VALUES ('20140213155722');

INSERT INTO schema_migrations (version) VALUES ('20140217165847');

INSERT INTO schema_migrations (version) VALUES ('20140218173336');

INSERT INTO schema_migrations (version) VALUES ('20140219164037');

INSERT INTO schema_migrations (version) VALUES ('20140530130528');

INSERT INTO schema_migrations (version) VALUES ('20150513152341');

INSERT INTO schema_migrations (version) VALUES ('20150520084645');

INSERT INTO schema_migrations (version) VALUES ('20150804112848');

INSERT INTO schema_migrations (version) VALUES ('20150810095146');

INSERT INTO schema_migrations (version) VALUES ('20150813105924');

INSERT INTO schema_migrations (version) VALUES ('20150825162340');

INSERT INTO schema_migrations (version) VALUES ('20150923164350');

INSERT INTO schema_migrations (version) VALUES ('20150925065809');

INSERT INTO schema_migrations (version) VALUES ('20150925065950');

INSERT INTO schema_migrations (version) VALUES ('20150925072808');

INSERT INTO schema_migrations (version) VALUES ('20150929091624');

INSERT INTO schema_migrations (version) VALUES ('20151020073350');

INSERT INTO schema_migrations (version) VALUES ('20151022125317');

INSERT INTO schema_migrations (version) VALUES ('20151029121013');

INSERT INTO schema_migrations (version) VALUES ('20151124164356');

INSERT INTO schema_migrations (version) VALUES ('20151126155119');

INSERT INTO schema_migrations (version) VALUES ('20151222112453');

INSERT INTO schema_migrations (version) VALUES ('20151222114114');

INSERT INTO schema_migrations (version) VALUES ('20160114163212');
