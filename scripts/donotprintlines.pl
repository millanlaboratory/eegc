#!/usr/bin/perl
use strict;

@ARGV >= 2 or die "Error: donotprintlines.pl FILE LINES\n";

my $limit = @ARGV-1;
my @lines = @ARGV[1..$limit];

my $filename = $ARGV[0];
#my $line = $ARGV[1];
open(FILE, $filename) or die "Error: cannot read $filename";

my $n = 1;
while(<FILE>) {
  if(grep $_ == $n, @lines) {
  } else {
	  print "$_";
  }
  $n++;
}
close FILE;
