#!/usr/bin/perl

use strict;
use warnings;
use autodie;

use File::Basename qw(fileparse);

my $logfile    = $ARGV[0];
my($filename, $directories, $suffix) = fileparse($logfile,qr/\.[^.]*$/);
$filename =~ s/\.$suffix$//;
my $parsedfile = $directories . $filename.".csv";

open my $infh,  '<', $logfile;
open my $outfh, '>', $parsedfile;

my $separator = ",";
print $outfh join($separator, qw(Hop IP T1 T2 T3 T4 T5 T6)), "\n";

while (<$infh>) {
    if (/^\s*\d/) {
        chomp;
        s/^\s+//;
        print $outfh join(',', split /\s+(?!ms)/), "\n";
    }
}
