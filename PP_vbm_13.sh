#!/bin/bash

# written by Nathan Muncy on 8/11/17


### Variables
workDir=/Volumes/Yorick/PreProc_Methods
scriptDir=${workDir}/Scripts
tempDir=${workDir}/Template
jlfDir=${tempDir}/priors_JLF

vbmDir=${workDir}/VBM
stats1Dir=${vbmDir}/stats_Hip
stats2Dir=${vbmDir}/stats_MTG
matDir=${vbmDir}/matrices

for a in $vbmDir $stats1Dir $stats2Dir $matDir; do
    if [ ! -d $a ]; then
        mkdir -p $a
    fi
done



### Arrays
roiL=(0017 1015)
roiR=(0053 2015)
label=(Hip MTG)

# all subjects
c=0; for i in $(ls ${workDir}/Run1/); do
    path=${workDir}/Run1/
    subject=${i/$path}
    subj[$c]=$subject
    let c=$[$c+1]
done

# some subjects
c=0; while [ $c -lt 20 ]; do
    subjList[$c]=${subj[$c]}
    let c=$[$c+1]
done

c=0; for i in orig acpc n4bc n4ss; do
    stepList[$c]=$i
    let c=$[$c+1]
done

roiLen=${#label[@]}
subjLen=${#subjList[@]}
stepLen=${#stepList[@]}



### Stitch, binarize template priors
cd $vbmDir

c=0; while [ $c -lt $roiLen ]; do
    if [ ! -f Template_"${label[$c]}"_bin.nii.gz ]; then

        ImageMath 3 \
        Template_"${label[$c]}".nii.gz \
        + \
        ${jlfDir}/label_"${roiL[$c]}".nii.gz \
        ${jlfDir}/label_"${roiR[$c]}".nii.gz

        ThresholdImage 3 \
        Template_"${label[$c]}".nii.gz \
        Template_"${label[$c]}"_bin.nii.gz \
        0.5 1

    fi
let c=$[$c+1]
done



### Make subject roi normalized to template files, for 20 subjects
runDir=${workDir}/Run2
cd $runDir

for a in ${subjList[@]}; do
subjDir=${runDir}/$a
cd $subjDir

    for i in ${stepList[@]}; do
    stepDir=${subjDir}/$i
    cd $stepDir

        for j in ${label[@]}; do
            if [ ! -f ${vbmDir}/${a}_${i}_${j}_NTT.nii.gz ]; then

                ImageMath 3 \
                ${vbmDir}/${a}_${i}_${j}_NTT.nii.gz \
                m \
                act_CorticalThicknessNormalizedToTemplate.nii.gz \
                ${vbmDir}/Template_${j}_bin.nii.gz

            fi
        done

    cd $subjDir
    done

cd $runDir
done



### Get data for matrices
echo "${subjList[@]}" > ${matDir}/subj_list.txt

> ${matDir}/grp.txt
for (( i=1; i<=$subjLen; i++)); do
    for (( j=1; j<=$stepLen; j++)); do
        echo $i >> ${matDir}/grp.txt
    done
done

c1=0; while [ $c1 -lt $roiLen ]; do
print=${matDir}/list_${label[$c1]}.txt
> $print

    for i in ${subjList[@]}; do
        c2=0; while [ $c2 -lt $stepLen ]; do

            num=$[$c2+1]
            echo ${i}_${stepList[$c2]}_${label[$c1]}_${num} >> $print

        let c2=$[$c2+1]
        done
    done

let c1=$[$c1+1]
done







