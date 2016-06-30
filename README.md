# protomagic
A set of cloud-based analysis scripts to run on ERCC Multilab study samples.  
We will prototype using NIST in-house data from the 'Magic Mix V1' HiSeq run [as it has SIRVs]

The intention is to automate the analysis such that it can be easily reproduced, as we will likely be doing similar or identical work 20+ times in the future.  

#### Step 1:  Upload to the cloud
  Takes as input a directory full of fastq files from a study & sends to 7BridgesCloud account for ERCC-consortium analysis (Steps 2-10)<p>
[input makes changes to the RMD;may convert to user-defined input for production?]

#### Step 2:  FastQC
#### Step 3:  Alignment
#### Step 4:  BAM QC 
#### Step 5:  Count table Integration 
#### Step 6:  Spike-in level QC
#### Step 7:  DE Testing
#### Step 8:  Interference testing
#### Step 9:  Mixture model analysis
#### Step 10:  Endogenous RNA Metrics
