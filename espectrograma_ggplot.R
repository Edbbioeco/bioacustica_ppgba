# Pàcotes ----

library(tuneR)

library(seewave)

library(tidyverse)

library(viridis)

library(ggview)

library(patchwork)

# Dados ----

## Importar ----

voc <- tuneR::readWave("vocalizacao.wav")

## Visualizar ----

voc

voc |> seewave::listen()

# Valores acústicos ----

## Valores do espectrograma ----

### Criar ----

voc |> seewave::spectro(flim = c(0.15, 0.72),
                        tlim = c(16.275, 16.625))

## Valores do oscilograma ----

### Criar ----

oscilo <- voc |> seewave::oscillo(from = 16.275, to = 16.625)

### Data frame ----

oscilo_df <- tibble::tibble(tempo = seq(0, (16.625 - 16.275),
                                        length.out = length(oscilo)),
                            amplitude = oscilo |> as.numeric())

oscilo_df

# Gráficos ----

## Eséctrograma ----

gg_espectro <- voc |>
  seewave::cutw(from = 16.275,
                to = 16.625,
                output = "Wave") |>
  seewave::ggspectro() +
  stat_contour(geom="polygon",
               aes(fill = after_stat(level)),
               bins = 1000) +
  scale_x_continuous(breaks = seq(0, 0.35, 0.1),
                     expand = FALSE) +
  scale_y_continuous(limits = c(0.15, 0.72),
                     expand = FALSE) +
  scale_fill_viridis_c(option = "inferno",
                       name = "Amplitude (dB)",
                       limits = c(-30, 0),
                       na.value = "transparent",
                       guide = guide_colorbar(title.hjust = 0.5,
                                              barheight = 20,
                                              frame.colour = "black",
                                              ticks.colour = "black")) +
  labs(y = "Frequência (KHz)") +
  theme_classic() +
  theme(axis.text = element_text(size = 17.5),
        axis.title = element_text(size = 20),
        axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        legend.text = element_text(size = 17.5),
        legend.title = element_text(size = 20),
        panel.background = element_rect(fill = viridis::inferno(n = 1))) +
  ggview::canvas(height = 10, width = 12)

gg_espectro

## Oscilograma ----

gg_oscilo <- oscilo_df |>
  ggplot(aes(tempo, amplitude)) +
  geom_line(linewidth = 1) +
  scale_x_continuous(expand = FALSE) +
  labs(x = "Tempo (s)",
       y = "Amplitude (KU)") +
  theme_classic() +
  theme(axis.text = element_text(size = 17.5),
        axis.title = element_text(size = 20),
        legend.text = element_text(size = 17.5),
        legend.title = element_text(size = 20)) +
  ggview::canvas(height = 10, width = 12)

gg_oscilo

## Unit os gráficos ----

(gg_espectro / gg_oscilo) &
  ggview::canvas(height = 10, width = 12)

ggsave(filename = "gg_espectro_oscilo.png",
       height = 10, width = 12)
