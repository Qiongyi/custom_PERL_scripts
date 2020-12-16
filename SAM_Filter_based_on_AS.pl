#!/usr/bin/perl -w
use strict;
use warnings;

if(@ARGV !=3) {
    print STDERR "Usage: SAM_Filter_based_on_AS.pl AS_cutoff(e.g. 5000) inf outf\n";
    exit(0);
}
my ($cutoff, $inf, $outf)=@ARGV;

open(IN, $inf) or die "Cannot open $inf\n";
open(OUT, ">$outf") or die "Cannot open $outf\n";
while(<IN>){
	if($_=~/^\@/){
		print OUT $_;
	}elsif($_=~/AS:i:(\d+)/){
		if($1>=$cutoff){
			print OUT $_;
		}
	}
}
close IN;
close OUT;
