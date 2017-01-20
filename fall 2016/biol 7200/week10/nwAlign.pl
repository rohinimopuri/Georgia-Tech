#!usr/bin/perl
use strict;

#======================== Needleman-Wunsch  Algorithm ========================
my $inputfile1 = $ARGV[0];
my $inputfile2 = $ARGV[1];

unless ($#ARGV == 1) {
	print "USAGE [input file name1] [input file name2]";
	print "Please provide all the mentioned information";
	exit;
}

open(INPUT1,$inputfile1) ;
open(INPUT2,$inputfile2) ;

my $seq1=<INPUT1>;
my $seq2=<INPUT2>;
chomp($seq1);chomp($seq2);

my @seq1 = split(//,$seq1);
my @seq2 = split(//,$seq2);

my $length1 = scalar@seq1;
my $length2 = scalar@seq2;
my @matrix;
#============filling up the matrix====================
my $j=0;
for(my $i=2;$i<$length1+2;$i++){
	$matrix[0][$i] = $seq1[$j];
	$j++;
	
}
my $j=0;
for(my $i=2;$i<$length2+2;$i++){
	$matrix[$i][0] = $seq2[$j];
	$j++;
}

#========Initializing the matrix====================
$matrix[1][1]=0;
for(my $i=2;$i<$length1+2;$i++){
	$matrix[1][$i] = $matrix[1][$i-1] - 1; 
}
for(my $i=2;$i<$length2+2;$i++){
	$matrix[$i][1] = $matrix[$i-1][1] - 1; 
}

#========Fill up the matrix with scores==============
#        #Match score = 1
#        #Mismatch score = -1
#        #Gap = -1
my $match; my $vertical; my $horizontal; my @array; my @sorted_array;
for(my $i=2;$i<$length2+2;$i++){
	for(my $j=2;$j<$length1+2;$j++){
		if($matrix[$i][0] eq $matrix[0][$j]){
			$match = $matrix[$i-1][$j-1] + 1; 
		}
		else{
			$match = $matrix[$i-1][$j-1] - 1; 
		}
		#Vertical score - Gap(-1)
		$vertical = $matrix[$i-1][$j] - 1; 
		#Horizontal score - Gap(-1)
		$horizontal = $matrix[$i][$j-1] - 1; 
		@array = ($match,$vertical,$horizontal);
		@sorted_array = sort{$a <=> $b}@array;
		$matrix[$i][$j] = $sorted_array[2];
	}
}

#=============Back tracking===================
my $i=$length2+1;
my $j=$length1+1;
my @a1; my @a2; my @a3; my $k;
my $diagonal; my $vertical; my $horizontal;
my $gap=0; my $match=0; my $mismatch=0;

if ($length1 > $length2){
	$k = $length1;
}
else{
	$k = $length2;
}

while($i>1 && $j>1){
	if($matrix[$i][0] eq $matrix[0][$j]){
		$a2[$k] = "|";
	}
	else{
		$a2[$k] = " ";
	}
	$diagonal = $matrix[$i-1][$j-1];
	$vertical = $matrix[$i-1][$j];
	$horizontal = $matrix[$i][$j-1];
	
	if(($diagonal > $horizontal) && ($diagonal > $vertical)){
		$a1[$k] = $matrix[0][$j];
		$a3[$k] = $matrix[$i][0];
		$k--;
		$i = $i-1;
		$j = $j-1;
	}
	elsif(($diagonal == $horizontal) && ($diagonal > $vertical)){
		$a1[$k] = $matrix[0][$j];
		$a3[$k] = $matrix[$i][0];
		$k--;
		$i = $i-1;
		$j = $j-1;
	}
	elsif(($diagonal == $vertical) && ($diagonal > $horizontal)){
		$a1[$k] = $matrix[0][$j];
		$a3[$k] = $matrix[$i][0];
		$k--;
		$i = $i-1;
		$j = $j-1;
	}
	elsif(($diagonal == $vertical) && ($diagonal == $horizontal)){
		$a1[$k] = $matrix[0][$j];
		$a3[$k] = $matrix[$i][0];
		$k--;
		$i = $i-1;
		$j = $j-1;
	}
	elsif(($diagonal <= $horizontal) && ($vertical < $horizontal)){
		$a1[$k] = $matrix[0][$j];
		$a3[$k] = "-";
		$gap++;
		$k--;
		$j = $j-1;
	}
	elsif(($diagonal <= $vertical) && ($horizontal < $vertical)){
		$a1[$k] = "-";
		$a3[$k] = $matrix[$i][0];
		$gap++;
		$k--;
		$i = $i-1;
	}
	
}

my $k=0; 
while($k<scalar@a1){
	if($a1[$k] ne $a3[$k]){
		$a2[$k] = " ";
	}
	else{
		$match++;
	}
	$k++;
}

my $score = $match - $gap;

print"\n@a1\n@a2\n@a3\n\nGaps:\t$gap\tMatches:\t$match\nAlignment Score:\t$score\n";