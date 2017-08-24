#!/bin/bash

# written by Nathan Muncy on 8/11/17

#SBATCH --time=01:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=4gb   # memory per CPU core
#SBATCH -J "ppN4BC"   # job name

# Compatibility variables for PBS. Delete if not needed.
export PBS_NODEFILE=`/fslapps/fslutils/generate_pbs_nodefile`
export PBS_JOBID=$SLURM_JOB_ID
export PBS_O_WORKDIR="$SLURM_SUBMIT_DIR"
export PBS_QUEUE=batch

# Set the max number of threads to use for programs using OpenMP. Should be <= ppn. Does nothing if the program doesn't use OpenMP.
export OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE



workDir=$1

DoN4BC.Function() {
    dim=3
    input=$1
    output=struct_n4bc.nii.gz

    con=[50x50x50x50,0.0000001]
    shrink=4
    bspline=[200]


    N4BiasFieldCorrection \
    -d $dim \
    -i $input \
    -s $shrink \
    -c $con \
    -b $bspline \
    -o $output

    rm struct_acpc.nii.gz
}


cd $workDir

DoN4BC.Function struct_acpc.nii.gz


