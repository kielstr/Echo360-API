#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/lib";
use Echo360;
use XML::Simple;
use Data::Dumper;

my $org_name = shift || die "No organization name";

my $echo360 = Echo360->new(
	USERNAME => 'kiel-test',
	KEY => '123456',
	SECRET => '7H/An2m9/oQV/znA6oqTFibhz8DiuOdw89Z6fCYM96YzuvSkmeDl2ODbEUUmHmDr6ZIZN2Frdv8BHVLdUF2V+Q==',
	URL => 'https://ecessqa01.csumain.csu.edu.au:8443/ess/scheduleapi/v1',
); 

my $org = $echo360->get(URI => 'organizations', MATCH => "^$org_name\$");

my %args = (
	'title' => '<![CDATA[Mr]]>',
	'first-name' => '<![CDATA[Kiel]]>',
	'last-name' => '<![CDATA[Testing]]>',
	'email-address' => '<![CDATA[kiels_test@csu.edu.au]]>',
	'block-alerts' => '<![CDATA[true]]>',
	'website' => '<![CDATA[https://test.com]]>',
	'time-zone' => '<![CDATA[Australia/Sydney]]>',
	'locale' => '<![CDATA[en_AU]]>',
	'credentials' => {
		'user-name' => '<![CDATA[kielstestacct]]>',
		'password' => '<![CDATA[lEtMe1nPleAse]]>'
	},
	'organization-roles' => [
			{
				'organization-role' => {
				'organization-id' => "<![CDATA[$org->{$org_name}{id}]]>",
				'role' => '<![CDATA[role-name-Admin]]>',
			},
		}
	],
);

my $p = XML::Simple->new(NoAttr => 1, KeyAttr => {});
my $xml = $p->XMLout(\%args, RootName=> 'person', NoEscape => 1);	

print $xml;

$echo360->add("people", $xml);
