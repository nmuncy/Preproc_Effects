# Preproc_Effects
Hosted scripts for building templates and template priors, pre-processing data, extracting ROI volumes, and running a tensor-based morphometric analysis.

Basic Notes: 
1) Scripts that start with "MT" are used for creating a template.
2) Scripts that start with "PP" are used in the pre-processing pipeline.
3) Scripts are numbered (e.g. *_1.sh, *_2.sh) to indicate their respective step in the pipeline. 
4) Sbatch scripts are written for a slurm environment, and are wrapped with submit_sbatch scripts.
