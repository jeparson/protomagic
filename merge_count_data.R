# Merges count data from a list of inputs into a N-sample data table
#` Usage: merge_count_data.R [Selected column of input file<numeric>] [comma-separated vector of sample names<string>] [samples <Files>]

arglist <- commandArgs(TRUE)

require(data.table) # hope this is installed

dlist <- lapply(x=arglist[4:length(arglist)],FUN = fread,select=as.integer(as.character(arglist[1]))) # make a scary huge list

multmerge = function(x){
  datalist = lapply(x[4:length(x)], FUN= function(x,select){data.table::fread(x,select=select)},select=as.integer(as.character(x[1])))
  Reduce(function(x,y) {cbind(x,y)}, datalist)
  }

merdf <- multmerge(dlist)
# Merged count list [assuming that outputs don't omit 0s, which i think is correct]
colnames(merdf) <- unlist(strsplit(arglist[2],split=","))
# Set the names
# Add in the isoform names
inames<-fread(arglist[4],select=1)
merdf<-cbind(inames,merdf)
write.csv(merdf,file = arglist[3])
