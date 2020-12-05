#!/usr/bin/perl -w
use warnings;
use strict;


##
##          Program name: QBI_mapping_varcall_BWAMEM_wiener.pl
##          Author: Qiongyi Zhao 
##          Email: q.zhao@uq.edu.au
##          This script is used to check the paired-end fastq files, 
##              - to remove the read if its mate is missing;
##              - to remove both read1 and read2 if one read's sequence is empty or the length of sequence doesn't match the length of quality;
##              - to remove both read1 and read2 if duplicate read IDs exist in either the read1 file or the read2 file.
##    
##          Usage:  Fastq_check.pl inf_read1 inf_read2 outf_read1 outf_read2
##
######################################################################

if(@ARGV != 4) {
    print STDERR "Usage: fastq_check.pl inf_read1 inf_read2 outf_read1 outf_read2\n";
    exit(0);
}

my ($read1, $read2, $outf1, $outf2)=@ARGV;

my %hash1;
open(IN, $read1) or die "Cannot open $!\n";
while(<IN>){
    if($_=~/^@([\w\-:]+)/){
        my $id=$1;
        my $seq=<IN>;
        my $tmp=<IN>;
        my $qua=<IN>;
        if($seq=~/[A-Za-z]+/){
            if(length($seq) == length($qua)){
                $hash1{$id}++;
            }
        }
    }else{
        print STDERR "This read in fastq file $read1 doesn't start with @. Please check.\n";
        print STDERR "$_"; exit;
    }
}
close IN;

my %hash2;
open(IN, $read2) or die "Cannot open $!\n";
while(<IN>){
    if($_=~/^@([\w\-:]+)/){
        my $id=$1;
        my $seq=<IN>;
        my $tmp=<IN>;
        my $qua=<IN>;
        if($seq=~/[A-Za-z]+/){
            if(length($seq) == length($qua)){
                $hash2{$id}++;
            }
        }
    }else{
        print STDERR "This read in fastq file $read2 doesn't start with @. Please check.\n";
        print STDERR "$_"; exit;
    }
}
close IN;

open(OUT, ">$outf1") or die "Cannot open $!\n";
open(IN, $read1) or die "Cannot open $!\n";
while(<IN>){
    if($_=~/^@([\w\-:]+)/){
        my $seq=<IN>;
        my $tmp=<IN>;
        my $qua=<IN>;
        if(exists $hash1{$1} && exists $hash2{$1} && $hash1{$1}==1 && $hash2{$1}==1){
            print OUT $_.$seq.$tmp.$qua;
        }
        #else{print STDERR "$_$seq$tmp$qua\n$1***\t$hash1{$1}~~~\t$hash2{$1}###\n"; sleep 3;}
    }
}
close IN;
close OUT;

open(OUT, ">$outf2") or die "Cannot open $!\n";
open(IN, $read2) or die "Cannot open $!\n";
while(<IN>){
    if($_=~/^@([\w\-:]+)/){
        my $seq=<IN>;
        my $tmp=<IN>;
        my $qua=<IN>;
        if(exists $hash1{$1} && exists $hash2{$1} && $hash1{$1}==1 && $hash2{$1}==1){
            print OUT $_.$seq.$tmp.$qua;
        }
    }
}
close IN;
close OUT;
