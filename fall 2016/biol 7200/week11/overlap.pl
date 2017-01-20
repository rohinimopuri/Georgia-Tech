#!/usr/bin/perl
use strict;
use warnings;
#=================================================================
sub overlap;
my $args = @ARGV;
my $join; my $file1; my $file2; my $m ; my $out;
#==========defining conditions for arguments===========================
if($args == 9 && $ARGV[0] eq "-i1" && $ARGV[2] eq "-i2" && $ARGV[4] eq "-m" && $ARGV[6] eq "-j" && $ARGV[7] eq "-o")
{   $join=1;
    $file1 = $ARGV[1];
	$file2 = $ARGV[3];
	$m = $ARGV[5];
	$out = $ARGV[8];
	if($ARGV[5] > 100 || $ARGV[5] <0){
	print "Enter valid minimal overlap that is >0 & <100 "; exit;}
}
elsif($args == 8 && $ARGV[0] eq "-i1" && $ARGV[2] eq "-i2" && $ARGV[4] eq "-m" && $ARGV[6] eq "-o")
{	
	$file1 = $ARGV[1];
	$file2 = $ARGV[3];
	$m = $ARGV[5];
	$out = $ARGV[7];
	$join=0;
}
elsif($args == 7 && $ARGV[0] eq "-i1" && $ARGV[2] eq "-i2" && $ARGV[4] eq "-m" && $ARGV[6] eq "-j")
{	
	$file1 = $ARGV[1];
	$file2 = $ARGV[3];
	$m = $ARGV[5];
	$out = "a.txt";
	$join=1;
}
elsif($args == 6 && $ARGV[0] eq "-i1" && $ARGV[2] eq "-i2" && $ARGV[4] eq "-m")
{	
	$file1 = $ARGV[1];
	$file2 = $ARGV[3];
	$m = $ARGV[5];
	$out = "a.txt";
	$join=0;
}
else
{
	print "Invalid Arguments!";
}

#=================================================================================================
#===================start main=============================================
my $val1=1; my $val2=1;
open(FH1,"<$file1");

my @array=();
while(<FH1>)
{
	my ($chr) = split("\t",$_);
	$chr =~ s/^\s+|\s+$//g;
	push @array, $chr;
}
close(FH1);
my %unique = ();
foreach my $item (@array)
{
    $unique{$item} ++;
}
my @ar2 = keys %unique;

foreach my $element(@ar2)
{
  overlap($element,$m,$out);
}


sub overlap
{	
    sub min
	{
		if($_[0]>$_[1])
		{ return $_[1];}
		else { return $_[0];}
	}
	sub max
	{
		if($_[0]>$_[1])
		{return $_[0];}
		else { return $_[1];}
	}
	my $ref_chr = $_[0];
	my $match = $_[1];
	my $out_file = $_[2];
	my @first=(); my @second=();
	open(FH2,"<$file1");
	open(FH3,"<$file2");
	open(FH4,">>$out_file");
	while(<FH2>)
	{   
		next unless $. >= $val1;
		my ($chr1)=split("\t",$_);
		$chr1 =~ s/^\s+|\s+$//g;
		if($chr1 eq $ref_chr)
		{
			push @first,$_;
		}
	}
	$val1 += @first;

	while(<FH3>)
	{	
		next unless $. >= $val2;
		my ($chr2)=split("\t",$_);
		$chr2 =~ s/^\s+|\s+$//g;
		if($chr2 eq $ref_chr)
		{
			push @second,$_;
		}
	}
		$val2 += @second;
	close(FH2);
	close(FH3);
   F1: for(my $i=0; $i<@first;$i++)
	{
		my($c1,$start_one,$stop_one) = split("\t",$first[$i]);
		$c1 =~ s/^\s+|\s+$//g;
		$start_one =~ s/^\s+|\s+$//g;
		$stop_one =~ s/^\s+|\s+$//g;
		F2: for(my $j=0;$j<@second;$j++)
		{
			my($c2,$start_two,$stop_two) = split("\t",$second[$j]);
			$c2 =~ s/^\s+|\s+$//g;
			$start_two =~ s/^\s+|\s+$//g;
			$stop_two =~ s/^\s+|\s+$//g;
			if($stop_one > $start_two)
			{
				   my $over_lap = min($stop_one,$stop_two) - max($start_one,$start_two);
				   my $total = $stop_one - $start_one;
				   my $percent = ($over_lap/$total)*100;
				   if($percent >= $match)
				   {
				      if($join == 1)
				       {
							my $into_file = $c1."\t".$start_one."\t".$stop_one."\t".$c2."\t".$start_two."\t".$stop_two."\n";
							print FH4 $into_file;
					   }
					  else 
					   {
							my $into = $c1."\t".$start_one."\t".$stop_one."\n";
							print FH4 $into;
				       }
				   }
				   else
				   {
						next F2;
				   }
			}
			else
			{
				next F1;
			}
		}
	}
	close(FH4);
}
