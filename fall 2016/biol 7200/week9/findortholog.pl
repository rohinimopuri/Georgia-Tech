#!/usr/bin/perl                                                                                                                                   
use warnings;
use strict;

#taking in two files input

my $seq1 = $ARGV[0] ;
my $seq2 = $ARGV[1] ;
my $dbtype = $ARGV[2];
my $outfile = $ARGV[3];
open(FH,">$outfile");
sub orthologs;

unless ($#ARGV == 3)  {
    print "  USAGE: query-list1 query-list2 Type-N/P\n";
    print " please enter all required fields";
    exit;
}


if (($dbtype eq 'n' || $dbtype eq 'N'))
	{
		system("makeblastdb -in $seq1 -parse_seqids -dbtype nucl");
		system("makeblastdb -in $seq2 -parse_seqids -dbtype nucl");
		print "Nucleotide Database created!";

		print "Querying $seq1 against Database\n";
		my @array1=`blastn -query $seq1 -db $seq2 -max_target_seqs 1 -outfmt 6`;
		

		print "Querying $seq2 against Database \n";
		my @array2=`blastn -query $seq2 -db $seq1 -max_target_seqs 1 -outfmt 6`;
		orthologs(\@array1,\@array2);
	} 

if (($dbtype eq 'P' || $dbtype eq 'p'))
	{
		system("makeblastdb -in $seq1 -parse_seqids -dbtype prot");
		system("makeblastdb -in $seq2 -parse_seqids -dbtype prot");
		print "Protien Database created!";

		print "Querying $seq1 against Database\n";
		my @array1 = `blastp -query $seq1 -db $seq2 -max_target_seqs 1 -outfmt 6`;

		print "Querying $seq2 against Database \n";
		my @array2 = `blastp -query $seq2 -db $seq1 -max_target_seqs 1 -outfmt 6`;
 		orthologs(\@array1,\@array2);
 	}

my %input_1; my %input_2;

sub orthologs() {

	my ($array1,$array2)=@_;
my %input_1; my %input_2;
	foreach my $line(@$array1)
	{
		my @parts=split("\t",$line);
		my @parts1=split(/\|/,$parts[0]);
		$input_1{$parts1[1]}=$parts[1];
	}
	foreach my $line(@$array2)
	{
		my @parts=split("\t",$line);
		my @parts1=split(/\|/,$parts[0]);
		$input_2{$parts[1]}=$parts1[1];
	}
	foreach (keys %input_1)
	{
		if(exists $input_2{$_})
		{
			if($input_1{$_} eq $input_2{$_})
			{
				print FH "$_\t$input_2{$_}\n";
			}
		}
	} 
}

system("rm $seq1.*");
system("rm $seq2.*");


  


