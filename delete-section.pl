#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/lib";
use Echo360;
use Data::Dumper;

my $term_name = shift || die "No term";
my $course_name = shift || die "No course";

my $echo360 = Echo360->new(
	USERNAME => 'kiel-test',
	KEY => '123456',
	SECRET => '7H/An2m9/oQV/znA6oqTFibhz8DiuOdw89Z6fCYM96YzuvSkmeDl2ODbEUUmHmDr6ZIZN2Frdv8BHVLdUF2V+Q==',
	URL => 'https://ecessqa01.csumain.csu.edu.au:8443/ess/scheduleapi/v1',
); 

my $term = $echo360->get(URI => 'terms', PARAMS => "term=$term_name");
die "Could not find term $term_name" unless $term;

my $course = $echo360->get(URI => 'courses', PARAMS => "term=$course_name");
die "Could not find course $course_name" unless $course;

my $section = $echo360->get(URI => "/terms/$term->{id}/courses/$course->{id}/sections");
die "Could not find section for term $term_name course $course_name" unless $section;

$echo360->delete("/sections/$section->{section}{id}");
