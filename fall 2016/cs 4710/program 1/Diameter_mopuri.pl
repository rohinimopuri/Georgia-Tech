use 5.010;
use strict;
use warnings;
use Excel::Writer::XLSX;


my $pdbfile = $ARGV[0]; 
open(INFO, $pdbfile);		
my @lines = <INFO>;		

my $str = join '', @lines;
my @new = split /\n/, $str;
##declaring variables###
my @coord;

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
   
   print "@x \n";
   print "@y \n";
   print "@z \n";

   

my %max = (val=>0, x=>0, y=>0, z=>0);

for (my $i=0; $i < 8; $i++)
{
       for (my $j =1; $j < 9; $j++)
       {
             my $dist = sqrt( ($x[$i]-$x[$j])**2 + ($y[$i]-$y[$j])**2 + ($z[$i]-$z[$j])**2 );
              
            push @coord, $dist;

            if ($dist > $max{val}) 
            {
                $max{val} = $dist;
          
            }

        }
  }
       
           
print "The Diameter is: $max{val}; \n";


##----HISTOGRAM-----###

my $bins=10;
my $interval_range= $max{val}/$bins;
my $interval =0;
my @int=();
my @range =(0,0,0,0,0,0,0,0,0,0);

for(my $i=1;$i<=$bins;$i++)
{

$interval=$interval_range+$interval;

push @int, $interval;
}

my @frequency =(0,0,0,0,0,0,0,0,0,0);


for ($a=0; $a<scalar@int;$a++)
{
       if ($coord[$a]<=$int[0])
       {$frequency[0]++;}
       
 elsif ($coord[$a]<=$int[1])
       {$frequency[1]++;}
       
       
 elsif ($coord[$a]<=$int[2])
       {$frequency[2]++;}
       
       
 elsif ($coord[$a]<=$int[3])
       {$frequency[3]++;}       


elsif ($coord[$a]<=$int[4])
       {$frequency[4]++;}
       
       
 elsif ($coord[$a]<=$int[5])
       {$frequency[5]++;}
       
       
 elsif ($coord[$a]<=$int[6])
       {$frequency[6]++;}   


elsif ($coord[$a]<=$int[7])
       {$frequency[7]++;}
       
       
 elsif ($coord[$a]<=$int[8])
       {$frequency[8]++;}
       
       
 elsif ($coord[$a]<=$int[9])
       {$frequency[9]++;}   



       }
       
       
##exporting to the excel###

my $workbook  = Excel::Writer::XLSX->new( 'Histogram.xlsx' );
my $worksheet = $workbook->add_worksheet();
for (my $b=0;$b<scalar @frequency+1; $b++)
{
    
      print "$int[$b]-$int[$b+1]\t \t $frequency[$b]\n";
      $worksheet->write($b, 1, $int[$b]);
       $worksheet->write($b, 2, $frequency[$b]);
      }