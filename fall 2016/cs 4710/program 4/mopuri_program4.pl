#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;


my $inputfile = $ARGV[0];
my %graph;
my %count;
my $i;
my $add1;
my $add2;
my $tot;
my %degree;
my %degreedist;
my @u_node1;
my @u_node2;
my @unique;

my %row;
my %col;
my $k=0;

unless ($#ARGV == 0) {
  print "USAGE [input file name]";
  print "Please provide all the mentioned information\n";
  exit;
}

#---------------------------MAIN-----------------------
open(FH,$inputfile);
while (<FH>)
{
    my ($n1, $n2, $n3) = split /\s+/;
 
  if($n1 eq $n3)
  {
      $degree{$n1}++;
      }
 else
 {
    $degree{$n1}++;
    $degree{$n3}++;
  } 
  
  push (@u_node1,$n1,$n3);
  
    $graph{$n1}{$n3} = $n2;
    $graph{$n3}{$n1} = $n2;
  
    }

 foreach my $v(sort keys %degree)
    {
        print "$v:$degree{$v}\n";
        @count{$v}=$degree{$v};
        }

 foreach my $a (sort keys %count)
    {
       for (my $b=0;$b<=scalar keys %count; $b++)
         {
             
        if ($count{$a} eq $b)
        {
            
            push @{ $degreedist{$b} }, $a;
            #print "node $a with degree $b\n";
            
            }
            
    }
     
}


print "DEGREE DISTRIBUTION is: \n";
print "k \t\t Pk\n";

 foreach my $a (sort keys %degreedist)
 {
     print "$a:"."\t\t".scalar@{  $degreedist{$a} }."\n";
     }
    
#------------------------CLUSTERING COEFFICIENT-----------------------#

my %link1;
my %link2;
my %array;

my$count2=0;

my $temp1;
my $temp2;

foreach my $key1 (keys %graph) 
{
        foreach my $key3 (keys %{$graph{$key1}}) 
        {
            print "$key1 <-> $key3\n";
                
        }
       
}

my @uniq;

foreach my $var1 (@u_node1)
{
    
        push (@uniq,$var1) unless grep{$_ eq $var1} @uniq;
        
        
}
#-----AJDACENCY MATRIX-------#


my @adj=();

for(my $row=0;$row<(scalar@uniq);$row++)
{
  for(my $col=0;$col<(scalar@uniq);$col++)
  {
         $adj[$row][$col]=0;  
      }
 }

for(my $r=0;$r<scalar@uniq;$r++)
 {
   for(my $c=0;$c<scalar@uniq;$c++)
 {
   if($graph{$uniq[$r]}{$uniq[$c]})
   {
     $adj[$r][$c] =1;
     }
     
   
    }
   }

print "#----------AJADENCY MATRIX------------#\n";
for(my $r=0;$r<scalar@uniq;$r++)
 {
   for(my $c=0;$c<scalar@uniq;$c++)
 {
      
      print "$adj[$r][$c]";
   }
   print "\n";
 }
 
 
#------------------ku nu-----------------------#
my %ku1;
my %ku2;
my $degku;

for(my $r=0;$r<scalar@uniq;$r++)
 {
   for(my $c=0;$c<scalar@uniq;$c++)
 {
   if($adj[$r][$c] eq 1)
   {
     push( @{$ku1{$uniq[$r]}},$uniq[$c] );
     
     }
   
    }
   
}

my %link;

foreach my $var1(sort keys %ku1)
{
 
  foreach my $var2(sort keys @{$ku1{$var1}})
{
   my $ctr=0;
  
  print "$var1: $var2: @{$ku1{$var1}}\n";
  foreach my $key1(sort keys %graph)
  {
    
    if( $graph{$key1}{$var1})
    {
      
      $ctr++;
      print "$graph{$key1}{$var1}\n\n";
      $link{$var1}=$ctr;
      }
    }
   
  }
  
}



print"#-------------ku for each node-------------#\n";

print Dumper(\%link);
#--------------------------#

