# Pacotes ----

library(av)

# Converter ----

av::av_audio_convert(audio = "vocalizacao.aac",
                     output = "vocalizacao.wav")
