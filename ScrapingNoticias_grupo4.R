library(tidyverse)
library(rvest)
library(dplyr)
library(stringr)
library(tibble)


noticias_inflacion_3_ <- tibble(
  url    = character(),
  fecha  = character(),
  medio  = character(),
  titulo = character(),
  cuerpo = character()
)


glimpse(noticias_inflacion_3_)
view(noticias_inflacion_3_)

library(tibble)
library(rvest)
library(dplyr)
library(stringr)
library(purrr)
library(tibble)

noticias_inflacion_3_ <- tibble(
  url    = character(),
  fecha  = character(),
  medio  = character(),
  titulo = character(),
  cuerpo = character()
)


glimpse(noticias_inflacion_3_)



#NOTICIAS ALBERTO  PAGINA 12 Y LA NACION

scrapear_pagina12 <- function(url, fecha) {
  pagina <- read_html(url)
  titulo <- pagina %>% 
    html_element("h1") %>%
    html_text2() %>%
    str_squish()
  cuerpo <- pagina %>% 
    html_element("div.article-main-content.article-text") %>% 
    html_elements("p") %>% 
    html_text2() %>% 
    str_squish() %>% 
    str_c(collapse = " ")
  tibble(
    url    = url,
    fecha  = fecha,
    medio  = "Página 12",
    titulo = titulo,
    cuerpo = cuerpo
  )
}


links_p12 <- tribble(
  ~url,                                                                 ~fecha,
  "https://www.pagina12.com.ar/323225-la-inflacion-de-enero-fue-del-4-por-ciento",                        "2021-01",
  "https://www.pagina12.com.ar/329025-la-inflacion-aflojo-un-poco-pero-sigue-alta",                        "2021-02",
  "https://www.pagina12.com.ar/335865-la-inflacion-de-marzo-fue-del-4-8",                                  "2021-03",
  "https://www.pagina12.com.ar/341395-la-inflacion-en-abril-fue-del-4-1-por-ciento",                       "2021-04",
  "https://www.pagina12.com.ar/348724-la-inflacion-de-mayo-marco-3-3-por-ciento",                          "2021-05",
  "https://www.pagina12.com.ar/355079-la-inflacion-fue-3-2-en-junio",                                      "2021-06",
  "https://www.pagina12.com.ar/361216-inflacion-que-paso-en-julio-y-como-sigue-en-el-ano",                 "2021-07",
  "https://www.pagina12.com.ar/368368-la-inflacion-anoto-2-5-por-ciento-en-agosto",                        "2021-08",
  "https://www.pagina12.com.ar/374631-la-inflacion-se-acelero-en-septiembre",                              "2021-09",
  "https://www.pagina12.com.ar/383715-canastas-por-debajo-de-la-inflacion",                                "2021-10",
  "https://www.pagina12.com.ar/389408-precios-cuidados-y-desinflacion",                                    "2021-11",
  "https://www.pagina12.com.ar/395218-indec-la-inflacion-en-2021-fue-de-50-9",                             "2021-12",
  "https://www.pagina12.com.ar/401872-la-tormenta-de-subas-de-precios-version-2022",                       "2022-01",
  "https://www.pagina12.com.ar/408226-la-inflacion-de-febrero-por-las-nubes",                              "2022-02",
  "https://www.pagina12.com.ar/415154-inflacion-record-alza-del-6-7-por-ciento",                           "2022-03",
  "https://www.pagina12.com.ar/421824-ante-las-dificultades-avanzar",                                      "2022-04",
  "https://www.pagina12.com.ar/428129-la-inflacion-fue-de-5-4-por-ciento-en-mayo",                         "2022-05",
  "https://www.pagina12.com.ar/437180-la-inflacion-de-junio-fue-de-5-3-por-ciento",                        "2022-06",
  "https://www.pagina12.com.ar/472685-la-inflacion-de-julio-fue-record-desde-2002",                       "2022-07",
  "https://www.pagina12.com.ar/482076-la-inflacion-de-agosto-se-mantuvo-en-7-por-ciento",                  "2022-08",
  "https://www.pagina12.com.ar/489825-la-inflacion-fue-del-6-2-por-ciento-en-spetiembre",                  "2022-09",
  "https://www.pagina12.com.ar/498080-la-inflacion-fue-del-6-3",                                           "2022-10",
  "https://www.pagina12.com.ar/508277-inflacion-el-indice-de-noviembre-comenzo-con-4",                     "2022-11",
  "https://www.pagina12.com.ar/516762-suben-los-precios-mayoristas",                                       "2022-12",
  "https://www.pagina12.com.ar/523912-en-enero-la-inflacion-volvio-a-subir-y-se-ubico-en-el-6-por-",        "2023-01",
  "https://www.pagina12.com.ar/530529-fue-de-6-3-la-inflacion-de-los-trabajadores",                        "2023-02",
  "https://www.pagina12.com.ar/540637-la-inflacion-sigue-en-alza-razones-del-historico-7-7-por-cie",       "2023-03",
  "https://www.pagina12.com.ar/548785-abril-marco-un-nuevo-record-en-la-inflacion-causas-de-una-ac",      "2023-04",
  "https://www.pagina12.com.ar/558393-se-desacelero-la-inflacion-en-mayo-pero-sigue-en-niveles-his",       "2023-05",
  "https://www.pagina12.com.ar/567754-la-inflacion-de-junio-marco-6-0-por-ciento",                         "2023-06",
  "https://www.pagina12.com.ar/578770-el-indec-publica-el-ipc-de-julio",                                   "2023-07",
  "https://www.pagina12.com.ar/587839-el-alimento-de-una-inflacion-de-dos-digitos",                        "2023-08",
  "https://www.pagina12.com.ar/597867-la-inflacion-golpeo-en-septiembre-con-un-12-7",                      "2023-09",
  "https://www.pagina12.com.ar/616194-en-octubre-la-inflacion-fue-del-8-3",                                "2023-10",
  "https://www.pagina12.com.ar/694950-la-inflacion-fue-12-8-por-ciento-en-noviembre",                     "2023-11",
  "https://www.pagina12.com.ar/703269-el-combo-de-devaluacion-y-desregulacion-pego-a-fondo-en-la-i",      "2023-12"
)


