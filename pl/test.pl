#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: test.pl
#
#        USAGE: ./test.pl  
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
#      CREATED: 02/10/19 12:12:55
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use Data::Dumper;
use Getopt::Long;
use File::Basename;
use Image::Size;
use Image::Resize;
use Parallel::Loops;
use List::Util qw[min max];


#global const's
my $PROCESSNUM = 4;
my $CHECKPOINTPATH='checkpoints/latest_model_FC-DenseNet56_coco.ckpt';
my $DATASETNAME = 'coco';
my $TESTPY = 'predict.py';
my $OUTFORMAT = 'png';
#global var's
my $Testflag = 0;
#procedures
sub myExec{
	(my $cmd) = @_;
	printf(STDERR "exec: _%s\n",$cmd);
	if(not $Testflag){
		system($cmd);
	}
}
sub parseCommandLine{
	(my $cmdline, my @arguments) = @_;
	my %args;
	for(@arguments){
		my $fullkey = $_;
		(my $key) = split('=',$fullkey);
		$args{$fullkey} = \$$cmdline{$key};
	}
	GetOptions(
		%args,
	);
}
sub getHeightWidth{
	(my $fullname) = @_;
	(my $height,my $width) = imgsize($fullname);
	return ($height,$width);
#	return (512,512);
}
sub createShares{
	(my $processNum,my $listRef) = @_;
	my @res;
	my $split = int(scalar(@$listRef)/$processNum);
	foreach my $i (1..$processNum){
		push(@res,{
				start=>(($i-1)*$split),
				end=>min($i*$split+1,scalar(@$listRef)),
			});
	}
	return \@res;
}

#main
my %cmdline;
parseCommandLine(\%cmdline,
	'testfolder=s', 'python=s', 'start=n', 'end=n', 'testflag=n',
	'extension=s',
	'outdir=s',
);
opendir(DH, $cmdline{testfolder});
my @files;
my $extension = $cmdline{extension};
for(readdir(DH)) {
	if(/\.$extension$/) {
		my $filename = $_;
		(my $base,my $dir, my $ext) = fileparse($filename,qr/\.[^.]*/);
		push(@files,$base);
	}
}
closedir(DH);
@files = sort @files;
$cmdline{start} //= 0;
$cmdline{end} //= scalar(@files) - 1;
$Testflag = $cmdline{testflag};
my @indexes = $cmdline{start}..($cmdline{end}-1);
my $shares = createShares($PROCESSNUM,\@indexes);
my $pl = Parallel::Loops->new($PROCESSNUM);
$pl->foreach( $shares, sub {
	my %share = %$_;
	for my $i ($share{start}..($share{end}-1)){
		my $filename = $files[$indexes[$i]];
#		my $filename = $files[$i];
		printf(STDERR "%d -> %s\n",$indexes[$i],$filename);
		my $fullname = sprintf("%s/%s.%s",
			$cmdline{testfolder}, $filename, $cmdline{extension},
		);
		(my $height,my $width) = getHeightWidth($fullname);
		myExec(sprintf("%s %s --dataset %s --checkpoint_path %s --image %s"
				." --out_height %d --out_width %d"
				." --outdir %s",
				$cmdline{python},$TESTPY,
				$DATASETNAME,$CHECKPOINTPATH,
				$fullname,
				$height,$width,
				$cmdline{outdir},
			));
		my $resfullname = sprintf("%s/%s_pred.%s",
			$cmdline{outdir}, $filename, $OUTFORMAT,
		);
		my $outfullname = sprintf("%s/%s_resized.%s",
			$cmdline{outdir}, $filename, $OUTFORMAT,
		);
		my $image = Image::Resize->new($resfullname);
		my $gd = $image->resize($width, $height,0);
		open(FH, '>'.$outfullname);
		print FH $gd->png();
		close(FH);
	}
});
