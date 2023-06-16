DROP DATABASE IF EXISTS french_employment_salaries_population_per_town;
CREATE DATABASE french_employment_salaries_population_per_town;
\c french_employment_salaries_population_per_town;

BEGIN;
CREATE TABLE IF NOT EXISTS "town" (
    "town_code" TEXT PRIMARY KEY,
    "town_name" TEXT,
    "region_number" INTEGER,
    "department_number" TEXT,
    "total_number_of_firms_in_town" INTEGER,
    "number_of_unknown_firms_in_town" INTEGER,
    "number_of_firms_in_town_with_1_to_5_employees" INTEGER,
    "number_of_firms_in_town_with_6_to_9_employees" INTEGER,
    "number_of_firms_in_town_with_10_to_19_employees" INTEGER,
    "number_of_firms_in_town_with_20_to_49_employees" INTEGER,
    "number_of_firms_in_town_with_50_to_99_employees" INTEGER,
    "number_of_firms_in_town_with_100_to_199_employees" INTEGER,
    "number_of_firms_in_town_with_200_to_499_employees" INTEGER,
    "number_of_firms_in_town_with_more_than_500_employees" INTEGER
);

CREATE TABLE IF NOT EXISTS "population" (
    "geographic_level" TEXT,
    "town_code" TEXT,
    "town_name" TEXT,
    "cohabitation_mode" TEXT,
    "age_category" INTEGER,
    "SEX" INTEGER,
    "number_of_people" INTEGER
);
-- AGE80_17 : age category (slice of 5 years) | ex : 0 -> people between 0 and 4 years old
-- SEXE : sex, 1 for men | 2 for women
-- cohabitation mode :
-- 11 = children living with two parents
-- 12 = children living with one parent
-- 21 = adults living in couple without child
-- 22 = adults living in couple with children
-- 23 = adults living alone with children
-- 31 = persons not from family living in the home
-- 32 = persons living alone

CREATE TABLE IF NOT EXISTS "net_salary_per_town" (
    "town_code" TEXT,
    "town_name" TEXT,
    "mean_net_salary" FLOAT,
    "mean_net_salary_per_hour_for_executive" FLOAT,
    "mean_net_salary_per_hour_for_middle_manager" FLOAT,
    "mean_net_salary_per_hour_for_employee" FLOAT,
    "mean_net_salary_per_hour_for_worker" FLOAT,
    "mean_net_salary_per_hour_for_women" FLOAT,
    "mean_net_salary_per_hour_for_feminin_executive" FLOAT,
    "mean_net_salary_per_hour_for_feminin_middle_manager" FLOAT,
    "mean_net_salary_per_hour_for_feminin_employee" FLOAT,
    "mean_net_salary_per_hour_for_feminin_worker" FLOAT,
    "mean_net_salary_for_man" FLOAT,
    "mean_net_salary_per_hour_for_masculin_executive" FLOAT,
    "mean_net_salary_per_hour_for_masculin_middle_manager" FLOAT,
    "mean_net_salary_per_hour_for_masculin_employee" FLOAT,
    "mean_net_salary_per_hour_for_masculin_worker" FLOAT,
    "mean_net_salary_per_hour_for_18-25_years_old" FLOAT,
    "mean_net_salary_per_hour_for_26-50_years_old" FLOAT,
    "mean_net_salary_per_hour_for_51_above_years_old" FLOAT,
    "mean_net_salary_per_hour_for_women_18-25_years_old" FLOAT,
    "mean_net_salary_per_hour_for_women_26-50_years_old" FLOAT,
    "mean_net_salary_per_hour_For_women_51_above_years_old" FLOAT,
    "mean_net_salary_per_hour_for_men_18-25_years_old" FLOAT,
    "mean_net_salary_per_hour_for_men_26-50_years_old" FLOAT,
    "mean_net_salary_per_hour_For_men_51_above_years_old" FLOAT
);

CREATE TABLE IF NOT EXISTS "ori_name_geographic_information" (
    "eu_constituency" TEXT,
    "region_code" INTEGER,
    "region_name" TEXT,
    "captial" TEXT,
    "department_number" TEXT,
    "department_name" TEXT,
    "prefecture" TEXT,
    "constituency_number" INTEGER,
    "municipality_name" TEXT,
    "postal_code" TEXT,
    "town_code" TEXT,
    "latitude" TEXT,
    "longitude" TEXT,
    "distance" TEXT
);
END;

-- Insert data from csv file
BEGIN;
\copy "town" FROM '/docker-entrypoint-initdb.d/data/french_employmnet_salaries_population_per_town/base.csv' CSV HEADER;
\copy "population" FROM '/docker-entrypoint-initdb.d/data/french_employmnet_salaries_population_per_town/population.csv' CSV HEADER;
\copy "net_salary_per_town" FROM '/docker-entrypoint-initdb.d/data/french_employmnet_salaries_population_per_town/net_salary_per_town.csv' CSV HEADER;
\copy "ori_name_geographic_information" FROM '/docker-entrypoint-initdb.d/data/french_employmnet_salaries_population_per_town/name_geographic_information.csv' CSV HEADER;
END;

-- Final table
BEGIN;
CREATE TABLE IF NOT EXISTS "name_geographic_information" (
    "eu_constituency" TEXT,
    "region_code" INTEGER,
    "region_name" TEXT,
    "captial" TEXT,
    "department_number" TEXT,
    "department_name" TEXT,
    "prefecture" TEXT,
    "constituency_number" INTEGER,
    "municipality_name" TEXT,
    "postal_code" TEXT,
    "town_code" TEXT,
    "latitude" FLOAT,
    "longitude" FLOAT,
    "distance" FLOAT
);
END;

BEGIN;
INSERT INTO "name_geographic_information" 
SELECT
    eu_constituency,
    region_code,
    region_name,
    captial,
    department_number,
    department_name,
    prefecture,
    constituency_number,
    municipality_name,
    postal_code,
    town_code,
    CASE 
        WHEN latitude ~ '^\d+(\.\d+)?$' THEN CAST(latitude AS FLOAT)
        ELSE NULL
    END,
    CASE 
        WHEN longitude ~ '^\d+(\.\d+)?$' THEN CAST(longitude AS FLOAT)
        ELSE NULL
    END,
    CASE 
        WHEN distance ~ '^\d+(\.\d+)?$' THEN CAST(distance AS FLOAT)
        ELSE NULL
    END
FROM "ori_name_geographic_information";
DROP TABLE IF EXISTS "ori_name_geographic_information";
END;
