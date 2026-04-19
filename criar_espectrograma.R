# Pacotees ----

library(seewave)

library(viridis)

# Dados ----

## Importar ----

voc <- tuneR::readWave("vocalizacao.wav")

## Visualizar ----

voc

# Espectrograma -----

## Criar espectrograma ----

voc |> seewave::spectro(flim = c(0.15, 0.72),
                        tlim = c(16.275, 16.625),
                        palette = viridis::inferno)

## Criar espectrograma com oscilograma ----

voc |> seewave::spectro(flim = c(0.15, 0.72),
                        tlim = c(16.275, 16.625),
                        palette = viridis::inferno,
                        osc = TRUE)

## Criar oscilograma ----

voc |> seewave::oscillo(from = 16.275, to = 16.625)
