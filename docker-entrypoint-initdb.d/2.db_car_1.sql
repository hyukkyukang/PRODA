--
-- PostgreSQL database dump
--

-- Create Database
DROP DATABASE IF EXISTS car_1;
CREATE DATABASE car_1 with owner data_user; 
\c car_1;

-- Dumped from database version 15.1 (Debian 15.1-1.pgdg110+1)
-- Dumped by pg_dump version 15.3 (Ubuntu 15.3-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: test_bigint_tid; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.test_bigint_tid AS (
	id bigint,
	ctid tid
);


ALTER TYPE public.test_bigint_tid OWNER TO postgres;

--
-- Name: test_id_tid; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.test_id_tid AS (
	id integer,
	ctid tid
);


ALTER TYPE public.test_id_tid OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: car_makers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.car_makers (
    id bigint NOT NULL,
    maker text,
    fullname text,
    country integer
);


ALTER TABLE public.car_makers OWNER TO postgres;

--
-- Name: car_names; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.car_names (
    makeid bigint NOT NULL,
    model text,
    make text
);


ALTER TABLE public.car_names OWNER TO postgres;

--
-- Name: cars_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cars_data (
    id bigint NOT NULL,
    mpg real,
    cylinders bigint,
    edispl real,
    horsepower real,
    weight bigint,
    accelerate real,
    year bigint
);


ALTER TABLE public.cars_data OWNER TO postgres;

--
-- Name: continents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.continents (
    contid bigint NOT NULL,
    continent text
);


ALTER TABLE public.continents OWNER TO postgres;

--
-- Name: countries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.countries (
    countryid bigint NOT NULL,
    countryname text,
    continent bigint
);


ALTER TABLE public.countries OWNER TO postgres;

--
-- Name: model_list; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.model_list (
    modelid bigint NOT NULL,
    maker bigint,
    model text
);


ALTER TABLE public.model_list OWNER TO postgres;

--
-- Name: car_1__car_1; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1 AS
 SELECT DISTINCT continents.contid AS continents__contid,
    continents.continent AS continents__continent,
    countries.countryid AS countries__countryid,
    countries.countryname AS countries__countryname,
    countries.continent AS countries__continent,
    car_makers.id AS car_makers__id,
    car_makers.maker AS car_makers__maker,
    car_makers.fullname AS car_makers__fullname,
    car_makers.country AS car_makers__country,
    model_list.modelid AS model_list__modelid,
    model_list.maker AS model_list__maker,
    model_list.model AS model_list__model,
    car_names.makeid AS car_names__makeid,
    car_names.model AS car_names__model,
    car_names.make AS car_names__make,
    cars_data.id AS cars_data__id,
    cars_data.mpg AS cars_data__mpg,
    cars_data.cylinders AS cars_data__cylinders,
    cars_data.edispl AS cars_data__edispl,
    cars_data.horsepower AS cars_data__horsepower,
    cars_data.weight AS cars_data__weight,
    cars_data.accelerate AS cars_data__accelerate,
    cars_data.year AS cars_data__year
   FROM (((((public.continents
     FULL JOIN public.countries ON ((continents.contid = countries.continent)))
     FULL JOIN public.car_makers ON ((countries.countryid = car_makers.country)))
     FULL JOIN public.model_list ON ((car_makers.id = model_list.maker)))
     FULL JOIN public.car_names ON ((model_list.model = car_names.model)))
     FULL JOIN public.cars_data ON ((car_names.makeid = cars_data.id)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1 OWNER TO data_user;

--
-- Name: car_1__car_1___n1_0____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_0____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_0____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_0____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_0____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_0____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_100____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_100____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (((car_1__car_1.cars_data__weight > 2155) AND (car_1__car_1.cars_data__weight <= 3785)) OR ((car_1__car_1.cars_data__edispl >= (79.0)::double precision) AND (car_1__car_1.cars_data__edispl <= (400.0)::double precision)) OR (car_1__car_1.cars_data__weight >= 4425)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_100____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_100____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_100____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (((car_1__car_1.cars_data__weight > 2155) AND (car_1__car_1.cars_data__weight <= 3785)) OR ((car_1__car_1.cars_data__edispl >= (79.0)::double precision) AND (car_1__car_1.cars_data__edispl <= (400.0)::double precision)) OR (car_1__car_1.cars_data__weight >= 4425))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_100____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_101____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_101____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_101____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_101____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_101____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_101____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_101____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_101____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.car_names__make = ANY (ARRAY['toyota corolla'::text, 'amc spirit dl'::text]))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_101____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_103____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_103____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__horsepower >= (15)::double precision) AND (car_1__car_1.cars_data__mpg >= (29.8)::double precision)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_103____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_103____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_103____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__horsepower >= (15)::double precision) AND (car_1__car_1.cars_data__mpg >= (29.8)::double precision))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_103____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_105____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_105____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.cars_data__accelerate <= (18.5)::double precision))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_105____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_105____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_105____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (car_1__car_1.cars_data__accelerate <= (18.5)::double precision)))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_105____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_107____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_107____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.cars_data__weight < 3609))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_107____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_107____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_107____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (car_1__car_1.cars_data__weight < 3609)))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_107____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_109____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_109____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.cars_data__cylinders <= 6))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_109____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_109____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_109____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (car_1__car_1.cars_data__cylinders <= 6)))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_109____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_111____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_111____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_111____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_111____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_111____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_111____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_113____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_113____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_113____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_113____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_113____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_113____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_115____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_115____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__accelerate > (12.5)::double precision) AND (car_1__car_1.cars_data__accelerate <= (15.5)::double precision)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_115____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_115____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_115____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__accelerate > (12.5)::double precision) AND (car_1__car_1.cars_data__accelerate <= (15.5)::double precision))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_115____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_117____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_117____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_117____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_117____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_117____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_117____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_119____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_119____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_119____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_119____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_119____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_119____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_119____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_119____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__weight > 2310) AND (car_1__car_1.cars_data__mpg > (15.5)::double precision) AND (car_1__car_1.cars_data__mpg < (24.0)::double precision))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_119____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_11____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_11____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.cars_data__mpg <> (28.0)::double precision))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_11____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_11____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_11____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (car_1__car_1.cars_data__mpg <> (28.0)::double precision)))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_11____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_121____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_121____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (((car_1__car_1.cars_data__mpg >= (12.0)::double precision) AND (car_1__car_1.cars_data__mpg <= (25.0)::double precision)) OR ((car_1__car_1.cars_data__year > 1970) AND (car_1__car_1.cars_data__year < 1976))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_121____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_121____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_121____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (((car_1__car_1.cars_data__mpg >= (12.0)::double precision) AND (car_1__car_1.cars_data__mpg <= (25.0)::double precision)) OR ((car_1__car_1.cars_data__year > 1970) AND (car_1__car_1.cars_data__year < 1976)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_121____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_122____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_122____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.car_names__make <> ALL (ARRAY['amc matador (sw)'::text, 'honda civic'::text])) OR ((car_1__car_1.cars_data__year >= 1974) AND (car_1__car_1.cars_data__year <= 1982))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_122____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_122____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_122____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.car_names__make <> ALL (ARRAY['amc matador (sw)'::text, 'honda civic'::text])) OR ((car_1__car_1.cars_data__year >= 1974) AND (car_1__car_1.cars_data__year <= 1982)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_122____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_124____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_124____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_124____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_124____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_124____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_124____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_124____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_124____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.continents__continent = 'america'::text)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_124____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_126____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_126____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__year = 1973) OR ((car_1__car_1.cars_data__year <= 1979) AND (car_1__car_1.cars_data__horsepower >= (22)::double precision))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_126____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_126____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_126____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__year = 1973) OR ((car_1__car_1.cars_data__year <= 1979) AND (car_1__car_1.cars_data__horsepower >= (22)::double precision)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_126____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_127____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_127____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_127____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_127____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_127____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_127____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_129____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_129____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_129____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_129____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_129____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_129____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_129____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_129____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.countries__countryname ~~ '%usa%'::text)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_129____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_131____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_131____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_131____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_131____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_131____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_131____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_133____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_133____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_133____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_133____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_133____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_133____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_135____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_135____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__weight >= 2228) OR (car_1__car_1.cars_data__year > 1976)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_135____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_135____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_135____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__weight >= 2228) OR (car_1__car_1.cars_data__year > 1976))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_135____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_136____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_136____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_136____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_136____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_136____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_136____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_138____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_138____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_138____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_138____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_138____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_138____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_138____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_138____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.continents__continent = 'america'::text)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_138____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_13____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_13____inner_view AS
 SELECT DISTINCT car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__id IS NOT NULL) AND ((car_1__car_1.car_makers__fullname = 'Chrysler'::text) OR (car_1__car_1.car_makers__fullname ~~ '%ota'::text)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_13____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_13____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_13____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__id IS NOT NULL) AND (NOT ((car_1__car_1.car_makers__fullname = 'Chrysler'::text) OR (car_1__car_1.car_makers__fullname ~~ '%ota'::text))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_13____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_140____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_140____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__mpg < (19.0)::double precision) AND (car_1__car_1.cars_data__year > 1973)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_140____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_140____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_140____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__mpg < (19.0)::double precision) AND (car_1__car_1.cars_data__year > 1973))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_140____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_142____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_142____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__mpg > (19.0)::double precision) OR (car_1__car_1.cars_data__year >= 1973) OR (car_1__car_1.cars_data__horsepower > (18)::double precision)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_142____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_142____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_142____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__mpg > (19.0)::double precision) OR (car_1__car_1.cars_data__year >= 1973) OR (car_1__car_1.cars_data__horsepower > (18)::double precision))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_142____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_143____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_143____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_143____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_143____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_143____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_143____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_143____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_143____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.countries__countryname = 'usa'::text)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_143____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_145____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_145____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__weight >= 2310) AND (car_1__car_1.cars_data__year > 1973) AND (car_1__car_1.cars_data__horsepower >= (25)::double precision)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_145____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_145____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_145____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__weight >= 2310) AND (car_1__car_1.cars_data__year > 1973) AND (car_1__car_1.cars_data__horsepower >= (25)::double precision))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_145____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_147____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_147____inner_view AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND ((car_1__car_1.cars_data__weight > 3563) OR ((car_1__car_1.cars_data__accelerate > (13.5)::double precision) AND (car_1__car_1.cars_data__accelerate <= (15.0)::double precision)) OR ((car_1__car_1.cars_data__weight > 2310) AND (car_1__car_1.cars_data__weight <= 2595))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_147____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_147____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_147____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__weight > 3563) OR ((car_1__car_1.cars_data__accelerate > (13.5)::double precision) AND (car_1__car_1.cars_data__accelerate <= (15.0)::double precision)) OR ((car_1__car_1.cars_data__weight > 2310) AND (car_1__car_1.cars_data__weight <= 2595)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_147____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_148____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_148____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_148____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_148____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_148____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_148____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_148____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_148____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__cylinders > 4) AND (car_1__car_1.cars_data__accelerate <= (13.0)::double precision))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_148____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_14____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_14____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_14____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_14____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_14____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_14____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_14____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_14____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.car_names__make = ANY (ARRAY['toyota corona'::text, 'dodge dart custom'::text, 'chevy c10'::text]))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_14____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_150____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_150____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__year < 1974) OR (car_1__car_1.cars_data__mpg > (29.0)::double precision) OR (car_1__car_1.cars_data__weight < 2035)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_150____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_150____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_150____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__year < 1974) OR (car_1__car_1.cars_data__mpg > (29.0)::double precision) OR (car_1__car_1.cars_data__weight < 2035))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_150____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_152____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_152____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_152____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_152____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_152____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_152____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_154____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_154____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__year < 1973) AND (car_1__car_1.cars_data__edispl > (97.0)::double precision) AND (car_1__car_1.cars_data__edispl <= (350.0)::double precision) AND (car_1__car_1.cars_data__weight < 3433)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_154____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_154____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_154____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__year < 1973) AND (car_1__car_1.cars_data__edispl > (97.0)::double precision) AND (car_1__car_1.cars_data__edispl <= (350.0)::double precision) AND (car_1__car_1.cars_data__weight < 3433))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_154____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_156____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_156____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__cylinders >= 8) OR ((car_1__car_1.cars_data__mpg >= (16.0)::double precision) AND (car_1__car_1.cars_data__mpg <= (17.5)::double precision)) OR (car_1__car_1.cars_data__cylinders < 4)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_156____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_156____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_156____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__cylinders >= 8) OR ((car_1__car_1.cars_data__mpg >= (16.0)::double precision) AND (car_1__car_1.cars_data__mpg <= (17.5)::double precision)) OR (car_1__car_1.cars_data__cylinders < 4))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_156____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_157____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_157____inner_view AS
 SELECT DISTINCT car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (car_1__car_1.countries__countryname <> ALL (ARRAY['italy'::text, 'germany'::text])))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_157____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_157____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_157____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (NOT (car_1__car_1.countries__countryname <> ALL (ARRAY['italy'::text, 'germany'::text]))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_157____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_159____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_159____inner_view AS
 SELECT DISTINCT car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND ((car_1__car_1.countries__countryname !~~ '%pan'::text) AND (car_1__car_1.continents__continent !~~ '%mer%'::text)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_159____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_159____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_159____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (NOT ((car_1__car_1.countries__countryname !~~ '%pan'::text) AND (car_1__car_1.continents__continent !~~ '%mer%'::text))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_159____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_161____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_161____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_161____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_161____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_161____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_161____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_163____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_163____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.car_names__make ~~ 'for%'::text) OR (car_1__car_1.cars_data__year < 1981) OR (car_1__car_1.car_names__make = ANY (ARRAY['datsun 200sx'::text, 'saab 900s'::text]))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_163____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_163____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_163____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.car_names__make ~~ 'for%'::text) OR (car_1__car_1.cars_data__year < 1981) OR (car_1__car_1.car_names__make = ANY (ARRAY['datsun 200sx'::text, 'saab 900s'::text])))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_163____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_165____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_165____inner_view AS
 SELECT DISTINCT car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__id IS NOT NULL) AND ((car_1__car_1.car_makers__fullname = 'General Motors'::text) OR (car_1__car_1.car_makers__fullname ~~ '%rys%'::text)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_165____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_165____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_165____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__id IS NOT NULL) AND (NOT ((car_1__car_1.car_makers__fullname = 'General Motors'::text) OR (car_1__car_1.car_makers__fullname ~~ '%rys%'::text))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_165____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_166____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_166____inner_view AS
 SELECT DISTINCT car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (car_1__car_1.countries__countryname <> ALL (ARRAY['usa'::text, 'japan'::text])))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_166____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_166____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_166____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (NOT (car_1__car_1.countries__countryname <> ALL (ARRAY['usa'::text, 'japan'::text]))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_166____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_168____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_168____inner_view AS
 SELECT DISTINCT car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (car_1__car_1.countries__countryname !~~ 'ita%'::text))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_168____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_168____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_168____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (NOT (car_1__car_1.countries__countryname !~~ 'ita%'::text)))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_168____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_16____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_16____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__horsepower < (28)::double precision) AND (car_1__car_1.cars_data__year < 1973) AND (car_1__car_1.cars_data__edispl > (307.0)::double precision)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_16____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_16____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_16____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__horsepower < (28)::double precision) AND (car_1__car_1.cars_data__year < 1973) AND (car_1__car_1.cars_data__edispl > (307.0)::double precision))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_16____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_170____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_170____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_170____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_170____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_170____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_170____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_170____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_170____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.car_names__make ~~ '%yot%'::text)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_170____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_172____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_172____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_172____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_172____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_172____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_172____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_172____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_172____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.countries__countryname !~~ 'usa%'::text)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_172____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_174____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_174____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_174____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_174____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_174____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_174____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_176____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_176____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__accelerate <> (14.0)::double precision) OR ((car_1__car_1.cars_data__year >= 1971) AND (car_1__car_1.cars_data__year < 1976)) OR ((car_1__car_1.cars_data__mpg > (10.0)::double precision) AND (car_1__car_1.cars_data__mpg < (31.9)::double precision))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_176____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_176____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_176____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__accelerate <> (14.0)::double precision) OR ((car_1__car_1.cars_data__year >= 1971) AND (car_1__car_1.cars_data__year < 1976)) OR ((car_1__car_1.cars_data__mpg > (10.0)::double precision) AND (car_1__car_1.cars_data__mpg < (31.9)::double precision)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_176____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_177____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_177____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_177____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_177____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_177____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_177____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_177____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_177____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.car_makers__maker <> 'amc'::text)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_177____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_179____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_179____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__year >= 1976) AND (car_1__car_1.cars_data__weight > 2565)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_179____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_179____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_179____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__year >= 1976) AND (car_1__car_1.cars_data__weight > 2565))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_179____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_181____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_181____inner_view AS
 SELECT DISTINCT car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__id IS NOT NULL) AND ((car_1__car_1.car_makers__maker = 'chrysler'::text) OR (car_1__car_1.car_makers__fullname = 'Ford Motor Company'::text)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_181____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_181____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_181____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__id IS NOT NULL) AND (NOT ((car_1__car_1.car_makers__maker = 'chrysler'::text) OR (car_1__car_1.car_makers__fullname = 'Ford Motor Company'::text))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_181____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_182____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_182____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_182____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_182____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_182____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_182____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_182____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_182____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.countries__countryname ~~ '%usa'::text)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_182____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_184____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_184____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_184____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_184____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_184____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_184____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_184____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_184____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.car_makers__maker = 'ford'::text)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_184____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_186____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_186____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.cars_data__accelerate <= (18.5)::double precision))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_186____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_186____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_186____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (car_1__car_1.cars_data__accelerate <= (18.5)::double precision)))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_186____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_188____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_188____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_188____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_188____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_188____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_188____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_188____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_188____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.continents__continent = 'america'::text)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_188____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_18____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_18____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_18____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_18____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_18____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_18____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_190____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_190____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_190____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_190____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_190____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_190____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_190____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_190____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.car_makers__maker = 'fiat'::text)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_190____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_192____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_192____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__weight >= 2228) AND (car_1__car_1.cars_data__year >= 1974)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_192____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_192____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_192____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__weight >= 2228) AND (car_1__car_1.cars_data__year >= 1974))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_192____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_194____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_194____inner_view AS
 SELECT DISTINCT car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__id IS NOT NULL) AND ((car_1__car_1.car_makers__fullname = 'American Motor Company'::text) OR (car_1__car_1.car_makers__fullname = 'Ford Motor Company'::text)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_194____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_194____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_194____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__id IS NOT NULL) AND (NOT ((car_1__car_1.car_makers__fullname = 'American Motor Company'::text) OR (car_1__car_1.car_makers__fullname = 'Ford Motor Company'::text))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_194____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_195____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_195____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_195____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_195____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_195____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_195____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_197____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_197____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_197____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_197____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_197____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_197____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_197____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_197____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.continents__continent <> 'america'::text) AND (car_1__car_1.countries__countryname = 'germany'::text))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_197____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_199____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_199____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__cylinders <= 4) AND (car_1__car_1.cars_data__weight <= 2226) AND (car_1__car_1.cars_data__horsepower < (44)::double precision)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_199____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_199____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_199____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__cylinders <= 4) AND (car_1__car_1.cars_data__weight <= 2226) AND (car_1__car_1.cars_data__horsepower < (44)::double precision))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_199____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_201____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_201____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__year >= 1970) AND (car_1__car_1.cars_data__year < 1973)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_201____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_201____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_201____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__year >= 1970) AND (car_1__car_1.cars_data__year < 1973))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_201____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_203____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_203____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.cars_data__horsepower <= (25)::double precision))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_203____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_203____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_203____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (car_1__car_1.cars_data__horsepower <= (25)::double precision)))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_203____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_205____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_205____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (((car_1__car_1.cars_data__horsepower <> (15)::double precision) AND (car_1__car_1.cars_data__weight < 2310)) OR ((car_1__car_1.cars_data__horsepower >= (19)::double precision) AND (car_1__car_1.cars_data__horsepower < (22)::double precision))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_205____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_205____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_205____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (((car_1__car_1.cars_data__horsepower <> (15)::double precision) AND (car_1__car_1.cars_data__weight < 2310)) OR ((car_1__car_1.cars_data__horsepower >= (19)::double precision) AND (car_1__car_1.cars_data__horsepower < (22)::double precision)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_205____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_207____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_207____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_207____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_207____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_207____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_207____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_209____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_209____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_209____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_209____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_209____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_209____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_209____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_209____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.car_names__make = ANY (ARRAY['mercury zephyr 6'::text, 'subaru'::text]))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_209____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_20____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_20____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__accelerate <= (14.0)::double precision) AND (car_1__car_1.cars_data__year > 1973)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_20____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_20____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_20____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__accelerate <= (14.0)::double precision) AND (car_1__car_1.cars_data__year > 1973))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_20____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_211____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_211____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_211____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_211____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_211____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_211____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_211____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_211____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.continents__continent = ANY (ARRAY['america'::text, 'europe'::text])) AND (car_1__car_1.countries__countryname = 'usa'::text))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_211____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_213____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_213____inner_view AS
 SELECT DISTINCT car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND ((car_1__car_1.car_makers__maker !~~ '%for%'::text) OR ((car_1__car_1.continents__continent = 'america'::text) AND (car_1__car_1.countries__countryname = 'usa'::text))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_213____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_213____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_213____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (NOT ((car_1__car_1.car_makers__maker !~~ '%for%'::text) OR ((car_1__car_1.continents__continent = 'america'::text) AND (car_1__car_1.countries__countryname = 'usa'::text)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_213____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_214____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_214____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_214____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_214____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_214____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_214____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_216____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_216____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_216____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_216____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_216____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_216____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_216____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_216____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.car_names__make <> 'ford pinto'::text)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_216____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_218____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_218____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_218____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_218____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_218____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_218____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_218____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_218____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__edispl >= (360.0)::double precision) AND (car_1__car_1.cars_data__edispl <= (383.0)::double precision) AND (car_1__car_1.cars_data__accelerate >= (11.0)::double precision))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_218____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_220____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_220____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_220____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_220____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_220____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_220____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_222____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_222____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_222____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_222____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_222____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_222____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_224____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_224____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__year <= 1973) AND (car_1__car_1.cars_data__horsepower <> (18)::double precision)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_224____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_224____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_224____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__year <= 1973) AND (car_1__car_1.cars_data__horsepower <> (18)::double precision))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_224____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_226____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_226____inner_view AS
 SELECT DISTINCT car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (car_1__car_1.car_makers__maker !~~ '%ler'::text))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_226____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_226____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_226____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (NOT (car_1__car_1.car_makers__maker !~~ '%ler'::text)))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_226____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_228____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_228____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_228____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_228____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_228____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_228____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_228____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_228____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__cylinders > 4) AND (car_1__car_1.cars_data__weight > 3988) AND (car_1__car_1.cars_data__weight <= 4335) AND (car_1__car_1.cars_data__horsepower >= (14)::double precision) AND (car_1__car_1.cars_data__horsepower <= (16)::double precision))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_228____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_22____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_22____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__year > 1971) OR ((car_1__car_1.cars_data__weight > 2833) AND (car_1__car_1.cars_data__weight <= 4312) AND (car_1__car_1.cars_data__cylinders = 8))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_22____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_22____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_22____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__year > 1971) OR ((car_1__car_1.cars_data__weight > 2833) AND (car_1__car_1.cars_data__weight <= 4312) AND (car_1__car_1.cars_data__cylinders = 8)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_22____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_230____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_230____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_230____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_230____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_230____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_230____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_232____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_232____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_232____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_232____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_232____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_232____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_234____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_234____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.cars_data__year <= 1973))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_234____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_234____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_234____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (car_1__car_1.cars_data__year <= 1973)))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_234____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_236____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_236____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_236____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_236____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_236____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_236____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_236____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_236____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.continents__continent ~~ '%rop%'::text)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_236____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_238____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_238____inner_view AS
 SELECT DISTINCT car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__id IS NOT NULL) AND ((car_1__car_1.car_makers__maker = 'gm'::text) OR (car_1__car_1.car_makers__maker <> 'ford'::text)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_238____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_238____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_238____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__id IS NOT NULL) AND (NOT ((car_1__car_1.car_makers__maker = 'gm'::text) OR (car_1__car_1.car_makers__maker <> 'ford'::text))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_238____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_239____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_239____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_239____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_239____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_239____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_239____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_23____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_23____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__edispl > (199.0)::double precision) OR ((car_1__car_1.cars_data__edispl > (86.0)::double precision) AND (car_1__car_1.cars_data__edispl < (97.0)::double precision))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_23____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_23____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_23____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__edispl > (199.0)::double precision) OR ((car_1__car_1.cars_data__edispl > (86.0)::double precision) AND (car_1__car_1.cars_data__edispl < (97.0)::double precision)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_23____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_241____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_241____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_241____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_241____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_241____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_241____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_241____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_241____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.countries__countryname = ANY (ARRAY['usa'::text, 'korea'::text]))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_241____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_243____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_243____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.cars_data__year < 1973))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_243____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_243____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_243____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (car_1__car_1.cars_data__year < 1973)))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_243____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_245____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_245____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__year >= 1979) AND (car_1__car_1.cars_data__accelerate >= (19.2)::double precision) AND (car_1__car_1.cars_data__weight > 2020)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_245____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_245____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_245____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__year >= 1979) AND (car_1__car_1.cars_data__accelerate >= (19.2)::double precision) AND (car_1__car_1.cars_data__weight > 2020))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_245____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_247____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_247____inner_view AS
 SELECT DISTINCT car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND ((car_1__car_1.continents__continent = 'america'::text) OR (car_1__car_1.continents__continent ~~ 'asi%'::text)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_247____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_247____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_247____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (NOT ((car_1__car_1.continents__continent = 'america'::text) OR (car_1__car_1.continents__continent ~~ 'asi%'::text))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_247____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_248____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_248____inner_view AS
 SELECT DISTINCT car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.countries__countryid IS NOT NULL) AND ((car_1__car_1.countries__countryname = 'usa'::text) OR (car_1__car_1.countries__countryname = ANY (ARRAY['japan'::text, 'france'::text]))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_248____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_248____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_248____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.countries__countryid IS NOT NULL) AND (NOT ((car_1__car_1.countries__countryname = 'usa'::text) OR (car_1__car_1.countries__countryname = ANY (ARRAY['japan'::text, 'france'::text])))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_248____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_249____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_249____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.cars_data__horsepower < (15)::double precision))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_249____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_249____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_249____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (car_1__car_1.cars_data__horsepower < (15)::double precision)))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_249____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_24____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_24____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.cars_data__year >= 1971))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_24____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_24____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_24____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (car_1__car_1.cars_data__year >= 1971)))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_24____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_251____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_251____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_251____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_251____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_251____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_251____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_251____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_251____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.continents__continent = 'america'::text)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_251____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_253____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_253____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_253____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_253____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_253____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_253____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_255____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_255____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_255____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_255____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_255____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_255____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_255____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_255____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.car_names__make = 'amc matador (sw)'::text)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_255____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_257____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_257____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__cylinders <= 4) OR (car_1__car_1.cars_data__accelerate > (17.0)::double precision)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_257____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_257____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_257____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__cylinders <= 4) OR (car_1__car_1.cars_data__accelerate > (17.0)::double precision))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_257____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_259____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_259____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.cars_data__horsepower >= (25)::double precision))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_259____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_259____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_259____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (car_1__car_1.cars_data__horsepower >= (25)::double precision)))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_259____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_261____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_261____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_261____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_261____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_261____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_261____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_263____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_263____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__year > 1971) AND (car_1__car_1.cars_data__cylinders = 6)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_263____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_263____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_263____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__year > 1971) AND (car_1__car_1.cars_data__cylinders = 6))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_263____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_265____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_265____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_265____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_265____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_265____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_265____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_265____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_265____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.continents__continent ~~ 'ame%'::text)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_265____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_267____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_267____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__edispl >= (97.0)::double precision) AND (car_1__car_1.cars_data__year <> 1973) AND (car_1__car_1.cars_data__cylinders > 6)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_267____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_267____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_267____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__edispl >= (97.0)::double precision) AND (car_1__car_1.cars_data__year <> 1973) AND (car_1__car_1.cars_data__cylinders > 6))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_267____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_269____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_269____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__edispl <= (122.0)::double precision) OR (car_1__car_1.cars_data__mpg = (15.0)::double precision) OR (car_1__car_1.cars_data__year = 1976)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_269____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_269____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_269____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__edispl <= (122.0)::double precision) OR (car_1__car_1.cars_data__mpg = (15.0)::double precision) OR (car_1__car_1.cars_data__year = 1976))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_269____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_26____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_26____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_26____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_26____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_26____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_26____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_26____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_26____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.car_names__make = 'dodge challenger se'::text)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_26____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_271____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_271____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__edispl <= (122.0)::double precision) AND (car_1__car_1.cars_data__year >= 1971)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_271____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_271____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_271____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__edispl <= (122.0)::double precision) AND (car_1__car_1.cars_data__year >= 1971))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_271____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_273____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_273____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.cars_data__weight >= 2310))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_273____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_273____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_273____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (car_1__car_1.cars_data__weight >= 2310)))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_273____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_275____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_275____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_275____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_275____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_275____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_275____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_277____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_277____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__weight = 2310) OR (car_1__car_1.cars_data__cylinders <> 4) OR (car_1__car_1.car_names__make <> 'chevrolet chevette'::text)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_277____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_277____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_277____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__weight = 2310) OR (car_1__car_1.cars_data__cylinders <> 4) OR (car_1__car_1.car_names__make <> 'chevrolet chevette'::text))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_277____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_278____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_278____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.cars_data__year <= 1973))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_278____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_278____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_278____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (car_1__car_1.cars_data__year <= 1973)))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_278____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_280____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_280____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (((car_1__car_1.cars_data__horsepower >= (19)::double precision) AND (car_1__car_1.cars_data__horsepower <= (32)::double precision)) OR (car_1__car_1.car_names__make <> ALL (ARRAY['amc matador'::text, 'vw rabbit'::text])) OR (car_1__car_1.cars_data__year >= 1976)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_280____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_280____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_280____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (((car_1__car_1.cars_data__horsepower >= (19)::double precision) AND (car_1__car_1.cars_data__horsepower <= (32)::double precision)) OR (car_1__car_1.car_names__make <> ALL (ARRAY['amc matador'::text, 'vw rabbit'::text])) OR (car_1__car_1.cars_data__year >= 1976))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_280____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_282____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_282____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_282____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_282____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_282____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_282____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_282____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_282____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.car_names__make <> 'toyota corolla'::text)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_282____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_284____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_284____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__horsepower < (14)::double precision) AND (car_1__car_1.cars_data__year <> 1970)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_284____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_284____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_284____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__horsepower < (14)::double precision) AND (car_1__car_1.cars_data__year <> 1970))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_284____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_286____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_286____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__weight <= 2254) OR (car_1__car_1.cars_data__cylinders >= 4) OR (car_1__car_1.cars_data__year >= 1980)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_286____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_286____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_286____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__weight <= 2254) OR (car_1__car_1.cars_data__cylinders >= 4) OR (car_1__car_1.cars_data__year >= 1980))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_286____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_288____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_288____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__accelerate <> (18.5)::double precision) AND (car_1__car_1.cars_data__cylinders >= 4) AND (car_1__car_1.cars_data__cylinders < 8)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_288____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_288____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_288____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__accelerate <> (18.5)::double precision) AND (car_1__car_1.cars_data__cylinders >= 4) AND (car_1__car_1.cars_data__cylinders < 8))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_288____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_28____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_28____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_28____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_28____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_28____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_28____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_28____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_28____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__maker !~~ '%fia%'::text) AND (car_1__car_1.cars_data__accelerate > (19.0)::double precision))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_28____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_290____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_290____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_290____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_290____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_290____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_290____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_290____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_290____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.continents__continent ~~ 'asi%'::text)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_290____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_292____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_292____inner_view AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.model_list__maker IS NOT NULL) AND ((car_1__car_1.car_makers__maker ~~ '%for%'::text) OR (car_1__car_1.car_names__make = 'amc rebel sst'::text)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_292____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_292____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_292____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.model_list__maker IS NOT NULL) AND (NOT ((car_1__car_1.car_makers__maker ~~ '%for%'::text) OR (car_1__car_1.car_names__make = 'amc rebel sst'::text))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_292____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_293____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_293____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__cylinders > 4) AND (car_1__car_1.cars_data__cylinders <= 6) AND (car_1__car_1.cars_data__accelerate >= (15.5)::double precision) AND (car_1__car_1.cars_data__accelerate < (16.4)::double precision)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_293____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_293____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_293____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__cylinders > 4) AND (car_1__car_1.cars_data__cylinders <= 6) AND (car_1__car_1.cars_data__accelerate >= (15.5)::double precision) AND (car_1__car_1.cars_data__accelerate < (16.4)::double precision))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_293____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_295____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_295____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_295____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_295____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_295____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_295____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_295____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_295____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.countries__countryname = 'japan'::text)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_295____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_297____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_297____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__year > 1971) AND (car_1__car_1.cars_data__year <= 1982)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_297____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_297____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_297____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__year > 1971) AND (car_1__car_1.cars_data__year <= 1982))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_297____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_299____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_299____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_299____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_299____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_299____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_299____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_299____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_299____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.car_makers__fullname = 'Toyota'::text)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_299____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_2____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_2____inner_view AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.model_list__maker IS NOT NULL) AND (((car_1__car_1.car_makers__fullname = 'American Motor Company'::text) AND (car_1__car_1.car_names__make <> ALL (ARRAY['amc rebel sst'::text, 'amc matador'::text, 'amc hornet'::text]))) OR (car_1__car_1.car_names__make = 'ford pinto'::text)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_2____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_2____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_2____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.model_list__maker IS NOT NULL) AND (NOT (((car_1__car_1.car_makers__fullname = 'American Motor Company'::text) AND (car_1__car_1.car_names__make <> ALL (ARRAY['amc rebel sst'::text, 'amc matador'::text, 'amc hornet'::text]))) OR (car_1__car_1.car_names__make = 'ford pinto'::text))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_2____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_30____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_30____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.cars_data__edispl >= (383.0)::double precision))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_30____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_30____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_30____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (car_1__car_1.cars_data__edispl >= (383.0)::double precision)))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_30____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_32____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_32____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_32____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_32____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_32____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_32____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_32____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_32____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.continents__continent = 'america'::text) AND (car_1__car_1.countries__countryname ~~ 'usa%'::text))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_32____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_34____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_34____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__horsepower <= (15)::double precision) OR (car_1__car_1.cars_data__year < 1980) OR (car_1__car_1.cars_data__accelerate > (20.1)::double precision)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_34____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_34____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_34____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__horsepower <= (15)::double precision) OR (car_1__car_1.cars_data__year < 1980) OR (car_1__car_1.cars_data__accelerate > (20.1)::double precision))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_34____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_36____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_36____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__weight <= 2228) OR ((car_1__car_1.cars_data__weight < 3060) AND (car_1__car_1.cars_data__year <= 1973))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_36____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_36____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_36____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__weight <= 2228) OR ((car_1__car_1.cars_data__weight < 3060) AND (car_1__car_1.cars_data__year <= 1973)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_36____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_38____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_38____inner_view AS
 SELECT DISTINCT car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND ((car_1__car_1.countries__countryname = ANY (ARRAY['usa'::text, 'japan'::text])) OR (car_1__car_1.car_makers__fullname <> 'Volvo'::text) OR (car_1__car_1.countries__countryname = ANY (ARRAY['sweden'::text, 'egypt'::text]))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_38____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_38____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_38____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT ((car_1__car_1.countries__countryname = ANY (ARRAY['usa'::text, 'japan'::text])) OR (car_1__car_1.car_makers__fullname <> 'Volvo'::text) OR (car_1__car_1.countries__countryname = ANY (ARRAY['sweden'::text, 'egypt'::text])))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_38____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_39____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_39____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_39____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_39____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_39____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_39____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_3____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_3____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__accelerate > (15.0)::double precision) AND (car_1__car_1.cars_data__cylinders <> 4)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_3____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_3____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_3____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__accelerate > (15.0)::double precision) AND (car_1__car_1.cars_data__cylinders <> 4))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_3____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_41____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_41____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__year >= 1973) AND (car_1__car_1.cars_data__year <= 1975) AND (car_1__car_1.cars_data__cylinders = 8)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_41____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_41____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_41____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__year >= 1973) AND (car_1__car_1.cars_data__year <= 1975) AND (car_1__car_1.cars_data__cylinders = 8))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_41____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_43____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_43____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_43____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_43____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_43____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_43____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_43____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_43____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.countries__countryname = 'japan'::text)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_43____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_45____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_45____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_45____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_45____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_45____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_45____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_45____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_45____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.car_makers__maker = ANY (ARRAY['chrysler'::text, 'toyota'::text, 'gm'::text]))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_45____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_47____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_47____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_47____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_47____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_47____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_47____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_47____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_47____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.countries__countryname = ANY (ARRAY['japan'::text, 'usa'::text]))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_47____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_49____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_49____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_49____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_49____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_49____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_49____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_49____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_49____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.countries__countryname = ANY (ARRAY['usa'::text, 'italy'::text]))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_49____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_51____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_51____inner_view AS
 SELECT DISTINCT car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__id IS NOT NULL) AND ((car_1__car_1.car_makers__fullname = 'Ford Motor Company'::text) OR (car_1__car_1.car_makers__fullname = 'General Motors'::text)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_51____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_51____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_51____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__id IS NOT NULL) AND (NOT ((car_1__car_1.car_makers__fullname = 'Ford Motor Company'::text) OR (car_1__car_1.car_makers__fullname = 'General Motors'::text))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_51____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_52____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_52____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.cars_data__horsepower < (15)::double precision))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_52____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_52____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_52____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (car_1__car_1.cars_data__horsepower < (15)::double precision)))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_52____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_54____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_54____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__year > 1973) AND (car_1__car_1.cars_data__year <= 1980)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_54____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_54____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_54____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__year > 1973) AND (car_1__car_1.cars_data__year <= 1980))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_54____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_56____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_56____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_56____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_56____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_56____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_56____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_56____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_56____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.car_makers__fullname ~~ 'Toy%'::text)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_56____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_58____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_58____inner_view AS
 SELECT DISTINCT car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__id IS NOT NULL) AND ((car_1__car_1.car_makers__fullname = 'Chrysler'::text) OR (car_1__car_1.car_makers__fullname = 'Ford Motor Company'::text)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_58____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_58____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_58____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__id IS NOT NULL) AND (NOT ((car_1__car_1.car_makers__fullname = 'Chrysler'::text) OR (car_1__car_1.car_makers__fullname = 'Ford Motor Company'::text))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_58____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_59____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_59____inner_view AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND ((car_1__car_1.countries__countryname = 'usa'::text) AND (car_1__car_1.cars_data__cylinders = 8)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_59____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_59____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_59____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (NOT ((car_1__car_1.countries__countryname = 'usa'::text) AND (car_1__car_1.cars_data__cylinders = 8))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_59____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_5____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_5____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_5____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_5____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_5____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_5____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_5____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_5____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.countries__countryname = 'usa'::text)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_5____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_61____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_61____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_61____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_61____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_61____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_61____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_61____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_61____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.countries__countryname <> ALL (ARRAY['usa'::text, 'japan'::text]))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_61____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_63____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_63____inner_view AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.model_list__maker IS NOT NULL) AND ((car_1__car_1.car_makers__maker = 'fiat'::text) OR (car_1__car_1.car_makers__maker = 'toyota'::text) OR ((car_1__car_1.cars_data__horsepower > (13)::double precision) AND (car_1__car_1.cars_data__horsepower < (19)::double precision))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_63____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_63____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_63____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.model_list__maker IS NOT NULL) AND (NOT ((car_1__car_1.car_makers__maker = 'fiat'::text) OR (car_1__car_1.car_makers__maker = 'toyota'::text) OR ((car_1__car_1.cars_data__horsepower > (13)::double precision) AND (car_1__car_1.cars_data__horsepower < (19)::double precision)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_63____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_64____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_64____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_64____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_64____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_64____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_64____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_64____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_64____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.continents__continent = 'america'::text)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_64____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_66____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_66____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.cars_data__horsepower < (19)::double precision))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_66____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_66____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_66____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (car_1__car_1.cars_data__horsepower < (19)::double precision)))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_66____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_68____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_68____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__year <> 1973) AND (car_1__car_1.cars_data__edispl >= (105.0)::double precision) AND (car_1__car_1.cars_data__horsepower >= (17)::double precision)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_68____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_68____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_68____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__year <> 1973) AND (car_1__car_1.cars_data__edispl >= (105.0)::double precision) AND (car_1__car_1.cars_data__horsepower >= (17)::double precision))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_68____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_70____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_70____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_70____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_70____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_70____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_70____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_70____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_70____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.car_makers__maker = 'amc'::text)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_70____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_72____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_72____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_72____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_72____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_72____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_72____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_74____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_74____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_74____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_74____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_74____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_74____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_76____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_76____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__cylinders <> 4) OR (car_1__car_1.cars_data__weight <= 2625) OR (car_1__car_1.car_names__make = 'peugeot 504'::text)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_76____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_76____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_76____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__cylinders <> 4) OR (car_1__car_1.cars_data__weight <= 2625) OR (car_1__car_1.car_names__make = 'peugeot 504'::text))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_76____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_77____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_77____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_77____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_77____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_77____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_77____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_77____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_77____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.car_names__make = ANY (ARRAY['toyota corona'::text, 'mercedes-benz 280s'::text]))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_77____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_79____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_79____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.cars_data__horsepower > (14)::double precision))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_79____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_79____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_79____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (car_1__car_1.cars_data__horsepower > (14)::double precision)))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_79____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_7____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_7____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_7____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_7____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_7____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_7____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_7____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_7____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.countries__countryname = 'japan'::text)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_7____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_81____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_81____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (((car_1__car_1.cars_data__horsepower <= (19)::double precision) AND (car_1__car_1.cars_data__mpg < (18.0)::double precision)) OR (car_1__car_1.cars_data__cylinders = 6)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_81____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_81____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_81____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (((car_1__car_1.cars_data__horsepower <= (19)::double precision) AND (car_1__car_1.cars_data__mpg < (18.0)::double precision)) OR (car_1__car_1.cars_data__cylinders = 6))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_81____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_82____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_82____inner_view AS
 SELECT DISTINCT car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND ((car_1__car_1.countries__countryname = 'japan'::text) OR (car_1__car_1.continents__continent = 'america'::text)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_82____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_82____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_82____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (NOT ((car_1__car_1.countries__countryname = 'japan'::text) OR (car_1__car_1.continents__continent = 'america'::text))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_82____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_83____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_83____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.cars_data__cylinders <= 4))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_83____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_83____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_83____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (car_1__car_1.cars_data__cylinders <= 4)))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_83____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_85____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_85____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_85____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_85____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_85____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_85____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_85____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_85____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.countries__countryname ~~ '%usa%'::text)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_85____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_87____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_87____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_87____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_87____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_87____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_87____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_87____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_87____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.car_names__make = ANY (ARRAY['chevrolet chevette'::text, 'oldsmobile cutlass supreme'::text]))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_87____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_89____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_89____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.car_names__make = ANY (ARRAY['toyota corona'::text, 'plymouth horizon tc3'::text, 'plymouth volare premier v8'::text])) OR ((car_1__car_1.cars_data__accelerate >= (14.9)::double precision) AND (car_1__car_1.cars_data__accelerate <= (15.5)::double precision)) OR (car_1__car_1.cars_data__year < 1973)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_89____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_89____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_89____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.car_names__make = ANY (ARRAY['toyota corona'::text, 'plymouth horizon tc3'::text, 'plymouth volare premier v8'::text])) OR ((car_1__car_1.cars_data__accelerate >= (14.9)::double precision) AND (car_1__car_1.cars_data__accelerate <= (15.5)::double precision)) OR (car_1__car_1.cars_data__year < 1973))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_89____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_90____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_90____inner_view AS
 SELECT DISTINCT car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND ((car_1__car_1.car_makers__maker = 'chrysler'::text) OR (car_1__car_1.car_makers__maker ~~ 'gm%'::text)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_90____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_90____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_90____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (NOT ((car_1__car_1.car_makers__maker = 'chrysler'::text) OR (car_1__car_1.car_makers__maker ~~ 'gm%'::text))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_90____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_91____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_91____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_91____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_91____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_91____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_91____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_93____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_93____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_93____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_93____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_93____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_93____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_95____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_95____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.cars_data__year <> 1971))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_95____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_95____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_95____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (car_1__car_1.cars_data__year <> 1971)))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_95____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_97____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_97____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (((car_1__car_1.car_names__make = 'toyota corona'::text) AND (car_1__car_1.cars_data__accelerate = (14.0)::double precision)) OR (car_1__car_1.car_names__make = ANY (ARRAY['dodge aspen se'::text, 'chevrolet vega (sw)'::text, 'plymouth duster'::text]))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_97____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_97____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_97____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (((car_1__car_1.car_names__make = 'toyota corona'::text) AND (car_1__car_1.cars_data__accelerate = (14.0)::double precision)) OR (car_1__car_1.car_names__make = ANY (ARRAY['dodge aspen se'::text, 'chevrolet vega (sw)'::text, 'plymouth duster'::text])))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_97____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_98____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_98____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_98____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_98____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_98____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_98____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n1_98____wf___f; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_98____wf___f AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.countries__countryname <> 'usa'::text)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_98____wf___f OWNER TO data_user;