nuevas_p12 <- links_p12 %>% 
  mutate(noticia = map2(url, fecha, scrapear_pagina12)) %>% 
  select(noticia) %>% 
  unnest(noticia)


noticias_inflacion_3_ <- bind_rows(noticias_inflacion_3_, nuevas_p12)


glimpse(noticias_inflacion_3_)
view(noticias_inflacion_3_)



urls_ln <- c(
  "https://www.lanacion.com.ar/economia/la-inflacion-enero-fue-4-se-mantiene-nid2599308/",
  "https://www.lanacion.com.ar/economia/precios-la-inflacion-fue-en-febrero-de-36-nid11032021/",
  "https://www.lanacion.com.ar/economia/crisis-se-disparan-los-precios-de-los-alimentos-y-la-inflacion-de-marzo-fue-de-48-nid15042021/",
  "https://www.lanacion.com.ar/economia/la-inflacion-en-abril-fue-del-41-y-acumula-176-en-cuatro-meses-informo-el-indec-nid13052021/",
  "https://www.lanacion.com.ar/economia/la-inflacion-fue-de-33-y-acumula-215-en-el-ano-nid16062021/",
  "https://www.lanacion.com.ar/economia/la-inflacion-de-junio-fue-de-32-y-acumulo-253-en-el-primer-semestre-nid15072021/",
  "https://www.lanacion.com.ar/economia/la-inflacion-de-julio-fue-de-3-y-acumulo-291-en-lo-que-va-del-ano-nid12082021/",
  "https://www.lanacion.com.ar/economia/la-inflacion-de-agosto-fue-25-y-logro-perforar-el-piso-de-3-despues-de-un-ano-nid14092021/",
  "https://www.lanacion.com.ar/economia/impacto-en-el-bolsillo-la-inflacion-volvio-a-acelerare-en-septiembre-y-cerro-a-35-nid14102021/",
  "https://www.lanacion.com.ar/economia/pese-al-congelamiento-de-precios-la-inflacion-de-octubre-fue-de-35-y-rompio-otra-meta-de-martin-nid11112021/",
  "https://www.lanacion.com.ar/economia/la-inflacion-fue-de-25-en-noviembre-y-ya-suma-454-en-lo-que-va-del-ano-nid14122021/",
  "https://www.lanacion.com.ar/economia/negocios/sin-techo-la-inflacion-de-diciembre-llego-al-38-y-2021-cerro-con-una-suba-de-509-nid13012022/",
  "https://www.lanacion.com.ar/economia/con-un-fuerte-aumento-en-los-alimentos-la-inflacion-de-enero-fue-de-39-nid15022022/",
  "https://www.lanacion.com.ar/economia/el-aumento-de-los-alimentos-no-cede-y-la-inflacion-de-febrero-trepo-a-47-nid15032022/",
  "https://www.lanacion.com.ar/economia/inflacion-de-marzo-la-argentina-quedo-segunda-en-el-mundo-solo-superada-por-rusia-nid13042022/",
  "https://www.lanacion.com.ar/economia/mes-a-mes-el-estrepitoso-fracaso-de-un-funcionario-que-quedo-en-la-mira-nid14042022/",
  "https://www.lanacion.com.ar/economia/la-inflacion-de-mayo-fue-de-51-y-en-un-ano-ya-supera-un-alza-de-un-60-nid14062022/",
  "https://www.lanacion.com.ar/economia/la-inflacion-de-junio-fue-de-53-y-llega-a-64-en-un-ano-nid14072022/",
  "https://www.lanacion.com.ar/economia/inflacion-record-que-lugar-ocupa-la-argentina-en-comparacion-con-otros-paises-de-la-region-nid11082022/",
  "https://www.lanacion.com.ar/economia/la-inflacion-ya-supero-la-peor-marca-de-macri-alcanzo-el-mayor-numero-en-mas-de-30-anos-y-se-nid14092022/",
  "https://www.lanacion.com.ar/politica/inflacion-de-62-en-septiembre-opositores-criticaron-al-gobierno-por-el-rumbo-de-la-economia-nid14102022/",
  "https://www.lanacion.com.ar/economia/la-inflacion-fue-de-63-en-octubre-y-suma-88-en-12-meses-nid15112022/",
  "https://www.lanacion.com.ar/economia/la-inflacion-fue-de-49-en-noviembre-y-acumula-924-en-doce-meses-nid15122022/",
  "https://www.lanacion.com.ar/economia/la-inflacion-de-diciembre-fue-de-51-y-cerro-2022-con-un-aumento-de-948-nid12012023/",
  "https://www.lanacion.com.ar/economia/el-gobierno-admite-que-la-inflacion-se-acelera-y-prepara-nuevas-medidas-nid13022023/",
  "https://www.lanacion.com.ar/economia/la-inflacion-de-febrero-fue-de-66-y-supero-el-100-interanual-por-primera-vez-en-mas-de-30-anos-nid14032023/",
  "https://www.lanacion.com.ar/economia/inflacion-de-marzo-de-2023-fue-77-y-acumula-1043-en-12-meses-nid14042023/",
  "https://www.lanacion.com.ar/economia/inflacion-de-abril-de-2023-fue-84-y-acumula-1088-en-12-meses-nid12052023/",
  "https://www.lanacion.com.ar/editoriales/la-inflacion-que-duele-a-la-gente-y-amenaza-al-gobierno-nid19062023/",
  "https://www.lanacion.com.ar/economia/la-inflacion-de-junio-fue-de-6-y-alcanzo-un-1156-en-12-meses-nid13072023/",
  "https://www.lanacion.com.ar/economia/la-inflacion-acelero-en-julio-a-63-y-pronostican-que-acumularia-hasta-un-25-en-los-proximos-dos-nid15082023/",
  "https://www.lanacion.com.ar/economia/la-inflacion-de-los-pobres-tras-la-devaluacion-y-por-la-suba-de-alimentos-se-disparo-un-17-en-agosto-nid15092023/",
  "https://www.lanacion.com.ar/economia/luego-de-la-devaluacion-segun-el-indec-la-inflacion-de-septiembre-fue-de-127-y-los-precios-subieron-nid12102023/",
  "https://www.lanacion.com.ar/economia/la-inflacion-de-octubre-fue-de-83-y-acumulo-1427-en-12-meses-nid13112023/",
  "https://www.lanacion.com.ar/economia/la-inflacion-fue-de-128-en-noviembre-y-el-ano-cerrara-con-la-mayor-suba-de-precios-desde-la-hiper-de-nid13122023/",
  "https://www.lanacion.com.ar/economia/inflacion-de-diciembre-los-rubros-que-mas-aumentaron-nid11012024/"
)

