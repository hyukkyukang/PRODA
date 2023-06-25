--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2 (Debian 15.2-1.pgdg110+1)
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
-- Name: proda_collection; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE proda_collection WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE proda_collection OWNER TO postgres;

\connect proda_collection

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: collection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collection (
    id integer NOT NULL,
    task_set_id integer NOT NULL,
    task_id integer NOT NULL,
    user_id character varying(64) NOT NULL,
    is_correct boolean,
    nl text,
    date timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.collection OWNER TO postgres;

--
-- Name: collection_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.collection_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.collection_id_seq OWNER TO postgres;

--
-- Name: collection_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.collection_id_seq OWNED BY public.collection.id;


--
-- Name: task; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task (
    id integer NOT NULL,
    nl text NOT NULL,
    sql text NOT NULL,
    query_type character varying(64) NOT NULL,
    evqa_path character varying(256) NOT NULL,
    table_excerpt_path character varying(256) DEFAULT NULL::character varying,
    result_table_path character varying(256) DEFAULT NULL::character varying,
    nl_mapping_path character varying(256) DEFAULT NULL::character varying,
    db_name character varying(128) NOT NULL,
    task_type integer NOT NULL,
    sub_task_ids integer[]
);


ALTER TABLE public.task OWNER TO postgres;

--
-- Name: task_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.task_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_id_seq OWNER TO postgres;

--
-- Name: task_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.task_id_seq OWNED BY public.task.id;


--
-- Name: task_set; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task_set (
    id integer NOT NULL,
    task_ids integer[] NOT NULL,
    date timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.task_set OWNER TO postgres;

--
-- Name: task_set_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.task_set_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_set_id_seq OWNER TO postgres;

--
-- Name: task_set_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.task_set_id_seq OWNED BY public.task_set.id;


--
-- Name: collection id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collection ALTER COLUMN id SET DEFAULT nextval('public.collection_id_seq'::regclass);


--
-- Name: task id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task ALTER COLUMN id SET DEFAULT nextval('public.task_id_seq'::regclass);


--
-- Name: task_set id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_set ALTER COLUMN id SET DEFAULT nextval('public.task_set_id_seq'::regclass);


--
-- Data for Name: collection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.collection (id, task_set_id, task_id, user_id, is_correct, nl, date) FROM stdin;
\.


--
-- Data for Name: task; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task (id, nl, sql, query_type, evqa_path, table_excerpt_path, result_table_path, nl_mapping_path, db_name, task_type, sub_task_ids) FROM stdin;
1	B1 is to Find targsubtype_name and targsubtype_id of targsubtype where ( targsubtype_name of targsubtype not equal to 'Police Security Forces/Officers' ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_0_targsubtype.targsubtype_name, N1_0_targsubtype.targsubtype_id FROM targsubtype AS N1_0_targsubtype WHERE N1_0_targsubtype.targsubtype_name != 'Police Security Forces/Officers'	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/8L5OJ9C3Q9.json	/root/PRODA/data/task/table_excerpt/8L5OJ9C3Q9.json	/root/PRODA/data/task/result_table/8L5OJ9C3Q9.json	/root/PRODA/data/task/nl_mapping/8L5OJ9C3Q9.json	db_name	0	{}
2	B1 is to Find avg of killed_american_num of terror.\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT AVG(N1_1_terror.killed_american_num) FROM terror AS N1_1_terror	non-nested__1__False__False__False__False__False	/root/PRODA/data/task/evqa/WKY1P87HNI.json	/root/PRODA/data/task/table_excerpt/WKY1P87HNI.json	/root/PRODA/data/task/result_table/WKY1P87HNI.json	/root/PRODA/data/task/nl_mapping/WKY1P87HNI.json	db_name	0	{}
3	B1 is to Find region_name and region_id (in ascending order) of region where ( region_name of region not equal to 'Southeast Asia' ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_2_region.region_name, N1_2_region.region_id FROM region AS N1_2_region WHERE N1_2_region.region_name != 'Southeast Asia' ORDER BY N1_2_region.region_id	non-nested__1__True__False__False__True__False	/root/PRODA/data/task/evqa/O1ORJ1SKDD.json	/root/PRODA/data/task/table_excerpt/O1ORJ1SKDD.json	/root/PRODA/data/task/result_table/O1ORJ1SKDD.json	/root/PRODA/data/task/nl_mapping/O1ORJ1SKDD.json	db_name	0	{}
4	B1 is to Find targsubtype_name and targsubtype_id of targsubtype.\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_3_targsubtype.targsubtype_name, N1_3_targsubtype.targsubtype_id FROM targsubtype AS N1_3_targsubtype	non-nested__1__False__False__False__False__False	/root/PRODA/data/task/evqa/5NADHSKKAG.json	/root/PRODA/data/task/table_excerpt/5NADHSKKAG.json	/root/PRODA/data/task/result_table/5NADHSKKAG.json	/root/PRODA/data/task/nl_mapping/5NADHSKKAG.json	db_name	0	{}
5	B1 is to Find region_name and region_id of region where ( region_name of region not equal to 'North America' ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_4_region.region_name, N1_4_region.region_id FROM region AS N1_4_region WHERE N1_4_region.region_name != 'North America'	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/10N8KZ0O64.json	/root/PRODA/data/task/table_excerpt/10N8KZ0O64.json	/root/PRODA/data/task/result_table/10N8KZ0O64.json	/root/PRODA/data/task/nl_mapping/10N8KZ0O64.json	db_name	0	{}
6	B1 is to Find all of weaptype where ( weaptype_name of weaptype is 'Incendiary' ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT * FROM weaptype AS N1_5_weaptype WHERE N1_5_weaptype.weaptype_name = 'Incendiary'	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/KNKJ4WRUJY.json	/root/PRODA/data/task/table_excerpt/KNKJ4WRUJY.json	/root/PRODA/data/task/result_table/KNKJ4WRUJY.json	/root/PRODA/data/task/nl_mapping/KNKJ4WRUJY.json	db_name	0	{}
7	B1 is to Find all of targtype where ( targtype_name of targtype is not in {Utilities, Government (General), Government (Diplomatic)} ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT * FROM targtype AS N1_6_targtype WHERE N1_6_targtype.targtype_name NOT IN ('Utilities','Government (General)','Government (Diplomatic)')	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/RFXRMDXIOB.json	/root/PRODA/data/task/table_excerpt/RFXRMDXIOB.json	/root/PRODA/data/task/result_table/RFXRMDXIOB.json	/root/PRODA/data/task/nl_mapping/RFXRMDXIOB.json	db_name	0	{}
8	B1 is to Find kidnap_hours of terror where ( property_description of terror is in {The house was slightly damaged.  16 windows were shattered., Twelve windows shattered and bomb fragments hurled into the interior of the building, Upper floor badly damaged} ), or where ( terror_criterion_2 of terror is True ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_7_terror.kidnap_hours FROM terror AS N1_7_terror WHERE (N1_7_terror.property_description IN ('The house was slightly damaged.  16 windows were shattered.','Twelve windows shattered and bomb fragments hurled into the interior of the building','Upper floor badly damaged') OR N1_7_terror.terror_criterion_2 = True)	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/ICOGVZFBUL.json	/root/PRODA/data/task/table_excerpt/ICOGVZFBUL.json	/root/PRODA/data/task/result_table/ICOGVZFBUL.json	/root/PRODA/data/task/nl_mapping/ICOGVZFBUL.json	db_name	0	{}
9	B1 is to Find hostaged_american_num of terror, region_id of region where ( hostaged_american_num of terror is greater than 0 ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_8_terror.hostaged_american_num, N1_8_region.region_id FROM terror AS N1_8_terror JOIN region AS N1_8_region ON N1_8_terror.region_id=N1_8_region.region_id WHERE N1_8_terror.hostaged_american_num > 0	non-nested__2__True__False__False__False__False	/root/PRODA/data/task/evqa/VEWL4D1927.json	/root/PRODA/data/task/table_excerpt/VEWL4D1927.json	/root/PRODA/data/task/result_table/VEWL4D1927.json	/root/PRODA/data/task/nl_mapping/VEWL4D1927.json	db_name	0	{}
10	B1 is to Find region_id and region_name of region where ( region_name of region is 'Southeast Asia' ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_9_region.region_id, N1_9_region.region_name FROM region AS N1_9_region WHERE N1_9_region.region_name = 'Southeast Asia'	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/75I8MMCTYY.json	/root/PRODA/data/task/table_excerpt/75I8MMCTYY.json	/root/PRODA/data/task/result_table/75I8MMCTYY.json	/root/PRODA/data/task/nl_mapping/75I8MMCTYY.json	db_name	0	{}
11	B1 is to Find is_suicide and property_damage_level of terror.\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_10_terror.is_suicide, N1_10_terror.property_damage_level FROM terror AS N1_10_terror	non-nested__1__False__False__False__False__False	/root/PRODA/data/task/evqa/IB3O7MF9O4.json	/root/PRODA/data/task/table_excerpt/IB3O7MF9O4.json	/root/PRODA/data/task/result_table/IB3O7MF9O4.json	/root/PRODA/data/task/nl_mapping/IB3O7MF9O4.json	db_name	0	{}
12	B1 is to Find region_id of region where ( region_name of region is 'North America' and motive of terror like '%rme%' ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_11_region.region_id FROM terror AS N1_11_terror JOIN region AS N1_11_region ON N1_11_terror.region_id=N1_11_region.region_id WHERE (N1_11_region.region_name = 'North America' AND N1_11_terror.motive LIKE '%rme%')	non-nested__2__True__False__False__False__False	/root/PRODA/data/task/evqa/O6ZT61G0X7.json	/root/PRODA/data/task/table_excerpt/O6ZT61G0X7.json	/root/PRODA/data/task/result_table/O6ZT61G0X7.json	/root/PRODA/data/task/nl_mapping/O6ZT61G0X7.json	db_name	0	{}
13	B1 is to Find count of all of terror where ( is_ransom of terror is False ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT COUNT(*) FROM terror AS N1_12_terror WHERE N1_12_terror.is_ransom = False	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/J7ME7OLTFB.json	/root/PRODA/data/task/table_excerpt/J7ME7OLTFB.json	/root/PRODA/data/task/result_table/J7ME7OLTFB.json	/root/PRODA/data/task/nl_mapping/J7ME7OLTFB.json	db_name	0	{}
14	B1 is to Find count of weapsubtype_id of weapsubtype.\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT COUNT(N1_13_weapsubtype.weapsubtype_id) FROM weapsubtype AS N1_13_weapsubtype	non-nested__1__False__False__False__False__False	/root/PRODA/data/task/evqa/GESLQ7F72F.json	/root/PRODA/data/task/table_excerpt/GESLQ7F72F.json	/root/PRODA/data/task/result_table/GESLQ7F72F.json	/root/PRODA/data/task/nl_mapping/GESLQ7F72F.json	db_name	0	{}
15	B1 is to Find dbsource and count of all of terror for each dbsource of terror where ( dbsource of terror is in {Hewitt Project, PGIS, UMD Miscellaneous} and killed_american_num of terror is greater than 0 ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_15_terror.dbsource, COUNT(*) FROM terror AS N1_15_terror WHERE (N1_15_terror.dbsource IN ('Hewitt Project','PGIS','UMD Miscellaneous') AND N1_15_terror.killed_american_num > 0) GROUP BY N1_15_terror.dbsource	non-nested__1__True__True__False__False__False	/root/PRODA/data/task/evqa/69N3O8626C.json	/root/PRODA/data/task/table_excerpt/69N3O8626C.json	/root/PRODA/data/task/result_table/69N3O8626C.json	/root/PRODA/data/task/nl_mapping/69N3O8626C.json	db_name	0	{}
16	B1 is to Find dbsource and count of all of terror for each dbsource of terror where ( dbsource of terror is in {Hewitt Project, PGIS, UMD Miscellaneous} and killed_american_num of terror is greater than 0 ).\nB2 is to Find dbsource of B1_results where ( count of all of B1_results is less than or equal to 85 ).\nPlease write out a single interrogative sentence for B2 in detail without any explicit reference to B1.\n	SELECT DISTINCT N1_14_terror.dbsource FROM terror AS N1_14_terror WHERE (N1_14_terror.dbsource IN ('Hewitt Project','PGIS','UMD Miscellaneous') AND N1_14_terror.killed_american_num > 0) GROUP BY N1_14_terror.dbsource HAVING COUNT(*) <= 85	non-nested__1__True__True__True__False__False	/root/PRODA/data/task/evqa/VPZ2IHYL2U.json	/root/PRODA/data/task/table_excerpt/VPZ2IHYL2U.json	/root/PRODA/data/task/result_table/VPZ2IHYL2U.json	/root/PRODA/data/task/nl_mapping/VPZ2IHYL2U.json	db_name	0	{15}
17	B1 is to Find count of region_name of region.\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT COUNT(N1_16_region.region_name) FROM region AS N1_16_region	non-nested__1__False__False__False__False__False	/root/PRODA/data/task/evqa/VGARNLZ6GQ.json	/root/PRODA/data/task/table_excerpt/VGARNLZ6GQ.json	/root/PRODA/data/task/result_table/VGARNLZ6GQ.json	/root/PRODA/data/task/nl_mapping/VGARNLZ6GQ.json	db_name	0	{}
18	B1 is to Find targtype_name and targtype_id of targtype.\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_17_targtype.targtype_name, N1_17_targtype.targtype_id FROM targtype AS N1_17_targtype	non-nested__1__False__False__False__False__False	/root/PRODA/data/task/evqa/RRSVKCNHWH.json	/root/PRODA/data/task/table_excerpt/RRSVKCNHWH.json	/root/PRODA/data/task/result_table/RRSVKCNHWH.json	/root/PRODA/data/task/nl_mapping/RRSVKCNHWH.json	db_name	0	{}
19	B1 is to Find count of region_id and count of region_name of region.\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT COUNT(N1_18_region.region_id), COUNT(N1_18_region.region_name) FROM region AS N1_18_region	non-nested__1__False__False__False__False__False	/root/PRODA/data/task/evqa/Y7YI86DVRC.json	/root/PRODA/data/task/table_excerpt/Y7YI86DVRC.json	/root/PRODA/data/task/result_table/Y7YI86DVRC.json	/root/PRODA/data/task/nl_mapping/Y7YI86DVRC.json	db_name	0	{}
20	B1 is to Find count of iday and count of is_suicide of terror where ( longitude of terror is greater than or equal to -105.265942 and longitude of terror is less than -89.176269 ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT COUNT(N1_19_terror.iday), COUNT(N1_19_terror.is_suicide) FROM terror AS N1_19_terror WHERE (N1_19_terror.longitude >= -105.265942 AND N1_19_terror.longitude < -89.176269)	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/VKV3TO5KHO.json	/root/PRODA/data/task/table_excerpt/VKV3TO5KHO.json	/root/PRODA/data/task/result_table/VKV3TO5KHO.json	/root/PRODA/data/task/nl_mapping/VKV3TO5KHO.json	db_name	0	{}
21	B1 is to Find dbsource and count of all of terror for each dbsource of terror where ( whole_wounded_num of terror is less than or equal to 0 ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_20_terror.dbsource, COUNT(*) FROM terror AS N1_20_terror WHERE N1_20_terror.whole_wounded_num <= 0 GROUP BY N1_20_terror.dbsource	non-nested__1__True__True__False__False__False	/root/PRODA/data/task/evqa/9PZU8XDU45.json	/root/PRODA/data/task/table_excerpt/9PZU8XDU45.json	/root/PRODA/data/task/result_table/9PZU8XDU45.json	/root/PRODA/data/task/nl_mapping/9PZU8XDU45.json	db_name	0	{}
22	B1 is to Find region_id and region_name (in ascending order) of region where ( region_name of region is 'North America' ),   with finding only top 1 results.\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_21_region.region_id, N1_21_region.region_name FROM region AS N1_21_region WHERE N1_21_region.region_name = 'North America' ORDER BY N1_21_region.region_name LIMIT 1	non-nested__1__True__False__False__True__True	/root/PRODA/data/task/evqa/H7KI1P6W1Q.json	/root/PRODA/data/task/table_excerpt/H7KI1P6W1Q.json	/root/PRODA/data/task/result_table/H7KI1P6W1Q.json	/root/PRODA/data/task/nl_mapping/H7KI1P6W1Q.json	db_name	0	{}
23	B1 is to Find targsubtype_id of targsubtype where ( targsubtype_name of targsubtype is in {Police Building (headquarters, station, school), Laborer (General)/Occupation Identified} ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_22_targsubtype.targsubtype_id FROM targsubtype AS N1_22_targsubtype WHERE N1_22_targsubtype.targsubtype_name IN ('Police Building (headquarters, station, school)','Laborer (General)/Occupation Identified')	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/94K2N46TDQ.json	/root/PRODA/data/task/table_excerpt/94K2N46TDQ.json	/root/PRODA/data/task/result_table/94K2N46TDQ.json	/root/PRODA/data/task/nl_mapping/94K2N46TDQ.json	db_name	0	{}
24	B1 is to Find count of weapsubtype_name of weapsubtype where ( weapsubtype_name of weapsubtype like 'Exp%' ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT COUNT(N1_23_weapsubtype.weapsubtype_name) FROM weapsubtype AS N1_23_weapsubtype WHERE N1_23_weapsubtype.weapsubtype_name LIKE 'Exp%'	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/51RBRG2NVI.json	/root/PRODA/data/task/table_excerpt/51RBRG2NVI.json	/root/PRODA/data/task/result_table/51RBRG2NVI.json	/root/PRODA/data/task/nl_mapping/51RBRG2NVI.json	db_name	0	{}
25	B1 is to Find count of weaptype_id of terror where ( claimmode of terror is 'Letter' and property_damage_level of terror is 'Minor (likely < $1 million)' ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT COUNT(N1_24_terror.weaptype_id) FROM terror AS N1_24_terror WHERE (N1_24_terror.claimmode = 'Letter' AND N1_24_terror.property_damage_level = 'Minor (likely < $1 million)')	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/HG3EN7HYLP.json	/root/PRODA/data/task/table_excerpt/HG3EN7HYLP.json	/root/PRODA/data/task/result_table/HG3EN7HYLP.json	/root/PRODA/data/task/nl_mapping/HG3EN7HYLP.json	db_name	0	{}
26	B1 is to Find targtype_id and eventid (in ascending order) of terror where ( imonth of terror is greater than or equal to 1 and imonth of terror is less than 9 ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_25_terror.targtype_id, N1_25_terror.eventid FROM terror AS N1_25_terror WHERE (N1_25_terror.imonth >= 1 AND N1_25_terror.imonth < 9) ORDER BY N1_25_terror.eventid	non-nested__1__True__False__False__True__False	/root/PRODA/data/task/evqa/TSFD4ZBDRV.json	/root/PRODA/data/task/table_excerpt/TSFD4ZBDRV.json	/root/PRODA/data/task/result_table/TSFD4ZBDRV.json	/root/PRODA/data/task/nl_mapping/TSFD4ZBDRV.json	db_name	0	{}
27	B1 is to Find iday of terror.\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_26_terror.iday FROM terror AS N1_26_terror	non-nested__1__False__False__False__False__False	/root/PRODA/data/task/evqa/VEH79FY2PI.json	/root/PRODA/data/task/table_excerpt/VEH79FY2PI.json	/root/PRODA/data/task/result_table/VEH79FY2PI.json	/root/PRODA/data/task/nl_mapping/VEH79FY2PI.json	db_name	0	{}
28	B1 is to Find avg of estimated_value_of_property_damage, count of targtype_id, and count of eventid of terror.\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT AVG(N1_27_terror.estimated_value_of_property_damage), COUNT(N1_27_terror.targtype_id), COUNT(N1_27_terror.eventid) FROM terror AS N1_27_terror	non-nested__1__False__False__False__False__False	/root/PRODA/data/task/evqa/YEY228WXBF.json	/root/PRODA/data/task/table_excerpt/YEY228WXBF.json	/root/PRODA/data/task/result_table/YEY228WXBF.json	/root/PRODA/data/task/nl_mapping/YEY228WXBF.json	db_name	0	{}
29	B1 is to Find weaptype_id of weaptype where ( terror_criterion_2 of terror is True ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_28_weaptype.weaptype_id FROM weaptype AS N1_28_weaptype JOIN terror AS N1_28_terror ON N1_28_terror.weaptype_id=N1_28_weaptype.weaptype_id WHERE N1_28_terror.terror_criterion_2 = True	non-nested__2__True__False__False__False__False	/root/PRODA/data/task/evqa/W3AB6WDONW.json	/root/PRODA/data/task/table_excerpt/W3AB6WDONW.json	/root/PRODA/data/task/result_table/W3AB6WDONW.json	/root/PRODA/data/task/nl_mapping/W3AB6WDONW.json	db_name	0	{}
30	B1 is to Find iday of terror, weapsubtype_name of weapsubtype.\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_29_terror.iday, N1_29_weapsubtype.weapsubtype_name FROM terror AS N1_29_terror JOIN weapsubtype AS N1_29_weapsubtype ON N1_29_terror.weapsubtype_id=N1_29_weapsubtype.weapsubtype_id	non-nested__2__False__False__False__False__False	/root/PRODA/data/task/evqa/6GAFT2EE4S.json	/root/PRODA/data/task/table_excerpt/6GAFT2EE4S.json	/root/PRODA/data/task/result_table/6GAFT2EE4S.json	/root/PRODA/data/task/nl_mapping/6GAFT2EE4S.json	db_name	0	{}
31	B1 is to Find all of terror where ( whole_wounded_num of terror is 0 and is_extended of terror is False ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT * FROM terror AS N1_30_terror WHERE (N1_30_terror.whole_wounded_num = 0 AND N1_30_terror.is_extended = False)	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/CBAUAJR7LZ.json	/root/PRODA/data/task/table_excerpt/CBAUAJR7LZ.json	/root/PRODA/data/task/result_table/CBAUAJR7LZ.json	/root/PRODA/data/task/nl_mapping/CBAUAJR7LZ.json	db_name	0	{}
32	B1 is to Find all of terror where ( is_terror_group_certain of terror is False ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT * FROM terror AS N1_31_terror WHERE N1_31_terror.is_terror_group_certain = False	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/0DI45GN1X1.json	/root/PRODA/data/task/table_excerpt/0DI45GN1X1.json	/root/PRODA/data/task/result_table/0DI45GN1X1.json	/root/PRODA/data/task/nl_mapping/0DI45GN1X1.json	db_name	0	{}
33	B1 is to Find region_name (in ascending order) and region_id of region.\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_32_region.region_name, N1_32_region.region_id FROM region AS N1_32_region ORDER BY N1_32_region.region_name	non-nested__1__False__False__False__True__False	/root/PRODA/data/task/evqa/6OLZMJDAXU.json	/root/PRODA/data/task/table_excerpt/6OLZMJDAXU.json	/root/PRODA/data/task/result_table/6OLZMJDAXU.json	/root/PRODA/data/task/nl_mapping/6OLZMJDAXU.json	db_name	0	{}
34	B1 is to Find count of region_id and count of region_name of region.\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT COUNT(N1_33_region.region_id), COUNT(N1_33_region.region_name) FROM region AS N1_33_region	non-nested__1__False__False__False__False__False	/root/PRODA/data/task/evqa/QFF6IRWUUG.json	/root/PRODA/data/task/table_excerpt/QFF6IRWUUG.json	/root/PRODA/data/task/result_table/QFF6IRWUUG.json	/root/PRODA/data/task/nl_mapping/QFF6IRWUUG.json	db_name	0	{}
35	B1 is to Find count of targtype_name of targtype where ( targtype_name of targtype is not in {Airports & Aircraft, Business, Government (Diplomatic)} ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT COUNT(N1_34_targtype.targtype_name) FROM targtype AS N1_34_targtype WHERE N1_34_targtype.targtype_name NOT IN ('Airports & Aircraft','Business','Government (Diplomatic)')	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/00UE12K3I3.json	/root/PRODA/data/task/table_excerpt/00UE12K3I3.json	/root/PRODA/data/task/result_table/00UE12K3I3.json	/root/PRODA/data/task/nl_mapping/00UE12K3I3.json	db_name	0	{}
36	B1 is to Find count of weaptype_name of weaptype.\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT COUNT(N1_35_weaptype.weaptype_name) FROM weaptype AS N1_35_weaptype	non-nested__1__False__False__False__False__False	/root/PRODA/data/task/evqa/87EDHLJRPF.json	/root/PRODA/data/task/table_excerpt/87EDHLJRPF.json	/root/PRODA/data/task/result_table/87EDHLJRPF.json	/root/PRODA/data/task/nl_mapping/87EDHLJRPF.json	db_name	0	{}
48	B1 is to Find iday and kidnap_days of terror.\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_47_terror.iday, N1_47_terror.kidnap_days FROM terror AS N1_47_terror	non-nested__1__False__False__False__False__False	/root/PRODA/data/task/evqa/BUIV40P8T0.json	/root/PRODA/data/task/table_excerpt/BUIV40P8T0.json	/root/PRODA/data/task/result_table/BUIV40P8T0.json	/root/PRODA/data/task/nl_mapping/BUIV40P8T0.json	db_name	0	{}
37	B1 is to Find summary (in ascending order) of terror where ( summary of terror like '%of%' and longitude of terror not equal to -89.386694 ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_36_terror.summary FROM terror AS N1_36_terror WHERE (N1_36_terror.summary LIKE '%of%' AND N1_36_terror.longitude != -89.386694) ORDER BY N1_36_terror.summary	non-nested__1__True__False__False__True__False	/root/PRODA/data/task/evqa/GEBACCI0V4.json	/root/PRODA/data/task/table_excerpt/GEBACCI0V4.json	/root/PRODA/data/task/result_table/GEBACCI0V4.json	/root/PRODA/data/task/nl_mapping/GEBACCI0V4.json	db_name	0	{}
38	B1 is to Find count of country_name of country where ( country_name of country is in {United States, United Kingdom} ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT COUNT(N1_37_country.country_name) FROM country AS N1_37_country WHERE N1_37_country.country_name IN ('United States','United Kingdom')	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/ODLBWJFCXK.json	/root/PRODA/data/task/table_excerpt/ODLBWJFCXK.json	/root/PRODA/data/task/result_table/ODLBWJFCXK.json	/root/PRODA/data/task/nl_mapping/ODLBWJFCXK.json	db_name	0	{}
39	B1 is to Find count of iday of terror where ( targtype_name of targtype like '%ary' ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT COUNT(N1_38_terror.iday) FROM terror AS N1_38_terror JOIN targtype AS N1_38_targtype ON N1_38_terror.targtype_id=N1_38_targtype.targtype_id WHERE N1_38_targtype.targtype_name LIKE '%ary'	non-nested__2__True__False__False__False__False	/root/PRODA/data/task/evqa/3Y4JST835G.json	/root/PRODA/data/task/table_excerpt/3Y4JST835G.json	/root/PRODA/data/task/result_table/3Y4JST835G.json	/root/PRODA/data/task/nl_mapping/3Y4JST835G.json	db_name	0	{}
40	B1 is to Find targtype_id, weaptype_id, and country_id (in ascending order) of terror where ( target_name of terror like '%dqu%' and target_corporation of terror is 'Cairo Police Department' ), or where ( target_corporation of terror is 'Hotel' ),   with finding only top 3 results.\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_39_terror.targtype_id, N1_39_terror.weaptype_id, N1_39_terror.country_id FROM terror AS N1_39_terror WHERE ((N1_39_terror.target_name LIKE '%dqu%' AND N1_39_terror.target_corporation = 'Cairo Police Department') OR N1_39_terror.target_corporation = 'Hotel') ORDER BY N1_39_terror.country_id LIMIT 3	non-nested__1__True__False__False__True__True	/root/PRODA/data/task/evqa/JS7LFFMCW9.json	/root/PRODA/data/task/table_excerpt/JS7LFFMCW9.json	/root/PRODA/data/task/result_table/JS7LFFMCW9.json	/root/PRODA/data/task/nl_mapping/JS7LFFMCW9.json	db_name	0	{}
41	B1 is to Find weaptype_name (in ascending order) and weaptype_id of weaptype where ( weaptype_name of weaptype is not in {Incendiary, Explosives, Firearms} ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_40_weaptype.weaptype_name, N1_40_weaptype.weaptype_id FROM weaptype AS N1_40_weaptype WHERE N1_40_weaptype.weaptype_name NOT IN ('Incendiary','Explosives','Firearms') ORDER BY N1_40_weaptype.weaptype_name	non-nested__1__True__False__False__True__False	/root/PRODA/data/task/evqa/IRYSSPQE7L.json	/root/PRODA/data/task/table_excerpt/IRYSSPQE7L.json	/root/PRODA/data/task/result_table/IRYSSPQE7L.json	/root/PRODA/data/task/nl_mapping/IRYSSPQE7L.json	db_name	0	{}
42	B1 is to Find kidnap_days and weapsubtype_id of terror where ( target_name of terror not equal to 'R.O.T.C., University of Illinois' and iyear of terror is less than or equal to 1970 ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_41_terror.kidnap_days, N1_41_terror.weapsubtype_id FROM terror AS N1_41_terror WHERE (N1_41_terror.target_name != 'R.O.T.C., University of Illinois' AND N1_41_terror.iyear <= 1970)	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/VM55YX7ZOI.json	/root/PRODA/data/task/table_excerpt/VM55YX7ZOI.json	/root/PRODA/data/task/result_table/VM55YX7ZOI.json	/root/PRODA/data/task/nl_mapping/VM55YX7ZOI.json	db_name	0	{}
43	B1 is to Find targsubtype_id (in ascending order) of targsubtype where ( targsubtype_name of targsubtype is 'Multinational Corporation' ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_42_targsubtype.targsubtype_id FROM targsubtype AS N1_42_targsubtype WHERE N1_42_targsubtype.targsubtype_name = 'Multinational Corporation' ORDER BY N1_42_targsubtype.targsubtype_id	non-nested__1__True__False__False__True__False	/root/PRODA/data/task/evqa/239HF3OMUI.json	/root/PRODA/data/task/table_excerpt/239HF3OMUI.json	/root/PRODA/data/task/result_table/239HF3OMUI.json	/root/PRODA/data/task/nl_mapping/239HF3OMUI.json	db_name	0	{}
44	B1 is to Find region_id and region_name of region.\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_43_region.region_id, N1_43_region.region_name FROM region AS N1_43_region	non-nested__1__False__False__False__False__False	/root/PRODA/data/task/evqa/HXL0R8RUA3.json	/root/PRODA/data/task/table_excerpt/HXL0R8RUA3.json	/root/PRODA/data/task/result_table/HXL0R8RUA3.json	/root/PRODA/data/task/nl_mapping/HXL0R8RUA3.json	db_name	0	{}
45	B1 is to Find targsubtype_id, region_id, and attacktype of terror.\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_44_terror.targsubtype_id, N1_44_terror.region_id, N1_44_terror.attacktype FROM terror AS N1_44_terror	non-nested__1__False__False__False__False__False	/root/PRODA/data/task/evqa/112X70XD71.json	/root/PRODA/data/task/table_excerpt/112X70XD71.json	/root/PRODA/data/task/result_table/112X70XD71.json	/root/PRODA/data/task/nl_mapping/112X70XD71.json	db_name	0	{}
46	B1 is to Find targtype_name and targtype_id (in ascending order) of targtype where ( targtype_name of targtype not like 'Vio%' ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_45_targtype.targtype_name, N1_45_targtype.targtype_id FROM targtype AS N1_45_targtype WHERE N1_45_targtype.targtype_name NOT LIKE 'Vio%' ORDER BY N1_45_targtype.targtype_id	non-nested__1__True__False__False__True__False	/root/PRODA/data/task/evqa/3RAKUVGYB0.json	/root/PRODA/data/task/table_excerpt/3RAKUVGYB0.json	/root/PRODA/data/task/result_table/3RAKUVGYB0.json	/root/PRODA/data/task/nl_mapping/3RAKUVGYB0.json	db_name	0	{}
47	B1 is to Find region_id and region_name (in ascending order) of region where ( region_name of region is in {South America, North America} ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_46_region.region_id, N1_46_region.region_name FROM region AS N1_46_region WHERE N1_46_region.region_name IN ('South America','North America') ORDER BY N1_46_region.region_name	non-nested__1__True__False__False__True__False	/root/PRODA/data/task/evqa/G3NQ92KYOQ.json	/root/PRODA/data/task/table_excerpt/G3NQ92KYOQ.json	/root/PRODA/data/task/result_table/G3NQ92KYOQ.json	/root/PRODA/data/task/nl_mapping/G3NQ92KYOQ.json	db_name	0	{}
49	B1 is to Find weaptype_name and weaptype_id of weaptype where ( weaptype_name of weaptype like '%ves' ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_48_weaptype.weaptype_name, N1_48_weaptype.weaptype_id FROM weaptype AS N1_48_weaptype WHERE N1_48_weaptype.weaptype_name LIKE '%ves'	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/CD70LP1Q67.json	/root/PRODA/data/task/table_excerpt/CD70LP1Q67.json	/root/PRODA/data/task/result_table/CD70LP1Q67.json	/root/PRODA/data/task/nl_mapping/CD70LP1Q67.json	db_name	0	{}
50	B1 is to Find is_property_damaged and weapsubtype_id of terror where ( targsubtype_name of targsubtype not equal to 'Named Civilian' ).\nWrites out a single interrogative sentence corresponding to B1 in detail.\n	SELECT DISTINCT N1_49_terror.is_property_damaged, N1_49_terror.weapsubtype_id FROM terror AS N1_49_terror JOIN targsubtype AS N1_49_targsubtype ON N1_49_terror.targsubtype_id=N1_49_targsubtype.targsubtype_id WHERE N1_49_targsubtype.targsubtype_name != 'Named Civilian'	non-nested__2__True__False__False__False__False	/root/PRODA/data/task/evqa/5WEE5U7ONQ.json	/root/PRODA/data/task/table_excerpt/5WEE5U7ONQ.json	/root/PRODA/data/task/result_table/5WEE5U7ONQ.json	/root/PRODA/data/task/nl_mapping/5WEE5U7ONQ.json	db_name	0	{}
\.


--
-- Data for Name: task_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task_set (id, task_ids, date) FROM stdin;
1	{1}	2023-06-25 04:51:46.168115+00
2	{2}	2023-06-25 04:51:48.049844+00
3	{3}	2023-06-25 04:51:51.123451+00
4	{4}	2023-06-25 04:51:54.226546+00
5	{5}	2023-06-25 04:51:57.460699+00
6	{6}	2023-06-25 04:51:58.72072+00
7	{7}	2023-06-25 04:52:00.297119+00
8	{8}	2023-06-25 04:52:03.695282+00
9	{9}	2023-06-25 04:52:06.964775+00
10	{10}	2023-06-25 04:52:10.035787+00
11	{11}	2023-06-25 04:52:13.260548+00
12	{12}	2023-06-25 04:52:15.616101+00
13	{13}	2023-06-25 04:52:18.152081+00
14	{14}	2023-06-25 04:52:19.110436+00
15	{15,16}	2023-06-25 04:52:23.583115+00
16	{17}	2023-06-25 04:52:24.345084+00
17	{18}	2023-06-25 04:52:25.781802+00
18	{19}	2023-06-25 04:52:27.238375+00
19	{20}	2023-06-25 04:52:29.218939+00
20	{21}	2023-06-25 04:52:32.531694+00
21	{22}	2023-06-25 04:52:35.898526+00
22	{23}	2023-06-25 04:52:37.536098+00
23	{24}	2023-06-25 04:52:40.165527+00
24	{25}	2023-06-25 04:52:42.05882+00
25	{26}	2023-06-25 04:52:45.101663+00
26	{27}	2023-06-25 04:52:47.03842+00
27	{28}	2023-06-25 04:52:50.284144+00
28	{29}	2023-06-25 04:52:53.565993+00
29	{30}	2023-06-25 04:52:56.581913+00
30	{31}	2023-06-25 04:52:58.407568+00
31	{32}	2023-06-25 04:53:00.602894+00
32	{33}	2023-06-25 04:53:04.923332+00
33	{34}	2023-06-25 04:53:05.898248+00
34	{35}	2023-06-25 04:53:07.735726+00
35	{36}	2023-06-25 04:53:08.888942+00
36	{37}	2023-06-25 04:53:10.687996+00
37	{38}	2023-06-25 04:53:11.788131+00
38	{39}	2023-06-25 04:53:13.798301+00
39	{40}	2023-06-25 04:53:17.450654+00
40	{41}	2023-06-25 04:53:20.263839+00
41	{42}	2023-06-25 04:53:22.707345+00
42	{43}	2023-06-25 04:53:24.012092+00
43	{44}	2023-06-25 04:53:25.044418+00
44	{45}	2023-06-25 04:53:26.664795+00
45	{46}	2023-06-25 04:53:28.557555+00
46	{47}	2023-06-25 04:53:30.140311+00
47	{48}	2023-06-25 04:53:33.203287+00
48	{49}	2023-06-25 04:53:35.672535+00
49	{50}	2023-06-25 04:53:39.850393+00
\.


--
-- Name: collection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.collection_id_seq', 1, false);


--
-- Name: task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.task_id_seq', 50, true);


--
-- Name: task_set_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.task_set_id_seq', 49, true);


--
-- Name: collection collection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_pkey PRIMARY KEY (id);


--
-- Name: task task_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task
    ADD CONSTRAINT task_pkey PRIMARY KEY (id);


--
-- Name: task_set task_set_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_set
    ADD CONSTRAINT task_set_pkey PRIMARY KEY (id);


--
-- Name: DATABASE proda_collection; Type: ACL; Schema: -; Owner: postgres
--

GRANT CONNECT ON DATABASE proda_collection TO collection_user;


--
-- Name: TABLE collection; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.collection TO collection_user;


--
-- Name: SEQUENCE collection_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.collection_id_seq TO collection_user;


--
-- Name: TABLE task; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.task TO collection_user;


--
-- Name: SEQUENCE task_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.task_id_seq TO collection_user;


--
-- Name: TABLE task_set; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.task_set TO collection_user;


--
-- Name: SEQUENCE task_set_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.task_set_id_seq TO collection_user;


--
-- PostgreSQL database dump complete
--

