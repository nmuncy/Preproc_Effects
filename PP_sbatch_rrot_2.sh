#!/bin/bash

# written by Nathan Muncy on 8/11/17

#SBATCH --time=01:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=8gb   # memory per CPU core
#SBATCH -J "ppACPC"   # job name

# Compatibility variables for PBS. Delete if not needed.
export PBS_NODEFILE=`/fslapps/fslutils/generate_pbs_nodefile`
export PBS_JOBID=$SLURM_JOB_ID
export PBS_O_WORKDIR="$SLURM_SUBMIT_DIR"
export PBS_QUEUE=batch

# Set the max number of threads to use for programs using OpenMP. Should be <= ppn. Does nothing if the program doesn't use OpenMP.
export OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE



workDir=$1
tempDir=$2

DoRigid.Function() {
    dim=3
    fix=$2
    mov=$1
    trans=r
    out=struct_acpc

    antsRegistrationSyNQuick.sh \
    -d $dim \
    -f $fix \
    -m $mov \
    -t $trans \
    -o $out

    cp ${out}Warped.nii.gz struct_acpc.nii.gz
    rm struct_orig.nii.gz
}




cd $workDir

DoRigid.Function struct_orig.nii.gz ${tempDir}/PreProc_head_template.nii.gz


