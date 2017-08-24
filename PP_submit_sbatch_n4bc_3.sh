#!/bin/bash

# written by Nathan Muncy on 8/11/17


workDir=~/compute/PreProc_Methods
slurmDir=${workDir}/Slurm_out
scriptDir=${workDir}/Scripts

time=`date '+%Y_%m_%d-%H_%M_%S'`
outDir=${slurmDir}/n4bc_$time

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

            acpcDir=${runDir}/${j}/acpc
            n4bcDir=${runDir}/${j}/n4bc

            cp ${acpcDir}/struct_acpc.nii.gz $n4bcDir
            cd $n4bcDir

            if [ ! -f struct_n4bc.nii.gz ]; then

                sbatch \
                -o ${outDir}/output_${i}_${j}_n4bc.txt \
                -e ${outDir}/error_${i}_${j}_n4bc.txt \
                ${scriptDir}/sbatch_n4bc_3.sh $n4bcDir

                sleep 1

            fi

        cd $runDir
        else

            subjDir=${runDir}/${j}
            cd $j

            for k in ${scanList[@]}; do

                getDir=${subjDir}/acpc/$k
                putDir=${subjDir}/n4bc/$k

                cp ${getDir}/struct_acpc.nii.gz $putDir
                cd $putDir

                if [ ! -f struct_n4bc.nii.gz ]; then

                    sbatch \
                    -o ${outDir}/output_${i}_${j}_${k}_n4bc.txt \
                    -e ${outDir}/error_${i}_${j}_${k}_n4bc.txt \
                    ${scriptDir}/sbatch_n4bc_3.sh $putDir

                    sleep 1

                fi

            cd $subjDir
            done

        cd $runDir
        fi
    done

cd $workDir
done









