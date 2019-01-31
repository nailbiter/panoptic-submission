#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: view_json.pl
#
#        USAGE: ./view_json.pl  
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
#      CREATED: 01/31/19 07:00:58
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use Getopt::Long;
use Data::Dumper;
use JSON::Parse 'parse_json';


#global const's
#global var's
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
parseCommandLine(\%cmdline,'json','cmds');
printf("%s\n",Dumper(\%cmdline));
my $json = loadJsonFromFile($cmdline{json});
for(keys %$json){
	printf("\t%s\n",$_);
}
