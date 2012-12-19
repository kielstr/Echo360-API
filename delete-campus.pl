#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/lib";
use Echo360;
use Data::Dumper;

my $campus_name = shift || die "No campus name";

my $echo360 = Echo360->new(
	USERNAME => 'kiel-test',
	KEY => '123456',
	SECRET => '7H/An2m9/oQV/znA6oqTFibhz8DiuOdw89Z6fCYM96YzuvSkmeDl2ODbEUUmHmDr6ZIZN2Frdv8BHVLdUF2V+Q==',
	URL => 'https://ecessqa01.csumain.csu.edu.au:8443/ess/scheduleapi/v1',
); 

my $campus = $echo360->get(URI => '/campuses', MATCH => "^$campus_name\$");
die "Could not find campus $campus_name" unless $campus;

$echo360->delete("/campuses/$campus->{$campus_name}{id}");
