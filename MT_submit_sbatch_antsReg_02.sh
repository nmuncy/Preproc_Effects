#!/bin/bash


tempDir=~/bin/Templates/old_templates/mni_icbm152_nlin_sym_09c_nifti/mni_icbm152_nlin_sym_09c
workDir=~/compute/PreProc_Methods
scanDir=${workDir}/Template
scriptDir=${workDir}/Scripts
slurmDir=${workDir}/Slurm_out

time=`date '+%Y_%m_%d-%H_%M_%S'`
outDir=${slurmDir}/template_ants_$time

if [ ! -d $outDir ]; then
    mkdir -p $outDir
fi


cd $scanDir

for i in s* ; do

subjDir=${scanDir}/${i}

sbatch \
-o ${outDir}/output_${i}.txt \
-e ${outDir}/error_${i}.txt \
${scriptDir}/sbatch_antsReg_02.sh $subjDir ${i}_orig.nii.gz ${tempDir}/mni_icbm152_t1_tal_nlin_sym_09c.nii

sleep 1

done
