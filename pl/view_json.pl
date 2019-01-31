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
use Term::ReadLine;
use Text::TabularDisplay;


#global const's
my %COMMANDS = (
	ls => {},
	cd => {},
	show => {},
	help => {
		description=>'show this help message',
	},
);
#global var's
my $Json;
my $OrigJson;
my $Log = 0;
#procedures
sub isHashRef {
	(my $ref) = @_;
	return (ref($ref) eq "HASH");
}
sub isArrayRef {
	(my $ref) = @_;
	return (ref($ref) eq "ARRAY");
}
$COMMANDS{show}->{callback} = sub {
	printf("%s\n",Dumper($Json));
	myLog(sprintf("%s\n",Dumper($Json)));
};
$COMMANDS{ls}->{callback} = sub {
	if( isHashRef($Json) ) {
		for(keys %$Json){
			printf("\t%s\n",$_);
		}
	} elsif( isArrayRef($Json) ) {
		printf("\tsize: %d\n",scalar(@$Json));
	}
};
$COMMANDS{cd}->{callback} = sub {
	(my $args) = @_;
	if( not defined $args ) {
		$Json = $OrigJson;
		printf("reset Json\n");
	} elsif( isHashRef($Json) ) {
		if ( defined $$Json{$args} ) {
			$Json = $$Json{$args};
			printf("set Json \"%s\"\n",$args);
		} else {
			printf("no key \"%s\"\n",$args);
		}
	} elsif( isArrayRef($Json) ) {
		my $count = $args;
		if ( defined $$Json[$count] ) {
			$Json = $$Json[$count];
			printf("set Json %d\n",$count);
		} else {
			printf("no key %d\n",$count);
		}
	}
};
$COMMANDS{help}->{callback} = sub {
	my $t = Text::TabularDisplay->new(qw(method description));
	for(keys(%COMMANDS)){
		my $description = $COMMANDS{$_}->{description};
		$description //= $_;
		$t->add($_,$description);
	}
	print $t->render;
	print "\n";
};
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
sub createLog{
	(my $filename) = @_;
	open my $fh, '>', $filename or 
		die sprintf("error opening %s\nerror=%s\n",$filename,$!);
	$Log = $fh;
}
sub myLog{
	(my $str) = @_;
	if( $Log ) {
		printf($Log "%s\n",$str);
	}
}
sub myexit{
	close($Log);
}

#main
my %cmdline;
parseCommandLine(\%cmdline,'json','cmds','log');
if(defined $cmdline{log}) {
	createLog($cmdline{log});
}
printf("%s\n",Dumper(\%cmdline));
$OrigJson = $Json = loadJsonFromFile($cmdline{json});
if( not defined $cmdline{cmds} ) {
	my $term = Term::ReadLine->new('Simple Perl calc');
	my $prompt = '> ';
	my $OUT = $term->OUT || \*STDOUT;
	while ( defined ($_ = $term->readline($prompt)) ) {
		(my $cmd, my $args) = split(/\s/,$_);
		if($cmd eq 'exit' ) {
			myexit();
			last;
		} else {
			my $wasFound = 0;
			for(keys %COMMANDS){
				if($_ eq $cmd){
					$COMMANDS{$_}->{callback}->($args);
					$wasFound = 1;
					last;
				}
			}
			if( !$wasFound ) {
				printf("Uknown command\n");
			}
		}
		$term->addhistory($_) if /\S/;
	}
}
