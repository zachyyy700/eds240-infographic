##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                                                                            --
##-------- CLEANING & TRANSLATING SCRIPT FOR JRA HORSE RACING DATASET-----------
##                                                                            --
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
library(tidyverse)
source("parse_margin.R")

# Load data, parsing certain columns as character
jra_results <- read_csv(here::here('data', '19860105-20210731_race_result.csv'),
col_types = cols(レース馬番ID = 'c', レースID = 'c', タイム = 'c')) |> 
    # Omit レース記号 columns
    select(-starts_with("レース記号"))

# Filter to only flat, not steeplechase races
jra_flat  <- jra_results |> 
  filter(is.na(障害区分))

# Translate & select columns
jra_eng <- jra_flat |> 
  rename(
    race_id_horsenum = レース馬番ID,
    race_id = レースID,
    race_date = レース日付,
    race_occur_num = 開催回数,
    racetrack_code = 競馬場コード,
    racetrack_name = 競馬場名,
    race_nth_day = 開催日数,
    race_prereq = 競争条件,
    race_num = レース番号,
    graded_race_nth_time = 重賞回次,
    race_name = レース名,
    race_grade = `リステッド・重賞競走`,
    track_surface = `芝・ダート区分`,
    race_direction = `右左回り・直線区分`,
    inside_outside = `内・外・襷区分`,
    distance_m = `距離(m)`,
    weather = 天候,
    track_condition = 馬場状態1,
    final_position = 着順,
    final_position_note = 着順注記,
    bracket_num = 枠番,
    horse_num = 馬番,
    horse_name = 馬名,
    horse_sex = 性別,
    horse_age = 馬齢,
    jockey_weight_kg = 斤量,
    jockey_name = 騎手,
    finish_time = タイム,
    margin_horselen = 着差,
    corner1_position = `1コーナー`,
    corner2_position = `2コーナー`,
    corner3_position = `3コーナー`,
    corner4_position = `4コーナー`,
    final_600m_time = 上り,
    win_odds_100Y = 単勝,
    win_fav = 人気,
    horse_weight = 馬体重,
    horse_weight_diff = 場体重増減,
    horse_nation = `東西・外国・地方区分`,
    horse_trainer = 調教師,
    horse_owner = 馬主,
    prize_money_10kY = `賞金(万円)`
  ) |> 
  select(-c(発走時刻, 障害区分, `芝・ダート区分2`, 馬場状態2))

# Add year and month columns
jra_eng  <- jra_eng |> 
    mutate(year = year(race_date), month = month(race_date), .after = race_date)

# Call margin function
jra_clean <- jra_eng |> 
  filter(!str_detect(margin_horselen,"\\+") | is.na(margin_horselen)) |> # Keep na's since these are first place horses
  mutate(margin_parsed = map_dbl(margin_horselen, parse_margin), .after = margin_horselen)

write_csv(jra_clean, "data/jra_clean.csv")