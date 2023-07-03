DROP DATABASE IF EXISTS health_nutrition;
CREATE DATABASE health_nutrition;
\c health_nutrition;
-- Table: public.country

-- DROP TABLE IF EXISTS public.country;

CREATE TABLE IF NOT EXISTS public.country
(
    country_code character varying(5) COLLATE pg_catalog."default" NOT NULL,
    country_name character varying(60) COLLATE pg_catalog."default",
    CONSTRAINT country_pkey PRIMARY KEY (country_code)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.country
    OWNER to postgres;
-- Index: country_1

-- DROP INDEX IF EXISTS public.country_1;

CREATE INDEX IF NOT EXISTS country_1
    ON public.country USING btree
    (country_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.indicator

-- DROP TABLE IF EXISTS public.indicator;

CREATE TABLE IF NOT EXISTS public.indicator
(
    indicator_code character varying(20) COLLATE pg_catalog."default" NOT NULL,
    indicator_name character varying(120) COLLATE pg_catalog."default",
    CONSTRAINT indicator_pkey PRIMARY KEY (indicator_code)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.indicator
    OWNER to postgres;
-- Index: indicator_1

-- DROP INDEX IF EXISTS public.indicator_1;

CREATE INDEX IF NOT EXISTS indicator_1
    ON public.indicator USING btree
    (indicator_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.statistics

-- DROP TABLE IF EXISTS public.statistics;

CREATE TABLE IF NOT EXISTS public.statistics
(
    country_code character varying(5) COLLATE pg_catalog."default" NOT NULL,
    indicator_code character varying(20) COLLATE pg_catalog."default" NOT NULL,
    year integer NOT NULL,
    rate double precision,
    CONSTRAINT statistics_pkey PRIMARY KEY (country_code, indicator_code, year),
    CONSTRAINT statistics_country_code_fkey FOREIGN KEY (country_code)
        REFERENCES public.country (country_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT statistics_indicator_code_fkey FOREIGN KEY (indicator_code)
        REFERENCES public.indicator (indicator_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.statistics
    OWNER to postgres;

GRANT ALL ON TABLE public.statistics TO data_user;

GRANT ALL ON TABLE public.statistics TO postgres;
-- Index: statistics_1

-- DROP INDEX IF EXISTS public.statistics_1;

CREATE INDEX IF NOT EXISTS statistics_1
    ON public.statistics USING btree
    (country_code COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: statistics_1_1

-- DROP INDEX IF EXISTS public.statistics_1_1;

CREATE INDEX IF NOT EXISTS statistics_1_1
    ON public.statistics USING hash
    (country_code COLLATE pg_catalog."default")
    TABLESPACE pg_default;
-- Index: statistics_2

-- DROP INDEX IF EXISTS public.statistics_2;

CREATE INDEX IF NOT EXISTS statistics_2
    ON public.statistics USING btree
    (indicator_code COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: statistics_2_1

-- DROP INDEX IF EXISTS public.statistics_2_1;

CREATE INDEX IF NOT EXISTS statistics_2_1
    ON public.statistics USING hash
    (indicator_code COLLATE pg_catalog."default")
    TABLESPACE pg_default;
-- Index: statistics_3

-- DROP INDEX IF EXISTS public.statistics_3;

CREATE INDEX IF NOT EXISTS statistics_3
    ON public.statistics USING btree
    (year ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: statistics_4

-- DROP INDEX IF EXISTS public.statistics_4;

CREATE INDEX IF NOT EXISTS statistics_4
    ON public.statistics USING btree
    (rate ASC NULLS LAST)
    TABLESPACE pg_default;

BEGIN;
\copy country FROM '/var/lib/postgresql/proda/health_nutrition/country.csv' CSV HEADER
\copy indicator FROM '/var/lib/postgresql/proda/health_nutrition/indicator.csv' CSV HEADER
\copy statistics FROM '/var/lib/postgresql/proda/health_nutrition/statistics.csv' CSV HEADER
END;

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE health_nutrition TO data_user;
GRANT ALL PRIVILEGES ON TABLE country TO data_user;
GRANT ALL PRIVILEGES ON TABLE indicator TO data_user;
GRANT ALL PRIVILEGES ON TABLE statistics TO data_user;
GRANT ALL ON SCHEMA public TO data_user;