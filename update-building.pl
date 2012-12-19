#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/lib";
use Echo360;
use XML::Simple;
use Data::Dumper;

my $building_name = shift || die "No building name";

my $echo360 = Echo360->new(
	USERNAME => 'kiel-test',
	KEY => '123456',
	SECRET => '7H/An2m9/oQV/znA6oqTFibhz8DiuOdw89Z6fCYM96YzuvSkmeDl2ODbEUUmHmDr6ZIZN2Frdv8BHVLdUF2V+Q==',
	URL => 'https://ecessqa01.csumain.csu.edu.au:8443/ess/scheduleapi/v1',
); 

my $building = $echo360->get(URI => 'buildings', MATCH => "^$building_name\$");
die "Could not find building $builing_name" unless $building;

my %args = (
	name => '<![CDATA[Kiels Test Building]]>',
	campus => "<![CDATA[Kiel Test Campus]]>",
);

my $p = XML::Simple->new(NoAttr => 1, KeyAttr => {});
my $xml = $p->XMLout(\%args, RootName=> 'building', NoEscape => 1);	

$echo360->update("/buildings/$building->{$building_name}{id}", $xml);