--
-- Name: car_1__car_1___n1_9____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_9____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_9____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n1_9____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n1_9____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE (car_1__car_1.cars_data__id IS NOT NULL)
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n1_9____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_0____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_0____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND ((car_1__car_1.cars_data__cylinders >= 4) AND (car_1__car_1.cars_data__cylinders <= 6) AND (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_249____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_249____inner_view
          GROUP BY car_1__car_1___n1_249____inner_view.cars_data__year
         HAVING ((count(*) > 7) AND (count(*) <= 16)))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.car_names__make = ANY (ARRAY['amc hornet'::text, 'renault 12 (sw)'::text]))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_0____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_0____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_0____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__cylinders >= 4) AND (car_1__car_1.cars_data__cylinders <= 6) AND (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_249____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_249____inner_view
          GROUP BY car_1__car_1___n1_249____inner_view.cars_data__year
         HAVING ((count(*) > 7) AND (count(*) <= 16)))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.car_names__make = ANY (ARRAY['amc hornet'::text, 'renault 12 (sw)'::text])))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_0____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_10____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_10____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_87____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_87____inner_view
          GROUP BY car_1__car_1___n1_87____inner_view.cars_data__year
         HAVING ((count(*) >= 28) AND (count(*) < 30)))) AND (car_1__car_1.cars_data__year IS NOT NULL)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_10____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_10____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_10____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_87____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_87____inner_view
          GROUP BY car_1__car_1___n1_87____inner_view.cars_data__year
         HAVING ((count(*) >= 28) AND (count(*) < 30)))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_10____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_11____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_11____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__mpg <= (19.0)::double precision) OR ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_7____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_7____inner_view
          GROUP BY car_1__car_1___n1_7____inner_view.cars_data__year
         HAVING ((count(*) > 27) AND (count(*) < 36)))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_11____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_11____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_11____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__mpg <= (19.0)::double precision) OR ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_7____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_7____inner_view
          GROUP BY car_1__car_1___n1_7____inner_view.cars_data__year
         HAVING ((count(*) > 27) AND (count(*) < 36)))) AND (car_1__car_1.cars_data__year IS NOT NULL)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_11____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_12____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_12____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_59____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_59____inner_view
          GROUP BY car_1__car_1___n1_59____inner_view.cars_data__year
         HAVING ((count(*) >= 6) AND (count(*) <= 10))))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_91____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_91____inner_view
          GROUP BY car_1__car_1___n1_91____inner_view.cars_data__year
         HAVING ((count(*) > 27) AND (count(*) <= 29))
          ORDER BY car_1__car_1___n1_91____inner_view.cars_data__year
         LIMIT 2))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.car_makers__fullname = 'Ford Motor Company'::text)) OR (car_1__car_1.car_makers__fullname = ANY (ARRAY['General Motors'::text, 'Toyota'::text, 'American Motor Company'::text]))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_12____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_12____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_12____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_59____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_59____inner_view
          GROUP BY car_1__car_1___n1_59____inner_view.cars_data__year
         HAVING ((count(*) >= 6) AND (count(*) <= 10))))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_91____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_91____inner_view
          GROUP BY car_1__car_1___n1_91____inner_view.cars_data__year
         HAVING ((count(*) > 27) AND (count(*) <= 29))
          ORDER BY car_1__car_1___n1_91____inner_view.cars_data__year
         LIMIT 2))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.car_makers__fullname = 'Ford Motor Company'::text)) OR (car_1__car_1.car_makers__fullname = ANY (ARRAY['General Motors'::text, 'Toyota'::text, 'American Motor Company'::text])))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_12____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_13____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_13____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_91____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_91____inner_view
          GROUP BY car_1__car_1___n1_91____inner_view.cars_data__year
         HAVING ((count(*) > 27) AND (count(*) <= 29))
          ORDER BY car_1__car_1___n1_91____inner_view.cars_data__year
         LIMIT 2))) AND (car_1__car_1.cars_data__year IS NOT NULL)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_13____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_13____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_13____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_91____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_91____inner_view
          GROUP BY car_1__car_1___n1_91____inner_view.cars_data__year
         HAVING ((count(*) > 27) AND (count(*) <= 29))
          ORDER BY car_1__car_1___n1_91____inner_view.cars_data__year
         LIMIT 2))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_13____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_14____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_14____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_39____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_39____inner_view
          GROUP BY car_1__car_1___n1_39____inner_view.cars_data__year
         HAVING (count(*) >= 28))) AND (car_1__car_1.cars_data__year IS NOT NULL)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_14____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_14____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_14____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_39____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_39____inner_view
          GROUP BY car_1__car_1___n1_39____inner_view.cars_data__year
         HAVING (count(*) >= 28))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_14____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_15____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_15____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_211____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_211____inner_view
          GROUP BY car_1__car_1___n1_211____inner_view.cars_data__year
         HAVING (count(*) >= 35))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((car_1__car_1.cars_data__year >= 1972) AND (car_1__car_1.cars_data__year < 1976)) OR (car_1__car_1.car_makers__fullname = 'General Motors'::text)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_15____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_15____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_15____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT (((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_211____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_211____inner_view
          GROUP BY car_1__car_1___n1_211____inner_view.cars_data__year
         HAVING (count(*) >= 35))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((car_1__car_1.cars_data__year >= 1972) AND (car_1__car_1.cars_data__year < 1976)) OR (car_1__car_1.car_makers__fullname = 'General Motors'::text))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_15____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_16____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_16____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_152____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_152____inner_view
          GROUP BY car_1__car_1___n1_152____inner_view.cars_data__year
         HAVING ((count(*) >= 30) AND (count(*) <= 40)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_16____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_16____inner_view
          GROUP BY car_1__car_1___n1_16____inner_view.cars_data__year
         HAVING (count(*) >= 9)))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_16____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_16____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_16____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (NOT (((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_152____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_152____inner_view
          GROUP BY car_1__car_1___n1_152____inner_view.cars_data__year
         HAVING ((count(*) >= 30) AND (count(*) <= 40)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_16____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_16____inner_view
          GROUP BY car_1__car_1___n1_16____inner_view.cars_data__year
         HAVING (count(*) >= 9)))) AND (car_1__car_1.cars_data__year IS NOT NULL)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_16____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_17____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_17____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_133____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_133____inner_view
          GROUP BY car_1__car_1___n1_133____inner_view.cars_data__year
         HAVING (count(*) <= 31)
          ORDER BY car_1__car_1___n1_133____inner_view.cars_data__year
         LIMIT 2)) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_222____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_222____inner_view
          GROUP BY car_1__car_1___n1_222____inner_view.cars_data__year
         HAVING (count(*) <= 29)))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.cars_data__accelerate >= (11.0)::double precision) AND (car_1__car_1.cars_data__accelerate <= (21.0)::double precision))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_17____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_17____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_17____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_133____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_133____inner_view
          GROUP BY car_1__car_1___n1_133____inner_view.cars_data__year
         HAVING (count(*) <= 31)
          ORDER BY car_1__car_1___n1_133____inner_view.cars_data__year
         LIMIT 2)) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_222____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_222____inner_view
          GROUP BY car_1__car_1___n1_222____inner_view.cars_data__year
         HAVING (count(*) <= 29)))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.cars_data__accelerate >= (11.0)::double precision) AND (car_1__car_1.cars_data__accelerate <= (21.0)::double precision)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_17____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_18____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_18____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_127____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_127____inner_view
          GROUP BY car_1__car_1___n1_127____inner_view.cars_data__year
         HAVING (count(*) < 31))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (NOT (car_1__car_1.cars_data__cylinders IN ( SELECT DISTINCT car_1__car_1___n1_22____inner_view.cars_data__cylinders
           FROM public.car_1__car_1___n1_22____inner_view
          WHERE (car_1__car_1___n1_22____inner_view.cars_data__id = car_1__car_1.cars_data__id)))) AND (car_1__car_1.cars_data__cylinders IS NOT NULL)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_18____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_18____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_18____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_127____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_127____inner_view
          GROUP BY car_1__car_1___n1_127____inner_view.cars_data__year
         HAVING (count(*) < 31))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (NOT (car_1__car_1.cars_data__cylinders IN ( SELECT DISTINCT car_1__car_1___n1_22____inner_view.cars_data__cylinders
           FROM public.car_1__car_1___n1_22____inner_view
          WHERE (car_1__car_1___n1_22____inner_view.cars_data__id = car_1__car_1.cars_data__id)))) AND (car_1__car_1.cars_data__cylinders IS NOT NULL))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_18____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_19____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_19____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_28____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_28____inner_view
          GROUP BY car_1__car_1___n1_28____inner_view.cars_data__year
         HAVING ((count(*) > 34) AND (count(*) < 40))))) AND (car_1__car_1.cars_data__year IS NOT NULL)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_19____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_19____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_19____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_28____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_28____inner_view
          GROUP BY car_1__car_1___n1_28____inner_view.cars_data__year
         HAVING ((count(*) > 34) AND (count(*) < 40))))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_19____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_1____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_1____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_79____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_79____inner_view
          GROUP BY car_1__car_1___n1_79____inner_view.cars_data__year
         HAVING (count(*) > 30)))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_45____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_45____inner_view
          GROUP BY car_1__car_1___n1_45____inner_view.cars_data__year
         HAVING (count(*) >= 28))) AND (car_1__car_1.cars_data__year IS NOT NULL)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_1____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_1____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_1____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_79____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_79____inner_view
          GROUP BY car_1__car_1___n1_79____inner_view.cars_data__year
         HAVING (count(*) > 30)))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_45____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_45____inner_view
          GROUP BY car_1__car_1___n1_45____inner_view.cars_data__year
         HAVING (count(*) >= 28))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_1____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_20____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_20____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_54____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_54____inner_view
          GROUP BY car_1__car_1___n1_54____inner_view.cars_data__year
         HAVING (count(*) > 29)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__cylinders <> 4) OR (car_1__car_1.cars_data__year >= 1976)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_20____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_20____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_20____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (NOT (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_54____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_54____inner_view
          GROUP BY car_1__car_1___n1_54____inner_view.cars_data__year
         HAVING (count(*) > 29)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__cylinders <> 4) OR (car_1__car_1.cars_data__year >= 1976))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_20____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_21____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_21____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_278____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_278____inner_view
          WHERE (car_1__car_1___n1_278____inner_view.cars_data__id = car_1__car_1.cars_data__id)
          GROUP BY car_1__car_1___n1_278____inner_view.cars_data__year
         HAVING (count(*) < 29)
          ORDER BY car_1__car_1___n1_278____inner_view.cars_data__year
         LIMIT 4))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__edispl >= (122.0)::double precision)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_21____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_21____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_21____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_278____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_278____inner_view
          WHERE (car_1__car_1___n1_278____inner_view.cars_data__id = car_1__car_1.cars_data__id)
          GROUP BY car_1__car_1___n1_278____inner_view.cars_data__year
         HAVING (count(*) < 29)
          ORDER BY car_1__car_1___n1_278____inner_view.cars_data__year
         LIMIT 4))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__edispl >= (122.0)::double precision))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_21____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_22____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_22____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_24____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_24____inner_view
          GROUP BY car_1__car_1___n1_24____inner_view.cars_data__year
         HAVING ((count(*) > 27) AND (count(*) <= 31))))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_253____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_253____inner_view
          GROUP BY car_1__car_1___n1_253____inner_view.cars_data__year
         HAVING ((count(*) >= 27) AND (count(*) < 29))
          ORDER BY car_1__car_1___n1_253____inner_view.cars_data__year
         LIMIT 5))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_22____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_22____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_22____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_24____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_24____inner_view
          GROUP BY car_1__car_1___n1_24____inner_view.cars_data__year
         HAVING ((count(*) > 27) AND (count(*) <= 31))))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_253____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_253____inner_view
          GROUP BY car_1__car_1___n1_253____inner_view.cars_data__year
         HAVING ((count(*) >= 27) AND (count(*) < 29))
          ORDER BY car_1__car_1___n1_253____inner_view.cars_data__year
         LIMIT 5))) AND (car_1__car_1.cars_data__year IS NOT NULL)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_22____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_23____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_23____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (((NOT (car_1__car_1.car_makers__id IN ( SELECT DISTINCT car_1__car_1___n1_13____inner_view.car_makers__id
           FROM public.car_1__car_1___n1_13____inner_view
          WHERE (car_1__car_1___n1_13____inner_view.car_makers__maker = car_1__car_1.car_makers__maker)))) AND (car_1__car_1.car_makers__id IS NOT NULL)) OR ((car_1__car_1.cars_data__year < ( SELECT DISTINCT car_1__car_1___n1_179____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_179____inner_view
          GROUP BY car_1__car_1___n1_179____inner_view.cars_data__year
         HAVING ((count(*) >= 14) AND (count(*) < 22))
          ORDER BY car_1__car_1___n1_179____inner_view.cars_data__year
         LIMIT 1)) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__mpg > (15.5)::double precision)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_23____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_23____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_23____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT (((NOT (car_1__car_1.car_makers__id IN ( SELECT DISTINCT car_1__car_1___n1_13____inner_view.car_makers__id
           FROM public.car_1__car_1___n1_13____inner_view
          WHERE (car_1__car_1___n1_13____inner_view.car_makers__maker = car_1__car_1.car_makers__maker)))) AND (car_1__car_1.car_makers__id IS NOT NULL)) OR ((car_1__car_1.cars_data__year < ( SELECT DISTINCT car_1__car_1___n1_179____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_179____inner_view
          GROUP BY car_1__car_1___n1_179____inner_view.cars_data__year
         HAVING ((count(*) >= 14) AND (count(*) < 22))
          ORDER BY car_1__car_1___n1_179____inner_view.cars_data__year
         LIMIT 1)) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__mpg > (15.5)::double precision))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_23____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_24____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_24____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (((car_1__car_1.car_names__make = 'toyota corolla'::text) AND (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_195____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_195____inner_view
          GROUP BY car_1__car_1___n1_195____inner_view.cars_data__year
         HAVING (count(*) > 29))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__accelerate >= (18.5)::double precision)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_24____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_24____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_24____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (NOT (((car_1__car_1.car_names__make = 'toyota corolla'::text) AND (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_195____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_195____inner_view
          GROUP BY car_1__car_1___n1_195____inner_view.cars_data__year
         HAVING (count(*) > 29))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__accelerate >= (18.5)::double precision))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_24____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_25____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_25____inner_view AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_43____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_43____inner_view
          GROUP BY car_1__car_1___n1_43____inner_view.cars_data__year
         HAVING (count(*) >= 36)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_36____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_36____inner_view
          GROUP BY car_1__car_1___n1_36____inner_view.cars_data__year
         HAVING (count(*) < 9)))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_25____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_25____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_25____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (NOT (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_43____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_43____inner_view
          GROUP BY car_1__car_1___n1_43____inner_view.cars_data__year
         HAVING (count(*) >= 36)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_36____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_36____inner_view
          GROUP BY car_1__car_1___n1_36____inner_view.cars_data__year
         HAVING (count(*) < 9)))) AND (car_1__car_1.cars_data__year IS NOT NULL)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_25____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_26____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_26____inner_view AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND ((car_1__car_1.cars_data__accelerate < (15.5)::double precision) OR ((EXISTS ( SELECT DISTINCT car_1__car_1___n1_121____inner_view.cars_data__id
           FROM public.car_1__car_1___n1_121____inner_view
          WHERE (car_1__car_1___n1_121____inner_view.cars_data__id = car_1__car_1.cars_data__id))) AND (NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_56____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_56____inner_view
          GROUP BY car_1__car_1___n1_56____inner_view.cars_data__year
         HAVING (count(*) <= 29)))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_26____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_26____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_26____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__accelerate < (15.5)::double precision) OR ((EXISTS ( SELECT DISTINCT car_1__car_1___n1_121____inner_view.cars_data__id
           FROM public.car_1__car_1___n1_121____inner_view
          WHERE (car_1__car_1___n1_121____inner_view.cars_data__id = car_1__car_1.cars_data__id))) AND (NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_56____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_56____inner_view
          GROUP BY car_1__car_1___n1_56____inner_view.cars_data__year
         HAVING (count(*) <= 29)))) AND (car_1__car_1.cars_data__year IS NOT NULL)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_26____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_27____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_27____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_150____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_150____inner_view
          GROUP BY car_1__car_1___n1_150____inner_view.cars_data__year
         HAVING ((count(*) >= 9) AND (count(*) < 28))))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_299____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_299____inner_view
          GROUP BY car_1__car_1___n1_299____inner_view.cars_data__year
         HAVING (count(*) >= 28))) AND (car_1__car_1.cars_data__year IS NOT NULL)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_27____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_27____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_27____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_150____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_150____inner_view
          GROUP BY car_1__car_1___n1_150____inner_view.cars_data__year
         HAVING ((count(*) >= 9) AND (count(*) < 28))))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_299____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_299____inner_view
          GROUP BY car_1__car_1___n1_299____inner_view.cars_data__year
         HAVING (count(*) >= 28))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_27____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_28____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_28____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_45____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_45____inner_view
          GROUP BY car_1__car_1___n1_45____inner_view.cars_data__year
         HAVING (count(*) >= 28)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_245____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_245____inner_view
          GROUP BY car_1__car_1___n1_245____inner_view.cars_data__year
         HAVING (count(*) >= 4)
          ORDER BY car_1__car_1___n1_245____inner_view.cars_data__year
         LIMIT 5))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_28____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_28____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_28____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_45____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_45____inner_view
          GROUP BY car_1__car_1___n1_45____inner_view.cars_data__year
         HAVING (count(*) >= 28)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_245____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_245____inner_view
          GROUP BY car_1__car_1___n1_245____inner_view.cars_data__year
         HAVING (count(*) >= 4)
          ORDER BY car_1__car_1___n1_245____inner_view.cars_data__year
         LIMIT 5))) AND (car_1__car_1.cars_data__year IS NOT NULL)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_28____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_29____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_29____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_284____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_284____inner_view
          GROUP BY car_1__car_1___n1_284____inner_view.cars_data__year
         HAVING (count(*) < 4)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((car_1__car_1.cars_data__weight > 3282) AND (car_1__car_1.cars_data__weight <= 3336)) OR (car_1__car_1.cars_data__year <> 1971)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_29____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_29____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_29____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_284____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_284____inner_view
          GROUP BY car_1__car_1___n1_284____inner_view.cars_data__year
         HAVING (count(*) < 4)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((car_1__car_1.cars_data__weight > 3282) AND (car_1__car_1.cars_data__weight <= 3336)) OR (car_1__car_1.cars_data__year <> 1971))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_29____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_2____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_2____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_145____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_145____inner_view
          GROUP BY car_1__car_1___n1_145____inner_view.cars_data__year
         HAVING (count(*) > 11)))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (EXISTS ( SELECT DISTINCT car_1__car_1___n1_135____inner_view.cars_data__id
           FROM public.car_1__car_1___n1_135____inner_view
          WHERE (car_1__car_1___n1_135____inner_view.cars_data__id = car_1__car_1.cars_data__id)))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_2____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_2____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_2____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_145____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_145____inner_view
          GROUP BY car_1__car_1___n1_145____inner_view.cars_data__year
         HAVING (count(*) > 11)))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (EXISTS ( SELECT DISTINCT car_1__car_1___n1_135____inner_view.cars_data__id
           FROM public.car_1__car_1___n1_135____inner_view
          WHERE (car_1__car_1___n1_135____inner_view.cars_data__id = car_1__car_1.cars_data__id))))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_2____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_30____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_30____inner_view AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_122____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_122____inner_view
          GROUP BY car_1__car_1___n1_122____inner_view.cars_data__year
         HAVING ((count(*) > 27) AND (count(*) <= 31))))) AND (car_1__car_1.cars_data__year IS NOT NULL)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_30____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_30____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_30____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (NOT ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_122____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_122____inner_view
          GROUP BY car_1__car_1___n1_122____inner_view.cars_data__year
         HAVING ((count(*) > 27) AND (count(*) <= 31))))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_30____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_31____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_31____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_107____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_107____inner_view
          GROUP BY car_1__car_1___n1_107____inner_view.cars_data__year
         HAVING (count(*) > 19)
          ORDER BY car_1__car_1___n1_107____inner_view.cars_data__year
         LIMIT 3))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((car_1__car_1.cars_data__edispl <= (122.0)::double precision) AND (NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_5____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_5____inner_view
          GROUP BY car_1__car_1___n1_5____inner_view.cars_data__year
         HAVING ((count(*) > 28) AND (count(*) < 40))))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__horsepower <> (18)::double precision)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_31____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_31____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_31____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (NOT (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_107____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_107____inner_view
          GROUP BY car_1__car_1___n1_107____inner_view.cars_data__year
         HAVING (count(*) > 19)
          ORDER BY car_1__car_1___n1_107____inner_view.cars_data__year
         LIMIT 3))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((car_1__car_1.cars_data__edispl <= (122.0)::double precision) AND (NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_5____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_5____inner_view
          GROUP BY car_1__car_1___n1_5____inner_view.cars_data__year
         HAVING ((count(*) > 28) AND (count(*) < 40))))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__horsepower <> (18)::double precision))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_31____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_32____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_32____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_222____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_222____inner_view
          GROUP BY car_1__car_1___n1_222____inner_view.cars_data__year
         HAVING (count(*) <= 29)))) AND (car_1__car_1.cars_data__year IS NOT NULL)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_32____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_32____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_32____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_222____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_222____inner_view
          GROUP BY car_1__car_1___n1_222____inner_view.cars_data__year
         HAVING (count(*) <= 29)))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_32____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_33____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_33____inner_view AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (((car_1__car_1.cars_data__accelerate >= (14.5)::double precision) AND (car_1__car_1.cars_data__accelerate <= (17.0)::double precision) AND (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_3____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_3____inner_view
          GROUP BY car_1__car_1___n1_3____inner_view.cars_data__year
         HAVING ((count(*) >= 4) AND (count(*) < 12)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__accelerate < (16.7)::double precision) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_290____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_290____inner_view
          GROUP BY car_1__car_1___n1_290____inner_view.cars_data__year
         HAVING ((count(*) > 28) AND (count(*) < 40))))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_33____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_33____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_33____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (NOT (((car_1__car_1.cars_data__accelerate >= (14.5)::double precision) AND (car_1__car_1.cars_data__accelerate <= (17.0)::double precision) AND (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_3____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_3____inner_view
          GROUP BY car_1__car_1___n1_3____inner_view.cars_data__year
         HAVING ((count(*) >= 4) AND (count(*) < 12)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__accelerate < (16.7)::double precision) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_290____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_290____inner_view
          GROUP BY car_1__car_1___n1_290____inner_view.cars_data__year
         HAVING ((count(*) > 28) AND (count(*) < 40))))) AND (car_1__car_1.cars_data__year IS NOT NULL)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_33____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_34____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_34____inner_view AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND ((car_1__car_1.cars_data__horsepower <= (30)::double precision) AND (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_275____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_275____inner_view
          GROUP BY car_1__car_1___n1_275____inner_view.cars_data__year
         HAVING (count(*) > 28))) AND (car_1__car_1.cars_data__year IS NOT NULL)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_34____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_34____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_34____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__horsepower <= (30)::double precision) AND (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_275____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_275____inner_view
          GROUP BY car_1__car_1___n1_275____inner_view.cars_data__year
         HAVING (count(*) > 28))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_34____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_35____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_35____inner_view AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_5____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_5____inner_view
          GROUP BY car_1__car_1___n1_5____inner_view.cars_data__year
         HAVING ((count(*) > 28) AND (count(*) < 40))))) AND (car_1__car_1.cars_data__year IS NOT NULL)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_35____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_35____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_35____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (NOT ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_5____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_5____inner_view
          GROUP BY car_1__car_1___n1_5____inner_view.cars_data__year
         HAVING ((count(*) > 28) AND (count(*) < 40))))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_35____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_36____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_36____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_54____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_54____inner_view
          GROUP BY car_1__car_1___n1_54____inner_view.cars_data__year
         HAVING (count(*) > 29)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (NOT (EXISTS ( SELECT DISTINCT car_1__car_1___n1_2____inner_view.car_makers__maker
           FROM public.car_1__car_1___n1_2____inner_view
          WHERE (car_1__car_1___n1_2____inner_view.car_makers__maker = car_1__car_1.car_makers__maker))))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_36____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_36____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_36____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_54____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_54____inner_view
          GROUP BY car_1__car_1___n1_54____inner_view.cars_data__year
         HAVING (count(*) > 29)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (NOT (EXISTS ( SELECT DISTINCT car_1__car_1___n1_2____inner_view.car_makers__maker
           FROM public.car_1__car_1___n1_2____inner_view
          WHERE (car_1__car_1___n1_2____inner_view.car_makers__maker = car_1__car_1.car_makers__maker)))))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_36____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_37____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_37____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_127____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_127____inner_view
          GROUP BY car_1__car_1___n1_127____inner_view.cars_data__year
         HAVING (count(*) < 31)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((car_1__car_1.cars_data__horsepower >= (16)::double precision) AND (car_1__car_1.cars_data__horsepower < (35)::double precision)) OR ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_148____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_148____inner_view
          GROUP BY car_1__car_1___n1_148____inner_view.cars_data__year
         HAVING (count(*) <= 29))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_37____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_37____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_37____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_127____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_127____inner_view
          GROUP BY car_1__car_1___n1_127____inner_view.cars_data__year
         HAVING (count(*) < 31)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((car_1__car_1.cars_data__horsepower >= (16)::double precision) AND (car_1__car_1.cars_data__horsepower < (35)::double precision)) OR ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_148____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_148____inner_view
          GROUP BY car_1__car_1___n1_148____inner_view.cars_data__year
         HAVING (count(*) <= 29))) AND (car_1__car_1.cars_data__year IS NOT NULL)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_37____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_38____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_38____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND ((car_1__car_1.cars_data__edispl < (122.0)::double precision) OR ((car_1__car_1.cars_data__cylinders = 4) AND (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_190____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_190____inner_view
          GROUP BY car_1__car_1___n1_190____inner_view.cars_data__year
         HAVING (count(*) <= 36))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_38____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_38____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_38____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__edispl < (122.0)::double precision) OR ((car_1__car_1.cars_data__cylinders = 4) AND (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_190____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_190____inner_view
          GROUP BY car_1__car_1___n1_190____inner_view.cars_data__year
         HAVING (count(*) <= 36))) AND (car_1__car_1.cars_data__year IS NOT NULL)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_38____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_39____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_39____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND ((EXISTS ( SELECT DISTINCT car_1__car_1___n1_181____inner_view.car_makers__id
           FROM public.car_1__car_1___n1_181____inner_view
          WHERE (car_1__car_1___n1_181____inner_view.car_makers__id = car_1__car_1.car_makers__id))) OR (car_1__car_1.cars_data__edispl > (134.0)::double precision)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_39____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_39____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_39____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT ((EXISTS ( SELECT DISTINCT car_1__car_1___n1_181____inner_view.car_makers__id
           FROM public.car_1__car_1___n1_181____inner_view
          WHERE (car_1__car_1___n1_181____inner_view.car_makers__id = car_1__car_1.car_makers__id))) OR (car_1__car_1.cars_data__edispl > (134.0)::double precision))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_39____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_3____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_3____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_24____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_24____inner_view
          GROUP BY car_1__car_1___n1_24____inner_view.cars_data__year
         HAVING ((count(*) > 27) AND (count(*) <= 31))))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__mpg >= (28.0)::double precision)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_3____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_3____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_3____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (NOT (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_24____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_24____inner_view
          GROUP BY car_1__car_1___n1_24____inner_view.cars_data__year
         HAVING ((count(*) > 27) AND (count(*) <= 31))))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__mpg >= (28.0)::double precision))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_3____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_40____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_40____inner_view AS
 SELECT DISTINCT car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__id IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_39____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_39____inner_view
          GROUP BY car_1__car_1___n1_39____inner_view.cars_data__year
         HAVING (count(*) >= 28))) AND (car_1__car_1.cars_data__year IS NOT NULL)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_40____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_40____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_40____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__id IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_39____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_39____inner_view
          GROUP BY car_1__car_1___n1_39____inner_view.cars_data__year
         HAVING (count(*) >= 28))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_40____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_41____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_41____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_211____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_211____inner_view
          GROUP BY car_1__car_1___n1_211____inner_view.cars_data__year
         HAVING (count(*) >= 35)))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.cars_data__weight <> 3085) AND (car_1__car_1.cars_data__horsepower > (13)::double precision)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_41____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_41____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_41____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_211____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_211____inner_view
          GROUP BY car_1__car_1___n1_211____inner_view.cars_data__year
         HAVING (count(*) >= 35)))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.cars_data__weight <> 3085) AND (car_1__car_1.cars_data__horsepower > (13)::double precision))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_41____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_42____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_42____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (((car_1__car_1.car_makers__id IN ( SELECT DISTINCT car_1__car_1___n1_13____inner_view.car_makers__id
           FROM public.car_1__car_1___n1_13____inner_view)) AND (car_1__car_1.car_makers__id IS NOT NULL)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_222____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_222____inner_view
          GROUP BY car_1__car_1___n1_222____inner_view.cars_data__year
         HAVING (count(*) <= 29)))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_42____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_42____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_42____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT (((car_1__car_1.car_makers__id IN ( SELECT DISTINCT car_1__car_1___n1_13____inner_view.car_makers__id
           FROM public.car_1__car_1___n1_13____inner_view)) AND (car_1__car_1.car_makers__id IS NOT NULL)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_222____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_222____inner_view
          GROUP BY car_1__car_1___n1_222____inner_view.cars_data__year
         HAVING (count(*) <= 29)))) AND (car_1__car_1.cars_data__year IS NOT NULL)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_42____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_43____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_43____inner_view AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_0____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_0____inner_view
          GROUP BY car_1__car_1___n1_0____inner_view.cars_data__year
         HAVING (count(*) < 29)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((car_1__car_1.car_names__make = ANY (ARRAY['amc matador'::text, 'dodge colt m/m'::text])) AND (car_1__car_1.cars_data__cylinders > 4) AND (car_1__car_1.cars_data__cylinders <= 6)) OR ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_131____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_131____inner_view
          GROUP BY car_1__car_1___n1_131____inner_view.cars_data__year
         HAVING ((count(*) > 27) AND (count(*) <= 34)))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_43____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_43____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_43____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (NOT (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_0____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_0____inner_view
          GROUP BY car_1__car_1___n1_0____inner_view.cars_data__year
         HAVING (count(*) < 29)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((car_1__car_1.car_names__make = ANY (ARRAY['amc matador'::text, 'dodge colt m/m'::text])) AND (car_1__car_1.cars_data__cylinders > 4) AND (car_1__car_1.cars_data__cylinders <= 6)) OR ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_131____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_131____inner_view
          GROUP BY car_1__car_1___n1_131____inner_view.cars_data__year
         HAVING ((count(*) > 27) AND (count(*) <= 34)))) AND (car_1__car_1.cars_data__year IS NOT NULL)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_43____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_44____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_44____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND ((car_1__car_1.cars_data__horsepower < (19)::double precision) OR ((car_1__car_1.cars_data__horsepower <= (43)::double precision) AND (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_24____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_24____inner_view
          GROUP BY car_1__car_1___n1_24____inner_view.cars_data__year
         HAVING ((count(*) > 27) AND (count(*) <= 31)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((NOT (car_1__car_1.car_names__make IN ( SELECT DISTINCT car_1__car_1___n1_277____inner_view.car_names__make
           FROM public.car_1__car_1___n1_277____inner_view
          WHERE (car_1__car_1___n1_277____inner_view.car_names__makeid = car_1__car_1.car_names__makeid)))) AND (car_1__car_1.car_names__make IS NOT NULL))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_44____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_44____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_44____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__horsepower < (19)::double precision) OR ((car_1__car_1.cars_data__horsepower <= (43)::double precision) AND (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_24____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_24____inner_view
          GROUP BY car_1__car_1___n1_24____inner_view.cars_data__year
         HAVING ((count(*) > 27) AND (count(*) <= 31)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((NOT (car_1__car_1.car_names__make IN ( SELECT DISTINCT car_1__car_1___n1_277____inner_view.car_names__make
           FROM public.car_1__car_1___n1_277____inner_view
          WHERE (car_1__car_1___n1_277____inner_view.car_names__makeid = car_1__car_1.car_names__makeid)))) AND (car_1__car_1.car_names__make IS NOT NULL)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_44____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_45____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_45____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (((car_1__car_1.cars_data__cylinders >= 4) AND (car_1__car_1.cars_data__cylinders < 8)) OR (car_1__car_1.cars_data__cylinders >= 8) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_129____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_129____inner_view
          GROUP BY car_1__car_1___n1_129____inner_view.cars_data__year
         HAVING (count(*) > 30)))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_45____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_45____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_45____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (((car_1__car_1.cars_data__cylinders >= 4) AND (car_1__car_1.cars_data__cylinders < 8)) OR (car_1__car_1.cars_data__cylinders >= 8) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_129____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_129____inner_view
          GROUP BY car_1__car_1___n1_129____inner_view.cars_data__year
         HAVING (count(*) > 30)))) AND (car_1__car_1.cars_data__year IS NOT NULL)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_45____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_46____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_46____inner_view AS
 SELECT DISTINCT car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__id IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_203____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_203____inner_view
          GROUP BY car_1__car_1___n1_203____inner_view.cars_data__year
         HAVING (count(*) <= 15)
          ORDER BY car_1__car_1___n1_203____inner_view.cars_data__year
         LIMIT 5))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.car_makers__fullname <> 'American Motor Company'::text)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_46____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_46____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_46____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__id IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (NOT (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_203____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_203____inner_view
          GROUP BY car_1__car_1___n1_203____inner_view.cars_data__year
         HAVING (count(*) <= 15)
          ORDER BY car_1__car_1___n1_203____inner_view.cars_data__year
         LIMIT 5))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.car_makers__fullname <> 'American Motor Company'::text))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_46____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_47____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_47____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_129____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_129____inner_view
          GROUP BY car_1__car_1___n1_129____inner_view.cars_data__year
         HAVING (count(*) > 30))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((car_1__car_1.cars_data__cylinders <> 6) AND (NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_150____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_150____inner_view
          WHERE (car_1__car_1___n1_150____inner_view.cars_data__cylinders = car_1__car_1.cars_data__cylinders)
          GROUP BY car_1__car_1___n1_150____inner_view.cars_data__year
         HAVING ((count(*) >= 9) AND (count(*) < 28))))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_47____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_47____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_47____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_129____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_129____inner_view
          GROUP BY car_1__car_1___n1_129____inner_view.cars_data__year
         HAVING (count(*) > 30))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((car_1__car_1.cars_data__cylinders <> 6) AND (NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_150____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_150____inner_view
          WHERE (car_1__car_1___n1_150____inner_view.cars_data__cylinders = car_1__car_1.cars_data__cylinders)
          GROUP BY car_1__car_1___n1_150____inner_view.cars_data__year
         HAVING ((count(*) >= 9) AND (count(*) < 28))))) AND (car_1__car_1.cars_data__year IS NOT NULL)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_47____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_48____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_48____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_91____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_91____inner_view
          GROUP BY car_1__car_1___n1_91____inner_view.cars_data__year
         HAVING ((count(*) > 27) AND (count(*) <= 29))
          ORDER BY car_1__car_1___n1_91____inner_view.cars_data__year
         LIMIT 2))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.cars_data__horsepower > (29)::double precision)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_48____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_48____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_48____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_91____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_91____inner_view
          GROUP BY car_1__car_1___n1_91____inner_view.cars_data__year
         HAVING ((count(*) > 27) AND (count(*) <= 29))
          ORDER BY car_1__car_1___n1_91____inner_view.cars_data__year
         LIMIT 2))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.cars_data__horsepower > (29)::double precision))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_48____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_49____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_49____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_280____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_280____inner_view
          GROUP BY car_1__car_1___n1_280____inner_view.cars_data__year
         HAVING ((count(*) > 26) AND (count(*) < 31))
          ORDER BY car_1__car_1___n1_280____inner_view.cars_data__year
         LIMIT 2))) AND (car_1__car_1.cars_data__year IS NOT NULL)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_49____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_49____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_49____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (NOT ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_280____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_280____inner_view
          GROUP BY car_1__car_1___n1_280____inner_view.cars_data__year
         HAVING ((count(*) > 26) AND (count(*) < 31))
          ORDER BY car_1__car_1___n1_280____inner_view.cars_data__year
         LIMIT 2))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_49____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_4____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_4____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND ((car_1__car_1.cars_data__cylinders > 4) AND (NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_142____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_142____inner_view
          WHERE (car_1__car_1___n1_142____inner_view.cars_data__cylinders = car_1__car_1.cars_data__cylinders)))) AND (car_1__car_1.cars_data__year IS NOT NULL)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_4____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_4____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_4____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__cylinders > 4) AND (NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_142____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_142____inner_view
          WHERE (car_1__car_1___n1_142____inner_view.cars_data__cylinders = car_1__car_1.cars_data__cylinders)))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_4____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_50____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_50____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND ((car_1__car_1.cars_data__year >= ( SELECT DISTINCT car_1__car_1___n1_138____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_138____inner_view
          GROUP BY car_1__car_1___n1_138____inner_view.cars_data__year
         HAVING ((count(*) >= 27) AND (count(*) < 30))
          ORDER BY car_1__car_1___n1_138____inner_view.cars_data__year
         LIMIT 1)) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_295____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_295____inner_view
          GROUP BY car_1__car_1___n1_295____inner_view.cars_data__year
         HAVING ((count(*) > 30) AND (count(*) < 36))))) AND (car_1__car_1.cars_data__year IS NOT NULL)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_50____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_50____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_50____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__year >= ( SELECT DISTINCT car_1__car_1___n1_138____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_138____inner_view
          GROUP BY car_1__car_1___n1_138____inner_view.cars_data__year
         HAVING ((count(*) >= 27) AND (count(*) < 30))
          ORDER BY car_1__car_1___n1_138____inner_view.cars_data__year
         LIMIT 1)) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_295____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_295____inner_view
          GROUP BY car_1__car_1___n1_295____inner_view.cars_data__year
         HAVING ((count(*) > 30) AND (count(*) < 36))))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_50____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_51____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_51____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_205____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_205____inner_view
          GROUP BY car_1__car_1___n1_205____inner_view.cars_data__year
         HAVING (count(*) >= 15)))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.cars_data__mpg <= (26.0)::double precision)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_51____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_51____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_51____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_205____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_205____inner_view
          GROUP BY car_1__car_1___n1_205____inner_view.cars_data__year
         HAVING (count(*) >= 15)))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.cars_data__mpg <= (26.0)::double precision))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_51____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_52____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_52____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_267____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_267____inner_view
          GROUP BY car_1__car_1___n1_267____inner_view.cars_data__year
         HAVING (count(*) >= 10))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.car_makers__maker <> ALL (ARRAY['chrysler'::text, 'opel'::text, 'renault'::text])) OR (car_1__car_1.car_names__make = 'dodge coronet brougham'::text)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_52____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_52____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_52____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT (((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_267____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_267____inner_view
          GROUP BY car_1__car_1___n1_267____inner_view.cars_data__year
         HAVING (count(*) >= 10))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.car_makers__maker <> ALL (ARRAY['chrysler'::text, 'opel'::text, 'renault'::text])) OR (car_1__car_1.car_names__make = 'dodge coronet brougham'::text))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_52____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_53____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_53____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_190____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_190____inner_view
          GROUP BY car_1__car_1___n1_190____inner_view.cars_data__year
         HAVING (count(*) <= 36))) AND (car_1__car_1.cars_data__year IS NOT NULL)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_53____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_53____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_53____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_190____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_190____inner_view
          GROUP BY car_1__car_1___n1_190____inner_view.cars_data__year
         HAVING (count(*) <= 36))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_53____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_54____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_54____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__cylinders > 4) OR ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_163____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_163____inner_view
          GROUP BY car_1__car_1___n1_163____inner_view.cars_data__year
         HAVING (count(*) <= 28))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.cars_data__cylinders < 4))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_54____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_54____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_54____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__cylinders > 4) OR ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_163____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_163____inner_view
          GROUP BY car_1__car_1___n1_163____inner_view.cars_data__year
         HAVING (count(*) <= 28))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.cars_data__cylinders < 4)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_54____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_55____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_55____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_150____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_150____inner_view
          GROUP BY car_1__car_1___n1_150____inner_view.cars_data__year
         HAVING ((count(*) >= 9) AND (count(*) < 28))))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_64____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_64____inner_view
          GROUP BY car_1__car_1___n1_64____inner_view.cars_data__year
         HAVING (count(*) < 35)))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_55____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_55____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_55____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_150____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_150____inner_view
          GROUP BY car_1__car_1___n1_150____inner_view.cars_data__year
         HAVING ((count(*) >= 9) AND (count(*) < 28))))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_64____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_64____inner_view
          GROUP BY car_1__car_1___n1_64____inner_view.cars_data__year
         HAVING (count(*) < 35)))) AND (car_1__car_1.cars_data__year IS NOT NULL)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_55____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_56____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_56____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (((car_1__car_1.cars_data__weight >= 2228) AND (car_1__car_1.cars_data__weight <= 2807)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_43____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_43____inner_view
          GROUP BY car_1__car_1___n1_43____inner_view.cars_data__year
         HAVING (count(*) >= 36)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.car_makers__fullname = ANY (ARRAY['General Motors'::text, 'Chrysler'::text, 'American Motor Company'::text]))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_56____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_56____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_56____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT (((car_1__car_1.cars_data__weight >= 2228) AND (car_1__car_1.cars_data__weight <= 2807)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_43____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_43____inner_view
          GROUP BY car_1__car_1___n1_43____inner_view.cars_data__year
         HAVING (count(*) >= 36)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.car_makers__fullname = ANY (ARRAY['General Motors'::text, 'Chrysler'::text, 'American Motor Company'::text])))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_56____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_57____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_57____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_224____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_224____inner_view
          WHERE (car_1__car_1___n1_224____inner_view.cars_data__id = car_1__car_1.cars_data__id)
          GROUP BY car_1__car_1___n1_224____inner_view.cars_data__year
         HAVING (count(*) < 27)
          ORDER BY car_1__car_1___n1_224____inner_view.cars_data__year
         LIMIT 5))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_0____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_0____inner_view
          GROUP BY car_1__car_1___n1_0____inner_view.cars_data__year
         HAVING (count(*) < 29)))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.continents__continent = 'asia'::text))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_57____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_57____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_57____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_224____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_224____inner_view
          WHERE (car_1__car_1___n1_224____inner_view.cars_data__id = car_1__car_1.cars_data__id)
          GROUP BY car_1__car_1___n1_224____inner_view.cars_data__year
         HAVING (count(*) < 27)
          ORDER BY car_1__car_1___n1_224____inner_view.cars_data__year
         LIMIT 5))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_0____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_0____inner_view
          GROUP BY car_1__car_1___n1_0____inner_view.cars_data__year
         HAVING (count(*) < 29)))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.continents__continent = 'asia'::text)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_57____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_58____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_58____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND ((car_1__car_1.cars_data__weight >= 2155) AND (car_1__car_1.cars_data__weight < 2265) AND (car_1__car_1.car_makers__fullname ~~ 'Gen%'::text) AND (NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_79____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_79____inner_view
          GROUP BY car_1__car_1___n1_79____inner_view.cars_data__year
         HAVING (count(*) > 30)))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (( SELECT DISTINCT count(car_1__car_1___n1_97____inner_view.*) AS count
           FROM public.car_1__car_1___n1_97____inner_view
          WHERE (car_1__car_1___n1_97____inner_view.car_names__model = car_1__car_1.car_names__model)) <> 1)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_58____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_58____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_58____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__weight >= 2155) AND (car_1__car_1.cars_data__weight < 2265) AND (car_1__car_1.car_makers__fullname ~~ 'Gen%'::text) AND (NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_79____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_79____inner_view
          GROUP BY car_1__car_1___n1_79____inner_view.cars_data__year
         HAVING (count(*) > 30)))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (( SELECT DISTINCT count(car_1__car_1___n1_97____inner_view.*) AS count
           FROM public.car_1__car_1___n1_97____inner_view
          WHERE (car_1__car_1___n1_97____inner_view.car_names__model = car_1__car_1.car_names__model)) <> 1))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_58____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_59____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_59____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_39____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_39____inner_view
          GROUP BY car_1__car_1___n1_39____inner_view.cars_data__year
         HAVING (count(*) >= 28))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (NOT (EXISTS ( SELECT DISTINCT car_1__car_1___n1_181____inner_view.car_makers__fullname
           FROM public.car_1__car_1___n1_181____inner_view
          WHERE (car_1__car_1___n1_181____inner_view.car_makers__fullname = car_1__car_1.car_makers__fullname))))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_59____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_59____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_59____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT (((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_39____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_39____inner_view
          GROUP BY car_1__car_1___n1_39____inner_view.cars_data__year
         HAVING (count(*) >= 28))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (NOT (EXISTS ( SELECT DISTINCT car_1__car_1___n1_181____inner_view.car_makers__fullname
           FROM public.car_1__car_1___n1_181____inner_view
          WHERE (car_1__car_1___n1_181____inner_view.car_makers__fullname = car_1__car_1.car_makers__fullname)))))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_59____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_5____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_5____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_28____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_28____inner_view
          GROUP BY car_1__car_1___n1_28____inner_view.cars_data__year
         HAVING ((count(*) > 34) AND (count(*) < 40)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__edispl < (122.0)::double precision)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_5____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_5____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_5____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_28____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_28____inner_view
          GROUP BY car_1__car_1___n1_28____inner_view.cars_data__year
         HAVING ((count(*) > 34) AND (count(*) < 40)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__edispl < (122.0)::double precision))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_5____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_60____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_60____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_59____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_59____inner_view
          GROUP BY car_1__car_1___n1_59____inner_view.cars_data__year
         HAVING ((count(*) >= 6) AND (count(*) <= 10)))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.car_names__make = 'ford pinto'::text)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_60____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_60____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_60____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_59____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_59____inner_view
          GROUP BY car_1__car_1___n1_59____inner_view.cars_data__year
         HAVING ((count(*) >= 6) AND (count(*) <= 10)))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.car_names__make = 'ford pinto'::text))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_60____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_61____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_61____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (((car_1__car_1.cars_data__accelerate IN ( SELECT DISTINCT car_1__car_1___n1_126____inner_view.cars_data__accelerate
           FROM public.car_1__car_1___n1_126____inner_view)) AND (car_1__car_1.cars_data__accelerate IS NOT NULL)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_26____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_26____inner_view
          GROUP BY car_1__car_1___n1_26____inner_view.cars_data__year
         HAVING (count(*) <= 35)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((car_1__car_1.cars_data__cylinders = 4) AND (car_1__car_1.continents__continent = 'america'::text))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_61____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_61____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_61____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT (((car_1__car_1.cars_data__accelerate IN ( SELECT DISTINCT car_1__car_1___n1_126____inner_view.cars_data__accelerate
           FROM public.car_1__car_1___n1_126____inner_view)) AND (car_1__car_1.cars_data__accelerate IS NOT NULL)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_26____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_26____inner_view
          GROUP BY car_1__car_1___n1_26____inner_view.cars_data__year
         HAVING (count(*) <= 35)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((car_1__car_1.cars_data__cylinders = 4) AND (car_1__car_1.continents__continent = 'america'::text)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_61____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_62____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_62____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_207____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_207____inner_view
          GROUP BY car_1__car_1___n1_207____inner_view.cars_data__year
         HAVING (count(*) <= 35))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.car_makers__fullname <> ALL (ARRAY['Ford Motor Company'::text, 'General Motors'::text])) OR (car_1__car_1.car_makers__fullname = 'Ford Motor Company'::text) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_140____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_140____inner_view
          GROUP BY car_1__car_1___n1_140____inner_view.cars_data__year
         HAVING ((count(*) >= 7) AND (count(*) < 13))))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_62____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_62____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_62____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT (((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_207____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_207____inner_view
          GROUP BY car_1__car_1___n1_207____inner_view.cars_data__year
         HAVING (count(*) <= 35))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.car_makers__fullname <> ALL (ARRAY['Ford Motor Company'::text, 'General Motors'::text])) OR (car_1__car_1.car_makers__fullname = 'Ford Motor Company'::text) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_140____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_140____inner_view
          GROUP BY car_1__car_1___n1_140____inner_view.cars_data__year
         HAVING ((count(*) >= 7) AND (count(*) < 13))))) AND (car_1__car_1.cars_data__year IS NOT NULL)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_62____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_63____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_63____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_188____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_188____inner_view
          GROUP BY car_1__car_1___n1_188____inner_view.cars_data__year
         HAVING (count(*) > 30))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__year > 1971)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_63____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_63____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_63____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_188____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_188____inner_view
          GROUP BY car_1__car_1___n1_188____inner_view.cars_data__year
         HAVING (count(*) > 30))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__year > 1971))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_63____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_64____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_64____inner_view AS
 SELECT DISTINCT car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__id IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_64____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_64____inner_view
          GROUP BY car_1__car_1___n1_64____inner_view.cars_data__year
         HAVING (count(*) < 35))) AND (car_1__car_1.cars_data__year IS NOT NULL)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_64____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_64____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_64____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__id IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_64____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_64____inner_view
          GROUP BY car_1__car_1___n1_64____inner_view.cars_data__year
         HAVING (count(*) < 35))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_64____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_65____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_65____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__edispl < (383.0)::double precision) OR ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_70____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_70____inner_view
          GROUP BY car_1__car_1___n1_70____inner_view.cars_data__year
         HAVING ((count(*) >= 27) AND (count(*) <= 36)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__mpg = (12.0)::double precision)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_65____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_65____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_65____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__edispl < (383.0)::double precision) OR ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_70____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_70____inner_view
          GROUP BY car_1__car_1___n1_70____inner_view.cars_data__year
         HAVING ((count(*) >= 27) AND (count(*) <= 36)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__mpg = (12.0)::double precision))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_65____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_66____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_66____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (((car_1__car_1.cars_data__edispl <> (113.0)::double precision) AND (car_1__car_1.cars_data__weight >= 2310) AND (car_1__car_1.cars_data__weight <= 3150)) OR ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_259____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_259____inner_view
          GROUP BY car_1__car_1___n1_259____inner_view.cars_data__year
         HAVING (count(*) > 12))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_66____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_66____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_66____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (((car_1__car_1.cars_data__edispl <> (113.0)::double precision) AND (car_1__car_1.cars_data__weight >= 2310) AND (car_1__car_1.cars_data__weight <= 3150)) OR ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_259____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_259____inner_view
          GROUP BY car_1__car_1___n1_259____inner_view.cars_data__year
         HAVING (count(*) > 12))) AND (car_1__car_1.cars_data__year IS NOT NULL)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_66____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_67____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_67____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_218____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_218____inner_view
          GROUP BY car_1__car_1___n1_218____inner_view.cars_data__year
         HAVING (count(*) <= 28)))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.cars_data__weight > 2900) AND (car_1__car_1.cars_data__weight < 3329)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_67____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_67____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_67____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_218____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_218____inner_view
          GROUP BY car_1__car_1___n1_218____inner_view.cars_data__year
         HAVING (count(*) <= 28)))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.cars_data__weight > 2900) AND (car_1__car_1.cars_data__weight < 3329))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_67____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_68____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_68____inner_view AS
 SELECT DISTINCT car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__id IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND ((( SELECT DISTINCT count(car_1__car_1___n1_38____inner_view.countries__continent) AS count
           FROM public.car_1__car_1___n1_38____inner_view
          WHERE (car_1__car_1___n1_38____inner_view.car_makers__country = car_1__car_1.car_makers__country)) <= 1) OR (car_1__car_1.cars_data__weight >= 2228) OR ((car_1__car_1.cars_data__year = ( SELECT DISTINCT car_1__car_1___n1_286____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_286____inner_view
          GROUP BY car_1__car_1___n1_286____inner_view.cars_data__year
         HAVING (count(*) >= 34)
          ORDER BY car_1__car_1___n1_286____inner_view.cars_data__year
         LIMIT 1)) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((car_1__car_1.cars_data__weight >= 1937) AND (car_1__car_1.cars_data__weight < 2035))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_68____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_68____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_68____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.car_makers__id IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (NOT ((( SELECT DISTINCT count(car_1__car_1___n1_38____inner_view.countries__continent) AS count
           FROM public.car_1__car_1___n1_38____inner_view
          WHERE (car_1__car_1___n1_38____inner_view.car_makers__country = car_1__car_1.car_makers__country)) <= 1) OR (car_1__car_1.cars_data__weight >= 2228) OR ((car_1__car_1.cars_data__year = ( SELECT DISTINCT car_1__car_1___n1_286____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_286____inner_view
          GROUP BY car_1__car_1___n1_286____inner_view.cars_data__year
         HAVING (count(*) >= 34)
          ORDER BY car_1__car_1___n1_286____inner_view.cars_data__year
         LIMIT 1)) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((car_1__car_1.cars_data__weight >= 1937) AND (car_1__car_1.cars_data__weight < 2035)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_68____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_69____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_69____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND ((NOT (car_1__car_1.car_makers__maker IN ( SELECT DISTINCT car_1__car_1___n1_292____inner_view.car_makers__maker
           FROM public.car_1__car_1___n1_292____inner_view))) AND (car_1__car_1.car_makers__maker IS NOT NULL) AND (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_11____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_11____inner_view
          GROUP BY car_1__car_1___n1_11____inner_view.cars_data__year
         HAVING ((count(*) > 26) AND (count(*) <= 30)))) AND (car_1__car_1.cars_data__year IS NOT NULL)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_69____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_69____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_69____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT ((NOT (car_1__car_1.car_makers__maker IN ( SELECT DISTINCT car_1__car_1___n1_292____inner_view.car_makers__maker
           FROM public.car_1__car_1___n1_292____inner_view))) AND (car_1__car_1.car_makers__maker IS NOT NULL) AND (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_11____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_11____inner_view
          GROUP BY car_1__car_1___n1_11____inner_view.cars_data__year
         HAVING ((count(*) > 26) AND (count(*) <= 30)))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_69____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_6____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_6____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND ((car_1__car_1.continents__continent = 'america'::text) OR ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_30____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_30____inner_view
          GROUP BY car_1__car_1___n1_30____inner_view.cars_data__year
         HAVING ((count(*) > 2) AND (count(*) <= 9)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_107____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_107____inner_view
          GROUP BY car_1__car_1___n1_107____inner_view.cars_data__year
         HAVING (count(*) > 19)
          ORDER BY car_1__car_1___n1_107____inner_view.cars_data__year
         LIMIT 3))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.continents__continent = 'asia'::text))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_6____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_6____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_6____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT ((car_1__car_1.continents__continent = 'america'::text) OR ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_30____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_30____inner_view
          GROUP BY car_1__car_1___n1_30____inner_view.cars_data__year
         HAVING ((count(*) > 2) AND (count(*) <= 9)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_107____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_107____inner_view
          GROUP BY car_1__car_1___n1_107____inner_view.cars_data__year
         HAVING (count(*) > 19)
          ORDER BY car_1__car_1___n1_107____inner_view.cars_data__year
         LIMIT 3))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.continents__continent = 'asia'::text)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_6____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_70____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_70____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_79____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_79____inner_view
          GROUP BY car_1__car_1___n1_79____inner_view.cars_data__year
         HAVING (count(*) > 30)))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.car_makers__maker = 'gm'::text)) OR (car_1__car_1.cars_data__horsepower < (20)::double precision)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_70____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_70____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_70____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_79____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_79____inner_view
          GROUP BY car_1__car_1___n1_79____inner_view.cars_data__year
         HAVING (count(*) > 30)))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.car_makers__maker = 'gm'::text)) OR (car_1__car_1.cars_data__horsepower < (20)::double precision))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_70____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_71____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_71____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_54____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_54____inner_view
          GROUP BY car_1__car_1___n1_54____inner_view.cars_data__year
         HAVING (count(*) > 29)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.countries__countryname <> ALL (ARRAY['usa'::text, 'japan'::text]))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_71____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_71____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_71____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_54____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_54____inner_view
          GROUP BY car_1__car_1___n1_54____inner_view.cars_data__year
         HAVING (count(*) > 29)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.countries__countryname <> ALL (ARRAY['usa'::text, 'japan'::text])))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_71____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_72____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_72____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_68____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_68____inner_view
          GROUP BY car_1__car_1___n1_68____inner_view.cars_data__year
         HAVING (count(*) >= 19)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__weight > 3160)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_72____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_72____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_72____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (NOT (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_68____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_68____inner_view
          GROUP BY car_1__car_1___n1_68____inner_view.cars_data__year
         HAVING (count(*) >= 19)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__weight > 3160))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_72____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_73____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_73____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND ((car_1__car_1.car_makers__fullname <> 'Toyota'::text) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_20____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_20____inner_view
          GROUP BY car_1__car_1___n1_20____inner_view.cars_data__year
         HAVING ((count(*) > 4) AND (count(*) <= 10))))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_73____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_73____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_73____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT ((car_1__car_1.car_makers__fullname <> 'Toyota'::text) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_20____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_20____inner_view
          GROUP BY car_1__car_1___n1_20____inner_view.cars_data__year
         HAVING ((count(*) > 4) AND (count(*) <= 10))))) AND (car_1__car_1.cars_data__year IS NOT NULL)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_73____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_74____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_74____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (((car_1__car_1.cars_data__weight > 2230) AND (car_1__car_1.cars_data__weight < 4257) AND (( SELECT DISTINCT car_1__car_1___n1_81____inner_view.cars_data__edispl
           FROM public.car_1__car_1___n1_81____inner_view
          WHERE (car_1__car_1___n1_81____inner_view.cars_data__id = car_1__car_1.cars_data__id)
          ORDER BY car_1__car_1___n1_81____inner_view.cars_data__edispl
         LIMIT 1) > (350.0)::double precision)) OR ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_216____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_216____inner_view
          GROUP BY car_1__car_1___n1_216____inner_view.cars_data__year
         HAVING (count(*) > 30))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_74____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_74____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_74____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (((car_1__car_1.cars_data__weight > 2230) AND (car_1__car_1.cars_data__weight < 4257) AND (( SELECT DISTINCT car_1__car_1___n1_81____inner_view.cars_data__edispl
           FROM public.car_1__car_1___n1_81____inner_view
          WHERE (car_1__car_1___n1_81____inner_view.cars_data__id = car_1__car_1.cars_data__id)
          ORDER BY car_1__car_1___n1_81____inner_view.cars_data__edispl
         LIMIT 1) > (350.0)::double precision)) OR ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_216____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_216____inner_view
          GROUP BY car_1__car_1___n1_216____inner_view.cars_data__year
         HAVING (count(*) > 30))) AND (car_1__car_1.cars_data__year IS NOT NULL)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_74____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_75____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_75____inner_view AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_124____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_124____inner_view
          GROUP BY car_1__car_1___n1_124____inner_view.cars_data__year
         HAVING ((count(*) >= 29) AND (count(*) <= 35)))) AND (car_1__car_1.cars_data__year IS NOT NULL)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_75____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_75____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_75____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_124____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_124____inner_view
          GROUP BY car_1__car_1___n1_124____inner_view.cars_data__year
         HAVING ((count(*) >= 29) AND (count(*) <= 35)))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_75____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_76____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_76____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((EXISTS ( SELECT DISTINCT car_1__car_1___n1_23____inner_view.cars_data__accelerate
           FROM public.car_1__car_1___n1_23____inner_view
          WHERE (car_1__car_1___n1_23____inner_view.cars_data__accelerate = car_1__car_1.cars_data__accelerate))) OR ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_170____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_170____inner_view
          GROUP BY car_1__car_1___n1_170____inner_view.cars_data__year
         HAVING ((count(*) >= 27) AND (count(*) <= 29)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__cylinders = 4)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_76____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_76____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_76____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((EXISTS ( SELECT DISTINCT car_1__car_1___n1_23____inner_view.cars_data__accelerate
           FROM public.car_1__car_1___n1_23____inner_view
          WHERE (car_1__car_1___n1_23____inner_view.cars_data__accelerate = car_1__car_1.cars_data__accelerate))) OR ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_170____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_170____inner_view
          GROUP BY car_1__car_1___n1_170____inner_view.cars_data__year
         HAVING ((count(*) >= 27) AND (count(*) <= 29)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__cylinders = 4))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_76____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_77____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_77____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (((car_1__car_1.cars_data__year <= ( SELECT DISTINCT car_1__car_1___n1_286____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_286____inner_view
          GROUP BY car_1__car_1___n1_286____inner_view.cars_data__year
         HAVING (count(*) >= 34)
          ORDER BY car_1__car_1___n1_286____inner_view.cars_data__year
         LIMIT 1)) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_220____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_220____inner_view
          GROUP BY car_1__car_1___n1_220____inner_view.cars_data__year
         HAVING (count(*) < 30)))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_77____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_77____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_77____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (((car_1__car_1.cars_data__year <= ( SELECT DISTINCT car_1__car_1___n1_286____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_286____inner_view
          GROUP BY car_1__car_1___n1_286____inner_view.cars_data__year
         HAVING (count(*) >= 34)
          ORDER BY car_1__car_1___n1_286____inner_view.cars_data__year
         LIMIT 1)) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_220____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_220____inner_view
          GROUP BY car_1__car_1___n1_220____inner_view.cars_data__year
         HAVING (count(*) < 30)))) AND (car_1__car_1.cars_data__year IS NOT NULL)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_77____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_78____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_78____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (((car_1__car_1.cars_data__mpg <> (30.0)::double precision) AND (car_1__car_1.cars_data__edispl >= ( SELECT DISTINCT car_1__car_1___n1_81____inner_view.cars_data__edispl
           FROM public.car_1__car_1___n1_81____inner_view
          ORDER BY car_1__car_1___n1_81____inner_view.cars_data__edispl
         LIMIT 1)) AND (car_1__car_1.cars_data__edispl IS NOT NULL)) OR (car_1__car_1.cars_data__weight <= 3230)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_78____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_78____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_78____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (((car_1__car_1.cars_data__mpg <> (30.0)::double precision) AND (car_1__car_1.cars_data__edispl >= ( SELECT DISTINCT car_1__car_1___n1_81____inner_view.cars_data__edispl
           FROM public.car_1__car_1___n1_81____inner_view
          ORDER BY car_1__car_1___n1_81____inner_view.cars_data__edispl
         LIMIT 1)) AND (car_1__car_1.cars_data__edispl IS NOT NULL)) OR (car_1__car_1.cars_data__weight <= 3230))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_78____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_79____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_79____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (((car_1__car_1.car_names__make <> 'ford pinto'::text) AND (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_195____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_195____inner_view
          GROUP BY car_1__car_1___n1_195____inner_view.cars_data__year
         HAVING (count(*) > 29))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((car_1__car_1.car_names__make ~~ '%for%'::text) AND (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_74____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_74____inner_view
          GROUP BY car_1__car_1___n1_74____inner_view.cars_data__year
         HAVING ((count(*) >= 27) AND (count(*) <= 34)))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_79____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_79____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_79____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (NOT (((car_1__car_1.car_names__make <> 'ford pinto'::text) AND (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_195____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_195____inner_view
          GROUP BY car_1__car_1___n1_195____inner_view.cars_data__year
         HAVING (count(*) > 29))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((car_1__car_1.car_names__make ~~ '%for%'::text) AND (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_74____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_74____inner_view
          GROUP BY car_1__car_1___n1_74____inner_view.cars_data__year
         HAVING ((count(*) >= 27) AND (count(*) <= 34)))) AND (car_1__car_1.cars_data__year IS NOT NULL)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_79____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_7____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_7____inner_view AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_3____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_3____inner_view
          GROUP BY car_1__car_1___n1_3____inner_view.cars_data__year
         HAVING ((count(*) >= 4) AND (count(*) < 12)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__cylinders >= 6) OR (car_1__car_1.cars_data__horsepower < (43)::double precision)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_7____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_7____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_7____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (NOT (((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_3____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_3____inner_view
          GROUP BY car_1__car_1___n1_3____inner_view.cars_data__year
         HAVING ((count(*) >= 4) AND (count(*) < 12)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__cylinders >= 6) OR (car_1__car_1.cars_data__horsepower < (43)::double precision))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_7____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_80____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_80____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__horsepower < (19)::double precision) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_188____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_188____inner_view
          GROUP BY car_1__car_1___n1_188____inner_view.cars_data__year
         HAVING (count(*) > 30)))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_80____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_80____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_80____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__horsepower < (19)::double precision) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_188____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_188____inner_view
          GROUP BY car_1__car_1___n1_188____inner_view.cars_data__year
         HAVING (count(*) > 30)))) AND (car_1__car_1.cars_data__year IS NOT NULL)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_80____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_81____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_81____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (((car_1__car_1.continents__contid IN ( SELECT DISTINCT car_1__car_1___n1_90____inner_view.continents__contid
           FROM public.car_1__car_1___n1_90____inner_view
          WHERE (car_1__car_1___n1_90____inner_view.car_makers__id = car_1__car_1.car_makers__id)
          ORDER BY car_1__car_1___n1_90____inner_view.continents__contid
         LIMIT 3)) AND (car_1__car_1.continents__contid IS NOT NULL)) OR ((car_1__car_1.cars_data__mpg >= (25.0)::double precision) AND (car_1__car_1.cars_data__mpg < (36.0)::double precision)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_295____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_295____inner_view
          GROUP BY car_1__car_1___n1_295____inner_view.cars_data__year
         HAVING ((count(*) > 30) AND (count(*) < 36))))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_81____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_81____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_81____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT (((car_1__car_1.continents__contid IN ( SELECT DISTINCT car_1__car_1___n1_90____inner_view.continents__contid
           FROM public.car_1__car_1___n1_90____inner_view
          WHERE (car_1__car_1___n1_90____inner_view.car_makers__id = car_1__car_1.car_makers__id)
          ORDER BY car_1__car_1___n1_90____inner_view.continents__contid
         LIMIT 3)) AND (car_1__car_1.continents__contid IS NOT NULL)) OR ((car_1__car_1.cars_data__mpg >= (25.0)::double precision) AND (car_1__car_1.cars_data__mpg < (36.0)::double precision)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_295____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_295____inner_view
          GROUP BY car_1__car_1___n1_295____inner_view.cars_data__year
         HAVING ((count(*) > 30) AND (count(*) < 36))))) AND (car_1__car_1.cars_data__year IS NOT NULL)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_81____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_82____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_82____inner_view AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_59____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_59____inner_view
          WHERE (car_1__car_1___n1_59____inner_view.model_list__maker = car_1__car_1.model_list__maker)
          GROUP BY car_1__car_1___n1_59____inner_view.cars_data__year
         HAVING ((count(*) >= 6) AND (count(*) <= 10))))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__cylinders <> 6)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_82____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_82____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_82____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (NOT (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_59____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_59____inner_view
          WHERE (car_1__car_1___n1_59____inner_view.model_list__maker = car_1__car_1.model_list__maker)
          GROUP BY car_1__car_1___n1_59____inner_view.cars_data__year
         HAVING ((count(*) >= 6) AND (count(*) <= 10))))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__cylinders <> 6))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_82____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_83____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_83____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_161____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_161____inner_view
          GROUP BY car_1__car_1___n1_161____inner_view.cars_data__year
         HAVING (count(*) >= 30))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.cars_data__weight <= 3433) AND (car_1__car_1.car_names__make <> 'honda accord lx'::text)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_83____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_83____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_83____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_161____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_161____inner_view
          GROUP BY car_1__car_1___n1_161____inner_view.cars_data__year
         HAVING (count(*) >= 30))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.cars_data__weight <= 3433) AND (car_1__car_1.car_names__make <> 'honda accord lx'::text))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_83____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_84____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_84____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_113____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_113____inner_view
          GROUP BY car_1__car_1___n1_113____inner_view.cars_data__year
         HAVING (count(*) >= 31))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (NOT (car_1__car_1.continents__continent IN ( SELECT DISTINCT car_1__car_1___n1_157____inner_view.continents__continent
           FROM public.car_1__car_1___n1_157____inner_view
          WHERE (car_1__car_1___n1_157____inner_view.continents__contid = car_1__car_1.continents__contid)
          GROUP BY car_1__car_1___n1_157____inner_view.continents__continent
         HAVING ((count(*) > 2) AND (count(*) <= 4))))) AND (car_1__car_1.continents__continent IS NOT NULL)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_84____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_84____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_84____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_113____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_113____inner_view
          GROUP BY car_1__car_1___n1_113____inner_view.cars_data__year
         HAVING (count(*) >= 31))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (NOT (car_1__car_1.continents__continent IN ( SELECT DISTINCT car_1__car_1___n1_157____inner_view.continents__continent
           FROM public.car_1__car_1___n1_157____inner_view
          WHERE (car_1__car_1___n1_157____inner_view.continents__contid = car_1__car_1.continents__contid)
          GROUP BY car_1__car_1___n1_157____inner_view.continents__continent
         HAVING ((count(*) > 2) AND (count(*) <= 4))))) AND (car_1__car_1.continents__continent IS NOT NULL))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_84____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_85____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_85____inner_view AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND ((NOT (car_1__car_1.cars_data__accelerate IN ( SELECT DISTINCT car_1__car_1___n1_126____inner_view.cars_data__accelerate
           FROM public.car_1__car_1___n1_126____inner_view
          WHERE (car_1__car_1___n1_126____inner_view.cars_data__id = car_1__car_1.cars_data__id)))) AND (car_1__car_1.cars_data__accelerate IS NOT NULL) AND (car_1__car_1.cars_data__weight < 3433) AND (NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_133____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_133____inner_view
          GROUP BY car_1__car_1___n1_133____inner_view.cars_data__year
         HAVING (count(*) <= 31)
          ORDER BY car_1__car_1___n1_133____inner_view.cars_data__year
         LIMIT 2))) AND (car_1__car_1.cars_data__year IS NOT NULL)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_85____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_85____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_85____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (NOT ((NOT (car_1__car_1.cars_data__accelerate IN ( SELECT DISTINCT car_1__car_1___n1_126____inner_view.cars_data__accelerate
           FROM public.car_1__car_1___n1_126____inner_view
          WHERE (car_1__car_1___n1_126____inner_view.cars_data__id = car_1__car_1.cars_data__id)))) AND (car_1__car_1.cars_data__accelerate IS NOT NULL) AND (car_1__car_1.cars_data__weight < 3433) AND (NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_133____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_133____inner_view
          GROUP BY car_1__car_1___n1_133____inner_view.cars_data__year
         HAVING (count(*) <= 31)
          ORDER BY car_1__car_1___n1_133____inner_view.cars_data__year
         LIMIT 2))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_85____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_86____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_86____inner_view AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_284____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_284____inner_view
          GROUP BY car_1__car_1___n1_284____inner_view.cars_data__year
         HAVING (count(*) < 4)))) AND (car_1__car_1.cars_data__year IS NOT NULL)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_86____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_86____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_86____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (NOT ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_284____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_284____inner_view
          GROUP BY car_1__car_1___n1_284____inner_view.cars_data__year
         HAVING (count(*) < 4)))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_86____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_87____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_87____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (((car_1__car_1.cars_data__mpg = (15.0)::double precision) AND (car_1__car_1.car_makers__maker <> 'amc'::text)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_20____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_20____inner_view
          GROUP BY car_1__car_1___n1_20____inner_view.cars_data__year
         HAVING ((count(*) > 4) AND (count(*) <= 10))))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_87____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_87____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_87____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT (((car_1__car_1.cars_data__mpg = (15.0)::double precision) AND (car_1__car_1.car_makers__maker <> 'amc'::text)) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_20____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_20____inner_view
          GROUP BY car_1__car_1___n1_20____inner_view.cars_data__year
         HAVING ((count(*) > 4) AND (count(*) <= 10))))) AND (car_1__car_1.cars_data__year IS NOT NULL)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_87____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_88____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_88____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_197____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_197____inner_view
          GROUP BY car_1__car_1___n1_197____inner_view.cars_data__year
         HAVING ((count(*) >= 27) AND (count(*) < 30))
          ORDER BY car_1__car_1___n1_197____inner_view.cars_data__year
         LIMIT 2))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__edispl >= (250.0)::double precision)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_88____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_88____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_88____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_197____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_197____inner_view
          GROUP BY car_1__car_1___n1_197____inner_view.cars_data__year
         HAVING ((count(*) >= 27) AND (count(*) < 30))
          ORDER BY car_1__car_1___n1_197____inner_view.cars_data__year
         LIMIT 2))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__edispl >= (250.0)::double precision))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_88____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_89____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_89____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_186____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_186____inner_view
          GROUP BY car_1__car_1___n1_186____inner_view.cars_data__year
         HAVING (count(*) < 25)
          ORDER BY car_1__car_1___n1_186____inner_view.cars_data__year
         LIMIT 2))) AND (car_1__car_1.cars_data__year IS NOT NULL)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_89____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_89____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_89____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_186____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_186____inner_view
          GROUP BY car_1__car_1___n1_186____inner_view.cars_data__year
         HAVING (count(*) < 25)
          ORDER BY car_1__car_1___n1_186____inner_view.cars_data__year
         LIMIT 2))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_89____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_8____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_8____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (( SELECT DISTINCT count(car_1__car_1___n1_176____inner_view.*) AS count
           FROM public.car_1__car_1___n1_176____inner_view
          WHERE (car_1__car_1___n1_176____inner_view.cars_data__horsepower = car_1__car_1.cars_data__horsepower)) > 4))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_8____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_8____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_8____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (NOT (( SELECT DISTINCT count(car_1__car_1___n1_176____inner_view.*) AS count
           FROM public.car_1__car_1___n1_176____inner_view
          WHERE (car_1__car_1___n1_176____inner_view.cars_data__horsepower = car_1__car_1.cars_data__horsepower)) > 4)))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_8____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_90____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_90____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND ((( SELECT DISTINCT count(car_1__car_1___n1_97____inner_view.*) AS count
           FROM public.car_1__car_1___n1_97____inner_view
          WHERE (car_1__car_1___n1_97____inner_view.car_names__model = car_1__car_1.car_names__model)) >= 1) AND (( SELECT DISTINCT count(car_1__car_1___n1_97____inner_view.*) AS count
           FROM public.car_1__car_1___n1_97____inner_view
          WHERE (car_1__car_1___n1_97____inner_view.car_names__model = car_1__car_1.car_names__model)) < 3) AND (car_1__car_1.cars_data__edispl >= (140.0)::double precision) AND (car_1__car_1.cars_data__edispl <= (307.0)::double precision) AND (car_1__car_1.cars_data__accelerate = (12.0)::double precision)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_90____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_90____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_90____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (NOT ((( SELECT DISTINCT count(car_1__car_1___n1_97____inner_view.*) AS count
           FROM public.car_1__car_1___n1_97____inner_view
          WHERE (car_1__car_1___n1_97____inner_view.car_names__model = car_1__car_1.car_names__model)) >= 1) AND (( SELECT DISTINCT count(car_1__car_1___n1_97____inner_view.*) AS count
           FROM public.car_1__car_1___n1_97____inner_view
          WHERE (car_1__car_1___n1_97____inner_view.car_names__model = car_1__car_1.car_names__model)) < 3) AND (car_1__car_1.cars_data__edispl >= (140.0)::double precision) AND (car_1__car_1.cars_data__edispl <= (307.0)::double precision) AND (car_1__car_1.cars_data__accelerate = (12.0)::double precision))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_90____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_91____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_91____inner_view AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND ((car_1__car_1.cars_data__weight <= 3563) AND (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_9____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_9____inner_view
          GROUP BY car_1__car_1___n1_9____inner_view.cars_data__year
         HAVING (count(*) > 28)
          ORDER BY car_1__car_1___n1_9____inner_view.cars_data__year
         LIMIT 3)) AND (car_1__car_1.cars_data__year IS NOT NULL)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_91____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_91____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_91____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__weight <= 3563) AND (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_9____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_9____inner_view
          GROUP BY car_1__car_1___n1_9____inner_view.cars_data__year
         HAVING (count(*) > 28)
          ORDER BY car_1__car_1___n1_9____inner_view.cars_data__year
         LIMIT 3)) AND (car_1__car_1.cars_data__year IS NOT NULL))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_91____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_92____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_92____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND ((NOT (car_1__car_1.car_names__make IN ( SELECT DISTINCT car_1__car_1___n1_277____inner_view.car_names__make
           FROM public.car_1__car_1___n1_277____inner_view
          WHERE (car_1__car_1___n1_277____inner_view.cars_data__mpg = car_1__car_1.cars_data__mpg)))) AND (car_1__car_1.car_names__make IS NOT NULL) AND (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_216____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_216____inner_view
          GROUP BY car_1__car_1___n1_216____inner_view.cars_data__year
         HAVING (count(*) > 30))) AND (car_1__car_1.cars_data__year IS NOT NULL)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_92____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_92____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_92____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT ((NOT (car_1__car_1.car_names__make IN ( SELECT DISTINCT car_1__car_1___n1_277____inner_view.car_names__make
           FROM public.car_1__car_1___n1_277____inner_view
          WHERE (car_1__car_1___n1_277____inner_view.cars_data__mpg = car_1__car_1.cars_data__mpg)))) AND (car_1__car_1.car_names__make IS NOT NULL) AND (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_216____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_216____inner_view
          GROUP BY car_1__car_1___n1_216____inner_view.cars_data__year
         HAVING (count(*) > 30))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_92____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_93____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_93____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_93____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_93____inner_view
          GROUP BY car_1__car_1___n1_93____inner_view.cars_data__year
         HAVING (count(*) <= 30)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((car_1__car_1.cars_data__year > 1971) AND (car_1__car_1.cars_data__year < 1977)) OR (car_1__car_1.cars_data__weight < 4464)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_93____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_93____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_93____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_93____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_93____inner_view
          GROUP BY car_1__car_1___n1_93____inner_view.cars_data__year
         HAVING (count(*) <= 30)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((car_1__car_1.cars_data__year > 1971) AND (car_1__car_1.cars_data__year < 1977)) OR (car_1__car_1.cars_data__weight < 4464))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_93____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_94____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_94____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND ((car_1__car_1.countries__countryname <> 'usa'::text) AND (car_1__car_1.cars_data__accelerate > (19.2)::double precision) AND (NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_161____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_161____inner_view
          GROUP BY car_1__car_1___n1_161____inner_view.cars_data__year
         HAVING (count(*) >= 30)))) AND (car_1__car_1.cars_data__year IS NOT NULL)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_94____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_94____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_94____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT ((car_1__car_1.countries__countryname <> 'usa'::text) AND (car_1__car_1.cars_data__accelerate > (19.2)::double precision) AND (NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_161____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_161____inner_view
          GROUP BY car_1__car_1___n1_161____inner_view.cars_data__year
         HAVING (count(*) >= 30)))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_94____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_95____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_95____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (((car_1__car_1.cars_data__mpg > (25.0)::double precision) AND (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_140____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_140____inner_view
          GROUP BY car_1__car_1___n1_140____inner_view.cars_data__year
         HAVING ((count(*) >= 7) AND (count(*) < 13)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((car_1__car_1.cars_data__accelerate IN ( SELECT DISTINCT car_1__car_1___n1_126____inner_view.cars_data__accelerate
           FROM public.car_1__car_1___n1_126____inner_view)) AND (car_1__car_1.cars_data__accelerate IS NOT NULL)) OR (car_1__car_1.cars_data__mpg < (20.2)::double precision)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_95____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_95____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_95____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (((car_1__car_1.cars_data__mpg > (25.0)::double precision) AND (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_140____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_140____inner_view
          GROUP BY car_1__car_1___n1_140____inner_view.cars_data__year
         HAVING ((count(*) >= 7) AND (count(*) < 13)))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR ((car_1__car_1.cars_data__accelerate IN ( SELECT DISTINCT car_1__car_1___n1_126____inner_view.cars_data__accelerate
           FROM public.car_1__car_1___n1_126____inner_view)) AND (car_1__car_1.cars_data__accelerate IS NOT NULL)) OR (car_1__car_1.cars_data__mpg < (20.2)::double precision))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_95____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_96____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_96____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND ((car_1__car_1.cars_data__edispl <= (122.0)::double precision) OR (( SELECT DISTINCT count(car_1__car_1___n1_97____inner_view.*) AS count
           FROM public.car_1__car_1___n1_97____inner_view
          WHERE (car_1__car_1___n1_97____inner_view.cars_data__edispl = car_1__car_1.cars_data__edispl)) > 1) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_9____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_9____inner_view
          GROUP BY car_1__car_1___n1_9____inner_view.cars_data__year
         HAVING (count(*) > 28)
          ORDER BY car_1__car_1___n1_9____inner_view.cars_data__year
         LIMIT 3))) AND (car_1__car_1.cars_data__year IS NOT NULL))))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_96____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_96____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_96____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.model_list__modelid,
    car_1__car_1.model_list__maker,
    car_1__car_1.model_list__model,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.model_list__maker IS NOT NULL) AND (car_1__car_1.model_list__modelid IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (car_1__car_1.car_names__model IS NOT NULL) AND (car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.model_list__model IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__edispl <= (122.0)::double precision) OR (( SELECT DISTINCT count(car_1__car_1___n1_97____inner_view.*) AS count
           FROM public.car_1__car_1___n1_97____inner_view
          WHERE (car_1__car_1___n1_97____inner_view.cars_data__edispl = car_1__car_1.cars_data__edispl)) > 1) OR ((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_9____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_9____inner_view
          GROUP BY car_1__car_1___n1_9____inner_view.cars_data__year
         HAVING (count(*) > 28)
          ORDER BY car_1__car_1___n1_9____inner_view.cars_data__year
         LIMIT 3))) AND (car_1__car_1.cars_data__year IS NOT NULL)))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_96____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_97____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_97____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND ((car_1__car_1.cars_data__accelerate > (15.0)::double precision) AND (car_1__car_1.cars_data__accelerate <= (24.8)::double precision) AND (NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_278____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_278____inner_view
          WHERE (car_1__car_1___n1_278____inner_view.cars_data__cylinders = car_1__car_1.cars_data__cylinders)
          GROUP BY car_1__car_1___n1_278____inner_view.cars_data__year
         HAVING (count(*) < 29)
          ORDER BY car_1__car_1___n1_278____inner_view.cars_data__year
         LIMIT 4))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.cars_data__cylinders > 4) AND (car_1__car_1.cars_data__cylinders <= 6)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_97____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_97____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_97____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT ((car_1__car_1.cars_data__accelerate > (15.0)::double precision) AND (car_1__car_1.cars_data__accelerate <= (24.8)::double precision) AND (NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_278____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_278____inner_view
          WHERE (car_1__car_1___n1_278____inner_view.cars_data__cylinders = car_1__car_1.cars_data__cylinders)
          GROUP BY car_1__car_1___n1_278____inner_view.cars_data__year
         HAVING (count(*) < 29)
          ORDER BY car_1__car_1___n1_278____inner_view.cars_data__year
         LIMIT 4))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.cars_data__cylinders > 4) AND (car_1__car_1.cars_data__cylinders <= 6))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_97____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_98____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_98____inner_view AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_56____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_56____inner_view
          GROUP BY car_1__car_1___n1_56____inner_view.cars_data__year
         HAVING (count(*) <= 29)))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.cars_data__weight > 2310)) OR (car_1__car_1.cars_data__horsepower < (32)::double precision)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_98____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_98____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_98____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (NOT (((NOT (car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_56____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_56____inner_view
          GROUP BY car_1__car_1___n1_56____inner_view.cars_data__year
         HAVING (count(*) <= 29)))) AND (car_1__car_1.cars_data__year IS NOT NULL) AND (car_1__car_1.cars_data__weight > 2310)) OR (car_1__car_1.cars_data__horsepower < (32)::double precision))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_98____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_99____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_99____inner_view AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_230____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_230____inner_view
          GROUP BY car_1__car_1___n1_230____inner_view.cars_data__year
         HAVING (count(*) >= 29))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__edispl > (258.0)::double precision) OR (car_1__car_1.cars_data__edispl <= (140.0)::double precision)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_99____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_99____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_99____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.car_names__makeid,
    car_1__car_1.car_names__model,
    car_1__car_1.car_names__make,
    car_1__car_1.cars_data__id,
    car_1__car_1.cars_data__mpg,
    car_1__car_1.cars_data__cylinders,
    car_1__car_1.cars_data__edispl,
    car_1__car_1.cars_data__horsepower,
    car_1__car_1.cars_data__weight,
    car_1__car_1.cars_data__accelerate,
    car_1__car_1.cars_data__year
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.cars_data__id IS NOT NULL) AND (car_1__car_1.car_names__makeid IS NOT NULL) AND (NOT (((car_1__car_1.cars_data__year IN ( SELECT DISTINCT car_1__car_1___n1_230____inner_view.cars_data__year
           FROM public.car_1__car_1___n1_230____inner_view
          GROUP BY car_1__car_1___n1_230____inner_view.cars_data__year
         HAVING (count(*) >= 29))) AND (car_1__car_1.cars_data__year IS NOT NULL)) OR (car_1__car_1.cars_data__edispl > (258.0)::double precision) OR (car_1__car_1.cars_data__edispl <= (140.0)::double precision))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_99____inner_view__negative_examples OWNER TO data_user;

--
-- Name: car_1__car_1___n2_9____inner_view; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_9____inner_view AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND ((EXISTS ( SELECT DISTINCT car_1__car_1___n1_2____inner_view.car_makers__id
           FROM public.car_1__car_1___n1_2____inner_view
          WHERE (car_1__car_1___n1_2____inner_view.car_makers__id = car_1__car_1.car_makers__id))) OR (car_1__car_1.continents__continent ~~ 'asi%'::text)))
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_9____inner_view OWNER TO data_user;

