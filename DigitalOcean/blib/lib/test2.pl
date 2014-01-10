#!/usr/bin/perl
use strict;
use DigitalOcean;

my $do = DigitalOcean->new(client_id=> $ENV{CLIENT_ID}, api_key => $ENV{API_KEY}, wait_on_events => 1);
$do->ssh_keys;
exit;
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


#snapshot
$droplet->snapshot_reboot;

my $snapshot_id = @{$droplet->snapshots}[0]->{id};
my $image = $do->image($snapshot_id);

#transfer image
my $new_region_id = $regions->[1]->id;
$image->transfer(region_id => $new_region_id);

#destroy image
#$image->destroy;

#$droplet->destroy;

exit;
#my $droplet = $do->droplet(207887);

#my $event = $droplet->shutdown;
#print $event->id . "\n";
#exit;

#my $snapshot_id = @{$droplet->snapshots}[0]->{id} . "\n";

#for (@{$do->images}) { 
#	print $_->name . "\n";		
#}

#print ref($droplet->snapshots) . "\n";

#for(@{$droplet->snapshots}) {
#	print $_->{name} . " " . $_->{id} . "\n";
#}

#my $image = $do->image($snapshot_id);

#exit;

#print $do->wait_on_events . "\n";

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

#restore
$droplet->restore(image_id => $image_id);

#rebuild
$droplet->rebuild(image_id => $image_id);

#rename
my $new_droplet_name = "new-$droplet_name";
$droplet->rename(name => $new_droplet_name);
exit;


$droplet->rename(name => 'poopie');

print "NEW NAME " . $droplet->name . "\n";

exit;
$droplet->snapshot_reboot;

my $snapshot_id = @{$droplet->snapshots}[0]->{id};
my $image_to_del = $do->image($snapshot_id);

print $snapshot_id . "\n";
$image_to_del->destroy;

#print $_->{name} . "\n" for (@{$droplet->snapshots});

print "\n";
#my $event = $droplet->snapshot_reboot;

#print $_->{name} . "\n" for (@{$droplet->snapshots});
