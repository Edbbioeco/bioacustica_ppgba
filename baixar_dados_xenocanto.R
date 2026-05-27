# Pacotes ----

library(suwo)

library(tidyverse)

library(av)

library(tuneR)

library(seewave)

library(viridis)

library(ggview)

# Dados ----

## Metadados ----

metadados <- suwo::query_xenocanto(species = "Myrmorchilus strigilatus")

metadados

metadados |> dplyr::glimpse()

## Filtrar dados a serem baixados ----

metadados_trat <- metadados |>
  dplyr::filter(country == "Brazil" & file_extension == "wav")

metadados_trat

## Mapa das áreas ----

metadados_trat |>
  suwo::map_locations()

## Baixar os dados ----

dir.create(path = "./voc_myrmorchilus")

metadados_trat |>
  suwo::download_media(path = "./voc_myrmorchilus",
                       overwrite = TRUE)

# Analisar dados ----

## Consertar os áudios ----

vocs <- purrr::map(list.files(path = "./voc_myrmorchilus",
                              full.names = TRUE),
                   \(voc){

                     av::av_audio_convert(voc,
                                          output = voc,
                                          format = "wav",
                                          sample_rate = 44100)
                   },
                   .progress = TRUE)

## Importar áudios ----

vocalizacoes <- purrr::map(vocs,
                           tuneR::readWave,
                           .progress = TRUE) |>
  setNames(list.files(path = "./voc_myrmorchilus") |>
             stringr::str_remove(".wav"))

vocalizacoes

## Duração dos cantos ----

purrr::map_dbl(vocalizacoes, seewave::duration)

## Visualizar vocalizações ----

purrr::map2(vocalizacoes,
            vocalizacoes |> names(),
            \(voc, nome){

             voc |>
               seewave::ggspectro(tlim = c(0, 3.5),
                                  wl = 2048,
                                  wn = "blackman",
                                  ovlp = 99) +
               geom_tile(aes(fill = amplitude)) +
               scale_x_continuous(breaks = seq(0, 3.5, length.out = 5),
                                  expand = FALSE) +
               scale_y_continuous(expand = FALSE) +
               scale_fill_viridis_c(name = "Amplitude (dB)",
                                    limits = c(-60, 0),
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
               ggview::canvas(height = 10, width = 12) |>
               print()

           },
           .progress = TRUE)
