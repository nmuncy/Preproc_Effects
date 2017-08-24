#!/bin/bash



workDir=~/compute/PreProc_Methods
slurmDir=${workDir}/Slurm_out
tempDir=${workDir}/Template
scriptDir=${tempDir}/Construction/Scripts

time=`date '+%Y_%m_%d-%H_%M_%S'`
outDir=${slurmDir}/template_act_$time

mkdir -p $outDir


sbatch \
-o ${outDir}/output_template_act.txt \
-e ${outDir}/error_template_act.txt \
${scriptDir}/sbatch_act_05.sh $tempDir PreProc_head_template.nii.gz
