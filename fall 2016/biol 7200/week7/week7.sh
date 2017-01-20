#!/bin/bash
#snp calling varients pipeline
#defining usage
#------------------------------
#./week7.sh -a ./data/D2-DS3_paired1.fq -b ./data/D2-DS3_paired2.fq -r ./data/chr17.fa -e -o ./output/output.vcf.gz -z -v -i
usage()
{
echo -e "\nUsage: $0:" >&2
echo -e "$0 [-a <reads_file1>][-b <reads_file2>][-r <reference_file>][-o <final>][-e][-z][-v][-i][-h]" >&2
echo -e "options:\n\t-a :Necessary: specify input reads file 1
\n\t-b :Necessary:specify input reads file 2
\n\t-r :Necessary:specify reference genome filename
\n\t-o :the output vcf file 
\n\t-e :Do reads re-alignment 
\n\t-z :if output VCF file should be gunzipped 
\n\t-v :verbose mode 
\n\t-i :Index BAM file using samtools\n\t-h : Help " >&2
exit 1
}

#checking if no parameter is specified

#----------------------------------------------------------------------------------

if [ $# == 0 ]; then

echo "Error! No parameter found" >&2

usage

fi

# Receiving command line argument and options
#------------------------------------------------------------------------------------
#fetching input options
verbose=false
while getopts ":a:b:r:o:ezvih" option; 
do
## Getting arguments from command line
case "$option" in
a)
reads_file1=$OPTARG
echo "input read file 1: $reads_file1";;
b)
reads_file2=$OPTARG
echo "input read file 2: $OPTARG";;
r)
reference_file=$OPTARG;;
o)
final=$OPTARG
echo "output final: $OPTARG";;
e)
reads_realignment=1;;  
z)
output_vcfgunzip=1;;
v)
verbose=true;;
i)
index_bamfile=1;;
h)
usage ;;
\?)
echo -e "\nError! Unknown option:" >&2
usage ;;
:) 
echo "option -$OPTARG requires an argument.";;

esac
done

# Some checks on the arguments/options; Alert user the usage if any required arguments missing
#----------------------------------------------------------------------------------------
ref1=$(basename "$reference_file" .fa)
# Check for existence of files
#-------------------------------------------------------------------------------------------

if [ ! -f $reads_file1 ]; then

echo -e "\nError! $reads_file1 not found or -a option specified improperly" >&2

exit 1

fi

if [ ! -f $reads_file2 ]; then

echo -e "\nError! $reads_file2 not found or -b option specified improperly" >&2

exit 1

fi
#check if genome file present in pwd



if [ ! -f $reference_file ]; then

echo -e "\nError! $reference_file not found or -r option specified improperly" >&2

exit 1

fi
#check if VCF file exists if yes overright or exit the program.

if [ -f $final ]; then

#if present ask to overwrite

echo -e "$final already present\n Do you wish to Overwrite(o) or Exit(e)? "
read opinion

#if overwrite permission not given exit 

if [ "$opinion" == "e" ]; then

exit 1

# remove existing file

else

rm -r $final

echo -e "\nOutput file will be overwritten: $final"

fi
fi


# Pipeline begins
#-------------Mapping using BWA----------------#
#indexing
echo "indexing reference file";
bwa index $reference_file
echo "indexing finished!";
#mapping reads to create sam file
echo "mapping reads to indexed reference file";
bwa mem -R '@RG\tID:foo\tSM:bar\tLB:library1' $reference_file $reads_file1 $reads_file2 > data/lane.sam
echo "mapping completed";
#cleaning up read pairing information and flags--------------------
echo "cleaning up read pairing information and flag...";
samtools fixmate -O bam data/lane.sam data/lane_fixmate.bam
#----sorting------#
echo "sorting...";
samtools sort -O bam -o data/lane_sorted.bam -T /tmp/lane_temp data/lane_fixmate.bam
echo "sorting done";
if [[ $index_bamfile -eq 1 ]]; 
	then

#indexing sorted bam file
samtools index data/lane_sorted.bam
fi
##---------IMPROVEMENTS--------------------##

if [[ $reads_realignment -eq 1 ]]; 
	then
#indexing fasta reference file----------
	samtools faidx $reference_file 
#creating dictionary
	java -jar /Users/rohinimopuri/Desktop/week7/lib/picard.jar CreateSequenceDictionary R= $reference_file O= data/$ref1.dict
#------realignment--------------------------
	echo "realignment starting";
java -jar lib/GenomeAnalysisTK.jar -T RealignerTargetCreator -R $reference_file  -I data/lane_sorted.bam  -o tmp/lane.intervals --known data/Mills1000G.b38.vcf
	java -jar lib/GenomeAnalysisTK.jar -T IndelRealigner -R $reference_file -I data/lane_sorted.bam -targetIntervals tmp/lane.intervals -o tmp/lane_realigned.bam

	echo "finished realignment";

#-----indexing sorted bam file--------------
#realigned  bam file 
	if [[ $index_bamfile -eq 1 ]]; 
		then
			echo "indexing sorted and realinged bam file...";
			samtools index tmp/lane_realigned.bam 
			echo "indexed sorted realinged bam file";
	fi
fi


#____________VARIANT CALLING________________#
if [[ $reads_realignment -eq 1 ]];
	then
echo "calling varients start with realigned BAM file";	
samtools mpileup -ugf $reference_file tmp/lane_realigned.bam | bcftools call -vmO z -o output/study.vcf.gz
else
	echo "calling varients start with sorted BAM file";	
samtools mpileup -ugf $reference_file tmp/lane_sorted.bam | bcftools call -vmO z -o output/study.vcf.gz
fi

# indexing VCF for querying it
echo "indexing";
tabix -p vcf output/study.vcf.gz
echo "filtering data.."
# To filter the data
bcftools filter -O z -o $final -s LOWQUAL -i'%QUAL>10' output/study.vcf.gz
echo "SNP's are here in the output directory!!! yaaayy!!";
if [[ $output_vcfgunzip -eq 1 ]];
then
   echo "Decompressing output file..."
 #  gunzip $finals
   gunzip $final
fi
