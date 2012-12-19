#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/lib";
use Echo360;
use XML::Simple;
use Data::Dumper;

my $org_name = shift || die "No Organization name";

my $echo360 = Echo360->new(
	USERNAME => 'kiel-test',
	KEY => '123456',
	SECRET => '7H/An2m9/oQV/znA6oqTFibhz8DiuOdw89Z6fCYM96YzuvSkmeDl2ODbEUUmHmDr6ZIZN2Frdv8BHVLdUF2V+Q==',
	URL => 'https://ecessqa01.csumain.csu.edu.au:8443/ess/scheduleapi/v1',
); 

my $orgs = $echo360->get(URI => 'organizations', MATCH => "^$org_name\$");

my %args = (
	'name' => 'kiels-test-course',
	'identifier' => 'kiels-test-course',
	'organization-id' => $orgs->{CSU}{id}
);

my %xml_args = map {$_ => '<![CDATA['.$args{$_}.']]>'} keys %args;
my $p = XML::Simple->new(NoAttr => 1, KeyAttr => {});
my $xml = $p->XMLout(\%xml_args, RootName=> 'course', NoEscape => 1);	

$echo360->add('courses', $xml);
