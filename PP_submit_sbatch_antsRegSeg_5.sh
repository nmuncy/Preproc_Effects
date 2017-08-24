#!/bin/bash

# written by Nathan Muncy on 8/11/17


workDir=~/compute/PreProc_Methods
tempDir=${workDir}/Template
slurmDir=${workDir}/Slurm_out
scriptDir=${workDir}/Scripts

time=`date '+%Y_%m_%d-%H_%M_%S'`
outDir=${slurmDir}/regSeg_$time

mkdir $outDir


c=0; for i in Run{1..5}; do
    runList[$c]=$i
    let c=$[$c+1]
done

c=0; for i in scan{1..3}; do
    scanList[$c]=$i
    let c=$[$c+1]
done

c=0; for i in orig acpc n4bc n4ss; do
    stepList[$c]=$i
    let c=$[$c+1]
done


cd $workDir

for i in ${runList[@]}; do
runDir=${workDir}/$i
cd $i

    for j in s*; do
    subjDir=${runDir}/$j
    cd $j

        for k in ${stepList[@]}; do
        stepDir=${subjDir}/$k

                if [ $k == n4ss ]; then
                    template=${tempDir}/PreProc_brain_template.nii.gz
                else
                    template=${tempDir}/PreProc_head_template.nii.gz
                fi

            if [ $i != Run1 ]; then
                if [ ! -f ${stepDir}/ants_Warp.nii.gz ] || [ ! -f ${stepDir}/label_0012.nii.gz ]; then

                    sbatch \
                    -o ${outDir}/output_${i}_${j}_${k}_regSeg.txt \
                    -e ${outDir}/error_${i}_${j}_${k}_regSeg.txt \
                    ${scriptDir}/sbatch_antsRegSeg_5.sh $stepDir struct_${k}.nii.gz $template ${tempDir}/priors_JLF

                    sleep 1

                fi
            else
                cd $stepDir

                for m in ${scanList[@]}; do
                scanDir=${stepDir}/$m

                    if [ ! -f ${scanDir}/ants_Warp.nii.gz ] || [ ! -f ${stepDir}/label_0012.nii.gz ]; then

                        sbatch \
                        -o ${outDir}/output_${i}_${j}_${k}_${m}_regSeg.txt \
                        -e ${outDir}/error_${i}_${j}_${k}_${m}_regSeg.txt \
                        ${scriptDir}/sbatch_antsRegSeg_5.sh $scanDir struct_${k}.nii.gz $template ${tempDir}/priors_JLF

                        sleep 1

                    fi
                done

            cd $subjDir
            fi
        done

    cd $runDir
    done

cd $workDir
done










