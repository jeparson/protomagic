args=commandArgs()
print(args)

##for debugging purposes:
args<-c("/Library/Frameworks/R.framework/Resources/bin/exec/R","--slave","--no-restore","--file=runDashboard.R","--args","--filenameRoot",
        "NIST_HiSeq_Mixes_Test.csv","--isNorm","false","--sample1Name","MixM","--sample2Name","MixL","--erccdilution","1",
        "--spikeVol","50","--totalRNAmass","2500","--choseFDR","0.05","--exTable","NIST_HiSeq_Mixes_Test.csv","--erccmix","RatioPair")

processargs<-function(args){
  #converts the unnamed --commandline arguments to a named list that can be passed to do.call
  outlist<-NULL
  go=0;a="datType";b="count"
  stringargs=c("--filenameRoot","--isNorm","--sample1Name","--sample2Name","--exTable","--erccmix")
  numericargs=c("--erccdilution","--spikeVol","--totalMass","--choseFDR")
    for (item in args){
  if(item%in%c(stringargs,numericargs)){
    go=2
    a=c(a,item)
    next
  }
  else{go=go-1}
    if(go==1){
      b=c(b,item)
    }
  }
  a<-gsub(pattern = "--",replacement="",x=a)
  outlist<-setNames(as.list(b),a)
  outlist[names(outlist)%in%gsub(x=numericargs,pattern="--",replacement="")]<-as.numeric(outlist[names(outlist)%in%gsub(x=numericargs,pattern="--",replacement="")]) #make things numeric
  return(outlist)
}
parameters=processargs(args)
print(parameters)
library(erccdashboard)#rundashboard doesn't work outside of its environment :(
dbout<-(do.call(erccdashboard::runDashboard,c(list(exTable=read.csv(parameters$exTable)),parameters[names(parameters)!="exTable"])))
#save(dbout,file=paste0(args[1],".rData"))
