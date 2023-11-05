# Population genetics analyses with low-coverage sequence data

In this study, we used the same samples from [DeSaix et al. 2023](https://onlinelibrary.wiley.com/doi/full/10.1111/mec.17137) that were downsampled to 2X sequencing coverage. We additionally removed individuals which had less than 0.1X coverage, resulting in 313 individual samples (169 from breeding range and 144 from the nonbreeding range). Here, are the steps we took for identifying SNPs and population genetic structure.

The software used here:

- ANGSD (0.940)

- NgsLD (1.2.0)

- PCangsd (1.2)

## Variant calling

Details on filtering options can be found on the [ANGSD site](http://www.popgen.dk/angsd/index.php/Input). Some filtering recommendations for low-coverage data can be found in a batch effects paper by [Lou et al. 2022](https://onlinelibrary.wiley.com/doi/full/10.1111/1755-0998.13559). I've found the recommendation in the paper of stringently filtering mapping quality (`-minMapQ 30`) and base quality (`-minQ 33`) to help some with mild library effects (that become apparent in a PCA). 

I use the full set of 313 individuals to identify an initial set of filtered SNPs (the full script used can be found here: [get-beagle-interval-array.sh](./slurm-scripts/get-beagle-interval-array.sh)):

```
angsd -b ${input_bams} -out ${outdir}/${outname} -gl 2 -domajorminor 1 \
 -snp_pval 1e-6 -domaf 1 -minmaf 0.05 -doGlf 2 -baq 1 \
 -ref ${reference} -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 1 -trim 0 -C 50 \
 -minMapQ 30 -minQ 33 -minInd 160 -setMinDepth 250 -setMaxDepth 1000 -doCounts 1 -nThreads 8 -sites ${site} -rf ${rf}
```

Some specific filters:

- `-minInd 160` sets calling only variants with ~50% of individuals
- `-setMinDepth 250` is based on 50% of the individuals and the average sequencing coverage of 1.6X (i.e. 250 ~ 1.6 x 160)
- `setMaxDepth 1000` is based on 2 times all the individuals and the average depth, to avoid sites overly sequenced (i.e. 1000 ~ 2 x 313 x 1.6)
- `minmaf 0.05` is minor allele frequency 5%

I also do this as a job array with the genome broken up in ~2mb intervals to speed things up using the `-sites` and `-rf` parameters. The details are explained in the ANGSD [-sites documentation](http://www.popgen.dk/angsd/index.php/Sites).

This produced 4,875,729 SNPs

## Linkage disequilibrium

I then check the SNPs in the Beagle file for linkage disequilibrium using [ngsLD](https://github.com/fgvieira/ngsLD).

Above, the `-doGlf 2` gives us the needed Beagle file format `.beagle.gz` for ngsLD and `-domaf 1` provides the allele frequency file (`.mafs.gz`). We still need to modify these to provide NgsLD with a genotype likelihood file (basically a beagle file with no header and the first three columns (position, major allele, minor allele) removed) and a file with the site positions (basically the `.mafs.gz` output with no header, and only keeping the first two columns). File prep details are outlined nicely by [lcwgs-guide-tutorial](https://github.com/nt246/lcwgs-guide-tutorial/blob/main/tutorial3_ld_popstructure/markdowns/ld.md).

This is pretty computationally intensive and provided 380 GB of memory across 24 threads. See example script, [get-ngsLD.sh](./slurm-scripts/get-ngsLD.sh). I also only considered pairwise comparisons of SNPs that were <50k bases apart.

I used the [prune_graph](https://github.com/fgvieira/prune_graph) software to select SNPs from the correlated pairs (r > 0.5). I provide an example script of this as well, [get-LDpruned.sh](./slurm-scripts/get-LDpruned.sh).

This reduced the data set to 3,956,902 SNPs, cool!

## Subset beagle files

Here, I find myself with a list of SNPs and an already prepared Beagle file that I want to subset by the list of SNPs. I could do the step previously mentioned and use "-sites" with ANGSD, but this goes back to the BAM files and is slow. Another way to quickly subset Beagle files that I like to do is to use an awk command in bash. The magically fast way to do that is:

```
awk 'NR==FNR{c[$1]++;next};c[$1]' ${ld_snps} <(zcat ${input}.beagle.gz) | gzip > ${output}.beagle.gz
```

where `${ld_snps}` is a file with a single column of the `scaffold_position` format of SNP position in the beagle file (i.e. "scaffold"_"position"), and the other input is just your plain old gzipped beagle file. Run this code and then you get a new beagle file that only has the SNPs specified in the snps file. I find this super handy! Don't forget to have the first line of the `${ld_snps}` file to have the word "marker", otherwise the new file won't have the header!

## PCangsd: Principal components analysis (PCA) and admixture

With low-coverage data, I use [PCangsd](https://github.com/Rosemeis/pcangsd) for PCA and admixture analyses. PCangsd is nice because all it requires is a beagle file as input!

Anyway, once you have a beagle file, all you need is to run PCangsd to get a covariance matrix:

```
pcangsd -b ${input_beagle} -o ${outname} -t 24
```

Also very simple to use the same framework to get individual admixture values. The only difference is adding `--admix` to specify "run admixture analysis". Specifying `-e #` is optional for manually specifying the number of eigenvectors to retain for K clusters (i.e. -e 1 = 2 clusters, -e 2 = 3 clusters, etc). You can loop through pretty fast the different K values or run it as an array (see [get-pcangsd-array.sh](./slurm-scripts/get-pcangsd-array.sh))

```
for i in {1..5}
do
    pcangsd -b ${input_beagle} -o ${admix_dir}/${outname} --admix -e ${i} -t 24
done
```

I then use the individual admixture values to create a genoscape map and also delineate breeding population clusters. In the next section, [Population Assignment](https://github.com/mgdesaix/amre-adaptation/blob/main/03_PopulationAssignment/), I will use these population clusters to subset a set of SNPs to use for assigning individuals to populations.

