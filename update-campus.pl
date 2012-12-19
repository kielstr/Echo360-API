#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/lib";
use Echo360;
use XML::Simple;
use Data::Dumper;

my $campus_name = shift || die "No campus supplied";

my $echo360 = Echo360->new(
	USERNAME => 'kiel-test',
	KEY => '123456',
	SECRET => '7H/An2m9/oQV/znA6oqTFibhz8DiuOdw89Z6fCYM96YzuvSkmeDl2ODbEUUmHmDr6ZIZN2Frdv8BHVLdUF2V+Q==',
	URL => 'https://ecessqa01.csumain.csu.edu.au:8443/ess/scheduleapi/v1',
); 

my $campus = $echo360->get(URI => '/campuses', MATCH => "^$campus_name\$");

my %args = (
	'name' => '<![CDATA[Kiel Test Campus]]>',
	'time-zone-name' => '<![CDATA[Australia/Sydney]]>',
);

my $p = XML::Simple->new(NoAttr => 1, KeyAttr => {});
my $xml = $p->XMLout(\%args, RootName=> 'campus', NoEscape => 1);	

$echo360->update("/campuses/$campus->{$campus_name}{id}", $xml);
