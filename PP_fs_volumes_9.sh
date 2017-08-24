#!/bin/bash

# written by Nathan Muncy on 8/11/17


### Variables
workDir=/Volumes/Yorick/PreProc_Methods
oasisDir=${workDir}/Oasis
outDir=${workDir}/analysis/vol
outDir2=${workDir}/analysis/brain_vol
outDir3=${workDir}/analysis/oasis_fs


### Arrays
c=0; for i in Run{1..5}; do
    runList[$c]=$i
    let c=$[$c+1]
done

c=0; for i in scan{1..3}; do
    scanList[$c]=$i
    let c=$[$c+1]
done

declare -a dataList=(OAS1_0009_MR1 OAS1_0049_MR1 OAS1_0055_MR1 OAS1_0059_MR1 OAS1_0061_MR1 OAS1_0077_MR1 OAS1_0090_MR1 OAS1_0105_MR1 OAS1_0107_MR1 OAS1_0150_MR1 OAS1_0156_MR1 OAS1_0162_MR1 OAS1_0211_MR1 OAS1_0231_MR1 OAS1_0236_MR1 OAS1_0253_MR1 OAS1_0285_MR1 OAS1_0294_MR1 OAS1_0295_MR1 OAS1_0310_MR1 OAS1_0313_MR1 OAS1_0344_MR1 OAS1_0361_MR1 OAS1_0379_MR1 OAS1_0397_MR1 OAS1_0007_MR1 OAS1_0017_MR1 OAS1_0029_MR1 OAS1_0043_MR1 OAS1_0054_MR1 OAS1_0057_MR1 OAS1_0087_MR1 OAS1_0126_MR1 OAS1_0191_MR1 OAS1_0198_MR1 OAS1_0250_MR1 OAS1_0258_MR1 OAS1_0350_MR1 OAS1_0359_MR1 OAS1_0415_MR1 OAS1_0419_MR1 OAS1_0439_MR1 OAS1_0092_MR1 OAS1_0125_MR1 OAS1_0132_MR1 OAS1_0144_MR1 OAS1_0189_MR1 OAS1_0209_MR1 OAS1_0224_MR1 OAS1_0232_MR1 OAS1_0246_MR1 OAS1_0277_MR1 OAS1_0302_MR1 OAS1_0311_MR1 OAS1_0348_MR1 OAS1_0353_MR1 OAS1_0368_MR1 OAS1_0385_MR1 OAS1_0394_MR1 OAS1_0408_MR1 OAS1_0420_MR1 OAS1_0421_MR1 OAS1_0431_MR1 OAS1_0437_MR1 OAS1_0448_MR1 OAS1_0038_MR1 OAS1_0097_MR1 OAS1_0111_MR1 OAS1_0140_MR1 OAS1_0148_MR1 OAS1_0152_MR1 OAS1_0153_MR1 OAS1_0174_MR1 OAS1_0193_MR1 OAS1_0202_MR1 OAS1_0346_MR1 OAS1_0370_MR1 OAS1_0410_MR1 OAS1_0416_MR1 OAS1_0435_MR1 OAS1_0442_MR1 OAS1_0006_MR1 OAS1_0025_MR1 OAS1_0051_MR1 OAS1_0104_MR1 OAS1_0131_MR1 OAS1_0136_MR1 OAS1_0141_MR1 OAS1_0264_MR1 OAS1_0392_MR1 OAS1_0079_MR1 OAS1_0080_MR1 OAS1_0108_MR1 OAS1_0117_MR1 OAS1_0147_MR1 OAS1_0151_MR1 OAS1_0377_MR1 OAS1_0396_MR1 OAS1_0406_MR1 OAS1_0413_MR1 OAS1_0121_MR1 OAS1_0218_MR1 OAS1_0227_MR1 OAS1_0333_MR1 OAS1_0386_MR1 OAS1_0387_MR1 OAS1_0395_MR1 OAS1_0037_MR1 OAS1_0314_MR1 OAS1_0325_MR1 OAS1_0004_MR1 OAS1_0095_MR1 OAS1_0249_MR1 OAS1_0261_MR1 OAS1_0281_MR1 OAS1_0296_MR1 OAS1_0045_MR1 OAS1_0101_MR1 OAS1_0239_MR1)


