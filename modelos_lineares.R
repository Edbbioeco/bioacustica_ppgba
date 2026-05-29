# Pacotes ----

library(readxl)

library(tidyverse)

library(nlme)

library(flextable)

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
  dplyr::select(Local,
                `Peak Freq (Hz)`,
                `Delta Freq (Hz)`,
                `Delta Time (s)`) |>
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
            data = valores[-14, ],
            correlation = nlme::corExp(form = ~Longitude + Latitude, nugget = TRUE))

  }) |>
  setNames(paste0("modelo_", vars))

modelos

## Estatísticas dos modelos ----

nome <- modelos |> names()

nome

estatisticas <- purrr::map2(modelos, vars, \(modelos, nome){

  modelos |>
    summary() %>%
    .$tTable |>
    as.data.frame() |>
    tibble::rownames_to_column() |>
    dplyr::rename("Preditor" = 1,
                  "β1" = 2,
                  "SE" = 3,
                  "t" = 4,
                  "p" = 5) |>
    dplyr::filter(!Preditor |> stringr::str_detect("Intercept")) |>
    dplyr::mutate(β1 = β1 |> round(4),
                  SE = SE |> round(4),
                  t = t |> round(3),
                  p = p |> round(2)) |>
    dplyr::mutate(Modelo =nome,
                  .before = Preditor)

  }) |>
  dplyr::bind_rows() |>
  dplyr::mutate(Modelo = dplyr::case_match(Modelo,
                                           "peak_freq_khz" ~ "Peak freq. (KHz)",
                                           "delta_freq_khz" ~ "Delta freq. (KHz)",
                                           "delta_time_s" ~ "Delta time (s)",
                                           "numero_notas" ~ "Número de notas"),
                Preditor = dplyr::case_match(Preditor,
                                             "solo" ~ "ECS (kg/m²)",
                                             "temperatura_quarto_mais_quante" ~ "TQQ (°C)",
                                             "precipitacao_quarto_mais_frio" ~ "PQF (mm)",
                                             .default = Preditor))

estatisticas |>
  flextable::flextable() |>
  flextable::width(width = 1.5,
                   j = 1) |>
  flextable::width(width = 1,
                   j = 2) |>
  flextable::align(align = "center", part = "all") |>
  flextable::bg(i = ~abs(t) >=qt(p = 0.05, df = 8, lower.tail = FALSE),
                bg = "grey") |>
  flextable::add_footer_lines(values = "ECS = Estoque de carbono do solo\nTQQ = Temperatura do quarto mais quente\nPQF = Precipitação do quarto mais frio\nSAVI = Soil-Adjusted Vegetation Index")

## R² ----

purrr::map(modelos, performance::r2)

## Gráfico ----

variaveis <- c("Frequência de Pico (KHZ)",
               "Intervalo de frequência (KHz)",
               "Intervalo da nota (s)",
               "Número de notas")

var_modelos <- estatisticas |>
  dplyr::pull(Modelo) |> unique()

var_modelos

sig <- purrr::map(var_modelos, \(modelos){

  estatisticas |>
    dplyr::filter(Modelo == modelos & abs(t) >= qt(p = 0.05, df = 8, lower.tail = FALSE)) |>
    dplyr::pull(Preditor)

  })

sig

purrr::pmap(list(vars, variaveis, sig),
            \(vars, variaveis, sig){

              valores[-14, ] |>
                dplyr::select(-elevacao) |>
                tidyr::pivot_longer(cols = 8:11,
                                    names_to = "Preditor",
                                    values_to = "Valor preditor") |>
                dplyr::mutate(Preditor = dplyr::case_match(
                                Preditor,
                                "solo" ~ "ECS (kg/m²)",
                                "temperatura_quarto_mais_quante" ~ "TQQ (°C)",
                                "precipitacao_quarto_mais_frio" ~ "PQF (mm)",
                                .default = Preditor),
                              Sig = dplyr::case_when(Preditor %in% sig ~ "Sim",
                                                     .default = "Não")) |>
                ggplot(aes(`Valor preditor`, .data[[vars]])) +
                geom_point(size = 5) +
                facet_wrap(~Preditor, scales = "free_x") +
                geom_smooth(data = . %>%
                              dplyr::filter(Sig == "Sim"),
                            method = "lm",
                            color = "blue",
                            se = FALSE) +
                labs(y = variaveis) +
                theme_bw() +
                theme(axis.text = element_text(size = 25, color = "black"),
                      axis.title = element_text(size = 25, color = "black"),
                      strip.background = element_rect(color = "black",
                                                      fill = "gray",
                                                      linewidth = 2),
                      strip.text = element_text(size = 25, color = "black"),
                      legend.text = element_text(size = 25, color = "black"),
                      legend.position = "bottom",
                      panel.background = element_rect(color = "black",
                                                      linewidth = 1)) +
                ggview::canvas(height = 10, width = 12)

            }) |>
  setNames(vars)

graficos <- purrr::pmap(list(vars, variaveis, sig),
            \(vars, variaveis, sig){

              valores[-14, ] |>
                dplyr::select(-elevacao) |>
                tidyr::pivot_longer(cols = 8:11,
                                    names_to = "Preditor",
                                    values_to = "Valor preditor") |>
                dplyr::mutate(Preditor = dplyr::case_match(
                                Preditor,
                                "solo" ~ "ECS (kg/m²)",
                                "temperatura_quarto_mais_quante" ~ "TQQ (°C)",
                                "precipitacao_quarto_mais_frio" ~ "PQF (mm)",
                                .default = Preditor),
                              Sig = dplyr::case_when(Preditor %in% sig ~ "Sim",
                                                     .default = "Não")) |>
                ggplot(aes(`Valor preditor`, .data[[vars]])) +
                geom_point(size = 5) +
                facet_wrap(~Preditor, scales = "free_x") +
                geom_smooth(data = . %>%
                              dplyr::filter(Sig == "Sim"),
                            method = "lm",
                            color = "blue",
                            se = FALSE) +
                labs(y = variaveis) +
                theme_bw() +
                theme(axis.text = element_text(size = 25, color = "black"),
                      axis.title = element_text(size = 25, color = "black"),
                      strip.background = element_rect(color = "black",
                                                      fill = "gray",
                                                      linewidth = 2),
                      strip.text = element_text(size = 25, color = "black"),
                      legend.text = element_text(size = 25, color = "black"),
                      legend.position = "bottom",
                      panel.background = element_rect(color = "black",
                                                      linewidth = 1))

            }) |>
  setNames(vars)

graficos

purrr::imap(graficos, \(graficos, nota){

  graficos

  ggsave(filename = paste0("grafico_", nota, ".png"),
         plot = graficos,
         height = 10, width = 12)

  })

