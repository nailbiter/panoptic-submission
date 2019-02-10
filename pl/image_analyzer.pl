#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: image_analyzer.pl
#
#        USAGE: ./image_analyzer.pl  
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
#      CREATED: 02/10/19 13:22:49
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use GD;


#procedures

#main
for(@ARGV) {
	my $filename = $_;
	printf("%s\n",$filename);
	my $image = GD::Image->new($filename);
	(my $width,my $height) = $image->getBounds();
	printf("(%d,%d)\n",$width,$height);
	for(my $x = 0; $x < $width; $x++) {
		for(my $y = 0; $y<$height; $y++) {
			my $index = $image->getPixel($x,$y);
			(my $r,my $g,my $b) = $image->rgb($index);
			printf("(%d,%d) -> (%d,%d,%d)\n",$x,$y,$r,$g,$b);
		}
	}
}
