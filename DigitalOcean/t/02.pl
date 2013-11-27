#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

unless($ENV{API_KEY} and $ENV{CLIENT_ID}) {
	plan skip_all => 'API_KEY and CLIENT_ID not set';
}
else {
	plan tests => 1;
}

BEGIN {
    use_ok( 'DigitalOcean' ) || print "Bail out!\n";
}

my $do = DigitalOcean->new(client_id=> $ENV{CLIENT_ID}, api_key => $ENV{API_KEY});
my $droplets = $do->droplets;

isa_ok( $droplets , 'ARRAY' );

