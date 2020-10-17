
rm(list=ls())
library(data.table)
library(fst)
library(stringr)


asofdates <- 2018:2019
# https://ffiec.cfpb.gov/data-publication/dynamic-national-loan-level-dataset/2018
hmda_files <- c("2018_lar.txt","2019_lar.txt")
path = "C:/Users/dratnadiwakara2/Downloads/"


for(j in 1:length(asofdates)) {
  print(asofdates[j])
  
  hmda_file_name = paste(path,hmda_files[j],sep="")
  
  hmda <- fread(hmda_file_name,header = TRUE,stringsAsFactors = FALSE,sep="|",data.table = TRUE)
  
  setnames(hmda, "activity_year", "asofdate")
  setnames(hmda, "derived_msa_md", "msa")
  setnames(hmda, "state_code", "state")
  setnames(hmda, "county_code", "countycode")
  setnames(hmda, "census_tract", "censustract")
  setnames(hmda,"derived_dwelling_category","propertytype")
  setnames(hmda,"applicant_ethnicity_1","applicantethnicity")
  setnames(hmda,"applicant_race_1","applicantrace1")
  setnames(hmda,"applicant_sex","applicantsex")
  setnames(hmda,"action_taken","actiontaken")
  setnames(hmda,"purchaser_type","typeofpurchaser")
  setnames(hmda,"preapproval","preapprovals")
  setnames(hmda,"loan_type","typeofloan")  
  setnames(hmda,"loan_purpose","purposeofloan")
  setnames(hmda,"lien_status","lienstatus")
  setnames(hmda,"loan_amount","amountofloan")
  setnames(hmda,"rate_spread","ratespread")
  setnames(hmda,"hoepa_status","hoepastatus")
  setnames(hmda,"occupancy_type","occupancy")
  setnames(hmda,"income","applicantincome")
  setnames(hmda,"denial_reason_1","denialreason1")
  setnames(hmda,"denial_reason_2","denialreason2")
  setnames(hmda,"denial_reason_3","denialreason3")
  setnames(hmda,"lei","respondentid")
  
  hmda[,state:=substr(countycode,1,2)]
  hmda[,countycode:=substr(countycode,3,5)]
  hmda[,agencycode:=""]
  hmda[,amountofloan:=amountofloan/1000]
  
  hmda[,propertytype:= ifelse(propertytype  %in% c("Single Family (1-4 Units):Site-Built"),"1",
                                    ifelse(propertytype %in% c("Single Family (1-4 Units):Manufactured","Multifamily:Manufactured"),"2","3"))]
  
  hmda <- hmda[hmda$propertytype=="1"]
  
  write_fst(hmda[hmda$occupancy=="1" &hmda$purposeofloan==1],paste(path,"OO_NP_",asofdates[j],".fst",sep=""),compress = 100)
  write_fst(hmda[hmda$occupancy=="2" &hmda$purposeofloan==1],paste(path,"NO_NP_",asofdates[j],".fst",sep=""),compress = 100)
  write_fst(hmda[hmda$occupancy=="1" &hmda$purposeofloan>30],paste(path,"OO_RF_",asofdates[j],".fst",sep=""),compress = 100)
  write_fst(hmda[hmda$occupancy=="2" &hmda$purposeofloan>30],paste(path,"NO_RF_",asofdates[j],".fst",sep=""),compress = 100)
  
                                           
}




asofdates <- 2017
# https://www.consumerfinance.gov/data-research/hmda/historic-data/?geo=nationwide&records=all-records&field_descriptions=codes
hmda_files <- c("hmda_2017_nationwide_all-records_codes.csv")
path = "C:/Users/dratnadiwakara2/Downloads/"


