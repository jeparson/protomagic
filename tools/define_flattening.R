library(sevenbridges)
library(readr)
#reads local file, but defines it on the job / image
# Any changes to the inputs or positions must be doubled in both definedashboard.R and runDashboard.R
script<-fileDef(name='makeflat.sh',content=read_file('tools/make_flat.sh'))
gtftoflat<-Tool(id="gtftoflat",label="GTFtoFlat",
                  hints = requirements(docker(pull="images.sbgenomics.com/jerod_parsons/gtftoflat"),cpu(1),mem(8000)),
                  requirements=requirements(script),
                                  baseCommand = "sh makeflat.sh",
                  inputs = list(
                    input(
                      id= 'source_file',
                      type='File',
                      required=TRUE,
                      position=1),
                    input(
                      id='outputfilename',
                      type='string',
                      required=TRUE,
                      position=2,
                      default='refFlat.txt',
                      description='name for output file'
                    )
                  ),
                  outputs=output(id = 'output',glob = "*.txt")
)

p$app_add('GTFtoFlat',gtftoflat)
