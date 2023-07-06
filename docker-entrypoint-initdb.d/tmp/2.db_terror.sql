DROP DATABASE IF EXISTS terror;
CREATE DATABASE terror;
\c terror;

-- Table: public.country

-- DROP TABLE IF EXISTS public.country;

CREATE TABLE IF NOT EXISTS public.country
(
    country_id integer NOT NULL,
    country_name text COLLATE pg_catalog."default",
    CONSTRAINT country_pkey PRIMARY KEY (country_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.country
    OWNER to postgres;
-- Index: country_index_1

-- DROP INDEX IF EXISTS public.country_index_1;

CREATE INDEX IF NOT EXISTS country_index_1
    ON public.country USING btree
    (country_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.region

-- DROP TABLE IF EXISTS public.region;

CREATE TABLE IF NOT EXISTS public.region
(
    region_id integer NOT NULL,
    region_name text COLLATE pg_catalog."default",
    CONSTRAINT region_pkey PRIMARY KEY (region_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.region
    OWNER to postgres;
-- Index: region_index_1

-- DROP INDEX IF EXISTS public.region_index_1;

CREATE INDEX IF NOT EXISTS region_index_1
    ON public.region USING btree
    (region_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.targsubtype

-- DROP TABLE IF EXISTS public.targsubtype;

CREATE TABLE IF NOT EXISTS public.targsubtype
(
    targsubtype_id integer NOT NULL,
    targsubtype_name text COLLATE pg_catalog."default",
    CONSTRAINT targsubtype_pkey PRIMARY KEY (targsubtype_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.targsubtype
    OWNER to postgres;
-- Index: targsubtype_index_1

-- DROP INDEX IF EXISTS public.targsubtype_index_1;

CREATE INDEX IF NOT EXISTS targsubtype_index_1
    ON public.targsubtype USING btree
    (targsubtype_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.targtype

-- DROP TABLE IF EXISTS public.targtype;

CREATE TABLE IF NOT EXISTS public.targtype
(
    targtype_id integer NOT NULL,
    targtype_name text COLLATE pg_catalog."default",
    CONSTRAINT targtype_pkey PRIMARY KEY (targtype_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.targtype
    OWNER to postgres;
-- Index: targtype_index_1

-- DROP INDEX IF EXISTS public.targtype_index_1;

CREATE INDEX IF NOT EXISTS targtype_index_1
    ON public.targtype USING btree
    (targtype_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.weapsubtype

-- DROP TABLE IF EXISTS public.weapsubtype;

CREATE TABLE IF NOT EXISTS public.weapsubtype
(
    weapsubtype_id integer NOT NULL,
    weapsubtype_name text COLLATE pg_catalog."default",
    CONSTRAINT weapsubtype_pkey PRIMARY KEY (weapsubtype_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.weapsubtype
    OWNER to postgres;
-- Index: weapsubtype_index_1

-- DROP INDEX IF EXISTS public.weapsubtype_index_1;

CREATE INDEX IF NOT EXISTS weapsubtype_index_1
    ON public.weapsubtype USING btree
    (weapsubtype_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.weaptype

-- DROP TABLE IF EXISTS public.weaptype;

CREATE TABLE IF NOT EXISTS public.weaptype
(
    weaptype_id integer NOT NULL,
    weaptype_name text COLLATE pg_catalog."default",
    CONSTRAINT weaptype_pkey PRIMARY KEY (weaptype_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.weaptype
    OWNER to postgres;
-- Index: weaptype_index_1

-- DROP INDEX IF EXISTS public.weaptype_index_1;

CREATE INDEX IF NOT EXISTS weaptype_index_1
    ON public.weaptype USING btree
    (weaptype_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.terror_info

-- DROP TABLE IF EXISTS public.terror_info;

CREATE TABLE IF NOT EXISTS public.terror_info
(
    event_id bigint NOT NULL,
    year integer,
    month integer,
    day integer,
    approxdate character varying(50) COLLATE pg_catalog."default",
    is_period_extended boolean,
    country_id integer,
    region_id integer,
    provstate character varying(50) COLLATE pg_catalog."default",
    city character varying(70) COLLATE pg_catalog."default",
    latitude double precision,
    longitude double precision,
    location_detail character varying(500) COLLATE pg_catalog."default",
    summary text COLLATE pg_catalog."default",
    is_success boolean,
    is_suicide boolean,
    attacktype character varying(40) COLLATE pg_catalog."default",
    targtype_id integer,
    targsubtype_id integer,
    target_corporation character varying(200) COLLATE pg_catalog."default",
    target_name character varying(400) COLLATE pg_catalog."default",
    target_nationality character varying(40) COLLATE pg_catalog."default",
    terror_group_name character varying(120) COLLATE pg_catalog."default",
    motive text COLLATE pg_catalog."default",
    weaptype_id integer,
    weapsubtype_id integer,
    whole_killed_num integer,
    killed_american_num integer,
    killed_terrorist_num integer,
    whole_wounded_num integer,
    wounded_american_num integer,
    wounded_terrorist_num integer,
    is_property_damaged boolean,
    property_damage_level character varying(50) COLLATE pg_catalog."default",
    estimated_value_of_property_damage bigint,
    property_description text COLLATE pg_catalog."default",
    is_hostage_kidnap boolean,
    hostage_num integer,
    hostaged_american_num integer,
    kidnap_hours integer,
    kidnap_days integer,
    released_hostage_num integer,
    CONSTRAINT terror_info_pkey PRIMARY KEY (event_id),
    CONSTRAINT terror_info_country_id_fkey FOREIGN KEY (country_id)
        REFERENCES public.country (country_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT terror_info_region_id_fkey FOREIGN KEY (region_id)
        REFERENCES public.region (region_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT terror_info_targsubtype_id_fkey FOREIGN KEY (targsubtype_id)
        REFERENCES public.targsubtype (targsubtype_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT terror_info_targtype_id_fkey FOREIGN KEY (targtype_id)
        REFERENCES public.targtype (targtype_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT terror_info_weapsubtype_id_fkey FOREIGN KEY (weapsubtype_id)
        REFERENCES public.weapsubtype (weapsubtype_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT terror_info_weaptype_id_fkey FOREIGN KEY (weaptype_id)
        REFERENCES public.weaptype (weaptype_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.terror_info
    OWNER to postgres;
-- Index: terror_info_0

-- DROP INDEX IF EXISTS public.terror_info_0;

CREATE INDEX IF NOT EXISTS terror_info_0
    ON public.terror_info USING hash
    (country_id)
    TABLESPACE pg_default;
-- Index: terror_info_1

-- DROP INDEX IF EXISTS public.terror_info_1;

CREATE INDEX IF NOT EXISTS terror_info_1
    ON public.terror_info USING hash
    (region_id)
    TABLESPACE pg_default;
-- Index: terror_info_10

-- DROP INDEX IF EXISTS public.terror_info_10;

-- Index: terror_info_12

-- DROP INDEX IF EXISTS public.terror_info_12;

CREATE INDEX IF NOT EXISTS terror_info_12
    ON public.terror_info USING btree
    (provstate COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_13

-- DROP INDEX IF EXISTS public.terror_info_13;

CREATE INDEX IF NOT EXISTS terror_info_13
    ON public.terror_info USING btree
    (city COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_14

-- DROP INDEX IF EXISTS public.terror_info_14;

CREATE INDEX IF NOT EXISTS terror_info_14
    ON public.terror_info USING btree
    (latitude ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_15

-- DROP INDEX IF EXISTS public.terror_info_15;

CREATE INDEX IF NOT EXISTS terror_info_15
    ON public.terror_info USING btree
    (longitude ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_16

-- DROP INDEX IF EXISTS public.terror_info_16;

CREATE INDEX IF NOT EXISTS terror_info_16
    ON public.terror_info USING btree
    (location_detail COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_17

-- DROP INDEX IF EXISTS public.terror_info_17;

CREATE INDEX IF NOT EXISTS terror_info_17
    ON public.terror_info USING btree
    (summary COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_19

-- DROP INDEX IF EXISTS public.terror_info_19;

CREATE INDEX IF NOT EXISTS terror_info_19
    ON public.terror_info USING btree
    (attacktype COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_1_0

-- DROP INDEX IF EXISTS public.terror_info_1_0;

CREATE INDEX IF NOT EXISTS terror_info_1_0
    ON public.terror_info USING btree
    (country_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_1_1

-- DROP INDEX IF EXISTS public.terror_info_1_1;

CREATE INDEX IF NOT EXISTS terror_info_1_1
    ON public.terror_info USING btree
    (region_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_1_10

-- DROP INDEX IF EXISTS public.terror_info_1_10;
-- Index: terror_info_1_12

-- DROP INDEX IF EXISTS public.terror_info_1_12;

CREATE INDEX IF NOT EXISTS terror_info_1_12
    ON public.terror_info USING hash
    (provstate COLLATE pg_catalog."default")
    TABLESPACE pg_default;
-- Index: terror_info_1_13

-- DROP INDEX IF EXISTS public.terror_info_1_13;

CREATE INDEX IF NOT EXISTS terror_info_1_13
    ON public.terror_info USING hash
    (city COLLATE pg_catalog."default")
    TABLESPACE pg_default;
-- Index: terror_info_1_14

-- DROP INDEX IF EXISTS public.terror_info_1_14;

CREATE INDEX IF NOT EXISTS terror_info_1_14
    ON public.terror_info USING hash
    (latitude)
    TABLESPACE pg_default;
-- Index: terror_info_1_15

-- DROP INDEX IF EXISTS public.terror_info_1_15;

CREATE INDEX IF NOT EXISTS terror_info_1_15
    ON public.terror_info USING hash
    (longitude)
    TABLESPACE pg_default;
-- Index: terror_info_1_16

-- DROP INDEX IF EXISTS public.terror_info_1_16;

CREATE INDEX IF NOT EXISTS terror_info_1_16
    ON public.terror_info USING hash
    (location_detail COLLATE pg_catalog."default")
    TABLESPACE pg_default;
-- Index: terror_info_1_17

-- DROP INDEX IF EXISTS public.terror_info_1_17;

CREATE INDEX IF NOT EXISTS terror_info_1_17
    ON public.terror_info USING hash
    (summary COLLATE pg_catalog."default")
    TABLESPACE pg_default;
-- Index: terror_info_1_19

-- DROP INDEX IF EXISTS public.terror_info_1_19;

CREATE INDEX IF NOT EXISTS terror_info_1_19
    ON public.terror_info USING hash
    (attacktype COLLATE pg_catalog."default")
    TABLESPACE pg_default;
-- Index: terror_info_1_2

-- DROP INDEX IF EXISTS public.terror_info_1_2;

CREATE INDEX IF NOT EXISTS terror_info_1_2
    ON public.terror_info USING btree
    (targsubtype_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_1_20

-- DROP INDEX IF EXISTS public.terror_info_1_20;

CREATE INDEX IF NOT EXISTS terror_info_1_20
    ON public.terror_info USING hash
    (target_corporation COLLATE pg_catalog."default")
    TABLESPACE pg_default;
-- Index: terror_info_1_21

-- DROP INDEX IF EXISTS public.terror_info_1_21;

CREATE INDEX IF NOT EXISTS terror_info_1_21
    ON public.terror_info USING hash
    (target_name COLLATE pg_catalog."default")
    TABLESPACE pg_default;
-- Index: terror_info_1_22

-- DROP INDEX IF EXISTS public.terror_info_1_22;

CREATE INDEX IF NOT EXISTS terror_info_1_22
    ON public.terror_info USING hash
    (target_nationality COLLATE pg_catalog."default")
    TABLESPACE pg_default;
-- Index: terror_info_1_23

-- DROP INDEX IF EXISTS public.terror_info_1_23;

CREATE INDEX IF NOT EXISTS terror_info_1_23
    ON public.terror_info USING hash
    (terror_group_name COLLATE pg_catalog."default")
    TABLESPACE pg_default;
-- Index: terror_info_1_24

-- DROP INDEX IF EXISTS public.terror_info_1_24;

CREATE INDEX IF NOT EXISTS terror_info_1_24
    ON public.terror_info USING hash
    (motive COLLATE pg_catalog."default")
    TABLESPACE pg_default;
-- Index: terror_info_1_26

-- DROP INDEX IF EXISTS public.terror_info_1_26;

CREATE INDEX IF NOT EXISTS terror_info_1_26
    ON public.terror_info USING hash
    (whole_killed_num)
    TABLESPACE pg_default;
-- Index: terror_info_1_27

-- DROP INDEX IF EXISTS public.terror_info_1_27;

CREATE INDEX IF NOT EXISTS terror_info_1_27
    ON public.terror_info USING hash
    (killed_american_num)
    TABLESPACE pg_default;
-- Index: terror_info_1_28

-- DROP INDEX IF EXISTS public.terror_info_1_28;

CREATE INDEX IF NOT EXISTS terror_info_1_28
    ON public.terror_info USING hash
    (killed_terrorist_num)
    TABLESPACE pg_default;
-- Index: terror_info_1_29

-- DROP INDEX IF EXISTS public.terror_info_1_29;

CREATE INDEX IF NOT EXISTS terror_info_1_29
    ON public.terror_info USING hash
    (whole_wounded_num)
    TABLESPACE pg_default;
-- Index: terror_info_1_3

-- DROP INDEX IF EXISTS public.terror_info_1_3;

CREATE INDEX IF NOT EXISTS terror_info_1_3
    ON public.terror_info USING btree
    (targtype_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_1_30

-- DROP INDEX IF EXISTS public.terror_info_1_30;

CREATE INDEX IF NOT EXISTS terror_info_1_30
    ON public.terror_info USING hash
    (wounded_american_num)
    TABLESPACE pg_default;
-- Index: terror_info_1_31

-- DROP INDEX IF EXISTS public.terror_info_1_31;

CREATE INDEX IF NOT EXISTS terror_info_1_31
    ON public.terror_info USING hash
    (wounded_terrorist_num)
    TABLESPACE pg_default;
-- Index: terror_info_1_32

-- DROP INDEX IF EXISTS public.terror_info_1_32;

CREATE INDEX IF NOT EXISTS terror_info_1_32
    ON public.terror_info USING hash
    (property_damage_level COLLATE pg_catalog."default")
    TABLESPACE pg_default;
-- Index: terror_info_1_33

-- DROP INDEX IF EXISTS public.terror_info_1_33;

CREATE INDEX IF NOT EXISTS terror_info_1_33
    ON public.terror_info USING hash
    (estimated_value_of_property_damage)
    TABLESPACE pg_default;
-- Index: terror_info_1_34

-- DROP INDEX IF EXISTS public.terror_info_1_34;

CREATE INDEX IF NOT EXISTS terror_info_1_34
    ON public.terror_info USING hash
    (property_description COLLATE pg_catalog."default")
    TABLESPACE pg_default;
-- Index: terror_info_1_35

-- DROP INDEX IF EXISTS public.terror_info_1_35;

CREATE INDEX IF NOT EXISTS terror_info_1_35
    ON public.terror_info USING hash
    (hostage_num)
    TABLESPACE pg_default;
-- Index: terror_info_1_36

-- DROP INDEX IF EXISTS public.terror_info_1_36;

CREATE INDEX IF NOT EXISTS terror_info_1_36
    ON public.terror_info USING hash
    (hostaged_american_num)
    TABLESPACE pg_default;
-- Index: terror_info_1_37

-- DROP INDEX IF EXISTS public.terror_info_1_37;

CREATE INDEX IF NOT EXISTS terror_info_1_37
    ON public.terror_info USING hash
    (kidnap_hours)
    TABLESPACE pg_default;
-- Index: terror_info_1_38

-- DROP INDEX IF EXISTS public.terror_info_1_38;

CREATE INDEX IF NOT EXISTS terror_info_1_38
    ON public.terror_info USING hash
    (kidnap_days)
    TABLESPACE pg_default;
-- Index: terror_info_1_39

-- DROP INDEX IF EXISTS public.terror_info_1_39;

CREATE INDEX IF NOT EXISTS terror_info_1_39
    ON public.terror_info USING hash
    (released_hostage_num)
    TABLESPACE pg_default;
-- Index: terror_info_1_4

-- DROP INDEX IF EXISTS public.terror_info_1_4;

CREATE INDEX IF NOT EXISTS terror_info_1_4
    ON public.terror_info USING btree
    (targsubtype_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_1_5

-- DROP INDEX IF EXISTS public.terror_info_1_5;

CREATE INDEX IF NOT EXISTS terror_info_1_5
    ON public.terror_info USING btree
    (weapsubtype_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_1_6

-- DROP INDEX IF EXISTS public.terror_info_1_6;

CREATE INDEX IF NOT EXISTS terror_info_1_6
    ON public.terror_info USING btree
    (weaptype_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_1_7

-- DROP INDEX IF EXISTS public.terror_info_1_7;

CREATE INDEX IF NOT EXISTS terror_info_1_7
    ON public.terror_info USING hash
    (year)
    TABLESPACE pg_default;
-- Index: terror_info_1_8

-- DROP INDEX IF EXISTS public.terror_info_1_8;

CREATE INDEX IF NOT EXISTS terror_info_1_8
    ON public.terror_info USING hash
    (month)
    TABLESPACE pg_default;
-- Index: terror_info_1_9

-- DROP INDEX IF EXISTS public.terror_info_1_9;

CREATE INDEX IF NOT EXISTS terror_info_1_9
    ON public.terror_info USING hash
    (day)
    TABLESPACE pg_default;
-- Index: terror_info_2

-- DROP INDEX IF EXISTS public.terror_info_2;

CREATE INDEX IF NOT EXISTS terror_info_2
    ON public.terror_info USING hash
    (targsubtype_id)
    TABLESPACE pg_default;
-- Index: terror_info_20

-- DROP INDEX IF EXISTS public.terror_info_20;

CREATE INDEX IF NOT EXISTS terror_info_20
    ON public.terror_info USING btree
    (target_corporation COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_21

-- DROP INDEX IF EXISTS public.terror_info_21;

CREATE INDEX IF NOT EXISTS terror_info_21
    ON public.terror_info USING btree
    (target_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_22

-- DROP INDEX IF EXISTS public.terror_info_22;

CREATE INDEX IF NOT EXISTS terror_info_22
    ON public.terror_info USING btree
    (target_nationality COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_23

-- DROP INDEX IF EXISTS public.terror_info_23;

CREATE INDEX IF NOT EXISTS terror_info_23
    ON public.terror_info USING btree
    (terror_group_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_24

-- DROP INDEX IF EXISTS public.terror_info_24;

CREATE INDEX IF NOT EXISTS terror_info_24
    ON public.terror_info USING btree
    (motive COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_26

-- DROP INDEX IF EXISTS public.terror_info_26;

CREATE INDEX IF NOT EXISTS terror_info_26
    ON public.terror_info USING btree
    (whole_killed_num ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_27

-- DROP INDEX IF EXISTS public.terror_info_27;

CREATE INDEX IF NOT EXISTS terror_info_27
    ON public.terror_info USING btree
    (killed_american_num ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_28

-- DROP INDEX IF EXISTS public.terror_info_28;

CREATE INDEX IF NOT EXISTS terror_info_28
    ON public.terror_info USING btree
    (killed_terrorist_num ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_29

-- DROP INDEX IF EXISTS public.terror_info_29;

CREATE INDEX IF NOT EXISTS terror_info_29
    ON public.terror_info USING btree
    (whole_wounded_num ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_3

-- DROP INDEX IF EXISTS public.terror_info_3;

CREATE INDEX IF NOT EXISTS terror_info_3
    ON public.terror_info USING hash
    (targtype_id)
    TABLESPACE pg_default;
-- Index: terror_info_30

-- DROP INDEX IF EXISTS public.terror_info_30;

CREATE INDEX IF NOT EXISTS terror_info_30
    ON public.terror_info USING btree
    (wounded_american_num ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_31

-- DROP INDEX IF EXISTS public.terror_info_31;

CREATE INDEX IF NOT EXISTS terror_info_31
    ON public.terror_info USING btree
    (wounded_terrorist_num ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_32

-- DROP INDEX IF EXISTS public.terror_info_32;

CREATE INDEX IF NOT EXISTS terror_info_32
    ON public.terror_info USING btree
    (property_damage_level COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_33

-- DROP INDEX IF EXISTS public.terror_info_33;

CREATE INDEX IF NOT EXISTS terror_info_33
    ON public.terror_info USING btree
    (estimated_value_of_property_damage ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_34

-- DROP INDEX IF EXISTS public.terror_info_34;

CREATE INDEX IF NOT EXISTS terror_info_34
    ON public.terror_info USING btree
    (property_description COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_35

-- DROP INDEX IF EXISTS public.terror_info_35;

CREATE INDEX IF NOT EXISTS terror_info_35
    ON public.terror_info USING btree
    (hostage_num ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_36

-- DROP INDEX IF EXISTS public.terror_info_36;

CREATE INDEX IF NOT EXISTS terror_info_36
    ON public.terror_info USING btree
    (hostaged_american_num ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_37

-- DROP INDEX IF EXISTS public.terror_info_37;

CREATE INDEX IF NOT EXISTS terror_info_37
    ON public.terror_info USING btree
    (kidnap_hours ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_38

-- DROP INDEX IF EXISTS public.terror_info_38;

CREATE INDEX IF NOT EXISTS terror_info_38
    ON public.terror_info USING btree
    (kidnap_days ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_39

-- DROP INDEX IF EXISTS public.terror_info_39;

CREATE INDEX IF NOT EXISTS terror_info_39
    ON public.terror_info USING btree
    (released_hostage_num ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_4

-- DROP INDEX IF EXISTS public.terror_info_4;

CREATE INDEX IF NOT EXISTS terror_info_4
    ON public.terror_info USING hash
    (targsubtype_id)
    TABLESPACE pg_default;
-- Index: terror_info_5

-- DROP INDEX IF EXISTS public.terror_info_5;

CREATE INDEX IF NOT EXISTS terror_info_5
    ON public.terror_info USING hash
    (weapsubtype_id)
    TABLESPACE pg_default;
-- Index: terror_info_6

-- DROP INDEX IF EXISTS public.terror_info_6;

CREATE INDEX IF NOT EXISTS terror_info_6
    ON public.terror_info USING hash
    (weaptype_id)
    TABLESPACE pg_default;
-- Index: terror_info_7

-- DROP INDEX IF EXISTS public.terror_info_7;

CREATE INDEX IF NOT EXISTS terror_info_7
    ON public.terror_info USING btree
    (year ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_8

-- DROP INDEX IF EXISTS public.terror_info_8;

CREATE INDEX IF NOT EXISTS terror_info_8
    ON public.terror_info USING btree
    (month ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: terror_info_9

-- DROP INDEX IF EXISTS public.terror_info_9;

CREATE INDEX IF NOT EXISTS terror_info_9
    ON public.terror_info USING btree
    (day ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.related_event

-- DROP TABLE IF EXISTS public.related_event;

CREATE TABLE IF NOT EXISTS public.related_event
(
    event_id bigint,
    related_event_id bigint,
    CONSTRAINT related_event_event_id_fkey FOREIGN KEY (event_id)
        REFERENCES public.terror_info (event_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.related_event
    OWNER to postgres;
-- Index: related_event_index_1

-- DROP INDEX IF EXISTS public.related_event_index_1;

CREATE INDEX IF NOT EXISTS related_event_index_1
    ON public.related_event USING btree
    (related_event_id ASC NULLS LAST)
    TABLESPACE pg_default;

BEGIN;
\copy country FROM '/var/lib/postgresql/proda/terror/country.csv' CSV HEADER
\copy region FROM '/var/lib/postgresql/proda/terror/region.csv' CSV HEADER
\copy targsubtype FROM '/var/lib/postgresql/proda/terror/targsubtype.csv' CSV HEADER
\copy targtype FROM '/var/lib/postgresql/proda/terror/targtype.csv' CSV HEADER
\copy weapsubtype FROM '/var/lib/postgresql/proda/terror/weapsubtype.csv' CSV HEADER
\copy weaptype FROM '/var/lib/postgresql/proda/terror/weaptype.csv' CSV HEADER
\copy terror_info FROM '/var/lib/postgresql/proda/terror/terror_info.csv' CSV HEADER
\copy related_event FROM '/var/lib/postgresql/proda/terror/related_event.csv' CSV HEADER
END;

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE terror TO data_user;
GRANT ALL PRIVILEGES ON TABLE country TO data_user;
GRANT ALL PRIVILEGES ON TABLE region TO data_user;
GRANT ALL PRIVILEGES ON TABLE targsubtype TO data_user;
GRANT ALL PRIVILEGES ON TABLE targtype TO data_user;
GRANT ALL PRIVILEGES ON TABLE weapsubtype TO data_user;
GRANT ALL PRIVILEGES ON TABLE weaptype TO data_user;
GRANT ALL PRIVILEGES ON TABLE terror_info TO data_user;
GRANT ALL PRIVILEGES ON TABLE related_event TO data_user;
GRANT ALL ON SCHEMA public TO data_user;