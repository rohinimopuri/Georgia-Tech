#!/usr/bin/perl -w

#====================================================================

#finding coordinates, starting coordinates and ending coordinates along with the gene name.

#====================================================================

use strict;

#====================================================================

#known gene file
my $inputfile1=$ARGV[0];
#kgXref file
my $inputfile2=$ARGV[1];
#infectious disease file
my $inputfile3=$ARGV[2];

my @split;
#====================================================================

#putting all genes into an array

#====================================================================

open(FH,$inputfile3);

my $header=<FH>;

my @genes;

while(my $line=<FH>)
{
	
	chomp($line);
	
	push(@genes,$line);	

}

close(FH);


#====================================================================

#getting all the genes coordinate id from kgXref.

#====================================================================

my @id;

my @GeneName;

open(FH,$inputfile2);

while(my $line=<FH>)

{
	chomp($line);
	
	@split=split(/\t/,$line);
	
	push(@id,$split[0]);
	
	push(@GeneName,$split[4]);	
}

my @Gene; 

my @CoordID;

foreach my $gene(@genes)

{

	for(my $i=0;$i<scalar(@GeneName);$i++)

	{

		if($gene eq $GeneName[$i])

		{

			push(@Gene,$gene);

			push(@CoordID,$id[$i]);

		}

	}

}

close(FH);


#====================================================================

#gettin coordinates from the knowngene file.

#====================================================================

my @coordinates;

my @start; 

my @end; 

my @Chromname;

open(FH,$inputfile1);

while(my $line=<FH>)

{

	chomp($line);
	
	@split=split(/\t/,$line);
	
	push(@coordinates,$split[0]); #coord
	
	push(@Chromname,$split[1]); #name
	
	push(@start,$split[3]); #start
	
	push(@end,$split[4]); #end
	
}

close(FH);

#====================================================================

#gettin coordinates from the knowngene file.

#====================================================================

my $k=0;

foreach my $gene(@CoordID)

{
	
	for(my $i=0;$i<scalar(@coordinates);$i++)

	{
		if($gene eq $coordinates[$i])
		
		{
			print "\nGene Name:\tChromosome Number:\tCoordinate start:\tCoordinate end:";
			print "\n==========\t==================\t=================\t===============";
			print "\n$Gene[$k]\t\t$Chromname[$i]\t\t\t$start[$i]\t\t$end[$i]";
		
		}
	
	}

$k++;

}


#==================================END========================================#
