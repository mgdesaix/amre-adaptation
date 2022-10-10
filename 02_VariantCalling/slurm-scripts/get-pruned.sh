#!/bin/bash
#set a job name
#SBATCH --job-name=prune-ld
#SBATCH --output=./err-out/prune.%j.out
#SBATCH --error=./err-out/prune.%j.err
################
#SBATCH --time=144:00:00
#SBATCH --qos=long
#SBATCH --partition=shas
#################
# Note: 4.84G/core or task
#################
#SBATCH --mem=100G
#################

source ~/.bashrc
conda activate ngsLD


# link to ngsld dir
ngsLD=/projects/mgdesaix@colostate.edu/programs/ngsLD

# run the code
infile=/home/mgdesaix@colostate.edu/scratch/AMRE/all-samples/angsd/ld/out/amre.all.no-relate.ind325.missing50.maf05.10k.ld
outfile=/home/mgdesaix@colostate.edu/scratch/AMRE/all-samples/angsd/ld/out/amre.all.no-relate.ind325.missing50.maf05.10k.r05.LONG.id

# run perl script

perl ${ngsLD}/scripts/prune_graph.pl --in_file ${infile} --max_kb_dist 10 --min_weight 0.5 --out ${outfile}
