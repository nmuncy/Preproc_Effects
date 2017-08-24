#!/bin/bash


refDir=~/bin/Templates/old_templates/oasis_20

workDir=~/compute/PreProc_Methods
slurmDir=${workDir}/Slurm_out
tempDir=${workDir}/Template
scriptDir=${tempDir}/Construction/Scripts

time=`date '+%Y_%m_%d-%H_%M_%S'`
outDir=${slurmDir}/template_jlf_$time

mkdir -p $outDir


sbatch \
-o ${outDir}/output_jlf.txt \
-e ${outDir}/error_jlf.txt \
${scriptDir}/sbatch_jlf_04.sh $tempDir $refDir PreProc_head_template.nii.gz

