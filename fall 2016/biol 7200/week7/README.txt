#___________________________________________________________________________________________________________________

Week7.sh : SNP Calling Pipeline
#___________________________________________________________________________________________________________________

./week7.sh -a ./data/D2-DS3_paired1.fq -b ./data/D2-DS3_paired2.fq -r ./data/chr17.fa -e -o ./output/output.vcf.gz -z -v -i
All input files must be in data folder.
The output files must set path to the output folder.

-a <reads_file1>:  Input reads file pair 1 (Required)
-b <reads_file2>:  Input reads file pair 2 (Required)
-r <reference_file>:    Input reads reference genome file (Required)
-o <final> :    Output vcf file (Required)
-e  Do reads re-alignment
-z  If output should be in format *.vcf.gz
-v  Verbose mode
-i  To index output bam file
-h  Print usage information

#___________________________________________________________________________________________________________________

Structure of pipeline directories:

|------ week7.sh
|------ README.txt
	|------ data/ [ALL input files must be in a data folder]
		|------ D2-DS3_paired1.fq [R1 file]
		|------ D2-DS3_paired2.fq [R2 file]
		|------ chr17.fa	  [Reference file]
		|------ Mills1000G.b38.vcf
	|------ lib/ [All softwares]
		|------ GenomeAnalysisTK.jar
		|------ picard.jar
		|------ samtools
		|------ tabix
		|------ bcftools-1.3.1
		|------ bwa.kit
	|------ tmp/ [where your temp file(s) are stored]
	|------ output/ [where ALL your final output files are stored]
		|------ output.vcf.gz
		|------ filtered_output.vcf.gz
		|------ plot directory

#_____________________________________________________________________________________________________________________

Output file of week7.sh is a VCF file of filtered SNPs for data: D2-DS3_paired1.fq and D2-DS3_paired2.fq which is aligned to Human Chromosome 17.
VCF file has information about SNP,INDEL and structural variations in the input file in correspondence with the reference genome.
The vcd is gunzipped but by choosing the option -z should decompress the file to a readable form.

Steps for finding variations in the input file:
1. Aligning the paired end reads with Reference genome.This is done using bwa tools
2. Sorting the bam file using Samtools
3. Realign raw gapped alignment with the Broad’s GATK Realigner to reduce the number of miscalls of INDELs in the data.
4.Variant calling using Samtools.




