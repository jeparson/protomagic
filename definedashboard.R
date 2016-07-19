library(sevenbridges)
library(readr)
#reads local file, but defines it on the job / image
# Any changes to the inputs or positions must be doubled in both definedashboard.R and runDashboard.R
fl=fileDef(name='runDashboard.R',content=read_file('runDashboard.R'))
ERCCDashboard<-Tool(id="ERCCdashboard",label="ERCCdashboard",
hints = requirements(docker(pull="bioconductor/devel_sequencing"),cpu(1),mem(2000)),
requirements=requirements(fl),
baseCommand = "Rscript runDashboard.R",
inputs = list(
  input(
    id='filenameRoot',
    type='string',
    required=TRUE,
    position= 1),
  input(
    id='isNorm',
    type='string',
    default="TRUE",
    required=TRUE,
    position=2),
  input(
    id='sample1_name',
    type='string',
    required=TRUE,
    position=3),
  input(
    id='sample2_name',
    type='string',
    required=TRUE,
    position=4),
  input(
    id='erccdilution',
    type='int',
    required=TRUE,
    default=100,
    position=5),
  input(
    id='spikeVol',
    type='int',
    required=TRUE,
    default=1,
    position=6),
  input(
  id='totalRNAmass',
  type='int',
  required=TRUE,
  default=1,
  position=7),
  input(
    id='chose_fdr',
    type='float',
    required=TRUE,
    default=0.05,
    position= 8),
  input(
    id= 'source_file',
    type='File',
    required=TRUE,
    position=9),
  input(
    id='erccmix',
    type= 'string',
    required=TRUE,
    default="RatioPair",
    position=10)
  ),
outputs=list(output(id = 'output',glob = "*.pdf"),output(id='data',glob="*.rData"))
)

p$app_add('runDashboard',ERCCDashboard)
