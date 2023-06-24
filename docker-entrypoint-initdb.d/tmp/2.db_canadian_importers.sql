DROP DATABASE IF EXISTS canadian_importers;
CREATE DATABASE canadian_importers;
\c canadian_importers;

-- Table: public.country

-- DROP TABLE IF EXISTS public.country;

CREATE TABLE IF NOT EXISTS public.country
(
    country text COLLATE pg_catalog."default" NOT NULL,
    pays text COLLATE pg_catalog."default",
    CONSTRAINT country_description_pkey PRIMARY KEY (country)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.country
    OWNER to postgres;
-- Index: country_index_1

-- DROP INDEX IF EXISTS public.country_index_1;

CREATE INDEX IF NOT EXISTS country_index_1
    ON public.country USING btree
    (pays COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.province

-- DROP TABLE IF EXISTS public.province;

CREATE TABLE IF NOT EXISTS public.province
(
    province_eng text COLLATE pg_catalog."default" NOT NULL,
    province_fra text COLLATE pg_catalog."default",
    CONSTRAINT province_pkey PRIMARY KEY (province_eng)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.province
    OWNER to postgres;
-- Index: province_index_1

-- DROP INDEX IF EXISTS public.province_index_1;

CREATE INDEX IF NOT EXISTS province_index_1
    ON public.province USING btree
    (province_fra COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.hs6_description

-- DROP TABLE IF EXISTS public.hs6_description;

CREATE TABLE IF NOT EXISTS public.hs6_description
(
    hs6_sh6 integer NOT NULL,
    description_eng text COLLATE pg_catalog."default",
    description_fra text COLLATE pg_catalog."default",
    CONSTRAINT hs6_description_pkey PRIMARY KEY (hs6_sh6)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.hs6_description
    OWNER to postgres;
-- Index: hs6_description_index_1

-- DROP INDEX IF EXISTS public.hs6_description_index_1;

CREATE INDEX IF NOT EXISTS hs6_description_index_1
    ON public.hs6_description USING btree
    (description_eng COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: hs6_description_index_2

-- DROP INDEX IF EXISTS public.hs6_description_index_2;

CREATE INDEX IF NOT EXISTS hs6_description_index_2
    ON public.hs6_description USING btree
    (description_fra COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.hs10_description

-- DROP TABLE IF EXISTS public.hs10_description;

CREATE TABLE IF NOT EXISTS public.hs10_description
(
    hs10_sh10 bigint NOT NULL,
    description_eng text COLLATE pg_catalog."default",
    description_fra text COLLATE pg_catalog."default",
    CONSTRAINT hs10_description_pkey PRIMARY KEY (hs10_sh10)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.hs10_description
    OWNER to postgres;
-- Index: hs10_description_index_1

-- DROP INDEX IF EXISTS public.hs10_description_index_1;

CREATE INDEX IF NOT EXISTS hs10_description_index_1
    ON public.hs10_description USING btree
    (description_eng COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: hs10_description_index_2

-- DROP INDEX IF EXISTS public.hs10_description_index_2;

CREATE INDEX IF NOT EXISTS hs10_description_index_2
    ON public.hs10_description USING btree
    (description_fra COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.major_importers_by_city

-- DROP TABLE IF EXISTS public.major_importers_by_city;

CREATE TABLE IF NOT EXISTS public.major_importers_by_city
(
    city_ville text COLLATE pg_catalog."default" NOT NULL,
    company_enterprise text COLLATE pg_catalog."default" NOT NULL,
    province_eng text COLLATE pg_catalog."default",
    postal_code_code_postal text COLLATE pg_catalog."default",
    data_year_anne_des_donnes integer,
    CONSTRAINT major_importers_by_city_pkey PRIMARY KEY (city_ville, company_enterprise),
    CONSTRAINT major_importers_by_city_province_eng_fkey FOREIGN KEY (province_eng)
        REFERENCES public.province (province_eng) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.major_importers_by_city
    OWNER to postgres;
-- Index: major_importers_by_city_index_1

-- DROP INDEX IF EXISTS public.major_importers_by_city_index_1;

CREATE INDEX IF NOT EXISTS major_importers_by_city_index_1
    ON public.major_importers_by_city USING btree
    (city_ville COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: major_importers_by_city_index_2

-- DROP INDEX IF EXISTS public.major_importers_by_city_index_2;

CREATE INDEX IF NOT EXISTS major_importers_by_city_index_2
    ON public.major_importers_by_city USING btree
    (company_enterprise COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: major_importers_by_city_index_3

-- DROP INDEX IF EXISTS public.major_importers_by_city_index_3;

CREATE INDEX IF NOT EXISTS major_importers_by_city_index_3
    ON public.major_importers_by_city USING btree
    (postal_code_code_postal COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: major_importers_by_city_index_4

-- DROP INDEX IF EXISTS public.major_importers_by_city_index_4;

CREATE INDEX IF NOT EXISTS major_importers_by_city_index_4
    ON public.major_importers_by_city USING btree
    (data_year_anne_des_donnes ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.major_importers_by_country

-- DROP TABLE IF EXISTS public.major_importers_by_country;

CREATE TABLE IF NOT EXISTS public.major_importers_by_country
(
    country text COLLATE pg_catalog."default" NOT NULL,
    company_enterprise text COLLATE pg_catalog."default" NOT NULL,
    city_ville text COLLATE pg_catalog."default" NOT NULL,
    province_eng text COLLATE pg_catalog."default",
    province_fra text COLLATE pg_catalog."default",
    postal_code_code_postal text COLLATE pg_catalog."default",
    data_year_anne_des_donnes integer,
    CONSTRAINT major_importers_by_country_pkey PRIMARY KEY (country, company_enterprise, city_ville),
    CONSTRAINT major_importers_by_country_country_fkey FOREIGN KEY (country)
        REFERENCES public.country (country) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.major_importers_by_country
    OWNER to postgres;
-- Index: major_importers_by_country_index_1

-- DROP INDEX IF EXISTS public.major_importers_by_country_index_1;

CREATE INDEX IF NOT EXISTS major_importers_by_country_index_1
    ON public.major_importers_by_country USING btree
    (company_enterprise COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: major_importers_by_country_index_2

-- DROP INDEX IF EXISTS public.major_importers_by_country_index_2;

CREATE INDEX IF NOT EXISTS major_importers_by_country_index_2
    ON public.major_importers_by_country USING btree
    (city_ville COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: major_importers_by_country_index_3

-- DROP INDEX IF EXISTS public.major_importers_by_country_index_3;

CREATE INDEX IF NOT EXISTS major_importers_by_country_index_3
    ON public.major_importers_by_country USING btree
    (province_eng COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: major_importers_by_country_index_4

-- DROP INDEX IF EXISTS public.major_importers_by_country_index_4;

CREATE INDEX IF NOT EXISTS major_importers_by_country_index_4
    ON public.major_importers_by_country USING btree
    (province_fra COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: major_importers_by_country_index_5

-- DROP INDEX IF EXISTS public.major_importers_by_country_index_5;

CREATE INDEX IF NOT EXISTS major_importers_by_country_index_5
    ON public.major_importers_by_country USING btree
    (postal_code_code_postal COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: major_importers_by_country_index_6

-- DROP INDEX IF EXISTS public.major_importers_by_country_index_6;

CREATE INDEX IF NOT EXISTS major_importers_by_country_index_6
    ON public.major_importers_by_country USING btree
    (data_year_anne_des_donnes ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.major_importers_by_hs6

-- DROP TABLE IF EXISTS public.major_importers_by_hs6;

CREATE TABLE IF NOT EXISTS public.major_importers_by_hs6
(
    hs6_sh6 integer NOT NULL,
    company_enterprise text COLLATE pg_catalog."default" NOT NULL,
    city_ville text COLLATE pg_catalog."default" NOT NULL,
    province_eng text COLLATE pg_catalog."default",
    postal_code_code_postal text COLLATE pg_catalog."default",
    data_year_anne_des_donnes integer,
    CONSTRAINT major_importers_by_hs6_pkey PRIMARY KEY (hs6_sh6, company_enterprise, city_ville),
    CONSTRAINT major_importers_by_hs6_hs6_sh6_fkey FOREIGN KEY (hs6_sh6)
        REFERENCES public.hs6_description (hs6_sh6) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT major_importers_by_hs6_province_eng_fkey FOREIGN KEY (province_eng)
        REFERENCES public.province (province_eng) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.major_importers_by_hs6
    OWNER to postgres;
-- Index: major_importers_by_hs6_index_1

-- DROP INDEX IF EXISTS public.major_importers_by_hs6_index_1;

CREATE INDEX IF NOT EXISTS major_importers_by_hs6_index_1
    ON public.major_importers_by_hs6 USING btree
    (company_enterprise COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: major_importers_by_hs6_index_2

-- DROP INDEX IF EXISTS public.major_importers_by_hs6_index_2;

CREATE INDEX IF NOT EXISTS major_importers_by_hs6_index_2
    ON public.major_importers_by_hs6 USING btree
    (city_ville COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: major_importers_by_hs6_index_3

-- DROP INDEX IF EXISTS public.major_importers_by_hs6_index_3;

CREATE INDEX IF NOT EXISTS major_importers_by_hs6_index_3
    ON public.major_importers_by_hs6 USING btree
    (postal_code_code_postal COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: major_importers_by_hs6_index_4

-- DROP INDEX IF EXISTS public.major_importers_by_hs6_index_4;

CREATE INDEX IF NOT EXISTS major_importers_by_hs6_index_4
    ON public.major_importers_by_hs6 USING btree
    (data_year_anne_des_donnes ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.major_importers_by_hs6_country

-- DROP TABLE IF EXISTS public.major_importers_by_hs6_country;

CREATE TABLE IF NOT EXISTS public.major_importers_by_hs6_country
(
    hs6_sh6 integer NOT NULL,
    company_enterprise text COLLATE pg_catalog."default" NOT NULL,
    country text COLLATE pg_catalog."default" NOT NULL,
    province_eng text COLLATE pg_catalog."default",
    city_ville text COLLATE pg_catalog."default" NOT NULL,
    postal_code_code_postal text COLLATE pg_catalog."default",
    data_year_anne_des_donnes integer,
    CONSTRAINT major_importers_by_hs6_country_pkey PRIMARY KEY (hs6_sh6, company_enterprise, country, city_ville),
    CONSTRAINT major_importers_by_hs6_country_country_fkey FOREIGN KEY (country)
        REFERENCES public.country (country) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT major_importers_by_hs6_country_hs6_sh6_fkey FOREIGN KEY (hs6_sh6)
        REFERENCES public.hs6_description (hs6_sh6) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT major_importers_by_hs6_country_province_eng_fkey FOREIGN KEY (province_eng)
        REFERENCES public.province (province_eng) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.major_importers_by_hs6_country
    OWNER to postgres;
-- Index: major_importers_by_hs6_country_index_1

-- DROP INDEX IF EXISTS public.major_importers_by_hs6_country_index_1;

CREATE INDEX IF NOT EXISTS major_importers_by_hs6_country_index_1
    ON public.major_importers_by_hs6_country USING btree
    (company_enterprise COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: major_importers_by_hs6_country_index_2

-- DROP INDEX IF EXISTS public.major_importers_by_hs6_country_index_2;

CREATE INDEX IF NOT EXISTS major_importers_by_hs6_country_index_2
    ON public.major_importers_by_hs6_country USING btree
    (city_ville COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: major_importers_by_hs6_country_index_3

-- DROP INDEX IF EXISTS public.major_importers_by_hs6_country_index_3;

CREATE INDEX IF NOT EXISTS major_importers_by_hs6_country_index_3
    ON public.major_importers_by_hs6_country USING btree
    (postal_code_code_postal COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: major_importers_by_hs6_country_index_4

-- DROP INDEX IF EXISTS public.major_importers_by_hs6_country_index_4;

CREATE INDEX IF NOT EXISTS major_importers_by_hs6_country_index_4
    ON public.major_importers_by_hs6_country USING btree
    (data_year_anne_des_donnes ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.major_importers_by_hs10

-- DROP TABLE IF EXISTS public.major_importers_by_hs10;

CREATE TABLE IF NOT EXISTS public.major_importers_by_hs10
(
    hs10_sh10 bigint NOT NULL,
    company_enterprise text COLLATE pg_catalog."default" NOT NULL,
    city_ville text COLLATE pg_catalog."default" NOT NULL,
    province_eng text COLLATE pg_catalog."default",
    postal_code_code_postal text COLLATE pg_catalog."default",
    data_year_anne_des_donnes integer,
    CONSTRAINT major_importers_by_hs10_pkey PRIMARY KEY (hs10_sh10, company_enterprise, city_ville),
    CONSTRAINT major_importers_by_hs10_hs10_sh10_fkey FOREIGN KEY (hs10_sh10)
        REFERENCES public.hs10_description (hs10_sh10) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT major_importers_by_hs10_province_eng_fkey FOREIGN KEY (province_eng)
        REFERENCES public.province (province_eng) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.major_importers_by_hs10
    OWNER to postgres;
-- Index: major_importers_by_hs10_index_1

-- DROP INDEX IF EXISTS public.major_importers_by_hs10_index_1;

CREATE INDEX IF NOT EXISTS major_importers_by_hs10_index_1
    ON public.major_importers_by_hs10 USING btree
    (company_enterprise COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: major_importers_by_hs10_index_2

-- DROP INDEX IF EXISTS public.major_importers_by_hs10_index_2;

CREATE INDEX IF NOT EXISTS major_importers_by_hs10_index_2
    ON public.major_importers_by_hs10 USING btree
    (city_ville COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: major_importers_by_hs10_index_3

-- DROP INDEX IF EXISTS public.major_importers_by_hs10_index_3;

CREATE INDEX IF NOT EXISTS major_importers_by_hs10_index_3
    ON public.major_importers_by_hs10 USING btree
    (postal_code_code_postal COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: major_importers_by_hs10_index_4

-- DROP INDEX IF EXISTS public.major_importers_by_hs10_index_4;

CREATE INDEX IF NOT EXISTS major_importers_by_hs10_index_4
    ON public.major_importers_by_hs10 USING btree
    (data_year_anne_des_donnes ASC NULLS LAST)
    TABLESPACE pg_default;

BEGIN;
\copy country FROM '/var/lib/postgresql/canadian_importers/country.csv' CSV HEADER
\copy province FROM '/var/lib/postgresql/canadian_importers/province.csv' CSV HEADER
\copy hs6_description FROM '/var/lib/postgresql/canadian_importers/hs6_description.csv' CSV HEADER
\copy hs10_description FROM '/var/lib/postgresql/canadian_importers/hs10_description.csv' CSV HEADER
\copy major_importers_by_hs6 FROM '/var/lib/postgresql/canadian_importers/major_importers_by_hs6.csv' CSV HEADER
\copy major_importers_by_hs10 FROM '/var/lib/postgresql/canadian_importers/major_importers_by_hs10.csv' CSV HEADER
\copy major_importers_by_city FROM '/var/lib/postgresql/canadian_importers/major_importers_by_city.csv' CSV HEADER
\copy major_importers_by_country FROM '/var/lib/postgresql/canadian_importers/major_importers_by_country.csv' CSV HEADER
\copy major_importers_by_hs6_country FROM '/var/lib/postgresql/canadian_importers/major_importers_by_hs6_country.csv' CSV HEADER
END;

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE canadian_importers TO data_user;
GRANT ALL PRIVILEGES ON TABLE country TO data_user;
GRANT ALL PRIVILEGES ON TABLE province TO data_user;
GRANT ALL PRIVILEGES ON TABLE hs6_description TO data_user;
GRANT ALL PRIVILEGES ON TABLE hs10_description TO data_user;
GRANT ALL PRIVILEGES ON TABLE major_importers_by_hs6 TO data_user;
GRANT ALL PRIVILEGES ON TABLE major_importers_by_hs10 TO data_user;
GRANT ALL PRIVILEGES ON TABLE major_importers_by_city TO data_user;
GRANT ALL PRIVILEGES ON TABLE major_importers_by_country TO data_user;
GRANT ALL PRIVILEGES ON TABLE major_importers_by_hs6_country TO data_user;
GRANT ALL ON SCHEMA public TO data_user;