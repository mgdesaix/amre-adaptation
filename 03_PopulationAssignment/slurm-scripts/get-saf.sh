#!/bin/bash
#set a job name
#SBATCH --job-name=angsd-saf
#SBATCH --output=./err-out/angsd-saf.%A_%a.out
#SBATCH --error=./err-out/angsd-saf.%A_%a.err
################
#################
#SBATCH --ntasks=8
#SBATCH --array=1-5
#################


# all-training-bam-array.txt
# ex. lists/training_Newfoundland.txt
input_bams=$(awk -v N=$SLURM_ARRAY_TASK_ID 'NR == N {print $1}' all-training-bam-array.txt)
region=$(echo ${input_bams} | cut -f2 -d_ | sed 's/.txt//')

outdir=/home/mgdesaix/projects/AMRE/snp_screening/saf
outname=amre.training.${region}.ds_2x.sites-filter

chrs=/home/mgdesaix/projects/AMRE/beagle/sites-filter/sites/amre.all.norelate.ind325.missing50.maf05.ldpruned_snps.chrs.sorted.txt
sites=/home/mgdesaix/projects/AMRE/beagle/sites-filter/sites/amre.all.norelate.ind325.missing50.maf05.ldpruned_snps.list


reference=/home/mgdesaix/reference/YWAR/YWAR.fa
# Trying to do sites and chromosome filter
# just doing site allele frequency here!
angsd_dir=/home/mgdesaix/programs/angsd
${angsd_dir}/angsd -b ${input_bams} -out ${outdir}/${outname} \
            -gl 2 -domajorminor 3 -dosaf 1 -anc ${reference} \
            -rf ${chrs} -sites ${sites} -nThreads 8
