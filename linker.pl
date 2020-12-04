#!/usr/bin/perl -w
if(@ARGV!=2){
	print STDERR "Usage: linker.pl input(fasta) output(sequence in one line)\n";
	exit(0);
}
my ($inf, $outf)=@ARGV;

open(IN,$inf) or die "cannot open $inf\n";
open(OUT,">$outf") or die "cannot open $outf\n";
my $flag=0;
while(<IN>){
    if($_=~/^>/ && $flag==0){
			print OUT $_;
			$flag=1;
	}elsif($_=~/^>/ && $flag==1){
			print OUT "\n$_";
	}elsif($_=~/^[A-Za-z]/){
      		chomp;
      		print OUT $_;
    }
}
print OUT "\n";
close(IN);
close(OUT);
  