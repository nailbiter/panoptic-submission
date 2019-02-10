#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: slicer.pl
#
#        USAGE: ./slicer.pl  
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
#      CREATED: 02/09/19 18:34:38
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use Data::Dumper;
use Getopt::Long;
use List::Util qw(shuffle);
use File::Basename;


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
sub getFileNames{
	(my $dirname, my $extension) = @_;
	opendir(DH, $dirname);
	my @files;
	for(readdir(DH)){
		if(/\.$extension$/) {
			my $filename = $_;
			(my $base,my $dir, my $ext) = fileparse($filename,qr/\.[^.]*/);
			push(@files,$base);
		}
	}
	closedir(DH);
	return @files;
}

#main
my %cmdline;
parseCommandLine(\%cmdline,'from=s@','to=s@','slicenum=n','extension=s@','testflag=n');
if(defined $cmdline{testflag}){
	$Testflag = $cmdline{testflag};
}
printf("%s\n",Dumper(\%cmdline));
#printf("%d\n",scalar());
my @files = shuffle(getFileNames($cmdline{from}->[0],$cmdline{extension}->[0]));
my $lim = int(scalar(@files)/$cmdline{slicenum});
@files = @files[1..$lim];
printf("files: %s\n",Dumper(\@files));
printf("lim: %d\n",$lim);
printf("lim: %d\n",scalar(@files));
for(1..scalar(@{$cmdline{from}})){
	my $i = $_-1;
	(my $from, my $to, my $ext) = ($cmdline{from}->[$i],$cmdline{to}->[$i],
		$cmdline{extension}->[$i]);
	printf("%d,\n\t%s,\n\t%s,\n\t%s,\n",$i,$from,$to,$ext);
	myExec(sprintf("mkdir -p %s",$to));
	for(@files){
		myExec(sprintf("cp %s/%s.%s %s",$from,$_,$ext,$to));
	}
}
