updatemetadata<-function(x,p,fastqmetadata=fastqmetadata){
  metadata<-fastqmetadata[fastqmetadata[,1]==x,2:length(fastqmetadata)]
  findfile(name=x,p,exact = TRUE)$setMeta(as.list(metadata)) # actually works now that the formatting in metadatatable is correct
} # Sets the metadata of a file on sbc to that presented in the metadatatable file.

# Define findfile function:   Searches sbc project for a file
# Avoids awkwardness around the default search only searching top100 files
findfile<-function(name,p,...){
  offset<-0
  while(length(p$file(offset=offset))==100){
    offset<-offset+100
  }# Count the total number of files
  maxoffset<-offset
  offset<-0
  while(offset <= maxoffset){
    if(!is.null(p$file(name=name,offset=offset))){return(p$file(name=name,offset=offset))}
    offset<-offset+100}
  return(NULL)
} # findfile

statuscheck<-function(x,p){
  tsk=p$task(id=x)
  switch(tsk$status,
         "RUNNING" = {tsk$monitor(time=120);return(paste0(tsk$name,"Waited until COMPLETED"))},
         "COMPLETED" = return(paste0(tsk$name,"COMPLETED")),
         "DRAFT" = {warning("Task in list is in draft status: not run");return(paste0(tsk$name,"ERROR"))})
  return(paste0(tsk$name,"UNKNOWN_STATUS"))}
# TODO test to see if this is a good way to handle running tasks.  Seems okay with stalled tasks.

copymetadata<-function(tskid,p){
  filelist<-p$task(id=tsklist[I])$file() # only the output files
  source<-p$task(id=tsklist[I])$inputs$input_archive_file$name # the relevant input file
  fastqmetadata <- read.table(file="metadatatable.txt",sep=",",stringsAsFactors = FALSE,header = TRUE,colClasses = c(rep("character",10)))
  lapply(filelist,updatemetadata,p,fastqmetadata)

}
