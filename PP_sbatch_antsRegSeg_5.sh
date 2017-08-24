#!/bin/bash

# written by Nathan Muncy on 8/11/17

#SBATCH --time=05:00:00   # walltime
#SBATCH --ntasks=2   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=8gb   # memory per CPU core
#SBATCH -J "PPants"   # job name

# Compatibility variables for PBS. Delete if not needed.
export PBS_NODEFILE=`/fslapps/fslutils/generate_pbs_nodefile`
export PBS_JOBID=$SLURM_JOB_ID
export PBS_O_WORKDIR="$SLURM_SUBMIT_DIR"
export PBS_QUEUE=batch

# Set the max number of threads to use for programs using OpenMP. Should be <= ppn. Does nothing if the program doesn't use OpenMP.
export OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE



### passed variables
workDir=$1
scan=$2
template=$3
priorDir=$4


### functions
DoANTs.Function() {

    MOV=$1
    FIX=$2

    OUT=ants_
    ITS=100x100x100x20
    DIM=3
    INTENSITY=CC[${FIX},${MOV},4,4]

    ${ANTSPATH}/ANTS \
    $DIM \
    -o $OUT \
    -i $ITS \
    -t SyN[0.1] \
    -r Gauss[3,0.5] \
    -m $INTENSITY

}



DoSeg.Function() {

    mov=$1
    prior=$2
    output=$3

    dim=3
    out=ants_

    WarpImageMultiTransform \
    $dim \
    $prior \
    $output \
    -i ${out}Affine.txt \
    ${out}InverseWarp.nii.gz \
    -R $mov \
    --use-NN

}



### arrays
c=0; for i in 0012 0051 0017 0053 1015 2015; do
    ROI[$c]=label_${i}.nii.gz
    let c=$[$c+1]
done

arrLen="${#ROI[@]}"



### work
cd $workDir

#DoANTs.Function $scan $template

count=0
while [ $count -lt $arrLen ]; do
    DoSeg.Function $scan ${priorDir}/${ROI[$count]} ${ROI[$count]}
    let count=$[$count+1]
done