for(j in 1:length(asofdates)) {
  print(asofdates[j])
  
  hmda_file_name = paste(path,hmda_files[j],sep="")
  
  hmda <- fread(hmda_file_name,header = T,stringsAsFactors = FALSE,sep=",",data.table = TRUE,colClasses = list(character=1:45))

  
  setnames(hmda, "as_of_year", "asofdate")
  setnames(hmda, "respondent_id", "respondentid")
  setnames(hmda, "agency_code", "agencycode")
  setnames(hmda, "loan_type", "typeofloan")
  setnames(hmda, "property_type", "propertytype")
  setnames(hmda,"loan_purpose","purposeofloan")
  setnames(hmda,"loan_amount_000s","amountofloan")
  setnames(hmda,"preapproval","preapprovals")
  setnames(hmda,"msamd","msa")
  setnames(hmda,"state_code","state")
  setnames(hmda,"county_code","countycode")
  setnames(hmda,"census_tract_number","censustract")
  setnames(hmda,"applicant_ethnicity","applicantethnicity")  
  setnames(hmda,"co_applicant_ethnicity","coapplicantenthnicity")
  setnames(hmda,"applicant_race_1","applicantrace1")
  setnames(hmda,"co_applicant_race_1","coapplicantrace1")
  setnames(hmda,"applicant_sex","applicantsex")
  setnames(hmda,"co_applicant_sex","coapplicantsex")
  setnames(hmda,"applicant_income_000s","applicantincome")
  setnames(hmda,"purchaser_type","typeofpurchaser")
  setnames(hmda,"denial_reason_1","denialreason1")
  setnames(hmda,"rate_spread","ratespread")
  setnames(hmda,"hoepa_status","hoepastatus")
  setnames(hmda,"edit_status","editstatus")
  setnames(hmda,"owner_occupancy","occupancy")
  setnames(hmda,"action_taken","actiontaken")
  
  hmda[,asofdate:=as.integer(asofdate)]
  hmda[,censustract:=str_replace(censustract,"[.]","")]
  
  hmda[,censustract:=paste0(state,countycode,censustract)]
  hmda <- hmda[hmda$propertytype=="1"]
  
  
  write_fst(hmda[hmda$occupancy=="1" &hmda$purposeofloan=="1"],paste(path,"OO_NP_",asofdates[j],".fst",sep=""),compress = 100)
  write_fst(hmda[hmda$occupancy=="2" &hmda$purposeofloan=="1"],paste(path,"NO_NP_",asofdates[j],".fst",sep=""),compress = 100)
  write_fst(hmda[hmda$occupancy=="1" &hmda$purposeofloan=="3"],paste(path,"OO_RF_",asofdates[j],".fst",sep=""),compress = 100)
  write_fst(hmda[hmda$occupancy=="2" &hmda$purposeofloan=="3"],paste(path,"NO_RF_",asofdates[j],".fst",sep=""),compress = 100)
  
  
}


test <- read_fst(choose.files(),as.data.table = T)

asofdates <- 1981:1989
hmda_header <- c("str","asofdate","respondentid","agencycode","typeofloan","purposeofloan",
                 "occupancy","amountofloan","actiontaken","msa","state","countycode",
                 "censustract","applicantsex","coapplicantsex","applicantincome",
                 "typeofpurchaser","denialreason1","denialreason2","denialreason3",
                 "editstatus","propertytype","preapprovals","applicantethnicity",
                 "coapplicantenthnicity","applicantrace1","applicantrace2","applicantrace3",
                 "applicantrace4","applicantrace5",
                 "coapplicantrace1","coapplicantrace2","coapplicantrace3","coapplicantrace4",
                 "coapplicantrace5",
                 "ratespread","hoepastatus","lienstatus","seqno")
split.points_hmda <- c(4,14,15,16,17,18,23,24,29,31,34,41,42,43,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,71,72,73,80)

hmda_files <- c("HMD_FACDSB81.txt","HMD_FACDSB82.txt","HMD.FACDSB83.PRO","HMD.FACDSB84.PRO","HMD.FACDSB85.PRO",
                "HMD.FACDSB86.PRO","HMD.FACDSB87.PRO","HMD.FACDSB88.PRO","HMD.FACDSB89.PRO")

path = "C:/Users/dratnadiwakara2/Downloads/HMDA/"

