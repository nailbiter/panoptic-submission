#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: get_image_size.pl
#
#        USAGE: ./get_image_size.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 02/05/19 18:31:28
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use Image::Size;
use Parallel::Loops;
use Data::Dumper;
use List::Util qw[min max];
use JSON;


#global const's
my $MAXSIZE = 10000;
my $STEP = 1000;
my %Size = (
	height => $MAXSIZE,
	width => $MAXSIZE,
);
#global var's

#main
my $pl = Parallel::Loops->new(scalar(@ARGV));
my %returnValues;
$pl->share(\%returnValues);
$pl->foreach( \@ARGV, sub {
	my %size = %Size;
	my $dirname = $_;
	opendir(DH, $dirname);
	my @files = readdir(DH);
	closedir(DH);
	for(my $i = 0; $i<scalar(@files);$i++){
		my $file = $files[$i];
		if( $file =~ /\.jpg$/ ) {
			my $filepath = sprintf("%s/%s",$dirname,$file);
#			printf(STDERR "filepath: %s\n",$filepath);
			(my $hei,my $wid) = imgsize($filepath);
			$size{height} = min($hei,$size{height});
			$size{width} = min($wid,$size{width});
			if(($i%$STEP)==0) {
				printf(STDERR "%25s: %09d: %d\n",$dirname,$i,scalar(@files));
			}
		}
	}
	$returnValues{$_} = \%size;
});

my %size = %Size;
for(keys %returnValues){
	$size{height} = min($returnValues{$_}->{height},$size{height});
	$size{width} = min($returnValues{$_}->{width},$size{width});
}
print(encode_json(\%size));
