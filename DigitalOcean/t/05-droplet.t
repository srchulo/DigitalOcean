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

my $sizes = $do->sizes;
my $regions = $do->regions;
my $images = $do->images;

my $size_id = $sizes->[0]->id;
my $region_id = $regions->[0]->id;

#get last image since user created images come first in array
#and may not be available in the region we chose
my $image_id = $images->[-1]->id;

my $droplet_name = 'test-' . time();

my $droplet = $do->create_droplet(
	name => $droplet_name,
    size_id => $size_id,
    image_id => $image_id,
    region_id => $region_id,
);

isa_ok($droplet, 'DigitalOcean::Droplet');

#sleep for x time to make sure still not being created?

ok(($droplet->destroy) > 0, 'Droplet sucessfully destroyed');
