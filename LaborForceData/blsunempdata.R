# this script cleans Labor force data from https://www.bls.gov/lau/#cntyaa

rm(list=ls())
library(data.table)
library(httr)
library(readxl)

filenames <- paste0("https://www.bls.gov/lau/laucnty",substr(1990:2019,3,4),".xlsx")

bls <- NULL
for(f in filenames) {
  GET(f, write_disk(tf <- tempfile(fileext = ".xlsx")))
  temp <- data.frame(read_excel(tf,skip = 6,col_names = FALSE))
  names(temp) <- c("lauscode","state","county","countyname","year","empty","laborforce","noemployed","nounemployed","unemprate")
  temp$empty <- NULL
  
  bls <- rbind(bls,temp)
}
bls <- data.table(bls)
bls <- bls[!is.na(laborforce)]

write.csv(bls,"")
