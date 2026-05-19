# PAcotes ----

library(readxl)

library(tidyverse)

library(geobr)

library(ggview)

# Dados ----

## Registros ----

### Importar ----

loc <- readxl::read_xlsx("valores_var.xlsx")

### Visualizar ----

loc

loc |> dplyr::glimpse()
