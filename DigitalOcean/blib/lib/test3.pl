#!/usr/bin/perl
use DigitalOcean;

my $do = DigitalOcean->new(client_id=> $ENV{CLIENT_ID}, api_key => $ENV{API_KEY}, wait_on_events => 1);

my $domains = $do->domains;

print $_->id . ' ' . $_->name . "\n" for (@{$domains});

print "\n";

my $domain = $do->domain(152031);


print $_->id . ' ' . $_->name . "\n" for (@{$domain->records});

my $record = $domain->record(1068162);