fechas_ln <- c(
  "2021-01","2021-02","2021-03","2021-04","2021-05","2021-06","2021-07","2021-08","2021-09","2021-10","2021-11","2021-12",
  "2022-01","2022-02","2022-03","2022-04","2022-05","2022-06","2022-07","2022-08","2022-09","2022-10","2022-11","2022-12",
  "2023-01","2023-02","2023-03","2023-04","2023-05","2023-06","2023-07","2023-08","2023-09","2023-10","2023-11","2023-12"
)


scrapear_lanacion <- function(url, fecha) {
  pagina <- read_html(url)
  titulo <- pagina %>%
    html_element("h1") %>%
    html_text2() %>%
    str_squish()
  cuerpo <- pagina %>%
    html_elements("p") %>%
    html_text2() %>%
    str_squish() %>%
    str_c(collapse = " ")
  tibble(
    url    = url,
    fecha  = fecha,
    medio  = "La Nación",
    titulo = titulo,
    cuerpo = cuerpo
  )
}

nuevas_ln <- map2_dfr(urls_ln, fechas_ln, scrapear_lanacion)
noticias_inflacion_3_ <- bind_rows(noticias_inflacion_3_, nuevas_ln)


glimpse(noticias_inflacion_3_)
view(noticias_inflacion_3_)
#NOTICIAS MACRI 2016

