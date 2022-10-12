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
# ex. amre.testing.ind85.ds_2x.sites-filter.top_100000_each.beagle.gz
input_beagle=$(awk -v N=$SLURM_ARRAY_TASK_ID 'NR == N {print $1}' testing-beagle-array.txt)
n=$(echo ${input_beagle} | cut -f6 -d.)
beagle_dir=/home/mgdesaix/projects/AMRE/snp_screening/testing-beagle
IDs=testing-ind85-reference-pop-IDs-k5.txt

outname=amre.testing.ind85.ds_2x.sites-filter.${n}
# Get likelihoods for leave-one-out assignment within known reference populations
# Output = 1) reference.popAF.npy, 2) reference.pop_like_LOO.txt
WGSassign --beagle ${beagle_dir}/${input_beagle} --pop_af_IDs ${IDs} --get_reference_af --loo --out ./reference-out ${outname} --threads 20

