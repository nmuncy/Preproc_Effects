#!/bin/bash

# written by Nathan Muncy on 8/11/17

#SBATCH --time=05:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=8gb   # memory per CPU core
#SBATCH -J "ppABE"   # job name

# Compatibility variables for PBS. Delete if not needed.
export PBS_NODEFILE=`/fslapps/fslutils/generate_pbs_nodefile`
export PBS_JOBID=$SLURM_JOB_ID
export PBS_O_WORKDIR="$SLURM_SUBMIT_DIR"
export PBS_QUEUE=batch

# Set the max number of threads to use for programs using OpenMP. Should be <= ppn. Does nothing if the program doesn't use OpenMP.
export OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE



workDir=$1
tempDir=$2
priorDir=${tempDir}/priors_ACT

DoABE.Function() {
    dim=3
    struct=$1
    temp=$2
    mask=${priorDir}/Template_BrainCerebellumBinaryMask.nii.gz
    out=ss_

    antsBrainExtraction.sh -d $dim -a $struct -e $temp -m $mask -o $out
    cp ss_BrainExtractionBrain.nii.gz struct_n4ss.nii.gz
}


cd $workDir

DoABE.Function struct_acpc.nii.gz ${tempDir}/PreProc_head_template.nii.gz

