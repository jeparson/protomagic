#TODO : Should this script also load the metadata from the local host since it's frequently used?
#TODO : Should this script set the project and authorization since they're used everywhere?
#TODO : Add Site to metadata in an appropriate location[SampleID/Investigation/Batch_number]

updatemetadata<-function(x,p,fastqmetadata=fastqmetadata){
  metadata<-fastqmetadata[fastqmetadata[,1]==x,2:length(fastqmetadata)]
  findfile(name=x,p,exact = TRUE)$setMeta(as.list(metadata)) # actually works now that the formatting in metadatatable is correct
} # Sets the metadata of a file on sbc to that presented in the metadatatable file [based on filename, only for fastqs].


gupdatemetadata<-function(dest,metadata){
# Inputs:  Dest is a file object, metadata is a metadata list.
# Only exists to be able to 'apply' the $setMeta function since it's technically not a function...
  # Input checking
  if(typeof(metadata)!="list"||length(metadata)==0){stop("Error in gupdatemetadata.  Metadata is not a list or is empty",metadata)}
  if(dest$class!="File"){stop("Error in gupdatemetadata. Dest is not a file",dest)}
      if(length(metadata)){
  dest$setMeta(as.list(metadata))} # Let's only set it if it's a real thing...
} # Sets the metadata of a file on sbc to that presented in the metadatatable file [based on filename, only for fastqs].


# Define findfile function:   Searches sbc project for a file
# Avoids awkwardness around the default search only searching top100 files
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

copymetadata<-function(tskid,src,p){
# Copy metadata from a source file to a task's output file list
# Intended to be used to set metadata on task output based on task input...
# @tskid - a SBC task id number
# @src - a SBC File object
# @p - a SBC Project object
  filelist<-p$task(id=tskid)$file() # only the output files
  metadata<-src$meta()
  metadata<-metadata[1:length(metadata)] # required to get rid of some weird API headers...
  lapply(filelist,gupdatemetadata,metadata=metadata)

} # function that exists to push metadata across an entire set of output.
# TODO: Determine if/when metadata [eg: paired_end and platform_unit_id] shouldn't be applied to downstream files
