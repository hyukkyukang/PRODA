DROP DATABASE IF EXISTS mubi_svod_platform;
CREATE DATABASE mubi_svod_platform;
\c mubi_svod_platform;

-- Create original tables
BEGIN;
CREATE TABLE IF NOT EXISTS "ori_movies" (
  "movie_id" INTEGER,
  "movie_title" TEXT,
  "movie_release_year" REAL,
  "movie_url" TEXT,
  "movie_title_language" TEXT,
  "movie_popularity" INTEGER,
  "movie_image_url" TEXT,
  "director_id" TEXT,
  "director_name" TEXT,
  "director_url" TEXT
);

CREATE TABLE IF NOT EXISTS "ori_ratings_users" (
  "user_id" INTEGER,
  "rating_date_utc" TIMESTAMP,
  "user_trialist" BOOLEAN,
  "user_subscriber" BOOLEAN,
  "user_avatar_image_url" TEXT,
  "user_cover_image_url" TEXT,
  "user_eligible_for_trial" BOOLEAN,
  "user_has_payment_method" BOOLEAN
);

CREATE TABLE IF NOT EXISTS "ori_lists_users" (
  "user_id" INTEGER,
  "list_id" INTEGER,
  "list_update_date_utc" TIMESTAMP,
  "list_creation_date_utc" TIMESTAMP,
  "user_trialist" BOOLEAN,
  "user_subscriber" BOOLEAN,
  "user_avatar_image_url" TEXT,
  "user_cover_image_url" TEXT,
  "user_eligible_for_trial" BOOLEAN,
  "user_has_payment_method" BOOLEAN
);

CREATE TABLE IF NOT EXISTS "ori_lists" (
  "user_id" INTEGER,
  "list_id" INTEGER,
  "list_title" TEXT,
  "list_movie_number" INTEGER,
  "list_update_timestamp_utc" TIMESTAMP,
  "list_creation_timestamp_utc" TIMESTAMP,
  "list_followers" INTEGER,
  "list_url" TEXT,
  "list_comments" INTEGER,
  "list_description" TEXT,
  "list_cover_image_url" TEXT,
  "list_first_image_url" TEXT,
  "list_second_image_url" TEXT,
  "list_third_image_url" TEXT
);

CREATE TABLE IF NOT EXISTS "ori_ratings" (
  "movie_id" INTEGER,
  "rating_id" INTEGER,
  "rating_url" TEXT,
  "rating_score" REAL,
  "rating_timestamp_utc" TIMESTAMP,
  "critic" TEXT,
  "critic_likes" INTEGER,
  "critic_comments" INTEGER,
  "user_id" INTEGER,
  "user_trialist" BOOLEAN,
  "user_subscriber" BOOLEAN,
  "user_eligible_for_trial" BOOLEAN,
  "user_has_payment_method" BOOLEAN
);
END;

-- Insert data from CSV files
BEGIN;
\copy ori_lists_users FROM './lists_users.csv' CSV HEADER
\copy ori_lists FROM './lists.csv' CSV HEADER
\copy ori_movies FROM './movies.csv' CSV HEADER
\copy ori_ratings_users FROM './ratings_users.csv' CSV HEADER
\copy ori_ratings FROM './ratings.csv' CSV HEADER
END;


-- Create final tables
BEGIN;
CREATE TABLE IF NOT EXISTS "directors" (
  "director_id" TEXT PRIMARY KEY,
  "director_name" TEXT,
  "director_url" TEXT
);

CREATE TABLE IF NOT EXISTS "movies" (
  "movie_id" INTEGER PRIMARY KEY,
  "movie_title" TEXT,
  "movie_release_year" REAL,
  "movie_url" TEXT,
  "movie_title_language" TEXT,
  "movie_popularity" INTEGER,
  "movie_image_url" TEXT,
  "director_id" TEXT
);

CREATE TABLE IF NOT EXISTS "users" (
    "user_id" INTEGER,
    "user_trialist" BOOLEAN,
    "user_subscriber" BOOLEAN,
    "user_avatar_image_url" TEXT,
    "user_cover_image_url" TEXT,
    "user_eligible_for_trial" BOOLEAN,
    "user_has_payment_method" BOOLEAN,
    "user_update_date_utc" TIMESTAMP,
    "user_update_by_action" TEXT,
    PRIMARY KEY (user_id, user_update_date_utc, user_update_by_action)
);

