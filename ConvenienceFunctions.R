#TODO : Should this script also load the metadata from the local host since it's frequently used?
#TODO : Should this script set the project and authorization since they're used everywhere?
#TODO : Add Site to metadata in an appropriate location[SampleID/Investigation/Batch_number]

requirelist<-function(crpackages=NULL,bcpackages=NULL,ghpackages=NULL,quietly=TRUE){
# Inputs:  List of packages available on cran.  List of packages available on bioconductor.  List of packages available on github.
# Github packages need to be either the url or the username/repo [things that can get fed to install_github].
  plist<-installed.packages() # caching this list since it takes about a second to load.
  if(!is.null(crpackages)){
    if(length(crpackages[!crpackages%in%plist])){
      install.packages(crpackages[!crpackages%in%plist])
    }
  }
  if(!is.null(bcpackages)){
    if(length(bcpackages[!bcpackages%in%plist])){
      source("http://bioconductor.org/biocLite.R")
      BiocInstaller::biocLite(bcpackages[!bcpackages%in%plist])
    }
  }
  if(!is.null(ghpackages)){
    # Do a substitution of the username
    ghlist<-unlist(lapply(ghpackages,FUN = function(x){last(strsplit(x,split="/")[[1]])})) # Element after the last slash.
    if(length(ghlist[!ghlist%in%plist])){
      if(!"devtools"%in%plist){install.packages("devtools")}
     devtools::install_github(repo = ghpackages[!ghpackages%in%plist])
    }
  }
  for(I in c(crpackages,bcpackages,ghpackages)){
    require(I,quietly=quietly,character.only=TRUE)
  }
} # Makes a list of packages needed within a script.  Installs if needed, then loads.

updatemetadata<-function(x,p,fastqmetadata=fastqmetadata){
  #` @x File name
  #` @p project object
  #` @fastqmetadata table
    metadata<-fastqmetadata[fastqmetadata[,1]==x,2:length(fastqmetadata)]
  findfile(name=x,p,exact = TRUE)$setMeta(as.list(metadata)) # actually works now that the formatting in metadatatable is correct
} # Sets the metadata of a file on sbc to that presented in the metadatatable file [based on filename, only for fastqs].
# TODO: Merge these two functions as a switch on typeof X
updatemetadatan<-function(x,p,fastqmetadata=fastqmetadata){
  #` @x File object
  #` @p project object
  #` @fastqmetadata table
  metadata<-fastqmetadata[fastqmetadata[,1]==x$name,2:length(fastqmetadata)]
  x$setMeta(as.list(metadata)) # actually works now that the formatting in metadatatable is correct
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
gmeta<-function(dest){
  return(dest$meta())
} # Returns the metadata of a file object.  Again, just a convenience wrapper because I don't know how to apply a function within a class...

# Define findfile function:   Searches sbc project for a file
# Avoids awkwardness around the default search only searching top100 files
findfile<-function(name,proj=p,...){
# Inputs: Name = filename to search for
# P : Project to look within
return(proj$file(name=name,limit=0,...))
} # TODO: Fully deprecate this function; findfile is no longer really relevant, but it's called a lot...

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
# @p - a SBC Project object
  filelist<-p$task(id=tskid)$file() # only the output files
  metadata<-src$meta()
  metadata<-metadata[1:length(metadata)] # required to get rid of some weird API headers...
  lapply(filelist,gupdatemetadata,metadata=metadata)

} # function that exists to push metadata across an entire set of output.
# TODO: Determine if/when metadata [eg: paired_end and platform_unit_id] shouldn't be applied to downstream files
