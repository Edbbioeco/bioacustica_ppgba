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

voc |> seewave::listen(f = 0.75)

# Valores acústicos ----

## Valores do espectrograma ----

### Criar ----

espectro <- voc |> seewave::spectro(flim = c(0, 0.75),
                                    tlim = c(15, 16.75))

### Data frame dos valore ----

espectro_df <- tibble::tibble(tempo = rep(espectro$time,
                                          each = length(espectro$freq)),
                              frequencia = rep(espectro$freq,
                                               length(espectro$time)),
                              amplitude = espectro$amp |> as.numeric())

espectro_df

## Valores do oscilograma ----

### Criar ----

oscilo <- voc |> seewave::oscillo(from = 15, to = 16.75)

### Data frame ----

oscilo_df <- tibble::tibble(tempo = seq(0, seewave::duration(voc),
                                        length.out = length(oscilo)),
                            amplitude = oscilo |> as.numeric())

oscilo_df

# Gráficos ----

## Eséctrograma ----

gg_espectro <- voc |>
  seewave::ggspectro() +
  stat_contour(geom="polygon",
               aes(fill = ..level..),
               bins = 1000) +
  scale_x_continuous(limits = c(15, 16.75),
                     expand = FALSE) +
  scale_y_continuous(limits = c(0, 0.75),
                     expand = FALSE) +
  scale_fill_viridis_c(name = "Amplitude (dB)",
                       limits = c(-30, 0),
                       na.value = "transparent",
                       guide = guide_colorbar(title.hjust = 0.5,
                                              barheight = 20,
                                              frame.colour = "black",
                                              ticks.colour = "black")) +
  theme_classic() +
  theme(axis.text = element_text(size = 17.5),
        axis.title = element_text(size = 20),
        axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        legend.text = element_text(size = 17.5),
        legend.title = element_text(size = 20),
        panel.background = element_rect(fill = viridis::viridis(n = 1))) +
  ggview::canvas(height = 10, width = 12)

gg_espectro

## Oscilograma ----

gg_oscilo <- oscilo_df |>
  ggplot(aes(tempo, amplitude)) +
  geom_line() +
  labs(y = "Amplitude (KU)") +
  theme_classic() +
  theme(axis.text = element_text(size = 17.5),
        axis.title = element_text(size = 20),
        legend.text = element_text(size = 17.5),
        legend.title = element_text(size = 20)) +
  ggview::canvas(height = 10, width = 12)

gg_oscilo
