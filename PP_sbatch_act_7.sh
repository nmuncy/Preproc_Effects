#!/bin/bash

# written by Nathan Muncy on 8/11/17

#SBATCH --time=15:00:00   # walltime
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


### functions
DoACT.Function() {

    struct=$1

    tempDir=~/compute/PreProc_Methods/Template
    priorDir=${tempDir}/priors_ACT
    tempH=${tempDir}/PreProc_head_template.nii.gz
    tempB=${tempDir}/PreProc_brain_template.nii.gz
    pmask=${priorDir}/Template_BrainCerebellumProbabilityMask.nii.gz
    emask=${priorDir}/Template_BrainCerebellumExtractionMask.nii.gz
    out=act_

    antsCorticalThickness.sh \
    -d 3 \
    -a $struct \
    -e $tempH \
    -t $tempB \
    -m $pmask \
    -f $emask \
    -p ${priorDir}/Prior%d.nii.gz \
    -o $out

}


cd $workDir

DoACT.Function $scan



