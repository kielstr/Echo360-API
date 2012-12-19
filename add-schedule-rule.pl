#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/lib";
use Echo360;
use XML::Simple;
use Data::Dumper;

my $course_name = shift || die "No course name";
my $room_name = shift || die "No room name";
my $presenter_name = shift || die "No presenters name";

my $echo360 = Echo360->new(
	USERNAME => 'kiel-test',
	KEY => '123456',
	SECRET => '7H/An2m9/oQV/znA6oqTFibhz8DiuOdw89Z6fCYM96YzuvSkmeDl2ODbEUUmHmDr6ZIZN2Frdv8BHVLdUF2V+Q==',
	URL => 'https://ecessqa01.csumain.csu.edu.au:8443/ess/scheduleapi/v1',
	DEBUG => 1,
); 

my $course = $echo360->get(URI => '/courses', PARAMS => "term=$course_name");
my $section = $echo360->get(URI => "/courses/$course->{id}/sections");
my $section_id = $section->{section}{id};

my %args = (
	'title' => '<![CDATA[Kiels Schedule-Rule Test]]>',
	'status' => '<![CDATA[draft]]>',
	'description' => '<![CDATA[Kiels Test schedule using the api]]>',
	'target-display-input-override' => '<![CDATA[640x720]]>',
	'recurring' => '<![CDATA[true]]>',
	'start-time' => '<![CDATA[10:30]]>',
	'duration-seconds' => '<![CDATA[120]]>',
	'start-date' => '<![CDATA[2012-12-25]]>',
	'end-date' => '<![CDATA[2013-01-10]]>',
	'days-of-week' => {
		'sunday' => '<![CDATA[false]]>',
		'monday' => '<![CDATA[true]]>',
		'tuesday'=> '<![CDATA[true]]>',
		'wednesday' => '<![CDATA[true]]>',
		'thursday' => '<![CDATA[false]]>',
		'friday' => '<![CDATA[false]]>',
		'saturday' => '<![CDATA[false]]>',
	},
	'excluded-dates' => {
		'date-range' => {
			'start' => '<![CDATA[2012-12-26]]>',
			'end' => '<![CDATA[2012-12-26]]>',
		},
	},
	'product-group' => {
		'name' => '<![CDATA[Display Only (Podcast/Vodcast/EchoPlayer). Balanced between file size & quality]]>',
	},
);

my $p = XML::Simple->new(NoAttr => 1, KeyAttr => {});
my $xml = $p->XMLout(\%args, RootName=> 'schedule-rule', NoEscape => 1);	

print "** Creating draft rule\n";
# Add the draft rule
my $rule = $echo360->add("/sections/$section_id/schedule-rules", $xml);

print "** Associating a room to rule\n";
# Associate to a room
my $room = $echo360->get(URI => 'rooms', MATCH => "^$room_name\$");
my $ret = $echo360->update("/schedule-rules/$rule->{id}/rooms/$room->{$room_name}{id}");

print "** Associating a presenter to rule\n";
# Associate to a presenter
my $person = $echo360->get(URI => 'people', PARAMS => "term=$presenter_name");
$ret = $echo360->update("/schedule-rules/$rule->{id}/presenters/$person->{id}");

# Update the status to complete
$args{status} = '<![CDATA[completed]]>';
$xml = $p->XMLout(\%args, RootName=> 'schedule-rule', NoEscape => 1);	
$rule = $echo360->update("/schedule-rules/$rule->{id}", $xml);
print "** Updated the status to completed\n";
#print Dumper $rule;

# Update the status to complete
$args{status} = '<![CDATA[active]]>';
$xml = $p->XMLout(\%args, RootName=> 'schedule-rule', NoEscape => 1);	
$rule = $echo360->update("/schedule-rules/$rule->{id}", $xml);
print "** Updated the status to active\n";