url <- "https://www.lanacion.com.ar/economia/la-inflacion-de-enero-fue-de-36-segun-el-indice-congreso-nid1871442/"


pagina <- read_html(url)


titulo <- pagina %>% html_element("h1") %>% html_text2()


parrafos <- pagina %>% html_elements("p") %>% html_text2()


cuerpo <- str_c(parrafos, collapse = " ")


nueva_noticia <- tibble(
  url = url,
  fecha = "2016-01",
  medio = "La Nación",
  titulo = titulo,
  cuerpo = cuerpo
)

noticias_inflacion_3_ <- bind_rows(noticias_inflacion_3_, nueva_noticia)

View(noticias_inflacion_3_)



urls <- c(
  "https://www.lanacion.com.ar/economia/la-inflacion-de-febrero-cerca-de-4-nid1878241/",
  "https://www.lanacion.com.ar/economia/llegaria-a-33-la-inflacion-de-marzo-nid1888391/",
  "https://www.lanacion.com.ar/economia/por-tarifas-la-inflacion-de-abril-fue-de-65-nid1898256/",
  "https://www.lanacion.com.ar/economia/la-inflacion-fue-del-42-en-mayo-y-el-indec-vuelve-a-publicar-sus-precios-nid1909416/",
  "https://www.lanacion.com.ar/economia/la-inflacion-en-junio-fue-del-31-11-puntos-menor-a-la-de-mayo-nid1918074/",
  "https://www.lanacion.com.ar/economia/segun-el-indec-la-inflacion-se-desacelero-en-julio-y-cayo-al-2-nid1927810/",
  "https://www.lanacion.com.ar/economia/por-el-freno-al-tarifazo-agosto-tuvo-la-menor-inflacion-en-12-anos-nid1937526/",
  "https://www.lanacion.com.ar/economia/la-inflacion-se-desacelera-fue-11-en-septiembre-pero-los-alimentos-no-aflojan-nid1946735/",
  "https://www.lanacion.com.ar/economia/por-el-impacto-del-aumento-de-gas-la-inflacion-de-octubre-fue-de-24-nid1955057/",
  "https://www.lanacion.com.ar/economia/la-inflacion-de-noviembre-fue-de-16-nid1967350/",
  "https://www.lanacion.com.ar/economia/la-inflacion-de-diciembre-fue-del-12-para-el-indec-nid1974936/"
)
fechas <- c(
  "2016-02", "2016-03", "2016-04", "2016-05", "2016-06", 
  "2016-07", "2016-08", "2016-09", "2016-10", "2016-11", "2016-12"
)


nuevas_noticias <- purrr::map2_dfr(urls, fechas, function(url, fecha) {
  pagina <- read_html(url)
  titulo <- pagina %>% html_element("h1") %>% html_text2()
  parrafos <- pagina %>% html_elements("p") %>% html_text2()
  cuerpo <- str_c(parrafos, collapse = " ")
  tibble(
    url = url,
    fecha = fecha,
    medio = "La Nación",
    titulo = titulo,
    cuerpo = cuerpo
  )
})


noticias_inflacion_3_ <- bind_rows(noticias_inflacion_3_, nuevas_noticias)


view(noticias_inflacion_3_)
#PAGINA12



url <- "https://www.pagina12.com.ar/diario/economia/2-292233-2016-02-11.html"


pagina <- read_html(url)


titulo <- pagina %>% html_element("h2") %>% html_text2()


parrafos <- pagina %>% html_elements("body p") %>% html_text2()
cuerpo <- str_c(parrafos, collapse = " ")


cat("TITULO:\n", titulo, "\n\n")
cat("CUERPO:\n", str_sub(cuerpo, 1, 300), "...")


noticia <- tibble(
  url = "https://www.pagina12.com.ar/diario/economia/2-292233-2016-02-11.html",
  fecha = "2016-01",
  medio = "Página 12",
  titulo = titulo,
  cuerpo = cuerpo
)


noticias_inflacion_3_ <- bind_rows(noticias_inflacion_3_, noticia)
view(noticias_inflacion_3_)


urls <- c(
  "https://www.pagina12.com.ar/diario/economia/2-294285-2016-03-11.html",
  "https://www.pagina12.com.ar/diario/economia/2-296997-2016-04-15.html",
  "https://www.pagina12.com.ar/diario/economia/2-299213-2016-05-13.html",
  "https://www.pagina12.com.ar/diario/economia/2-301884-2016-06-16.html",
  "https://www.pagina12.com.ar/diario/economia/2-304209-2016-07-14.html",
  "https://www.pagina12.com.ar/diario/economia/2-306774-2016-08-13.html",
  "https://www.pagina12.com.ar/diario/economia/2-309352-2016-09-14.html",
  "https://www.pagina12.com.ar/diario/economia/2-311752-2016-10-14.html"
)

