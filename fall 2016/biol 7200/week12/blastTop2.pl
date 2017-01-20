#!/usr/bin/perl
use strict;
use warnings;
use Bio::SeqIO;
use Bio::Tools::Run::StandAloneBlast;
use Getopt::Long qw(GetOptions);
#====================input=========================
my $usage = "STANDALONE BLAST\nUsage options:\n-i INPUT_FILE\n-d SEQUENCE_DB.FA\n-m BLAST_METHOD\n-o OUTPUT_FILENAME\n";
my $input; my $output; my $method; my $database;
GetOptions(
	"i=s" => \$input,
	"o=s" => \$output,
	"d=s" => \$database,
	"m=s" => \$method
) || die "Error in command line arguments\n$usage\n";
print "Input File:$input\nOutput File:$output\nMethod:$method\nDatabase:$database\n";
#==========creating db==========================
`formatdb -i $database -p F`;
open(FH,">$output");
my @params = (-p => $method, -d => $database);
my $seqio_object = Bio::SeqIO->new(-file => $input, -format => 'Fasta');
my $factory = Bio::Tools::Run::StandAloneBlast->new(@params);
my $report = ""; 
while (my $seq = $seqio_object->next_seq)
{
	$report = $factory->blastall($seq);
	my $result = $report->next_result;
	print FH "Query=",$result->query_name,"\n";
	my $flag=0;
	while( my $hit = $result->next_hit ) 
	{ 
		if($flag>1)
		{
			last;
		}
		print FH "Hit=",$hit->name,"\n";
		$flag++;
	}	
}
