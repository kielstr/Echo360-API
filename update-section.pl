#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/lib";
use Echo360;
use XML::Simple;
use Data::Dumper;

my $person_name = shift || die "No name";
my $term_name = shift || die "No term";
my $course_name = shift || die "No course";
my $section_name = shift || die "No section name";

my $echo360 = Echo360->new(
	USERNAME => 'kiel-test',
	KEY => '123456',
	SECRET => '7H/An2m9/oQV/znA6oqTFibhz8DiuOdw89Z6fCYM96YzuvSkmeDl2ODbEUUmHmDr6ZIZN2Frdv8BHVLdUF2V+Q==',
	URL => 'https://ecessqa01.csumain.csu.edu.au:8443/ess/scheduleapi/v1',
); 

my $person = $echo360->get(URI => 'people', PARAMS => "term=$person_name");
die "Could not find person $person_name" unless $person;

my $term = $echo360->get(URI => 'terms', PARAMS => "term=$term_name");
die "Could not find term $term_name" unless $term;

my $course = $echo360->get(URI => 'courses', PARAMS => "term=$course_name");
die "Could not find course $course_name" unless $course;

my $section = $echo360->get(URI => "/terms/$term->{id}/courses/$course->{id}/sections");
die "Could not find section for term $term_name course $course_name" unless $section;

my %args = (
	'name' => "<![CDATA[$section_name]]>",
	'section-roles' => {
		'section-role' => {
			'person-id' => "<![CDATA[$person->{id}]]>",
			'role-name' => '<![CDATA[section-role-name-instructor]]>',
		},
	},
	'do-not-publish' => '<![CDATA[true]]>',
	'course-portal-enabled' => '<![CDATA[true]]>',
#	'properties' => [ 
#		{
#			'key' => '<![CDATA[]]>',
#			'value' => '<![CDATA[]]>',
#		},
#		{
#			'key' => '<![CDATA[]]>',
#			'value' => '<![CDATA[]]>',
#		},
#	],
	
);

my $p = XML::Simple->new(NoAttr => 1, KeyAttr => {});
my $xml = $p->XMLout(\%args, RootName=> 'section', NoEscape => 1);	

$echo360->update("sections/$section->{section}{id}", $xml);
