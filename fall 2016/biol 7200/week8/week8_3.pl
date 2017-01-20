#!/usr/bin/perl -w

#=========================================================================

#Summarize an input BED file, taking name from the command line

#=========================================================================

use strict;

#=========================================================================

my $i=-1;
my %summary;
my @split=();
my @len_entry;

my $inputfile=$ARGV[0];

if ( -e $inputfile )

{

print "\nInput file exits.....loading" ;
#file exists

}else 

{

print "\nError! please enter correct input file name" ;

$inputfile=<stdin>;

chomp($inputfile);

}

open(FH, $inputfile) ;

while (<FH>)

{

chomp $_;
    
@split=split('\t', $_);
  	
$summary{entries}++;

#=========================================================================

#total length 

#=========================================================================

$i++;

$len_entry[$i]=($split[2]-$split[1]);

#==========================================================================

#initializing maximum and minimum length to 1st entry

#==========================================================================

if($summary{entries} == 1)

{

$summary{max}=$summary{min}=$len_entry[$i];

$summary{longest}=$summary{shortest}=$_;

}
if($summary{max}<$len_entry[$i])

{

$summary{max}=$len_entry[$i];

$summary{longest}=$_;

}

#==========================================================================

#comparing length of each entry to find shortest entry

#==========================================================================

if($summary{min}>$len_entry[$i])

{

$summary{min}=$len_entry[$i];

$summary{shortest}=$_;

}

$summary{tlen_entries}+=$len_entry[$i];

#==========================================================================

#calculating number of entries on each strand

#==========================================================================

if($split[5] eq '+')

{

$summary{p_entries}++;

}

else

{

$summary{n_entries}++;

}

}



#==========================================================================

#calculating average length of entries

#==========================================================================

$summary{avg_length}=$summary{tlen_entries}/$summary{entries};

#==========================================================================

#standard deviation among gene length

#==========================================================================

my $sum_of_squares=0;

foreach my $y(@len_entry)

{

$sum_of_squares+=(($y-$summary{avg_length})**2);

}

$summary{std_dev}=(($sum_of_squares/$summary{entries})**0.5);


print "\nSummary of:\t$inputfile\n\n";
print "\n==========================================================";

print "\nTotal entries:\t\t$summary{entries}\n";
print "\n==========================================================";

print "\nTotal length of entries:\t$summary{tlen_entries}\n";
print "\n==========================================================";

print "\nTotal entries on +ve strand:\t$summary{p_entries}\n";
print "\n==========================================================";

print "\nTotal entries on -ve strand:\t$summary{n_entries}\n";
print "\n==========================================================";

print "\nLongest entry:\t\t$summary{max}\n$summary{longest}\n";
print "\n==========================================================";

print "\nShortest entry:\t\t$summary{min}\n$summary{shortest}\n";
print "\n==========================================================";

print "\nAverage length of entries:\t$summary{avg_length}\n";
print "\n==========================================================";

print "\nStandard deviation of entries:\t$summary{std_dev}\n";
print "\n==========================================================";



#==================================END========================================#