fechas <- c(
  "2016-02", "2016-03", "2016-04", "2016-05", 
  "2016-06", "2016-07", "2016-08", "2016-09"
)


scrapear_pagina12_antigua <- function(url, fecha) {
  pagina <- read_html(url)
  titulo <- pagina %>% html_element("h2") %>% html_text2()
  cuerpo <- pagina %>% html_elements("body p") %>% html_text2() %>% str_c(collapse = " ")
  tibble(
    url = url,
    fecha = fecha,
    medio = "Página 12",
    titulo = titulo,
    cuerpo = cuerpo
  )
}


nuevas_noticias <- map2_dfr(urls, fechas, scrapear_pagina12_antigua)
noticias_inflacion_3_ <- bind_rows(noticias_inflacion_3_, nuevas_noticias)

view(noticias_inflacion_3_)


urls <- c(
  "https://www.pagina12.com.ar/2427-sigue-la-inflacion-pero-lo-festejan",
  "https://www.pagina12.com.ar/8945-mas-inflacion-con-los-alimentos-a-la-cabeza",
  "https://www.pagina12.com.ar/13712-sin-cifra-de-inflacion-anual-por-el-apagon"
)

fechas <- c("2016-10", "2016-11", "2016-12")


scrapear_pagina12 <- function(url, fecha) {
  pagina <- read_html(url)
  titulo <- pagina %>% html_element("h1") %>% html_text2()
  cuerpo <- pagina %>% html_elements("p") %>% html_text2() %>% str_c(collapse = " ")
  tibble(
    url = url,
    fecha = fecha,
    medio = "Pagina12",
    titulo = titulo,
    cuerpo = cuerpo
  )
}


nuevas_noticias <- purrr::map2_dfr(urls, fechas, scrapear_pagina12)


noticias_inflacion_3_ <- bind_rows(noticias_inflacion_3_, nuevas_noticias)


noticias_inflacion_3_ <- noticias_inflacion_3_ %>% arrange(fecha)


view(noticias_inflacion_3_)

#MACRI2017 PAGINA 12



urls <- c(
  "https://www.pagina12.com.ar/19194-la-inflacion-de-enero-trepo-un-1-3-por-ciento",  # 2017-01
  "https://www.pagina12.com.ar/24866-la-inflacion-no-se-dio-por-enterada",             # 2017-02
  "https://www.pagina12.com.ar/31266-le-torcemos-el-brazo",                            # 2017-03
  "https://www.pagina12.com.ar/36978-con-precios-asi-no-hay-meta-que-alcance",         # 2017-04
  "https://www.pagina12.com.ar/43027-los-precios-subieron-1-3-por-ciento-en-mayo",     # 2017-05
  "https://www.pagina12.com.ar/49565-como-bajar-la-inflacion-con-precios-que-suben",   # 2017-06
  "https://www.pagina12.com.ar/55355-la-inflacion-ya-va-por-24",                       # 2017-07
  "https://www.pagina12.com.ar/62478-la-meta-de-inflacion-tambien-te-la-debo",         # 2017-08
  "https://www.pagina12.com.ar/68117-la-inflacion-desbordo-la-meta-del-bcra",          # 2017-09
  "https://www.pagina12.com.ar/76016-no-hay-suba-de-tasas-que-frene-la-inflacion",     # 2017-10
  "https://www.pagina12.com.ar/82280-los-precios-siguen-sin-freno",                    # 2017-11
  "https://www.pagina12.com.ar/88636-esclavo-de-sus-palabras"                          # 2017-12
)
fechas <- c("2017-01", "2017-02", "2017-03", "2017-04", "2017-05", "2017-06",
            "2017-07", "2017-08", "2017-09", "2017-10", "2017-11", "2017-12")

scrapear_pagina12_2017 <- function(url, fecha) {
  pagina <- read_html(url)
  titulo <- pagina %>% html_nodes("h1, h2") %>% html_text(trim = TRUE) %>% first()
  parrafos <- pagina %>% html_nodes("div.article-text p, div.texto p, div.note_text p, div#cuerpo p") %>% html_text(trim = TRUE)
  cuerpo <- str_c(parrafos, collapse = " ")
  tibble(
    url = url,
    fecha = fecha,
    medio = "Pagina12",
    titulo = titulo,
    cuerpo = cuerpo
  )
}


noticias_pagina12_2017 <- purrr::map2_dfr(urls, fechas, scrapear_pagina12_2017)


