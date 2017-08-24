#!/bin/bash



### variables
parDir=/Volumes/Yorick/PreProc_Methods
workDir=${parDir}/Template
dataPar=${parDir}/Run2

if [ ! -d $workDir ]; then
    mkdir $workDir
fi

# arrays
declare -a dataList=(OAS1_0209_MR1 OAS1_0224_MR1 OAS1_0059_MR1 OAS1_0025_MR1 OAS1_0218_MR1 OAS1_0156_MR1 OAS1_0295_MR1 OAS1_0227_MR1 OAS1_0392_MR1 OAS1_0150_MR1 OAS1_0281_MR1 OAS1_0105_MR1 OAS1_0189_MR1 OAS1_0368_MR1 OAS1_0396_MR1 OAS1_0333_MR1 OAS1_0361_MR1 OAS1_0108_MR1 OAS1_0250_MR1 OAS1_0346_MR1)

c=0; for i in ${dataList[@]}; do
    tmp=${i#*_}
    subj=s${tmp%_*}
    subjList[$c]=$subj
    let c=$[$c+1]
done


cd $dataPar
for i in ${subjList[@]}; do

    destDir=${workDir}/$i
    mkdir $destDir

    dataDir=${dataPar}/${i}/orig
    cp ${dataDir}/struct_orig.nii.gz ${dataDir}/${i}_orig.nii.gz
    mv ${dataDir}/${i}_orig.nii.gz $destDir

done
