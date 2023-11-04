#!/bin/bash
#set a job name
#SBATCH --job-name=angsd-beagle-array
#SBATCH --output=./err-out/angsd-beagle-array.%A_%a.out
#SBATCH --error=./err-out/angsd-beagle-array.%A_%a.err
################
#SBATCH --time=12:00:00
#################
# Note: 3.74G/core or task
#################
#SBATCH --mem=32G
#SBATCH --array=401-566
#################

source ~/.bashrc
conda activate angsd

site=$(awk -v N=$SLURM_ARRAY_TASK_ID 'NR == N {print $1}' ./data/interval2mb-sites-rf-id-array.txt)
# /projects/mgdesaix@colostate.edu/reference/YWAR/intervals/angsd/sites/interval2mb_001.sites.txt
rf=$(awk -v N=$SLURM_ARRAY_TASK_ID 'NR == N {print $2}' ./data/interval2mb-sites-rf-id-array.txt)
# /projects/mgdesaix@colostate.edu/reference/YWAR/intervals/angsd/rf/interval2mb_001.rf.txt
interval=$(awk -v N=$SLURM_ARRAY_TASK_ID 'NR == N {print $3}' ./data/interval2mb-sites-rf-id-array.txt)
# 001

reference=/projects/mgdesaix@colostate.edu/reference/YWAR/YWAR.fa

input_bams=./data/amre.adaptation.ind313.2x_path.txt
outdir=./intervals
outname=amre.ind313.filtered.2x_${interval}

# 313 individuals unrelated all
# thus ~50% missing is 160 ind
# average of 1.6x coverage, thus min depth = 250, max depth is 1000
angsd -b ${input_bams} -out ${outdir}/${outname} -gl 2 -domajorminor 1 \
 -snp_pval 1e-6 -domaf 1 -minmaf 0.05 -doGlf 2 -baq 1 \
 -ref ${reference} -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 1 -trim 0 -C 50 \
 -minMapQ 30 -minQ 33 -minInd 160 -setMinDepth 250 -setMaxDepth 1000 -doCounts 1 -nThreads 8 \
 -sites ${site} -rf ${rf}
