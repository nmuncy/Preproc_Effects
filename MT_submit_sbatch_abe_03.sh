#!/bin/bash


tempDir=~/bin/Templates/old_templates/oasis_30
dim=3
fixed=${tempDir}/T_template0.nii.gz
pmask=${tempDir}/T_template0_BrainCerebellumProbabilityMask.nii.gz
rmask=${tempDir}/T_template0_BrainCerebellumRegistrationMask.nii.gz

workDir=~/compute/PreProc_Methods
scanDir=${workDir}/Template
scriptDir=${workDir}/Scripts
slurmDir=${workDir}/Slurm_out

time=`date '+%Y_%m_%d-%H_%M_%S'`
outDir=${slurmDir}/template_abe_$time

if [ ! -d $outDir ]; then
mkdir -p $outDir
fi


cd $scanDir

for i in s* ; do

subjDir=${scanDir}/${i}

sbatch \
-o ${outDir}/output_${i}.txt \
-e ${outDir}/error_${i}.txt \
${scriptDir}/sbatch_abe_03.sh $subjDir ${i}_mni.nii.gz $tempDir

sleep 1

done
