source("R/1_explorando_tabela_eventos.R")

library(ggplot2)
library(ggsoccer)

# Visualizar as finalizações da França
final_match_events |>
  filter(type.name == "Shot") |>
  select(
    period, minute, second, 
    team.name,
    player.name, location, shot.end_location,
    shot.statsbomb_xg, shot.outcome.name
  ) |>
  View()

# Finalizações da França no tempo normal e na prorrogação
france_shots <- final_match_events |>
  filter(
    type.name == "Shot",
    team.name == "France",
    period %in% 1:4
  ) |>
  mutate(
    x = purrr::map_dbl(location, 1),
    y = purrr::map_dbl(location, 2),
    end_x = purrr::map_dbl(shot.end_location, 1),
    end_y = purrr::map_dbl(shot.end_location, 2),
    resultado = ifelse(shot.outcome.name == "Goal", "Gol", "Não gol")
  ) |>
  select(
    period, minute, player.name, x, y, end_x, end_y,
    xg = shot.statsbomb_xg, 
    resultado, shot.outcome.name, shot.body_part.name
  )

# Campinho com as finalizações
#
# Coordenadas da StatsBomb: campo de 120 x 80, ataque da esquerda para a direita.
# coord_flip() deixa o campo na vertical, com o gol adversário no topo,
# e xlim restringe a visualização ao campo de ataque.
france_shots |>
  ggplot() +
  annotate_pitch(dimensions = pitch_statsbomb, colour = "grey60", fill = "white") +
  geom_segment(
    aes(x = x, y = y, xend = end_x, yend = end_y),
    arrow = arrow(length = unit(0.15, "cm"), type = "closed"),
    colour = "grey40",
    linewidth = 0.4
  ) +
  geom_point(
    aes(x = x, y = y, size = xg, fill = resultado),
    shape = 21,
    colour = "black",
    alpha = 0.85
  ) +
  scale_size_continuous(range = c(2, 10), name = "xG") +
  scale_fill_manual(values = c("Gol" = "#c0392b", "Não gol" = "grey80"), name = NULL) +
  guides(fill = guide_legend(override.aes = list(size = 4))) +
  coord_flip(xlim = c(60, 121)) +
  theme_pitch() +
  theme(legend.position = "bottom") +
  labs(
    title = "Finalizações da França na final da Copa do Mundo de 2022",
    subtitle = "Tamanho do ponto proporcional ao xG. A seta indica onde a bola terminou.",
    caption = "Dados: StatsBomb Open Data"
  )
