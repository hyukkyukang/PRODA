DROP DATABASE IF EXISTS spotify_playlists;
CREATE DATABASE spotify_playlists;
\c spotify_playlists;

-- Table: public.artists

-- DROP TABLE IF EXISTS public.artists;

CREATE TABLE IF NOT EXISTS public.artists
(
    artist_id text COLLATE pg_catalog."default" NOT NULL,
    artist_popularity integer,
    artist_followers integer,
    name text COLLATE pg_catalog."default",
    CONSTRAINT artists_pkey PRIMARY KEY (artist_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.artists
    OWNER to postgres;
-- Index: artists_index_1

-- DROP INDEX IF EXISTS public.artists_index_1;

CREATE INDEX IF NOT EXISTS artists_index_1
    ON public.artists USING btree
    (artist_popularity ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: artists_index_2

-- DROP INDEX IF EXISTS public.artists_index_2;

CREATE INDEX IF NOT EXISTS artists_index_2
    ON public.artists USING btree
    (artist_followers ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: artists_index_3

-- DROP INDEX IF EXISTS public.artists_index_3;

CREATE INDEX IF NOT EXISTS artists_index_3
    ON public.artists USING btree
    (name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.playlists

-- DROP TABLE IF EXISTS public.playlists;

CREATE TABLE IF NOT EXISTS public.playlists
(
    playlist_id text COLLATE pg_catalog."default" NOT NULL,
    name text COLLATE pg_catalog."default",
    description text COLLATE pg_catalog."default",
    query text COLLATE pg_catalog."default",
    author text COLLATE pg_catalog."default",
    n_tracks integer,
    playlist_followers integer,
    CONSTRAINT playlists_pkey PRIMARY KEY (playlist_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.playlists
    OWNER to postgres;
-- Index: playlists_index_1

-- DROP INDEX IF EXISTS public.playlists_index_1;

CREATE INDEX IF NOT EXISTS playlists_index_1
    ON public.playlists USING btree
    (name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: playlists_index_2

-- DROP INDEX IF EXISTS public.playlists_index_2;

CREATE INDEX IF NOT EXISTS playlists_index_2
    ON public.playlists USING btree
    (description COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: playlists_index_3

-- DROP INDEX IF EXISTS public.playlists_index_3;

CREATE INDEX IF NOT EXISTS playlists_index_3
    ON public.playlists USING btree
    (query COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: playlists_index_4

-- DROP INDEX IF EXISTS public.playlists_index_4;

CREATE INDEX IF NOT EXISTS playlists_index_4
    ON public.playlists USING btree
    (author COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: playlists_index_5

-- DROP INDEX IF EXISTS public.playlists_index_5;

CREATE INDEX IF NOT EXISTS playlists_index_5
    ON public.playlists USING btree
    (n_tracks ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: playlists_index_6

-- DROP INDEX IF EXISTS public.playlists_index_6;

CREATE INDEX IF NOT EXISTS playlists_index_6
    ON public.playlists USING btree
    (playlist_followers ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.tracklists

-- DROP TABLE IF EXISTS public.tracklists;

CREATE TABLE IF NOT EXISTS public.tracklists
(
    track_id text COLLATE pg_catalog."default" NOT NULL,
    name text COLLATE pg_catalog."default",
    popularity integer,
    album_type text COLLATE pg_catalog."default",
    is_playable boolean,
    release_date date,
    danceability double precision,
    energy double precision,
    key integer,
    loudness double precision,
    mode integer,
    speechiness double precision,
    acousticness double precision,
    instrumentalness double precision,
    liveness double precision,
    valence double precision,
    tempo double precision,
    analysis_url text COLLATE pg_catalog."default",
    duration_ms integer,
    time_signature integer,
    CONSTRAINT tracklists_pkey PRIMARY KEY (track_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.tracklists
    OWNER to postgres;
-- Index: tracklists_index_1

-- DROP INDEX IF EXISTS public.tracklists_index_1;

CREATE INDEX IF NOT EXISTS tracklists_index_1
    ON public.tracklists USING btree
    (name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: tracklists_index_10

-- DROP INDEX IF EXISTS public.tracklists_index_10;

CREATE INDEX IF NOT EXISTS tracklists_index_10
    ON public.tracklists USING btree
    (speechiness ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: tracklists_index_11

-- DROP INDEX IF EXISTS public.tracklists_index_11;

CREATE INDEX IF NOT EXISTS tracklists_index_11
    ON public.tracklists USING btree
    (acousticness ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: tracklists_index_12

-- DROP INDEX IF EXISTS public.tracklists_index_12;

CREATE INDEX IF NOT EXISTS tracklists_index_12
    ON public.tracklists USING btree
    (instrumentalness ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: tracklists_index_13

-- DROP INDEX IF EXISTS public.tracklists_index_13;

CREATE INDEX IF NOT EXISTS tracklists_index_13
    ON public.tracklists USING btree
    (liveness ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: tracklists_index_14

-- DROP INDEX IF EXISTS public.tracklists_index_14;

CREATE INDEX IF NOT EXISTS tracklists_index_14
    ON public.tracklists USING btree
    (valence ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: tracklists_index_15

-- DROP INDEX IF EXISTS public.tracklists_index_15;

CREATE INDEX IF NOT EXISTS tracklists_index_15
    ON public.tracklists USING btree
    (tempo ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: tracklists_index_16

-- DROP INDEX IF EXISTS public.tracklists_index_16;

CREATE INDEX IF NOT EXISTS tracklists_index_16
    ON public.tracklists USING btree
    (analysis_url COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: tracklists_index_17

-- DROP INDEX IF EXISTS public.tracklists_index_17;

CREATE INDEX IF NOT EXISTS tracklists_index_17
    ON public.tracklists USING btree
    (duration_ms ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: tracklists_index_18

-- DROP INDEX IF EXISTS public.tracklists_index_18;

CREATE INDEX IF NOT EXISTS tracklists_index_18
    ON public.tracklists USING btree
    (time_signature ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: tracklists_index_2

-- DROP INDEX IF EXISTS public.tracklists_index_2;

CREATE INDEX IF NOT EXISTS tracklists_index_2
    ON public.tracklists USING btree
    (popularity ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: tracklists_index_3

-- DROP INDEX IF EXISTS public.tracklists_index_3;

CREATE INDEX IF NOT EXISTS tracklists_index_3
    ON public.tracklists USING btree
    (album_type COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: tracklists_index_4

-- DROP INDEX IF EXISTS public.tracklists_index_4;

CREATE INDEX IF NOT EXISTS tracklists_index_4
    ON public.tracklists USING btree
    (release_date ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: tracklists_index_5

-- DROP INDEX IF EXISTS public.tracklists_index_5;

CREATE INDEX IF NOT EXISTS tracklists_index_5
    ON public.tracklists USING btree
    (danceability ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: tracklists_index_6

-- DROP INDEX IF EXISTS public.tracklists_index_6;

CREATE INDEX IF NOT EXISTS tracklists_index_6
    ON public.tracklists USING btree
    (energy ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: tracklists_index_7

-- DROP INDEX IF EXISTS public.tracklists_index_7;

CREATE INDEX IF NOT EXISTS tracklists_index_7
    ON public.tracklists USING btree
    (key ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: tracklists_index_8

-- DROP INDEX IF EXISTS public.tracklists_index_8;

CREATE INDEX IF NOT EXISTS tracklists_index_8
    ON public.tracklists USING btree
    (loudness ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: tracklists_index_9

-- DROP INDEX IF EXISTS public.tracklists_index_9;

CREATE INDEX IF NOT EXISTS tracklists_index_9
    ON public.tracklists USING btree
    (mode ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.artist_genres

-- DROP TABLE IF EXISTS public.artist_genres;

CREATE TABLE IF NOT EXISTS public.artist_genres
(
    artist_id text COLLATE pg_catalog."default",
    genres text COLLATE pg_catalog."default",
    CONSTRAINT artist_genres_artist_id_fkey FOREIGN KEY (artist_id)
        REFERENCES public.artists (artist_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.artist_genres
    OWNER to postgres;
-- Index: artist_genres_index_1

-- DROP INDEX IF EXISTS public.artist_genres_index_1;

CREATE INDEX IF NOT EXISTS artist_genres_index_1
    ON public.artist_genres USING btree
    (genres COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.participation

-- DROP TABLE IF EXISTS public.participation;

CREATE TABLE IF NOT EXISTS public.participation
(
    track_id text COLLATE pg_catalog."default",
    artist_id text COLLATE pg_catalog."default",
    CONSTRAINT participation_artist_id_fkey FOREIGN KEY (artist_id)
        REFERENCES public.artists (artist_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT participation_track_id_fkey FOREIGN KEY (track_id)
        REFERENCES public.tracklists (track_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.participation
    OWNER to postgres;

-- Table: public.track_in_playlist

-- DROP TABLE IF EXISTS public.track_in_playlist;

CREATE TABLE IF NOT EXISTS public.track_in_playlist
(
    track_id text COLLATE pg_catalog."default",
    playlist_id text COLLATE pg_catalog."default",
    CONSTRAINT track_in_playlist_playlist_id_fkey FOREIGN KEY (playlist_id)
        REFERENCES public.playlists (playlist_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT track_in_playlist_track_id_fkey FOREIGN KEY (track_id)
        REFERENCES public.tracklists (track_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.track_in_playlist
    OWNER to postgres;

BEGIN;
\copy artists FROM '/var/lib/postgresql/spotify_playlists/artists.csv' CSV HEADER
\copy playlists FROM '/var/lib/postgresql/spotify_playlists/playlists.csv' CSV HEADER
\copy tracklists FROM '/var/lib/postgresql/spotify_playlists/tracklists.csv' CSV HEADER
\copy participation FROM '/var/lib/postgresql/spotify_playlists/participation.csv' CSV HEADER
\copy track_in_playlist FROM '/var/lib/postgresql/spotify_playlists/track_in_playlist.csv' CSV HEADER
\copy artist_genres FROM '/var/lib/postgresql/spotify_playlists/artist_genres.csv' CSV HEADER
END;

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE spotify_playlists TO data_user;
GRANT ALL PRIVILEGES ON TABLE artists TO data_user;
GRANT ALL PRIVILEGES ON TABLE playlists TO data_user;
GRANT ALL PRIVILEGES ON TABLE tracklists TO data_user;
GRANT ALL PRIVILEGES ON TABLE participation TO data_user;
GRANT ALL PRIVILEGES ON TABLE track_in_playlist TO data_user;
GRANT ALL PRIVILEGES ON TABLE artist_genres TO data_user;
GRANT ALL ON SCHEMA public TO data_user;