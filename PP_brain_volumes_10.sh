#!/bin/bash

# written by Nathan Muncy on 8/11/17


workDir=/Volumes/Yorick/PreProc_Methods
outDir=${workDir}/analysis/brain_vol


### Arrays
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


### Output
for a in ${runList[@]}; do
    for b in ${stepList[@]}; do
        if [ $a == Run1 ]; then
            > ${outDir}/${a}_${b}.txt
            > ${outDir}/${a}_rescan_${b}.txt
        else
            > ${outDir}/${a}_${b}.txt
        fi
    done
done



### Work
cd $workDir

for i in ${runList[@]}; do
runDir=${workDir}/$i
cd $i

    for j in s*; do
    subjDir=${runDir}/$j
    cd $j

        for k in ${stepList[@]}; do
        stepDir=${subjDir}/$k
        cd $k

            if [ $i != Run1 ]; then

                vol=`c3d act_BrainExtractionMask.nii.gz -dup -lstat`
                echo "$j $vol" >> ${outDir}/${i}_${k}.txt

            else
                for m in ${scanList[@]}; do
                scanDir=${stepDir}/$m
                cd $m

                    if [ $m == scan1 ]; then

                        vol=`c3d act_BrainExtractionMask.nii.gz -dup -lstat`
                        echo "$j $vol" >> ${outDir}/${i}_${k}.txt

                    fi

                    vol=`c3d act_BrainExtractionMask.nii.gz -dup -lstat`
                    echo "$j $m $vol" >> ${outDir}/${i}_rescan_${k}.txt

                cd $stepDir
                done
            fi

        cd $subjDir
        done

    cd $runDir
    done

cd $workDir
done










