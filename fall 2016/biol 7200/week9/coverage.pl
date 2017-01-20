#!/usr/bin/perl
use strict;

#======taking in files========
my $inputfile=$ARGV[0];
my $outputfile=$ARGV[1];

unless ($#ARGV == 1) 
{
    print "  USAGE: -inputfile -outputfile \n";
    print " please enter all required fields";
    exit;
}

sub printbed;
`sort -V -k1,1 -k2,2 -k3,3 $inputfile -o $inputfile`;
open(FH,"$inputfile");
open(FS,">$outputfile");
my $line=<FH>;
my @split = split("\t",$line);
my $prev_chrom=$split[0];
close(FH);
open(FH,"$inputfile");

my %bed;
while(my $line=<FH>)
{
	chomp($line);
	my @all = split("\t",$line);
	my $chrom=$all[0];
	if($prev_chrom eq $chrom)
	{
		for(my $i=$all[1];$i<=$all[2];$i++)
		{
			$bed{$i}++;
		}
	}
	elsif($prev_chrom ne $chrom)
	{
		printbed(\%bed,$prev_chrom);
		%bed=();
		$prev_chrom=$chrom;	
	}
}

printbed(\%bed,$prev_chrom);

sub printbed()
{
	my ($bed,$chrom)=@_;
	my %bed=%$bed;
	my @key= ( sort {$a<=>$b} keys %bed);
	my @temp;
        for(my $i=0;$i<scalar(@key);$i++)
	{
		if($bed{$key[$i]} == $bed{$key[$i+1]})
		{
			push(@temp,$key[$i]);
		}
		elsif($bed{$key[$i]} != $bed{$key[$i+1]})
		{
			push(@temp,$key[$i]);
			print FS "$chrom\t$temp[0]\t$key[$i]\t$bed{$key[$i]}\n";
			@temp=();
		}
	}
	
}

