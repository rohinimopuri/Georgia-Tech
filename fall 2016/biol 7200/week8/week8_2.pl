#!/usr/bin/perl -w

#count the occurrences of every repName, repFamily and repClass in a RepeatMasker table and print
#=========================================================================

use strict;
#=========================================================================

#defining hashes for repName, repClass and repFamily

#=========================================================================


my %repName; 
my %repClass; 
my %repFamily;
my @split;
my @repname;
my @repclass;
my @repfamily;
my $i;

#=========================================================================

#checking file exits or not

#=========================================================================


my $inputfile=$ARGV[0];

if ( -e $inputfile )

{

print "\nInput file exits.....loading\n" ;
#file exists

}else 

{

print "\nError! please enter correct input file name" ;

$inputfile=<stdin>;

chomp($inputfile);

}

#=========================================================================

#opening input file (repeat masker file)

#=========================================================================


open(FH, $inputfile) ;

while (<FH>)

{

 chomp $_;
    
 @split=split('\t', $_);
  	
@repname=$split[10];
    foreach $i(@repname)
	{
	   $repName{$i}++;
	   	 
	 }
@repclass=$split[11];

	 foreach $i(@repclass)
	{
	   $repClass{$i}++;
	   	 	
	 }
	 
	 
  
 @repfamily=$split[12];
    foreach $i(@repfamily)
	{
	   $repFamily{$i}++;
	      
	   		
	 }
}

print "\nCounts of Repeat Names:";
print "\n==========================";
print "\nRepeat Name\t\tOccurence";
print "\n============\t\t==========";


#=========================================================================

#printing all repName types and their occurences in the file
#sorts alphabetically 

#=========================================================================

foreach my $i(sort(keys(%repName)))

{

printf "\n$i\t\t$repName{$i}\n";

}

#=========================================================================

#printing all repClass types and their occurences in the file

#=========================================================================


print "\nCounts of Repeat Classes:";
print "\n==========================";
print "\nRepeat Name\t\tOccurence";
print "\n============\t\t==========";

foreach my $i(sort(keys(%repClass)))

{

printf "\n$i\t\t$repClass{$i}\n";

}


#=========================================================================

#printing all repFamilies types and their occurences in the file

#=========================================================================


print "\nCounts of Repeat Families:";
print "\n==========================";
print "\nRepeat Name\t\tOccurence";
print "\n============\t\t==========";
foreach my $i(sort(keys(%repFamily)))

{

printf "\n$i\t\t$repFamily{$i}\n";

}

#==================================END=======================================
