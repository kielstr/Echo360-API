#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/lib";
use Echo360;
use XML::Simple;
use Data::Dumper;

my $campus_name = shift || die "No campus name";
my $building_name = shift || die "No building name";

my $echo360 = Echo360->new(
	USERNAME => 'kiel-test',
	KEY => '123456',
	SECRET => '7H/An2m9/oQV/znA6oqTFibhz8DiuOdw89Z6fCYM96YzuvSkmeDl2ODbEUUmHmDr6ZIZN2Frdv8BHVLdUF2V+Q==',
	URL => 'https://ecessqa01.csumain.csu.edu.au:8443/ess/scheduleapi/v1',
); 

my $campus = $echo360->get(URI => 'campuses', MATCH => "^$campus_name\$");
die "Could not find campus $campus_name" unless $campus; 

my %args = (
	name => "<![CDATA[$building_name]]>",
	campus => "<![CDATA[$campus->{$campus_name}{id}]]>",
);

my $p = XML::Simple->new(NoAttr => 1, KeyAttr => {});
my $xml = $p->XMLout(\%args, RootName=> 'building', NoEscape => 1);	

$echo360->add("campuses/$campus->{$campus_name}{id}/buildings", $xml);
