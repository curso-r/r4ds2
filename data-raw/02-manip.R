library(tidyverse)

# us ----------------------------------------------------------------------

library(readxl)
library(janitor)

path <- "data-raw/xlsx/indicadoressegurancapublicamunicdez19.xlsx"

# Lê e empilha
da_sinesp <- path %>%
  excel_sheets() %>%
  map_dfr(read_xlsx, path = path, col_types = "text") %>%
  clean_names()

# filter ---
da_sinesp %>%
  filter(regiao == "NORTE")

da_sinesp %>%
  filter(regiao %in% c("NORTE", "SUL"))

da_sinesp %>%
  filter(regiao == "NORTE", sigla_uf == "AC")

# select ---
da_sinesp %>%
  select(1)

da_sinesp %>%
  select(1, 2)

da_sinesp %>%
  select(municipio, mes_ano)

da_sinesp %>%
  select(ends_with("o"))

da_sinesp %>%
  select(-mes_ano)

# mutate ---
da_sinesp_com_vitima_numerica <- da_sinesp %>%
  mutate(vitima = as.numeric(vitima))

da_sinesp %>%
  mutate(muni_upper = toupper(municipio),
         muni_lower = tolower(municipio),
         muni_rm = abjutils::rm_accent(municipio))

da_sinesp %>%
  # quem deu warnings?
  mutate(data = as.numeric(mes_ano),
         data = as.Date(data, origin = "1900-01-01"))


da_sinesp %>%
  mutate(data = as.numeric(mes_ano),
         data = as.Date(data, origin = "1900-01-01")) %>%
  filter(is.na(data))
# (vamos resolver isso depois com o {lubridate}!)


# categorizando variavel
da_sinesp %>%
  mutate(vitima = as.numeric(vitima),
         vitima_cat = cut(vitima, c(0, 10, 100, 200))) %>%
  filter(vitima == 0)


da_sinesp %>%
  filter(vitima == 0)

da_sinesp %>%
  mutate(vitima = as.numeric(vitima),
         vitima_cat = cut(vitima, c(0, 10, 100, 200), include.lowest = TRUE)) %>%
  filter(vitima == 0)

# arrange ---

da_sinesp %>%
  arrange(vitima)

# cuidado com os textos!
da_sinesp %>%
  filter(vitima > 10) %>%
  arrange(vitima) %>%
  print(n = 20)

da_sinesp %>%
  mutate(vitima = as.numeric(vitima)) %>%
  arrange(vitima)

# decrescente
da_sinesp %>%
  mutate(vitima = as.numeric(vitima)) %>%
  arrange(sigla_uf, desc(vitima))

# group_by() + summarise()

da_sinesp %>%
  mutate(vitima = as.numeric(vitima)) %>%
  group_by(regiao) %>%
  summarise(n = n(), soma = sum(vitima))

# armazenando o resultado numa variável

da_sumario <- da_sinesp %>%
  mutate(vitima = as.numeric(vitima)) %>%
  group_by(regiao) %>%
  summarise(n = n(), soma = sum(vitima)) %>%
  arrange(desc(soma))

# Exercicio um pouco mais desafiador (em aula)

# Crie uma base `da_vitimas_por_regiao` em que cada linha é a
# soma de vítimas de cada Estado e Região.
# mutate(), group_by(), summarise(sum())
# Extra: para remover os grupos, use ungroup()

da_vitimas_por_regiao <- da_sinesp %>%
  mutate(vitima = as.numeric(vitima)) %>%
  group_by(regiao, sigla_uf) %>%
  summarise(soma = sum(vitima)) %>%
  mutate(prop = soma / sum(soma))

da_vitimas_por_regiao <- da_sinesp %>%
  mutate(vitima = as.numeric(vitima)) %>%
  group_by(regiao, sigla_uf) %>%
  summarise(soma = sum(vitima)) %>%
  mutate(prop = soma / sum(soma)) %>%
  ungroup()



# you ---------------------------------------------------------------------

# Exercício (apague os __________)

da_resultado <- da_sinesp %>%
  # a. tire a coluna mes_ano com select
  select(-mes_ano) %>%
  # b. filtre apenas para região norte
  filter(regiao == "NORTE") %>%
  # c. usando mutate, deixe a coluna vítima como numérica
  mutate(vitima = as.numeric(vitima)) %>%
  # d. agrupe por estado
  group_by(sigla_uf) %>%
  # e. sumarise, mostrando o número de observações e a média de vítimas
  summarise(n = n(), media = mean(vitima)) %>%
  # f. ordene em ordem decrescente pela média de vítimas
  arrange(desc(media))

# EXTRA: faça um gráfico de barras com ggplot() e geom_col()
# com estado no eixo x, média de vítimas no eixo y e Região nas facets.
# Dica: utilize o `da_vitimas_por_regiao` que montamos anteriormente.






