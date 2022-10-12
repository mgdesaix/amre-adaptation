#!/bin/bash
#set a job name
#SBATCH --job-name=cut-beagle
#SBATCH --output=./err-out/cut-beagle.%A_%a.out
#SBATCH --error=./err-out/cut-beagle.%A_%a.err
################
#################
#SBATCH --ntasks=1
#SBATCH --array=1-9
#################


# ex. amre.training.all.top_10000_each.sites
input_sites=$(awk -v N=$SLURM_ARRAY_TASK_ID 'NR == N {print $1}' amre-sites-array.txt)

n=$(echo ${input_sites} | cut -f4 -d.)

sites_dir=/home/mgdesaix/projects/AMRE/snp_screening/fst/sub/summary
snps=${sites_dir}/${input_sites}
# paste chr and pos to match beagle
awk '{print $1"_"$2}' ${snps} > ${snps}.pasted


input_beagle=/home/mgdesaix/projects/AMRE/beagle/sites-filter/out-nobadPA/amre.all.nobadPA.ds_x2.0.ind317.sites.beagle.gz

outname=amre.nonbreeding.ind148.ds_2x.sites-filter.${n}.beagle.gz

# the awk code I can never remember
# also cutting the original beagle file to only include the nonbreeding individuals:
# for the 317 ind file, the first 169 individuals are breeding and the remaining are nonbreeding
awk 'NR==FNR{c[$1]++;next};c[$1]' ${snps}.pasted <(zcat ${input_beagle}) | cut -f1-3,511- | gzip > ./nonbreeding-beagle/${outname}
