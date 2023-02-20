libraries = c( "XML","robotstxt", "tidyft","data.table", "DBI", "httr", "RSQLite","tidyverse","rvest","stringr","robotstxt","selectr","xml2","dplyr","forcats","magrittr","tidyr","ggplot2","lubridate","tibble","purrr","googleLanguageR","cld2")
lapply(libraries, require, character.only = TRUE)
counter=0


#-- Step1: Downloading all the CTRI Webpages in HTML.
ids = c(1:90000)
counter = 0
for (i in seq_along(ids)) {
  myurl = paste0("http://ctri.nic.in/Clinicaltrials/pmaindet2.php?trialid=", ids[i]) 
  url = url(paste0("http://ctri.nic.in/Clinicaltrials/pmaindet2.php?trialid=",ids[i]))
  ctri_page = read_html(url)
  keyword = ctri_page %>% html_nodes("td") %>% html_text() %>% str_extract("Invalid Request")
  keyword = toString(keyword)
  ##This is done because there are many records which have their particular links, but no content is present in those records. Instead it is displayed as "Invalid Request".
  if (keyword != "Invalid Request") { 
  myfile = paste0("ctri_page",ids[i],".html")
  download.file(myurl, destfile = myfile, quiet = TRUE)
  time_of_download = as.character(timestamp())
  
  time_stamp = data.frame(Trial_ID = as.character(ids[i]),
                          downloaded_time = time_of_download,
                          URL = as.character(myurl))
  
  write.table(time_stamp, "time_stamp.csv", sep = ",",row.names = FALSE, col.names = !file.exists("time_stamp.csv"), append = T)
  
  counter = counter + 1
  print(paste("Count = ", counter,"ID = ",ids[i]))
  }
  else {
    print(paste("Count=",counter,"ID = ",ids[i],"but page is invalid one"))
  }
}


#total no. of records in ctri: 47955 (expected number of records)
#url <- url("http://ctri.nic.in/Clinicaltrials/pmaindet2.php?trialid=78000") #invalid request-one (invalid records look likes this)
#url <- url("http://ctri.nic.in/Clinicaltrials/pmaindet2.php?trialid=2")#proper trial record


