CREATE TABLE IF NOT EXISTS "lists" (
    "list_id" INTEGER PRIMARY KEY,
    "user_id" INTEGER,
    "list_title" TEXT,
    "list_movie_number" INTEGER,
    "list_update_timestamp_utc" TIMESTAMP,
    "list_creation_timestamp_utc" TIMESTAMP,
    "list_followers" INTEGER,
    "list_url" TEXT,
    "list_comments" INTEGER,
    "list_description" TEXT,
    "list_cover_image_url" TEXT,
    "list_first_image_url" TEXT,
    "list_second_image_url" TEXT,
    "list_third_image_url" TEXT
);

CREATE TABLE IF NOT EXISTS "ratings" (
    "rating_id" INTEGER PRIMARY KEY,
    "movie_id" INTEGER,
    "user_id" INTEGER,
    "rating_url" TEXT,
    "rating_score" REAL,
    "rating_timestamp_utc" TIMESTAMP,
    "critic" TEXT,
    "critic_likes" INTEGER,
    "critic_comments" INTEGER,
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);
END;

-- Insert values to the final tables
INSERT INTO directors (director_id, director_name, director_url) SELECT DISTINCT director_id, director_name, director_url FROM ori_movies;
INSERT INTO movies (movie_id, movie_title, movie_release_year, movie_url, movie_title_language, movie_popularity, movie_image_url, director_id) SELECT DISTINCT movie_id, movie_title, movie_release_year, movie_url, movie_title_language, movie_popularity, movie_image_url, director_id FROM ori_movies;
INSERT INTO users (user_id, user_trialist, user_subscriber, user_avatar_image_url, user_cover_image_url, user_eligible_for_trial, user_has_payment_method, user_update_date_utc, user_update_by_action) SELECT DISTINCT user_id, user_trialist, user_subscriber, user_avatar_image_url, user_cover_image_url, user_eligible_for_trial, user_has_payment_method, rating_date_utc, 'RATING' FROM ori_ratings_users;
INSERT INTO users (user_id, user_trialist, user_subscriber, user_avatar_image_url, user_cover_image_url, user_eligible_for_trial, user_has_payment_method, user_update_date_utc, user_update_by_action) SELECT DISTINCT user_id, user_trialist, user_subscriber, user_avatar_image_url, user_cover_image_url, user_eligible_for_trial, user_has_payment_method, list_update_date_utc, 'LISTS' FROM ori_lists_users WHERE user_id NOT IN (SELECT user_id FROM users);
INSERT INTO lists (list_id, user_id, list_title, list_movie_number, list_update_timestamp_utc, list_creation_timestamp_utc, list_followers, list_url, list_comments, list_description, list_cover_image_url, list_first_image_url, list_second_image_url, list_third_image_url) SELECT DISTINCT list_id, user_id, list_title, list_movie_number, list_update_timestamp_utc, list_creation_timestamp_utc, list_followers, list_url, list_comments, list_description, list_cover_image_url, list_first_image_url, list_second_image_url, list_third_image_url FROM ori_lists;
INSERT INTO lists (list_id, user_id, list_update_timestamp_utc, list_creation_timestamp_utc) SELECT DISTINCT list_id, user_id, list_update_date_utc, list_creation_date_utc FROM ori_lists_users WHERE list_id NOT IN (SELECT list_id FROM lists);
INSERT INTO ratings (rating_id, movie_id, user_id, rating_url, rating_score, rating_timestamp_utc, critic, critic_likes, critic_comments) SELECT DISTINCT rating_id, movie_id, user_id, rating_url, rating_score, rating_timestamp_utc, critic, critic_likes, critic_comments FROM ori_ratings WHERE user_id IN (SELECT user_id FROM users) AND movie_id IN (SELECT movie_id FROM movies);


-- Drop redundant tables
DROP TABLE ori_movies;
DROP TABLE ori_ratings_users;
DROP TABLE ori_lists_users;
DROP TABLE ori_lists;
DROP TABLE ori_ratings;

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE mubi_svod_platform TO data_user;
GRANT ALL PRIVILEGES ON TABLE directors TO data_user;
GRANT ALL PRIVILEGES ON TABLE movies TO data_user;
GRANT ALL PRIVILEGES ON TABLE users TO data_user;
GRANT ALL PRIVILEGES ON TABLE lists TO data_user;
GRANT ALL PRIVILEGES ON TABLE ratings TO data_user;
GRANT ALL ON SCHEMA public TO data_user;
