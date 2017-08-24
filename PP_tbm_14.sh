#!/bin/bash

# written by Nathan Muncy on 8/11/17
# This script will run a repeated measures ANOVA tensor-based morphometric analysis



workDir=/Volumes/Yorick/PreProc_Methods
priorDir=${workDir}/Template/priors_ACT
tbmDir=${workDir}/TBM
matDir=${tbmDir}/matrices

declare -a roi=("Put" "Hip" "MTG")


cd $tbmDir

for i in "${roi[@]}"; do
statsDir=${tbmDir}/stats_$i

    if [ ! -d $statsDir ]; then
        mkdir -p $statsDir
    fi

    ### merge files, get exclusion mask
    if [ ! -f ${statsDir}/merged_${i}.nii.gz ]; then
        fslmerge -t ${statsDir}/merged_${i}.nii.gz s*${i}*.nii.gz
    fi

    if [ ! -f ${statsDir}/Template_BrainCerebellumBinaryMask.nii.gz ]; then
        cp ${priorDir}/Template_BrainCerebellumBinaryMask.nii.gz $statsDir
    fi


    ### Create vests - requires 4 manually-created txt files
    cd $statsDir

    if [ ! -f design.mat ]; then
        Text2Vest ${matDir}/design.txt design.mat
    fi


    if [ ! -f design.con ]; then

        Text2Vest ${matDir}/contrasts.txt design.con

        echo '/ContrastName3	n4ss diff' | cat - design.con > temp && mv temp design.con
        echo '/ContrastName2	n4bc diff' | cat - design.con > temp && mv temp design.con
        echo '/ContrastName1	acpc diff' | cat - design.con > temp && mv temp design.con
        echo '/ContrastNameB	orig base' | cat - design.con > temp && mv temp design.con

    fi


    if [ ! -f design.fts ]; then
        Text2Vest ${matDir}/ftests.txt design.fts
    fi


    if [ ! -f design.grp ]; then
        Text2Vest ${matDir}/group.txt design.grp
    fi


    ### run tbm

    #-V
    randomise \
    -i merged_${i} \
    -o TBM_RM_${i} \
    -d design.mat \
    -t design.con \
    -f design.fts \
    -m Template_BrainCerebellumBinaryMask.nii.gz \
    -e design.grp \
    -n 500 \
    -T

cd $tbmDir
done
