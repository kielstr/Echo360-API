#!/usr/bin/perl -w

use strict;
use FindBin qw($Bin);
use lib "$Bin/lib";
use Net::OAuth;
use Data::Dumper;
use LWP::UserAgent;
use XML::Simple;
#$Net::OAuth::PROTOCOL_VERSION = Net::OAuth::PROTOCOL_VERSION_1_0A;

$ENV{PERL_LWP_SSL_VERIFY_HOSTNAME} = 0;

my $key = "123456";
my $secret = "7H/An2m9/oQV/znA6oqTFibhz8DiuOdw89Z6fCYM96YzuvSkmeDl2ODbEUUmHmDr6ZIZN2Frdv8BHVLdUF2V+Q==";
my $url= "https://ecessqa01.csumain.csu.edu.au:8443/ess/scheduleapi/v1";


int @ARGV > 1 and my $format = shift || 'xml';

my $uri = shift;

my $ua = LWP::UserAgent->new;

my $request = Net::OAuth->request('request token')->new (
	consumer_key => $key,
	consumer_secret => $secret,
#       request_url => "$url/courses/ebd0c81e-e9a5-460c-aa41-f9bb0a02ab2d/sections?term=DBtuningtest",

# The following is for drilling down from terms->courses->sections for the creation of a section
#	request_url => "$url/terms?term=201290",
#	request_url => "$url/terms/68f989e7-57b7-4e14-a673-71ad28a3e49f/courses?term=DBtuningtest",
                            
#	request_url => "$url/courses/ebd0c81e-e9a5-460c-aa41-f9bb0a02ab2d/sections?term=DBtuningtest",
#	request_url => "$url/terms?term=201290",
	request_url => "$url/$uri",
	request_method => 'GET',
	signature_method => 'HMAC-SHA1',
	timestamp => time,
	nonce => 'hsu94j3884jdopsl',
	callback => '',
);

$request->sign;
my $res = $ua->get($request->to_url);
my $xml = XML::Simple->new(NoAttr => 1, KeyAttr => {});

if ($res->is_success) {
	my $ret = $xml->XMLin($res->content);
	
	print (($format eq 'xml') ? $xml->XMLout($ret) : Dumper $ret);
	
} else {
	print Dumper $res;
	die "failed";
}
