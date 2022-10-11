#!/bin/bash
#set a job name
#SBATCH --job-name=downsampling
#SBATCH --output=./err-out/downsampling.%A_%a.out
#SBATCH --error=./err-out/downsampling.%A_%a.err
################
#SBATCH --time=24:00:00
#SBATCH --qos=normal
#SBATCH --partition=shas
#################
# Note: 4.84G/core or task
#################
#SBATCH --array=1-613
#################

source ~/.bashrc
conda activate gatk4

set -x 

bam=$(awk -v N=$SLURM_ARRAY_TASK_ID 'NR == N {print $1}' downsampling-array-full.txt)
# 20N002019.bam
cov=$(awk -v N=$SLURM_ARRAY_TASK_ID 'NR == N {print $2}' downsampling-array-full.txt)
# x2.0
p=$(awk -v N=$SLURM_ARRAY_TASK_ID 'NR == N {print $3}' downsampling-array-full.txt)
# 0.23

picard=/projects/mgdesaix@colostate.edu/programs/picard.jar

input=/home/mgdesaix@colostate.edu/scratch/AMRE/all-samples/bamfiles/xfull/${bam}
output=/home/mgdesaix@colostate.edu/scratch/AMRE/all-samples/bamfiles/${cov}/${bam}

java -jar ${picard} DownsampleSam I=${input} O=${output} P=${p} VALIDATION_STRINGENCY=SILENT
samtools index ${output}

# mkdir -p ./${cov}/depth

# depth=$(samtools depth -a ${output} | awk '{sum+=$3} END { print "Average = ",sum/NR}')
# echo ${bam} ${depth} >> ${cov}/depth/${cov}.depth.txt
