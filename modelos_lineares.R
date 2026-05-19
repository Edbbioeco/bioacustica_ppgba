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

acus_valores <- acus |>
  dplyr::filter(!View|> stringr::str_detect("Spectrogram")) |>
  dplyr::select(Local, `Peak Freq (Hz)`, `Delta Freq (Hz)`, `Delta Time (s)`) |>
  tidyr::fill(Local) |>
  dplyr::filter(!`Peak Freq (Hz)` |> is.na()) |>
  dplyr::mutate(dplyr::across(.cols = dplyr::contains(c("Freq", "Time")),
                              .fns = ~as.numeric(.)),
                `Peak Freq (Hz)` = `Peak Freq (Hz)` / 1e6,
                `Delta Freq (Hz)` = `Delta Freq (Hz)` / 1e6,
                `Delta Time (s)` = dplyr::if_else(`Delta Time (s)` > 1,
                                                  `Delta Time (s)` / 10000,
                                                  `Delta Time (s)`)) |>
  dplyr::rename("Peak Freq (khz)" = `Peak Freq (Hz)`,
                "Delta Freq (khz)" = `Delta Freq (Hz)`) |>
  janitor::clean_names() |>
  dplyr::mutate(numero_notas = dplyr::n(),
                .by = local) |>
  dplyr::ungroup() |>
  dplyr::summarise(dplyr::across(.cols = dplyr::where(is.numeric),
                                 .fns = ~mean(.)),
                   .by = local)

acus_valores

## Unir os dados ----

valores <- acus_valores |>
  dplyr::bind_cols(var |>
                     dplyr::filter(!Local |> stringr::str_detect("Chapada do Ar")) |>
                     dplyr::select(2:8))

valores |> as.data.frame()

# Modelos lineares ----

## Multicolinearidade ----

valores |>
  dplyr::select(8:12) |>
  cor(method = "spearman")

## Criar modelos ----

vars <- valores |>
  dplyr::select(2:5) |>
  names()

vars

modelos <- purrr::map(vars, \(vars){

  formula <- as.formula(paste(vars,
                              "~ solo + temperatura_quarto_mais_quante + precipitacao_quarto_mais_frio + SAVI"))

  nlme::gls(formula,
            data = valores,
            correlation = nlme::corExp(form = ~Longitude + Latitude, nugget = TRUE))

  }) |>
  setNames(paste0("modelo_", vars))

modelos

## Estatísticas dos modelos ----

purrr::map(modelos, summary)