my %nu;
for (my $r=0; $r< scalar@uniq;$r++)
{
	my $tri=0;
	for(my $c=0;$c<scalar@uniq;$c++)
	{
		if ($adj[$r][$c] == 1 && $uniq[$r] ne $uniq[$c]) 
		{
			for (my $row = 0; $row < scalar@uniq; $row++)
			{
				if ($uniq[$row] ne $uniq[$c] && $uniq[$row] ne $uniq[$r]) 
				{
					if ($adj[$row][$c] == 1 && $adj[$r][$row] == 1) 
					{
						$tri += 1;	
					}
				}	
			}
		}

	}
	$nu{$uniq[$r]} = $tri/2;
}

print"#-------------nu for each node-------------#\n";
print Dumper(\%nu);


my %cu;
foreach my $node (keys %nu){
	$cu{$node} = (2*$nu{$node})/($ku1{$node}*($ku1{$node}-1))
}


#calculation --------------- avg_c -------------#
my $total_c =0; 
my $avg_c;
my $node_c;
my @high_cu;
foreach my $c (sort values %cu)
    {
	$node_c++;
	$total_c += $c;
	
    }
$avg_c = $total_c/$node_c;
print "\nAVERAGE_C = $avg_c\n\n";


#calculation --------- avg_ck ----------------#
	
foreach my $deg (sort keys %degreedist)
{
	my $node_ck=0; 
	my $total_ck=0;
	if($deg > 1)
	{
	
		foreach my $node (@{$degreedist{$deg}})
		{	
			$total_ck += $cu{$node};
			$node_ck++;
			
		}
		
		my $a = $total_ck/$node_ck;
		
		print "For k = $deg, AVERAGE_C(k) = $a\n";
	}
	


}
print "\n";

#top five nodes with high cu
foreach my $node (sort { $cu{$a} <=> $cu{$b} } keys %cu) 
{
    push @high_cu, $node;
}


print "Top 5 nodes with highest cluster co-efficient:\n$high_cu[-1]\n$high_cu[-2]\n$high_cu[-3]\n$high_cu[-4]\n$high_cu[-5]\n\n";

#-------------------------CENTRALITY----------------------#

my @V=@uniq;
my @w;
my $inf=999999999;

for(my $r=0;$r<scalar@uniq;$r++)
 {
   for(my $c=0;$c<scalar@uniq;$c++)
 {
     $w[$r][$c]=$adj[$r][$c];
     if ( $w[$r][$c] eq 1)
     {}
       else
       {
        $w[$r][$c]= $inf;
         }
   }
 }
 
for ( my $k = 0; $k < scalar@V; $k++ )
{
    for ( my $i = 0; $i < scalar@V; $i++ )
        {
            for ( my $j = 0; $j < scalar@V; $j++ )
            {
                    if($w[$i][$k]+ $w[$k][$j] < $w[$i][$j])
                    {
                      $w[$i][$j]= $w[$i][$k]+ $w[$k][$j];
                      }     

            }
        }
}

for(my $r=0;$r<scalar@uniq;$r++)
 {
   for(my $c=0;$c<scalar@uniq;$c++)
    {
        print "$w[$r][$c]";
        }
        print "\n";
}

my $sum;
my @sum;
my $closeness;
my @closeness;
my %central;
my @high_cen;


 
for(my $r=0;$r<scalar@uniq;$r++)
 {
    $sum=0;
   for(my $c=0;$c<scalar@uniq;$c++)
    {
       
       $sum = $w[$r][$c]+$sum;
        
        }
     
        #calculation of centrality of a node 
        $closeness=1/$sum;
        push(@closeness,$closeness);
        $central{$uniq[$r]}={$closeness};
    
    }

  
  #top five nodes with high closeness centrality#
foreach my $node (sort { $central{$a} <=> $central{$b} } keys %central) 
{
    push @high_cen, $node;
}
print "Top 5 nodes with highest closeness centrality:\n$high_cen[-1]\n$high_cen[-2]\n$high_cen[-3]\n$high_cen[-4]\n$high_cen[-5]\n\n";











