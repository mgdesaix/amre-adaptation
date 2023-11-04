#!/bin/bash
#set a job name
#SBATCH --job-name=pcangsd-array
#SBATCH --output=./err-out/pcangsd-array.%A_%a.out
#SBATCH --error=./err-out/pcangsd-array.%A_%a.err
################
#SBATCH --time=2:00:00
#################
# Note: 3.74G/core or task
#################
#SBATCH --ntasks=4
#SBATCH --array=1-6
#################

source ~/.bashrc
conda activate pcangsd

N=$SLURM_ARRAY_TASK_ID

prefix=amre.breeding_169.ind313.filtered.2x.LDpruned
beagle=~/scratch/AMRE/angsd/full/${prefix}.beagle.gz

# produce basic covariance matrix first time

if [[ N -eq 1 ]]
then
    pcangsd --beagle ${beagle} --out ./out/${prefix} --threads 4
fi

# run admixture
pcangsd --beagle ${beagle} --out ./out/${prefix}.eigen.${N} --threads 4 --admix --n_eig ${N}



