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


roiLen="${#roiList[@]}"
parr1Len="${#parr1[@]}"


## convert to nii, parc labels for dsc
cd $workDir

for i in ${runList[@]}; do
runDir=${workDir}/$i
cd $i

    for j in s*; do
        if [ $i != Run1 ]; then
            subjDir=${runDir}/${j}/fs
        else
            subjDir=${runDir}/${j}/fs/scan1
        fi

        cd $subjDir

        if [ ! -f bin_0012.nii.gz ]; then

            mri_convert mri/T1.mgz struct_fs.nii.gz
            mri_convert mri/aparc+aseg.mgz labels.nii.gz

            c=0; while [ $c -lt $roiLen ]; do
                c3d labels.nii.gz -thresh ${labelList[$c]} ${labelList[$c]} ${labelList[$c]} 0 -o bin_${roiList[$c]}.nii.gz
                let c=$[$c+1]
            done
        fi

    cd $runDir
    done

cd $workDir
done


## do dsc, report
print=${outDir}/DSC_fs.txt
echo "Subj DSC-Comp Test Mask 1Match 2Match OVLP_SZ DSC JCDC" > $print

c1=0; while [ $c1 -lt $roiLen ]; do
    for i in ${subjList[@]}; do
        c2=0; while [ $c2 -lt $parr1Len ]; do

            if [ ${parr1[$c2]} == Run1 ]; then
                data1=${workDir}/${parr1[$c2]}/${i}/fs/scan1/bin_${roiList[$c1]}.nii.gz
            else
                data1=${workDir}/${parr1[$c2]}/${i}/fs/bin_${roiList[$c1]}.nii.gz
            fi

            data2=${workDir}/${parr2[$c2]}/${i}/fs/bin_${roiList[$c1]}.nii.gz

            dsc1=`c3d $data1 $data2 -overlap ${labelList[$c1]}`
            runa=${parr1[$c2]}
            runb=${parr2[$c2]}

        echo "$i ${runa}-${runb} $dsc1" >> $print

        let c2=$[$c2+1]
        done
    done

let c1=$[$c1+1]
done


cd $outDir

for i in *fs.txt; do

    sed 's/,//g' $i > tmp1
    sed 's/://g' tmp1 > tmp2
    cp tmp2 $i
    rm tmp*

done
















