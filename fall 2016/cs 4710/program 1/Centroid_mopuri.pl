use 5.010;
use strict;
use warnings;

# Initializing the file
my $pdbfile = 'fake_protein.pdb'; 
# Open the file 
open(INFO, $pdbfile) or die "$! \n";
# put the data from the file into an Array
my @lines = <INFO>;		



my $str = join '', @lines;
my @new = split /\n/, $str;


my $coord;

my $x;
my $y;
my $z;
my @x;
my @y;
my @z;

foreach my $value (@new)
{
     
  
    if ($value =~ m"^ATOM\s+(.*?)\s+(.*)\s+(.*)\s+(.*)\s+(.*)\s+(.*)\s+(.*)\s+(.*)\s+(.*)\s+(.*)")
         {
             

      $x = substr($value, 30, 8);  #for columns 31-38
        $x =~ s/^\s*//;
        push @x,$x;
       
       
 $y = substr($value, 39, 8);  #for columns 39-47
        $y =~ s/^\s*//;
        push @y,$y;
       
       
$z= substr($value, 48, 8);  #for columns 39-47
        $z =~ s/^\s*//;
        push @z,$z;
       

    }

 
 }
 
 
#calculating Centroid point#

my $xcoord = 0;
my $xcount =0;
my $Xc = 0;
my $Yc = 0;
my $Zc = 0;

foreach my $xindex(@x)
{
      $xcoord +=$xindex;
      $xcount++;
      $Xc = $xcoord / $xcount;
}
         

my $ycoord = 0;
my $ycount =0;
foreach my $yindex(@y)
{
      $ycoord +=$yindex;
      $ycount++;
      $Yc = $ycoord / $ycount;
}


my $zcoord = 0;
my $zcount =0;
foreach my $zindex(@z)
{
      $zcoord +=$zindex;
      $zcount++;
      $Zc = $zcoord / $zcount;
}


push (my @C, $Xc, $Yc, $Zc);
print "Centroid points: @C \n\n";
   

my @dist=();

for (my $i = 0; $i < 8; $i++)
{
    

  
my $distance = sqrt( ($x[$i]-$C[0])**2 + ($y[$i]-$C[1])**2 + ($z[$i]-$C[2])**2 );
push @dist, $distance;

}
      
##calculating maximum distance###       
my $max= 0;


for (my $j=0; $j < 8; $j++)
{
      if($max < $dist[$j])
      {
            $max = $dist[$j];
            
            }


}


print "The Maximum Distance: $max \n";

##calculating minimum distance##

my $min =0;

for (my $k=0; $k < 8; $k++)
{
      if($min > $dist[$k])
      {
            $min = $dist[$k];
            }


      }


print "The Minimum Distance: $min \n";
 








