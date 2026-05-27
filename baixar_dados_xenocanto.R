# Pacotes ----

library(suwo)

library(tidyverse)

# Dados ----

## Metadados ----

metadados <- suwo::query_xenocanto(species = "Myrmorchilus strigilatus")

metadados

metadados |> dplyr::glimpse()
