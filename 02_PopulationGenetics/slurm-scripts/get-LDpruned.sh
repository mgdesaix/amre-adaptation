#!/bin/bash
#set a job name
#SBATCH --job-name=prune-ld
#SBATCH --output=./err-out/prune.%j.out
#SBATCH --error=./err-out/prune.%j.err
################
#SBATCH --time=4:00:00
#SBATCH --qos=normal
#SBATCH --partition=amilan
#################
# Note: 3.74G/core or task
#################
#SBATCH --mem=50G
#################

source ~/.bashrc
conda activate ngsLD


# link to ngsld dir
prune_graph=/projects/mgdesaix@colostate.edu/programs/prune_graph/target/release/prune_graph

# run the code
infile=/home/mgdesaix@colostate.edu/scratch/AMRE/angsd/full/ld-prune/out/amre.breeding_169.ind313.filtered.2x.50k.ld

outfile=/home/mgdesaix@colostate.edu/scratch/AMRE/angsd/full/ld-prune/out/amre.breeding_169.ind313.filtered.2x.50k.ld.r05.pruned.id

# run prune_graph

${prune_graph} --in ${infile} --weight-field column_7 --weight-filter "column_7 >= 0.5" --out ${outfile} --verbose



