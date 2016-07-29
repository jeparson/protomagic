library(sevenbridges)
library(readr)
#reads local file, but defines it on the job / image
# Any changes to the inputs or positions must be doubled in both definedashboard.R and runDashboard.R
script=fileDef(name='merge_count_data.R',content=read_file('merge_count_data.R'))
MergeCounts<-Tool(id="MergeCounts",label="MergeCounts",
                    hints = requirements(docker(pull="bioconductor/devel_sequencing"),cpu(1),mem(2000)),
                    requirements=requirements(script),
                    baseCommand = "RScript mergeCounts.R",
                    inputs = list(
                      input(
                        id= 'source_file',
                        type='File Array',
                        required=TRUE,
                        position=4),
                      input(
                        id='Column',
                        type= 'numeric',
                        required=TRUE,
                        default="1",
                        position=1),
                      input(
                        id='names',
                        type='string',
                        required=TRUE,
                        position=2,
                        description = 'comma-separated list of names for input files'
                      ),
                      input(
                        id='outputfilename',
                        type='string',
                        required=TRUE,
                        position=3,
                        default='merged.csv',
                        description='name for output file'
                      )
                    ),
                    outputs=output(id = 'output',glob = "*merged.csv")
)

p$app_add('mergecounts',MergeCounts)
