#TODO : Should this script also load the metadata from the local host since it's frequently used?
#TODO : Should this script set the project and authorization since they're used everywhere?
#TODO : Add Site to metadata in an appropriate location[SampleID/Investigation/Batch_number]

updatemetadata<-function(x,p,fastqmetadata=fastqmetadata){
  metadata<-fastqmetadata[fastqmetadata[,1]==x,2:length(fastqmetadata)]
  findfile(name=x,p,exact = TRUE)$setMeta(as.list(metadata)) # actually works now that the formatting in metadatatable is correct
} # Sets the metadata of a file on sbc to that presented in the metadatatable file [based on filename, only for fastqs].


gupdatemetadata<-function(src,dest,p,fastqmetadata=fastqmetadata){
# Inputs:  Src and Dest are file objects, p is a project object, and fastqmetadata is a table.
# Src must be contained within the fastqmetadata table, meaning, it'd better be a fastq file.
  metadata<-fastqmetadata[fastqmetadata[,1]==src$name,2:length(fastqmetadata)]
  if(length(metadata[,1])){
  dest$setMeta(as.list(metadata))} # Let's only set it if it's a real thing...
} # Sets the metadata of a file on sbc to that presented in the metadatatable file [based on filename, only for fastqs].


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
    if(!is.null(p$file(name=name,offset=offset,...))){return(p$file(name=name,offset=offset,...))}
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
  filelist<-p$task(id=tskid)$file() # only the output files
  source<-findfile(p$task(id=tskid)$inputs$input_archive_file$name,p) # the relevant input file if we're dealing with alignments, but not in general...
  fastqmetadata <- read.table(file="metadatatable.txt",sep=",",stringsAsFactors = FALSE,header = TRUE,colClasses = c(rep("character",10)))
  lapply(filelist,gupdatemetadata,p=p,fastqmetadata=fastqmetadata,src=source)

} # function that exists to push metadata across an entire set of output.
# TODO: Determine if/when metadata [eg: paired_end and platform_unit_id] shouldn't be applied to downstream files