### Output
mkdir $outDir2
mkdir $outDir3

> ${outDir2}/BV_fs.txt
> ${outDir2}/BV_rescan_fs.txt

> ${outDir3}/ROI_fs.txt
> ${outDir3}/BV_fs.txt

for a in ${runList[@]}; do
    if [ $a == Run1 ]; then
        > ${outDir}/${a}_fs.txt
        > ${outDir}/${a}_rescan_fs.txt
    else
        > ${outDir}/${a}_fs.txt
    fi
done



### Function
FSvol.Function() {

    num=$#

    subj=$1
    dataS=$2
    dataL=$3
    dataR=$4
    print1=$5
    print2=$6
    run=$7

    if [[ $num == 8 ]]; then
        scan=$8
    fi

    FSdata[0]=`cat $dataS | grep "Left-Hippocampus"`
    FSdata[1]=`cat $dataS | grep "Right-Hippocampus"`
    FSdata[2]=`cat $dataS | grep "Left-Putamen"`
    FSdata[3]=`cat $dataS | grep "Right-Putamen"`
    FSdata[4]=`cat $dataL | grep "middletemporal"`
    FSdata[5]=`cat $dataR | grep "middletemporal"`
    BV=`cat $dataS | grep "Measure BrainSeg, BrainSegVol, Brain Segmentation Volume,"`

    length=${#FSdata[@]}

    if [[ $num > 7 ]]; then
        echo "$subj $scan" >> $print1
    else
        echo "$subj" >> $print1
    fi

    echo "$run $subj $BV" >> $print2
    c=0; while [ $c -lt $length ]; do
        echo "${FSdata[$c]}" >> $print1
        let c=$[$c+1]
    done
}




### Work
# get data
cd $workDir

for i in ${runList[@]}; do
runDir=${workDir}/$i
cd $i

    for j in s*; do
    subjDir=${runDir}/$j
    fsDir=${subjDir}/fs

        if [ $i != Run1 ]; then

            dataDir=${fsDir}/stats
            print=${outDir}/${i}_fs.txt
            print2=${outDir2}/BV_fs.txt

            dataS=${dataDir}/aseg.stats
            dataL=${dataDir}/lh.aparc.DKTatlas.stats
            dataR=${dataDir}/rh.aparc.DKTatlas.stats

            FSvol.Function $j $dataS $dataL $dataR $print $print2 $i

        else
            cd $subjDir

            for m in ${scanList[@]}; do
            scanDir=${fsDir}/$m
            cd $scanDir

                dataDir=${scanDir}/stats

                dataS=${dataDir}/aseg.stats
                dataL=${dataDir}/lh.aparc.DKTatlas.stats
                dataR=${dataDir}/rh.aparc.DKTatlas.stats

                if [ $m == scan1 ]; then

                    print=${outDir}/${i}_fs.txt
                    print2=${outDir2}/BV_fs.txt

                    FSvol.Function $j $dataS $dataL $dataR $print $print2 $i

                fi

                print=${outDir}/${i}_rescan_fs.txt
                print2=${outDir2}/BV_rescan_fs.txt

                FSvol.Function $j $dataS $dataL $dataR $print $print2 $i $m

            cd $subjDir
            done
        fi
    done

cd $workDir
done


# clean BV data
cd $outDir2

for i in BV_*fs.txt; do

    sed 's/,//g' $i > tmp1
    sed 's/://g' tmp1 > tmp2
    cp tmp2 $i
    rm tmp*

done


# get Oasis values
cd $oasisDir

for a in disc*; do
discDir=${oasisDir}/$a
cd $a

    for b in OAS*; do
        for c in ${!dataList[@]}; do
            if [[ $b == ${dataList[$c]} ]]; then

                tmp1=${dataList[$c]}
                tmp2=${tmp1#*_}
                subj=s${tmp2%_*}

                dataDir=${discDir}/${b}/stats
                print=${outDir3}/ROI_fs.txt
                print2=${outDir3}/BV_fs.txt

                dataS=${dataDir}/aseg.stats
                dataL=${dataDir}/lh.aparc.stats
                dataR=${dataDir}/rh.aparc.stats

                FSvol.Function $subj $dataS $dataL $dataR $print $print2

            fi
        done
    done

cd $oasisDir
done




