noticias_pagina12_2017 %>%
  mutate(cuerpo_preview = str_sub(cuerpo, 1, 300)) %>%
  select(fecha, titulo, cuerpo_preview)
noticias_inflacion_3_ <- bind_rows(noticias_inflacion_3_, noticias_pagina12_2017)


View(noticias_inflacion_3_)





#MACRI2017 LA NACIÓN



urls <- c(
  "https://www.lanacion.com.ar/economia/la-inflacion-de-enero-fue-del-13-segun-el-indec-nid1983182/",
  "https://www.lanacion.com.ar/economia/la-inflacion-de-febrero-fue-del-25-segun-el-indec-nid1991546/",
  "https://www.lanacion.com.ar/economia/la-inflacion-de-marzo-fue-del-24-segun-el-indec-nid2008801/",
  "https://www.lanacion.com.ar/economia/la-inflacion-fue-de-26-en-abril-y-trepo-a-275-en-12-meses-segun-el-indec-nid2022591/",
  "https://www.lanacion.com.ar/economia/indec-la-inflacion-en-mayo-fue-del-13-nid2031711/",
  "https://www.lanacion.com.ar/economia/la-inflacion-de-junio-fue-del-12-segun-el-indec-nid2041765/",
  "https://www.lanacion.com.ar/economia/el-ipc-de-julio-fue-de-xx-y-la-inflacion-acumula-xx-en-lo-que-va-del-ano-nid2051779/",
  "https://www.lanacion.com.ar/economia/la-inflacion-de-agosto-fue-de-14-y-acumula-154-en-lo-que-va-del-ano-nid2062190/",
  "https://www.lanacion.com.ar/economia/indec-la-inflacion-de-septiembre-fue-del-19-y-acumula-176-en-el-ano-nid2071565/",
  "https://www.lanacion.com.ar/economia/la-inflacion-de-octubre-fue-15-y-acumulo-en-el-ano-194-nid2082210/",
  "https://www.lanacion.com.ar/economia/la-inflacion-de-noviembre-cerro-en-14-pero-esperan-que-este-mes-supere-el-25-nid2090876/",
  "https://www.lanacion.com.ar/economia/indec-la-inflacion-en-diciembre-fue-del-31-y-llego-al-248-en-el-ano-nid2099776/"
)
fechas <- c(
  "2017-01", "2017-02", "2017-03", "2017-04",
  "2017-05", "2017-06", "2017-07", "2017-08",
  "2017-09", "2017-10", "2017-11", "2017-12"
)


noticias_preview <- map2_dfr(urls, fechas, function(url, fecha) {
  pagina <- read_html(url)
  titulo <- pagina %>% html_element("h1") %>% html_text2()
  parrafos <- pagina %>% html_elements("h2,p") %>% html_text2()
  cuerpo <- str_c(parrafos, collapse = " ")
  tibble(url = url, fecha = fecha, medio = "La Nación", titulo = titulo, cuerpo = cuerpo)
})

noticias_preview %>%
  mutate(preview = str_sub(cuerpo, 1, 300)) %>%
  select(fecha, titulo, preview)


noticias_inflacion_3_ <- bind_rows(noticias_inflacion_3_, noticias_preview)



View(noticias_inflacion_3_)
#MACRI 2018 LA NACION



urls <- c(
  "https://www.lanacion.com.ar/economia/la-inflacion-en-enero-fue-del-18-y-acumula-una-suba-del-25-en-los-ultimos-12-meses-nid2109445/",
  "https://www.lanacion.com.ar/economia/indec-por-el-impacto-de-las-tarifas-la-inflacion-de-febrero-fue-de-24-nid2116936/",
  "https://www.lanacion.com.ar/economia/inflacion-marzo-2018-indec-caba-nid2124976/",
  "https://www.lanacion.com.ar/economia/dolar/la-inflacion-de-abril-fue-de-27-y-esperan-una-suba-arriba-de-2-en-mayo-nid2134822/",
  "https://www.lanacion.com.ar/economia/dolar/la-inflacion-fue-del-21-en-mayo-y-acumulo-119-en-los-primeros-cinco-meses-del-ano-nid2143950/",
  "https://www.lanacion.com.ar/economia/la-inflacion-de-junio-fue-de-37-el-numero-mas-alto-de-los-ultimos-dos-anos-nid2153950/",
  "https://www.lanacion.com.ar/economia/dolar/la-inflacion-de-julio-fue-del-31-y-este-ano-cerraria-en-torno-de-35-nid2162826/",
  "https://www.lanacion.com.ar/economia/dolar/inflacion-indec-agosto-nid2171672/",
  "https://www.lanacion.com.ar/economia/inflacion-nid2182584/",
  "https://www.lanacion.com.ar/economia/indec-inflacion-octubre-ipc-nid2192047/",
  "https://www.lanacion.com.ar/economia/dolar/inflacion-diciembre-2018-indec-precios-nid2211091/"
)

