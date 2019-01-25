#!/usr/bin/perl -w
use warnings;
use strict;

##			Program name: gtf_addGeneName_from_refFlat.pl
##       	Author: Qiongyi Zhao 
##			Email: q.zhao@uq.edu.au
##			Release date: 25/01/2019
##    
##       	Usage:  gtf_addGeneName_from_refFlat.pl mm10.refGene.gtf mm10.refGene.refFlat.txt output(the updated GTF file)
##
######################################################################

if(@ARGV != 3) {
    print STDERR "Usage: gtf_addGeneName_from_refFlat.pl mm10.gtf mm10.refGene.refFlat.txt output\n";
  	exit(0);
}
my ($gtf, $ref, $outf)=@ARGV;


my %hash;
open(IN, $ref) or die "cannot open $ref\n";
while(<IN>){
	my @info=split(/\s+/, $_);
	$hash{$info[1]}=$info[12];
}
close IN;

my %list; # to record transcripts that don't have gene ID in refFlat
open(IN, $gtf) or die "cannot open $gtf\n";
open(OUT, ">$outf") or die "cannot open $outf\n";
while(<IN>){
	chomp;
	my @info=split(/\t/, $_);
	if($info[8]=~/gene_id "([^"]+)"; transcript_id "([^"]+)";/){
		my $gene_id;
		my ($g_id, $t_id) = ($1, $2);
		if(exists $hash{$g_id}){
			$gene_id=$hash{$g_id};
		}else{
			$gene_id=$g_id;
			$list{$g_id}=1;
		}
		$info[8]=qq(gene_id "$gene_id"; transcript_id "$g_id";);
	}else{
		print STDERR "Wrong line in gtf file:\n$_\n"; exit;
	}
	my $line=join"\t", @info;
	print OUT "$line\n";
}
close OUT;
close IN;

my $n = scalar(keys %list);
print STDERR "There are $n transcripts that don't have gene id.\n";
foreach my $key (keys %list){
	print STDERR "~$key~\n";
}

