DROP DATABASE IF EXISTS fifa_23_complete_player;
CREATE DATABASE fifa_23_complete_player;
\c fifa_23_complete_player;

-- Table: public.leagues

-- DROP TABLE IF EXISTS public.leagues;

CREATE TABLE IF NOT EXISTS public.leagues
(
    league_id integer NOT NULL,
    league_name text COLLATE pg_catalog."default",
    league_level integer,
    CONSTRAINT league_pkey PRIMARY KEY (league_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.leagues
    OWNER to postgres;
-- Index: league_index_1

-- DROP INDEX IF EXISTS public.league_index_1;

CREATE INDEX IF NOT EXISTS league_index_1
    ON public.leagues USING btree
    (league_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.nations

-- DROP TABLE IF EXISTS public.nations;

CREATE TABLE IF NOT EXISTS public.nations
(
    nation_id integer NOT NULL,
    nation_name text COLLATE pg_catalog."default",
    CONSTRAINT nationality_pkey PRIMARY KEY (nation_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.nations
    OWNER to postgres;
-- Index: nations_index_1

-- DROP INDEX IF EXISTS public.nations_index_1;

CREATE INDEX IF NOT EXISTS nations_index_1
    ON public.nations USING btree
    (nation_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.coaches

-- DROP TABLE IF EXISTS public.coaches;

CREATE TABLE IF NOT EXISTS public.coaches
(
    coach_id integer NOT NULL,
    coach_url text COLLATE pg_catalog."default",
    short_name text COLLATE pg_catalog."default",
    long_name text COLLATE pg_catalog."default",
    dob date,
    nation_id integer,
    face_url text COLLATE pg_catalog."default",
    gender text COLLATE pg_catalog."default",
    CONSTRAINT coaches_pkey PRIMARY KEY (coach_id),
    CONSTRAINT coaches_nation_id_fkey FOREIGN KEY (nation_id)
        REFERENCES public.nations (nation_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT coaches_nationality_id_fkey FOREIGN KEY (nation_id)
        REFERENCES public.nations (nation_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.coaches
    OWNER to postgres;
-- Index: coaches_index_1

-- DROP INDEX IF EXISTS public.coaches_index_1;

CREATE INDEX IF NOT EXISTS coaches_index_1
    ON public.coaches USING btree
    (dob ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: coaches_index_2

-- DROP INDEX IF EXISTS public.coaches_index_2;

CREATE INDEX IF NOT EXISTS coaches_index_2
    ON public.coaches USING btree
    (long_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: coaches_index_3

-- DROP INDEX IF EXISTS public.coaches_index_3;

CREATE INDEX IF NOT EXISTS coaches_index_3
    ON public.coaches USING btree
    (short_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: coaches_index_4

-- DROP INDEX IF EXISTS public.coaches_index_4;

CREATE INDEX IF NOT EXISTS coaches_index_4
    ON public.coaches USING btree
    (coach_url COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.players

-- DROP TABLE IF EXISTS public.players;

CREATE TABLE IF NOT EXISTS public.players
(
    player_id integer NOT NULL,
    short_name text COLLATE pg_catalog."default",
    long_name text COLLATE pg_catalog."default",
    dob date,
    nation_id integer,
    gender text COLLATE pg_catalog."default",
    CONSTRAINT players_unique_pkey PRIMARY KEY (player_id),
    CONSTRAINT players_nationality_id_fkey FOREIGN KEY (nation_id)
        REFERENCES public.nations (nation_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.players
    OWNER to postgres;
-- Index: players_index_1

-- DROP INDEX IF EXISTS public.players_index_1;

CREATE INDEX IF NOT EXISTS players_index_1
    ON public.players USING btree
    (short_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_index_2

-- DROP INDEX IF EXISTS public.players_index_2;

CREATE INDEX IF NOT EXISTS players_index_2
    ON public.players USING btree
    (long_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_index_3

-- DROP INDEX IF EXISTS public.players_index_3;

CREATE INDEX IF NOT EXISTS players_index_3
    ON public.players USING btree
    (dob ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_index_4

-- DROP INDEX IF EXISTS public.players_index_4;

CREATE INDEX IF NOT EXISTS players_index_4
    ON public.players USING btree
    (nation_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Table: public.teams

-- DROP TABLE IF EXISTS public.teams;

CREATE TABLE IF NOT EXISTS public.teams
(
    team_id integer NOT NULL,
    team_name text COLLATE pg_catalog."default",
    league_id integer,
    nation_id integer,
    rival_team_id integer,
    gender text COLLATE pg_catalog."default",
    CONSTRAINT teams_pkey PRIMARY KEY (team_id),
    CONSTRAINT teams_league_id_fkey FOREIGN KEY (league_id)
        REFERENCES public.leagues (league_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT teams_nationality_id_fkey FOREIGN KEY (nation_id)
        REFERENCES public.nations (nation_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT teams_rival_team_id_fkey FOREIGN KEY (rival_team_id)
        REFERENCES public.teams (team_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.teams
    OWNER to postgres;
-- Index: teams_index_1

-- DROP INDEX IF EXISTS public.teams_index_1;

CREATE INDEX IF NOT EXISTS teams_index_1
    ON public.teams USING btree
    (team_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Table: public.players_update_history

-- DROP TABLE IF EXISTS public.players_update_history;

CREATE TABLE IF NOT EXISTS public.players_update_history
(
    player_id integer NOT NULL,
    player_url text COLLATE pg_catalog."default",
    fifa_version integer NOT NULL,
    fifa_update integer NOT NULL,
    fifa_update_date date,
    player_positions text COLLATE pg_catalog."default",
    overall integer,
    potential integer,
    value_eur bigint,
    wage_eur integer,
    age integer,
    height_cm integer,
    weight_kg integer,
    club_team_id integer,
    club_position text COLLATE pg_catalog."default",
    club_jersey_number integer,
    club_loaned_from text COLLATE pg_catalog."default",
    club_joined_date date,
    club_contract_valid_until_year integer,
    nation_position text COLLATE pg_catalog."default",
    nation_jersey_number integer,
    preferred_foot text COLLATE pg_catalog."default",
    weak_foot integer,
    skill_moves integer,
    international_reputation integer,
    work_rate text COLLATE pg_catalog."default",
    body_type text COLLATE pg_catalog."default",
    real_face text COLLATE pg_catalog."default",
    release_clause_eur bigint,
    player_tags text COLLATE pg_catalog."default",
    player_traits text COLLATE pg_catalog."default",
    pace integer,
    shooting integer,
    passing integer,
    dribbling integer,
    defending integer,
    physic integer,
    attacking_crossing integer,
    attacking_finishing integer,
    attacking_heading_accuracy integer,
    attacking_short_passing integer,
    attacking_volleys integer,
    skill_dribbling integer,
    skill_curve integer,
    skill_fk_accuracy integer,
    skill_long_passing integer,
    skill_ball_control integer,
    movement_acceleration integer,
    movement_sprint_speed integer,
    movement_agility integer,
    movement_reactions integer,
    movement_balance integer,
    power_shot_power integer,
    power_jumping integer,
    power_stamina integer,
    power_strength integer,
    power_long_shots integer,
    mentality_aggression integer,
    mentality_interceptions integer,
    mentality_positioning integer,
    mentality_vision integer,
    mentality_penalties integer,
    mentality_composure integer,
    defending_marking_awareness integer,
    defending_standing_tackle integer,
    defending_sliding_tackle integer,
    goalkeeping_diving integer,
    goalkeeping_handling integer,
    goalkeeping_kicking integer,
    goalkeeping_positioning integer,
    goalkeeping_reflexes integer,
    goalkeeping_speed integer,
    ls integer,
    st integer,
    rs integer,
    lw integer,
    lf integer,
    cf integer,
    rf integer,
    rw integer,
    lam integer,
    cam integer,
    ram integer,
    lm integer,
    lcm integer,
    cm integer,
    rcm integer,
    rm integer,
    lwb integer,
    ldm integer,
    cdm integer,
    rdm integer,
    rwb integer,
    lb integer,
    lcb integer,
    cb integer,
    rcb integer,
    rb integer,
    gk integer,
    CONSTRAINT players_update_id PRIMARY KEY (player_id, fifa_version, fifa_update),
    CONSTRAINT players_update_history_club_team_id_fkey FOREIGN KEY (club_team_id)
        REFERENCES public.teams (team_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT players_update_history_player_id_fkey FOREIGN KEY (player_id)
        REFERENCES public.players (player_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.players_update_history
    OWNER to postgres;
-- Index: players_update_history_index_1

-- DROP INDEX IF EXISTS public.players_update_history_index_1;

CREATE INDEX IF NOT EXISTS players_update_history_index_1
    ON public.players_update_history USING btree
    (player_url COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_10

-- DROP INDEX IF EXISTS public.players_update_history_index_10;

CREATE INDEX IF NOT EXISTS players_update_history_index_10
    ON public.players_update_history USING btree
    (club_jersey_number ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_11

-- DROP INDEX IF EXISTS public.players_update_history_index_11;

CREATE INDEX IF NOT EXISTS players_update_history_index_11
    ON public.players_update_history USING btree
    (club_loaned_from COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_12

-- DROP INDEX IF EXISTS public.players_update_history_index_12;

CREATE INDEX IF NOT EXISTS players_update_history_index_12
    ON public.players_update_history USING btree
    (club_joined_date ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_13

-- DROP INDEX IF EXISTS public.players_update_history_index_13;

CREATE INDEX IF NOT EXISTS players_update_history_index_13
    ON public.players_update_history USING btree
    (club_contract_valid_until_year ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_14

-- DROP INDEX IF EXISTS public.players_update_history_index_14;

CREATE INDEX IF NOT EXISTS players_update_history_index_14
    ON public.players_update_history USING btree
    (nation_position COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_15

-- DROP INDEX IF EXISTS public.players_update_history_index_15;

CREATE INDEX IF NOT EXISTS players_update_history_index_15
    ON public.players_update_history USING btree
    (nation_jersey_number ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_16

-- DROP INDEX IF EXISTS public.players_update_history_index_16;

CREATE INDEX IF NOT EXISTS players_update_history_index_16
    ON public.players_update_history USING btree
    (skill_moves ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_17

-- DROP INDEX IF EXISTS public.players_update_history_index_17;

CREATE INDEX IF NOT EXISTS players_update_history_index_17
    ON public.players_update_history USING btree
    (international_reputation ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_18

-- DROP INDEX IF EXISTS public.players_update_history_index_18;

CREATE INDEX IF NOT EXISTS players_update_history_index_18
    ON public.players_update_history USING btree
    (work_rate COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_19

-- DROP INDEX IF EXISTS public.players_update_history_index_19;

CREATE INDEX IF NOT EXISTS players_update_history_index_19
    ON public.players_update_history USING btree
    (release_clause_eur ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_2

-- DROP INDEX IF EXISTS public.players_update_history_index_2;

CREATE INDEX IF NOT EXISTS players_update_history_index_2
    ON public.players_update_history USING btree
    (fifa_update_date ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_20

-- DROP INDEX IF EXISTS public.players_update_history_index_20;

CREATE INDEX IF NOT EXISTS players_update_history_index_20
    ON public.players_update_history USING btree
    (player_traits COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_21

-- DROP INDEX IF EXISTS public.players_update_history_index_21;

CREATE INDEX IF NOT EXISTS players_update_history_index_21
    ON public.players_update_history USING btree
    (pace ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_22

-- DROP INDEX IF EXISTS public.players_update_history_index_22;

CREATE INDEX IF NOT EXISTS players_update_history_index_22
    ON public.players_update_history USING btree
    (shooting ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_23

-- DROP INDEX IF EXISTS public.players_update_history_index_23;

CREATE INDEX IF NOT EXISTS players_update_history_index_23
    ON public.players_update_history USING btree
    (passing ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_24

-- DROP INDEX IF EXISTS public.players_update_history_index_24;

CREATE INDEX IF NOT EXISTS players_update_history_index_24
    ON public.players_update_history USING btree
    (dribbling ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_25

-- DROP INDEX IF EXISTS public.players_update_history_index_25;

CREATE INDEX IF NOT EXISTS players_update_history_index_25
    ON public.players_update_history USING btree
    (defending ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_26

-- DROP INDEX IF EXISTS public.players_update_history_index_26;

CREATE INDEX IF NOT EXISTS players_update_history_index_26
    ON public.players_update_history USING btree
    (physic ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_27

-- DROP INDEX IF EXISTS public.players_update_history_index_27;

CREATE INDEX IF NOT EXISTS players_update_history_index_27
    ON public.players_update_history USING btree
    (attacking_crossing ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_28

-- DROP INDEX IF EXISTS public.players_update_history_index_28;

CREATE INDEX IF NOT EXISTS players_update_history_index_28
    ON public.players_update_history USING btree
    (attacking_finishing ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_29

-- DROP INDEX IF EXISTS public.players_update_history_index_29;

CREATE INDEX IF NOT EXISTS players_update_history_index_29
    ON public.players_update_history USING btree
    (attacking_heading_accuracy ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_3

-- DROP INDEX IF EXISTS public.players_update_history_index_3;

CREATE INDEX IF NOT EXISTS players_update_history_index_3
    ON public.players_update_history USING btree
    (player_positions COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_30

-- DROP INDEX IF EXISTS public.players_update_history_index_30;

CREATE INDEX IF NOT EXISTS players_update_history_index_30
    ON public.players_update_history USING btree
    (attacking_short_passing ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_31

-- DROP INDEX IF EXISTS public.players_update_history_index_31;

CREATE INDEX IF NOT EXISTS players_update_history_index_31
    ON public.players_update_history USING btree
    (attacking_volleys ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_32

-- DROP INDEX IF EXISTS public.players_update_history_index_32;

CREATE INDEX IF NOT EXISTS players_update_history_index_32
    ON public.players_update_history USING btree
    (skill_dribbling ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_33

-- DROP INDEX IF EXISTS public.players_update_history_index_33;

CREATE INDEX IF NOT EXISTS players_update_history_index_33
    ON public.players_update_history USING btree
    (skill_curve ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_34

-- DROP INDEX IF EXISTS public.players_update_history_index_34;

CREATE INDEX IF NOT EXISTS players_update_history_index_34
    ON public.players_update_history USING btree
    (skill_fk_accuracy ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_35

-- DROP INDEX IF EXISTS public.players_update_history_index_35;

CREATE INDEX IF NOT EXISTS players_update_history_index_35
    ON public.players_update_history USING btree
    (skill_long_passing ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_36

-- DROP INDEX IF EXISTS public.players_update_history_index_36;

CREATE INDEX IF NOT EXISTS players_update_history_index_36
    ON public.players_update_history USING btree
    (skill_ball_control ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_37

-- DROP INDEX IF EXISTS public.players_update_history_index_37;

CREATE INDEX IF NOT EXISTS players_update_history_index_37
    ON public.players_update_history USING btree
    (movement_acceleration ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_38

-- DROP INDEX IF EXISTS public.players_update_history_index_38;

CREATE INDEX IF NOT EXISTS players_update_history_index_38
    ON public.players_update_history USING btree
    (movement_sprint_speed ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_39

-- DROP INDEX IF EXISTS public.players_update_history_index_39;

CREATE INDEX IF NOT EXISTS players_update_history_index_39
    ON public.players_update_history USING btree
    (movement_agility ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_4

-- DROP INDEX IF EXISTS public.players_update_history_index_4;

CREATE INDEX IF NOT EXISTS players_update_history_index_4
    ON public.players_update_history USING btree
    (overall ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_40

-- DROP INDEX IF EXISTS public.players_update_history_index_40;

CREATE INDEX IF NOT EXISTS players_update_history_index_40
    ON public.players_update_history USING btree
    (movement_reactions ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_41

-- DROP INDEX IF EXISTS public.players_update_history_index_41;

CREATE INDEX IF NOT EXISTS players_update_history_index_41
    ON public.players_update_history USING btree
    (movement_balance ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_42

-- DROP INDEX IF EXISTS public.players_update_history_index_42;

CREATE INDEX IF NOT EXISTS players_update_history_index_42
    ON public.players_update_history USING btree
    (power_shot_power ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_43

-- DROP INDEX IF EXISTS public.players_update_history_index_43;

CREATE INDEX IF NOT EXISTS players_update_history_index_43
    ON public.players_update_history USING btree
    (power_jumping ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_44

-- DROP INDEX IF EXISTS public.players_update_history_index_44;

CREATE INDEX IF NOT EXISTS players_update_history_index_44
    ON public.players_update_history USING btree
    (power_stamina ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_45

-- DROP INDEX IF EXISTS public.players_update_history_index_45;

CREATE INDEX IF NOT EXISTS players_update_history_index_45
    ON public.players_update_history USING btree
    (power_strength ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_46

-- DROP INDEX IF EXISTS public.players_update_history_index_46;

CREATE INDEX IF NOT EXISTS players_update_history_index_46
    ON public.players_update_history USING btree
    (power_long_shots ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_47

-- DROP INDEX IF EXISTS public.players_update_history_index_47;

CREATE INDEX IF NOT EXISTS players_update_history_index_47
    ON public.players_update_history USING btree
    (mentality_aggression ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_48

-- DROP INDEX IF EXISTS public.players_update_history_index_48;

CREATE INDEX IF NOT EXISTS players_update_history_index_48
    ON public.players_update_history USING btree
    (mentality_interceptions ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_49

-- DROP INDEX IF EXISTS public.players_update_history_index_49;

CREATE INDEX IF NOT EXISTS players_update_history_index_49
    ON public.players_update_history USING btree
    (mentality_positioning ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_5

-- DROP INDEX IF EXISTS public.players_update_history_index_5;

CREATE INDEX IF NOT EXISTS players_update_history_index_5
    ON public.players_update_history USING btree
    (potential ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_50

-- DROP INDEX IF EXISTS public.players_update_history_index_50;

CREATE INDEX IF NOT EXISTS players_update_history_index_50
    ON public.players_update_history USING btree
    (mentality_vision ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_51

-- DROP INDEX IF EXISTS public.players_update_history_index_51;

CREATE INDEX IF NOT EXISTS players_update_history_index_51
    ON public.players_update_history USING btree
    (mentality_penalties ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_52

-- DROP INDEX IF EXISTS public.players_update_history_index_52;

CREATE INDEX IF NOT EXISTS players_update_history_index_52
    ON public.players_update_history USING btree
    (mentality_composure ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_53

-- DROP INDEX IF EXISTS public.players_update_history_index_53;

CREATE INDEX IF NOT EXISTS players_update_history_index_53
    ON public.players_update_history USING btree
    (defending_marking_awareness ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_54

-- DROP INDEX IF EXISTS public.players_update_history_index_54;

CREATE INDEX IF NOT EXISTS players_update_history_index_54
    ON public.players_update_history USING btree
    (defending_standing_tackle ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_55

-- DROP INDEX IF EXISTS public.players_update_history_index_55;

CREATE INDEX IF NOT EXISTS players_update_history_index_55
    ON public.players_update_history USING btree
    (defending_sliding_tackle ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_56

-- DROP INDEX IF EXISTS public.players_update_history_index_56;

CREATE INDEX IF NOT EXISTS players_update_history_index_56
    ON public.players_update_history USING btree
    (goalkeeping_diving ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_57

-- DROP INDEX IF EXISTS public.players_update_history_index_57;

CREATE INDEX IF NOT EXISTS players_update_history_index_57
    ON public.players_update_history USING btree
    (goalkeeping_handling ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_58

-- DROP INDEX IF EXISTS public.players_update_history_index_58;

CREATE INDEX IF NOT EXISTS players_update_history_index_58
    ON public.players_update_history USING btree
    (goalkeeping_kicking ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_59

-- DROP INDEX IF EXISTS public.players_update_history_index_59;

CREATE INDEX IF NOT EXISTS players_update_history_index_59
    ON public.players_update_history USING btree
    (goalkeeping_positioning ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_6

-- DROP INDEX IF EXISTS public.players_update_history_index_6;

CREATE INDEX IF NOT EXISTS players_update_history_index_6
    ON public.players_update_history USING btree
    (age ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_60

-- DROP INDEX IF EXISTS public.players_update_history_index_60;

CREATE INDEX IF NOT EXISTS players_update_history_index_60
    ON public.players_update_history USING btree
    (goalkeeping_reflexes ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_61

-- DROP INDEX IF EXISTS public.players_update_history_index_61;

CREATE INDEX IF NOT EXISTS players_update_history_index_61
    ON public.players_update_history USING btree
    (goalkeeping_speed ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_62

-- DROP INDEX IF EXISTS public.players_update_history_index_62;

CREATE INDEX IF NOT EXISTS players_update_history_index_62
    ON public.players_update_history USING btree
    (ls ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_63

-- DROP INDEX IF EXISTS public.players_update_history_index_63;

CREATE INDEX IF NOT EXISTS players_update_history_index_63
    ON public.players_update_history USING btree
    (st ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_64

-- DROP INDEX IF EXISTS public.players_update_history_index_64;

CREATE INDEX IF NOT EXISTS players_update_history_index_64
    ON public.players_update_history USING btree
    (rs ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_65

-- DROP INDEX IF EXISTS public.players_update_history_index_65;

CREATE INDEX IF NOT EXISTS players_update_history_index_65
    ON public.players_update_history USING btree
    (lw ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_66

-- DROP INDEX IF EXISTS public.players_update_history_index_66;

CREATE INDEX IF NOT EXISTS players_update_history_index_66
    ON public.players_update_history USING btree
    (lf ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_67

-- DROP INDEX IF EXISTS public.players_update_history_index_67;

CREATE INDEX IF NOT EXISTS players_update_history_index_67
    ON public.players_update_history USING btree
    (cf ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_68

-- DROP INDEX IF EXISTS public.players_update_history_index_68;

CREATE INDEX IF NOT EXISTS players_update_history_index_68
    ON public.players_update_history USING btree
    (rf ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_69

-- DROP INDEX IF EXISTS public.players_update_history_index_69;

CREATE INDEX IF NOT EXISTS players_update_history_index_69
    ON public.players_update_history USING btree
    (rw ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_7

-- DROP INDEX IF EXISTS public.players_update_history_index_7;

CREATE INDEX IF NOT EXISTS players_update_history_index_7
    ON public.players_update_history USING btree
    (height_cm ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_70

-- DROP INDEX IF EXISTS public.players_update_history_index_70;

CREATE INDEX IF NOT EXISTS players_update_history_index_70
    ON public.players_update_history USING btree
    (lam ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_71

-- DROP INDEX IF EXISTS public.players_update_history_index_71;

CREATE INDEX IF NOT EXISTS players_update_history_index_71
    ON public.players_update_history USING btree
    (cam ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_72

-- DROP INDEX IF EXISTS public.players_update_history_index_72;

CREATE INDEX IF NOT EXISTS players_update_history_index_72
    ON public.players_update_history USING btree
    (ram ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_73

-- DROP INDEX IF EXISTS public.players_update_history_index_73;

CREATE INDEX IF NOT EXISTS players_update_history_index_73
    ON public.players_update_history USING btree
    (lm ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_74

-- DROP INDEX IF EXISTS public.players_update_history_index_74;

CREATE INDEX IF NOT EXISTS players_update_history_index_74
    ON public.players_update_history USING btree
    (lcm ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_75

-- DROP INDEX IF EXISTS public.players_update_history_index_75;

CREATE INDEX IF NOT EXISTS players_update_history_index_75
    ON public.players_update_history USING btree
    (cm ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_76

-- DROP INDEX IF EXISTS public.players_update_history_index_76;

CREATE INDEX IF NOT EXISTS players_update_history_index_76
    ON public.players_update_history USING btree
    (rcm ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_77

-- DROP INDEX IF EXISTS public.players_update_history_index_77;

CREATE INDEX IF NOT EXISTS players_update_history_index_77
    ON public.players_update_history USING btree
    (rm ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_78

-- DROP INDEX IF EXISTS public.players_update_history_index_78;

CREATE INDEX IF NOT EXISTS players_update_history_index_78
    ON public.players_update_history USING btree
    (lwb ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_79

-- DROP INDEX IF EXISTS public.players_update_history_index_79;

CREATE INDEX IF NOT EXISTS players_update_history_index_79
    ON public.players_update_history USING btree
    (ldm ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_8

-- DROP INDEX IF EXISTS public.players_update_history_index_8;

CREATE INDEX IF NOT EXISTS players_update_history_index_8
    ON public.players_update_history USING btree
    (weight_kg ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_80

-- DROP INDEX IF EXISTS public.players_update_history_index_80;

CREATE INDEX IF NOT EXISTS players_update_history_index_80
    ON public.players_update_history USING btree
    (cdm ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_81

-- DROP INDEX IF EXISTS public.players_update_history_index_81;

CREATE INDEX IF NOT EXISTS players_update_history_index_81
    ON public.players_update_history USING btree
    (rdm ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_82

-- DROP INDEX IF EXISTS public.players_update_history_index_82;

CREATE INDEX IF NOT EXISTS players_update_history_index_82
    ON public.players_update_history USING btree
    (rwb ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_83

-- DROP INDEX IF EXISTS public.players_update_history_index_83;

CREATE INDEX IF NOT EXISTS players_update_history_index_83
    ON public.players_update_history USING btree
    (lb ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_84

-- DROP INDEX IF EXISTS public.players_update_history_index_84;

CREATE INDEX IF NOT EXISTS players_update_history_index_84
    ON public.players_update_history USING btree
    (lcb ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_85

-- DROP INDEX IF EXISTS public.players_update_history_index_85;

CREATE INDEX IF NOT EXISTS players_update_history_index_85
    ON public.players_update_history USING btree
    (cb ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_86

-- DROP INDEX IF EXISTS public.players_update_history_index_86;

CREATE INDEX IF NOT EXISTS players_update_history_index_86
    ON public.players_update_history USING btree
    (rcb ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_87

-- DROP INDEX IF EXISTS public.players_update_history_index_87;

CREATE INDEX IF NOT EXISTS players_update_history_index_87
    ON public.players_update_history USING btree
    (rb ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_88

-- DROP INDEX IF EXISTS public.players_update_history_index_88;

CREATE INDEX IF NOT EXISTS players_update_history_index_88
    ON public.players_update_history USING btree
    (gk ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: players_update_history_index_9

-- DROP INDEX IF EXISTS public.players_update_history_index_9;

CREATE INDEX IF NOT EXISTS players_update_history_index_9
    ON public.players_update_history USING btree
    (club_position COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.teams_update_history

-- DROP TABLE IF EXISTS public.teams_update_history;

CREATE TABLE IF NOT EXISTS public.teams_update_history
(
    team_id integer NOT NULL,
    team_url text COLLATE pg_catalog."default",
    fifa_version integer NOT NULL,
    fifa_update integer NOT NULL,
    fifa_update_date date,
    overall integer,
    attack integer,
    midfield integer,
    defence integer,
    coach_id integer,
    home_stadium text COLLATE pg_catalog."default",
    international_prestige integer,
    domestic_prestige integer,
    transfer_budget_eur integer,
    club_worth_eur integer,
    starting_xi_average_age double precision,
    whole_team_average_age double precision,
    captain integer,
    short_free_kick integer,
    long_free_kick integer,
    left_short_free_kick integer,
    right_short_free_kick integer,
    penalties integer,
    left_corner integer,
    right_corner integer,
    def_style text COLLATE pg_catalog."default",
    def_team_width integer,
    def_team_depth integer,
    def_defence_pressure integer,
    def_defence_aggression integer,
    def_defence_width integer,
    def_defence_defender_line text COLLATE pg_catalog."default",
    off_style text COLLATE pg_catalog."default",
    off_build_up_play text COLLATE pg_catalog."default",
    off_chance_creation text COLLATE pg_catalog."default",
    off_team_width integer,
    off_players_in_box integer,
    off_corners integer,
    off_free_kicks integer,
    build_up_play_speed integer,
    build_up_play_dribbling integer,
    build_up_play_passing integer,
    build_up_play_positioning text COLLATE pg_catalog."default",
    chance_creation_passing integer,
    chance_creation_crossing integer,
    chance_creation_shooting integer,
    chance_creation_positioning text COLLATE pg_catalog."default",
    CONSTRAINT teams_update_id PRIMARY KEY (team_id, fifa_version, fifa_update),
    CONSTRAINT teams_update_history_coach_id_fkey FOREIGN KEY (coach_id)
        REFERENCES public.coaches (coach_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT teams_update_history_team_id_fkey FOREIGN KEY (team_id)
        REFERENCES public.teams (team_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.teams_update_history
    OWNER to postgres;
-- Index: teams_update_history_index_1

-- DROP INDEX IF EXISTS public.teams_update_history_index_1;

CREATE INDEX IF NOT EXISTS teams_update_history_index_1
    ON public.teams_update_history USING btree
    (team_url COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_10

-- DROP INDEX IF EXISTS public.teams_update_history_index_10;

CREATE INDEX IF NOT EXISTS teams_update_history_index_10
    ON public.teams_update_history USING btree
    (transfer_budget_eur ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_11

-- DROP INDEX IF EXISTS public.teams_update_history_index_11;

CREATE INDEX IF NOT EXISTS teams_update_history_index_11
    ON public.teams_update_history USING btree
    (club_worth_eur ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_12

-- DROP INDEX IF EXISTS public.teams_update_history_index_12;

CREATE INDEX IF NOT EXISTS teams_update_history_index_12
    ON public.teams_update_history USING btree
    (starting_xi_average_age ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_13

-- DROP INDEX IF EXISTS public.teams_update_history_index_13;

CREATE INDEX IF NOT EXISTS teams_update_history_index_13
    ON public.teams_update_history USING btree
    (whole_team_average_age ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_14

-- DROP INDEX IF EXISTS public.teams_update_history_index_14;

CREATE INDEX IF NOT EXISTS teams_update_history_index_14
    ON public.teams_update_history USING btree
    (captain ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_15

-- DROP INDEX IF EXISTS public.teams_update_history_index_15;

CREATE INDEX IF NOT EXISTS teams_update_history_index_15
    ON public.teams_update_history USING btree
    (short_free_kick ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_16

-- DROP INDEX IF EXISTS public.teams_update_history_index_16;

CREATE INDEX IF NOT EXISTS teams_update_history_index_16
    ON public.teams_update_history USING btree
    (long_free_kick ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_17

-- DROP INDEX IF EXISTS public.teams_update_history_index_17;

CREATE INDEX IF NOT EXISTS teams_update_history_index_17
    ON public.teams_update_history USING btree
    (left_short_free_kick ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_18

-- DROP INDEX IF EXISTS public.teams_update_history_index_18;

CREATE INDEX IF NOT EXISTS teams_update_history_index_18
    ON public.teams_update_history USING btree
    (right_short_free_kick ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_19

-- DROP INDEX IF EXISTS public.teams_update_history_index_19;

CREATE INDEX IF NOT EXISTS teams_update_history_index_19
    ON public.teams_update_history USING btree
    (penalties ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_2

-- DROP INDEX IF EXISTS public.teams_update_history_index_2;

CREATE INDEX IF NOT EXISTS teams_update_history_index_2
    ON public.teams_update_history USING btree
    (fifa_update_date ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_20

-- DROP INDEX IF EXISTS public.teams_update_history_index_20;

CREATE INDEX IF NOT EXISTS teams_update_history_index_20
    ON public.teams_update_history USING btree
    (left_corner ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_21

-- DROP INDEX IF EXISTS public.teams_update_history_index_21;

CREATE INDEX IF NOT EXISTS teams_update_history_index_21
    ON public.teams_update_history USING btree
    (right_corner ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_22

-- DROP INDEX IF EXISTS public.teams_update_history_index_22;

CREATE INDEX IF NOT EXISTS teams_update_history_index_22
    ON public.teams_update_history USING btree
    (def_style COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_23

-- DROP INDEX IF EXISTS public.teams_update_history_index_23;

CREATE INDEX IF NOT EXISTS teams_update_history_index_23
    ON public.teams_update_history USING btree
    (def_team_width ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_24

-- DROP INDEX IF EXISTS public.teams_update_history_index_24;

CREATE INDEX IF NOT EXISTS teams_update_history_index_24
    ON public.teams_update_history USING btree
    (def_team_depth ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_25

-- DROP INDEX IF EXISTS public.teams_update_history_index_25;

CREATE INDEX IF NOT EXISTS teams_update_history_index_25
    ON public.teams_update_history USING btree
    (def_defence_pressure ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_26

-- DROP INDEX IF EXISTS public.teams_update_history_index_26;

CREATE INDEX IF NOT EXISTS teams_update_history_index_26
    ON public.teams_update_history USING btree
    (def_defence_aggression ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_27

-- DROP INDEX IF EXISTS public.teams_update_history_index_27;

CREATE INDEX IF NOT EXISTS teams_update_history_index_27
    ON public.teams_update_history USING btree
    (def_defence_width ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_28

-- DROP INDEX IF EXISTS public.teams_update_history_index_28;

CREATE INDEX IF NOT EXISTS teams_update_history_index_28
    ON public.teams_update_history USING btree
    (def_defence_defender_line COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_29

-- DROP INDEX IF EXISTS public.teams_update_history_index_29;

CREATE INDEX IF NOT EXISTS teams_update_history_index_29
    ON public.teams_update_history USING btree
    (off_style COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_3

-- DROP INDEX IF EXISTS public.teams_update_history_index_3;

CREATE INDEX IF NOT EXISTS teams_update_history_index_3
    ON public.teams_update_history USING btree
    (overall ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_30

-- DROP INDEX IF EXISTS public.teams_update_history_index_30;

CREATE INDEX IF NOT EXISTS teams_update_history_index_30
    ON public.teams_update_history USING btree
    (off_build_up_play COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_31

-- DROP INDEX IF EXISTS public.teams_update_history_index_31;

CREATE INDEX IF NOT EXISTS teams_update_history_index_31
    ON public.teams_update_history USING btree
    (off_chance_creation COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_32

-- DROP INDEX IF EXISTS public.teams_update_history_index_32;

CREATE INDEX IF NOT EXISTS teams_update_history_index_32
    ON public.teams_update_history USING btree
    (off_team_width ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_33

-- DROP INDEX IF EXISTS public.teams_update_history_index_33;

CREATE INDEX IF NOT EXISTS teams_update_history_index_33
    ON public.teams_update_history USING btree
    (off_players_in_box ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_34

-- DROP INDEX IF EXISTS public.teams_update_history_index_34;

CREATE INDEX IF NOT EXISTS teams_update_history_index_34
    ON public.teams_update_history USING btree
    (off_corners ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_35

-- DROP INDEX IF EXISTS public.teams_update_history_index_35;

CREATE INDEX IF NOT EXISTS teams_update_history_index_35
    ON public.teams_update_history USING btree
    (off_free_kicks ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_36

-- DROP INDEX IF EXISTS public.teams_update_history_index_36;

CREATE INDEX IF NOT EXISTS teams_update_history_index_36
    ON public.teams_update_history USING btree
    (build_up_play_speed ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_37

-- DROP INDEX IF EXISTS public.teams_update_history_index_37;

CREATE INDEX IF NOT EXISTS teams_update_history_index_37
    ON public.teams_update_history USING btree
    (build_up_play_dribbling ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_38

-- DROP INDEX IF EXISTS public.teams_update_history_index_38;

CREATE INDEX IF NOT EXISTS teams_update_history_index_38
    ON public.teams_update_history USING btree
    (build_up_play_passing ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_39

-- DROP INDEX IF EXISTS public.teams_update_history_index_39;

CREATE INDEX IF NOT EXISTS teams_update_history_index_39
    ON public.teams_update_history USING btree
    (build_up_play_positioning COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_4

-- DROP INDEX IF EXISTS public.teams_update_history_index_4;

CREATE INDEX IF NOT EXISTS teams_update_history_index_4
    ON public.teams_update_history USING btree
    (attack ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_40

-- DROP INDEX IF EXISTS public.teams_update_history_index_40;

CREATE INDEX IF NOT EXISTS teams_update_history_index_40
    ON public.teams_update_history USING btree
    (chance_creation_passing ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_41

-- DROP INDEX IF EXISTS public.teams_update_history_index_41;

CREATE INDEX IF NOT EXISTS teams_update_history_index_41
    ON public.teams_update_history USING btree
    (chance_creation_crossing ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_42

-- DROP INDEX IF EXISTS public.teams_update_history_index_42;

CREATE INDEX IF NOT EXISTS teams_update_history_index_42
    ON public.teams_update_history USING btree
    (chance_creation_shooting ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_43

-- DROP INDEX IF EXISTS public.teams_update_history_index_43;

CREATE INDEX IF NOT EXISTS teams_update_history_index_43
    ON public.teams_update_history USING btree
    (chance_creation_positioning COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_5

-- DROP INDEX IF EXISTS public.teams_update_history_index_5;

CREATE INDEX IF NOT EXISTS teams_update_history_index_5
    ON public.teams_update_history USING btree
    (midfield ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_6

-- DROP INDEX IF EXISTS public.teams_update_history_index_6;

CREATE INDEX IF NOT EXISTS teams_update_history_index_6
    ON public.teams_update_history USING btree
    (defence ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_7

-- DROP INDEX IF EXISTS public.teams_update_history_index_7;

CREATE INDEX IF NOT EXISTS teams_update_history_index_7
    ON public.teams_update_history USING btree
    (home_stadium COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_8

-- DROP INDEX IF EXISTS public.teams_update_history_index_8;

CREATE INDEX IF NOT EXISTS teams_update_history_index_8
    ON public.teams_update_history USING btree
    (international_prestige ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: teams_update_history_index_9

-- DROP INDEX IF EXISTS public.teams_update_history_index_9;

CREATE INDEX IF NOT EXISTS teams_update_history_index_9
    ON public.teams_update_history USING btree
    (domestic_prestige ASC NULLS LAST)
    TABLESPACE pg_default;

BEGIN;
\copy leagues FROM '/var/lib/postgresql/FIFA_23_Complete_Player/leagues.csv' CSV HEADER
\copy nations FROM '/var/lib/postgresql/FIFA_23_Complete_Player/nations.csv' CSV HEADER
\copy coaches FROM '/var/lib/postgresql/FIFA_23_Complete_Player/coaches.csv' CSV HEADER
\copy teams FROM '/var/lib/postgresql/FIFA_23_Complete_Player/teams.csv' CSV HEADER
\copy players FROM '/var/lib/postgresql/FIFA_23_Complete_Player/players.csv' CSV HEADER
\copy players_update_history FROM '/var/lib/postgresql/FIFA_23_Complete_Player/players_update_history.csv' CSV HEADER
\copy teams_update_history FROM '/var/lib/postgresql/FIFA_23_Complete_Player/teams_update_history.csv' CSV HEADER
END;

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE FIFA_23_Complete_Player TO data_user;
GRANT ALL PRIVILEGES ON TABLE coaches TO data_user;
GRANT ALL PRIVILEGES ON TABLE leagues TO data_user;
GRANT ALL PRIVILEGES ON TABLE teams TO data_user;
GRANT ALL PRIVILEGES ON TABLE players TO data_user;
GRANT ALL PRIVILEGES ON TABLE nations TO data_user;
GRANT ALL PRIVILEGES ON TABLE players_update_history TO data_user;
GRANT ALL PRIVILEGES ON TABLE teams_update_history TO data_user;
GRANT ALL ON SCHEMA public TO data_user;