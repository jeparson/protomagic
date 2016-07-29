#!/bin/bash
gtfToGenePred -genePredExt -geneNameAsName2 $1 refFlat.tmp.txt
paste <(cut -f 12 refFlat.tmp.txt) <(cut -f 1-10 refFlat.tmp.txt) > $2
gzip $2