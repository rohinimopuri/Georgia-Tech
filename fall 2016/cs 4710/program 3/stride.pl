#!/usr/bin/perl   

use warnings;
use strict;
#Sub method to give the secondary structure from pdb
sub pdbsec
{
	my $pdb = $_[0];
	my $NH=0;
	my $NE=0;
	my %pdb_ss;
	open(FH, "<pdb/$pdb") or die;
	while(my $line=<FH>)
	{
		if(substr($line,0,5) eq 'HELIX')
		{
			my $min1 = substr($line,20,6);
			$min1 =~ s/^\s+|\s+$//g;
			my $max1 = substr($line,32,6);
			$max1 =~ s/^\s+|\s+$//g;

		for (my $i = $min1; $i<=$max1; $i++)
		{
			$pdb = substr($pdb,0,4);
			my $r = $pdb."_".$i;
			$pdb_ss{$r} = 'HELIX';
			$NH++;
		}
		}
		elsif(substr($line,0,5) eq 'SHEET')
		{
			my $min2 = substr($line,23,5);
			$min2 =~ s/^\s+|\s+$//g;
			my $max2 = substr($line,33,5);
			$max2 =~ s/^\s+|\s+$//g;

		for (my $j = $min1; $j<=$max1; $j++)
		{
			$pdb = substr($pdb,0,4);
			my $r1 = $pdb."_".$j;
			$pdb_ss{$r1} = 'SHEET';
			$NE++;
		}
		}
	}
	return (\%pdb_ss,$NH,$NE);
}

#sub method to get secondary structure from stride

sub stridesec
{
	my $file_name = $_[0];
	my @results;
	my %stride_ss;
	print substr($file_name,0,4)."\n\n";
#calling stride..
	@results = `stride pdb/$file_name`;
	for (my $k=0; $k<scalar(@results);$k++)
	{
		if(substr($results[$k],0,3) eq 'ASG')
		{
			my $res = substr($results[$k],10,6);
			my $ss = substr($results[$k],25,14);
			$res =~ s/^\s+|\s+$//g;
			$ss =~ s/^\s+|\s+$//g;
			$file_name = substr($file_name,0,4);
			$res = $file_name."_".$res;
			$stride_ss{$res} = $ss;
		}
		elsif(substr($results[$k],0,3) eq 'SEQ' || substr($results[$k],0,3) eq 'STR')
		{
			print $results[$k];
		}

	}
	print "\n";
	my $stride_ref = \%stride_ss;
	return $stride_ref;
}
#taking files from the directory
unless(opendir(FOLDER, 'pdbfiles'))
{
	print "cannot open the directory";
	exit;
}

my @files=readdir(FOLDER);
closedir(FOLDER);

my %new_hash;
foreach my $pdb(@files)
{
	my $PH=0;
	my $PE=0;
	if($pdb ne '.' && $pdb ne '..')
	{
		my $id = substr($pdb,0,4);
		my ($pdb_out,$nhelix,$nsheet) = pdbsec($pdb);
		my $str_out = stridesec($pdb);
		my %pdb_as = %$pdb_out;
		my %stride_as = %$str_out;

		foreach(keys %stride_as)
		{
			if(exists $pdb_as{$_})
			{
				if((stride_as{$_} eq 'AlphaHelix' || stride_as{$_} eq '310Helix' || stride_as{$_} eq 'PIHelix') && $pdb_as{$_} eq 'HELIX')
				{
					$PH++;
				}
				elsif(stride_as{$_} eq 'Strand' && $pdb_as{$_} eq 'SHEET')
				{
					$PE++;
				}
			}
		}
		my $RH = ($PH/$nhelix);
		my $RE = ($PE/$nsheet);
		my $Q3 = ($PH+$PE)/($nhelix+$nsheet);
		print "RH = $RH\n";
		print "RE = $RE\n";
		print "Q3 = $Q3\n\n";

		$new_hash{"$id"}{"RH"} = $RH;
		$new_hash{"$id"}{"RE"} = $RE;
		$new_hash{"$id"}{"Q3"} = $Q3;


	}
}

my $avgRH=0;
my $avgRE=0;
my $avgQ3=0;
my $r_h=0;
my $r_e=0;
my $q_3=0;
foreach my $name(sort keys %new_hash)
{
	foreach my $value(sort keys %{$new_hash{$name}})
	{
		if( $value eq 'RH')
		{
			$avgRH += $new_hash{$name}{$value};
			$r_h++;
		}
		elsif( $value eq 'RE')
		{
			$avgRE += $new_hash{$name}{$value};
			$r_e++;
		}
		else
		{
			$avgQ3 += $new_hash{$name}{$value};
			$q_3++;
		}
	}
}

print "avgRH = ".$avgRH/$r_h."\n";
print "avgRE = ".$avgRE/$r_e."\n";
print "avgQ3 = ".$avgQ3/$q_3."\n";






