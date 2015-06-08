#!/usr/bin/perl
use lib './lib';

use DigitalOcean;

my $do = DigitalOcean->new(oauth_token => 'a4a582d91e8585d481f1c4388c73e66a7c299ffbbaeffd85d54cb03db502eb9d');

$do->droplet(207673);
