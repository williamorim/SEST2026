# remotes::install_github("williamorim/kickoff")

library(kickoff)
library(dplyr)

# Listar as competições abertas do SB
sb_competitions <- sb_open_competitions()

# Pegar dados da Copa do Mundo masculina de 2022
wc_2022 <- sb_competitions |>
  filter(
    competition_name == "FIFA World Cup",
    competition_gender == "male",
    season_name == 2022
  )

# Pegar as partidas
wc_2022_matches <- kickoff::sb_open_matches(wc_2022)
saveRDS(wc_2022_matches, "data/wc_2022_matches.rds")

# Pegar os eventos
wc_2022_events <- kickoff::sb_open_events(wc_2022_matches)
saveRDS(wc_2022_events, "data/wc_2022_events.rds")

# Pegar a final
final_match <- wc_2022_matches |>
  filter(competition_stage.name == "Final")

# Pegar os eventos da final
final_match_events <- wc_2022_events |>
  filter(match_id == final_match$match_id)

# Explorando a base
final_match_events |> 
  select(period, minute, second, location, team.name, player.name, type.name) |> 
  View()
