#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

unless($ENV{API_KEY} and $ENV{CLIENT_ID} and $ENV{LOL}) {
	plan skip_all => 'API_KEY and CLIENT_ID not set';
}
else {
	plan tests => 6;
}

use_ok( 'DigitalOcean' ) || print "Bail out!\n";

my $do = DigitalOcean->new(client_id=> $ENV{CLIENT_ID}, api_key => $ENV{API_KEY}, wait_on_events => 1);

my $sizes = $do->sizes;
my $regions = $do->regions;
my $images = $do->images;

my $size_id = $sizes->[0]->id;
my $resize_id = $sizes->[1]->id;
my $region_id = $regions->[0]->id;

#get last image since user created images come first in array
#and may not be available in the region we chose
my $image_id = $images->[-1]->id;

my $droplet_name = 'test-' . time() . '-' . int(rand(100));

my $droplet = $do->create_droplet(
	name => $droplet_name,
    size_id => $size_id,
    image_id => $image_id,
    region_id => $region_id,
);

isa_ok($droplet, 'DigitalOcean::Droplet');

#snapshot
ok(($droplet->snapshot_reboot)->isa("DigitalOcean::Event"), 'Snapshot successfully taken');

my $snapshot_id = @{$droplet->snapshots}[0]->{id};
my $image = $do->image($snapshot_id);

isa_ok($image, "DigitalOcean::Image");

#transfer image
my $new_region_id = $regions->[1]->id;
ok(($image->transfer(region_id => $new_region_id))->isa("DigitalOcean::Event"), 'Image successfully transferred');

#destroy image
$image->destroy;

ok(($droplet->destroy)->isa("DigitalOcean::Event"), 'Droplet sucessfully destroyed');
