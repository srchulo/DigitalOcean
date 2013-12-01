#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

unless($ENV{API_KEY} and $ENV{CLIENT_ID}) {
	plan skip_all => 'API_KEY and CLIENT_ID not set';
}

use_ok( 'DigitalOcean' ) || print "Bail out!\n";

my $do = DigitalOcean->new(client_id=> $ENV{CLIENT_ID}, api_key => $ENV{API_KEY});
my $sizes = $do->sizes;

isa_ok( $sizes , 'ARRAY' );

for(@{$sizes}) { 
	isa_ok($_, 'DigitalOcean::Size');
}

done_testing(2 + @{$sizes});
