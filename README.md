# Preproc_Effects
Hosted scripts for building templates and template priors, pre-processing data, extracting ROI volumes, and running a tensor-based morphometric analysis.

Basic Notes: 
1) Scripts that start with "MT" are used for creating a template.
2) Scripts that start with "PP" are used in the pre-processing pipeline.
3) Scripts are numbered (e.g. *_1.sh, *_2.sh) to indicate their respective step in the pipeline. 
4) Sbatch scripts are written for a slurm environment, and are wrapped with submit_sbatch scripts.

Citation: 
Muncy NM, Hedges-Muncy AM, Kirwan CB (2017) Discrete pre-processing step effects in registration-based pipelines, 
  a preliminary volumetric study on T1-weighted images. PLOS ONE 12(10): e0186071. https://doi.org/10.1371/journal.pone.0186071
