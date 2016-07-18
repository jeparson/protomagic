'usage: runDashboard.R [--filenameRoot< --isNorm<boolean>'

args<-commandArgs(TRUE)
require(data.table)
processargs<-function(args){
# convert the unnamed --commandline arguments to a named list that can be passed to do.call
  outlist<-NULL
  stringargs<-c("--filenameRoot","--isNorm","--sample1Name","--sample2Name","--exTable","--erccmix")
  numericargs<-c("--erccdilution","--spikeVol","--totalRNAmass","--choseFDR")
  vals<-FALSE
  theargs<-c("filenameRoot","isNorm","sample1Name","sample2Name","erccdilution","spikeVol","totalRNAmass","choseFDR","source_file","erccmix")
# This assumes that the arguments go in the order defined in definedashboard.R
# Any changes to the arguments or order must be doubled in both definedashboard.R and runDashboard.R
  outlist<-as.list(setNames(args,as.list(theargs)))
  outlist[names(outlist)%in%gsub(x=numericargs,pattern="--",replacement="")]<-as.numeric(outlist[names(outlist)%in%gsub(x=numericargs,pattern="--",replacement="")]) #make things numeric
  return(outlist)
}
parameters<-processargs(args)
library(erccdashboard)#rundashboard doesn't work outside of its environment :(
dbout<-(do.call(erccdashboard::runDashboard,c(list(exTable=as.data.frame(data.table::fread(parameters$source_file))),parameters[names(parameters)!="source_file"],datType="Count")))
# TODO:  Test this with a good count table.
save(dbout,file=paste0(args[1],".rData"))
