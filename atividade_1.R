# Pàcotes ----

library(tuneR)

library(seewave)

library(tidyverse)

library(ggmagnify)

library(viridis)

library(ggview)

library(patchwork)

# Vocalização ----

## Importar ----

voc <- tuneR::readWave("C:/Users/LENOVO/OneDrive/Documentos/projeto mestrado/vocalizações/Allobates-olfersioides.wav")

## Visualizar  ----

voc

voc |> seewave::listen()

# Valores acústicos ----

## Valores do espectrograma ----

### Criar ----

voc |> seewave::spectro(flim = c(4.2, 5.25),
                        wl = 8112,
                        wn = "blackman",
                        ovlp = 99,
                        palette = viridis::viridis)

## Valores do oscilograma ----

### Criar ----

oscilo <- voc |> seewave::oscillo()

### Data frame ----

oscilo_df <- tibble::tibble(tempo = seq(0,
                                        voc |> seewave::duration(),
                                        length.out = oscilo |>
                                          as.numeric() |>
                                          length()),
                            amplitude = oscilo |> as.numeric())

oscilo_df

# Gráficos ----

## Eséctrograma ----

gg_espectro <- voc |>
  seewave::ggspectro(wl = 8112,
                     wn = "blackman",
                     ovlp = 99) +
  geom_tile(aes(fill = amplitude)) +
  scale_x_continuous(breaks = seq(0,
                                  voc |> seewave::duration(),
                                  1),
                     expand = FALSE) +
  scale_y_continuous(limits = c(4.2, 5.3),
                     breaks = seq(4.25,
                                  5.25,
                                  0.25),
                     expand = FALSE) +
  scale_fill_viridis_c(name = "Amplitude (dB)",
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
        panel.grid = element_line(linetype = "dashed",
                                  color = "gray",
                                  linewidth = 1),
        panel.grid.minor = element_blank(),
        legend.text = element_text(size = 17.5),
        legend.title = element_text(size = 20)) +
  ggview::canvas(height = 10, width = 12)

gg_espectro