--
-- Name: car_1__car_1___n2_9____inner_view__negative_examples; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.car_1__car_1___n2_9____inner_view__negative_examples AS
 SELECT DISTINCT car_1__car_1.continents__contid,
    car_1__car_1.continents__continent,
    car_1__car_1.countries__countryid,
    car_1__car_1.countries__countryname,
    car_1__car_1.countries__continent,
    car_1__car_1.car_makers__id,
    car_1__car_1.car_makers__maker,
    car_1__car_1.car_makers__fullname,
    car_1__car_1.car_makers__country
   FROM public.car_1__car_1
  WHERE ((car_1__car_1.countries__continent IS NOT NULL) AND (car_1__car_1.continents__contid IS NOT NULL) AND (car_1__car_1.countries__countryid IS NOT NULL) AND (car_1__car_1.car_makers__country IS NOT NULL) AND (car_1__car_1.car_makers__id IS NOT NULL) AND (NOT ((EXISTS ( SELECT DISTINCT car_1__car_1___n1_2____inner_view.car_makers__id
           FROM public.car_1__car_1___n1_2____inner_view
          WHERE (car_1__car_1___n1_2____inner_view.car_makers__id = car_1__car_1.car_makers__id))) OR (car_1__car_1.continents__continent ~~ 'asi%'::text))))
 LIMIT 20
  WITH NO DATA;


