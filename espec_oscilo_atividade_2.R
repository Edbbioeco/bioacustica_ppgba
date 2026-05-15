# Pacotes ----

library(tidyverse)

library(tuneR)

library(seewave)

# Dados ----

## Importar ----

audios <- purrr::map(list.files(path = "pratica_diferenciacao/",
                                full.names = TRUE),
                     \(audio){

                       tuneR::readWave(audio)

                     }) |>
  setNames(list.files(path = "pratica_diferenciacao/") |>
             stringr::str_remove(".WAV"))

## Visualizar ----

audios

purrr::map(audios, seewave::listen)

# Gráficos ----

## Limites ----

limites <- list(c(0.5, 3.5),
                c(0.6, 3.2),
                c(2, 4.5),
                c(2, 4.5),
                c(2, 4.5),
                c(2.5, 5),
                c(2.75, 5),
                c(2.75, 5),
                c(3.35, 5.75),
                c(1.5, 3.75))

limites

## Nomes ----

nomes <- list.files(path = "pratica_diferenciacao/") |>
  stringr::str_remove(".WAV")

nomes

## Espectrograma ----

espectro <- purrr::pmap(list(audios ,limites, nomes),
                        \(audio, limites, nome){

                          audio |> seewave::ggspectro(tlim = limites,
                                                      wl = 2048,
                                                      wn = "blackman",
                                                      ovlp = 99) +
                            geom_tile(aes(fill = amplitude)) +
                            scale_x_continuous(limits = limites,
                                               expand = FALSE) +
                            scale_y_continuous(expand = FALSE) +
                            scale_fill_viridis_c(name = "Amplitude (dB)",
                                                 limits = c(-80, 0),
                                                 na.value = "transparent",
                                                 guide = guide_colorbar(
                                                   title.hjust = 0.5,
                                                   barheight = 20,
                                                   frame.colour = "black",
                                                   ticks.colour = "black")) +
                            labs(title = nome,
                                 y = "Frequência (KHz)") +
                            theme_classic() +
                            theme(axis.text = element_text(size = 17.5),
                                  axis.title = element_text(size = 20),
                                  axis.title.x = element_blank(),
                                  axis.text.x = element_blank(),
                                  plot.title = element_text(size = 20),
                                  panel.grid = element_line(linetype = "dashed",
                                                            color = "gray",
                                                            linewidth = 1),
                                  panel.grid.minor = element_blank(),
                                  panel.background = element_rect(
                                    fill = viridis::viridis(n = 1)),
                                  legend.text = element_text(size = 17.5),
                                  legend.title = element_text(size = 20)) +
    ggview::canvas(height = 10, width = 12)

                          })

espectro
