#!/bin/bash

# written by Nathan Muncy on 8/11/17

### variables
workDir=/Volumes/Yorick/PreProc_Methods
dataPar=${workDir}/Oasis


# arrays
declare -a dataList=(OAS1_0009_MR1 OAS1_0049_MR1 OAS1_0055_MR1 OAS1_0059_MR1 OAS1_0061_MR1 OAS1_0077_MR1 OAS1_0090_MR1 OAS1_0105_MR1 OAS1_0107_MR1 OAS1_0150_MR1 OAS1_0156_MR1 OAS1_0162_MR1 OAS1_0211_MR1 OAS1_0231_MR1 OAS1_0236_MR1 OAS1_0253_MR1 OAS1_0285_MR1 OAS1_0294_MR1 OAS1_0295_MR1 OAS1_0310_MR1 OAS1_0313_MR1 OAS1_0344_MR1 OAS1_0361_MR1 OAS1_0379_MR1 OAS1_0397_MR1 OAS1_0007_MR1 OAS1_0017_MR1 OAS1_0029_MR1 OAS1_0043_MR1 OAS1_0054_MR1 OAS1_0057_MR1 OAS1_0087_MR1 OAS1_0126_MR1 OAS1_0191_MR1 OAS1_0198_MR1 OAS1_0250_MR1 OAS1_0258_MR1 OAS1_0350_MR1 OAS1_0359_MR1 OAS1_0415_MR1 OAS1_0419_MR1 OAS1_0439_MR1 OAS1_0092_MR1 OAS1_0125_MR1 OAS1_0132_MR1 OAS1_0144_MR1 OAS1_0189_MR1 OAS1_0209_MR1 OAS1_0224_MR1 OAS1_0232_MR1 OAS1_0246_MR1 OAS1_0277_MR1 OAS1_0302_MR1 OAS1_0311_MR1 OAS1_0348_MR1 OAS1_0353_MR1 OAS1_0368_MR1 OAS1_0385_MR1 OAS1_0394_MR1 OAS1_0408_MR1 OAS1_0420_MR1 OAS1_0421_MR1 OAS1_0431_MR1 OAS1_0437_MR1 OAS1_0448_MR1 OAS1_0038_MR1 OAS1_0097_MR1 OAS1_0111_MR1 OAS1_0140_MR1 OAS1_0148_MR1 OAS1_0152_MR1 OAS1_0153_MR1 OAS1_0174_MR1 OAS1_0193_MR1 OAS1_0202_MR1 OAS1_0346_MR1 OAS1_0370_MR1 OAS1_0410_MR1 OAS1_0416_MR1 OAS1_0435_MR1 OAS1_0442_MR1 OAS1_0006_MR1 OAS1_0025_MR1 OAS1_0051_MR1 OAS1_0104_MR1 OAS1_0131_MR1 OAS1_0136_MR1 OAS1_0141_MR1 OAS1_0264_MR1 OAS1_0392_MR1 OAS1_0079_MR1 OAS1_0080_MR1 OAS1_0108_MR1 OAS1_0117_MR1 OAS1_0147_MR1 OAS1_0151_MR1 OAS1_0377_MR1 OAS1_0396_MR1 OAS1_0406_MR1 OAS1_0413_MR1 OAS1_0121_MR1 OAS1_0218_MR1 OAS1_0227_MR1 OAS1_0333_MR1 OAS1_0386_MR1 OAS1_0387_MR1 OAS1_0395_MR1 OAS1_0037_MR1 OAS1_0314_MR1 OAS1_0325_MR1 OAS1_0004_MR1 OAS1_0095_MR1 OAS1_0249_MR1 OAS1_0261_MR1 OAS1_0281_MR1 OAS1_0296_MR1 OAS1_0045_MR1 OAS1_0101_MR1 OAS1_0239_MR1)

declare -a stepList=(orig acpc n4bc n4ss fs)

c=0; for i in Run{1..5}; do
    runList[$c]=$i
    let c=$[$c+1]
done

c=0; for i in scan{1..3}; do
    scanList[$c]=$i
    let c=$[$c+1]
done


### build dir hierarchy
cd $workDir

for i in ${runList[@]}; do
mkdir $i
cd $i

    for j in ${dataList[@]}; do
    tmp=${j#*_}
    subj=s${tmp%_*}
    mkdir $subj
    cd $subj

        if [ $i == Run1 ]; then
            for a in ${stepList[@]}; do
                for b in ${scanList[@]}; do
                    mkdir -p ${a}/${b}
                done
            done
        else
            for k in ${stepList[@]}; do
                mkdir $k
            done
        fi

    cd ${workDir}/$i
    done

cd $workDir
done


### get data, organize
cd $dataPar

for a in disc*; do
cd $a

    for b in OAS*; do
        for c in ${!dataList[@]}; do
            if [[ $b == ${dataList[$c]} ]]; then

            tmp1=${dataList[$c]}
            tmp2=${tmp1#*_}
            subj=s${tmp2%_*}

                for i in ${runList[@]}; do

                    #for j in orig fs; do
                    for j in fs; do
                        if [ $i == Run1 ]; then

                            dest1=${workDir}/${i}/${subj}/${j}/scan1
                            dest2=${workDir}/${i}/${subj}/${j}/scan2
                            dest3=${workDir}/${i}/${subj}/${j}/scan3

                            file1=${b}/RAW/${b}_mpr-1_anon.*
                            file2=${b}/RAW/${b}_mpr-2_anon.*
                            file3=${b}/RAW/${b}_mpr-3_anon.*

                            cp $file1 $dest1
                            cp $file2 $dest2
                            cp $file3 $dest3

                        else
                            dest=${workDir}/${i}/${subj}/${j}
                            file=${b}/RAW/${b}_mpr-1_anon.*

                            cp $file $dest
                        fi
                    done
                done
            fi
        done
    done

cd $dataPar
done


### convert img to nii, mgz
cd $workDir

for i in ${runList[@]}; do
runDir=${workDir}/$i
cd $runDir

    for j in s*; do
    subjDir=${runDir}/$j
    cd $j

        for k in orig fs; do
        stepDir=${subjDir}/$k
        cd $k

            if [ $i == Run1 ]; then
                for a in ${scanList[@]}; do
                scanDir=${stepDir}/$a
                cd $a

                    if [ $k == orig ]; then
                        mri_convert *img struct_orig.nii.gz
                    else
                        fsOut=${scanDir}/mri/orig
                        mkdir -p $fsOut
                        mri_convert *.img ${fsOut}/001.mgz
                    fi

                cd $stepDir
                done

            else
                if [ $k == orig ]; then
                    mri_convert *img struct_orig.nii.gz
                else
                    fsOut=${stepDir}/mri/orig
                    mkdir -p $fsOut
                    mri_convert *.img ${fsOut}/001.mgz
                fi
            fi

        cd $subjDir
        done

    cd $runDir
    done

cd $workDir
done













