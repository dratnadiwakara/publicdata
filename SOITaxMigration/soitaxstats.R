# this script cleans SOI Tax Stats - Migration Data from https://www.irs.gov/statistics/soi-tax-stats-migration-data
# file format different after year 2011

rm(list=ls())
library(data.table)
library(fst)
library(readxl)
library(stringr)



# 1996 to 2011 ------------------------------------------------------------

files_txt <- list.files(path = "C:/Users/dratnadiwakara2/Downloads/IRS Migration/out", pattern = '.xls',full.names = TRUE)
path_char <- nchar("C:/Users/dratnadiwakara2/Downloads/IRS Migration/out/")+1
pb   <- txtProgressBar(1, length(files_txt), style=3)
i= 1
for(file in files_txt) {
  setTxtProgressBar(pb, i)
  i=i+1
  tryCatch(
    {
      temp <- data.frame(read_excel(file,skip = 8,col_names = FALSE))
      names(temp) <- c("fromstate","fromcounty","tostate","tocounty","statecode","desc","noreturns","noexceptions","agi")
      temp['file'] <- substr(file,path_char,nchar(file)-4)
      write_fst(temp,paste0(substr(file,1,nchar(file)-3),"fst"),compress = 100)
    },error=function(cond) {})
}

files_txt <- list.files(path = "C:/Users/dratnadiwakara2/Downloads/IRS Migration/out", pattern = '.fst',full.names = TRUE)
temp = lapply(files_txt, function (x) read_fst(x,as.data.table = TRUE))
temp = rbindlist(temp, fill = TRUE)
temp <- temp[substr(temp$file,1,2)=="co"]
temp[,fromyear:=substr(temp$file,3,5)]
temp[,fromyear:=ifelse(temp$fromyear=="001","000",ifelse(temp$fromyear=="102","010",ifelse(temp$fromyear=="203","020",temp$fromyear)))]
temp[,fromyear:=as.numeric(substr(temp$fromyear,1,2))]
temp[,fromyear:=ifelse(temp$fromyear<50,2000+temp$fromyear,1900+temp$fromyear)]
temp <- temp[temp$fromyear>1996]

temp1 <- temp
temp1[,noreturns:=as.numeric(temp1$noreturns)]
temp1[,noexceptions:=as.numeric(temp1$noexceptions)]
temp1[,agi:=as.numeric(temp1$agi)]

temp1[,c("NA","NA.1","NA.2"):=list(NULL)]



# 2012 to 2016 ------------------------------------------------------------

files_txt <- list.files(path = "C:/Users/dratnadiwakara2/Downloads/IRS Migration/out_post2012", pattern = '.csv',full.names = TRUE)
path_char <- nchar("C:/Users/dratnadiwakara2/Downloads/IRS Migration/out_post2012/")+1
pb   <- txtProgressBar(1, length(files_txt), style=3)
i= 1
for(file in files_txt) {
  setTxtProgressBar(pb, i)
  i=i+1
  tryCatch(
    {
      temp <- fread(file,stringsAsFactors = FALSE)
      names(temp) <- c("fromstate","fromcounty","tostate","tocounty","statecode","desc","noreturns","noexceptions","agi")
      temp[,file:= substr(file,path_char,nchar(file)-4)]
      write_fst(temp,paste0(substr(file,1,nchar(file)-3),"fst"),compress = 100)
    },error=function(cond) {})
}

files_txt <- list.files(path = "C:/Users/dratnadiwakara2/Downloads/IRS Migration/out_post2012", pattern = '.fst',full.names = TRUE)
temp = lapply(files_txt, function (x) read_fst(x,as.data.table = TRUE))
temp = rbindlist(temp, fill = TRUE)

# uncomment the following for out files
temp[,fromyear:=as.numeric(paste0("20",substr(temp$file,14,15)))]
# temp[,fromyear:=as.numeric(paste0("20",substr(temp$file,13,14)))]

temp[,fromstate:=as.character(temp$fromstate)]
temp[,fromstate:=ifelse(nchar(temp$fromstate)==1,paste0("0",temp$fromstate),temp$fromstate)]
temp[,fromcounty:=as.character(temp$fromcounty)]
temp[,fromcounty:=ifelse(nchar(temp$fromcounty)==1,paste0("00",temp$fromcounty),ifelse(nchar(temp$fromcounty)==2,paste0("0",temp$fromcounty),temp$fromcounty))]
temp[,tostate:=as.character(temp$tostate)]
temp[,tostate:=ifelse(nchar(temp$tostate)==1,paste0("0",temp$tostate),temp$tostate)]
temp[,tocounty:=as.character(temp$tocounty)]
temp[,tocounty:=ifelse(nchar(temp$tocounty)==1,paste0("00",temp$tocounty),ifelse(nchar(temp$tocounty)==2,paste0("0",temp$tocounty),temp$tocounty))]


temp2 <- rbind(temp,temp1)

temp2[,fromstate:=str_pad(fromstate,2,side="left",pad="0")]
temp2[,fromcounty:=str_pad(fromcounty,3,side="left",pad="0")]
temp2[,tostate:=str_pad(tostate,2,side="left",pad="0")]
temp2[,tocounty:=str_pad(tocounty,3,side="left",pad="0")]

write_fst(temp2,"C:/Users/dratnadiwakara2/Documents/OneDrive - Louisiana State University/Raw Data/IRS Migration Data/out_migration_1997_2017.fst",compress = 100)