for(j in 1:length(asofdates)) {
  print(asofdates[j])
  
  hmda_file_name = paste(path,hmda_files[j],sep="")
  
  hmda <- fread(hmda_file_name,header = FALSE,stringsAsFactors = FALSE,sep="\t",data.table = FALSE)
  hmda <- as.vector(hmda$V1)
  
  hmda_vector <- as.data.frame(matrix(ncol = 39,nrow=length(hmda)))
  
  hmda_vector[,1]<- hmda
  
  prev = 0
  i=2
  for(point in split.points_hmda) {
    print (paste(prev+1,point))
    hmda_vector[,i] <- sapply(hmda_vector$V1,function(x) substr(x,prev+1,point))
    i=i+1
    prev=point
  }
  
  names(hmda_vector) <- hmda_header
  
  hmda_vector <- data.table(hmda_vector)
  hmda_vector <- hmda_vector[hmda_vector$editstatus==" " & hmda_vector$propertytype=="1"]
  hmda_vector[,c("str","denialreason2","denialreason3","editstatus","applicantrace3","applicantrace4","applicantrace5","coapplicantrace3","coapplicantrace4","coapplicantrace5"):=list(NULL)]
  
  
  saveRDS(hmda_vector[hmda_vector$occupancy=="1" &hmda_vector$purposeofloan=="1"],file=paste(path,"OO_NP_",asofdates[j],".rds",sep=""))
  saveRDS(hmda_vector[hmda_vector$occupancy=="2" &hmda_vector$purposeofloan=="1"],file=paste(path,"NO_NP_",asofdates[j],".rds",sep=""))
  saveRDS(hmda_vector[hmda_vector$occupancy=="1" &hmda_vector$purposeofloan=="3"],file=paste(path,"OO_RF_",asofdates[j],".rds",sep=""))
  saveRDS(hmda_vector[hmda_vector$occupancy=="2" &hmda_vector$purposeofloan=="3"],file=paste(path,"NO_RF_",asofdates[j],".rds",sep=""))
  rm(hmda_vector)
  gc()
}



asofdates <- 2013:2004
hmda_header <- c("str","asofdate","respondentid","agencycode","typeofloan","purposeofloan",
                 "occupancy","amountofloan","actiontaken","msa","state","countycode",
                 "censustract","applicantsex","coapplicantsex","applicantincome",
                 "typeofpurchaser","denialreason1","denialreason2","denialreason3",
                 "editstatus","propertytype","preapprovals","applicantethnicity",
                 "coapplicantenthnicity","applicantrace1","applicantrace2","applicantrace3",
                 "applicantrace4","applicantrace5",
                 "coapplicantrace1","coapplicantrace2","coapplicantrace3","coapplicantrace4",
                 "coapplicantrace5",
                 "ratespread","hoepastatus","lienstatus","seqno")
split.points_hmda <- c(4,14,15,16,17,18,23,24,29,31,34,41,42,43,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,71,72,73,80)

hmda_files <- c("Lars.ultimate.2013.dat","Lars.ultimate.2012.dat","Lars.ultimate.2011.dat","Lars.ultimate.2010.dat","2009_Ultimate_PUBLIC_LAR.dat","lars.ultimate.2008.dat","lars.ultimate.2007.dat","LARS.ULTIMATE.2006.DAT","LARS.ULTIMATE.2005.DAT","u2004lar.public.dat")
 

path = "C:/Users/dnratnadiwakara/Documents/interest rate and default/Data/Raw/HMDA/text files/"

for(j in 1:length(asofdates)) {
  print(asofdates[j])
  
  hmda_file_name = paste(path,hmda_files[j],sep="")
  
  hmda <- fread(hmda_file_name,header = FALSE,stringsAsFactors = FALSE,sep="\t",data.table = FALSE)
  hmda <- as.vector(hmda$V1)
  
  hmda_vector <- as.data.frame(matrix(ncol = 39,nrow=length(hmda)))
  
  hmda_vector[,1]<- hmda
  
  prev = 0
  i=2
  for(point in split.points_hmda) {
    print (paste(prev+1,point))
    hmda_vector[,i] <- sapply(hmda_vector$V1,function(x) substr(x,prev+1,point))
    i=i+1
    prev=point
  }
  
  names(hmda_vector) <- hmda_header
  
  hmda_vector <- data.table(hmda_vector)
  hmda_vector <- hmda_vector[hmda_vector$editstatus==" " & hmda_vector$propertytype=="1"]
  hmda_vector[,c("str","denialreason2","denialreason3","editstatus","applicantrace3","applicantrace4","applicantrace5","coapplicantrace3","coapplicantrace4","coapplicantrace5"):=list(NULL)]
  
  
  saveRDS(hmda_vector[hmda_vector$occupancy=="1" &hmda_vector$purposeofloan=="1"],file=paste(path,"OO_NP_",asofdates[j],".rds",sep=""))
  saveRDS(hmda_vector[hmda_vector$occupancy=="2" &hmda_vector$purposeofloan=="1"],file=paste(path,"NO_NP_",asofdates[j],".rds",sep=""))
  saveRDS(hmda_vector[hmda_vector$occupancy=="1" &hmda_vector$purposeofloan=="3"],file=paste(path,"OO_RF_",asofdates[j],".rds",sep=""))
  saveRDS(hmda_vector[hmda_vector$occupancy=="2" &hmda_vector$purposeofloan=="3"],file=paste(path,"NO_RF_",asofdates[j],".rds",sep=""))
  rm(hmda_vector)
  gc()
}









