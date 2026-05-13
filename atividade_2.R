# Pacotes ----

library(tidyverse)

library(readxl)

library(flextable)

library(performance)

library(broom)

library(ggview)

# Dados ----

## Importar ----

dados <- purrr::pmap(list(1:10,
                          rep(c("Mulher", "Homem"), each = 5),
                          rep(1:5, 2)),
                     \(id, gen, id2){

              readxl::read_xlsx("gosta_de_cafe.xlsx",
                                sheet = id) |>
                dplyr::mutate(dplyr::across(.cols = 5:11,
                                            .fns = ~as.numeric(.)),
                              dplyr::across(.cols = dplyr::contains("Freq"),
                                            .fns = ~./1000),
                              Gênero = gen,
                              ID = paste0(gen, " ", id2))
            }) |>
  dplyr::bind_rows()

## Visualizar ----

dados

dados |> dplyr::glimpse()

## Tratar ----

dados <- dados |>
  tidyr::fill(Nota) |>
  dplyr::filter(!`Peak Freq (Hz)` |> is.na()) |>
  dplyr::select(Nota, Selection, `Peak Freq (Hz)`, Gênero, ID) |>
  dplyr::mutate(Nota = Nota |> forcats::fct_relevel(c("Gos",
                                                      "Ta",
                                                      "De",
                                                      "Ca",
                                                      "Fe")))

dados

# Estatísticas ----

## Estatísticas descritivas ----

### Média e Desvio Padrão ----

estatísticas <- dados |>
  dplyr::summarise(Média = `Peak Freq (Hz)` |>
                     mean() |>
                     round(2),
                   `Desvio Padrão` = `Peak Freq (Hz)` |>
                     sd() |>
                     round(2),
                   `Coeficiente de Variação` = (`Desvio Padrão` / Média) * 100 |>
                     round(2),
                   .by = c(Nota, Gênero))

estatísticas

### Tabela flextable ----

est_flex <- estatísticas |>
  flextable::flextable() |>
  flextable::align(align = "center", part = "all") |>
  flextable::width(width = 1.25) |>
  flextable::width(width = 1, j = 1:3)

est_flex

est_flex |> flextable::save_as_docx(path = "tabela_estatisticas_atividade_2.docx")

## Anova ----

### Notas ----

notas <- dados$Nota |> unique()

notas

### Criar modelos ----

anovas <- purrr::map(notas, \(nota){

  lm(`Peak Freq (Hz)` ~ Gênero, data = dados |>
                             dplyr::filter(Nota == nota))

  })

anovas

### Pressupostos ----

purrr::map(anovas, \(modelo){

  modelo |
    performance::check_normality() |>
    print()

  modelo |>
    performance::check_heteroscedasticity() |>
    print()

  modelo |>
    performance::check_model(check = c("normality",
                                       "qq",
                                       "homogeneity"))})

### Estatísticas ----

anova_esstatistica <- purrr::map2(notas, anovas, \(nota, modelo){

  anova(modelo) |>
    broom::tidy() |>
    dplyr::mutate(Nota = nota,
                  df = "1, 9",
                  statistic = statistic |> round(2),
                  p.value = p.value |> round(2)) |>
    dplyr::select(Nota, statistic, df, p.value) |>
    dplyr::rename(`F` = statistic,
                  `p-valor` = p.value)

  }) |>
  dplyr::bind_rows() |>
  tidyr::drop_na()

anova_esstatistica

### Tabela ----

anova_flex <- anova_esstatistica |>
  flextable::flextable() |>
  flextable::align(align = "center", part = "all")

anova_flex

anova_flex |>
  flextable::save_as_docx(path = "tabela_anova_atividade_2.docx")

## Gráfico ----

dados |>
  ggplot(aes(Gênero, `Peak Freq (Hz)`, fill = Gênero)) +
  geom_point(size = 4, shape = 21, stroke = 1) +
  facet_wrap(~Nota, scales = "free_y") +
  scale_fill_manual(values = c("goldenrod", "forestgreen")) +
  labs(y = "Frequência de pico (Hz)") +
  theme_classic() +
  theme(axis.text = element_text(size = 20, color = "black"),
        axis.title = element_text(size = 20, color = "black"),
        strip.text = element_text(size = 20, color = "black"),
        strip.background = element_rect(color = "black", fill = "gray", linewidth = 2),
        legend.position = "none",
        axis.line = element_line(color = "black", linewidth = 1)) +
  ggview::canvas(height = 10, width = 12)

ggsave(filename = "gráfico_atividade_2.png",
       height = 10, width = 12)
