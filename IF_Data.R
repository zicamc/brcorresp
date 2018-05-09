options("repos" = c(CRAN = "http://cran.r-project.org/"))
install.packages("readxl")
install.packages("sqldf")
install.packages("rvest")
install.packages("pdftools")
install.packages("data.table")
install.packages("tabulizer")
install.packages("rJava")
library(rJava) # load and attach 'rJava' now
install.packages("devtools")
devtools::install_github("ropensci/tabulizer", args="--no-multiarch")

library("readxl")
library(sqldf)
library("rvest")
library(tibble)
library(httr)
library(rvest)
library(lubridate)
library(stringr)
library(purrr)
library(dplyr)
library(data.table)
library(tabulizer)

activity_url <- "https://www.bcb.gov.br/fis/info/cad/correspondentes/201805CORRESPONDENTES.zip"
temp <- tempfile()
download.file(activity_url, temp)
unzip(temp, "201805CORRESPONDENTES.xlsx")
# note that here I modified your original read.table() which did not work
mydata <- read_excel("201805CORRESPONDENTES.xlsx")
unlink(temp)

newdata <-  sqldf('select * from mydata where X__14 == "X"
                   union
                   select * from mydata where X__12 == "X" ' )

names(newdata) <- c( "CNPJ da Contratante",	"Nome da Contratante",  "CNPJ do Correspondente",	"Nome do Correspondente",	"Tipo de Instalação",	"Nº de Ordem da Instalação",	
                     "Município da Instalação",	"UF",	"Inc. I",   	"Inc. II",  	"Inc. III", 	"Inc. IV",  	"Inc. V",   	"Inc. VI",  	"Inc. VIII" )








###### BUSCA DADOS - OLE CONSIGNADO #######

link <- 'https://institucional.oleconsignado.com.br/atendimento/nossas-lojas'
thepage = readLines(link)

abc <- paste( thepage, collapse=' ')
bpart <- "<div class=\"views-field views-field-title\">"

abc1 <- substring( abc, regexpr( bpart, abc) + 45)

ole <- c()

while( regexpr("<footer", abc1) > 100 ){

  latlon <- substring( abc1, 0, regexpr(bpart, abc1) )
  append(c(latlon),c(ole))
  abc1 <-  substring( abc, regexpr( bpart, abc) + 45)

} 



#########################################################


download.file("http://www.ccbfinanceira.com.br/correspondentes/ccb-financeira-correspondentes-credito-consignado.pdf", "ccb.pdf", mode = "wb")


srcbase <- "http://www.ccbfinanceira.com.br/correspondentes/ccb-financeira-correspondentes-credito-consignado.pdf"


library(pdftools)
dat <- pdftools::pdf_text(srcbase)
dat <- paste0(dat, collapse = " ")
dat
pattern <- "\r\n"

dat2 <- strsplit (dat, pattern)
dat2
lst <- extract_tables( srcbase , encoding="UTF-8") 
# peep into the doc for further specs (page, location etc.)!


txt14_16 <- pdf_text("ccb.pdf")
txt14_16 <- paste( txt14_16 ,  collapse = ' ')

head(txt14_16)

###### BANCO PAN ########

https://www.bancopan.com.br//atendimento/rede-de-vendas/shops.json
https://www.bancopan.com.br/atendimento/rede-de-vendas/partners.json
