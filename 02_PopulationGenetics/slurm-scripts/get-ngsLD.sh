#!/bin/bash
#set a job name
#SBATCH --job-name=ngsLD-mem
#SBATCH --output=./err-out/ngsLD-mem.%j.out
#SBATCH --error=./err-out/ngsLD-mem.%j.err
################
#SBATCH --time=24:00:00
#SBATCH --qos=normal
#SBATCH --partition=smem
#################
# Note: 4.84G/core or task
#################
#SBATCH --ntasks=24
#SBATCH --mem=1000GB
#################

# source ~/.bashrc
# conda activate /projects/mgdesaix@colostate.edu/miniconda3/envs/bioinf

# link to executable
ngsLD=/projects/mgdesaix@colostate.edu/programs/ngsLD/ngsLD

pos=/home/mgdesaix@colostate.edu/scratch/AMRE/all-samples/angsd/ld/data/amre.all.no-relate.ind325.missing50.maf05.pos.gz
geno=/home/mgdesaix@colostate.edu/scratch/AMRE/all-samples/angsd/ld/data/amre.all.no-relate.ind325.missing50.maf05.snps4ngsLD.gz

# run the code
outdir=/home/mgdesaix@colostate.edu/scratch/AMRE/all-samples/angsd/ld/out
outname=amre.all.no-relate.ind325.missing50.maf05.10k.ld

${ngsLD} --geno ${geno} --pos ${pos} --probs --n_ind 325 --n_sites 8896381 --max_kb_dist 10 --n_threads 24 --out ${outdir}/${outname}
