'usage: runDashboard.R [--filenameRoot<file> isNorm<boolean> sample1Name<string> sample2Name<string> erccdilution<numeric> spikeVol<numeric> totalRNAmass<numeric> choseFDR<numeric> source_file<file path> erccmix<string>'

args<-commandArgs(TRUE)
cranpackagelist<-c("devtools","data.table")
pkgneeded<-cranpackagelist[!cranpackagelist%in%installed.packages()]
if(length(pkgneeded)){install.packages(pkgneeded)}
require(data.table)
require(devtools)
devtools::install_github(repo = "usnistgov/erccdashboard@isoform")
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
ttable<-as.data.frame(data.table::fread(parameters$source_file))
dbout<-runDashboard(datType = "count",isNorm = parameters$isNorm,exTable = ttable,filenameRoot = parameters$filenameRoot,sample1Name = parameters$sample1Name,sample2Name = parameters$sample2Name,
                    erccmix = parameters$erccmix,erccdilution = parameters$erccdilution,totalRNAmass = parameters$totalRNAmass,spikeVol = parameters$spikeVol,choseFDR = parameters$choseFDR)
#dbout<-(do.call(runDashboard,list(exTable="ttable",parameters[names(parameters)!="source_file"],datType="Count")))) #for whatever reason i couldn't get do.call to do what i wanted.
# TODO:  Get rplots.pdf to not output.
save(dbout,file=paste0(args[1],".rData"))
