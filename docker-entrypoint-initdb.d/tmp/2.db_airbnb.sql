DROP DATABASE IF EXISTS airbnb;
CREATE DATABASE airbnb;
\c airbnb;

CREATE TABLE IF NOT EXISTS public.cities
(
    city text COLLATE pg_catalog."default",
    is_weekend boolean,
    total_price double precision,
    airbnb_id integer,
    room_type text COLLATE pg_catalog."default",
    is_room_shared boolean,
    is_room_private boolean,
    person_capacity integer,
    is_host_is_superhost boolean,
    is_multiple_rooms boolean,
    is_business_facilities boolean,
    cleanliness_rating integer,
    guest_satisfaction_overall integer,
    bedrooms integer,
    city_centre_dist double precision,
    metro_dist double precision,
    longitude double precision,
    latitude double precision
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.cities
    OWNER to postgres;

\copy cities FROM '/var/lib/postgresql/airbnb/cities.csv' CSV HEADER


GRANT ALL PRIVILEGES ON DATABASE airbnb TO data_user;
GRANT ALL PRIVILEGES ON TABLE cities TO data_user;
GRANT ALL ON SCHEMA public TO data_user;