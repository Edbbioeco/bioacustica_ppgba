# Pacotes ----

library(tidyverse)

library(readxl)

library(nlme)

library(broom)

library(performance)

library(ggview)

# Dados ----

## Variáveis ambientais ----

### Importar ----

var <- readxl::read_xlsx("valores_var.xlsx")

### Visualizar ----

var

var |> dplyr::glimpse()
