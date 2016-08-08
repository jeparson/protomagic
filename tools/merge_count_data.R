# Merges count data from a list of inputs into a N-sample data table
#` Usage: merge_count_data.R [Selected column of input file<numeric>] [comma-separated vector of sample names<string>] [output filename] [samples <Files>]

arglist <- commandArgs(TRUE)
if(!require("data.table")){install.packages("data.table");require("data.table")}
dlist <- lapply(X=arglist[4:length(arglist)],FUN = fread,select=as.integer(as.character(arglist[1]))) # make a scary huge list
dlist <- Reduce(cbind,dlist)
# Merged count list [assuming that outputs don't omit 0s, which i think is correct]
colnames(dlist) <- unlist(strsplit(arglist[2],split=","))
# Set the names
# Add in the isoform names
inames<-fread(arglist[4],select=1)
dlist<-cbind(inames,dlist)
write.csv(dlist,file = paste0(arglist[3],".csv"),quote = FALSE,row.names = FALSE)
