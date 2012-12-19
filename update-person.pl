#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/lib";
use Echo360;
use XML::Simple;
use Data::Dumper;

my $org_name = shift || die "No organization name";
my $person_name = shift || die "No name";

my $echo360 = Echo360->new(
	USERNAME => 'kiel-test',
	KEY => '123456',
	SECRET => '7H/An2m9/oQV/znA6oqTFibhz8DiuOdw89Z6fCYM96YzuvSkmeDl2ODbEUUmHmDr6ZIZN2Frdv8BHVLdUF2V+Q==',
	URL => 'https://ecessqa01.csumain.csu.edu.au:8443/ess/scheduleapi/v1',
	DEBUG => 1,
); 

my $org = $echo360->get(URI => 'organizations', MATCH => "^$org_name\$");
my $person = $echo360->get(URI => 'people', PARAMS => "term=$person_name");

my %args = (
	'title' => '<![CDATA[Mr]]>',
	'first-name' => '<![CDATA[Kiel]]>',
	'last-name' => '<![CDATA[Testing]]>',
	'email-address' => '<![CDATA[kiels_test@csu.edu.au]]>',
	'block-alerts' => '<![CDATA[true]]>',
	'website' => '<![CDATA[https://test.com]]>',
	'time-zone' => '<![CDATA[Australia/Sydney]]>',
	'locale' => '<![CDATA[en_AU]]>',
	'organization-roles' => {
		'organization-role' => [
			{
				'organization-id' => "<![CDATA[$org->{$org_name}{id}]]>",
		  		'role' => '<![CDATA[role-name-Admin]]>',
			},
			{
				'organization-id' => "<![CDATA[$org->{$org_name}{id}]]>",
				'role' => '<![CDATA[role-name-academic-staff]]>',
			},
			{
				'organization-id' => "<![CDATA[$org->{$org_name}{id}]]>",
				'role' => '<![CDATA[role-name-scheduler]]>',
			},
		],
	},
);

my $p = XML::Simple->new(NoAttr => 1, KeyAttr => {});
my $xml = $p->XMLout(\%args, RootName=> 'person', NoEscape => 1);	
my $ret = $echo360->update("people/$person->{id}", $xml);
