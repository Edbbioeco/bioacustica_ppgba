# Pacotes ----

library(readxl)

library(tidyverse)

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
