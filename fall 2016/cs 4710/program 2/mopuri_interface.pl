#!usr/bin/perl -w




open(FILE1,$ARGV[0]) || die("Cannot open file $ARGV[0]\n");
#creating jmol file for input to jmol.
open(FILE4,">jmol_input.spt");
@pdbfile=<FILE1>;
#coordinates-------------------------------------------------------------------------------------------------------------
#Calling coordinates for Chain A
($x,$y,$z,$aa,$posn)=coordinates($ARGV[1]);
@chainA_x=@$x;
@chainA_y=@$y;
@chainA_z=@$z;
@chainA_aa=@$aa;
@positionA=@$posn;
$len1=scalar@chainA_x;


#Calling coordinates for Chain B
($x,$y,$z,$aa,$posn)=coordinates($ARGV[2]);
@chainB_x=@$x;
@chainB_y=@$y;
@chainB_z=@$z;
@chainB_aa=@$aa;
@positionB=@$posn;
$len2=scalar@chainB_x;
#calculating Eulers distance between each pair of CA atoms in given chains
($selected_cA,$selected_cB)=distance(\@chainA_x,\@chainA_y,\@chainA_z,\@chainA_aa,\@positionA,\@chainB_x,\@chainB_y,\@chainB_z,\@chainB_aa,\@positionB,$ARGV[1],$ARGV[2],$ARGV[3]);
$distances=0;
@select_c1=@$selected_cA;
@select_c2=@$selected_cB;

#Creating an input file for JMOL command line with .spt extension
create_file($ARGV[0],$ARGV[1],$ARGV[2],\@select_c1,\@select_c2);

#--------subroutines--------------------#

#------------Subroutine to extract coordinates
sub coordinates{
	($chain)=@_;
	@x=@y=@z=@aa=@posn=();
	foreach(@pdbfile){
		chomp($_);
		if($_ =~ /^ATOM/){
			@array=split(/\s+/,$_);
			if($array[4] eq $chain){
				if($array[2] eq 'CA'){
					push(@x,$array[6]);
					push(@y,$array[7]);
					push(@z,$array[8]);
					push(@aa,$array[3]);
					push(@posn,$array[5]);
				}
			}
		}
	}
	return (\@x,\@y,\@z,\@aa,\@posn);
}

#----------Subroutine to calculate Eulers distances
sub distance{
	($xA,$yA,$zA,$aaA,$pA,$xB,$yB,$zB,$aaB,$pB,$chainA,$chainB,$thresh)=@_;
	@xA=@{ $xA }; @yA=@{ $yA }; @zA=@{ $zA }; @aaA=@{ $aaA }; @posnA=@{ $pA };
	@xB=@{ $xB }; @yB=@{ $yB }; @zB=@{ $zB }; @aaB=@{ $aaB }; @posnB=@{ $pB };
	$c1=$chainA; $c2=$chainB; $threshold=$thresh;
	
	@selected_cA=@selected_cB=();
	
	#Calculate lengths of arrays
	$len1=scalar@xA;
	$len2=scalar@xB;
	$k=0;
	
	#Calculte Eulers distance and compare with given threshold
	for($x=0;$x<$len1;$x++){
		for($y=0;$y<$len2;$y++){
			$x_sq = ($xA[$x]-$xB[$y])*($xA[$x]-$xB[$y]);
			$y_sq = ($yA[$x]-$yB[$y])*($yA[$x]-$yB[$y]);
			$z_sq = ($zA[$x]-$zB[$y])*($zA[$x]-$zB[$y]);
			$distances[$k]=sqrt($x_sq+$y_sq+$z_sq);
			if($distances[$k]<$threshold){
				push(@selected_cA,$posnA[$x]);
				push(@selected_cB,$posnB[$y]);
				print "$c1: $aaA[$x]($posnA[$x]) interacts with $c2: $aaB[$y]($posnB[$y])\n";
			}
			$k++;
		}
	}
	return (\@selected_cA,\@selected_cB);
}

#---------Subroutine to create .spt file
sub create_file{
	($file,$chainA,$chainB,$chainA_coords,$chainB_coords)=@_;
	
	$file=$file; $chainA_name=$chainA; $chainB_name=$chainB;
	@chainAcoords=@{ $chainA_coords }; @chainBcoords=@{ $chainB_coords };
	
	$file=~s/.pdb//;

	$join_c1=join(', ',@chainAcoords);
	$join_c2=join(', ',@chainBcoords);
	
	#Load pdb molecule, change to wireframe, display interacting amino acids of chain 1 in yellow, chain 2 in purple
	print FILE4 "load *$file\n";
	print FILE4 "zoom 100\n";
	print FILE4 "spacefill\n";
	print FILE4 "spacefill off\n";
	print FILE4 "wireframe\n";
	print FILE4 "select all;color white\n";
	print FILE4 "select $join_c1:$chainA_name;cartoon;color red\n";
	print FILE4 "select $join_c2:$chainB_name;cartoon;color blue\n";
}