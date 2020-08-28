
# data from:https://data.nber.org/data/soi-tax-stats-individual-income-tax-statistics-zip-code-data-soi.html

files <- list.files(path="C:/Users/dratnadiwakara2/Downloads/irs",pattern = "*.csv",full.names = T)

for(f in files) {
  t <- fread(f,select = c("zipcode","n1","a00100"))
  t <- t[zipcode>99]
  t[,zipcode:=as.character(zipcode)]
  t[,zipcode:=str_pad(zipcode,width = 5,side="left",pad="0")]
  t <- t[,.(agi=sum(a00100,na.rm=T)*1000/sum(n1,na.rm=T)),by=zipcode]
  t[,year:=as.numeric(substr(f,nchar(f)-7,nchar(f)-4))]
  write_fst(t,paste0(f,".fst"),compress = 100)
}