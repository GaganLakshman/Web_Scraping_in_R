setwd("C:/Users/Gagan/Desktop/New folder (2)")

library(rvest)
library(curl)
library(stringr)
library(pdftools)

#generate website address from where pdf links have to be downloaded

url <- paste0("https://www.supremecourt.gov/oral_arguments/archived_transcripts/",1968:1999)
url1 <- paste0("https://www.supremecourt.gov/oral_arguments/argument_transcript/",2000:2009)
final_url <- c(url,url1)


#function to extract pdf links using xpath to navigate to the particular element


extract_pdf_links <- function(url){
  
  #if link has archived in it use the below xpath
  if(str_detect(url,"archived") == 'TRUE'){
    
    y <- read_html(url)
    ylinks <-  html_nodes(y,xpath = "//div[@class = 'panel-body']//table") %>% html_nodes("div a") %>% html_attr("href")
    ylinks <- sapply(ylinks,function(x){paste("https://www.supremecourt.gov",x,sep = "")})
    return(ylinks)
  }else
  {
    
    x <- read_html(url)  
    xlinks <-  html_nodes(x,xpath = "//div[@class = 'panel-body']//table//span//a") %>% html_attr("href")
    xlinks <- sapply(xlinks,function(x){paste("https://www.supremecourt.gov/oral_arguments",str_sub(x,3),sep = "")})
    return(xlinks)
  }
  
}

#apply the function on each link
res <- sapply(final_url,function(x) extract_pdf_links(x))
r <- unname(unlist(res))


#download the pdf from the extracted pdf's links
sapply(r[1:20],function(x){try({
  download.file(url = x,destfile = paste("Doc",which(r == x),".pdf",sep = "_"), mode = "wb", method = "curl")})})

#extract text from pdf's
file_list = list.files(path = "C:\\Users\\Gagan\\Desktop\\New folder (2)")
text_doc= sapply(file_list,pdf_text)