fechas <- c(
  "2018-01", "2018-02", "2018-03", "2018-04", "2018-05", 
  "2018-06", "2018-07", "2018-08", "2018-09", "2018-10", "2018-12"
)


scrapear_lanacion <- function(url, fecha) {
  pagina <- read_html(url)
  titulo <- pagina %>% html_element("h1") %>% html_text2()
  cuerpo <- pagina %>% html_elements("p") %>% html_text2() %>% str_c(collapse = " ")
  tibble(
    url = url,
    fecha = fecha,
    medio = "La Nación",
    titulo = titulo,
    cuerpo = cuerpo
  )
}


nuevas_noticias <- map2_dfr(urls, fechas, scrapear_lanacion)
noticias_inflacion_3_ <- bind_rows(noticias_inflacion_3_, nuevas_noticias)
#MACRI2018 PAGINA12




urls <- c(
  "https://www.pagina12.com.ar/96259-la-inflacion-ataca-de-nuevo",         
  "https://www.pagina12.com.ar/100586-los-tarifazos-y-la-redistribucion",
  "https://www.pagina12.com.ar/107789-los-precios-desmienten-la-palabra-oficial",
  "https://www.pagina12.com.ar/115076-a-la-corrida-de-precios-no-hay-quien-la-pare",
  "https://www.pagina12.com.ar/121716-el-indec-m-le-hizo-precio-a-la-inflacion",
  "https://www.pagina12.com.ar/129032-querida-agrande-los-precios",
  "https://www.pagina12.com.ar/135539-bajar-la-inflacion-al-final-no-era-tan-facil",
  "https://www.pagina12.com.ar/142125-mes-a-mes-los-precios-baten-su-propio-record",
  "https://www.pagina12.com.ar/149554-6-5-la-inflacion-en-orbita",
  "https://www.pagina12.com.ar/155783-al-infinito-y-mas-alla",
  "https://www.pagina12.com.ar/161974-disparada-de-precios-que-no-cesa",
  "https://www.pagina12.com.ar/168684-no-fue-magia-el-record-de-inflacion-de-macri"
)

fechas <- c(
  "2018-01", "2018-02", "2018-03", "2018-04",
  "2018-05", "2018-06", "2018-07", "2018-08",
  "2018-09", "2018-10", "2018-11", "2018-12"
)

scrapear_pagina12_2018 <- function(url, fecha) {
  pagina <- read_html(url)
  titulo <- pagina %>% html_nodes("h1, h2") %>% html_text(trim = TRUE) %>% first()
  parrafos <- pagina %>% html_nodes("div.article-text p, div.texto p, div.note_text p, div#cuerpo p") %>% html_text(trim = TRUE)
  cuerpo <- str_c(parrafos, collapse = " ")
  tibble(url = url, fecha = fecha, medio = "Pagina12", titulo = titulo, cuerpo = cuerpo)
}

noticias_pagina12_2018 <- purrr::map2_dfr(urls, fechas, scrapear_pagina12_2018)


noticias_pagina12_2018 %>%
  mutate(cuerpo_preview = str_sub(cuerpo, 1, 300)) %>%
  select(fecha, titulo, cuerpo_preview)
for(i in 1:nrow(noticias_pagina12_2018)) {
  cat("Noticia", i, "(", noticias_pagina12_2018$fecha[i], "):\n")
  cat(str_sub(noticias_pagina12_2018$cuerpo[i], 1, 300), "\n\n")
}
noticias_inflacion_3_ <- bind_rows(noticias_inflacion_3_, noticias_pagina12_2018)

#Macri2019 La nación


urls <- c(
  "https://www.lanacion.com.ar/economia/inflacion-enero-indec-nid2220192/",
  "https://www.lanacion.com.ar/economia/inflacion-febrero-indec-nid2228589/",
  "https://www.lanacion.com.ar/economia/inflacion-marzo-indec-nid2238909/",
  "https://www.lanacion.com.ar/economia/quiebre-la-inflacion-fue-xx-abril-menos-nid2248050/",
  "https://www.lanacion.com.ar/economia/inflacion-indec-mayo-nid2257664/",
  "https://www.lanacion.com.ar/economia/inflacion-indec-junio-nid2268197/",
  "https://www.lanacion.com.ar/economia/la-inflacion-julio-fue-xx-pero-se-nid2277822/",
  "https://www.lanacion.com.ar/economia/inflacion-indec-agosto-nid2287151/",
  "https://www.lanacion.com.ar/economia/dolar-la-inflacion-septiembre-fue-acumula-nid2297680/",
  "https://www.lanacion.com.ar/economia/dolar-la-inflacion-septiembre-fue-acumula-nid2297680/", 
  "https://www.lanacion.com.ar/economia/inflacion-indec-octubre-nid2306463/",
  "https://www.lanacion.com.ar/economia/inflacion-noviembre-indec-nid2315192/",
  "https://www.lanacion.com.ar/economia/precios-la-inflacion-2019-fue-mas-alta-nid2324218/"
)
fechas <- c(
  "2019-01", "2019-02", "2019-03", "2019-04", "2019-05", "2019-06", 
  "2019-07", "2019-08", "2019-09", "2019-09", "2019-10", "2019-11", "2019-12"
)