ALTER TABLE public.car_1__car_1___n2_9____inner_view__negative_examples OWNER TO data_user;

--
-- Name: test_array_agg; Type: MATERIALIZED VIEW; Schema: public; Owner: data_user
--

CREATE MATERIALIZED VIEW public.test_array_agg AS
 SELECT DISTINCT cars_data.year,
    array_agg(cars_data.id) AS array_agg
   FROM public.cars_data
  GROUP BY cars_data.year
  WITH NO DATA;


ALTER TABLE public.test_array_agg OWNER TO data_user;

--
-- Name: test_view3; Type: VIEW; Schema: public; Owner: data_user
--

CREATE VIEW public.test_view3 AS
 SELECT model_list.model AS model_list___model,
    car_names.model AS car_names___model
   FROM (public.model_list
     FULL JOIN public.car_names ON ((model_list.model = car_names.model)));


ALTER TABLE public.test_view3 OWNER TO data_user;

--
-- Data for Name: car_makers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.car_makers (id, maker, fullname, country) FROM stdin;
1	amc	American Motor Company	1
2	volkswagen	Volkswagen	2
3	bmw	BMW	2
4	gm	General Motors	1
5	ford	Ford Motor Company	1
6	chrysler	Chrysler	1
7	citroen	Citroen	3
8	nissan	Nissan Motors	4
9	fiat	Fiat	5
11	honda	Honda	4
12	mazda	Mazda	4
13	daimler benz	Daimler Benz	2
14	opel	Opel	2
15	peugeaut	Peugeaut	3
16	renault	Renault	3
17	saab	Saab	6
18	subaru	Subaru	4
19	toyota	Toyota	4
20	triumph	Triumph	7
21	volvo	Volvo	6
22	kia	Kia Motors	8
23	hyundai	Hyundai	8
\.


