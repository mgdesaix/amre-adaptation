# Population Genetics

After getting analysis-ready BAM files from low-coverage sequencing data, then I make heavy use of the software [ANGSD](http://www.popgen.dk/angsd/index.php/ANGSD) (Analysis of Next Generation Sequencing Data). [ANGSD](http://www.popgen.dk/angsd/index.php/ANGSD) is a software that was specifically developed to analyze low-coverage sequencing data, and notably has many methods designed for accounting for genotype uncertainty. 

One aspect that is different when working with low-coverage data is the file types of the variant information. Typically you don't work with the standard variant call format (VCF) files that are commonplace with called genotypes. Unfortunately, what this means, is you don't have access to all the handy VCF handling software (ex. bcftools) that you may be used to. Fortunately, ANGSD is fairly straightforward with it's ability to produce different file formats for the different analyses needed in the subsequent steps. Just make sure to take note of what file type is needed for the different analyses. For a great tutorial on understanding different analyses and the process of getting the different kinds of genotype likelihood files, check out [lcwgs-guide-tutorial](https://github.com/nt246/lcwgs-guide-tutorial) on github, and their [paper](https://onlinelibrary.wiley.com/doi/10.1111/mec.16077).

## Identify related individuals

## Linkage disequilibrium

## Principal components analysis

