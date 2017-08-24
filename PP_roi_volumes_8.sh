#!/bin/bash

# written by Nathan Muncy on 8/11/17


workDir=/Volumes/Yorick/PreProc_Methods
outDir=${workDir}/analysis/vol


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

c=0; for i in 0012 0051 0017 0053 1015 2015; do
    roiList[$c]=$i
    let c=$[$c+1]
done

c=0; for i in 12 51 17 53 1015 2015; do
    labelList[$c]=$i
    let c=$[$c+1]
done

labelLen=${#labelList[@]}


### Output
if [ ! -d $outDir ]; then
    mkdir -p $outDir
fi

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
                c=0; while [ $c -lt $labelLen ]; do

                        if [ ! -f bin_${roiList[$c]}.nii.gz ]; then
                            c3d label_${roiList[$c]}.nii.gz -thresh 0.5 1 ${labelList[$c]} 0 -o bin_${roiList[$c]}.nii.gz
                        fi

                    vol=`c3d bin_${roiList[$c]}.nii.gz -dup -lstat`
                    echo "$j $vol" >> ${outDir}/${i}_${k}.txt

                let c=$[$c+1]
                done
            else
                for m in ${scanList[@]}; do
                scanDir=${stepDir}/$m
                cd $m

                    if [ $m == scan1 ]; then
                        c1=0; while [ $c1 -lt $labelLen ]; do

                                if [ ! -f bin_${roiList[$c1]}.nii.gz ]; then
                                    c3d label_${roiList[$c1]}.nii.gz -thresh 0.5 1 ${labelList[$c1]} 0 -o bin_${roiList[$c1]}.nii.gz
                                fi

                            vol=`c3d bin_${roiList[$c1]}.nii.gz -dup -lstat`
                            echo "$j $vol" >> ${outDir}/${i}_${k}.txt

                        let c1=$[$c1+1]
                        done
                    fi

                    c2=0; while [ $c2 -lt $labelLen ]; do

                            if [ ! -f bin_${roiList[$c2]}.nii.gz ]; then
                                c3d label_${roiList[$c2]}.nii.gz -thresh 0.5 1 ${labelList[$c2]} 0 -o bin_${roiList[$c2]}.nii.gz
                            fi

                        vol=`c3d bin_${roiList[$c2]}.nii.gz -dup -lstat`
                        echo "$j $m $vol" >> ${outDir}/${i}_rescan_${k}.txt

                    let c2=$[$c2+1]
                    done

                cd $stepDir
                done
            fi

        cd $subjDir
        done

    cd $runDir
    done

cd $workDir
done










