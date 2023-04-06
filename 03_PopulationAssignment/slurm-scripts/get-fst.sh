#!/bin/bash
#set a job name
#SBATCH --job-name=angsd-fst
#SBATCH --output=./err-out/angsd-fst.%A_%a.out
#SBATCH --error=./err-out/angsd-fst.%A_%a.err
################
#################
#SBATCH --ntasks=1
#SBATCH --array=1-10
#################


# saf-array.txt
# ex. amre.training.Newfoundland.ds_2x.sites-filter.saf.idx
saf1=$(awk -v N=$SLURM_ARRAY_TASK_ID 'NR == N {print $1}' saf-array.txt)
region1=$(echo ${saf1} | cut -f3 -d.)

# ex. amre.training.Newfoundland.ds_2x.sites-filter.saf.idx
saf2=$(awk -v N=$SLURM_ARRAY_TASK_ID 'NR == N {print $2}' saf-array.txt)
region2=$(echo ${saf2} | cut -f3 -d.)

saf_dir=/home/mgdesaix/projects/AMRE/snp_screening/saf
sfs_dir=/home/mgdesaix/projects/AMRE/snp_screening/2dsfs
outname=amre.training.${region1}.${region2}.ds_2x.sites-filter
angsd_dir=/home/mgdesaix/programs/angsd

fst_dir=/home/mgdesaix/projects/AMRE/snp_screening/fst

# get 2dsfs
${angsd_dir}/misc/realSFS ${saf_dir}/${saf1} ${saf_dir}/${saf2} -maxIter 1000 -P 8 > ${newout}

# get fst
${angsd_dir}/misc/realSFS fst index ${saf_dir}/${saf1} ${saf_dir}/${saf2} -sfs ${sfs_dir}/${outname}.ml -whichFst 1 -fstout ${fst_dir}/${outname}

### Getting individual locus Fst stuff
# ${angsd_dir}/misc/realSFS fst print ${fst_dir}/${outname}.fst.idx > ${fst_dir}/${outname}.fst

# just report Fsts > 0 to minimize file size
# awk '$4 != 0 {print $1, $2, $3/$4}' ${fst_dir}/${outname}.fst | awk '$3 > 0 {print}' | sort -k3 -rg > ${fst_dir}/summaries/${outname}.gt0.fst


