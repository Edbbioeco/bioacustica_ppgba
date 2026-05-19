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

## Parâmetros acústicos ----

### Importar ----

acus <- readxl::read_xlsx("Bioacustica - Seminarios.xlsx")

### Visualizar ----

acus

acus |> dplyr::glimpse()

### Estatísticas dos parâmetros acústicos ----

acus |>
  dplyr::mutate(dplyr::across()) |>
  dplyr::summarise(numero_de_nomas = `número de notas` |> mean(),
                   frequencia_de_pico = `peak Freq (hz)` |> mean())
