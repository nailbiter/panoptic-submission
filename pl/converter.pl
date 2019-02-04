#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: converter.pl
#
#        USAGE: ./converter.pl  
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
#      CREATED: 01/31/19 17:54:55
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use Getopt::Long;
use Data::Dumper;
use JSON::Parse 'parse_json';


#global const's
my %CONVERTERS = (
	SEGTOCSV=> '',
);
#procedures
sub parseCommandLine{
	(my $cmdline, my @arguments) = @_;
	my %args;
	for(@arguments){
		$args{$_.'=s'} = \$$cmdline{$_};
	}
	GetOptions(
		%args,
	);
}
$CONVERTERS{SEGTOCSV} = sub {
	my %cmdline = @_;
#	printf(STDERR "%s\n",Dumper(\%cmdline));
	my $json = loadJsonFromFile($cmdline{in});
	printf("name,r,g,b\n");
	for(@$json){
#		printf("%s\n",Dumper($_));
		printf("%s,%d, %d, %d\n",
			$_->{name},
#			$_->{color}->[0],
#			$_->{color}->[1],
#			$_->{color}->[2],
			$_->{id},
			$_->{id},
			$_->{id},
		);
	}
};
sub loadJsonFromFile{
	(my $filename) = @_;
	open my $fh, '<', $filename or 
		die sprintf("error opening %s\nerror=%s\n",$filename,$!);
	my $data = do { local $/; <$fh> };
	my $json = parse_json($data);
	close($fh);
	return $json;
}

#main
my %cmdline;
parseCommandLine(\%cmdline,'in','mode');
for(keys %CONVERTERS){
	if( $_ eq $cmdline{mode} ) {
		$CONVERTERS{$_}->(%cmdline);
		exit;
	}
}
printf(STDERR "unknown converter \"%s\"\n",$cmdline{mode});
