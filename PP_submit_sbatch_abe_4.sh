#!/bin/bash

# written by Nathan Muncy on 8/11/17


workDir=~/compute/PreProc_Methods
tempDir=${workDir}/Template
slurmDir=${workDir}/Slurm_out
scriptDir=${workDir}/Scripts

time=`date '+%Y_%m_%d-%H_%M_%S'`
outDir=${slurmDir}/abe_$time

mkdir $outDir


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

            acpcDir=${runDir}/${j}/acpc
            n4ssDir=${runDir}/${j}/n4ss

            cp ${acpcDir}/struct_acpc.nii.gz $n4ssDir

            if [ ! -f ${n4ssDir}/struct_n4ss.nii.gz ]; then

                sbatch \
                -o ${outDir}/output_${i}_${j}_abe.txt \
                -e ${outDir}/error_${i}_${j}_abe.txt \
                ${scriptDir}/sbatch_abe_4.sh $n4ssDir $tempDir

                sleep 1

            fi
        else
            subjDir=${runDir}/${j}
            cd $j

            for k in ${scanList[@]}; do

                getDir=${subjDir}/acpc/$k
                putDir=${subjDir}/n4ss/$k

                cp ${getDir}/struct_acpc.nii.gz $putDir

                if [ ! -f ${putDir}/struct_n4ss.nii.gz ]; then

                    sbatch \
                    -o ${outDir}/output_${i}_${j}_${k}_abe.txt \
                    -e ${outDir}/error_${i}_${j}_${k}_abe.txt \
                    ${scriptDir}/sbatch_abe_4.sh $putDir $tempDir

                    sleep 1

                fi
            done

        cd $runDir
        fi
    done

cd $workDir
done









