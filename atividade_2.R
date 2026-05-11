# Pacotes ----

library(tidyverse)

library(readxl)

library(ggpubr)

library(ggview)

# Dados ----

## Importar ----

dados <- purrr::map2(1:10,
            rep(c("Mulher", "Homem"), each = 5),
            \(id, gen){

              readxl::read_xlsx("gosta_de_cafe.xlsx",
                                sheet = id) |>
                dplyr::mutate(dplyr::across(.cols = 5:11,
                                            .fns = ~as.numeric(.)),
                              dplyr::across(.cols = dplyr::contains("Freq"),
                                            .fns = ~./1000),
                              ID = paste0(gen, " ", id))
            }) |>
  dplyr::bind_rows()
