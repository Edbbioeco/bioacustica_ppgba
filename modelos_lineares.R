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

acus <- purrr::map(readxl::excel_sheets, \(sheet){

  readxl::read_xlsx("valores_acustico.xlsx",
                        sheet = sheet)

                  }) |>
  dplyr::bind_rows()

### Visualizar ----

acus

acus |> dplyr::glimpse()
