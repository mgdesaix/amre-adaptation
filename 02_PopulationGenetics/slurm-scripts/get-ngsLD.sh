#!/bin/bash
#set a job name
#SBATCH --job-name=ngsLD-mem
#SBATCH --output=./err-out/ngsLD-mem.%j.out
#SBATCH --error=./err-out/ngsLD-mem.%j.err
################
#SBATCH --time=24:00:00
#SBATCH --qos=mem
#SBATCH --partition=amem
#################
# Note: 16G/core or task
#################
#SBATCH --ntasks=24
#SBATCH --mem=380GB
#################

# source ~/.bashrc
# conda activate /projects/mgdesaix@colostate.edu/miniconda3/envs/bioinf

# link to executable
ngsLD=/projects/mgdesaix@colostate.edu/programs/ngsLD/ngsLD

pos=/home/mgdesaix@colostate.edu/scratch/AMRE/angsd/full/amre.ind313.filtered.2x.scaff4ngsLD.gz
geno=/home/mgdesaix@colostate.edu/scratch/AMRE/angsd/full/amre.breeding_169.ind313.filtered.2x.beagle4ngsLD.gz

# run the code
outdir=/home/mgdesaix@colostate.edu/scratch/AMRE/angsd/full/ld-prune/out
outname=amre.breeding_169.ind313.filtered.2x.50k.ld

${ngsLD} --geno ${geno} --pos ${pos} --probs --n_ind 169 --n_sites 4867951 --max_kb_dist 50 --n_threads 24 --out ${outdir}/${outname}

