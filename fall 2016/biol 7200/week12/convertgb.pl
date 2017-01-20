#!usr/bin/perl 
use strict;
use Bio::SeqIO;	
use Getopt::Long qw(GetOptions);

my $usage = "Convert GenBank file to EMBL/FASTA format\nUsage options:\n-i INPUT_GENBANK\n-f OUTPUT_FORMAT[EMBL/FASTA]\n-o OUTPUT_FILENAME\n";

my $input; my $format; my $output;
GetOptions(
	'i=s' => \$input,
	'f=s' => \$format,
	'o=s' => \$output,
) || die "Error in command line arguments\n$usage\n"; 


my $in = Bio::SeqIO->newFh(-file => $input, -format => 'genbank');

my $out = Bio::SeqIO->newFh(-file => ">$output", -format => "$format");

print $out $_ while <$in>;