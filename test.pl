#!/usr/bin/perl
#use lib './DigitalOcean/lib';
use DigitalOcean;
print "$_\n" for @INC;
my $do = DigitalOcean->new(client_id=> $ENV{CLIENT_ID}, api_key => $ENV{API_KEY});

print $_->name . "\n" for (@{droplets()});

sub droplets {
	return $do->droplets;
}
