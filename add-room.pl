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
die "Failed to find organization $org_name" unless $org;

my $building = $echo360->get(URI => 'buildings', MATCH => "^$building_name\$");
die "Failed to find building $building_name" unless $building;

my %args = (
	'name' => "<![CDATA[$room_name]]>",
	'organization-id' => "<![CDATA[$org->{$org_name}{id}]]>",
);

my $p = XML::Simple->new(NoAttr => 1, KeyAttr => {});
my $xml = $p->XMLout(\%args, RootName=> 'room', NoEscape => 1);	

my $room = $echo360->add("buildings/$building->{$building_name}{id}/rooms", $xml);

printf "Added room -- name=%s, id=%s\n", $room->{name}, $room->{id};
