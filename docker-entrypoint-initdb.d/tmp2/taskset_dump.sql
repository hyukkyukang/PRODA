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
1	B1 is to Find targsubtype_name and targsubtype_id of targsubtype where ( targsubtype_name of targsubtype not equal to 'Police Security Forces/Officers' ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_0_targsubtype.targsubtype_name, N1_0_targsubtype.targsubtype_id FROM targsubtype AS N1_0_targsubtype WHERE N1_0_targsubtype.targsubtype_name != 'Police Security Forces/Officers'	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/2AIF0LHEJC.json	/root/PRODA/data/task/table_excerpt/2AIF0LHEJC.json	/root/PRODA/data/task/result_table/2AIF0LHEJC.json	/root/PRODA/data/task/nl_mapping/2AIF0LHEJC.json	db_name	0	{}
2	B1 is to Find avg of killed_american_num of terror. Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT AVG(N1_1_terror.killed_american_num) FROM terror AS N1_1_terror	non-nested__1__False__False__False__False__False	/root/PRODA/data/task/evqa/XXHQ0VRKO1.json	/root/PRODA/data/task/table_excerpt/XXHQ0VRKO1.json	/root/PRODA/data/task/result_table/XXHQ0VRKO1.json	/root/PRODA/data/task/nl_mapping/XXHQ0VRKO1.json	db_name	0	{}
3	B1 is to Find region_name and region_id (in ascending order) of region where ( region_name of region not equal to 'Southeast Asia' ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_2_region.region_name, N1_2_region.region_id FROM region AS N1_2_region WHERE N1_2_region.region_name != 'Southeast Asia' ORDER BY N1_2_region.region_id	non-nested__1__True__False__False__True__False	/root/PRODA/data/task/evqa/K0LOJ2BNHM.json	/root/PRODA/data/task/table_excerpt/K0LOJ2BNHM.json	/root/PRODA/data/task/result_table/K0LOJ2BNHM.json	/root/PRODA/data/task/nl_mapping/K0LOJ2BNHM.json	db_name	0	{}
4	B1 is to Find targsubtype_name and targsubtype_id of targsubtype. Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_3_targsubtype.targsubtype_name, N1_3_targsubtype.targsubtype_id FROM targsubtype AS N1_3_targsubtype	non-nested__1__False__False__False__False__False	/root/PRODA/data/task/evqa/XO8TW8M2FQ.json	/root/PRODA/data/task/table_excerpt/XO8TW8M2FQ.json	/root/PRODA/data/task/result_table/XO8TW8M2FQ.json	/root/PRODA/data/task/nl_mapping/XO8TW8M2FQ.json	db_name	0	{}
5	B1 is to Find region_name and region_id of region where ( region_name of region not equal to 'North America' ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_4_region.region_name, N1_4_region.region_id FROM region AS N1_4_region WHERE N1_4_region.region_name != 'North America'	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/WW7DDM9A9V.json	/root/PRODA/data/task/table_excerpt/WW7DDM9A9V.json	/root/PRODA/data/task/result_table/WW7DDM9A9V.json	/root/PRODA/data/task/nl_mapping/WW7DDM9A9V.json	db_name	0	{}
6	B1 is to Find all of weaptype where ( weaptype_name of weaptype is 'Incendiary' ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT * FROM weaptype AS N1_5_weaptype WHERE N1_5_weaptype.weaptype_name = 'Incendiary'	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/YC7MVH1MPJ.json	/root/PRODA/data/task/table_excerpt/YC7MVH1MPJ.json	/root/PRODA/data/task/result_table/YC7MVH1MPJ.json	/root/PRODA/data/task/nl_mapping/YC7MVH1MPJ.json	db_name	0	{}
7	B1 is to Find all of targtype where ( targtype_name of targtype is not in {Utilities, Government (General), Government (Diplomatic)} ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT * FROM targtype AS N1_6_targtype WHERE N1_6_targtype.targtype_name NOT IN ('Utilities','Government (General)','Government (Diplomatic)')	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/W7F6DY2A1Y.json	/root/PRODA/data/task/table_excerpt/W7F6DY2A1Y.json	/root/PRODA/data/task/result_table/W7F6DY2A1Y.json	/root/PRODA/data/task/nl_mapping/W7F6DY2A1Y.json	db_name	0	{}
8	B1 is to Find kidnap_hours of terror where ( property_description of terror is in {The house was slightly damaged.  16 windows were shattered., Twelve windows shattered and bomb fragments hurled into the interior of the building, Upper floor badly damaged} ), or where ( terror_criterion_2 of terror is True ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_7_terror.kidnap_hours FROM terror AS N1_7_terror WHERE (N1_7_terror.property_description IN ('The house was slightly damaged.  16 windows were shattered.','Twelve windows shattered and bomb fragments hurled into the interior of the building','Upper floor badly damaged') OR N1_7_terror.terror_criterion_2 = True)	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/3RYNDJYX2I.json	/root/PRODA/data/task/table_excerpt/3RYNDJYX2I.json	/root/PRODA/data/task/result_table/3RYNDJYX2I.json	/root/PRODA/data/task/nl_mapping/3RYNDJYX2I.json	db_name	0	{}
9	B1 is to Find hostaged_american_num of terror, region_id of region where ( hostaged_american_num of terror is greater than 0 ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_8_terror.hostaged_american_num, N1_8_region.region_id FROM terror AS N1_8_terror JOIN region AS N1_8_region ON N1_8_terror.region_id=N1_8_region.region_id WHERE N1_8_terror.hostaged_american_num > 0	non-nested__2__True__False__False__False__False	/root/PRODA/data/task/evqa/MKROC87LPP.json	/root/PRODA/data/task/table_excerpt/MKROC87LPP.json	/root/PRODA/data/task/result_table/MKROC87LPP.json	/root/PRODA/data/task/nl_mapping/MKROC87LPP.json	db_name	0	{}
10	B1 is to Find region_id and region_name of region where ( region_name of region is 'Southeast Asia' ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_9_region.region_id, N1_9_region.region_name FROM region AS N1_9_region WHERE N1_9_region.region_name = 'Southeast Asia'	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/LZJVD7GW5N.json	/root/PRODA/data/task/table_excerpt/LZJVD7GW5N.json	/root/PRODA/data/task/result_table/LZJVD7GW5N.json	/root/PRODA/data/task/nl_mapping/LZJVD7GW5N.json	db_name	0	{}
11	B1 is to Find is_suicide and property_damage_level of terror. Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_10_terror.is_suicide, N1_10_terror.property_damage_level FROM terror AS N1_10_terror	non-nested__1__False__False__False__False__False	/root/PRODA/data/task/evqa/2WCKCYXLHZ.json	/root/PRODA/data/task/table_excerpt/2WCKCYXLHZ.json	/root/PRODA/data/task/result_table/2WCKCYXLHZ.json	/root/PRODA/data/task/nl_mapping/2WCKCYXLHZ.json	db_name	0	{}
12	B1 is to Find region_id of region where ( region_name of region is 'North America' and motive of terror like '%rme%' ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_11_region.region_id FROM terror AS N1_11_terror JOIN region AS N1_11_region ON N1_11_terror.region_id=N1_11_region.region_id WHERE (N1_11_region.region_name = 'North America' AND N1_11_terror.motive LIKE '%rme%')	non-nested__2__True__False__False__False__False	/root/PRODA/data/task/evqa/X4TZ6BVNWC.json	/root/PRODA/data/task/table_excerpt/X4TZ6BVNWC.json	/root/PRODA/data/task/result_table/X4TZ6BVNWC.json	/root/PRODA/data/task/nl_mapping/X4TZ6BVNWC.json	db_name	0	{}
13	B1 is to Find count of all of terror where ( is_ransom of terror is False ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT COUNT(*) FROM terror AS N1_12_terror WHERE N1_12_terror.is_ransom = False	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/26K623CTP4.json	/root/PRODA/data/task/table_excerpt/26K623CTP4.json	/root/PRODA/data/task/result_table/26K623CTP4.json	/root/PRODA/data/task/nl_mapping/26K623CTP4.json	db_name	0	{}
14	B1 is to Find count of weapsubtype_id of weapsubtype. Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT COUNT(N1_13_weapsubtype.weapsubtype_id) FROM weapsubtype AS N1_13_weapsubtype	non-nested__1__False__False__False__False__False	/root/PRODA/data/task/evqa/XBOC5YREH9.json	/root/PRODA/data/task/table_excerpt/XBOC5YREH9.json	/root/PRODA/data/task/result_table/XBOC5YREH9.json	/root/PRODA/data/task/nl_mapping/XBOC5YREH9.json	db_name	0	{}
15	B1 is to Find dbsource and count of all of terror for each dbsource of terror where ( dbsource of terror is in {Hewitt Project, PGIS, UMD Miscellaneous} and killed_american_num of terror is greater than 0 ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_15_terror.dbsource, COUNT(*) FROM terror AS N1_15_terror WHERE (N1_15_terror.dbsource IN ('Hewitt Project','PGIS','UMD Miscellaneous') AND N1_15_terror.killed_american_num > 0) GROUP BY N1_15_terror.dbsource	non-nested__1__True__True__False__False__False	/root/PRODA/data/task/evqa/JHYAQNUA1F.json	/root/PRODA/data/task/table_excerpt/JHYAQNUA1F.json	/root/PRODA/data/task/result_table/JHYAQNUA1F.json	/root/PRODA/data/task/nl_mapping/JHYAQNUA1F.json	db_name	0	{}
16	B1 is to Find dbsource and count of all of terror for each dbsource of terror where ( dbsource of terror is in {Hewitt Project, PGIS, UMD Miscellaneous} and killed_american_num of terror is greater than 0 ). B2 is to Find dbsource of B1_results where ( count of all of B1_results is less than or equal to 85 ). Please write out a single interrogative sentence for B2 in detail without any explicit reference to B1. 	SELECT DISTINCT N1_14_terror.dbsource FROM terror AS N1_14_terror WHERE (N1_14_terror.dbsource IN ('Hewitt Project','PGIS','UMD Miscellaneous') AND N1_14_terror.killed_american_num > 0) GROUP BY N1_14_terror.dbsource HAVING COUNT(*) <= 85	non-nested__1__True__True__True__False__False	/root/PRODA/data/task/evqa/884FRL6K41.json	/root/PRODA/data/task/table_excerpt/884FRL6K41.json	/root/PRODA/data/task/result_table/884FRL6K41.json	/root/PRODA/data/task/nl_mapping/884FRL6K41.json	db_name	0	{15}
17	B1 is to Find count of region_name of region. Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT COUNT(N1_16_region.region_name) FROM region AS N1_16_region	non-nested__1__False__False__False__False__False	/root/PRODA/data/task/evqa/O6FOBA453Z.json	/root/PRODA/data/task/table_excerpt/O6FOBA453Z.json	/root/PRODA/data/task/result_table/O6FOBA453Z.json	/root/PRODA/data/task/nl_mapping/O6FOBA453Z.json	db_name	0	{}
18	B1 is to Find targtype_name and targtype_id of targtype. Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_17_targtype.targtype_name, N1_17_targtype.targtype_id FROM targtype AS N1_17_targtype	non-nested__1__False__False__False__False__False	/root/PRODA/data/task/evqa/1GUKXV7GD0.json	/root/PRODA/data/task/table_excerpt/1GUKXV7GD0.json	/root/PRODA/data/task/result_table/1GUKXV7GD0.json	/root/PRODA/data/task/nl_mapping/1GUKXV7GD0.json	db_name	0	{}
19	B1 is to Find count of region_id and count of region_name of region. Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT COUNT(N1_18_region.region_id), COUNT(N1_18_region.region_name) FROM region AS N1_18_region	non-nested__1__False__False__False__False__False	/root/PRODA/data/task/evqa/1QXISVV5PC.json	/root/PRODA/data/task/table_excerpt/1QXISVV5PC.json	/root/PRODA/data/task/result_table/1QXISVV5PC.json	/root/PRODA/data/task/nl_mapping/1QXISVV5PC.json	db_name	0	{}
20	B1 is to Find count of iday and count of is_suicide of terror where ( longitude of terror is greater than or equal to -105.265942 and longitude of terror is less than -89.176269 ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT COUNT(N1_19_terror.iday), COUNT(N1_19_terror.is_suicide) FROM terror AS N1_19_terror WHERE (N1_19_terror.longitude >= -105.265942 AND N1_19_terror.longitude < -89.176269)	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/N30HHPMXAN.json	/root/PRODA/data/task/table_excerpt/N30HHPMXAN.json	/root/PRODA/data/task/result_table/N30HHPMXAN.json	/root/PRODA/data/task/nl_mapping/N30HHPMXAN.json	db_name	0	{}
21	B1 is to Find dbsource and count of all of terror for each dbsource of terror where ( whole_wounded_num of terror is less than or equal to 0 ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_20_terror.dbsource, COUNT(*) FROM terror AS N1_20_terror WHERE N1_20_terror.whole_wounded_num <= 0 GROUP BY N1_20_terror.dbsource	non-nested__1__True__True__False__False__False	/root/PRODA/data/task/evqa/A1JFP3XFQS.json	/root/PRODA/data/task/table_excerpt/A1JFP3XFQS.json	/root/PRODA/data/task/result_table/A1JFP3XFQS.json	/root/PRODA/data/task/nl_mapping/A1JFP3XFQS.json	db_name	0	{}
22	B1 is to Find region_id and region_name (in ascending order) of region where ( region_name of region is 'North America' ),   with finding only top 1 results. Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_21_region.region_id, N1_21_region.region_name FROM region AS N1_21_region WHERE N1_21_region.region_name = 'North America' ORDER BY N1_21_region.region_name LIMIT 1	non-nested__1__True__False__False__True__True	/root/PRODA/data/task/evqa/JABA54NJF7.json	/root/PRODA/data/task/table_excerpt/JABA54NJF7.json	/root/PRODA/data/task/result_table/JABA54NJF7.json	/root/PRODA/data/task/nl_mapping/JABA54NJF7.json	db_name	0	{}
23	B1 is to Find targsubtype_id of targsubtype where ( targsubtype_name of targsubtype is in {Police Building (headquarters, station, school), Laborer (General)/Occupation Identified} ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_22_targsubtype.targsubtype_id FROM targsubtype AS N1_22_targsubtype WHERE N1_22_targsubtype.targsubtype_name IN ('Police Building (headquarters, station, school)','Laborer (General)/Occupation Identified')	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/82AL9RJAL4.json	/root/PRODA/data/task/table_excerpt/82AL9RJAL4.json	/root/PRODA/data/task/result_table/82AL9RJAL4.json	/root/PRODA/data/task/nl_mapping/82AL9RJAL4.json	db_name	0	{}
24	B1 is to Find count of weapsubtype_name of weapsubtype where ( weapsubtype_name of weapsubtype like 'Exp%' ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT COUNT(N1_23_weapsubtype.weapsubtype_name) FROM weapsubtype AS N1_23_weapsubtype WHERE N1_23_weapsubtype.weapsubtype_name LIKE 'Exp%'	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/F1W1XHD0SY.json	/root/PRODA/data/task/table_excerpt/F1W1XHD0SY.json	/root/PRODA/data/task/result_table/F1W1XHD0SY.json	/root/PRODA/data/task/nl_mapping/F1W1XHD0SY.json	db_name	0	{}
25	B1 is to Find count of weaptype_id of terror where ( claimmode of terror is 'Letter' and property_damage_level of terror is 'Minor (likely < $1 million)' ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT COUNT(N1_24_terror.weaptype_id) FROM terror AS N1_24_terror WHERE (N1_24_terror.claimmode = 'Letter' AND N1_24_terror.property_damage_level = 'Minor (likely < $1 million)')	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/DTC3HJ93Q5.json	/root/PRODA/data/task/table_excerpt/DTC3HJ93Q5.json	/root/PRODA/data/task/result_table/DTC3HJ93Q5.json	/root/PRODA/data/task/nl_mapping/DTC3HJ93Q5.json	db_name	0	{}
26	B1 is to Find targtype_id and eventid (in ascending order) of terror where ( imonth of terror is greater than or equal to 1 and imonth of terror is less than 9 ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_25_terror.targtype_id, N1_25_terror.eventid FROM terror AS N1_25_terror WHERE (N1_25_terror.imonth >= 1 AND N1_25_terror.imonth < 9) ORDER BY N1_25_terror.eventid	non-nested__1__True__False__False__True__False	/root/PRODA/data/task/evqa/JK8ODWGJ07.json	/root/PRODA/data/task/table_excerpt/JK8ODWGJ07.json	/root/PRODA/data/task/result_table/JK8ODWGJ07.json	/root/PRODA/data/task/nl_mapping/JK8ODWGJ07.json	db_name	0	{}
27	B1 is to Find iday of terror. Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_26_terror.iday FROM terror AS N1_26_terror	non-nested__1__False__False__False__False__False	/root/PRODA/data/task/evqa/DC5RR33LYW.json	/root/PRODA/data/task/table_excerpt/DC5RR33LYW.json	/root/PRODA/data/task/result_table/DC5RR33LYW.json	/root/PRODA/data/task/nl_mapping/DC5RR33LYW.json	db_name	0	{}
28	B1 is to Find avg of estimated_value_of_property_damage, count of targtype_id, and count of eventid of terror. Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT AVG(N1_27_terror.estimated_value_of_property_damage), COUNT(N1_27_terror.targtype_id), COUNT(N1_27_terror.eventid) FROM terror AS N1_27_terror	non-nested__1__False__False__False__False__False	/root/PRODA/data/task/evqa/DDADMK7SWF.json	/root/PRODA/data/task/table_excerpt/DDADMK7SWF.json	/root/PRODA/data/task/result_table/DDADMK7SWF.json	/root/PRODA/data/task/nl_mapping/DDADMK7SWF.json	db_name	0	{}
29	B1 is to Find weaptype_id of weaptype where ( terror_criterion_2 of terror is True ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_28_weaptype.weaptype_id FROM weaptype AS N1_28_weaptype JOIN terror AS N1_28_terror ON N1_28_terror.weaptype_id=N1_28_weaptype.weaptype_id WHERE N1_28_terror.terror_criterion_2 = True	non-nested__2__True__False__False__False__False	/root/PRODA/data/task/evqa/5S6JTRGALO.json	/root/PRODA/data/task/table_excerpt/5S6JTRGALO.json	/root/PRODA/data/task/result_table/5S6JTRGALO.json	/root/PRODA/data/task/nl_mapping/5S6JTRGALO.json	db_name	0	{}
30	B1 is to Find iday of terror, weapsubtype_name of weapsubtype. Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_29_terror.iday, N1_29_weapsubtype.weapsubtype_name FROM terror AS N1_29_terror JOIN weapsubtype AS N1_29_weapsubtype ON N1_29_terror.weapsubtype_id=N1_29_weapsubtype.weapsubtype_id	non-nested__2__False__False__False__False__False	/root/PRODA/data/task/evqa/4XZLKKUVKP.json	/root/PRODA/data/task/table_excerpt/4XZLKKUVKP.json	/root/PRODA/data/task/result_table/4XZLKKUVKP.json	/root/PRODA/data/task/nl_mapping/4XZLKKUVKP.json	db_name	0	{}
31	B1 is to Find all of terror where ( whole_wounded_num of terror is 0 and is_extended of terror is False ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT * FROM terror AS N1_30_terror WHERE (N1_30_terror.whole_wounded_num = 0 AND N1_30_terror.is_extended = False)	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/5VEOP2VE9W.json	/root/PRODA/data/task/table_excerpt/5VEOP2VE9W.json	/root/PRODA/data/task/result_table/5VEOP2VE9W.json	/root/PRODA/data/task/nl_mapping/5VEOP2VE9W.json	db_name	0	{}
32	B1 is to Find all of terror where ( is_terror_group_certain of terror is False ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT * FROM terror AS N1_31_terror WHERE N1_31_terror.is_terror_group_certain = False	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/OXN796D2LP.json	/root/PRODA/data/task/table_excerpt/OXN796D2LP.json	/root/PRODA/data/task/result_table/OXN796D2LP.json	/root/PRODA/data/task/nl_mapping/OXN796D2LP.json	db_name	0	{}
33	B1 is to Find region_name (in ascending order) and region_id of region. Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_32_region.region_name, N1_32_region.region_id FROM region AS N1_32_region ORDER BY N1_32_region.region_name	non-nested__1__False__False__False__True__False	/root/PRODA/data/task/evqa/M9GXINW31Q.json	/root/PRODA/data/task/table_excerpt/M9GXINW31Q.json	/root/PRODA/data/task/result_table/M9GXINW31Q.json	/root/PRODA/data/task/nl_mapping/M9GXINW31Q.json	db_name	0	{}
34	B1 is to Find count of region_id and count of region_name of region. Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT COUNT(N1_33_region.region_id), COUNT(N1_33_region.region_name) FROM region AS N1_33_region	non-nested__1__False__False__False__False__False	/root/PRODA/data/task/evqa/N99Y5SFE2B.json	/root/PRODA/data/task/table_excerpt/N99Y5SFE2B.json	/root/PRODA/data/task/result_table/N99Y5SFE2B.json	/root/PRODA/data/task/nl_mapping/N99Y5SFE2B.json	db_name	0	{}
35	B1 is to Find count of targtype_name of targtype where ( targtype_name of targtype is not in {Airports & Aircraft, Business, Government (Diplomatic)} ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT COUNT(N1_34_targtype.targtype_name) FROM targtype AS N1_34_targtype WHERE N1_34_targtype.targtype_name NOT IN ('Airports & Aircraft','Business','Government (Diplomatic)')	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/0YCCQU4CQ5.json	/root/PRODA/data/task/table_excerpt/0YCCQU4CQ5.json	/root/PRODA/data/task/result_table/0YCCQU4CQ5.json	/root/PRODA/data/task/nl_mapping/0YCCQU4CQ5.json	db_name	0	{}
36	B1 is to Find count of weaptype_name of weaptype. Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT COUNT(N1_35_weaptype.weaptype_name) FROM weaptype AS N1_35_weaptype	non-nested__1__False__False__False__False__False	/root/PRODA/data/task/evqa/QU51DOGWDF.json	/root/PRODA/data/task/table_excerpt/QU51DOGWDF.json	/root/PRODA/data/task/result_table/QU51DOGWDF.json	/root/PRODA/data/task/nl_mapping/QU51DOGWDF.json	db_name	0	{}
48	B1 is to Find iday and kidnap_days of terror. Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_47_terror.iday, N1_47_terror.kidnap_days FROM terror AS N1_47_terror	non-nested__1__False__False__False__False__False	/root/PRODA/data/task/evqa/GGW3XVYC6T.json	/root/PRODA/data/task/table_excerpt/GGW3XVYC6T.json	/root/PRODA/data/task/result_table/GGW3XVYC6T.json	/root/PRODA/data/task/nl_mapping/GGW3XVYC6T.json	db_name	0	{}
37	B1 is to Find summary (in ascending order) of terror where ( summary of terror like '%of%' and longitude of terror not equal to -89.386694 ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_36_terror.summary FROM terror AS N1_36_terror WHERE (N1_36_terror.summary LIKE '%of%' AND N1_36_terror.longitude != -89.386694) ORDER BY N1_36_terror.summary	non-nested__1__True__False__False__True__False	/root/PRODA/data/task/evqa/XOUZG57ZLB.json	/root/PRODA/data/task/table_excerpt/XOUZG57ZLB.json	/root/PRODA/data/task/result_table/XOUZG57ZLB.json	/root/PRODA/data/task/nl_mapping/XOUZG57ZLB.json	db_name	0	{}
38	B1 is to Find count of country_name of country where ( country_name of country is in {United States, United Kingdom} ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT COUNT(N1_37_country.country_name) FROM country AS N1_37_country WHERE N1_37_country.country_name IN ('United States','United Kingdom')	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/1CUWCKOD02.json	/root/PRODA/data/task/table_excerpt/1CUWCKOD02.json	/root/PRODA/data/task/result_table/1CUWCKOD02.json	/root/PRODA/data/task/nl_mapping/1CUWCKOD02.json	db_name	0	{}
39	B1 is to Find count of iday of terror where ( targtype_name of targtype like '%ary' ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT COUNT(N1_38_terror.iday) FROM terror AS N1_38_terror JOIN targtype AS N1_38_targtype ON N1_38_terror.targtype_id=N1_38_targtype.targtype_id WHERE N1_38_targtype.targtype_name LIKE '%ary'	non-nested__2__True__False__False__False__False	/root/PRODA/data/task/evqa/WDYWHYT5RK.json	/root/PRODA/data/task/table_excerpt/WDYWHYT5RK.json	/root/PRODA/data/task/result_table/WDYWHYT5RK.json	/root/PRODA/data/task/nl_mapping/WDYWHYT5RK.json	db_name	0	{}
40	B1 is to Find targtype_id, weaptype_id, and country_id (in ascending order) of terror where ( target_name of terror like '%dqu%' and target_corporation of terror is 'Cairo Police Department' ), or where ( target_corporation of terror is 'Hotel' ),   with finding only top 3 results. Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_39_terror.targtype_id, N1_39_terror.weaptype_id, N1_39_terror.country_id FROM terror AS N1_39_terror WHERE ((N1_39_terror.target_name LIKE '%dqu%' AND N1_39_terror.target_corporation = 'Cairo Police Department') OR N1_39_terror.target_corporation = 'Hotel') ORDER BY N1_39_terror.country_id LIMIT 3	non-nested__1__True__False__False__True__True	/root/PRODA/data/task/evqa/K1WYBSOTLA.json	/root/PRODA/data/task/table_excerpt/K1WYBSOTLA.json	/root/PRODA/data/task/result_table/K1WYBSOTLA.json	/root/PRODA/data/task/nl_mapping/K1WYBSOTLA.json	db_name	0	{}
41	B1 is to Find weaptype_name (in ascending order) and weaptype_id of weaptype where ( weaptype_name of weaptype is not in {Incendiary, Explosives, Firearms} ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_40_weaptype.weaptype_name, N1_40_weaptype.weaptype_id FROM weaptype AS N1_40_weaptype WHERE N1_40_weaptype.weaptype_name NOT IN ('Incendiary','Explosives','Firearms') ORDER BY N1_40_weaptype.weaptype_name	non-nested__1__True__False__False__True__False	/root/PRODA/data/task/evqa/PSGVC301BR.json	/root/PRODA/data/task/table_excerpt/PSGVC301BR.json	/root/PRODA/data/task/result_table/PSGVC301BR.json	/root/PRODA/data/task/nl_mapping/PSGVC301BR.json	db_name	0	{}
42	B1 is to Find kidnap_days and weapsubtype_id of terror where ( target_name of terror not equal to 'R.O.T.C., University of Illinois' and iyear of terror is less than or equal to 1970 ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_41_terror.kidnap_days, N1_41_terror.weapsubtype_id FROM terror AS N1_41_terror WHERE (N1_41_terror.target_name != 'R.O.T.C., University of Illinois' AND N1_41_terror.iyear <= 1970)	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/FTCUEQG3A0.json	/root/PRODA/data/task/table_excerpt/FTCUEQG3A0.json	/root/PRODA/data/task/result_table/FTCUEQG3A0.json	/root/PRODA/data/task/nl_mapping/FTCUEQG3A0.json	db_name	0	{}
43	B1 is to Find targsubtype_id (in ascending order) of targsubtype where ( targsubtype_name of targsubtype is 'Multinational Corporation' ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_42_targsubtype.targsubtype_id FROM targsubtype AS N1_42_targsubtype WHERE N1_42_targsubtype.targsubtype_name = 'Multinational Corporation' ORDER BY N1_42_targsubtype.targsubtype_id	non-nested__1__True__False__False__True__False	/root/PRODA/data/task/evqa/C56FV9PDYR.json	/root/PRODA/data/task/table_excerpt/C56FV9PDYR.json	/root/PRODA/data/task/result_table/C56FV9PDYR.json	/root/PRODA/data/task/nl_mapping/C56FV9PDYR.json	db_name	0	{}
44	B1 is to Find region_id and region_name of region. Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_43_region.region_id, N1_43_region.region_name FROM region AS N1_43_region	non-nested__1__False__False__False__False__False	/root/PRODA/data/task/evqa/P87TIKQ810.json	/root/PRODA/data/task/table_excerpt/P87TIKQ810.json	/root/PRODA/data/task/result_table/P87TIKQ810.json	/root/PRODA/data/task/nl_mapping/P87TIKQ810.json	db_name	0	{}
45	B1 is to Find targsubtype_id, region_id, and attacktype of terror. Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_44_terror.targsubtype_id, N1_44_terror.region_id, N1_44_terror.attacktype FROM terror AS N1_44_terror	non-nested__1__False__False__False__False__False	/root/PRODA/data/task/evqa/7UD0HCRFLB.json	/root/PRODA/data/task/table_excerpt/7UD0HCRFLB.json	/root/PRODA/data/task/result_table/7UD0HCRFLB.json	/root/PRODA/data/task/nl_mapping/7UD0HCRFLB.json	db_name	0	{}
46	B1 is to Find targtype_name and targtype_id (in ascending order) of targtype where ( targtype_name of targtype not like 'Vio%' ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_45_targtype.targtype_name, N1_45_targtype.targtype_id FROM targtype AS N1_45_targtype WHERE N1_45_targtype.targtype_name NOT LIKE 'Vio%' ORDER BY N1_45_targtype.targtype_id	non-nested__1__True__False__False__True__False	/root/PRODA/data/task/evqa/BQLTT1PDR7.json	/root/PRODA/data/task/table_excerpt/BQLTT1PDR7.json	/root/PRODA/data/task/result_table/BQLTT1PDR7.json	/root/PRODA/data/task/nl_mapping/BQLTT1PDR7.json	db_name	0	{}
47	B1 is to Find region_id and region_name (in ascending order) of region where ( region_name of region is in {South America, North America} ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_46_region.region_id, N1_46_region.region_name FROM region AS N1_46_region WHERE N1_46_region.region_name IN ('South America','North America') ORDER BY N1_46_region.region_name	non-nested__1__True__False__False__True__False	/root/PRODA/data/task/evqa/1FAD1XM9NI.json	/root/PRODA/data/task/table_excerpt/1FAD1XM9NI.json	/root/PRODA/data/task/result_table/1FAD1XM9NI.json	/root/PRODA/data/task/nl_mapping/1FAD1XM9NI.json	db_name	0	{}
49	B1 is to Find weaptype_name and weaptype_id of weaptype where ( weaptype_name of weaptype like '%ves' ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_48_weaptype.weaptype_name, N1_48_weaptype.weaptype_id FROM weaptype AS N1_48_weaptype WHERE N1_48_weaptype.weaptype_name LIKE '%ves'	non-nested__1__True__False__False__False__False	/root/PRODA/data/task/evqa/TYLHQ04BEK.json	/root/PRODA/data/task/table_excerpt/TYLHQ04BEK.json	/root/PRODA/data/task/result_table/TYLHQ04BEK.json	/root/PRODA/data/task/nl_mapping/TYLHQ04BEK.json	db_name	0	{}
50	B1 is to Find is_property_damaged and weapsubtype_id of terror where ( targsubtype_name of targsubtype not equal to 'Named Civilian' ). Writes out a single interrogative sentence corresponding to B1 in detail. 	SELECT DISTINCT N1_49_terror.is_property_damaged, N1_49_terror.weapsubtype_id FROM terror AS N1_49_terror JOIN targsubtype AS N1_49_targsubtype ON N1_49_terror.targsubtype_id=N1_49_targsubtype.targsubtype_id WHERE N1_49_targsubtype.targsubtype_name != 'Named Civilian'	non-nested__2__True__False__False__False__False	/root/PRODA/data/task/evqa/96987F22SQ.json	/root/PRODA/data/task/table_excerpt/96987F22SQ.json	/root/PRODA/data/task/result_table/96987F22SQ.json	/root/PRODA/data/task/nl_mapping/96987F22SQ.json	db_name	0	{}
\.


--
-- Data for Name: task_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task_set (id, task_ids, date) FROM stdin;
1	{1}	2023-06-25 03:37:42.519438+00
2	{2}	2023-06-25 03:37:43.277151+00
3	{3}	2023-06-25 03:37:43.432485+00
4	{4}	2023-06-25 03:37:43.555198+00
5	{5}	2023-06-25 03:37:43.720762+00
6	{6}	2023-06-25 03:37:43.864506+00
7	{7}	2023-06-25 03:37:44.00787+00
8	{8}	2023-06-25 03:37:44.781315+00
9	{9}	2023-06-25 03:37:44.9695+00
10	{10}	2023-06-25 03:37:45.112678+00
11	{11}	2023-06-25 03:37:45.788822+00
12	{12}	2023-06-25 03:37:45.974843+00
13	{13}	2023-06-25 03:37:46.694136+00
14	{14}	2023-06-25 03:37:46.816931+00
15	{15,16}	2023-06-25 03:37:47.131149+00
16	{17}	2023-06-25 03:37:47.252456+00
17	{18}	2023-06-25 03:37:47.374932+00
18	{19}	2023-06-25 03:37:47.492942+00
19	{20}	2023-06-25 03:37:47.702073+00
20	{21}	2023-06-25 03:37:48.095205+00
21	{22}	2023-06-25 03:37:48.251213+00
22	{23}	2023-06-25 03:37:48.405895+00
23	{24}	2023-06-25 03:37:48.539023+00
24	{25}	2023-06-25 03:37:48.737293+00
25	{26}	2023-06-25 03:37:49.304028+00
26	{27}	2023-06-25 03:37:49.968886+00
27	{28}	2023-06-25 03:37:50.72025+00
28	{29}	2023-06-25 03:37:51.320473+00
29	{30}	2023-06-25 03:37:51.952641+00
30	{31}	2023-06-25 03:37:52.411604+00
31	{32}	2023-06-25 03:37:53.094541+00
32	{33}	2023-06-25 03:37:53.227157+00
33	{34}	2023-06-25 03:37:53.349327+00
34	{35}	2023-06-25 03:37:53.493102+00
35	{36}	2023-06-25 03:37:53.614982+00
36	{37}	2023-06-25 03:37:54.160544+00
37	{38}	2023-06-25 03:37:54.316038+00
38	{39}	2023-06-25 03:37:54.557661+00
39	{40}	2023-06-25 03:37:54.799139+00
40	{41}	2023-06-25 03:37:54.942868+00
41	{42}	2023-06-25 03:37:55.129914+00
42	{43}	2023-06-25 03:37:55.284193+00
43	{44}	2023-06-25 03:37:55.406465+00
44	{45}	2023-06-25 03:37:56.174448+00
45	{46}	2023-06-25 03:37:56.345871+00
46	{47}	2023-06-25 03:37:56.511524+00
47	{48}	2023-06-25 03:37:57.230133+00
48	{49}	2023-06-25 03:37:57.373611+00
49	{50}	2023-06-25 03:37:58.085591+00
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
