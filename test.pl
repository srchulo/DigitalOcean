#!/usr/bin/perl
use strict;
use lib './lib';

use DigitalOcean;

=head
my $hash = {
                                       'features' => [
                                                       'private_networking',
                                                       'backups',
                                                       'ipv6',
                                                       'metadata'
                                                     ],
                                       'slug' => 'sfo1',
                                       'name' => 'San Francisco 1',
                                       'sizes' => [
                                                    '32gb',
                                                    '16gb',
                                                    '2gb',
                                                    '1gb',
                                                    '4gb',
                                                    '8gb',
                                                    '512mb',
                                                    '64gb',
                                                    '48gb'
                                                  ],
                                       'available' => bless( do{\(my $o = 1)}, 'JSON::PP::Boolean' ),
                                     }; 
#my $reg = DigitalOcean::Region->new($hash);

#print $reg->slug . "\n";

my $net = DigitalOcean::Networks->new(v4 => [{
                                                                 'gateway' => '198.199.108.1',
                                                                                                                  'type' => 'public',
                                                                                                                                                                   'netmask' => '255.255.255.0',
                                                                                                                                                                                                                    'ip_address' => '198.199.108.65'
                                                                                                                                                                                                                                                                   }]);

                                                                                                                                                                                                                                        

print $net->v4->[0]->gateway;


exit;
=cut
my $do = DigitalOcean->new(oauth_token => 'a4a582d91e8585d481f1c4388c73e66a7c299ffbbaeffd85d54cb03db502eb9c');
$do->per_page(1);


my $droplets = $do->droplets;

for my $droplet (@$droplets) { 
    print $droplet->name . "\n";
    print "\tcreated at: " . $droplet->image->created_at . "\n";
}

print "LR TOTAL: " . $do->last_response->meta->total . "\n";

exit;

my $droplet = $do->droplet(207673);

print "size slug: " . $droplet->size_slug . "\n";

for my $net (@{$droplet->networks->v4})  { 
    print "@{[$net->ip_address]}\n";
    print "@{[$net->netmask]}\n";
    print "@{[$net->gateway]}\n";
    print "@{[$net->type]}\n";
}


print "v6:\n";
for my $net (@{$droplet->networks->v6})  { 
    print "@{[$net->ip_address]}\n";
    print "@{[$net->netmask]}\n";
    print "@{[$net->gateway]}\n";
    print "@{[$net->type]}\n";
}



exit;


print "Droplet id: @{[$droplet->id]}\n";

#$do->droplet(5572725);

#my $image = DigitalOcean::Image->new(DigitalOcean => $do, slug => undef, image => DigitalOcean::Image->new(DigitalOcean=>$do));
#my $image = DigitalOcean::Image->new(DigitalOcean => $do, slug => undef, image =>  { DigitalOcean=>$do });

#print "@{[$image->slug]}\n";
#print "@{[$image->DigitalOcean->oauth_token]}\n";
