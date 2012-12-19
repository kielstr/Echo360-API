#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/lib";
use Echo360;
use XML::Simple;
use Data::Dumper;

my $org_name = shift || die "No organization name";
my $building_name = shift || die "No building name";
my $room_name = shift || die "No room name";

my $echo360 = Echo360->new(
	USERNAME => 'kiel-test',
	KEY => '123456',
	SECRET => '7H/An2m9/oQV/znA6oqTFibhz8DiuOdw89Z6fCYM96YzuvSkmeDl2ODbEUUmHmDr6ZIZN2Frdv8BHVLdUF2V+Q==',
	URL => 'https://ecessqa01.csumain.csu.edu.au:8443/ess/scheduleapi/v1',
); 

my $org = $echo360->get(URI => 'organizations', MATCH => "^$org_name\$");
my $building = $echo360->get(URI => 'buildings', MATCH => "^$building_name\$");
my $room = $echo360->get(URI => 'rooms', MATCH => "^$room_name\$");

my %args = (
	'name' => '<![CDATA[Kiels Test Room]]>',
	'organization-id' => "<![CDATA[$org->{$org_name}{id}]]>",
);

my $p = XML::Simple->new(NoAttr => 1, KeyAttr => {});
my $xml = $p->XMLout(\%args, RootName=> 'room', NoEscape => 1);	

$echo360->update("rooms/$room->{$room_name}{id}", $xml);
