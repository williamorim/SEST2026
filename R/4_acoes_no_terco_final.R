source("R/1_explorando_tabela_eventos.R")

library(ggplot2)

# Ações no terço final: passes, dribles e finalizações que começam em x >= 80
acoes_terco_final <- final_match_events |>
  filter(
    period %in% 1:4,
    type.name %in% c("Pass", "Dribble", "Shot")
  ) |>
  mutate(x = purrr::map_dbl(location, 1)) |>
  filter(x >= 80) |>
  select(period, minute, second, team.name, player.name, type.name, x)

# Minuto de jogo contínuo
#
# Na base, os acréscimos do 1º tempo (45, 46, 47...) usam os mesmos minutos
# do início do 2º tempo. O mesmo acontece entre os outros períodos. Para que
# cada barra represente um único trecho do jogo, deslocamos cada período pelo
# tempo acumulado dos períodos anteriores.
periodos <- final_match_events |>
  filter(period %in% 1:4) |>
  group_by(period) |>
  summarise(inicio = min(minute), fim = max(minute)) |>
  mutate(
    duracao = fim - inicio + 1,
    inicio_continuo = cumsum(duracao) - duracao,
    rotulo = case_when(
      period == 1 ~ "1º tempo",
      period == 2 ~ "2º tempo",
      period == 3 ~ "Prorrogação",
      TRUE ~ ""
    )
  )

# Volume por minuto e por seleção
# França no eixo positivo, Argentina no negativo
volume <- acoes_terco_final |>
  left_join(periodos, by = "period") |>
  mutate(minuto = minute - inicio + inicio_continuo) |>
  count(team.name, minuto, name = "acoes") |>
  mutate(
    selecao = ifelse(team.name == "France", "França", "Argentina"),
    acoes = ifelse(team.name == "France", acoes, -acoes)
  )

# Gráfico de volume de jogo
limite <- max(abs(volume$acoes))

volume |>
  ggplot(aes(x = minuto, y = acoes, fill = selecao)) +
  geom_col(width = 0.9, show.legend = FALSE) +
  geom_hline(yintercept = 0, colour = "grey30") +
  geom_vline(
    data = periodos |> filter(period > 1),
    aes(xintercept = inicio_continuo - 0.5),
    linetype = "dashed",
    colour = "grey50"
  ) +
  scale_fill_manual(values = c("França" = "#0055A4", "Argentina" = "#75AADB"), name = NULL) +
  scale_x_continuous(breaks = seq(0, 135, by = 15)) +
  scale_y_continuous(labels = abs) +
  theme_minimal() +
  theme(
    legend.position = "bottom",
    panel.grid = element_blank(),
    axis.title = element_blank(),
    axis.text.y = element_blank()
  )
