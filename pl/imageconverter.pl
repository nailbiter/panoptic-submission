#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: imageconverter.pl
#
#        USAGE: ./imageconverter.pl  
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
#      CREATED: 02/03/19 15:25:18
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use Getopt::Long;
use File::Basename;
use Data::Dumper;
use List::Util qw[min max];
use Parallel::Loops;


#global const's
my %CONVERTERS = (
	JPGTOPNG=> '',
	RESIZE=> '',
);
my $PROCESSNUM = 4;
#global var's
my $Testflag = 0;
#procedures
sub myExec{
	(my $cmd) = @_;
	printf("exec: _%s\n",$cmd);
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
$CONVERTERS{RESIZE} = sub {
	my %cmdline = @_;
	(my $from, my $to) = @cmdline{'from','to'};
}
$CONVERTERS{JPGTOPNG} = sub {
	my %cmdline = @_;
	(my $from, my $to) = @cmdline{'from','to'};
	opendir(DH, $from);
	my @files = readdir(DH);
	closedir(DH);

	my @filenames;
	foreach my $file (@files){
		if($file =~ /\.jpg$/) {
			push(@filenames,$file);
		}
	}
	printf("%d files\n",scalar @filenames);
	my $shares = createShares($PROCESSNUM,\@filenames);
	my $pl = Parallel::Loops->new($PROCESSNUM);
	$pl->foreach( $shares, sub {
			my %share = %$_;
#			printf("share: %s\n",Dumper($share));
			for my $i ($share{start}..($share{end}-1)){
				my $file = $filenames[$i];
				(my $basename,my $dir,my $ext) 
					= fileparse($file, qr/\.[^.]*/);
				my $cmd = sprintf("convert %s%s %s%s.png",$from,$file,$to,$basename);
				system($cmd);
			}
		});
};
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
parseCommandLine(\%cmdline,'from=s','to=s','mode=s');
for(keys %CONVERTERS){
	if( $_ eq $cmdline{mode} ) {
		$CONVERTERS{$_}->(%cmdline);
		exit;
	}
}
printf(STDERR "unknown converter \"%s\"\n",$cmdline{mode});
