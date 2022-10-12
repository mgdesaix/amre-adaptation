#!/bin/bash
#set a job name
#SBATCH --job-name=summarize
#SBATCH --output=./err-out/summarize.%A_%a.out
#SBATCH --error=./err-out/summarize.%A_%a.err
################
#################
#SBATCH --ntasks=1
#SBATCH --array=1-9
#################


n=$(awk -v N=$SLURM_ARRAY_TASK_ID 'NR == N {print $1}' head-array.txt)

name=amre.training.all.top_${n}_each
head -n ${n} *.gt0.fst | grep "scaffold" | awk '{print $1"_"$2}' | sort | uniq > ./summary/${name}.tmp

cd ./summary/

cut -f1 -d"|" ${name}.tmp | sed 's/scaffold//' > ${name}.scaff
cut -f2 -d"_" ${name}.tmp > ${name}.pos
paste ${name}.scaff ${name}.pos ${name}.tmp | sort -k1,1n -k2,2n | cut -f3 | sed 's/_/\t/' > ${name}.sites

rm ${name}.scaff
rm ${name}.pos
rm ${name}.tmp
