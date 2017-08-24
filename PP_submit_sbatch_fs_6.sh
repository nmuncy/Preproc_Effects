#!/bin/bash

# written by Nathan Muncy on 8/11/17


### Variables
workDir=~/compute/PreProc_Methods
oasisDir=${workDir}/Oasis
slurmDir=${workDir}/Slurm_out
scriptDir=${workDir}/Scripts

time=`date '+%Y_%m_%d-%H_%M_%S'`
outDir=${slurmDir}/fs_$time

mkdir $outDir


### Arrays
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
    subjDir=${runDir}/$j
    fsDir=${subjDir}/fs

        if [ $i != Run1 ]; then
            if [ ! -f ${fsDir}/stats/aseg.stats ]; then

                    if [ -d ${fsDir}/label ]; then
                        for x in label scripts stats surf tmp touch trash; do
                            rm -r ${fsDir}/$x
                        done
                    fi

                sbatch \
                -o ${outDir}/output_${i}_${j}_fs.txt \
                -e ${outDir}/error_${i}_${j}_fs.txt \
                ${scriptDir}/sbatch_fs_6.sh $subjDir fs

                sleep 1

            fi
        else
            for k in ${scanList[@]}; do
            scanDir=${subjDir}/fs/$k

                if [ ! -f ${scanDir}/stats/aseg.stats ]; then

                        if [ -d ${scanDir}/label ]; then
                            for x in label scripts stats surf tmp touch trash; do
                                rm -r ${scanDir}/$x
                            done
                        fi

                    sbatch \
                    -o ${outDir}/output_${i}_${j}_${k}_fs.txt \
                    -e ${outDir}/error_${i}_${j}_${k}_fs.txt \
                    ${scriptDir}/sbatch_fs_6.sh $fsDir $k

                    sleep 1

                fi
            done
        fi
    done

cd $workDir
done