--
-- Data for Name: car_names; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.car_names (makeid, model, make) FROM stdin;
1	chevrolet	chevrolet chevelle malibu
2	buick	buick skylark 320
3	plymouth	plymouth satellite
4	amc	amc rebel sst
5	ford	ford torino
6	ford	ford galaxie 500
7	chevrolet	chevrolet impala
8	plymouth	plymouth fury iii
9	pontiac	pontiac catalina
10	amc	amc ambassador dpl
11	citroen	citroen ds-21 pallas
12	chevrolet	chevrolet chevelle concours (sw)
13	ford	ford torino (sw)
14	plymouth	plymouth satellite (sw)
15	amc	amc rebel sst (sw)
16	dodge	dodge challenger se
17	plymouth	plymouth cuda 340
18	ford	ford mustang boss 302
19	chevrolet	chevrolet monte carlo
20	buick	buick estate wagon (sw)
21	toyota	toyota corona mark ii
22	plymouth	plymouth duster
23	amc	amc hornet
24	ford	ford maverick
25	datsun	datsun pl510
26	volkswagen	volkswagen 1131 deluxe sedan
27	peugeot	peugeot 504
28	audi	audi 100 ls
29	saab	saab 99e
30	bmw	bmw 2002
31	amc	amc gremlin
32	ford	ford f250
33	chevrolet	chevy c20
34	dodge	dodge d200
35	hi	hi 1200d
36	datsun	datsun pl510
37	chevrolet	chevrolet vega 2300
38	toyota	toyota corona
39	ford	ford pinto
40	volkswagen	volkswagen super beetle 117
41	amc	amc gremlin
42	plymouth	plymouth satellite custom
43	chevrolet	chevrolet chevelle malibu
44	ford	ford torino 500
45	amc	amc matador
46	chevrolet	chevrolet impala
47	pontiac	pontiac catalina brougham
48	ford	ford galaxie 500
49	plymouth	plymouth fury iii
50	dodge	dodge monaco (sw)
51	ford	ford country squire (sw)
52	pontiac	pontiac safari (sw)
53	amc	amc hornet sportabout (sw)
54	chevrolet	chevrolet vega (sw)
55	pontiac	pontiac firebird
56	ford	ford mustang
57	mercury	mercury capri 2000
58	opel	opel 1900
59	peugeot	peugeot 304
60	fiat	fiat 124b
61	toyota	toyota corolla 1200
62	datsun	datsun 1200
63	volkswagen	volkswagen model 111
64	plymouth	plymouth cricket
65	toyota	toyota corona hardtop
66	dodge	dodge colt hardtop
67	volkswagen	volkswagen type 3
68	chevrolet	chevrolet vega
69	ford	ford pinto runabout
70	chevrolet	chevrolet impala
71	pontiac	pontiac catalina
72	plymouth	plymouth fury iii
73	ford	ford galaxie 500
74	amc	amc ambassador sst
75	mercury	mercury marquis
76	buick	buick lesabre custom
77	oldsmobile	oldsmobile delta 88 royale
78	chrysler	chrysler newport royal
79	mazda	mazda rx2 coupe
80	amc	amc matador (sw)
81	chevrolet	chevrolet chevelle concours (sw)
82	ford	ford gran torino (sw)
83	plymouth	plymouth satellite custom (sw)
84	volvo	volvo 145e (sw)
85	volkswagen	volkswagen 411 (sw)
86	peugeot	peugeot 504 (sw)
87	renault	renault 12 (sw)
88	ford	ford pinto (sw)
89	datsun	datsun 510 (sw)
90	toyota	toyota corona mark ii (sw)
91	dodge	dodge colt (sw)
92	toyota	toyota corolla 1600 (sw)
93	buick	buick century 350
94	amc	amc matador
95	chevrolet	chevrolet malibu
96	ford	ford gran torino
97	dodge	dodge coronet custom
98	mercury	mercury marquis brougham
99	chevrolet	chevrolet caprice classic
100	ford	ford ltd
101	plymouth	plymouth fury gran sedan
102	chrysler	chrysler new yorker brougham
103	buick	buick electra 225 custom
104	amc	amc ambassador brougham
105	plymouth	plymouth valiant
106	chevrolet	chevrolet nova custom
107	amc	amc hornet
108	ford	ford maverick
109	plymouth	plymouth duster
110	volkswagen	volkswagen super beetle
111	chevrolet	chevrolet impala
112	ford	ford country
113	plymouth	plymouth custom suburb
114	oldsmobile	oldsmobile vista cruiser
115	amc	amc gremlin
116	toyota	toyota carina
117	chevrolet	chevrolet vega
118	datsun	datsun 610
119	mazda	mazda rx3
120	ford	ford pinto
121	mercury	mercury capri v6
122	fiat	fiat 124 sport coupe
123	chevrolet	chevrolet monte carlo s
124	pontiac	pontiac grand prix
125	fiat	fiat 128
126	opel	opel manta
127	audi	audi 100ls
128	volvo	volvo 144ea
129	dodge	dodge dart custom
130	saab	saab 99le
131	toyota	toyota mark ii
132	oldsmobile	oldsmobile omega
133	plymouth	plymouth duster
134	ford	ford maverick
135	amc	amc hornet
136	chevrolet	chevrolet nova
137	datsun	datsun b210
138	ford	ford pinto
139	toyota	toyota corolla 1200
140	chevrolet	chevrolet vega
141	chevrolet	chevrolet chevelle malibu classic
142	amc	amc matador
143	plymouth	plymouth satellite sebring
144	ford	ford gran torino
145	buick	buick century luxus (sw)
146	dodge	dodge coronet custom (sw)
147	ford	ford gran torino (sw)
148	amc	amc matador (sw)
149	audi	audi fox
150	volkswagen	volkswagen dasher
151	opel	opel manta
152	toyota	toyota corona
153	datsun	datsun 710
154	dodge	dodge colt
155	fiat	fiat 128
156	fiat	fiat 124 tc
157	honda	honda civic
158	subaru	subaru
159	fiat	fiat x1.9
160	plymouth	plymouth valiant custom
161	chevrolet	chevrolet nova
162	mercury	mercury monarch
163	ford	ford maverick
164	pontiac	pontiac catalina
165	chevrolet	chevrolet bel air
166	plymouth	plymouth grand fury
167	ford	ford ltd
168	buick	buick century
169	chevrolet	chevrolet chevelle malibu
170	amc	amc matador
171	plymouth	plymouth fury
172	buick	buick skyhawk
173	chevrolet	chevrolet monza 2+2
174	ford	ford mustang ii
175	toyota	toyota corolla
176	ford	ford pinto
177	amc	amc gremlin
178	pontiac	pontiac astro
179	toyota	toyota corona
180	volkswagen	volkswagen dasher
181	datsun	datsun 710
182	ford	ford pinto
183	volkswagen	volkswagen rabbit
184	amc	amc pacer
185	audi	audi 100ls
186	peugeot	peugeot 504
187	volvo	volvo 244dl
188	saab	saab 99le
189	honda	honda civic cvcc
190	fiat	fiat 131
191	opel	opel 1900
192	capri	capri ii
193	dodge	dodge colt
194	renault	renault 12tl
195	chevrolet	chevrolet chevelle malibu classic
196	dodge	dodge coronet brougham
197	amc	amc matador
198	ford	ford gran torino
199	plymouth	plymouth valiant
200	chevrolet	chevrolet nova
201	ford	ford maverick
202	amc	amc hornet
203	chevrolet	chevrolet chevette
204	chevrolet	chevrolet woody
205	volkswagen	vw rabbit
206	honda	honda civic
207	dodge	dodge aspen se
208	ford	ford granada ghia
209	pontiac	pontiac ventura sj
210	amc	amc pacer d/l
211	volkswagen	volkswagen rabbit
212	datsun	datsun b-210
213	toyota	toyota corolla
214	ford	ford pinto
215	volvo	volvo 245
216	plymouth	plymouth volare premier v8
217	peugeot	peugeot 504
218	toyota	toyota mark ii
219	mercedes-benz	mercedes-benz 280s
220	cadillac	cadillac seville
221	chevrolet	chevy c10
222	ford	ford f108
223	dodge	dodge d100
224	honda	honda accord cvcc
225	buick	buick opel isuzu deluxe
226	renault	renault 5 gtl
227	plymouth	plymouth arrow gs
228	datsun	datsun f-10 hatchback
229	chevrolet	chevrolet caprice classic
230	oldsmobile	oldsmobile cutlass supreme
231	dodge	dodge monaco brougham
232	mercury	mercury cougar brougham
233	chevrolet	chevrolet concours
234	buick	buick skylark
235	plymouth	plymouth volare custom
236	ford	ford granada
237	pontiac	pontiac grand prix lj
238	chevrolet	chevrolet monte carlo landau
239	chrysler	chrysler cordoba
240	ford	ford thunderbird
241	volkswagen	volkswagen rabbit custom
242	pontiac	pontiac sunbird coupe
243	toyota	toyota corolla liftback
244	ford	ford mustang ii 2+2
245	chevrolet	chevrolet chevette
246	dodge	dodge colt m/m
247	subaru	subaru dl
248	volkswagen	volkswagen dasher
249	datsun	datsun 810
250	bmw	bmw 320i
251	mazda	mazda rx-4
252	volkswagen	volkswagen rabbit custom diesel
253	ford	ford fiesta
254	mazda	mazda glc deluxe
255	datsun	datsun b210 gx
256	honda	honda civic cvcc
257	oldsmobile	oldsmobile cutlass salon brougham
258	dodge	dodge diplomat
259	mercury	mercury monarch ghia
260	pontiac	pontiac phoenix lj
261	chevrolet	chevrolet malibu
262	ford	ford fairmont (auto)
263	ford	ford fairmont (man)
264	plymouth	plymouth volare
265	amc	amc concord
266	buick	buick century special
267	mercury	mercury zephyr
268	dodge	dodge aspen
269	amc	amc concord d/l
270	chevrolet	chevrolet monte carlo landau
271	buick	buick regal sport coupe (turbo)
272	ford	ford futura
273	dodge	dodge magnum xe
274	chevrolet	chevrolet chevette
275	toyota	toyota corona
276	datsun	datsun 510
277	dodge	dodge omni
278	toyota	toyota celica gt liftback
279	plymouth	plymouth sapporo
280	oldsmobile	oldsmobile starfire sx
281	datsun	datsun 200-sx
282	audi	audi 5000
283	volvo	volvo 264gl
284	saab	saab 99gle
285	peugeot	peugeot 604sl
286	volkswagen	volkswagen scirocco
287	honda	honda accord lx
288	pontiac	pontiac lemans v6
289	mercury	mercury zephyr 6
290	ford	ford fairmont 4
291	amc	amc concord dl 6
292	dodge	dodge aspen 6
293	chevrolet	chevrolet caprice classic
294	ford	ford ltd landau
295	mercury	mercury grand marquis
296	dodge	dodge st. regis
297	buick	buick estate wagon (sw)
298	ford	ford country squire (sw)
299	chevrolet	chevrolet malibu classic (sw)
300	chrysler	chrysler lebaron town @ country (sw)
301	volkswagen	vw rabbit custom
302	mazda	 mazda glc deluxe
303	dodge	dodge colt hatchback custom
304	amc	amc spirit dl
305	mercedes	mercedes benz 300d
306	cadillac	cadillac eldorado
307	peugeot	peugeot 504
308	oldsmobile	oldsmobile cutlass salon brougham
309	plymouth	plymouth horizon
310	plymouth	plymouth horizon tc3
311	datsun	datsun 210
312	fiat	fiat strada custom
313	buick	buick skylark limited
314	chevrolet	chevrolet citation
315	oldsmobile	oldsmobile omega brougham
316	pontiac	pontiac phoenix
317	volkswagen	vw rabbit
318	toyota	toyota corolla tercel
319	chevrolet	chevrolet chevette
320	datsun	datsun 310
321	chevrolet	chevrolet citation
322	ford	ford fairmont
323	amc	amc concord
324	dodge	dodge aspen
325	audi	audi 4000
326	toyota	toyota corona liftback
327	mazda	mazda 626
328	datsun	datsun 510 hatchback
329	toyota	toyota corolla
330	mazda	mazda glc
331	dodge	dodge colt
332	datsun	datsun 210
333	volkswagen	vw rabbit c (diesel)
334	volkswagen	vw dasher (diesel)
335	audi	audi 5000s (diesel)
336	mercedes-benz	mercedes-benz 240d
337	honda	honda civic 1500 gl
338	renault	renault lecar deluxe
339	subaru	subaru dl
340	 volkswagen	volkswagen rabbit
341	datsun	datsun 280-zx
342	mazda	mazda rx-7 gs
343	triumph	triumph tr7 coupe
344	ford	ford mustang cobra
345	honda	honda accord
346	plymouth	plymouth reliant
347	buick	buick skylark
348	dodge	dodge aries wagon (sw)
349	chevrolet	chevrolet citation
350	plymouth	plymouth reliant
351	toyota	toyota starlet
352	plymouth	plymouth champ
353	honda	honda civic 1300
354	subaru	subaru
355	datsun	datsun 210 mpg
356	toyota	toyota tercel
357	mazda	mazda glc 4
358	plymouth	plymouth horizon 4
359	ford	ford escort 4w
360	ford	ford escort 2h
361	volkswagen	volkswagen jetta
362	renault	renault 18i
363	honda	honda prelude
364	toyota	toyota corolla
365	datsun	datsun 200sx
366	mazda	mazda 626
367	peugeot	peugeot 505s turbo diesel
368	saab	saab 900s
369	volvo	volvo diesel
370	toyota	toyota cressida
371	datsun	datsun 810 maxima
372	buick	buick century
373	oldsmobile	oldsmobile cutlass ls
374	ford	ford granada gl
375	chrysler	chrysler lebaron salon
376	chevrolet	chevrolet cavalier
377	chevrolet	chevrolet cavalier wagon
378	chevrolet	chevrolet cavalier 2-door
379	pontiac	pontiac j2000 se hatchback
380	dodge	dodge aries se
381	pontiac	pontiac phoenix
382	ford	ford fairmont futura
383	amc	amc concord dl
384	volkswagen	volkswagen rabbit l
385	mazda	mazda glc custom l
386	mazda	mazda glc custom
387	plymouth	plymouth horizon miser
388	mercury	mercury lynx l
389	nissan	nissan stanza xe
390	honda	honda accord
391	toyota	toyota corolla
392	honda	honda civic
393	honda	honda civic (auto)
394	datsun	datsun 310 gx
395	buick	buick century limited
396	oldsmobile	oldsmobile cutlass ciera (diesel)
397	chrysler	chrysler lebaron medallion
398	ford	ford granada l
399	toyota	toyota celica gt
400	dodge	dodge charger 2.2
401	chevrolet	chevrolet camaro
402	ford	ford mustang gl
403	volkswagen	vw pickup
404	dodge	dodge rampage
405	ford	ford ranger
406	chevrolet	chevy s-10
\.


