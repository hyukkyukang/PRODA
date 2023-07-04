DROP DATABASE IF EXISTS nba;
CREATE DATABASE nba;
\c nba;

-- Table: public.game

-- DROP TABLE IF EXISTS public.game;

CREATE TABLE IF NOT EXISTS public.game
(
    season_id integer,
    team_id_home integer,
    team_abbreviation_home character varying(3) COLLATE pg_catalog."default",
    team_name_home character varying(33) COLLATE pg_catalog."default",
    game_id integer NOT NULL,
    game_date character varying(30) COLLATE pg_catalog."default",
    matchup_home character varying(11) COLLATE pg_catalog."default",
    win_lose_home character varying(3) COLLATE pg_catalog."default",
    min integer,
    field_goals_made_at_home double precision,
    field_goals_attempted_at_home double precision,
    field_goal_percentage_at_home double precision,
    three_point_field_goals_made_at_home double precision,
    three_point_field_goals_attempted_at_home double precision,
    three_point_field_goals_percentage_at_home double precision,
    free_throws_made_at_home double precision,
    free_throws_attempted_at_home double precision,
    free_throw_percentage_at_home double precision,
    offensive_rebounds_at_home double precision,
    defensive_rebounds_at_home double precision,
    rebound_home double precision,
    assist_home double precision,
    steal_home double precision,
    block_home double precision,
    turn_over_home double precision,
    personal_foul_home double precision,
    points_home integer,
    plus_minus_home integer,
    team_id_away integer,
    team_abbreviation_away character varying(3) COLLATE pg_catalog."default",
    team_name_away character varying(33) COLLATE pg_catalog."default",
    matchup_away character varying(9) COLLATE pg_catalog."default",
    win_lose_away character varying(3) COLLATE pg_catalog."default",
    field_goals_made_at_away double precision,
    field_goals_attempted_at_away double precision,
    field_goal_percentage_at_away double precision,
    three_point_field_goals_made_at_away double precision,
    three_point_field_goals_attempted_at_away double precision,
    three_point_field_goals_percentage_at_away double precision,
    free_throws_made_at_away double precision,
    free_throws_attempted_at_away double precision,
    free_throw_percentage_at_away double precision,
    offensive_rebounds_at_away double precision,
    defensive_rebounds_at_away double precision,
    rebound_away double precision,
    assist_away double precision,
    steal_away double precision,
    block_away double precision,
    turn_over_away double precision,
    personal_foul_away double precision,
    points_away integer,
    plus_minus_away integer,
    video_available_away integer,
    video_available_home boolean,
    CONSTRAINT game_pkey PRIMARY KEY (game_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.game
    OWNER to postgres;

GRANT ALL ON TABLE public.game TO data_user;

GRANT ALL ON TABLE public.game TO postgres;
-- Index: idx_game_ast_away

-- DROP INDEX IF EXISTS public.idx_game_ast_away;

CREATE INDEX IF NOT EXISTS idx_game_ast_away
    ON public.game USING btree
    (assist_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_ast_home

-- DROP INDEX IF EXISTS public.idx_game_ast_home;

CREATE INDEX IF NOT EXISTS idx_game_ast_home
    ON public.game USING btree
    (assist_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_blk_away

-- DROP INDEX IF EXISTS public.idx_game_blk_away;

CREATE INDEX IF NOT EXISTS idx_game_blk_away
    ON public.game USING btree
    (block_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_blk_home

-- DROP INDEX IF EXISTS public.idx_game_blk_home;

CREATE INDEX IF NOT EXISTS idx_game_blk_home
    ON public.game USING btree
    (block_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_dreb_away

-- DROP INDEX IF EXISTS public.idx_game_dreb_away;

CREATE INDEX IF NOT EXISTS idx_game_dreb_away
    ON public.game USING btree
    (defensive_rebounds_at_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_dreb_home

-- DROP INDEX IF EXISTS public.idx_game_dreb_home;

CREATE INDEX IF NOT EXISTS idx_game_dreb_home
    ON public.game USING btree
    (defensive_rebounds_at_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_fg3_pct_away

-- DROP INDEX IF EXISTS public.idx_game_fg3_pct_away;

CREATE INDEX IF NOT EXISTS idx_game_fg3_pct_away
    ON public.game USING btree
    (three_point_field_goals_percentage_at_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_fg3_pct_home

-- DROP INDEX IF EXISTS public.idx_game_fg3_pct_home;

CREATE INDEX IF NOT EXISTS idx_game_fg3_pct_home
    ON public.game USING btree
    (three_point_field_goals_percentage_at_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_fg3a_away

-- DROP INDEX IF EXISTS public.idx_game_fg3a_away;

CREATE INDEX IF NOT EXISTS idx_game_fg3a_away
    ON public.game USING btree
    (three_point_field_goals_attempted_at_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_fg3a_home

-- DROP INDEX IF EXISTS public.idx_game_fg3a_home;

CREATE INDEX IF NOT EXISTS idx_game_fg3a_home
    ON public.game USING btree
    (three_point_field_goals_attempted_at_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_fg3m_away

-- DROP INDEX IF EXISTS public.idx_game_fg3m_away;

CREATE INDEX IF NOT EXISTS idx_game_fg3m_away
    ON public.game USING btree
    (three_point_field_goals_made_at_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_fg3m_home

-- DROP INDEX IF EXISTS public.idx_game_fg3m_home;

CREATE INDEX IF NOT EXISTS idx_game_fg3m_home
    ON public.game USING btree
    (three_point_field_goals_made_at_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_fg_pct_away

-- DROP INDEX IF EXISTS public.idx_game_fg_pct_away;

CREATE INDEX IF NOT EXISTS idx_game_fg_pct_away
    ON public.game USING btree
    (field_goal_percentage_at_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_fg_pct_home

-- DROP INDEX IF EXISTS public.idx_game_fg_pct_home;

CREATE INDEX IF NOT EXISTS idx_game_fg_pct_home
    ON public.game USING btree
    (field_goal_percentage_at_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_fga_away

-- DROP INDEX IF EXISTS public.idx_game_fga_away;

CREATE INDEX IF NOT EXISTS idx_game_fga_away
    ON public.game USING btree
    (field_goals_attempted_at_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_fga_home

-- DROP INDEX IF EXISTS public.idx_game_fga_home;

CREATE INDEX IF NOT EXISTS idx_game_fga_home
    ON public.game USING btree
    (field_goals_attempted_at_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_fgm_away

-- DROP INDEX IF EXISTS public.idx_game_fgm_away;

CREATE INDEX IF NOT EXISTS idx_game_fgm_away
    ON public.game USING btree
    (field_goals_made_at_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_fgm_home

-- DROP INDEX IF EXISTS public.idx_game_fgm_home;

CREATE INDEX IF NOT EXISTS idx_game_fgm_home
    ON public.game USING btree
    (field_goals_made_at_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_ft_pct_away

-- DROP INDEX IF EXISTS public.idx_game_ft_pct_away;

CREATE INDEX IF NOT EXISTS idx_game_ft_pct_away
    ON public.game USING btree
    (free_throw_percentage_at_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_ft_pct_home

-- DROP INDEX IF EXISTS public.idx_game_ft_pct_home;

CREATE INDEX IF NOT EXISTS idx_game_ft_pct_home
    ON public.game USING btree
    (free_throw_percentage_at_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_fta_away

-- DROP INDEX IF EXISTS public.idx_game_fta_away;

CREATE INDEX IF NOT EXISTS idx_game_fta_away
    ON public.game USING btree
    (free_throws_attempted_at_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_fta_home

-- DROP INDEX IF EXISTS public.idx_game_fta_home;

CREATE INDEX IF NOT EXISTS idx_game_fta_home
    ON public.game USING btree
    (free_throws_attempted_at_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_ftm_away

-- DROP INDEX IF EXISTS public.idx_game_ftm_away;

CREATE INDEX IF NOT EXISTS idx_game_ftm_away
    ON public.game USING btree
    (free_throws_made_at_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_ftm_home

-- DROP INDEX IF EXISTS public.idx_game_ftm_home;

CREATE INDEX IF NOT EXISTS idx_game_ftm_home
    ON public.game USING btree
    (free_throws_made_at_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_game_date

-- DROP INDEX IF EXISTS public.idx_game_game_date;

CREATE INDEX IF NOT EXISTS idx_game_game_date
    ON public.game USING btree
    (game_date COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_matchup_away

-- DROP INDEX IF EXISTS public.idx_game_matchup_away;

CREATE INDEX IF NOT EXISTS idx_game_matchup_away
    ON public.game USING btree
    (matchup_away COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_matchup_home

-- DROP INDEX IF EXISTS public.idx_game_matchup_home;

CREATE INDEX IF NOT EXISTS idx_game_matchup_home
    ON public.game USING btree
    (matchup_home COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_min

-- DROP INDEX IF EXISTS public.idx_game_min;

CREATE INDEX IF NOT EXISTS idx_game_min
    ON public.game USING btree
    (min ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_oreb_away

-- DROP INDEX IF EXISTS public.idx_game_oreb_away;

CREATE INDEX IF NOT EXISTS idx_game_oreb_away
    ON public.game USING btree
    (offensive_rebounds_at_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_oreb_home

-- DROP INDEX IF EXISTS public.idx_game_oreb_home;

CREATE INDEX IF NOT EXISTS idx_game_oreb_home
    ON public.game USING btree
    (offensive_rebounds_at_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_pf_away

-- DROP INDEX IF EXISTS public.idx_game_pf_away;

CREATE INDEX IF NOT EXISTS idx_game_pf_away
    ON public.game USING btree
    (personal_foul_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_pf_home

-- DROP INDEX IF EXISTS public.idx_game_pf_home;

CREATE INDEX IF NOT EXISTS idx_game_pf_home
    ON public.game USING btree
    (personal_foul_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_plus_minus_away

-- DROP INDEX IF EXISTS public.idx_game_plus_minus_away;

CREATE INDEX IF NOT EXISTS idx_game_plus_minus_away
    ON public.game USING btree
    (plus_minus_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_plus_minus_home

-- DROP INDEX IF EXISTS public.idx_game_plus_minus_home;

CREATE INDEX IF NOT EXISTS idx_game_plus_minus_home
    ON public.game USING btree
    (plus_minus_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_pts_away

-- DROP INDEX IF EXISTS public.idx_game_pts_away;

CREATE INDEX IF NOT EXISTS idx_game_pts_away
    ON public.game USING btree
    (points_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_pts_home

-- DROP INDEX IF EXISTS public.idx_game_pts_home;

CREATE INDEX IF NOT EXISTS idx_game_pts_home
    ON public.game USING btree
    (points_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_reb_away

-- DROP INDEX IF EXISTS public.idx_game_reb_away;

CREATE INDEX IF NOT EXISTS idx_game_reb_away
    ON public.game USING btree
    (rebound_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_reb_home

-- DROP INDEX IF EXISTS public.idx_game_reb_home;

CREATE INDEX IF NOT EXISTS idx_game_reb_home
    ON public.game USING btree
    (rebound_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_season_id

-- DROP INDEX IF EXISTS public.idx_game_season_id;

CREATE INDEX IF NOT EXISTS idx_game_season_id
    ON public.game USING btree
    (season_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_stl_away

-- DROP INDEX IF EXISTS public.idx_game_stl_away;

CREATE INDEX IF NOT EXISTS idx_game_stl_away
    ON public.game USING btree
    (steal_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_stl_home

-- DROP INDEX IF EXISTS public.idx_game_stl_home;

CREATE INDEX IF NOT EXISTS idx_game_stl_home
    ON public.game USING btree
    (steal_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_team_abbreviation_away

-- DROP INDEX IF EXISTS public.idx_game_team_abbreviation_away;

CREATE INDEX IF NOT EXISTS idx_game_team_abbreviation_away
    ON public.game USING btree
    (team_abbreviation_away COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_team_abbreviation_home

-- DROP INDEX IF EXISTS public.idx_game_team_abbreviation_home;

CREATE INDEX IF NOT EXISTS idx_game_team_abbreviation_home
    ON public.game USING btree
    (team_abbreviation_home COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_team_id_away

-- DROP INDEX IF EXISTS public.idx_game_team_id_away;

CREATE INDEX IF NOT EXISTS idx_game_team_id_away
    ON public.game USING btree
    (team_id_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_team_id_home

-- DROP INDEX IF EXISTS public.idx_game_team_id_home;

CREATE INDEX IF NOT EXISTS idx_game_team_id_home
    ON public.game USING btree
    (team_id_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_team_name_away

-- DROP INDEX IF EXISTS public.idx_game_team_name_away;

CREATE INDEX IF NOT EXISTS idx_game_team_name_away
    ON public.game USING btree
    (team_name_away COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_team_name_home

-- DROP INDEX IF EXISTS public.idx_game_team_name_home;

CREATE INDEX IF NOT EXISTS idx_game_team_name_home
    ON public.game USING btree
    (team_name_home COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_tov_away

-- DROP INDEX IF EXISTS public.idx_game_tov_away;

CREATE INDEX IF NOT EXISTS idx_game_tov_away
    ON public.game USING btree
    (turn_over_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_tov_home

-- DROP INDEX IF EXISTS public.idx_game_tov_home;

CREATE INDEX IF NOT EXISTS idx_game_tov_home
    ON public.game USING btree
    (turn_over_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_video_available_away

-- DROP INDEX IF EXISTS public.idx_game_video_available_away;

CREATE INDEX IF NOT EXISTS idx_game_video_available_away
    ON public.game USING btree
    (video_available_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_video_available_home

-- DROP INDEX IF EXISTS public.idx_game_video_available_home;

CREATE INDEX IF NOT EXISTS idx_game_video_available_home
    ON public.game USING btree
    (video_available_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_wl_away

-- DROP INDEX IF EXISTS public.idx_game_wl_away;

CREATE INDEX IF NOT EXISTS idx_game_wl_away
    ON public.game USING btree
    (win_lose_away COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_wl_home

-- DROP INDEX IF EXISTS public.idx_game_wl_home;

CREATE INDEX IF NOT EXISTS idx_game_wl_home
    ON public.game USING btree
    (win_lose_home COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.player

-- DROP TABLE IF EXISTS public.player;

CREATE TABLE IF NOT EXISTS public.player
(
    id integer NOT NULL,
    full_name character varying(24) COLLATE pg_catalog."default",
    first_name character varying(15) COLLATE pg_catalog."default",
    last_name character varying(18) COLLATE pg_catalog."default",
    is_active boolean,
    CONSTRAINT player_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.player
    OWNER to postgres;

GRANT ALL ON TABLE public.player TO data_user;

GRANT ALL ON TABLE public.player TO postgres;
-- Index: idx_player_first_name

-- DROP INDEX IF EXISTS public.idx_player_first_name;

CREATE INDEX IF NOT EXISTS idx_player_first_name
    ON public.player USING btree
    (first_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_player_full_name

-- DROP INDEX IF EXISTS public.idx_player_full_name;

CREATE INDEX IF NOT EXISTS idx_player_full_name
    ON public.player USING btree
    (full_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_player_is_active

-- DROP INDEX IF EXISTS public.idx_player_is_active;

CREATE INDEX IF NOT EXISTS idx_player_is_active
    ON public.player USING btree
    (is_active ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_player_last_name

-- DROP INDEX IF EXISTS public.idx_player_last_name;

CREATE INDEX IF NOT EXISTS idx_player_last_name
    ON public.player USING btree
    (last_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.team

-- DROP TABLE IF EXISTS public.team;

CREATE TABLE IF NOT EXISTS public.team
(
    id integer NOT NULL,
    full_name character varying(22) COLLATE pg_catalog."default",
    abbreviation character varying(3) COLLATE pg_catalog."default",
    nickname character varying(13) COLLATE pg_catalog."default",
    city character varying(13) COLLATE pg_catalog."default",
    state character varying(20) COLLATE pg_catalog."default",
    year_founded double precision,
    CONSTRAINT team_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.team
    OWNER to postgres;

GRANT ALL ON TABLE public.team TO data_user;

GRANT ALL ON TABLE public.team TO postgres;
-- Index: idx_team_abbreviation

-- DROP INDEX IF EXISTS public.idx_team_abbreviation;

CREATE INDEX IF NOT EXISTS idx_team_abbreviation
    ON public.team USING btree
    (abbreviation COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_city

-- DROP INDEX IF EXISTS public.idx_team_city;

CREATE INDEX IF NOT EXISTS idx_team_city
    ON public.team USING btree
    (city COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_full_name

-- DROP INDEX IF EXISTS public.idx_team_full_name;

CREATE INDEX IF NOT EXISTS idx_team_full_name
    ON public.team USING btree
    (full_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_nickname

-- DROP INDEX IF EXISTS public.idx_team_nickname;

CREATE INDEX IF NOT EXISTS idx_team_nickname
    ON public.team USING btree
    (nickname COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_state

-- DROP INDEX IF EXISTS public.idx_team_state;

CREATE INDEX IF NOT EXISTS idx_team_state
    ON public.team USING btree
    (state COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_year_founded

-- DROP INDEX IF EXISTS public.idx_team_year_founded;

CREATE INDEX IF NOT EXISTS idx_team_year_founded
    ON public.team USING btree
    (year_founded ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.game_info

-- DROP TABLE IF EXISTS public.game_info;

CREATE TABLE IF NOT EXISTS public.game_info
(
    game_id integer NOT NULL,
    game_date timestamp without time zone,
    attendance double precision,
    game_time interval,
    CONSTRAINT game_info_pkey PRIMARY KEY (game_id),
    CONSTRAINT game_info_game_id_fkey FOREIGN KEY (game_id)
        REFERENCES public.game (game_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.game_info
    OWNER to postgres;

GRANT ALL ON TABLE public.game_info TO data_user;

GRANT ALL ON TABLE public.game_info TO postgres;
-- Index: idx_game_info_attendance

-- DROP INDEX IF EXISTS public.idx_game_info_attendance;

CREATE INDEX IF NOT EXISTS idx_game_info_attendance
    ON public.game_info USING btree
    (attendance ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_info_game_date

-- DROP INDEX IF EXISTS public.idx_game_info_game_date;

CREATE INDEX IF NOT EXISTS idx_game_info_game_date
    ON public.game_info USING btree
    (game_date ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_info_game_time

-- DROP INDEX IF EXISTS public.idx_game_info_game_time;

CREATE INDEX IF NOT EXISTS idx_game_info_game_time
    ON public.game_info USING btree
    (game_time ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.game_summary

-- DROP TABLE IF EXISTS public.game_summary;

CREATE TABLE IF NOT EXISTS public.game_summary
(
    game_date_est character varying(30) COLLATE pg_catalog."default",
    game_sequence double precision,
    game_id integer NOT NULL,
    game_status_id integer,
    game_status_text character varying(20) COLLATE pg_catalog."default",
    gamecode character varying(15) COLLATE pg_catalog."default",
    home_team_id integer,
    visitor_team_id integer,
    season integer,
    live_period integer,
    live_pc_time character varying(10) COLLATE pg_catalog."default",
    natl_tv_broadcaster_abbreviation character varying(9) COLLATE pg_catalog."default",
    live_period_time_bcast character varying(19) COLLATE pg_catalog."default" NOT NULL,
    wh_status boolean,
    CONSTRAINT game_summary_pkey PRIMARY KEY (game_id, live_period_time_bcast),
    CONSTRAINT game_summary_game_id_fkey FOREIGN KEY (game_id)
        REFERENCES public.game (game_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT game_summary_home_team_id_fkey FOREIGN KEY (home_team_id)
        REFERENCES public.team (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.game_summary
    OWNER to postgres;

GRANT ALL ON TABLE public.game_summary TO data_user;

GRANT ALL ON TABLE public.game_summary TO postgres;
-- Index: idx_game_summary_game_date_est

-- DROP INDEX IF EXISTS public.idx_game_summary_game_date_est;

CREATE INDEX IF NOT EXISTS idx_game_summary_game_date_est
    ON public.game_summary USING btree
    (game_date_est COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_summary_game_sequence

-- DROP INDEX IF EXISTS public.idx_game_summary_game_sequence;

CREATE INDEX IF NOT EXISTS idx_game_summary_game_sequence
    ON public.game_summary USING btree
    (game_sequence ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_summary_game_status_id

-- DROP INDEX IF EXISTS public.idx_game_summary_game_status_id;

CREATE INDEX IF NOT EXISTS idx_game_summary_game_status_id
    ON public.game_summary USING btree
    (game_status_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_summary_game_status_text

-- DROP INDEX IF EXISTS public.idx_game_summary_game_status_text;

CREATE INDEX IF NOT EXISTS idx_game_summary_game_status_text
    ON public.game_summary USING btree
    (game_status_text COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_summary_gamecode

-- DROP INDEX IF EXISTS public.idx_game_summary_gamecode;

CREATE INDEX IF NOT EXISTS idx_game_summary_gamecode
    ON public.game_summary USING btree
    (gamecode COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_summary_home_team_id

-- DROP INDEX IF EXISTS public.idx_game_summary_home_team_id;

CREATE INDEX IF NOT EXISTS idx_game_summary_home_team_id
    ON public.game_summary USING btree
    (home_team_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_summary_live_pc_time

-- DROP INDEX IF EXISTS public.idx_game_summary_live_pc_time;

CREATE INDEX IF NOT EXISTS idx_game_summary_live_pc_time
    ON public.game_summary USING btree
    (live_pc_time COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_summary_live_period

-- DROP INDEX IF EXISTS public.idx_game_summary_live_period;

CREATE INDEX IF NOT EXISTS idx_game_summary_live_period
    ON public.game_summary USING btree
    (live_period ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_summary_live_period_time_bcast

-- DROP INDEX IF EXISTS public.idx_game_summary_live_period_time_bcast;

CREATE INDEX IF NOT EXISTS idx_game_summary_live_period_time_bcast
    ON public.game_summary USING btree
    (live_period_time_bcast COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_summary_natl_tv_broadcaster_abbreviation

-- DROP INDEX IF EXISTS public.idx_game_summary_natl_tv_broadcaster_abbreviation;

CREATE INDEX IF NOT EXISTS idx_game_summary_natl_tv_broadcaster_abbreviation
    ON public.game_summary USING btree
    (natl_tv_broadcaster_abbreviation COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_summary_season

-- DROP INDEX IF EXISTS public.idx_game_summary_season;

CREATE INDEX IF NOT EXISTS idx_game_summary_season
    ON public.game_summary USING btree
    (season ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_summary_visitor_team_id

-- DROP INDEX IF EXISTS public.idx_game_summary_visitor_team_id;

CREATE INDEX IF NOT EXISTS idx_game_summary_visitor_team_id
    ON public.game_summary USING btree
    (visitor_team_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_game_summary_wh_status

-- DROP INDEX IF EXISTS public.idx_game_summary_wh_status;

CREATE INDEX IF NOT EXISTS idx_game_summary_wh_status
    ON public.game_summary USING btree
    (wh_status ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_hash_game_summary_home_team_id

-- DROP INDEX IF EXISTS public.idx_hash_game_summary_home_team_id;

CREATE INDEX IF NOT EXISTS idx_hash_game_summary_home_team_id
    ON public.game_summary USING hash
    (home_team_id)
    TABLESPACE pg_default;

-- Table: public.common_player_info

-- DROP TABLE IF EXISTS public.common_player_info;

CREATE TABLE IF NOT EXISTS public.common_player_info
(
    person_id integer,
    first_name character varying(14) COLLATE pg_catalog."default",
    last_name character varying(18) COLLATE pg_catalog."default",
    display_first_last character varying(24) COLLATE pg_catalog."default",
    display_last_comma_first character varying(25) COLLATE pg_catalog."default",
    display_fi_last character varying(21) COLLATE pg_catalog."default",
    player_slug character varying(24) COLLATE pg_catalog."default",
    birthdate character varying(50) COLLATE pg_catalog."default",
    school character varying(35) COLLATE pg_catalog."default",
    country character varying(24) COLLATE pg_catalog."default",
    last_affiliation character varying(42) COLLATE pg_catalog."default",
    weight double precision,
    season_exp integer,
    jersey character varying(7) COLLATE pg_catalog."default",
    "position" character varying(14) COLLATE pg_catalog."default",
    rosterstatus character varying(8) COLLATE pg_catalog."default",
    games_played_current_season_flag character varying(1) COLLATE pg_catalog."default",
    team_id integer,
    team_name character varying(13) COLLATE pg_catalog."default",
    team_abbreviation character varying(3) COLLATE pg_catalog."default",
    team_code character varying(12) COLLATE pg_catalog."default",
    team_city character varying(25) COLLATE pg_catalog."default",
    playercode character varying(33) COLLATE pg_catalog."default",
    from_year date,
    to_year date,
    dleague_flag character varying(1) COLLATE pg_catalog."default",
    nba_flag character varying(1) COLLATE pg_catalog."default",
    games_played_flag character varying(1) COLLATE pg_catalog."default",
    draft_year character varying(9) COLLATE pg_catalog."default",
    draft_round character varying(9) COLLATE pg_catalog."default",
    draft_number character varying(9) COLLATE pg_catalog."default",
    greatest_75_flag character varying(1) COLLATE pg_catalog."default",
    CONSTRAINT common_player_info_person_id_fkey FOREIGN KEY (person_id)
        REFERENCES public.player (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT common_player_info_team_id_fkey FOREIGN KEY (team_id)
        REFERENCES public.team (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.common_player_info
    OWNER to postgres;

GRANT ALL ON TABLE public.common_player_info TO data_user;

GRANT ALL ON TABLE public.common_player_info TO postgres;
-- Index: idx_common_player_info_birthdate

-- DROP INDEX IF EXISTS public.idx_common_player_info_birthdate;

CREATE INDEX IF NOT EXISTS idx_common_player_info_birthdate
    ON public.common_player_info USING btree
    (birthdate COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_country

-- DROP INDEX IF EXISTS public.idx_common_player_info_country;

CREATE INDEX IF NOT EXISTS idx_common_player_info_country
    ON public.common_player_info USING btree
    (country COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_display_fi_last

-- DROP INDEX IF EXISTS public.idx_common_player_info_display_fi_last;

CREATE INDEX IF NOT EXISTS idx_common_player_info_display_fi_last
    ON public.common_player_info USING btree
    (display_fi_last COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_display_first_last

-- DROP INDEX IF EXISTS public.idx_common_player_info_display_first_last;

CREATE INDEX IF NOT EXISTS idx_common_player_info_display_first_last
    ON public.common_player_info USING btree
    (display_first_last COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_display_last_comma_first

-- DROP INDEX IF EXISTS public.idx_common_player_info_display_last_comma_first;

CREATE INDEX IF NOT EXISTS idx_common_player_info_display_last_comma_first
    ON public.common_player_info USING btree
    (display_last_comma_first COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_dleague_flag

-- DROP INDEX IF EXISTS public.idx_common_player_info_dleague_flag;

CREATE INDEX IF NOT EXISTS idx_common_player_info_dleague_flag
    ON public.common_player_info USING btree
    (dleague_flag COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_draft_number

-- DROP INDEX IF EXISTS public.idx_common_player_info_draft_number;

CREATE INDEX IF NOT EXISTS idx_common_player_info_draft_number
    ON public.common_player_info USING btree
    (draft_number COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_draft_round

-- DROP INDEX IF EXISTS public.idx_common_player_info_draft_round;

CREATE INDEX IF NOT EXISTS idx_common_player_info_draft_round
    ON public.common_player_info USING btree
    (draft_round COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_draft_year

-- DROP INDEX IF EXISTS public.idx_common_player_info_draft_year;

CREATE INDEX IF NOT EXISTS idx_common_player_info_draft_year
    ON public.common_player_info USING btree
    (draft_year COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_first_name

-- DROP INDEX IF EXISTS public.idx_common_player_info_first_name;

CREATE INDEX IF NOT EXISTS idx_common_player_info_first_name
    ON public.common_player_info USING btree
    (first_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_from_year

-- DROP INDEX IF EXISTS public.idx_common_player_info_from_year;

CREATE INDEX IF NOT EXISTS idx_common_player_info_from_year
    ON public.common_player_info USING btree
    (from_year ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_games_played_current_season_flag

-- DROP INDEX IF EXISTS public.idx_common_player_info_games_played_current_season_flag;

CREATE INDEX IF NOT EXISTS idx_common_player_info_games_played_current_season_flag
    ON public.common_player_info USING btree
    (games_played_current_season_flag COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_games_played_flag

-- DROP INDEX IF EXISTS public.idx_common_player_info_games_played_flag;

CREATE INDEX IF NOT EXISTS idx_common_player_info_games_played_flag
    ON public.common_player_info USING btree
    (games_played_flag COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_greatest_75_flag

-- DROP INDEX IF EXISTS public.idx_common_player_info_greatest_75_flag;

CREATE INDEX IF NOT EXISTS idx_common_player_info_greatest_75_flag
    ON public.common_player_info USING btree
    (greatest_75_flag COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_jersey

-- DROP INDEX IF EXISTS public.idx_common_player_info_jersey;

CREATE INDEX IF NOT EXISTS idx_common_player_info_jersey
    ON public.common_player_info USING btree
    (jersey COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_last_affiliation

-- DROP INDEX IF EXISTS public.idx_common_player_info_last_affiliation;

CREATE INDEX IF NOT EXISTS idx_common_player_info_last_affiliation
    ON public.common_player_info USING btree
    (last_affiliation COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_last_name

-- DROP INDEX IF EXISTS public.idx_common_player_info_last_name;

CREATE INDEX IF NOT EXISTS idx_common_player_info_last_name
    ON public.common_player_info USING btree
    (last_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_nba_flag

-- DROP INDEX IF EXISTS public.idx_common_player_info_nba_flag;

CREATE INDEX IF NOT EXISTS idx_common_player_info_nba_flag
    ON public.common_player_info USING btree
    (nba_flag COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_person_id

-- DROP INDEX IF EXISTS public.idx_common_player_info_person_id;

CREATE INDEX IF NOT EXISTS idx_common_player_info_person_id
    ON public.common_player_info USING btree
    (person_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_player_slug

-- DROP INDEX IF EXISTS public.idx_common_player_info_player_slug;

CREATE INDEX IF NOT EXISTS idx_common_player_info_player_slug
    ON public.common_player_info USING btree
    (player_slug COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_playercode

-- DROP INDEX IF EXISTS public.idx_common_player_info_playercode;

CREATE INDEX IF NOT EXISTS idx_common_player_info_playercode
    ON public.common_player_info USING btree
    (playercode COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_position

-- DROP INDEX IF EXISTS public.idx_common_player_info_position;

CREATE INDEX IF NOT EXISTS idx_common_player_info_position
    ON public.common_player_info USING btree
    ("position" COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_rosterstatus

-- DROP INDEX IF EXISTS public.idx_common_player_info_rosterstatus;

CREATE INDEX IF NOT EXISTS idx_common_player_info_rosterstatus
    ON public.common_player_info USING btree
    (rosterstatus COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_school

-- DROP INDEX IF EXISTS public.idx_common_player_info_school;

CREATE INDEX IF NOT EXISTS idx_common_player_info_school
    ON public.common_player_info USING btree
    (school COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_season_exp

-- DROP INDEX IF EXISTS public.idx_common_player_info_season_exp;

CREATE INDEX IF NOT EXISTS idx_common_player_info_season_exp
    ON public.common_player_info USING btree
    (season_exp ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_team_abbreviation

-- DROP INDEX IF EXISTS public.idx_common_player_info_team_abbreviation;

CREATE INDEX IF NOT EXISTS idx_common_player_info_team_abbreviation
    ON public.common_player_info USING btree
    (team_abbreviation COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_team_city

-- DROP INDEX IF EXISTS public.idx_common_player_info_team_city;

CREATE INDEX IF NOT EXISTS idx_common_player_info_team_city
    ON public.common_player_info USING btree
    (team_city COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_team_code

-- DROP INDEX IF EXISTS public.idx_common_player_info_team_code;

CREATE INDEX IF NOT EXISTS idx_common_player_info_team_code
    ON public.common_player_info USING btree
    (team_code COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_team_id

-- DROP INDEX IF EXISTS public.idx_common_player_info_team_id;

CREATE INDEX IF NOT EXISTS idx_common_player_info_team_id
    ON public.common_player_info USING btree
    (team_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_team_name

-- DROP INDEX IF EXISTS public.idx_common_player_info_team_name;

CREATE INDEX IF NOT EXISTS idx_common_player_info_team_name
    ON public.common_player_info USING btree
    (team_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_to_year

-- DROP INDEX IF EXISTS public.idx_common_player_info_to_year;

CREATE INDEX IF NOT EXISTS idx_common_player_info_to_year
    ON public.common_player_info USING btree
    (to_year ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_common_player_info_weight

-- DROP INDEX IF EXISTS public.idx_common_player_info_weight;

CREATE INDEX IF NOT EXISTS idx_common_player_info_weight
    ON public.common_player_info USING btree
    (weight ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_hash_common_player_info_person_id

-- DROP INDEX IF EXISTS public.idx_hash_common_player_info_person_id;

CREATE INDEX IF NOT EXISTS idx_hash_common_player_info_person_id
    ON public.common_player_info USING hash
    (person_id)
    TABLESPACE pg_default;
-- Index: idx_hash_common_player_info_team_id

-- DROP INDEX IF EXISTS public.idx_hash_common_player_info_team_id;

CREATE INDEX IF NOT EXISTS idx_hash_common_player_info_team_id
    ON public.common_player_info USING hash
    (team_id)
    TABLESPACE pg_default;

-- Table: public.draft_combine_stats

-- DROP TABLE IF EXISTS public.draft_combine_stats;

CREATE TABLE IF NOT EXISTS public.draft_combine_stats
(
    season integer NOT NULL,
    player_id integer NOT NULL,
    first_name character varying(10) COLLATE pg_catalog."default",
    last_name character varying(18) COLLATE pg_catalog."default",
    player_name character varying(24) COLLATE pg_catalog."default",
    "position" character varying(5) COLLATE pg_catalog."default",
    height_wo_shoes double precision,
    height_wo_shoes_ft_in character varying(10) COLLATE pg_catalog."default",
    height_w_shoes double precision,
    height_w_shoes_ft_in character varying(10) COLLATE pg_catalog."default",
    weight double precision,
    wingspan double precision,
    wingspan_ft_in character varying(10) COLLATE pg_catalog."default",
    standing_reach double precision,
    standing_reach_ft_in character varying(10) COLLATE pg_catalog."default",
    body_fat_pct double precision,
    hand_length double precision,
    hand_width double precision,
    standing_vertical_leap double precision,
    max_vertical_leap double precision,
    lane_agility_time double precision,
    modified_lane_agility_time double precision,
    three_quarter_sprint double precision,
    bench_press double precision,
    spot_fifteen_corner_left character varying(3) COLLATE pg_catalog."default",
    spot_fifteen_break_left character varying(3) COLLATE pg_catalog."default",
    spot_fifteen_top_key character varying(3) COLLATE pg_catalog."default",
    spot_fifteen_break_right character varying(3) COLLATE pg_catalog."default",
    spot_fifteen_corner_right character varying(3) COLLATE pg_catalog."default",
    spot_college_corner_left character varying(5) COLLATE pg_catalog."default",
    spot_college_break_left character varying(3) COLLATE pg_catalog."default",
    spot_college_top_key character varying(3) COLLATE pg_catalog."default",
    spot_college_break_right character varying(3) COLLATE pg_catalog."default",
    spot_college_corner_right character varying(3) COLLATE pg_catalog."default",
    spot_nba_corner_left character varying(3) COLLATE pg_catalog."default",
    spot_nba_break_left character varying(3) COLLATE pg_catalog."default",
    spot_nba_top_key character varying(3) COLLATE pg_catalog."default",
    spot_nba_break_right character varying(3) COLLATE pg_catalog."default",
    spot_nba_corner_right character varying(3) COLLATE pg_catalog."default",
    off_drib_fifteen_break_left character varying(3) COLLATE pg_catalog."default",
    off_drib_fifteen_top_key character varying(3) COLLATE pg_catalog."default",
    off_drib_fifteen_break_right character varying(4) COLLATE pg_catalog."default",
    off_drib_college_break_left character varying(5) COLLATE pg_catalog."default",
    off_drib_college_top_key character varying(3) COLLATE pg_catalog."default",
    off_drib_college_break_right character varying(3) COLLATE pg_catalog."default",
    on_move_fifteen character varying(5) COLLATE pg_catalog."default",
    on_move_college character varying(5) COLLATE pg_catalog."default",
    CONSTRAINT draft_combine_stats_pkey PRIMARY KEY (season, player_id),
    CONSTRAINT draft_combine_stats_player_id_fkey FOREIGN KEY (player_id)
        REFERENCES public.player (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.draft_combine_stats
    OWNER to postgres;

GRANT ALL ON TABLE public.draft_combine_stats TO data_user;

GRANT ALL ON TABLE public.draft_combine_stats TO postgres;
-- Index: idx_draft_combine_stats_bench_press

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_bench_press;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_bench_press
    ON public.draft_combine_stats USING btree
    (bench_press ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_body_fat_pct

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_body_fat_pct;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_body_fat_pct
    ON public.draft_combine_stats USING btree
    (body_fat_pct ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_first_name

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_first_name;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_first_name
    ON public.draft_combine_stats USING btree
    (first_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_hand_length

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_hand_length;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_hand_length
    ON public.draft_combine_stats USING btree
    (hand_length ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_hand_width

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_hand_width;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_hand_width
    ON public.draft_combine_stats USING btree
    (hand_width ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_height_w_shoes

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_height_w_shoes;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_height_w_shoes
    ON public.draft_combine_stats USING btree
    (height_w_shoes ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_height_w_shoes_ft_in

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_height_w_shoes_ft_in;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_height_w_shoes_ft_in
    ON public.draft_combine_stats USING btree
    (height_w_shoes_ft_in COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_height_wo_shoes

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_height_wo_shoes;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_height_wo_shoes
    ON public.draft_combine_stats USING btree
    (height_wo_shoes ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_height_wo_shoes_ft_in

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_height_wo_shoes_ft_in;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_height_wo_shoes_ft_in
    ON public.draft_combine_stats USING btree
    (height_wo_shoes_ft_in COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_lane_agility_time

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_lane_agility_time;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_lane_agility_time
    ON public.draft_combine_stats USING btree
    (lane_agility_time ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_last_name

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_last_name;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_last_name
    ON public.draft_combine_stats USING btree
    (last_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_max_vertical_leap

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_max_vertical_leap;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_max_vertical_leap
    ON public.draft_combine_stats USING btree
    (max_vertical_leap ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_modified_lane_agility_time

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_modified_lane_agility_time;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_modified_lane_agility_time
    ON public.draft_combine_stats USING btree
    (modified_lane_agility_time ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_off_drib_college_break_left

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_off_drib_college_break_left;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_off_drib_college_break_left
    ON public.draft_combine_stats USING btree
    (off_drib_college_break_left COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_off_drib_college_break_right

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_off_drib_college_break_right;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_off_drib_college_break_right
    ON public.draft_combine_stats USING btree
    (off_drib_college_break_right COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_off_drib_college_top_key

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_off_drib_college_top_key;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_off_drib_college_top_key
    ON public.draft_combine_stats USING btree
    (off_drib_college_top_key COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_off_drib_fifteen_break_left

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_off_drib_fifteen_break_left;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_off_drib_fifteen_break_left
    ON public.draft_combine_stats USING btree
    (off_drib_fifteen_break_left COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_off_drib_fifteen_break_right

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_off_drib_fifteen_break_right;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_off_drib_fifteen_break_right
    ON public.draft_combine_stats USING btree
    (off_drib_fifteen_break_right COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_off_drib_fifteen_top_key

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_off_drib_fifteen_top_key;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_off_drib_fifteen_top_key
    ON public.draft_combine_stats USING btree
    (off_drib_fifteen_top_key COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_on_move_college

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_on_move_college;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_on_move_college
    ON public.draft_combine_stats USING btree
    (on_move_college COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_on_move_fifteen

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_on_move_fifteen;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_on_move_fifteen
    ON public.draft_combine_stats USING btree
    (on_move_fifteen COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_player_id

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_player_id;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_player_id
    ON public.draft_combine_stats USING btree
    (player_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_player_name

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_player_name;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_player_name
    ON public.draft_combine_stats USING btree
    (player_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_position

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_position;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_position
    ON public.draft_combine_stats USING btree
    ("position" COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_spot_college_break_left

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_spot_college_break_left;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_spot_college_break_left
    ON public.draft_combine_stats USING btree
    (spot_college_break_left COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_spot_college_break_right

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_spot_college_break_right;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_spot_college_break_right
    ON public.draft_combine_stats USING btree
    (spot_college_break_right COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_spot_college_corner_left

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_spot_college_corner_left;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_spot_college_corner_left
    ON public.draft_combine_stats USING btree
    (spot_college_corner_left COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_spot_college_corner_right

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_spot_college_corner_right;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_spot_college_corner_right
    ON public.draft_combine_stats USING btree
    (spot_college_corner_right COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_spot_college_top_key

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_spot_college_top_key;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_spot_college_top_key
    ON public.draft_combine_stats USING btree
    (spot_college_top_key COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_spot_fifteen_break_left

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_spot_fifteen_break_left;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_spot_fifteen_break_left
    ON public.draft_combine_stats USING btree
    (spot_fifteen_break_left COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_spot_fifteen_break_right

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_spot_fifteen_break_right;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_spot_fifteen_break_right
    ON public.draft_combine_stats USING btree
    (spot_fifteen_break_right COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_spot_fifteen_corner_left

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_spot_fifteen_corner_left;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_spot_fifteen_corner_left
    ON public.draft_combine_stats USING btree
    (spot_fifteen_corner_left COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_spot_fifteen_corner_right

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_spot_fifteen_corner_right;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_spot_fifteen_corner_right
    ON public.draft_combine_stats USING btree
    (spot_fifteen_corner_right COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_spot_fifteen_top_key

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_spot_fifteen_top_key;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_spot_fifteen_top_key
    ON public.draft_combine_stats USING btree
    (spot_fifteen_top_key COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_spot_nba_break_left

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_spot_nba_break_left;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_spot_nba_break_left
    ON public.draft_combine_stats USING btree
    (spot_nba_break_left COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_spot_nba_break_right

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_spot_nba_break_right;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_spot_nba_break_right
    ON public.draft_combine_stats USING btree
    (spot_nba_break_right COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_spot_nba_corner_left

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_spot_nba_corner_left;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_spot_nba_corner_left
    ON public.draft_combine_stats USING btree
    (spot_nba_corner_left COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_spot_nba_corner_right

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_spot_nba_corner_right;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_spot_nba_corner_right
    ON public.draft_combine_stats USING btree
    (spot_nba_corner_right COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_spot_nba_top_key

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_spot_nba_top_key;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_spot_nba_top_key
    ON public.draft_combine_stats USING btree
    (spot_nba_top_key COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_standing_reach

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_standing_reach;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_standing_reach
    ON public.draft_combine_stats USING btree
    (standing_reach ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_standing_reach_ft_in

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_standing_reach_ft_in;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_standing_reach_ft_in
    ON public.draft_combine_stats USING btree
    (standing_reach_ft_in COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_standing_vertical_leap

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_standing_vertical_leap;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_standing_vertical_leap
    ON public.draft_combine_stats USING btree
    (standing_vertical_leap ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_three_quarter_sprint

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_three_quarter_sprint;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_three_quarter_sprint
    ON public.draft_combine_stats USING btree
    (three_quarter_sprint ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_weight

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_weight;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_weight
    ON public.draft_combine_stats USING btree
    (weight ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_wingspan

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_wingspan;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_wingspan
    ON public.draft_combine_stats USING btree
    (wingspan ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_combine_stats_wingspan_ft_in

-- DROP INDEX IF EXISTS public.idx_draft_combine_stats_wingspan_ft_in;

CREATE INDEX IF NOT EXISTS idx_draft_combine_stats_wingspan_ft_in
    ON public.draft_combine_stats USING btree
    (wingspan_ft_in COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_hash_draft_combine_stats_player_id

-- DROP INDEX IF EXISTS public.idx_hash_draft_combine_stats_player_id;

CREATE INDEX IF NOT EXISTS idx_hash_draft_combine_stats_player_id
    ON public.draft_combine_stats USING hash
    (player_id)
    TABLESPACE pg_default;

-- Table: public.draft_history

-- DROP TABLE IF EXISTS public.draft_history;

CREATE TABLE IF NOT EXISTS public.draft_history
(
    person_id integer NOT NULL,
    player_name character varying(24) COLLATE pg_catalog."default",
    season date NOT NULL,
    round_number integer,
    round_pick integer,
    overall_pick integer,
    draft_type character varying(11) COLLATE pg_catalog."default",
    team_id integer NOT NULL,
    team_city character varying(25) COLLATE pg_catalog."default",
    team_name character varying(13) COLLATE pg_catalog."default",
    team_abbreviation character varying(3) COLLATE pg_catalog."default",
    organization character varying(64) COLLATE pg_catalog."default",
    organization_type character varying(18) COLLATE pg_catalog."default",
    player_profile_flag integer,
    CONSTRAINT draft_history_pkey PRIMARY KEY (season, team_id, person_id),
    CONSTRAINT draft_history_team_id_fkey FOREIGN KEY (team_id)
        REFERENCES public.team (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.draft_history
    OWNER to postgres;

GRANT ALL ON TABLE public.draft_history TO data_user;

GRANT ALL ON TABLE public.draft_history TO postgres;
-- Index: idx_draft_history_draft_type

-- DROP INDEX IF EXISTS public.idx_draft_history_draft_type;

CREATE INDEX IF NOT EXISTS idx_draft_history_draft_type
    ON public.draft_history USING btree
    (draft_type COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_history_organization

-- DROP INDEX IF EXISTS public.idx_draft_history_organization;

CREATE INDEX IF NOT EXISTS idx_draft_history_organization
    ON public.draft_history USING btree
    (organization COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_history_organization_type

-- DROP INDEX IF EXISTS public.idx_draft_history_organization_type;

CREATE INDEX IF NOT EXISTS idx_draft_history_organization_type
    ON public.draft_history USING btree
    (organization_type COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_history_overall_pick

-- DROP INDEX IF EXISTS public.idx_draft_history_overall_pick;

CREATE INDEX IF NOT EXISTS idx_draft_history_overall_pick
    ON public.draft_history USING btree
    (overall_pick ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_history_player_name

-- DROP INDEX IF EXISTS public.idx_draft_history_player_name;

CREATE INDEX IF NOT EXISTS idx_draft_history_player_name
    ON public.draft_history USING btree
    (player_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_history_player_profile_flag

-- DROP INDEX IF EXISTS public.idx_draft_history_player_profile_flag;

CREATE INDEX IF NOT EXISTS idx_draft_history_player_profile_flag
    ON public.draft_history USING btree
    (player_profile_flag ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_history_round_number

-- DROP INDEX IF EXISTS public.idx_draft_history_round_number;

CREATE INDEX IF NOT EXISTS idx_draft_history_round_number
    ON public.draft_history USING btree
    (round_number ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_history_round_pick

-- DROP INDEX IF EXISTS public.idx_draft_history_round_pick;

CREATE INDEX IF NOT EXISTS idx_draft_history_round_pick
    ON public.draft_history USING btree
    (round_pick ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_history_season

-- DROP INDEX IF EXISTS public.idx_draft_history_season;

CREATE INDEX IF NOT EXISTS idx_draft_history_season
    ON public.draft_history USING btree
    (season ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_history_team_abbreviation

-- DROP INDEX IF EXISTS public.idx_draft_history_team_abbreviation;

CREATE INDEX IF NOT EXISTS idx_draft_history_team_abbreviation
    ON public.draft_history USING btree
    (team_abbreviation COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_history_team_city

-- DROP INDEX IF EXISTS public.idx_draft_history_team_city;

CREATE INDEX IF NOT EXISTS idx_draft_history_team_city
    ON public.draft_history USING btree
    (team_city COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_history_team_id

-- DROP INDEX IF EXISTS public.idx_draft_history_team_id;

CREATE INDEX IF NOT EXISTS idx_draft_history_team_id
    ON public.draft_history USING btree
    (team_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_draft_history_team_name

-- DROP INDEX IF EXISTS public.idx_draft_history_team_name;

CREATE INDEX IF NOT EXISTS idx_draft_history_team_name
    ON public.draft_history USING btree
    (team_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_hash_draft_history_team_id

-- DROP INDEX IF EXISTS public.idx_hash_draft_history_team_id;

CREATE INDEX IF NOT EXISTS idx_hash_draft_history_team_id
    ON public.draft_history USING hash
    (team_id)
    TABLESPACE pg_default;

-- Table: public.inactive_players

-- DROP TABLE IF EXISTS public.inactive_players;

CREATE TABLE IF NOT EXISTS public.inactive_players
(
    game_id integer NOT NULL,
    player_id integer NOT NULL,
    first_name character varying(13) COLLATE pg_catalog."default",
    last_name character varying(18) COLLATE pg_catalog."default",
    jersey_num character varying(3) COLLATE pg_catalog."default",
    team_id integer,
    team_city character varying(25) COLLATE pg_catalog."default",
    team_name character varying(13) COLLATE pg_catalog."default",
    team_abbreviation character varying(3) COLLATE pg_catalog."default",
    CONSTRAINT inactive_players_pkey PRIMARY KEY (game_id, player_id),
    CONSTRAINT inactive_players_game_id_fkey FOREIGN KEY (game_id)
        REFERENCES public.game (game_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.inactive_players
    OWNER to postgres;

GRANT ALL ON TABLE public.inactive_players TO data_user;

GRANT ALL ON TABLE public.inactive_players TO postgres;
-- Index: idx_inactive_players_first_name

-- DROP INDEX IF EXISTS public.idx_inactive_players_first_name;

CREATE INDEX IF NOT EXISTS idx_inactive_players_first_name
    ON public.inactive_players USING btree
    (first_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_inactive_players_jersey_num

-- DROP INDEX IF EXISTS public.idx_inactive_players_jersey_num;

CREATE INDEX IF NOT EXISTS idx_inactive_players_jersey_num
    ON public.inactive_players USING btree
    (jersey_num COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_inactive_players_last_name

-- DROP INDEX IF EXISTS public.idx_inactive_players_last_name;

CREATE INDEX IF NOT EXISTS idx_inactive_players_last_name
    ON public.inactive_players USING btree
    (last_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_inactive_players_player_id

-- DROP INDEX IF EXISTS public.idx_inactive_players_player_id;

CREATE INDEX IF NOT EXISTS idx_inactive_players_player_id
    ON public.inactive_players USING btree
    (player_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_inactive_players_team_abbreviation

-- DROP INDEX IF EXISTS public.idx_inactive_players_team_abbreviation;

CREATE INDEX IF NOT EXISTS idx_inactive_players_team_abbreviation
    ON public.inactive_players USING btree
    (team_abbreviation COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_inactive_players_team_city

-- DROP INDEX IF EXISTS public.idx_inactive_players_team_city;

CREATE INDEX IF NOT EXISTS idx_inactive_players_team_city
    ON public.inactive_players USING btree
    (team_city COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_inactive_players_team_id

-- DROP INDEX IF EXISTS public.idx_inactive_players_team_id;

CREATE INDEX IF NOT EXISTS idx_inactive_players_team_id
    ON public.inactive_players USING btree
    (team_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_inactive_players_team_name

-- DROP INDEX IF EXISTS public.idx_inactive_players_team_name;

CREATE INDEX IF NOT EXISTS idx_inactive_players_team_name
    ON public.inactive_players USING btree
    (team_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.line_score

-- DROP TABLE IF EXISTS public.line_score;

CREATE TABLE IF NOT EXISTS public.line_score
(
    game_date_est timestamp without time zone,
    game_sequence double precision,
    game_id integer NOT NULL,
    team_id_home integer,
    team_abbreviation_home character varying(3) COLLATE pg_catalog."default",
    team_city_name_home character varying(25) COLLATE pg_catalog."default",
    team_nickname_home character varying(13) COLLATE pg_catalog."default",
    team_wins_losses_home character varying(5) COLLATE pg_catalog."default",
    points_quarter1_home double precision,
    points_quarter2_home double precision,
    points_quarter3_home double precision,
    points_quarter4_home double precision,
    points_over_time1_home double precision,
    points_over_time2_home double precision,
    points_over_time3_home double precision,
    points_over_time4_home double precision,
    points_over_time5_home double precision,
    points_over_time6_home double precision,
    points_over_time7_home double precision,
    points_over_time8_home double precision,
    points_over_time9_home double precision,
    points_over_time10_home double precision,
    points_home integer,
    team_id_away integer,
    team_abbreviation_away character varying(3) COLLATE pg_catalog."default",
    team_city_name_away character varying(25) COLLATE pg_catalog."default",
    team_nickname_away character varying(13) COLLATE pg_catalog."default",
    team_wins_losses_away character varying(5) COLLATE pg_catalog."default",
    points_quarter1_away double precision,
    points_quarter2_away double precision,
    points_quarter3_away double precision,
    points_quarter4_away double precision,
    points_over_time1_away double precision,
    points_over_time2_away double precision,
    points_over_time3_away double precision,
    points_over_time4_away double precision,
    points_over_time5_away double precision,
    points_over_time6_away double precision,
    points_over_time7_away double precision,
    points_over_time8_away double precision,
    points_over_time9_away double precision,
    points_over_time10_away double precision,
    points_away integer,
    CONSTRAINT line_score_1_pkey PRIMARY KEY (game_id),
    CONSTRAINT line_score_1_game_id_fkey FOREIGN KEY (game_id)
        REFERENCES public.game (game_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.line_score
    OWNER to postgres;

GRANT ALL ON TABLE public.line_score TO data_user;

GRANT ALL ON TABLE public.line_score TO postgres;
-- Index: idx_line_score_game_date_est

-- DROP INDEX IF EXISTS public.idx_line_score_game_date_est;

CREATE INDEX IF NOT EXISTS idx_line_score_game_date_est
    ON public.line_score USING btree
    (game_date_est ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_game_sequence

-- DROP INDEX IF EXISTS public.idx_line_score_game_sequence;

CREATE INDEX IF NOT EXISTS idx_line_score_game_sequence
    ON public.line_score USING btree
    (game_sequence ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_away

-- DROP INDEX IF EXISTS public.idx_line_score_points_away;

CREATE INDEX IF NOT EXISTS idx_line_score_points_away
    ON public.line_score USING btree
    (points_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_home

-- DROP INDEX IF EXISTS public.idx_line_score_points_home;

CREATE INDEX IF NOT EXISTS idx_line_score_points_home
    ON public.line_score USING btree
    (points_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_over_time10_away

-- DROP INDEX IF EXISTS public.idx_line_score_points_over_time10_away;

CREATE INDEX IF NOT EXISTS idx_line_score_points_over_time10_away
    ON public.line_score USING btree
    (points_over_time10_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_over_time10_home

-- DROP INDEX IF EXISTS public.idx_line_score_points_over_time10_home;

CREATE INDEX IF NOT EXISTS idx_line_score_points_over_time10_home
    ON public.line_score USING btree
    (points_over_time10_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_over_time1_away

-- DROP INDEX IF EXISTS public.idx_line_score_points_over_time1_away;

CREATE INDEX IF NOT EXISTS idx_line_score_points_over_time1_away
    ON public.line_score USING btree
    (points_over_time1_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_over_time1_home

-- DROP INDEX IF EXISTS public.idx_line_score_points_over_time1_home;

CREATE INDEX IF NOT EXISTS idx_line_score_points_over_time1_home
    ON public.line_score USING btree
    (points_over_time1_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_over_time2_away

-- DROP INDEX IF EXISTS public.idx_line_score_points_over_time2_away;

CREATE INDEX IF NOT EXISTS idx_line_score_points_over_time2_away
    ON public.line_score USING btree
    (points_over_time2_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_over_time2_home

-- DROP INDEX IF EXISTS public.idx_line_score_points_over_time2_home;

CREATE INDEX IF NOT EXISTS idx_line_score_points_over_time2_home
    ON public.line_score USING btree
    (points_over_time2_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_over_time3_away

-- DROP INDEX IF EXISTS public.idx_line_score_points_over_time3_away;

CREATE INDEX IF NOT EXISTS idx_line_score_points_over_time3_away
    ON public.line_score USING btree
    (points_over_time3_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_over_time3_home

-- DROP INDEX IF EXISTS public.idx_line_score_points_over_time3_home;

CREATE INDEX IF NOT EXISTS idx_line_score_points_over_time3_home
    ON public.line_score USING btree
    (points_over_time3_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_over_time4_away

-- DROP INDEX IF EXISTS public.idx_line_score_points_over_time4_away;

CREATE INDEX IF NOT EXISTS idx_line_score_points_over_time4_away
    ON public.line_score USING btree
    (points_over_time4_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_over_time4_home

-- DROP INDEX IF EXISTS public.idx_line_score_points_over_time4_home;

CREATE INDEX IF NOT EXISTS idx_line_score_points_over_time4_home
    ON public.line_score USING btree
    (points_over_time4_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_over_time5_away

-- DROP INDEX IF EXISTS public.idx_line_score_points_over_time5_away;

CREATE INDEX IF NOT EXISTS idx_line_score_points_over_time5_away
    ON public.line_score USING btree
    (points_over_time5_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_over_time5_home

-- DROP INDEX IF EXISTS public.idx_line_score_points_over_time5_home;

CREATE INDEX IF NOT EXISTS idx_line_score_points_over_time5_home
    ON public.line_score USING btree
    (points_over_time5_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_over_time6_away

-- DROP INDEX IF EXISTS public.idx_line_score_points_over_time6_away;

CREATE INDEX IF NOT EXISTS idx_line_score_points_over_time6_away
    ON public.line_score USING btree
    (points_over_time6_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_over_time6_home

-- DROP INDEX IF EXISTS public.idx_line_score_points_over_time6_home;

CREATE INDEX IF NOT EXISTS idx_line_score_points_over_time6_home
    ON public.line_score USING btree
    (points_over_time6_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_over_time7_away

-- DROP INDEX IF EXISTS public.idx_line_score_points_over_time7_away;

CREATE INDEX IF NOT EXISTS idx_line_score_points_over_time7_away
    ON public.line_score USING btree
    (points_over_time7_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_over_time7_home

-- DROP INDEX IF EXISTS public.idx_line_score_points_over_time7_home;

CREATE INDEX IF NOT EXISTS idx_line_score_points_over_time7_home
    ON public.line_score USING btree
    (points_over_time7_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_over_time8_away

-- DROP INDEX IF EXISTS public.idx_line_score_points_over_time8_away;

CREATE INDEX IF NOT EXISTS idx_line_score_points_over_time8_away
    ON public.line_score USING btree
    (points_over_time8_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_over_time8_home

-- DROP INDEX IF EXISTS public.idx_line_score_points_over_time8_home;

CREATE INDEX IF NOT EXISTS idx_line_score_points_over_time8_home
    ON public.line_score USING btree
    (points_over_time8_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_over_time9_away

-- DROP INDEX IF EXISTS public.idx_line_score_points_over_time9_away;

CREATE INDEX IF NOT EXISTS idx_line_score_points_over_time9_away
    ON public.line_score USING btree
    (points_over_time9_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_over_time9_home

-- DROP INDEX IF EXISTS public.idx_line_score_points_over_time9_home;

CREATE INDEX IF NOT EXISTS idx_line_score_points_over_time9_home
    ON public.line_score USING btree
    (points_over_time9_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_quarter1_away

-- DROP INDEX IF EXISTS public.idx_line_score_points_quarter1_away;

CREATE INDEX IF NOT EXISTS idx_line_score_points_quarter1_away
    ON public.line_score USING btree
    (points_quarter1_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_quarter1_home

-- DROP INDEX IF EXISTS public.idx_line_score_points_quarter1_home;

CREATE INDEX IF NOT EXISTS idx_line_score_points_quarter1_home
    ON public.line_score USING btree
    (points_quarter1_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_quarter2_away

-- DROP INDEX IF EXISTS public.idx_line_score_points_quarter2_away;

CREATE INDEX IF NOT EXISTS idx_line_score_points_quarter2_away
    ON public.line_score USING btree
    (points_quarter2_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_quarter2_home

-- DROP INDEX IF EXISTS public.idx_line_score_points_quarter2_home;

CREATE INDEX IF NOT EXISTS idx_line_score_points_quarter2_home
    ON public.line_score USING btree
    (points_quarter2_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_quarter3_away

-- DROP INDEX IF EXISTS public.idx_line_score_points_quarter3_away;

CREATE INDEX IF NOT EXISTS idx_line_score_points_quarter3_away
    ON public.line_score USING btree
    (points_quarter3_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_quarter3_home

-- DROP INDEX IF EXISTS public.idx_line_score_points_quarter3_home;

CREATE INDEX IF NOT EXISTS idx_line_score_points_quarter3_home
    ON public.line_score USING btree
    (points_quarter3_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_quarter4_away

-- DROP INDEX IF EXISTS public.idx_line_score_points_quarter4_away;

CREATE INDEX IF NOT EXISTS idx_line_score_points_quarter4_away
    ON public.line_score USING btree
    (points_quarter4_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_points_quarter4_home

-- DROP INDEX IF EXISTS public.idx_line_score_points_quarter4_home;

CREATE INDEX IF NOT EXISTS idx_line_score_points_quarter4_home
    ON public.line_score USING btree
    (points_quarter4_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_team_abbreviation_away

-- DROP INDEX IF EXISTS public.idx_line_score_team_abbreviation_away;

CREATE INDEX IF NOT EXISTS idx_line_score_team_abbreviation_away
    ON public.line_score USING btree
    (team_abbreviation_away COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_team_abbreviation_home

-- DROP INDEX IF EXISTS public.idx_line_score_team_abbreviation_home;

CREATE INDEX IF NOT EXISTS idx_line_score_team_abbreviation_home
    ON public.line_score USING btree
    (team_abbreviation_home COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_team_city_name_away

-- DROP INDEX IF EXISTS public.idx_line_score_team_city_name_away;

CREATE INDEX IF NOT EXISTS idx_line_score_team_city_name_away
    ON public.line_score USING btree
    (team_city_name_away COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_team_city_name_home

-- DROP INDEX IF EXISTS public.idx_line_score_team_city_name_home;

CREATE INDEX IF NOT EXISTS idx_line_score_team_city_name_home
    ON public.line_score USING btree
    (team_city_name_home COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_team_id_away

-- DROP INDEX IF EXISTS public.idx_line_score_team_id_away;

CREATE INDEX IF NOT EXISTS idx_line_score_team_id_away
    ON public.line_score USING btree
    (team_id_away ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_team_id_home

-- DROP INDEX IF EXISTS public.idx_line_score_team_id_home;

CREATE INDEX IF NOT EXISTS idx_line_score_team_id_home
    ON public.line_score USING btree
    (team_id_home ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_team_nickname_away

-- DROP INDEX IF EXISTS public.idx_line_score_team_nickname_away;

CREATE INDEX IF NOT EXISTS idx_line_score_team_nickname_away
    ON public.line_score USING btree
    (team_nickname_away COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_team_nickname_home

-- DROP INDEX IF EXISTS public.idx_line_score_team_nickname_home;

CREATE INDEX IF NOT EXISTS idx_line_score_team_nickname_home
    ON public.line_score USING btree
    (team_nickname_home COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_team_wins_losses_away

-- DROP INDEX IF EXISTS public.idx_line_score_team_wins_losses_away;

CREATE INDEX IF NOT EXISTS idx_line_score_team_wins_losses_away
    ON public.line_score USING btree
    (team_wins_losses_away COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_line_score_team_wins_losses_home

-- DROP INDEX IF EXISTS public.idx_line_score_team_wins_losses_home;

CREATE INDEX IF NOT EXISTS idx_line_score_team_wins_losses_home
    ON public.line_score USING btree
    (team_wins_losses_home COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.officials

-- DROP TABLE IF EXISTS public.officials;

CREATE TABLE IF NOT EXISTS public.officials
(
    game_id integer NOT NULL,
    official_id integer NOT NULL,
    first_name character varying(9) COLLATE pg_catalog."default",
    last_name character varying(12) COLLATE pg_catalog."default",
    jersey_num integer,
    CONSTRAINT officials_pkey PRIMARY KEY (game_id, official_id),
    CONSTRAINT officials_game_id_fkey FOREIGN KEY (game_id)
        REFERENCES public.game (game_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.officials
    OWNER to postgres;

GRANT ALL ON TABLE public.officials TO data_user;

GRANT ALL ON TABLE public.officials TO postgres;
-- Index: idx_officials_first_name

-- DROP INDEX IF EXISTS public.idx_officials_first_name;

CREATE INDEX IF NOT EXISTS idx_officials_first_name
    ON public.officials USING btree
    (first_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_officials_jersey_num

-- DROP INDEX IF EXISTS public.idx_officials_jersey_num;

CREATE INDEX IF NOT EXISTS idx_officials_jersey_num
    ON public.officials USING btree
    (jersey_num ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_officials_last_name

-- DROP INDEX IF EXISTS public.idx_officials_last_name;

CREATE INDEX IF NOT EXISTS idx_officials_last_name
    ON public.officials USING btree
    (last_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_officials_official_id

-- DROP INDEX IF EXISTS public.idx_officials_official_id;

CREATE INDEX IF NOT EXISTS idx_officials_official_id
    ON public.officials USING btree
    (official_id ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.play_by_play

-- DROP TABLE IF EXISTS public.play_by_play;

CREATE TABLE IF NOT EXISTS public.play_by_play
(
    game_id integer NOT NULL,
    eventnum integer NOT NULL,
    eventmsgtype integer,
    eventmsgactiontype integer,
    period integer,
    wctimestring character varying(10) COLLATE pg_catalog."default",
    pctimestring character varying(10) COLLATE pg_catalog."default",
    homedescription character varying(81) COLLATE pg_catalog."default",
    neutraldescription character varying(77) COLLATE pg_catalog."default",
    visitordescription character varying(84) COLLATE pg_catalog."default",
    score character varying(9) COLLATE pg_catalog."default",
    scoremargin character varying(3) COLLATE pg_catalog."default",
    person1type double precision,
    player1_id integer,
    player1_name character varying(24) COLLATE pg_catalog."default",
    player1_team_id double precision,
    player1_team_city character varying(25) COLLATE pg_catalog."default",
    player1_team_nickname character varying(13) COLLATE pg_catalog."default",
    player1_team_abbreviation character varying(3) COLLATE pg_catalog."default",
    person2type double precision,
    player2_id integer,
    player2_name character varying(24) COLLATE pg_catalog."default",
    player2_team_id double precision,
    player2_team_city character varying(25) COLLATE pg_catalog."default",
    player2_team_nickname character varying(13) COLLATE pg_catalog."default",
    player2_team_abbreviation character varying(3) COLLATE pg_catalog."default",
    person3type double precision,
    player3_id integer,
    player3_name character varying(24) COLLATE pg_catalog."default",
    player3_team_id double precision,
    player3_team_city character varying(25) COLLATE pg_catalog."default",
    player3_team_nickname character varying(13) COLLATE pg_catalog."default",
    player3_team_abbreviation character varying(3) COLLATE pg_catalog."default",
    video_available_flag boolean,
    CONSTRAINT play_by_play_pkey PRIMARY KEY (game_id, eventnum),
    CONSTRAINT play_by_play_game_id_fkey FOREIGN KEY (game_id)
        REFERENCES public.game (game_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.play_by_play
    OWNER to postgres;

GRANT ALL ON TABLE public.play_by_play TO data_user;

GRANT ALL ON TABLE public.play_by_play TO postgres;
-- Index: idx_play_by_play_eventmsgactiontype

-- DROP INDEX IF EXISTS public.idx_play_by_play_eventmsgactiontype;

CREATE INDEX IF NOT EXISTS idx_play_by_play_eventmsgactiontype
    ON public.play_by_play USING btree
    (eventmsgactiontype ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_eventmsgtype

-- DROP INDEX IF EXISTS public.idx_play_by_play_eventmsgtype;

CREATE INDEX IF NOT EXISTS idx_play_by_play_eventmsgtype
    ON public.play_by_play USING btree
    (eventmsgtype ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_eventnum

-- DROP INDEX IF EXISTS public.idx_play_by_play_eventnum;

CREATE INDEX IF NOT EXISTS idx_play_by_play_eventnum
    ON public.play_by_play USING btree
    (eventnum ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_homedescription

-- DROP INDEX IF EXISTS public.idx_play_by_play_homedescription;

CREATE INDEX IF NOT EXISTS idx_play_by_play_homedescription
    ON public.play_by_play USING btree
    (homedescription COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_neutraldescription

-- DROP INDEX IF EXISTS public.idx_play_by_play_neutraldescription;

CREATE INDEX IF NOT EXISTS idx_play_by_play_neutraldescription
    ON public.play_by_play USING btree
    (neutraldescription COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_pctimestring

-- DROP INDEX IF EXISTS public.idx_play_by_play_pctimestring;

CREATE INDEX IF NOT EXISTS idx_play_by_play_pctimestring
    ON public.play_by_play USING btree
    (pctimestring COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_period

-- DROP INDEX IF EXISTS public.idx_play_by_play_period;

CREATE INDEX IF NOT EXISTS idx_play_by_play_period
    ON public.play_by_play USING btree
    (period ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_person1type

-- DROP INDEX IF EXISTS public.idx_play_by_play_person1type;

CREATE INDEX IF NOT EXISTS idx_play_by_play_person1type
    ON public.play_by_play USING btree
    (person1type ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_person2type

-- DROP INDEX IF EXISTS public.idx_play_by_play_person2type;

CREATE INDEX IF NOT EXISTS idx_play_by_play_person2type
    ON public.play_by_play USING btree
    (person2type ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_person3type

-- DROP INDEX IF EXISTS public.idx_play_by_play_person3type;

CREATE INDEX IF NOT EXISTS idx_play_by_play_person3type
    ON public.play_by_play USING btree
    (person3type ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_player1_id

-- DROP INDEX IF EXISTS public.idx_play_by_play_player1_id;

CREATE INDEX IF NOT EXISTS idx_play_by_play_player1_id
    ON public.play_by_play USING btree
    (player1_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_player1_name

-- DROP INDEX IF EXISTS public.idx_play_by_play_player1_name;

CREATE INDEX IF NOT EXISTS idx_play_by_play_player1_name
    ON public.play_by_play USING btree
    (player1_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_player1_team_abbreviation

-- DROP INDEX IF EXISTS public.idx_play_by_play_player1_team_abbreviation;

CREATE INDEX IF NOT EXISTS idx_play_by_play_player1_team_abbreviation
    ON public.play_by_play USING btree
    (player1_team_abbreviation COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_player1_team_city

-- DROP INDEX IF EXISTS public.idx_play_by_play_player1_team_city;

CREATE INDEX IF NOT EXISTS idx_play_by_play_player1_team_city
    ON public.play_by_play USING btree
    (player1_team_city COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_player1_team_id

-- DROP INDEX IF EXISTS public.idx_play_by_play_player1_team_id;

CREATE INDEX IF NOT EXISTS idx_play_by_play_player1_team_id
    ON public.play_by_play USING btree
    (player1_team_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_player1_team_nickname

-- DROP INDEX IF EXISTS public.idx_play_by_play_player1_team_nickname;

CREATE INDEX IF NOT EXISTS idx_play_by_play_player1_team_nickname
    ON public.play_by_play USING btree
    (player1_team_nickname COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_player2_id

-- DROP INDEX IF EXISTS public.idx_play_by_play_player2_id;

CREATE INDEX IF NOT EXISTS idx_play_by_play_player2_id
    ON public.play_by_play USING btree
    (player2_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_player2_name

-- DROP INDEX IF EXISTS public.idx_play_by_play_player2_name;

CREATE INDEX IF NOT EXISTS idx_play_by_play_player2_name
    ON public.play_by_play USING btree
    (player2_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_player2_team_abbreviation

-- DROP INDEX IF EXISTS public.idx_play_by_play_player2_team_abbreviation;

CREATE INDEX IF NOT EXISTS idx_play_by_play_player2_team_abbreviation
    ON public.play_by_play USING btree
    (player2_team_abbreviation COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_player2_team_city

-- DROP INDEX IF EXISTS public.idx_play_by_play_player2_team_city;

CREATE INDEX IF NOT EXISTS idx_play_by_play_player2_team_city
    ON public.play_by_play USING btree
    (player2_team_city COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_player2_team_id

-- DROP INDEX IF EXISTS public.idx_play_by_play_player2_team_id;

CREATE INDEX IF NOT EXISTS idx_play_by_play_player2_team_id
    ON public.play_by_play USING btree
    (player2_team_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_player2_team_nickname

-- DROP INDEX IF EXISTS public.idx_play_by_play_player2_team_nickname;

CREATE INDEX IF NOT EXISTS idx_play_by_play_player2_team_nickname
    ON public.play_by_play USING btree
    (player2_team_nickname COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_player3_id

-- DROP INDEX IF EXISTS public.idx_play_by_play_player3_id;

CREATE INDEX IF NOT EXISTS idx_play_by_play_player3_id
    ON public.play_by_play USING btree
    (player3_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_player3_name

-- DROP INDEX IF EXISTS public.idx_play_by_play_player3_name;

CREATE INDEX IF NOT EXISTS idx_play_by_play_player3_name
    ON public.play_by_play USING btree
    (player3_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_player3_team_abbreviation

-- DROP INDEX IF EXISTS public.idx_play_by_play_player3_team_abbreviation;

CREATE INDEX IF NOT EXISTS idx_play_by_play_player3_team_abbreviation
    ON public.play_by_play USING btree
    (player3_team_abbreviation COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_player3_team_city

-- DROP INDEX IF EXISTS public.idx_play_by_play_player3_team_city;

CREATE INDEX IF NOT EXISTS idx_play_by_play_player3_team_city
    ON public.play_by_play USING btree
    (player3_team_city COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_player3_team_id

-- DROP INDEX IF EXISTS public.idx_play_by_play_player3_team_id;

CREATE INDEX IF NOT EXISTS idx_play_by_play_player3_team_id
    ON public.play_by_play USING btree
    (player3_team_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_player3_team_nickname

-- DROP INDEX IF EXISTS public.idx_play_by_play_player3_team_nickname;

CREATE INDEX IF NOT EXISTS idx_play_by_play_player3_team_nickname
    ON public.play_by_play USING btree
    (player3_team_nickname COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_score

-- DROP INDEX IF EXISTS public.idx_play_by_play_score;

CREATE INDEX IF NOT EXISTS idx_play_by_play_score
    ON public.play_by_play USING btree
    (score COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_scoremargin

-- DROP INDEX IF EXISTS public.idx_play_by_play_scoremargin;

CREATE INDEX IF NOT EXISTS idx_play_by_play_scoremargin
    ON public.play_by_play USING btree
    (scoremargin COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_video_available_flag

-- DROP INDEX IF EXISTS public.idx_play_by_play_video_available_flag;

CREATE INDEX IF NOT EXISTS idx_play_by_play_video_available_flag
    ON public.play_by_play USING btree
    (video_available_flag ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_visitordescription

-- DROP INDEX IF EXISTS public.idx_play_by_play_visitordescription;

CREATE INDEX IF NOT EXISTS idx_play_by_play_visitordescription
    ON public.play_by_play USING btree
    (visitordescription COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_play_by_play_wctimestring

-- DROP INDEX IF EXISTS public.idx_play_by_play_wctimestring;

CREATE INDEX IF NOT EXISTS idx_play_by_play_wctimestring
    ON public.play_by_play USING btree
    (wctimestring COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.team_details

-- DROP TABLE IF EXISTS public.team_details;

CREATE TABLE IF NOT EXISTS public.team_details
(
    team_id integer NOT NULL,
    abbreviation character varying(3) COLLATE pg_catalog."default",
    nickname character varying(13) COLLATE pg_catalog."default",
    yearfounded double precision,
    city character varying(13) COLLATE pg_catalog."default",
    arena character varying(26) COLLATE pg_catalog."default",
    arenacapacity double precision,
    owner character varying(35) COLLATE pg_catalog."default",
    generalmanager character varying(18) COLLATE pg_catalog."default",
    headcoach character varying(16) COLLATE pg_catalog."default",
    dleagueaffiliation character varying(33) COLLATE pg_catalog."default",
    facebook character varying(41) COLLATE pg_catalog."default",
    instagram character varying(37) COLLATE pg_catalog."default",
    twitter character varying(35) COLLATE pg_catalog."default",
    CONSTRAINT team_details_pkey PRIMARY KEY (team_id),
    CONSTRAINT team_details_team_id_fkey FOREIGN KEY (team_id)
        REFERENCES public.team (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.team_details
    OWNER to postgres;

GRANT ALL ON TABLE public.team_details TO data_user;

GRANT ALL ON TABLE public.team_details TO postgres;
-- Index: idx_team_details_abbreviation

-- DROP INDEX IF EXISTS public.idx_team_details_abbreviation;

CREATE INDEX IF NOT EXISTS idx_team_details_abbreviation
    ON public.team_details USING btree
    (abbreviation COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_details_arena

-- DROP INDEX IF EXISTS public.idx_team_details_arena;

CREATE INDEX IF NOT EXISTS idx_team_details_arena
    ON public.team_details USING btree
    (arena COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_details_arenacapacity

-- DROP INDEX IF EXISTS public.idx_team_details_arenacapacity;

CREATE INDEX IF NOT EXISTS idx_team_details_arenacapacity
    ON public.team_details USING btree
    (arenacapacity ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_details_city

-- DROP INDEX IF EXISTS public.idx_team_details_city;

CREATE INDEX IF NOT EXISTS idx_team_details_city
    ON public.team_details USING btree
    (city COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_details_dleagueaffiliation

-- DROP INDEX IF EXISTS public.idx_team_details_dleagueaffiliation;

CREATE INDEX IF NOT EXISTS idx_team_details_dleagueaffiliation
    ON public.team_details USING btree
    (dleagueaffiliation COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_details_facebook

-- DROP INDEX IF EXISTS public.idx_team_details_facebook;

CREATE INDEX IF NOT EXISTS idx_team_details_facebook
    ON public.team_details USING btree
    (facebook COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_details_generalmanager

-- DROP INDEX IF EXISTS public.idx_team_details_generalmanager;

CREATE INDEX IF NOT EXISTS idx_team_details_generalmanager
    ON public.team_details USING btree
    (generalmanager COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_details_headcoach

-- DROP INDEX IF EXISTS public.idx_team_details_headcoach;

CREATE INDEX IF NOT EXISTS idx_team_details_headcoach
    ON public.team_details USING btree
    (headcoach COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_details_instagram

-- DROP INDEX IF EXISTS public.idx_team_details_instagram;

CREATE INDEX IF NOT EXISTS idx_team_details_instagram
    ON public.team_details USING btree
    (instagram COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_details_nickname

-- DROP INDEX IF EXISTS public.idx_team_details_nickname;

CREATE INDEX IF NOT EXISTS idx_team_details_nickname
    ON public.team_details USING btree
    (nickname COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_details_owner

-- DROP INDEX IF EXISTS public.idx_team_details_owner;

CREATE INDEX IF NOT EXISTS idx_team_details_owner
    ON public.team_details USING btree
    (owner COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_details_twitter

-- DROP INDEX IF EXISTS public.idx_team_details_twitter;

CREATE INDEX IF NOT EXISTS idx_team_details_twitter
    ON public.team_details USING btree
    (twitter COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_details_yearfounded

-- DROP INDEX IF EXISTS public.idx_team_details_yearfounded;

CREATE INDEX IF NOT EXISTS idx_team_details_yearfounded
    ON public.team_details USING btree
    (yearfounded ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.team_history

-- DROP TABLE IF EXISTS public.team_history;

CREATE TABLE IF NOT EXISTS public.team_history
(
    team_id integer NOT NULL,
    city character varying(25) COLLATE pg_catalog."default",
    nickname character varying(13) COLLATE pg_catalog."default",
    year_founded date NOT NULL,
    year_active_till date,
    CONSTRAINT team_history_pkey PRIMARY KEY (team_id, year_founded),
    CONSTRAINT team_history_team_id_fkey FOREIGN KEY (team_id)
        REFERENCES public.team (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.team_history
    OWNER to postgres;

GRANT ALL ON TABLE public.team_history TO data_user;

GRANT ALL ON TABLE public.team_history TO postgres;
-- Index: idx_team_history_city

-- DROP INDEX IF EXISTS public.idx_team_history_city;

CREATE INDEX IF NOT EXISTS idx_team_history_city
    ON public.team_history USING btree
    (city COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_history_nickname

-- DROP INDEX IF EXISTS public.idx_team_history_nickname;

CREATE INDEX IF NOT EXISTS idx_team_history_nickname
    ON public.team_history USING btree
    (nickname COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_history_year_active_till

-- DROP INDEX IF EXISTS public.idx_team_history_year_active_till;

CREATE INDEX IF NOT EXISTS idx_team_history_year_active_till
    ON public.team_history USING btree
    (year_active_till ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_history_year_founded

-- DROP INDEX IF EXISTS public.idx_team_history_year_founded;

CREATE INDEX IF NOT EXISTS idx_team_history_year_founded
    ON public.team_history USING btree
    (year_founded ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.team_info_common

-- DROP TABLE IF EXISTS public.team_info_common;

CREATE TABLE IF NOT EXISTS public.team_info_common
(
    team_id integer NOT NULL,
    season_year character varying(7) COLLATE pg_catalog."default",
    team_city character varying(13) COLLATE pg_catalog."default",
    team_name character varying(13) COLLATE pg_catalog."default",
    team_abbreviation character varying(3) COLLATE pg_catalog."default",
    team_conference character varying(4) COLLATE pg_catalog."default",
    team_division character varying(9) COLLATE pg_catalog."default",
    team_code character varying(12) COLLATE pg_catalog."default",
    team_slug character varying(12) COLLATE pg_catalog."default",
    win integer,
    lose integer,
    percentage double precision,
    conference_rank integer,
    division_rank integer,
    min_year date,
    max_year date,
    league_id integer,
    season_id integer,
    points_rank integer,
    points_per_game double precision,
    rebound_rank integer,
    rebound_per_game double precision,
    assist_rank integer,
    assist_per_game double precision,
    opponent_points_per_rank integer,
    opponent_points_per_game double precision,
    CONSTRAINT team_info_common_pkey PRIMARY KEY (team_id),
    CONSTRAINT team_info_common_team_id_fkey FOREIGN KEY (team_id)
        REFERENCES public.team (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.team_info_common
    OWNER to postgres;

GRANT ALL ON TABLE public.team_info_common TO data_user;

GRANT ALL ON TABLE public.team_info_common TO postgres;
-- Index: idx_team_info_common_ast_pg

-- DROP INDEX IF EXISTS public.idx_team_info_common_ast_pg;

CREATE INDEX IF NOT EXISTS idx_team_info_common_ast_pg
    ON public.team_info_common USING btree
    (assist_per_game ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_info_common_ast_rank

-- DROP INDEX IF EXISTS public.idx_team_info_common_ast_rank;

CREATE INDEX IF NOT EXISTS idx_team_info_common_ast_rank
    ON public.team_info_common USING btree
    (assist_rank ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_info_common_conf_rank

-- DROP INDEX IF EXISTS public.idx_team_info_common_conf_rank;

CREATE INDEX IF NOT EXISTS idx_team_info_common_conf_rank
    ON public.team_info_common USING btree
    (conference_rank ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_info_common_div_rank

-- DROP INDEX IF EXISTS public.idx_team_info_common_div_rank;

CREATE INDEX IF NOT EXISTS idx_team_info_common_div_rank
    ON public.team_info_common USING btree
    (division_rank ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_info_common_l

-- DROP INDEX IF EXISTS public.idx_team_info_common_l;

CREATE INDEX IF NOT EXISTS idx_team_info_common_l
    ON public.team_info_common USING btree
    (lose ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_info_common_league_id

-- DROP INDEX IF EXISTS public.idx_team_info_common_league_id;

CREATE INDEX IF NOT EXISTS idx_team_info_common_league_id
    ON public.team_info_common USING btree
    (league_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_info_common_max_year

-- DROP INDEX IF EXISTS public.idx_team_info_common_max_year;

CREATE INDEX IF NOT EXISTS idx_team_info_common_max_year
    ON public.team_info_common USING btree
    (max_year ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_info_common_min_year

-- DROP INDEX IF EXISTS public.idx_team_info_common_min_year;

CREATE INDEX IF NOT EXISTS idx_team_info_common_min_year
    ON public.team_info_common USING btree
    (min_year ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_info_common_opp_pts_pg

-- DROP INDEX IF EXISTS public.idx_team_info_common_opp_pts_pg;

CREATE INDEX IF NOT EXISTS idx_team_info_common_opp_pts_pg
    ON public.team_info_common USING btree
    (opponent_points_per_game ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_info_common_opp_pts_rank

-- DROP INDEX IF EXISTS public.idx_team_info_common_opp_pts_rank;

CREATE INDEX IF NOT EXISTS idx_team_info_common_opp_pts_rank
    ON public.team_info_common USING btree
    (opponent_points_per_rank ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_info_common_pct

-- DROP INDEX IF EXISTS public.idx_team_info_common_pct;

CREATE INDEX IF NOT EXISTS idx_team_info_common_pct
    ON public.team_info_common USING btree
    (percentage ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_info_common_pts_pg

-- DROP INDEX IF EXISTS public.idx_team_info_common_pts_pg;

CREATE INDEX IF NOT EXISTS idx_team_info_common_pts_pg
    ON public.team_info_common USING btree
    (points_per_game ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_info_common_pts_rank

-- DROP INDEX IF EXISTS public.idx_team_info_common_pts_rank;

CREATE INDEX IF NOT EXISTS idx_team_info_common_pts_rank
    ON public.team_info_common USING btree
    (points_rank ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_info_common_reb_pg

-- DROP INDEX IF EXISTS public.idx_team_info_common_reb_pg;

CREATE INDEX IF NOT EXISTS idx_team_info_common_reb_pg
    ON public.team_info_common USING btree
    (rebound_per_game ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_info_common_reb_rank

-- DROP INDEX IF EXISTS public.idx_team_info_common_reb_rank;

CREATE INDEX IF NOT EXISTS idx_team_info_common_reb_rank
    ON public.team_info_common USING btree
    (rebound_rank ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_info_common_season_id

-- DROP INDEX IF EXISTS public.idx_team_info_common_season_id;

CREATE INDEX IF NOT EXISTS idx_team_info_common_season_id
    ON public.team_info_common USING btree
    (season_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_info_common_season_year

-- DROP INDEX IF EXISTS public.idx_team_info_common_season_year;

CREATE INDEX IF NOT EXISTS idx_team_info_common_season_year
    ON public.team_info_common USING btree
    (season_year COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_info_common_team_abbreviation

-- DROP INDEX IF EXISTS public.idx_team_info_common_team_abbreviation;

CREATE INDEX IF NOT EXISTS idx_team_info_common_team_abbreviation
    ON public.team_info_common USING btree
    (team_abbreviation COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_info_common_team_city

-- DROP INDEX IF EXISTS public.idx_team_info_common_team_city;

CREATE INDEX IF NOT EXISTS idx_team_info_common_team_city
    ON public.team_info_common USING btree
    (team_city COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_info_common_team_code

-- DROP INDEX IF EXISTS public.idx_team_info_common_team_code;

CREATE INDEX IF NOT EXISTS idx_team_info_common_team_code
    ON public.team_info_common USING btree
    (team_code COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_info_common_team_conference

-- DROP INDEX IF EXISTS public.idx_team_info_common_team_conference;

CREATE INDEX IF NOT EXISTS idx_team_info_common_team_conference
    ON public.team_info_common USING btree
    (team_conference COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_info_common_team_division

-- DROP INDEX IF EXISTS public.idx_team_info_common_team_division;

CREATE INDEX IF NOT EXISTS idx_team_info_common_team_division
    ON public.team_info_common USING btree
    (team_division COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_info_common_team_name

-- DROP INDEX IF EXISTS public.idx_team_info_common_team_name;

CREATE INDEX IF NOT EXISTS idx_team_info_common_team_name
    ON public.team_info_common USING btree
    (team_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_info_common_team_slug

-- DROP INDEX IF EXISTS public.idx_team_info_common_team_slug;

CREATE INDEX IF NOT EXISTS idx_team_info_common_team_slug
    ON public.team_info_common USING btree
    (team_slug COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_team_info_common_w

-- DROP INDEX IF EXISTS public.idx_team_info_common_w;

CREATE INDEX IF NOT EXISTS idx_team_info_common_w
    ON public.team_info_common USING btree
    (win ASC NULLS LAST)
    TABLESPACE pg_default;

\copy play_by_play FROM '/var/lib/postgresql/nba/play_by_play.csv' CSV HEADER
\copy line_score FROM '/var/lib/postgresql/nba/line_score.csv' CSV HEADER
\copy game_info FROM '/var/lib/postgresql/nba/game_info.csv' CSV HEADER
\copy inactive_players FROM '/var/lib/postgresql/nba/inactive_players.csv' CSV HEADER
\copy game_summary FROM '/var/lib/postgresql/nba/game_summary.csv' CSV HEADER
\copy team FROM '/var/lib/postgresql/nba/team.csv' CSV HEADER
\copy team_details FROM '/var/lib/postgresql/nba/team_details.csv' CSV HEADER
\copy team_info_common FROM '/var/lib/postgresql/nba/team_info_common.csv' CSV HEADER
\copy common_player_info FROM '/var/lib/postgresql/nba/common_player_info.csv' CSV HEADER
\copy officials FROM '/var/lib/postgresql/nba/officials.csv' CSV HEADER
\copy team_history FROM '/var/lib/postgresql/nba/team_history.csv' CSV HEADER
\copy draft_history FROM '/var/lib/postgresql/nba/draft_history.csv' CSV HEADER
\copy player FROM '/var/lib/postgresql/nba/player.csv' CSV HEADER
\copy draft_combine_stats FROM '/var/lib/postgresql/nba/draft_combine_stats.csv' CSV HEADER
END;

GRANT ALL PRIVILEGES ON DATABASE nba TO data_user;
GRANT ALL PRIVILEGES ON TABLE play_by_play TO data_user;
GRANT ALL PRIVILEGES ON TABLE line_score TO data_user;
GRANT ALL PRIVILEGES ON TABLE game_info TO data_user;
GRANT ALL PRIVILEGES ON TABLE inactive_players TO data_user;
GRANT ALL PRIVILEGES ON TABLE game_summary TO data_user;
GRANT ALL PRIVILEGES ON TABLE team TO data_user;
GRANT ALL PRIVILEGES ON TABLE team_details TO data_user;
GRANT ALL PRIVILEGES ON TABLE team_info_common TO data_user;
GRANT ALL PRIVILEGES ON TABLE common_player_info TO data_user;
GRANT ALL PRIVILEGES ON TABLE officials TO data_user;
GRANT ALL PRIVILEGES ON TABLE team_history TO data_user;
GRANT ALL PRIVILEGES ON TABLE draft_history TO data_user;
GRANT ALL PRIVILEGES ON TABLE player TO data_user;
GRANT ALL PRIVILEGES ON TABLE draft_combine_stats TO data_user;
GRANT ALL ON SCHEMA public TO data_user;