DROP DATABASE IF EXISTS terror_info;
CREATE DATABASE terror_info;
\c terror_info;

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

-- Table: public.terror

-- DROP TABLE IF EXISTS public.terror;

CREATE TABLE IF NOT EXISTS public.terror
(
    eventid bigint NOT NULL,
    iyear integer,
    imonth integer,
    iday integer,
    approxdate text COLLATE pg_catalog."default",
    is_extended boolean,
    resolution text COLLATE pg_catalog."default",
    country_id integer,
    region_id integer,
    provstate text COLLATE pg_catalog."default",
    city text COLLATE pg_catalog."default",
    latitude double precision,
    longitude double precision,
    geographical_accuracy text COLLATE pg_catalog."default",
    is_vicinity boolean,
    location_detail text COLLATE pg_catalog."default",
    summary text COLLATE pg_catalog."default",
    terror_criterion_1 boolean,
    terror_criterion_2 boolean,
    terror_criterion_3 boolean,
    alternative text COLLATE pg_catalog."default",
    is_success boolean,
    is_suicide boolean,
    attacktype text COLLATE pg_catalog."default",
    targtype_id integer,
    targsubtype_id integer,
    target_corporation text COLLATE pg_catalog."default",
    target_name text COLLATE pg_catalog."default",
    target_nationality text COLLATE pg_catalog."default",
    terror_group_name text COLLATE pg_catalog."default",
    motive text COLLATE pg_catalog."default",
    is_terror_group_certain boolean,
    claimmode text COLLATE pg_catalog."default",
    weaptype_id integer,
    weapsubtype_id integer,
    whole_killed_num integer,
    killed_american_num integer,
    killed_terrorist_num integer,
    whole_wounded_num integer,
    wounded_american_num integer,
    wounded_terrorist_num integer,
    is_property_damaged boolean,
    property_damage_level text COLLATE pg_catalog."default",
    estimated_value_of_property_damage bigint,
    property_description text COLLATE pg_catalog."default",
    is_hostage_kidnap boolean,
    hostage_num integer,
    american_hostage_num integer,
    kidnap_hours integer,
    kidnap_days integer,
    is_ransom boolean,
    released_hostage_num integer,
    dbsource text COLLATE pg_catalog."default",
    CONSTRAINT terror_pkey PRIMARY KEY (eventid),
    CONSTRAINT terror_country_id_fkey FOREIGN KEY (country_id)
        REFERENCES public.country (country_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT terror_region_id_fkey FOREIGN KEY (region_id)
        REFERENCES public.region (region_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT terror_targsubtype_id_fkey FOREIGN KEY (targsubtype_id)
        REFERENCES public.targsubtype (targsubtype_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT terror_targtype_id_fkey FOREIGN KEY (targtype_id)
        REFERENCES public.targtype (targtype_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT terror_weapsubtype_id_fkey FOREIGN KEY (weapsubtype_id)
        REFERENCES public.weapsubtype (weapsubtype_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT terror_weaptype_id_fkey FOREIGN KEY (weaptype_id)
        REFERENCES public.weaptype (weaptype_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.terror
    OWNER to postgres;

-- Table: public.related_event

-- DROP TABLE IF EXISTS public.related_event;

CREATE TABLE IF NOT EXISTS public.related_event
(
    eventid bigint,
    related_eventid bigint,
    CONSTRAINT related_event_eventid_fkey FOREIGN KEY (eventid)
        REFERENCES public.terror (eventid) MATCH SIMPLE
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
    (related_eventid ASC NULLS LAST)
    TABLESPACE pg_default;

BEGIN;
\copy country FROM '/var/lib/postgresql/terror_info/country.csv' CSV HEADER
\copy region FROM '/var/lib/postgresql/terror_info/region.csv' CSV HEADER
\copy targsubtype FROM '/var/lib/postgresql/terror_info/targsubtype.csv' CSV HEADER
\copy targtype FROM '/var/lib/postgresql/terror_info/targtype.csv' CSV HEADER
\copy weapsubtype FROM '/var/lib/postgresql/terror_info/weapsubtype.csv' CSV HEADER
\copy weaptype FROM '/var/lib/postgresql/terror_info/weaptype.csv' CSV HEADER
\copy terror FROM '/var/lib/postgresql/terror_info/terror.csv' CSV HEADER
\copy related_event FROM '/var/lib/postgresql/terror_info/related_event.csv' CSV HEADER
END;

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE terror_info TO data_user;
GRANT ALL PRIVILEGES ON TABLE country TO data_user;
GRANT ALL PRIVILEGES ON TABLE region TO data_user;
GRANT ALL PRIVILEGES ON TABLE targsubtype TO data_user;
GRANT ALL PRIVILEGES ON TABLE targtype TO data_user;
GRANT ALL PRIVILEGES ON TABLE weapsubtype TO data_user;
GRANT ALL PRIVILEGES ON TABLE weaptype TO data_user;
GRANT ALL PRIVILEGES ON TABLE terror TO data_user;
GRANT ALL PRIVILEGES ON TABLE related_event TO data_user;
GRANT ALL ON SCHEMA public TO data_user;