--
-- Data for Name: cars_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cars_data (id, mpg, cylinders, edispl, horsepower, weight, accelerate, year) FROM stdin;
1	18	8	307	18	3504	12	1970
2	15	8	350	15	3693	11.5	1970
3	18	8	318	18	3436	11	1970
4	16	8	304	16	3433	12	1970
5	17	8	302	17	3449	10.5	1970
6	15	8	429	15	4341	10	1970
7	14	8	454	14	4354	9	1970
8	14	8	440	14	4312	8.5	1970
9	14	8	455	14	4425	10	1970
10	15	8	390	15	3850	8.5	1970
16	15	8	383	15	3563	10	1970
17	14	8	340	14	3609	8	1970
19	15	8	400	15	3761	9.5	1970
20	14	8	455	14	3086	10	1970
21	24	4	113	24	2372	15	1970
22	22	6	198	22	2833	15.5	1970
23	18	6	199	18	2774	15.5	1970
24	21	6	200	21	2587	16	1970
25	27	4	97	27	2130	14.5	1970
26	26	4	97	26	1835	20.5	1970
27	25	4	110	25	2672	17.5	1970
28	24	4	107	24	2430	14.5	1970
29	25	4	104	25	2375	17.5	1970
30	26	4	121	26	2234	12.5	1970
31	21	6	199	21	2648	15	1970
32	10	8	360	10	4615	14	1970
33	10	8	307	10	4376	15	1970
34	11	8	318	11	4382	13.5	1970
35	9	8	304	9	4732	18.5	1970
36	27	4	97	27	2130	14.5	1971
37	28	4	140	28	2264	15.5	1971
38	25	4	113	25	2228	14	1971
39	25	4	98	25	2046	19	1971
41	19	6	232	19	2634	13	1971
42	16	6	225	16	3439	15.5	1971
43	17	6	250	17	3329	15.5	1971
44	19	6	250	19	3302	15.5	1971
45	18	6	232	18	3288	15.5	1971
46	14	8	350	14	4209	12	1971
47	14	8	400	14	4464	11.5	1971
48	14	8	351	14	4154	13.5	1971
49	14	8	318	14	4096	13	1971
50	12	8	383	12	4955	11.5	1971
51	13	8	400	13	4746	12	1971
52	13	8	400	13	5140	12	1971
53	18	6	258	18	2962	13.5	1971
54	22	4	140	22	2408	19	1971
55	19	6	250	19	3282	15	1971
56	18	6	250	18	3139	14.5	1971
57	23	4	122	23	2220	14	1971
58	28	4	116	28	2123	14	1971
59	30	4	79	30	2074	19.5	1971
60	30	4	88	30	2065	14.5	1971
61	31	4	71	31	1773	19	1971
62	35	4	72	35	1613	18	1971
63	27	4	97	27	1834	19	1971
64	26	4	91	26	1955	20.5	1971
65	24	4	113	24	2278	15.5	1972
66	25	4	97.5	25	2126	17	1972
67	23	4	97	23	2254	23.5	1972
68	20	4	140	20	2408	19.5	1972
69	21	4	122	21	2226	16.5	1972
70	13	8	350	13	4274	12	1972
71	14	8	400	14	4385	12	1972
72	15	8	318	15	4135	13.5	1972
73	14	8	351	14	4129	13	1972
74	17	8	304	17	3672	11.5	1972
75	11	8	429	11	4633	11	1972
76	13	8	350	13	4502	13.5	1972
77	12	8	350	12	4456	13.5	1972
78	13	8	400	13	4422	12.5	1972
79	19	3	70	19	2330	13.5	1972
80	15	8	304	15	3892	12.5	1972
81	13	8	307	13	4098	14	1972
82	13	8	302	13	4294	16	1972
83	14	8	318	14	4077	14	1972
84	18	4	121	18	2933	14.5	1972
85	22	4	121	22	2511	18	1972
86	21	4	120	21	2979	19.5	1972
87	26	4	96	26	2189	18	1972
88	22	4	122	22	2395	16	1972
89	28	4	97	28	2288	17	1972
90	23	4	120	23	2506	14.5	1972
91	28	4	98	28	2164	15	1972
92	27	4	97	27	2100	16.5	1972
93	13	8	350	13	4100	13	1973
94	14	8	304	14	3672	11.5	1973
95	13	8	350	13	3988	13	1973
96	14	8	302	14	4042	14.5	1973
97	15	8	318	15	3777	12.5	1973
98	12	8	429	12	4952	11.5	1973
99	13	8	400	13	4464	12	1973
100	13	8	351	13	4363	13	1973
101	14	8	318	14	4237	14.5	1973
102	13	8	440	13	4735	11	1973
103	12	8	455	12	4951	11	1973
104	13	8	360	13	3821	11	1973
105	18	6	225	18	3121	16.5	1973
106	16	6	250	16	3278	18	1973
107	18	6	232	18	2945	16	1973
108	18	6	250	18	3021	16.5	1973
109	23	6	198	23	2904	16	1973
110	26	4	97	26	1950	21	1973
111	11	8	400	11	4997	14	1973
112	12	8	400	12	4906	12.5	1973
113	13	8	360	13	4654	13	1973
114	12	8	350	12	4499	12.5	1973
115	18	6	232	18	2789	15	1973
116	20	4	97	20	2279	19	1973
117	21	4	140	21	2401	19.5	1973
118	22	4	108	22	2379	16.5	1973
119	18	3	70	18	2124	13.5	1973
120	19	4	122	19	2310	18.5	1973
121	21	6	155	21	2472	14	1973
122	26	4	98	26	2265	15.5	1973
123	15	8	350	15	4082	13	1973
124	16	8	400	16	4278	9.5	1973
125	29	4	68	29	1867	19.5	1973
126	24	4	116	24	2158	15.5	1973
127	20	4	114	20	2582	14	1973
128	19	4	121	19	2868	15.5	1973
129	15	8	318	15	3399	11	1973
130	24	4	121	24	2660	14	1973
131	20	6	156	20	2807	13.5	1973
132	11	8	350	11	3664	11	1973
133	20	6	198	20	3102	16.5	1974
134	21	6	200	21	2875	17	1974
135	19	6	232	19	2901	16	1974
136	15	6	250	15	3336	17	1974
137	31	4	79	31	1950	19	1974
138	26	4	122	26	2451	16.5	1974
139	32	4	71	32	1836	21	1974
140	25	4	140	25	2542	17	1974
141	16	6	250	16	3781	17	1974
142	16	6	258	16	3632	18	1974
143	18	6	225	18	3613	16.5	1974
144	16	8	302	16	4141	14	1974
145	13	8	350	13	4699	14.5	1974
146	14	8	318	14	4457	13.5	1974
147	14	8	302	14	4638	16	1974
148	14	8	304	14	4257	15.5	1974
149	29	4	98	29	2219	16.5	1974
150	26	4	79	26	1963	15.5	1974
151	26	4	97	26	2300	14.5	1974
152	31	4	76	31	1649	16.5	1974
153	32	4	83	32	2003	19	1974
154	28	4	90	28	2125	14.5	1974
155	24	4	90	24	2108	15.5	1974
156	26	4	116	26	2246	14	1974
157	24	4	120	24	2489	15	1974
158	26	4	108	26	2391	15.5	1974
159	31	4	79	31	2000	16	1974
160	19	6	225	19	3264	16	1975
161	18	6	250	18	3459	16	1975
162	15	6	250	15	3432	21	1975
163	15	6	250	15	3158	19.5	1975
164	16	8	400	16	4668	11.5	1975
165	15	8	350	15	4440	14	1975
166	16	8	318	16	4498	14.5	1975
167	14	8	351	14	4657	13.5	1975
168	17	6	231	17	3907	21	1975
169	16	6	250	16	3897	18.5	1975
170	15	6	258	15	3730	19	1975
171	18	6	225	18	3785	19	1975
172	21	6	231	21	3039	15	1975
173	20	8	262	20	3221	13.5	1975
174	13	8	302	13	3169	12	1975
175	29	4	97	29	2171	16	1975
176	23	4	140	23	2639	17	1975
177	20	6	232	20	2914	16	1975
178	23	4	140	23	2592	18.5	1975
179	24	4	134	24	2702	13.5	1975
180	25	4	90	25	2223	16.5	1975
181	24	4	119	24	2545	17	1975
182	18	6	171	18	2984	14.5	1975
183	29	4	90	29	1937	14	1975
184	19	6	232	19	3211	17	1975
185	23	4	115	23	2694	15	1975
186	23	4	120	23	2957	17	1975
187	22	4	121	22	2945	14.5	1975
188	25	4	121	25	2671	13.5	1975
189	33	4	91	33	1795	17.5	1975
190	28	4	107	28	2464	15.5	1976
191	25	4	116	25	2220	16.9	1976
192	25	4	140	25	2572	14.9	1976
193	26	4	98	26	2255	17.7	1976
194	27	4	101	27	2202	15.3	1976
195	17.5	8	305	17.5	4215	13	1976
196	16	8	318	16	4190	13	1976
197	15.5	8	304	15.5	3962	13.9	1976
198	14.5	8	351	14.5	4215	12.8	1976
199	22	6	225	22	3233	15.4	1976
200	22	6	250	22	3353	14.5	1976
201	24	6	200	24	3012	17.6	1976
202	22.5	6	232	22.5	3085	17.6	1976
203	29	4	85	29	2035	22.2	1976
204	24.5	4	98	24.5	2164	22.1	1976
205	29	4	90	29	1937	14.2	1976
206	33	4	91	33	1795	17.4	1976
207	20	6	225	20	3651	17.7	1976
208	18	6	250	18	3574	21	1976
209	18.5	6	250	18.5	3645	16.2	1976
210	17.5	6	258	17.5	3193	17.8	1976
211	29.5	4	97	29.5	1825	12.2	1976
212	32	4	85	32	1990	17	1976
213	28	4	97	28	2155	16.4	1976
214	26.5	4	140	26.5	2565	13.6	1976
215	20	4	130	20	3150	15.7	1976
216	13	8	318	13	3940	13.2	1976
217	19	4	120	19	3270	21.9	1976
218	19	6	156	19	2930	15.5	1976
219	16.5	6	168	16.5	3820	16.7	1976
220	16.5	8	350	16.5	4380	12.1	1976
221	13	8	350	13	4055	12	1976
222	13	8	302	13	3870	15	1976
223	13	8	318	13	3755	14	1976
224	31.5	4	98	31.5	2045	18.5	1977
225	30	4	111	30	2155	14.8	1977
226	36	4	79	36	1825	18.6	1977
227	25.5	4	122	25.5	2300	15.5	1977
228	33.5	4	85	33.5	1945	16.8	1977
229	17.5	8	305	17.5	3880	12.5	1977
230	17	8	260	17	4060	19	1977
231	15.5	8	318	15.5	4140	13.7	1977
232	15	8	302	15	4295	14.9	1977
233	17.5	6	250	17.5	3520	16.4	1977
234	20.5	6	231	20.5	3425	16.9	1977
235	19	6	225	19	3630	17.7	1977
236	18.5	6	250	18.5	3525	19	1977
237	16	8	400	16	4220	11.1	1977
238	15.5	8	350	15.5	4165	11.4	1977
239	15.5	8	400	15.5	4325	12.2	1977
240	16	8	351	16	4335	14.5	1977
241	29	4	97	29	1940	14.5	1977
242	24.5	4	151	24.5	2740	16	1977
243	26	4	97	26	2265	18.2	1977
244	25.5	4	140	25.5	2755	15.8	1977
245	30.5	4	98	30.5	2051	17	1977
246	33.5	4	98	33.5	2075	15.9	1977
247	30	4	97	30	1985	16.4	1977
248	30.5	4	97	30.5	2190	14.1	1977
249	22	6	146	22	2815	14.5	1977
250	21.5	4	121	21.5	2600	12.8	1977
251	21.5	3	80	21.5	2720	13.5	1977
252	43.1	4	90	43.1	1985	21.5	1978
253	36.1	4	98	36.1	1800	14.4	1978
254	32.8	4	78	32.8	1985	19.4	1978
255	39.4	4	85	39.4	2070	18.6	1978
256	36.1	4	91	36.1	1800	16.4	1978
257	19.9	8	260	19.9	3365	15.5	1978
258	19.4	8	318	19.4	3735	13.2	1978
259	20.2	8	302	20.2	3570	12.8	1978
260	19.2	6	231	19.2	3535	19.2	1978
261	20.5	6	200	20.5	3155	18.2	1978
262	20.2	6	200	20.2	2965	15.8	1978
263	25.1	4	140	25.1	2720	15.4	1978
264	20.5	6	225	20.5	3430	17.2	1978
265	19.4	6	232	19.4	3210	17.2	1978
266	20.6	6	231	20.6	3380	15.8	1978
267	20.8	6	200	20.8	3070	16.7	1978
268	18.6	6	225	18.6	3620	18.7	1978
269	18.1	6	258	18.1	3410	15.1	1978
270	19.2	8	305	19.2	3425	13.2	1978
271	17.7	6	231	17.7	3445	13.4	1978
272	18.1	8	302	18.1	3205	11.2	1978
273	17.5	8	318	17.5	4080	13.7	1978
274	30	4	98	30	2155	16.5	1978
275	27.5	4	134	27.5	2560	14.2	1978
276	27.2	4	119	27.2	2300	14.7	1978
277	30.9	4	105	30.9	2230	14.5	1978
278	21.1	4	134	21.1	2515	14.8	1978
279	23.2	4	156	23.2	2745	16.7	1978
280	23.8	4	151	23.8	2855	17.6	1978
281	23.9	4	119	23.9	2405	14.9	1978
282	20.3	5	131	20.3	2830	15.9	1978
283	17	6	163	17	3140	13.6	1978
284	21.6	4	121	21.6	2795	15.7	1978
285	16.2	6	163	16.2	3410	15.8	1978
286	31.5	4	89	31.5	1990	14.9	1978
287	29.5	4	98	29.5	2135	16.6	1978
288	21.5	6	231	21.5	3245	15.4	1979
289	19.8	6	200	19.8	2990	18.2	1979
290	22.3	4	140	22.3	2890	17.3	1979
291	20.2	6	232	20.2	3265	18.2	1979
292	20.6	6	225	20.6	3360	16.6	1979
293	17	8	305	17	3840	15.4	1979
294	17.6	8	302	17.6	3725	13.4	1979
295	16.5	8	351	16.5	3955	13.2	1979
296	18.2	8	318	18.2	3830	15.2	1979
297	16.9	8	350	16.9	4360	14.9	1979
298	15.5	8	351	15.5	4054	14.3	1979
299	19.2	8	267	19.2	3605	15	1979
300	18.5	8	360	18.5	3940	13	1979
301	31.9	4	89	31.9	1925	14	1979
302	34.1	4	86	34.1	1975	15.2	1979
303	35.7	4	98	35.7	1915	14.4	1979
304	27.4	4	121	27.4	2670	15	1979
305	25.4	5	183	25.4	3530	20.1	1979
306	23	8	350	23	3900	17.4	1979
307	27.2	4	141	27.2	3190	24.8	1979
308	23.9	8	260	23.9	3420	22.2	1979
309	34.2	4	105	34.2	2200	13.2	1979
310	34.5	4	105	34.5	2150	14.9	1979
311	31.8	4	85	31.8	2020	19.2	1979
312	37.3	4	91	37.3	2130	14.7	1979
313	28.4	4	151	28.4	2670	16	1979
314	28.8	6	173	28.8	2595	11.3	1979
315	26.8	6	173	26.8	2700	12.9	1979
316	33.5	4	151	33.5	2556	13.2	1979
317	41.5	4	98	41.5	2144	14.7	1980
318	38.1	4	89	38.1	1968	18.8	1980
319	32.1	4	98	32.1	2120	15.5	1980
320	37.2	4	86	37.2	2019	16.4	1980
321	28	4	151	28	2678	16.5	1980
322	26.4	4	140	26.4	2870	18.1	1980
323	24.3	4	151	24.3	3003	20.1	1980
324	19.1	6	225	19.1	3381	18.7	1980
325	34.3	4	97	34.3	2188	15.8	1980
326	29.8	4	134	29.8	2711	15.5	1980
327	31.3	4	120	31.3	2542	17.5	1980
328	37	4	119	37	2434	15	1980
329	32.2	4	108	32.2	2265	15.2	1980
330	46.6	4	86	46.6	2110	17.9	1980
331	27.9	4	156	27.9	2800	14.4	1980
332	40.8	4	85	40.8	2110	19.2	1980
333	44.3	4	90	44.3	2085	21.7	1980
334	43.4	4	90	43.4	2335	23.7	1980
335	36.4	5	121	36.4	2950	19.9	1980
336	30	4	146	30	3250	21.8	1980
337	44.6	4	91	44.6	1850	13.8	1980
338	40.9	4	85	40.9	1835	17.3	1980
339	33.8	4	97	33.8	2145	18	1980
340	29.8	4	89	29.8	1845	15.3	1980
341	32.7	6	168	32.7	2910	11.4	1980
342	23.7	3	70	23.7	2420	12.5	1980
343	35	4	122	35	2500	15.1	1980
344	23.6	4	140	23.6	2905	14.3	1980
345	32.4	4	107	32.4	2290	17	1980
346	27.2	4	135	27.2	2490	15.7	1981
347	26.6	4	151	26.6	2635	16.4	1981
348	25.8	4	156	25.8	2620	14.4	1981
349	23.5	6	173	23.5	2725	12.6	1981
350	30	4	135	30	2385	12.9	1981
351	39.1	4	79	39.1	1755	16.9	1981
352	39	4	86	39	1875	16.4	1981
353	35.1	4	81	35.1	1760	16.1	1981
354	32.3	4	97	32.3	2065	17.8	1981
355	37	4	85	37	1975	19.4	1981
356	37.7	4	89	37.7	2050	17.3	1981
357	34.1	4	91	34.1	1985	16	1981
358	34.7	4	105	34.7	2215	14.9	1981
359	34.4	4	98	34.4	2045	16.2	1981
360	29.9	4	98	29.9	2380	20.7	1981
361	33	4	105	33	2190	14.2	1981
362	34.5	4	100	34.5	2320	15.8	1981
363	33.7	4	107	33.7	2210	14.4	1981
364	32.4	4	108	32.4	2350	16.8	1981
365	32.9	4	119	32.9	2615	14.8	1981
366	31.6	4	120	31.6	2635	18.3	1981
367	28.1	4	141	28.1	3230	20.4	1981
369	30.7	6	145	30.7	3160	19.6	1981
370	25.4	6	168	25.4	2900	12.6	1981
371	24.2	6	146	24.2	2930	13.8	1981
372	22.4	6	231	22.4	3415	15.8	1981
373	26.6	8	350	26.6	3725	19	1981
374	20.2	6	200	20.2	3060	17.1	1981
375	17.6	6	225	17.6	3465	16.6	1981
376	28	4	112	28	2605	19.6	1982
377	27	4	112	27	2640	18.6	1982
378	34	4	112	34	2395	18	1982
379	31	4	112	31	2575	16.2	1982
380	29	4	135	29	2525	16	1982
381	27	4	151	27	2735	18	1982
382	24	4	140	24	2865	16.4	1982
383	23	4	151	23	3035	20.5	1982
384	36	4	105	36	1980	15.3	1982
385	37	4	91	37	2025	18.2	1982
386	31	4	91	31	1970	17.6	1982
387	38	4	105	38	2125	14.7	1982
388	36	4	98	36	2125	17.3	1982
389	36	4	120	36	2160	14.5	1982
390	36	4	107	36	2205	14.5	1982
391	34	4	108	34	2245	16.9	1982
392	38	4	91	38	1965	15	1982
393	32	4	91	32	1965	15.7	1982
394	38	4	91	38	1995	16.2	1982
395	25	6	181	25	2945	16.4	1982
396	38	6	262	38	3015	17	1982
397	26	4	156	26	2585	14.5	1982
398	22	6	232	22	2835	14.7	1982
399	32	4	144	32	2665	13.9	1982
400	36	4	135	36	2370	13	1982
401	27	4	151	27	2950	17.3	1982
402	27	4	140	27	2790	15.6	1982
403	44	4	97	44	2130	24.6	1982
404	32	4	135	32	2295	11.6	1982
405	28	4	120	28	2625	18.6	1982
406	31	4	119	31	2720	19.4	1982
11	\N	4	133	\N	3090	17.5	1970
12	\N	8	350	\N	4142	11.5	1970
13	\N	8	351	\N	4034	11	1970
14	\N	8	383	\N	4166	10.5	1970
15	\N	8	360	\N	3850	11	1970
18	\N	8	302	\N	3353	8	1970
40	\N	4	97	\N	1978	20	1971
368	\N	4	121	\N	2800	15.4	1981
\.


