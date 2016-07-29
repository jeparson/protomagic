library(sevenbridges)
library(readr)
#reads local file, but defines it on the job / image
# Any changes to the inputs or positions must be doubled in both definedashboard.R and runDashboard.R
fl=fileDef(name='runDashboardBeta.R',content=read_file('runDashboardBeta.R'))
ERCCDashboard<-Tool(id="ERCCdashboard",label="ERCCdashboard",
hints = requirements(docker(pull="bioconductor/devel_sequencing"),cpu(1),mem(2000)),
requirements=requirements(fl),
baseCommand = "Rscript runDashboardBeta.R",
inputs = IPList(
  input(
    id='filenameRoot',
    label='filename',
    description = 'Base name for output file',
    type='string',
    required=TRUE,
    position= 1),
  input(
    id='isNorm',
    label='isnorm',
    description='normalization status TRUE/FALSE',
    type='string',
    default="TRUE",
    required=TRUE,
    position=2),
  input(
    id='sample1_name',
    label='sample1_name',
    description ='name of first sample',
    type='string',
    required=TRUE,
    position=3),
  input(
    id='sample2_name',
    label='sample2_name',
    description ='name of second sample',
    type='string',
    required=TRUE,
    position=4),
  input(
    id='erccdilution',
    label='erccdilution',
    description='dilution factor of ERCC spike-ins(1:100 = 100)',
    type='int',
    required=TRUE,
    default=100,
    position=5),
  input(
    id='spikeVol',
    label='spikevol',
    description='volume of ERCC spiked-in (uL)',
    type='int',
    required=TRUE,
    default=1,
    position=6),
  input(
  id='totalRNAmass',
  label='totalRNAmass',
  description='mass in micrograms of RNA spiked with ERCC mixtures',
  type='int',
  required=TRUE,
  default=1,
  position=7),
  input(
    id='chose_fdr',
    label='chose_fdr',
    description ='False Discovery Rate for differential expression testing',
    type='float',
    required=TRUE,
    default=0.05,
    position= 8),
  input(
    id= 'source_file',
    label='source_file',
    description='data frame, 1st column containing names of transcripts, remaining are replicate expression measures of samples',
    type='File',
    required=TRUE,
    position=9),
  input(
    id='erccmix',
    label='erccmix',
    description='name of ERCC mixture design added',
    type= 'string',
    required=TRUE,
    default="RatioPair",
    position=10)
  ),
outputs=list(output(type = ItemArray("File"),id = 'DashboardFigures',glob = "*.pdf"),output(id='data',glob="*.rData",type="file"))
)

p$app_add('runDashboardBeta',ERCCDashboard)
