#!/bin/bash

#SBATCH --time=05:00:00   # walltime
#SBATCH --ntasks=4   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=8gb   # memory per CPU core
#SBATCH -J "ppTabe"   # job name

# Compatibility variables for PBS. Delete if not needed.
export PBS_NODEFILE=`/fslapps/fslutils/generate_pbs_nodefile`
export PBS_JOBID=$SLURM_JOB_ID
export PBS_O_WORKDIR="$SLURM_SUBMIT_DIR"
export PBS_QUEUE=batch

# Set the max number of threads to use for programs using OpenMP. Should be <= ppn. Does nothing if the program doesn't use OpenMP.
export OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE


cd $1

mov=$2
tempDir=$3
dim=3
out=ss_
subj=${2%_*}

fixed=${tempDir}/T_template0.nii.gz
mask=${tempDir}/T_template0_BrainCerebellumMask.nii.gz

antsBrainExtraction.sh -d $dim -a $mov -e $fixed -m $mask -o $out

cp ss_BrainExtractionBrain.nii.gz ${subj}_brain.nii.gz