scrapear_ln <- function(url, fecha) {
  pagina <- read_html(url)
  titulo <- pagina %>% html_element("h1") %>% html_text2()
  parrafos <- pagina %>% html_elements("p") %>% html_text2()
  cuerpo <- str_c(parrafos, collapse = " ")
  tibble(
    url = url,
    fecha = fecha,
    medio = "La Nación",
    titulo = titulo,
    cuerpo = cuerpo
  )
}


nuevas_noticias <- map2_dfr(urls, fechas, scrapear_ln)

noticias_inflacion_3_ <- bind_rows(noticias_inflacion_3_, nuevas_noticias)

view(noticias_inflacion_3_)
#MACRI2019 PAGINA12


urls <- c(
  "https://www.pagina12.com.ar/175096-la-inflacion-dio-otro-salto-en-enero",
  "https://www.pagina12.com.ar/180953-se-acelera",
  "https://www.pagina12.com.ar/187966-subas-de-precios-donde-y-cuando-mas-duelen",
  "https://www.pagina12.com.ar/194092-la-suba-de-precios-sigue-en-una-zona-muy-caliente",
  "https://www.pagina12.com.ar/200131-la-inflacion-mas-alta-en-casi-30-anos",
  "https://www.pagina12.com.ar/206746-la-inflacion-indomable-pese-a-la-recesion",
  "https://www.pagina12.com.ar/212540-la-desinflacion-quedara-como-un-mal-recuerdo",
  "https://www.pagina12.com.ar/218022-se-acelera-la-inflacion-pese-al-freno-del-consumo",
  "https://www.pagina12.com.ar/225253-la-inflacion-actual-duplica-a-la-de-2015",
  "https://www.pagina12.com.ar/231039-la-inflacion-de-octubre-fue-del-3-3",
  "https://www.pagina12.com.ar/236205-la-inflacion-de-noviembre-fue-del-4-3",
  "https://www.pagina12.com.ar/241774-indice-anual-de-precios-por-arriba-del-55-por-ciento"
)

fechas <- c(
  "2019-01", "2019-02", "2019-03", "2019-04",
  "2019-05", "2019-06", "2019-07", "2019-08",
  "2019-09", "2019-10", "2019-11", "2019-12"
)

scrapear_pagina12_2019 <- function(url, fecha) {
  pagina <- read_html(url)
  titulo <- pagina %>% html_nodes("h1, h2") %>% html_text(trim = TRUE) %>% first()
  parrafos <- pagina %>% html_nodes("div.article-text p, div.texto p, div.note_text p, div#cuerpo p") %>% html_text(trim = TRUE)
  cuerpo <- str_c(parrafos, collapse = " ")
  tibble(
    url = url,
    fecha = fecha,
    medio = "Pagina12",
    titulo = titulo,
    cuerpo = cuerpo
  )
}

nuevas_noticias_2019 <- map2_dfr(urls, fechas, scrapear_pagina12_2019)


for(i in 1:nrow(nuevas_noticias_2019)) {
  cat("Noticia", i, "(", nuevas_noticias_2019$fecha[i], "):\n")
  cat("TÍTULO: ", nuevas_noticias_2019$titulo[i], "\n")
  cat("CUERPO (preview): ", str_sub(nuevas_noticias_2019$cuerpo[i], 1, 300), "\n\n")
}

noticias_inflacion_3_ <- bind_rows(noticias_inflacion_3_, nuevas_noticias_2019)
noticias_inflacion_3_ <- noticias_inflacion_3_ %>% arrange(fecha)
view(noticias_inflacion_3_)


unique(noticias_inflacion_3_$medio)
noticias_inflacion_3_ <- noticias_inflacion_3_ %>%
  mutate(medio = if_else(str_detect(medio, "Nación"), "La Nación", "Pagina12"))
unique(noticias_inflacion_3_$medio)
library(readr)
write_csv(noticias_inflacion_3_, "noticias_inflacion_3.csv")
library(writexl)
write_xlsx(noticias_inflacion_3_, "noticias_inflacion_3.xlsx")
