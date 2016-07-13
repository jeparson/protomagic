cwlVersion: cwl:draft-3
class: CommandLineTool
baseCommand: RScript
hints:
  - class: DockerRequirement
    dockerPull: bioconductor/release_microarray
inputs:
  - id: filenameRoot
    type: string
    inputBinding:
      position: 1
      prefix: --filenameRoot
      separate: false
  - id: isNorm
    type: boolean
    inputBinding:
      position: 2
      prefix: --isNorm
      separate: false
  - id: sample1_name
    type: string
    inputBinding:
      position: 3
      prefix: --sample1name
      separate: false
  - id: sample2_name
    type: string
    inputBinding:
      position: 4
      prefix: --sample2name
      separate: false
  - id: erccdilution
    type: int
    inputBinding:
      position: 5
      prefix: --erccdilution
      separate: false
  - id: spikeVol
    type: int
    inputBinding:
      position: 6
      prefix: --spikeVol
      separate: false
  - id: totalRNAmass
    type: int
    inputBinding:
      position: 7
      prefix: --totalRNAmass
      separate: false
  - id: chose_fdr
    type: numeric
    inputBinding:
      position: 8
      prefix: --chose_fdr
      separate: false
  - id: source_file
    type: ["null", File]
    inputBinding:
      prefix: --file=
      separate: false
      position: 9
  - id: erccmix
    type: string
    inputBinding:
      position: 10
      prefix: --erccmix
      separate: false

outputs:
  - id: output
    type:
      type: array
      items: File
    outputBinding:
      glob: "*.pdf"


