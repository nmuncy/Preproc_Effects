#!/bin/bash

# written by Nathan Muncy on 8/11/17


workDir=~/compute/PreProc_Methods
slurmDir=${workDir}/Slurm_out
tempDir=${workDir}/Template
scriptDir=${workDir}/Scripts

time=`date '+%Y_%m_%d-%H_%M_%S'`
outDir=${slurmDir}/acpc_$time

mkdir -p $outDir


c=0; for i in Run{1..5}; do
    runList[$c]=$i
    let c=$[$c+1]
done

c=0; for i in scan{1..3}; do
    scanList[$c]=$i
    let c=$[$c+1]
done


cd $workDir

for i in ${runList[@]}; do
runDir=${workDir}/$i
cd $i

    for j in s*; do
        if [ $i != Run1 ]; then

            origDir=${runDir}/${j}/orig
            acpcDir=${runDir}/${j}/acpc

            cp ${origDir}/struct_orig.nii.gz $acpcDir
            cd $acpcDir

            if [ ! -f struct_acpc.nii.gz ]; then

                sbatch \
                -o ${outDir}/output_${i}_${j}_acpc.txt \
                -e ${outDir}/error_${i}_${j}_acpc.txt \
                ${scriptDir}/sbatch_acpc_2.sh $acpcDir $tempDir

                sleep 1

            fi

        cd $runDir
        else

            subjDir=${runDir}/${j}
            cd $j

            for k in ${scanList[@]}; do

                getDir=${subjDir}/orig/$k
                putDir=${subjDir}/acpc/$k

                cp ${getDir}/struct_orig.nii.gz $putDir
                cd $putDir

                if [ ! -f struct_acpc.nii.gz ]; then

                    sbatch \
                    -o ${outDir}/output_${i}_${j}_${k}_acpc.txt \
                    -e ${outDir}/error_${i}_${j}_${k}_acpc.txt \
                    ${scriptDir}/sbatch_acpc_2.sh $putDir $tempDir

                    sleep 1

                fi

            cd $subjDir
            done

        cd $runDir
        fi
    done

cd $workDir
done









