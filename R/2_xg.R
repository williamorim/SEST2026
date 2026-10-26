source("R/1_explorando_tabela_eventos.R")

# Visualizar xG
final_match_events |> 
  filter(!is.na(shot.statsbomb_xg)) |>
  select(period, minute, second, location, team.name, player.name, type.name, shot.statsbomb_xg) |> 
  View()

# xg da partida final
final_match_xg <- final_match_events |>
  # Remove penalty shootouts
  filter(period %in% 1:4) |>
  group_by(team.name) |>
  summarise(match_xg = sum(shot.statsbomb_xg, na.rm = TRUE))

# Gols vs xG
wc_2022_goals_vs_xg <- wc_2022_events |>
  filter(period %in% 1:4) |>
  group_by(team.name) |>
  summarise(
    total_xg = sum(shot.statsbomb_xg, na.rm = TRUE),
    goals = sum(shot.outcome.name == "Goal", na.rm = TRUE)
  ) |> 
  arrange(desc(goals))

# Visualização de gols vs xG
library(ggplot2)

wc_2022_goals_vs_xg |> 
  mutate(
    fill = ifelse(goals > total_xg, "lightgreen", "lightcoral")
  ) |>
  ggplot(aes(x = total_xg, y = goals, label = team.name, fill = I(fill))) +
  ggrepel::geom_label_repel(max.overlaps = 30) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red") +
  labs(
    title = "Goals vs Expected Goals (xG) - 2022 World Cup",
    x = "Total xG",
    y = "Goals"
   ) +
  theme_minimal()
