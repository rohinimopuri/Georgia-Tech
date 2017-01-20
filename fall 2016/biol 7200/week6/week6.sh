#!/bin/bash
#initializing 
i=o
j=0
#Taking in commandline arguments
while getopts ":n:m:v" opt;
do
	case $opt in
	n)
		i=$OPTARG
		echo "-n value is: $OPTARG";;
	m)
		j=$OPTARG
		echo "-m value is: $OPTARG";;
	v)
		
	    set -v ;;
	\?)
	     echo "invalid option";;
	:) 
		 echo "option -$OPTARG requires an argument.";;	
	esac
done

#for i in {1..10}
#getting the value of i and j from getopts commandline inputs.
for((x=1;x<=${i};x++))
do
#	 Checking if the output files already exists. Delete if yes.
	if [ -e seq${x}.fasta ] #-e means the file exists
		then
			rm seq${x}.fasta
#			echo "file exists and deleted"
	fi
	touch seq${x}.fasta
#	for j in {1..8}
for((y=1;y<=${j};y++))
	do
#		Generates output and write to files
		echo ">seq${x}_${y}" >> seq${x}.fasta # >> to append the required line
		cat /dev/urandom | tr -dc 'ACGT' | fold -w 50 | head >> seq${x}.fasta #generating random sequences
	done
done

