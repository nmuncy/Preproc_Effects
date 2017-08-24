#!/bin/bash

# written by Nathan Muncy on 8/11/17


workDir=/Volumes/Yorick/PreProc_Methods
outDir=${workDir}/analysis/dsc

if [ ! -d $outDir ]; then
    mkdir $outDir
fi



### Arrays
c=0; for i in Run{1..5}; do
    runList[$c]=$i
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

c=0; for i in $(ls ${workDir}/Run1/); do
    path=${workDir}/Run1/
    subject=${i/$path}
    subjList[$c]=$subject
    let c=$[$c+1]
done


## make permutation arrays
set -- "${runList[@]}"
out=`for a; do shift; for b; do echo "$a" "$b"; done; done`
parr1=($(echo "${out}" | awk '{ print $1 }'))
parr2=($(echo "${out}" | awk '{ print $2 }'))


stepLen="${#stepList[@]}"
roiLen="${#roiList[@]}"
parr1Len="${#parr1[@]}"



### Work
# calc DSCs, report
c1=0; while [ $c1 -lt $stepLen ]; do

    print1[$c1]=${outDir}/DSC_"${stepList[$c1]}".txt
    echo "Subj DSC-Comp Test Mask 1Match 2Match OVLP_SZ DSC JCDC" > "${print1[$c1]}"

    c2=0; while [ $c2 -lt $roiLen ]; do
        for i in ${subjList[@]}; do
            c3=0; while [ $c3 -lt $parr1Len ]; do

                if [ ${parr1[$c3]} == Run1 ]; then
                    data1=${workDir}/${parr1[$c3]}/${i}/${stepList[$c1]}/scan1/bin_${roiList[$c2]}.nii.gz
                else
                    data1=${workDir}/${parr1[$c3]}/${i}/${stepList[$c1]}/bin_${roiList[$c2]}.nii.gz
                fi

                data2=${workDir}/${parr2[$c3]}/${i}/${stepList[$c1]}/bin_${roiList[$c2]}.nii.gz

                dsc1=`c3d $data1 $data2 -overlap ${labelList[$c2]}`
                runa=${parr1[$c3]}
                runb=${parr2[$c3]}

                echo "$i ${runa}-${runb} $dsc1" >> ${print1[$c1]}

            let c3=$[$c3+1]
            done
        done

    let c2=$[$c2+1]
    done

let c1=$[$c1+1]
done


# clean files
cd ${outDir}

for i in *.txt; do

    sed 's/,//g' $i > tmp1
    sed 's/://g' tmp1 > tmp2
    cp tmp2 $i
    rm tmp*

done
























