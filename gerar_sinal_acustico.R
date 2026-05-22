# Pacotes ----

library(tuneR)

library(seewave)

library(sonicscrewdriver)

library(tidyverse)

library(viridis)

library(ggview)

library(patchwork)

# Dados ----

## Importar ----

scinax <- tuneR::readWave("Scinax x signatus_trat.wav")

## Visualizar ----

scinax

scinax |> seewave::spectro(flim = c(0, 6),
                           tlim = c(0, 3.5),
                           ovlp = 99,
                           wn = "blackman",
                           wl = 2048)

scinax |> seewave::listen()

# Sinal acústico ----

## Silencio ----

silencio <- tuneR::silence(duration = 0.6746,
                           xunit = "time",
                           samp.rate = scinax@samp.rate,
                           pcm = TRUE,
                           stereo = FALSE)

silencio

## Gerar múltiplos sinais acústicos ----

sinal <- purrr::map(1:9,
                    \(id){

            sonicscrewdriver::sweptsine(f0 = 693.5,
                                        f1 = 5185.9,
                                        sweep.time = 0.0197,
                                        samp.rate = scinax@samp.rate,
                                        bit = 32,
                                        mode = "linear")

                    }) |>
  purrr::reduce(\(som1, som2) tuneR::bind(som1, som2))

sinal

sinal |> seewave::spectro(flim = c(0, 5.5),
                          ovlp = 99,
                          wn = "blackman",
                          wl = 2048)

sinal |> seewave::listen()

sinal_completo <- purrr::map(1:5, \(id){sinal}) |>
  purrr::reduce(\(som1, som2) tuneR::bind(som1, silencio, som2)) %>%
  tuneR::bind(silencio, ., silencio)

sinal_completo

sinal_completo |> seewave::listen()

sinal_completo |> seewave::spectro(flim = c(0, 6),
                                   ovlp = 99,
                                   wn = "blackman",
                                   wl = 2048)

# Gráfico ----

## Vocalização ----

### Espectrograma ----

voc_spec <- scinax |> seewave::ggspectro(tlim = c(0, 3.5),
                             wl = 2048,
                             wn = "blackman",
                             ovlp = 99) +
  geom_tile(aes(fill = amplitude)) +
  scale_x_continuous(breaks = seq(0, 3.5, length.out = 5),
                     expand = FALSE) +
  scale_y_continuous(limits = c(0, 6),
                     expand = FALSE) +
  scale_fill_viridis_c(name = "Amplitude (dB)",
                       limits = c(-60, 0),
                       na.value = "transparent",
                       guide = guide_colorbar(
                         title.hjust = 0.5,
                         barheight = 20,
                         frame.colour = "black",
                         ticks.colour = "black")) +
  labs(y = "Frequência (KHz)") +
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

voc_spec

### Oscilograma ----

voc_oscilo <- tibble::tibble(tempo = seq(0,
                                         3.5,
                                         length.out = scinax |>
                                           seewave::oscillo(
                                             from = 0,
                                             to = 3.5,
                                             plot = FALSE) |>
                                           as.numeric() |>
                                           length()),
                             amplitude = scinax |>
                               seewave::oscillo(from = 0,
                                                to = 3.5,
                                                plot = FALSE) |>
                               as.numeric()) |>
  ggplot(aes(tempo, amplitude)) +
  geom_line(linewidth = 1) +
  scale_x_continuous(breaks = seq(0,
                                  3.5,
                                  length.out = 5),
                     expand = FALSE) +
  labs(x = "Tempo (s)",
       y = "Amplitude (KU)") +
  theme_classic() +
  theme(axis.text = element_text(size = 17.5),
        axis.title = element_text(size = 20),
        panel.grid = element_line(linetype = "dashed",
                                  color = "gray",
                                  linewidth = 1),
        panel.grid.minor = element_blank(),
        legend.text = element_text(size = 17.5),
        legend.title = element_text(size = 20)) +
  ggview::canvas(height = 10, width = 12)

voc_oscilo

### Unir os dados ----

(voc_spec / voc_oscilo) &
  ggview::canvas(height = 10, width = 12)

ggsave(filename = "atividade_3_voc.png",
       height = 10, width = 12)

## Sinal acústico ----

## Espectrograma ----

sinal_spec <- sinal_completo |>
  seewave::ggspectro(tlim = c(0,
                              sinal_completo |> seewave::duration()),
                     wl = 2048,
                     wn = "blackman",
                     ovlp = 99) +
  geom_tile(aes(fill = amplitude)) +
  scale_x_continuous(breaks = seq(0,
                                  sinal_completo |> seewave::duration(),
                                  length.out = 5),
                     expand = FALSE) +
  scale_y_continuous(limits = c(0, 6),
                     expand = FALSE) +
  scale_fill_viridis_c(name = "Amplitude (dB)",
                       limits = c(-60, 0),
                       na.value = "transparent",
                       guide = guide_colorbar(
                         title.hjust = 0.5,
                         barheight = 20,
                         frame.colour = "black",
                         ticks.colour = "black")) +
  labs(y = "Frequência (KHz)") +
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

sinal_spec
