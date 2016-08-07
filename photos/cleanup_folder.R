########
# Description: Given name of folder with JPGs, organises them according to their dates into folders Jan, Feb, Mar etc.
# Note: only for linux systems, this has only been tested on Ubuntu
# Author: samlam
# Created: 6 Aug 2016
########

test <- TRUE
folderloc <- "/media/sammi/SamanthaLam/Pictures/2016"

# requires system to have exiv2, i.e. in command line, please do: sudo apt-get install exiv2
getdates <- function(file.ext){
   paste("exiv2 *.", file.ext, " | grep timestamp | cut -d' ' -f13 | cut -d':' -f2", sep="")
}


setwd(folderloc)

if (test == TRUE) { 
  print(system(paste("pwd")))
}

jpg.data <- NULL

# ARW files not working yet - don't have camera properties, need to find RAW files equivalent to get date
for( file.exts in c('jpg', 'JPG', 'ARW') ){
  jpg.names <- suppressWarnings(system(paste("ls *.", file.exts, sep=""), intern = TRUE))
  if(length(jpg.names) > 0){
    jpg.months <- system(getdates(file.exts), intern = TRUE)
    jpg.temp.data <- cbind(jpg.names, jpg.months)
    jpg.data <- rbind(jpg.data, jpg.temp.data)
  }
}

jpg.data <- as.data.frame(jpg.data)

##### create required folders

folders <- month.abb[as.numeric(as.character(unique(jpg.data$jpg.months)))]

for(f in folders){
  system(paste("mkdir ", f, sep=""))
}

# check they are created
if (test == TRUE) { 
  print(system(paste("ls -lt | head -n12")))
}


##### put into folders
for(i in 1:length(jpg.months)){
  system(paste("mv ", as.character(jpg.data$jpg.names[i]), " ", month.abb[as.numeric(as.character(jpg.data$jpg.months[i]))], sep=""))
}



