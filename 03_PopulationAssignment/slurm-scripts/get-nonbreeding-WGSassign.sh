#!/bin/bash
#set a job name
#SBATCH --job-name=WGSassign
#SBATCH --output=./err-out/WGSassign.%A_%a.out
#SBATCH --error=./err-out/WGSassign.%A_%a.err
################
#SBATCH --time=24:00:00
#################
# Note: 4.84G/core or task
#################
#SBATCH --ntasks=20
#SBATCH --array=1-9
#################
source /home/mgdesaix/mambaforge/etc/profile.d/conda.sh

## Run assignment
conda activate WGSassign
# 1) Nonbreeding beagle file
# ex. nonbreeding-beagle/amre.nonbreeding.ind148.ds_2x.sites-filter.top_100000_each.beagle.gz
nb_beagle=$(awk -v N=$SLURM_ARRAY_TASK_ID 'NR == N {print $1}' nbBeagle-and-refpopAF-array.txt)
n=$(echo ${nb_beagle} | cut -f3 -d_)
# 2) Reference pop alleles
# ex. ../testing-assignment/reference-out/amre.testing.ind85.ds_2x.sites-filter.top_100000_each.popAF.npy
ref_pop=$(awk -v N=$SLURM_ARRAY_TASK_ID 'NR == N {print $2}' nbBeagle-and-refpopAF-array.txt)

# Get likelihoods for leave-one-out assignment within known reference populations
# Output = 1) reference.popAF.npy, 2) reference.pop_like_LOO.txt
# WGSassign --beagle ${beagle_dir}/${input_beagle} --pop_af_IDs ${IDs} --get_reference_af --loo --out ./reference-out/${outname} --threads 20

outname=./nonbreeding-likelihood/amre.nonbreeding.ind148.ds_2x.sites-filter.top_${n}_each
# Estimate population assignment likelihoods
# Output = assign.pop_like.txt (text file of size N (individuals) rows x K (ref pops) columns)
WGSassign --beagle ${nb_beagle} --pop_af_file ${ref_pop} --get_pop_like --out ${outname} --threads 20
