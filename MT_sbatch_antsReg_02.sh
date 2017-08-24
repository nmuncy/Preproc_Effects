#!/bin/bash

#SBATCH --time=05:00:00   # walltime
#SBATCH --ntasks=4   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=8gb   # memory per CPU core
#SBATCH -J "mniV2ants"   # job name

# Compatibility variables for PBS. Delete if not needed.
export PBS_NODEFILE=`/fslapps/fslutils/generate_pbs_nodefile`
export PBS_JOBID=$SLURM_JOB_ID
export PBS_O_WORKDIR="$SLURM_SUBMIT_DIR"
export PBS_QUEUE=batch

# Set the max number of threads to use for programs using OpenMP. Should be <= ppn. Does nothing if the program doesn't use OpenMP.
export OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE




cd $1

FIX=$3
MOV=$2
OUT=ants_
subj=${2%_*}

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


WarpImageMultiTransform $DIM $MOV ${subj}_mni.nii.gz ${OUT}Warp.nii.gz ${OUT}Affine.txt -R $FIX