--
-- Data for Name: continents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.continents (contid, continent) FROM stdin;
1	america
2	europe
3	asia
4	africa
5	australia
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.countries (countryid, countryname, continent) FROM stdin;
1	usa	1
2	germany	2
3	france	2
4	japan	3
5	italy	2
6	sweden	2
7	uk	2
8	korea	3
9	russia	2
10	nigeria	4
11	australia	5
12	new zealand	5
13	egypt	4
14	mexico	1
15	brazil	1
\.


--
-- Data for Name: model_list; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.model_list (modelid, maker, model) FROM stdin;
1	1	amc
2	2	audi
3	3	bmw
4	4	buick
5	4	cadillac
6	5	capri
7	4	chevrolet
8	6	chrysler
9	7	citroen
10	8	datsun
11	6	dodge
12	9	fiat
13	5	ford
14	10	hi
15	11	honda
16	12	mazda
17	13	mercedes
18	13	mercedes-benz
19	5	mercury
20	8	nissan
21	4	oldsmobile
22	14	opel
23	15	peugeot
24	6	plymouth
25	4	pontiac
26	16	renault
27	17	saab
28	18	subaru
29	19	toyota
30	20	triumph
31	2	volkswagen
32	21	volvo
33	22	kia
34	23	hyundai
35	6	jeep
36	19	scion
\.


--
-- Name: continents idx_24691_continents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.continents
    ADD CONSTRAINT idx_24691_continents_pkey PRIMARY KEY (contid);


--
-- Name: countries idx_24696_countries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT idx_24696_countries_pkey PRIMARY KEY (countryid);


--
-- Name: car_makers idx_24701_car_makers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.car_makers
    ADD CONSTRAINT idx_24701_car_makers_pkey PRIMARY KEY (id);


--
-- Name: model_list idx_24706_model_list_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_list
    ADD CONSTRAINT idx_24706_model_list_pkey PRIMARY KEY (modelid);


--
-- Name: car_names idx_24711_car_names_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.car_names
    ADD CONSTRAINT idx_24711_car_names_pkey PRIMARY KEY (makeid);


--
-- Name: cars_data idx_24716_cars_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cars_data
    ADD CONSTRAINT idx_24716_cars_data_pkey PRIMARY KEY (id);


--
-- Name: idx_24706_sqlite_autoindex_model_list_1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_24706_sqlite_autoindex_model_list_1 ON public.model_list USING btree (model);


--
-- Name: cars_data cars_data_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cars_data
    ADD CONSTRAINT cars_data_id_fkey FOREIGN KEY (id) REFERENCES public.car_names(makeid);


--
-- Name: countries countries_continent_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_continent_fkey FOREIGN KEY (continent) REFERENCES public.continents(contid);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO data_user;


--
-- Name: TABLE car_makers; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.car_makers TO data_user;


--
-- Name: TABLE car_names; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.car_names TO data_user;


--
-- Name: TABLE cars_data; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.cars_data TO data_user;


--
-- Name: TABLE continents; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.continents TO data_user;


--
-- Name: TABLE countries; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.countries TO data_user;


--
-- Name: TABLE model_list; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.model_list TO data_user;


--
-- Name: car_1__car_1; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1;


--
-- Name: car_1__car_1___n1_0____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_0____inner_view;


--
-- Name: car_1__car_1___n1_0____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_0____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_100____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_100____inner_view;


--
-- Name: car_1__car_1___n1_100____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_100____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_101____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_101____inner_view;


--
-- Name: car_1__car_1___n1_101____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_101____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_101____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_101____wf___f;


--
-- Name: car_1__car_1___n1_103____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_103____inner_view;


--
-- Name: car_1__car_1___n1_103____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_103____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_105____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_105____inner_view;


--
-- Name: car_1__car_1___n1_105____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_105____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_107____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_107____inner_view;


--
-- Name: car_1__car_1___n1_107____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_107____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_109____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_109____inner_view;


--
-- Name: car_1__car_1___n1_109____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_109____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_111____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_111____inner_view;


--
-- Name: car_1__car_1___n1_111____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_111____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_113____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_113____inner_view;


--
-- Name: car_1__car_1___n1_113____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_113____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_115____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_115____inner_view;


--
-- Name: car_1__car_1___n1_115____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_115____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_117____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_117____inner_view;


--
-- Name: car_1__car_1___n1_117____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_117____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_119____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_119____inner_view;


--
-- Name: car_1__car_1___n1_119____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_119____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_119____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_119____wf___f;


--
-- Name: car_1__car_1___n1_11____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_11____inner_view;


--
-- Name: car_1__car_1___n1_11____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_11____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_121____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_121____inner_view;


--
-- Name: car_1__car_1___n1_121____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_121____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_122____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_122____inner_view;


--
-- Name: car_1__car_1___n1_122____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_122____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_124____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_124____inner_view;


--
-- Name: car_1__car_1___n1_124____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_124____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_124____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_124____wf___f;


--
-- Name: car_1__car_1___n1_126____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_126____inner_view;


--
-- Name: car_1__car_1___n1_126____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_126____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_127____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_127____inner_view;


--
-- Name: car_1__car_1___n1_127____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_127____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_129____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_129____inner_view;


--
-- Name: car_1__car_1___n1_129____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_129____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_129____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_129____wf___f;


--
-- Name: car_1__car_1___n1_131____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_131____inner_view;


--
-- Name: car_1__car_1___n1_131____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_131____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_133____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_133____inner_view;


--
-- Name: car_1__car_1___n1_133____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_133____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_135____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_135____inner_view;


--
-- Name: car_1__car_1___n1_135____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_135____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_136____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_136____inner_view;


--
-- Name: car_1__car_1___n1_136____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_136____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_138____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_138____inner_view;


--
-- Name: car_1__car_1___n1_138____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_138____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_138____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_138____wf___f;


--
-- Name: car_1__car_1___n1_13____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_13____inner_view;


--
-- Name: car_1__car_1___n1_13____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_13____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_140____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_140____inner_view;


--
-- Name: car_1__car_1___n1_140____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_140____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_142____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_142____inner_view;


--
-- Name: car_1__car_1___n1_142____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_142____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_143____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_143____inner_view;


--
-- Name: car_1__car_1___n1_143____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_143____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_143____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_143____wf___f;


--
-- Name: car_1__car_1___n1_145____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_145____inner_view;


--
-- Name: car_1__car_1___n1_145____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_145____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_147____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_147____inner_view;


