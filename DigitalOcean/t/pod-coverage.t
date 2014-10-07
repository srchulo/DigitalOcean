#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

# Ensure a recent version of Test::Pod::Coverage
my $min_tpc = 1.08;
eval "use Test::Pod::Coverage $min_tpc";
plan skip_all => "Test::Pod::Coverage $min_tpc required for testing POD coverage"
    if $@;

# Test::Pod::Coverage doesn't require a minimum Pod::Coverage version,
# but older versions don't recognize some common documentation styles
my $min_pc = 0.18;
eval "use Pod::Coverage $min_pc";
plan skip_all => "Pod::Coverage $min_pc required for testing POD coverage"
    if $@;

my $words = join '|', qw(
		DigitalOcean
		Domain
		ssh_pub_key
		data
		domain_id
		record_type
		weight
		id
		name
		port
		slug
		priority
		error
		live_zone_file
		ttl
		zone_file_with_error
		backups
		backups_active
		created_at
		image_id
		ip_address
		locked
		private_ip_address
		region_id
		size_id
		snapshots
		status
		action_status
		droplet_id
		event_type_id
		percentage
		distribution
);


all_pod_coverage_ok( {
	also_private => [ qr/^($words)$/ ], });
