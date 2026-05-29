# PAcotes ----

library(readxl)

library(tidyverse)

library(geobr)

library(ggview)

library(cowplot)

# Dados ----

## Registros ----

### Importar ----

loc <- readxl::read_xlsx("valores_var.xlsx")

### Visualizar ----

loc

loc |> dplyr::glimpse()

## Biomas ----

### Importar ----

biomas <- geobr::read_biomes()

### Visualizar ----

biomas

ggplot() +
  geom_sf(data = biomas)

## Estados do Brasil ----

### Importar ----

estados <- geobr::read_state()

### Visualizar ----

estados

ggplot() +
  geom_sf(data = estados)

# Mapa ----

## Mapa principal ----

mapa_principal <- ggplot() +
  geom_sf(data = biomas |>
            tidyr::drop_na(),
          aes(fill = name_biome),
          linewidth = 0) +
  geom_sf(data = estados, color = "black", linewidth = 1, fill = "transparent") +
  geom_point(data = loc,
             aes(Longitude,
                 Latitude,
                 color = "Registro de ocorrência"),
             size = 5) +
  labs(color = NULL,
       fill = NULL,
       x = NULL,
       y = NULL) +
  scale_color_manual(values = c("darkgreen",
                                "gold",
                                "orange",
                                "forestgreen",
                                "royalblue",
                                "orange4",
                                "Registro de ocorrência" = "black")) +
  scale_fill_manual(values = c("darkgreen",
                               "gold",
                               "orange",
                               "forestgreen",
                               "royalblue",
                               "orange4")) +
  coord_sf(xlim = c(-44, -35),
           ylim = c(-17, -4)) +
  theme_minimal() +
  theme(axis.text = element_text(size = 25, color = "black"),
        axis.title = element_text(size = 25, color = "black"),
        strip.background = element_rect(color = "black", fill = "gray", linewidth = 2),
        legend.text = element_text(size = 25, color = "black"),
        legend.position = "bottom") +
  ggview::canvas(height = 10, width = 12)

mapa_principal

## Insert map ----

insert_map <- ggplot() +
  geom_sf(data = biomas |>
            tidyr::drop_na(),
          aes(color = name_biome,
              fill = name_biome)) +
  geom_sf(data = estados, color = "black", linewidth = 0.5, fill = "transparent") +
  labs(color = NULL,
       fill = NULL,
       x = NULL,
       y = NULL) +
  scale_color_manual(values = c("darkgreen",
                                "gold",
                                "orange",
                                "forestgreen",
                                "royalblue",
                                "orange4")) +
  scale_fill_manual(values = c("darkgreen",
                               "gold",
                               "orange",
                               "forestgreen",
                               "royalblue",
                               "orange4")) +
  geom_rect(aes(xmin = -44,
                xmax = -35,
                ymin = -17,
                ymax = -4),
            color = "darkred",
            fill = "darkred",
            alpha = 0.3,
            linewidth = 2) +
  theme_void() +
  theme(legend.position = "none") +
  ggview::canvas(height = 10, width = 12)

insert_map

## Mapa final ----

cowplot::ggdraw(mapa_principal) +
  cowplot::draw_plot(insert_map,
                     x = 0.6,
                     y = 0.2,
                     height = 0.35,
                     width = 0.35) +
  ggview::canvas(height = 10, width = 12)

ggsave(filename = "mapa_seminario.png",
       height = 10, width = 12)
