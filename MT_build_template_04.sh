#!/bin/bash



# variables
refDir=/Volumes/Yorick/Templates/old_templates/mni_icbm152_nlin_sym_09c_nifti/mni_icbm152_nlin_sym_09c
workDir=/Volumes/Yorick/PreProc_Methods/Template
con1=${workDir}/construct_head
con2=${workDir}/construct_brain


# set up
mkdir $con1
mkdir $con2

cd $workDir

for i in s*; do
cd $i

    cp ${i}_mni.nii.gz $con1
    cp ${i}_brain.nii.gz $con2

cd $workDir
done


# make head template
if [ ! -f ${con1}/PreProc_head_template.nii.gz ]; then
    cd $con1

    DIM=3
    ITER=30x90x30
    TRANS=GR
    SIM=CC
    CON=2
    PROC=8
    REF=${refDir}/mni_icbm152_t1_tal_nlin_sym_09c.nii


    buildtemplateparallel.sh \
    -d $DIM \
    -m $ITER \
    -t $TRANS \
    -s $SIM \
    -c $CON \
    -j $PROC \
    -o PreProc_head_ \
    -z $REF \
    s*.nii.gz
fi


# make brain template
if [ ! -f ${con2}/PreProc_brain_template.nii.gz ]; then
    cd $con2

    DIM=3
    ITER=30x90x30
    TRANS=GR
    SIM=CC
    CON=2
    PROC=8
    REF=${refDir}/mni_icbm152_t1_tal_nlin_sym_09c.nii


    buildtemplateparallel.sh \
    -d $DIM \
    -m $ITER \
    -t $TRANS \
    -s $SIM \
    -c $CON \
    -j $PROC \
    -o PreProc_brain_ \
    -z $REF \
    s*.nii.gz
fi