hmda_header <- c("asofdate","respondentid","agencycode","typeofloan","propertytype","purposeofloan","occupancy","amountofloan","preapprovals","actiontaken","msa","state","countycode",
                 "censustract","applicantethnicity","coapplicantenthnicity","applicantrace1","applicantrace2","applicantrace3",
                 "applicantrace4","applicantrace5","coapplicantrace1","coapplicantrace2","coapplicantrace3","coapplicantrace4","coapplicantrace5","applicantsex","coapplicantsex"
                 ,"applicantincome","typeofpurchaser","denialreason1","denialreason2","denialreason3","ratespread", "hoepastatus","lienstatus","editstatus","seqno")

hmda_files <- c("2016HMDALAR - National.csv","2015HMDALAR - National.csv","2014HMDALAR - National.csv")

asofdates <- 2016:2014
path = "C:/Users/dnratnadiwakara/Documents/interest rate and default/Data/Raw/HMDA/text files/"


for(j in 1:length(asofdates)) {
  print(asofdates[j])
  
  hmda_file_name = paste(path,hmda_files[j],sep="")
  
  hmda <- fread(hmda_file_name,header = FALSE,stringsAsFactors = FALSE,sep=",",data.table = TRUE,colClasses = list(character=1:45))
  names(hmda) <- c(hmda_header,"V1","V2","V3","V4","V5","V6","V7")
  hmda <- hmda[,..hmda_header]
  
  hmda <- hmda[hmda$editstatus=="" & hmda$propertytype=="1"]
  
  hmda[,c("denialreason2","denialreason3","editstatus","applicantrace3","applicantrace4","applicantrace5","coapplicantrace3","coapplicantrace4","coapplicantrace5"):=list(NULL)]
  
  hmda[,asofdate:=as.integer(hmda$asofdate)]
  hmda[,censustract:=trimws(censustract)]
  hmda[,censustract:= paste(hmda$state,hmda$countycode,hmda$censustract,sep="")]
  hmda[,censustract:=gsub("[.]","",hmda$censustract)]
  hmda[,applicantincome:=as.numeric(hmda$applicantincome)]
  hmda[,amountofloan := as.numeric(hmda$amountofloan)]
  
  # write_fst(temp,paste(substr(file,1,nchar(file)-3),"fst",sep=""),compress = 100)
  
  write_fst(hmda[hmda$occupancy=="1" &hmda$purposeofloan=="1"],paste(path,"OO_NP_",asofdates[j],".fst",sep=""),compress = 100)
  write_fst(hmda[hmda$occupancy=="2" &hmda$purposeofloan=="1"],paste(path,"NO_NP_",asofdates[j],".fst",sep=""),compress = 100)
  write_fst(hmda[hmda$occupancy=="1" &hmda$purposeofloan=="3"],paste(path,"OO_RF_",asofdates[j],".fst",sep=""),compress = 100)
  write_fst(hmda[hmda$occupancy=="2" &hmda$purposeofloan=="3"],paste(path,"NO_RF_",asofdates[j],".fst",sep=""),compress = 100)
  rm(hmda)
  gc()
}




files <- list.files(path = paste('C:/Users/dratnadiwakara2/Documents/OneDrive - Louisiana State University/Raw Data/HMDA/pre2004/NO_NP',sep=""), pattern = '.rds',full.names = TRUE)
for(file in files) {
  print(file)
  temp <- readRDS(file)
  temp[,amountofloan:=as.numeric(temp$amountofloan)]
  temp[,amountofloan:=as.numeric(temp$amountofloan)]
  
  temp[,asofdate:=as.integer(temp$asofdate)]
  temp[,censustract:=trimws(temp$censustract)]
  temp[,censustract:= paste(temp$state,temp$countycode,temp$censustract,sep="")]
  temp[,censustract:=gsub("[.]","",temp$censustract)]
  temp[,applicantincome:=as.numeric(temp$applicantincome)]
  temp[,amountofloan := as.numeric(temp$amountofloan)]
  
  write.fst(temp,paste0(substr(file,1,nchar(file)-3),"fst"),compress = 100)
}