--
-- Name: car_1__car_1___n1_147____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_147____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_148____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_148____inner_view;


--
-- Name: car_1__car_1___n1_148____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_148____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_148____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_148____wf___f;


--
-- Name: car_1__car_1___n1_14____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_14____inner_view;


--
-- Name: car_1__car_1___n1_14____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_14____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_14____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_14____wf___f;


--
-- Name: car_1__car_1___n1_150____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_150____inner_view;


--
-- Name: car_1__car_1___n1_150____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_150____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_152____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_152____inner_view;


--
-- Name: car_1__car_1___n1_152____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_152____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_154____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_154____inner_view;


--
-- Name: car_1__car_1___n1_154____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_154____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_156____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_156____inner_view;


--
-- Name: car_1__car_1___n1_156____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_156____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_157____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_157____inner_view;


--
-- Name: car_1__car_1___n1_157____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_157____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_159____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_159____inner_view;


--
-- Name: car_1__car_1___n1_159____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_159____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_161____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_161____inner_view;


--
-- Name: car_1__car_1___n1_161____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_161____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_163____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_163____inner_view;


--
-- Name: car_1__car_1___n1_163____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_163____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_165____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_165____inner_view;


--
-- Name: car_1__car_1___n1_165____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_165____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_166____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_166____inner_view;


--
-- Name: car_1__car_1___n1_166____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_166____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_168____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_168____inner_view;


--
-- Name: car_1__car_1___n1_168____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_168____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_16____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_16____inner_view;


--
-- Name: car_1__car_1___n1_16____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_16____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_170____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_170____inner_view;


--
-- Name: car_1__car_1___n1_170____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_170____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_170____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_170____wf___f;


--
-- Name: car_1__car_1___n1_172____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_172____inner_view;


--
-- Name: car_1__car_1___n1_172____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_172____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_172____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_172____wf___f;


--
-- Name: car_1__car_1___n1_174____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_174____inner_view;


--
-- Name: car_1__car_1___n1_174____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_174____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_176____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_176____inner_view;


--
-- Name: car_1__car_1___n1_176____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_176____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_177____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_177____inner_view;


--
-- Name: car_1__car_1___n1_177____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_177____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_177____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_177____wf___f;


--
-- Name: car_1__car_1___n1_179____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_179____inner_view;


--
-- Name: car_1__car_1___n1_179____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_179____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_181____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_181____inner_view;


--
-- Name: car_1__car_1___n1_181____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_181____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_182____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_182____inner_view;


--
-- Name: car_1__car_1___n1_182____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_182____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_182____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_182____wf___f;


--
-- Name: car_1__car_1___n1_184____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_184____inner_view;


--
-- Name: car_1__car_1___n1_184____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_184____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_184____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_184____wf___f;


--
-- Name: car_1__car_1___n1_186____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_186____inner_view;


--
-- Name: car_1__car_1___n1_186____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_186____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_188____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_188____inner_view;


--
-- Name: car_1__car_1___n1_188____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_188____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_188____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_188____wf___f;


--
-- Name: car_1__car_1___n1_18____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_18____inner_view;


--
-- Name: car_1__car_1___n1_18____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_18____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_190____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_190____inner_view;


--
-- Name: car_1__car_1___n1_190____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_190____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_190____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_190____wf___f;


--
-- Name: car_1__car_1___n1_192____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_192____inner_view;


--
-- Name: car_1__car_1___n1_192____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_192____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_194____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_194____inner_view;


--
-- Name: car_1__car_1___n1_194____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_194____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_195____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_195____inner_view;


--
-- Name: car_1__car_1___n1_195____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_195____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_197____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_197____inner_view;


--
-- Name: car_1__car_1___n1_197____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_197____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_197____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_197____wf___f;


--
-- Name: car_1__car_1___n1_199____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_199____inner_view;


--
-- Name: car_1__car_1___n1_199____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_199____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_201____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_201____inner_view;


--
-- Name: car_1__car_1___n1_201____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_201____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_203____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_203____inner_view;


--
-- Name: car_1__car_1___n1_203____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_203____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_205____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_205____inner_view;


--
-- Name: car_1__car_1___n1_205____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_205____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_207____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_207____inner_view;


--
-- Name: car_1__car_1___n1_207____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_207____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_209____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_209____inner_view;


--
-- Name: car_1__car_1___n1_209____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_209____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_209____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_209____wf___f;


--
-- Name: car_1__car_1___n1_20____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_20____inner_view;


--
-- Name: car_1__car_1___n1_20____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_20____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_211____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_211____inner_view;


--
-- Name: car_1__car_1___n1_211____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_211____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_211____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_211____wf___f;


--
-- Name: car_1__car_1___n1_213____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_213____inner_view;


--
-- Name: car_1__car_1___n1_213____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_213____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_214____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_214____inner_view;


--
-- Name: car_1__car_1___n1_214____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_214____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_216____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_216____inner_view;


--
-- Name: car_1__car_1___n1_216____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_216____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_216____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_216____wf___f;


--
-- Name: car_1__car_1___n1_218____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_218____inner_view;


--
-- Name: car_1__car_1___n1_218____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_218____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_218____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_218____wf___f;


--
-- Name: car_1__car_1___n1_220____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_220____inner_view;


--
-- Name: car_1__car_1___n1_220____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_220____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_222____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_222____inner_view;


--
-- Name: car_1__car_1___n1_222____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_222____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_224____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_224____inner_view;


--
-- Name: car_1__car_1___n1_224____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_224____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_226____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_226____inner_view;


--
-- Name: car_1__car_1___n1_226____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_226____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_228____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_228____inner_view;


--
-- Name: car_1__car_1___n1_228____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_228____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_228____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_228____wf___f;


--
-- Name: car_1__car_1___n1_22____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_22____inner_view;


--
-- Name: car_1__car_1___n1_22____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_22____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_230____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_230____inner_view;


--
-- Name: car_1__car_1___n1_230____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_230____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_232____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_232____inner_view;


--
-- Name: car_1__car_1___n1_232____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_232____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_234____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_234____inner_view;


--
-- Name: car_1__car_1___n1_234____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_234____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_236____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_236____inner_view;


--
-- Name: car_1__car_1___n1_236____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_236____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_236____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_236____wf___f;


--
-- Name: car_1__car_1___n1_238____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_238____inner_view;


--
-- Name: car_1__car_1___n1_238____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_238____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_239____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_239____inner_view;


--
-- Name: car_1__car_1___n1_239____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_239____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_23____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_23____inner_view;


--
-- Name: car_1__car_1___n1_23____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_23____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_241____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_241____inner_view;


--
-- Name: car_1__car_1___n1_241____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_241____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_241____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_241____wf___f;


--
-- Name: car_1__car_1___n1_243____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_243____inner_view;


--
-- Name: car_1__car_1___n1_243____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_243____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_245____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_245____inner_view;


--
-- Name: car_1__car_1___n1_245____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_245____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_247____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_247____inner_view;


--
-- Name: car_1__car_1___n1_247____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_247____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_248____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_248____inner_view;


--
-- Name: car_1__car_1___n1_248____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_248____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_249____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_249____inner_view;


--
-- Name: car_1__car_1___n1_249____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_249____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_24____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_24____inner_view;


--
-- Name: car_1__car_1___n1_24____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_24____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_251____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_251____inner_view;


--
-- Name: car_1__car_1___n1_251____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_251____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_251____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_251____wf___f;


--
-- Name: car_1__car_1___n1_253____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_253____inner_view;


--
-- Name: car_1__car_1___n1_253____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_253____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_255____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_255____inner_view;


--
-- Name: car_1__car_1___n1_255____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_255____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_255____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_255____wf___f;


--
-- Name: car_1__car_1___n1_257____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_257____inner_view;


--
-- Name: car_1__car_1___n1_257____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_257____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_259____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_259____inner_view;


--
-- Name: car_1__car_1___n1_259____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_259____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_261____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_261____inner_view;


--
-- Name: car_1__car_1___n1_261____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_261____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_263____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_263____inner_view;


--
-- Name: car_1__car_1___n1_263____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_263____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_265____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_265____inner_view;


--
-- Name: car_1__car_1___n1_265____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_265____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_265____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_265____wf___f;


--
-- Name: car_1__car_1___n1_267____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_267____inner_view;


--
-- Name: car_1__car_1___n1_267____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_267____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_269____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_269____inner_view;


--
-- Name: car_1__car_1___n1_269____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_269____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_26____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_26____inner_view;


--
-- Name: car_1__car_1___n1_26____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_26____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_26____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_26____wf___f;


--
-- Name: car_1__car_1___n1_271____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_271____inner_view;


--
-- Name: car_1__car_1___n1_271____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_271____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_273____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_273____inner_view;


--
-- Name: car_1__car_1___n1_273____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_273____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_275____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_275____inner_view;


--
-- Name: car_1__car_1___n1_275____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_275____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_277____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_277____inner_view;


--
-- Name: car_1__car_1___n1_277____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_277____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_278____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_278____inner_view;


--
-- Name: car_1__car_1___n1_278____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_278____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_280____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_280____inner_view;


--
-- Name: car_1__car_1___n1_280____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_280____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_282____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_282____inner_view;


--
-- Name: car_1__car_1___n1_282____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_282____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_282____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_282____wf___f;


--
-- Name: car_1__car_1___n1_284____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_284____inner_view;


--
-- Name: car_1__car_1___n1_284____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_284____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_286____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_286____inner_view;


--
-- Name: car_1__car_1___n1_286____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_286____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_288____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_288____inner_view;


--
-- Name: car_1__car_1___n1_288____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_288____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_28____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_28____inner_view;


--
-- Name: car_1__car_1___n1_28____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_28____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_28____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_28____wf___f;


--
-- Name: car_1__car_1___n1_290____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_290____inner_view;


--
-- Name: car_1__car_1___n1_290____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_290____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_290____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_290____wf___f;


--
-- Name: car_1__car_1___n1_292____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_292____inner_view;


--
-- Name: car_1__car_1___n1_292____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_292____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_293____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_293____inner_view;


--
-- Name: car_1__car_1___n1_293____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_293____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_295____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_295____inner_view;


--
-- Name: car_1__car_1___n1_295____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_295____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_295____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_295____wf___f;


--
-- Name: car_1__car_1___n1_297____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_297____inner_view;


--
-- Name: car_1__car_1___n1_297____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_297____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_299____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_299____inner_view;


--
-- Name: car_1__car_1___n1_299____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_299____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_299____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_299____wf___f;


--
-- Name: car_1__car_1___n1_2____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_2____inner_view;


--
-- Name: car_1__car_1___n1_2____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_2____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_30____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_30____inner_view;


--
-- Name: car_1__car_1___n1_30____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_30____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_32____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_32____inner_view;


--
-- Name: car_1__car_1___n1_32____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_32____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_32____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_32____wf___f;


--
-- Name: car_1__car_1___n1_34____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_34____inner_view;


--
-- Name: car_1__car_1___n1_34____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_34____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_36____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_36____inner_view;


--
-- Name: car_1__car_1___n1_36____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_36____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_38____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_38____inner_view;


--
-- Name: car_1__car_1___n1_38____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_38____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_39____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_39____inner_view;


--
-- Name: car_1__car_1___n1_39____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_39____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_3____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_3____inner_view;


--
-- Name: car_1__car_1___n1_3____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_3____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_41____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_41____inner_view;


--
-- Name: car_1__car_1___n1_41____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_41____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_43____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_43____inner_view;


--
-- Name: car_1__car_1___n1_43____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_43____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_43____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_43____wf___f;


--
-- Name: car_1__car_1___n1_45____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_45____inner_view;


--
-- Name: car_1__car_1___n1_45____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_45____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_45____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_45____wf___f;


--
-- Name: car_1__car_1___n1_47____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_47____inner_view;


--
-- Name: car_1__car_1___n1_47____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_47____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_47____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_47____wf___f;


--
-- Name: car_1__car_1___n1_49____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_49____inner_view;


--
-- Name: car_1__car_1___n1_49____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_49____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_49____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_49____wf___f;


--
-- Name: car_1__car_1___n1_51____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_51____inner_view;


--
-- Name: car_1__car_1___n1_51____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_51____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_52____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_52____inner_view;


--
-- Name: car_1__car_1___n1_52____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_52____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_54____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_54____inner_view;


--
-- Name: car_1__car_1___n1_54____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_54____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_56____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_56____inner_view;


--
-- Name: car_1__car_1___n1_56____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_56____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_56____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_56____wf___f;


--
-- Name: car_1__car_1___n1_58____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_58____inner_view;


--
-- Name: car_1__car_1___n1_58____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_58____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_59____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_59____inner_view;


--
-- Name: car_1__car_1___n1_59____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_59____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_5____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_5____inner_view;


--
-- Name: car_1__car_1___n1_5____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_5____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_5____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_5____wf___f;


--
-- Name: car_1__car_1___n1_61____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_61____inner_view;


--
-- Name: car_1__car_1___n1_61____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_61____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_61____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_61____wf___f;


--
-- Name: car_1__car_1___n1_63____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_63____inner_view;


--
-- Name: car_1__car_1___n1_63____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_63____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_64____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_64____inner_view;


--
-- Name: car_1__car_1___n1_64____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_64____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_64____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_64____wf___f;


--
-- Name: car_1__car_1___n1_66____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_66____inner_view;


--
-- Name: car_1__car_1___n1_66____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_66____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_68____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_68____inner_view;


--
-- Name: car_1__car_1___n1_68____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_68____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_70____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_70____inner_view;


--
-- Name: car_1__car_1___n1_70____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_70____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_70____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_70____wf___f;


--
-- Name: car_1__car_1___n1_72____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_72____inner_view;


--
-- Name: car_1__car_1___n1_72____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_72____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_74____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_74____inner_view;


--
-- Name: car_1__car_1___n1_74____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_74____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_76____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_76____inner_view;


--
-- Name: car_1__car_1___n1_76____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_76____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_77____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_77____inner_view;


--
-- Name: car_1__car_1___n1_77____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_77____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_77____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_77____wf___f;


--
-- Name: car_1__car_1___n1_79____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_79____inner_view;


--
-- Name: car_1__car_1___n1_79____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_79____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_7____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_7____inner_view;


--
-- Name: car_1__car_1___n1_7____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_7____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_7____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_7____wf___f;


--
-- Name: car_1__car_1___n1_81____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_81____inner_view;


--
-- Name: car_1__car_1___n1_81____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_81____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_82____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_82____inner_view;


--
-- Name: car_1__car_1___n1_82____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_82____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_83____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_83____inner_view;


--
-- Name: car_1__car_1___n1_83____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_83____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_85____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_85____inner_view;


--
-- Name: car_1__car_1___n1_85____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_85____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_85____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_85____wf___f;


--
-- Name: car_1__car_1___n1_87____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_87____inner_view;


--
-- Name: car_1__car_1___n1_87____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_87____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_87____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_87____wf___f;


--
-- Name: car_1__car_1___n1_89____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_89____inner_view;


--
-- Name: car_1__car_1___n1_89____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_89____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_90____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_90____inner_view;


--
-- Name: car_1__car_1___n1_90____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_90____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_91____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_91____inner_view;


--
-- Name: car_1__car_1___n1_91____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_91____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_93____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_93____inner_view;


--
-- Name: car_1__car_1___n1_93____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_93____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_95____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_95____inner_view;


--
-- Name: car_1__car_1___n1_95____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_95____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_97____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_97____inner_view;


--
-- Name: car_1__car_1___n1_97____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_97____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_98____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_98____inner_view;


--
-- Name: car_1__car_1___n1_98____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_98____inner_view__negative_examples;


--
-- Name: car_1__car_1___n1_98____wf___f; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_98____wf___f;


--
-- Name: car_1__car_1___n1_9____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_9____inner_view;


--
-- Name: car_1__car_1___n1_9____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n1_9____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_0____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_0____inner_view;


--
-- Name: car_1__car_1___n2_0____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_0____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_10____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_10____inner_view;


--
-- Name: car_1__car_1___n2_10____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_10____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_11____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_11____inner_view;


--
-- Name: car_1__car_1___n2_11____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_11____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_12____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_12____inner_view;


--
-- Name: car_1__car_1___n2_12____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_12____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_13____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_13____inner_view;


--
-- Name: car_1__car_1___n2_13____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_13____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_14____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_14____inner_view;


--
-- Name: car_1__car_1___n2_14____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_14____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_15____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_15____inner_view;


--
-- Name: car_1__car_1___n2_15____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_15____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_16____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_16____inner_view;


--
-- Name: car_1__car_1___n2_16____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_16____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_17____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_17____inner_view;


--
-- Name: car_1__car_1___n2_17____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_17____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_18____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_18____inner_view;


--
-- Name: car_1__car_1___n2_18____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_18____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_19____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_19____inner_view;


--
-- Name: car_1__car_1___n2_19____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_19____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_1____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_1____inner_view;


--
-- Name: car_1__car_1___n2_1____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_1____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_20____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_20____inner_view;


--
-- Name: car_1__car_1___n2_20____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_20____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_21____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_21____inner_view;


--
-- Name: car_1__car_1___n2_21____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_21____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_22____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_22____inner_view;


--
-- Name: car_1__car_1___n2_22____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_22____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_23____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_23____inner_view;


--
-- Name: car_1__car_1___n2_23____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_23____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_24____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_24____inner_view;


--
-- Name: car_1__car_1___n2_24____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_24____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_25____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_25____inner_view;


--
-- Name: car_1__car_1___n2_25____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_25____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_26____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_26____inner_view;


--
-- Name: car_1__car_1___n2_26____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_26____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_27____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_27____inner_view;


--
-- Name: car_1__car_1___n2_27____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_27____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_28____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_28____inner_view;


--
-- Name: car_1__car_1___n2_28____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_28____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_29____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_29____inner_view;


--
-- Name: car_1__car_1___n2_29____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_29____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_2____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_2____inner_view;


--
-- Name: car_1__car_1___n2_2____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_2____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_30____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_30____inner_view;


--
-- Name: car_1__car_1___n2_30____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_30____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_31____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_31____inner_view;


--
-- Name: car_1__car_1___n2_31____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_31____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_32____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_32____inner_view;


--
-- Name: car_1__car_1___n2_32____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_32____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_33____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_33____inner_view;


--
-- Name: car_1__car_1___n2_33____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_33____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_34____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_34____inner_view;


--
-- Name: car_1__car_1___n2_34____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_34____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_35____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_35____inner_view;


--
-- Name: car_1__car_1___n2_35____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_35____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_36____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_36____inner_view;


--
-- Name: car_1__car_1___n2_36____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_36____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_37____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_37____inner_view;


--
-- Name: car_1__car_1___n2_37____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_37____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_38____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_38____inner_view;


--
-- Name: car_1__car_1___n2_38____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_38____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_39____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_39____inner_view;


--
-- Name: car_1__car_1___n2_39____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_39____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_3____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_3____inner_view;


--
-- Name: car_1__car_1___n2_3____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_3____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_40____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_40____inner_view;


--
-- Name: car_1__car_1___n2_40____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_40____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_41____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_41____inner_view;


--
-- Name: car_1__car_1___n2_41____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_41____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_42____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_42____inner_view;


--
-- Name: car_1__car_1___n2_42____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_42____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_43____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_43____inner_view;


--
-- Name: car_1__car_1___n2_43____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_43____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_44____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_44____inner_view;


--
-- Name: car_1__car_1___n2_44____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_44____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_45____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_45____inner_view;


--
-- Name: car_1__car_1___n2_45____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_45____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_46____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_46____inner_view;


--
-- Name: car_1__car_1___n2_46____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_46____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_47____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_47____inner_view;


--
-- Name: car_1__car_1___n2_47____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_47____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_48____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_48____inner_view;


--
-- Name: car_1__car_1___n2_48____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_48____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_49____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_49____inner_view;


--
-- Name: car_1__car_1___n2_49____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_49____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_4____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_4____inner_view;


--
-- Name: car_1__car_1___n2_4____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_4____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_50____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_50____inner_view;


--
-- Name: car_1__car_1___n2_50____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_50____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_51____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_51____inner_view;


--
-- Name: car_1__car_1___n2_51____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_51____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_52____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_52____inner_view;


--
-- Name: car_1__car_1___n2_52____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_52____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_53____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_53____inner_view;


--
-- Name: car_1__car_1___n2_53____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_53____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_54____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_54____inner_view;


--
-- Name: car_1__car_1___n2_54____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_54____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_55____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_55____inner_view;


--
-- Name: car_1__car_1___n2_55____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_55____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_56____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_56____inner_view;


--
-- Name: car_1__car_1___n2_56____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_56____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_57____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_57____inner_view;


--
-- Name: car_1__car_1___n2_57____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_57____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_58____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_58____inner_view;


--
-- Name: car_1__car_1___n2_58____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_58____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_59____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_59____inner_view;


--
-- Name: car_1__car_1___n2_59____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_59____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_5____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_5____inner_view;


--
-- Name: car_1__car_1___n2_5____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_5____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_60____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_60____inner_view;


--
-- Name: car_1__car_1___n2_60____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_60____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_61____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_61____inner_view;


--
-- Name: car_1__car_1___n2_61____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_61____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_62____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_62____inner_view;


--
-- Name: car_1__car_1___n2_62____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_62____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_63____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_63____inner_view;


--
-- Name: car_1__car_1___n2_63____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_63____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_64____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_64____inner_view;


--
-- Name: car_1__car_1___n2_64____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_64____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_65____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_65____inner_view;


--
-- Name: car_1__car_1___n2_65____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_65____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_66____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_66____inner_view;


--
-- Name: car_1__car_1___n2_66____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_66____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_67____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_67____inner_view;


--
-- Name: car_1__car_1___n2_67____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_67____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_68____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_68____inner_view;


--
-- Name: car_1__car_1___n2_68____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_68____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_69____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_69____inner_view;


--
-- Name: car_1__car_1___n2_69____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_69____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_6____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_6____inner_view;


--
-- Name: car_1__car_1___n2_6____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_6____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_70____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_70____inner_view;


--
-- Name: car_1__car_1___n2_70____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_70____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_71____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_71____inner_view;


--
-- Name: car_1__car_1___n2_71____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_71____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_72____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_72____inner_view;


--
-- Name: car_1__car_1___n2_72____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_72____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_73____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_73____inner_view;


--
-- Name: car_1__car_1___n2_73____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_73____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_74____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_74____inner_view;


--
-- Name: car_1__car_1___n2_74____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_74____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_75____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_75____inner_view;


--
-- Name: car_1__car_1___n2_75____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_75____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_76____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_76____inner_view;


--
-- Name: car_1__car_1___n2_76____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_76____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_77____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_77____inner_view;


--
-- Name: car_1__car_1___n2_77____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_77____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_78____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_78____inner_view;


--
-- Name: car_1__car_1___n2_78____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_78____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_79____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_79____inner_view;


--
-- Name: car_1__car_1___n2_79____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_79____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_7____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_7____inner_view;


--
-- Name: car_1__car_1___n2_7____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_7____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_80____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_80____inner_view;


--
-- Name: car_1__car_1___n2_80____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_80____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_81____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_81____inner_view;


--
-- Name: car_1__car_1___n2_81____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_81____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_82____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_82____inner_view;


--
-- Name: car_1__car_1___n2_82____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_82____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_83____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_83____inner_view;


--
-- Name: car_1__car_1___n2_83____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_83____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_84____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_84____inner_view;


--
-- Name: car_1__car_1___n2_84____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_84____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_85____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_85____inner_view;


--
-- Name: car_1__car_1___n2_85____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_85____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_86____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_86____inner_view;


--
-- Name: car_1__car_1___n2_86____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_86____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_87____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_87____inner_view;


--
-- Name: car_1__car_1___n2_87____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_87____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_88____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_88____inner_view;


--
-- Name: car_1__car_1___n2_88____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_88____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_89____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_89____inner_view;


--
-- Name: car_1__car_1___n2_89____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_89____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_8____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_8____inner_view;


--
-- Name: car_1__car_1___n2_8____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_8____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_90____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_90____inner_view;


--
-- Name: car_1__car_1___n2_90____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_90____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_91____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_91____inner_view;


--
-- Name: car_1__car_1___n2_91____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_91____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_92____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_92____inner_view;


--
-- Name: car_1__car_1___n2_92____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_92____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_93____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_93____inner_view;


--
-- Name: car_1__car_1___n2_93____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_93____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_94____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_94____inner_view;


--
-- Name: car_1__car_1___n2_94____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_94____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_95____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_95____inner_view;


--
-- Name: car_1__car_1___n2_95____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_95____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_96____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_96____inner_view;


--
-- Name: car_1__car_1___n2_96____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_96____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_97____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_97____inner_view;


--
-- Name: car_1__car_1___n2_97____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_97____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_98____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_98____inner_view;


--
-- Name: car_1__car_1___n2_98____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_98____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_99____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_99____inner_view;


--
-- Name: car_1__car_1___n2_99____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_99____inner_view__negative_examples;


--
-- Name: car_1__car_1___n2_9____inner_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_9____inner_view;


--
-- Name: car_1__car_1___n2_9____inner_view__negative_examples; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.car_1__car_1___n2_9____inner_view__negative_examples;


--
-- Name: test_array_agg; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: data_user
--

REFRESH MATERIALIZED VIEW public.test_array_agg;


--
-- PostgreSQL database dump complete
--

