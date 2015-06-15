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
#my $droplet = $do->droplet(207887);
my $droplet = $do->droplet(5720084);

my $true = $droplet->delete;

print "$true\n";
exit;

$do->per_page(40);

    #set this collection to have 2 objects returned per page
    my $actions_collection = $droplet->actions;
    my $obj;

    while($obj = $actions_collection->next) { 
        print $obj->id . " " . $obj->type . "\n";
    }

exit;

    my $backups_collection = $droplet->backups(2);
    my $obj;

    while($obj = $backups_collection->next) { 
        print $obj->name . "\n";
    }
exit;

    $do->per_page(1);

    #set this collection to have 2 objects returned per page
    my $snapshots_collection = $droplet->snapshots;
    my $obj;

    my $count = 0;
    print "before\n";
    while($obj = $snapshots_collection->next) { 
        print "NAME: " . $obj->name . "\n";
    }

    print "After\n";
exit;

    $do->per_page(30);

    #set this collection to have 2 objects returned per page
    my $kernels_collection = $droplet->kernels;
    my $obj;

    while($obj = $kernels_collection->next) { 
        print $obj->name . "\n";
    }

    exit;

$do->per_page(2);
my $droplets_collection = $do->droplets;
print "$droplets_collection\n";

print $droplets_collection->total . "\n";

my $next;
while($next = $droplets_collection->next) { 
    print $next->name . "\n";
    print "  " . $next->id . "\n";
}

exit;


my $droplet = $do->droplet(207673);

print Data::Dumper->Dump([$droplet]);
exit;


    my $new_droplet = $do->create_droplet(
        name => 'new-droplet',
        region => 'sfo1',
        size => '512mb',
        image => 'ubuntu-14-04-x64',
        ssh_keys => [887618],
        backups => 1,
        ipv6 => 1,
        private_networking => 1,
    );

print Data::Dumper->Dump([$new_droplet]);

exit;

my $domain = $do->domain('hey.com');

my $true = $domain->delete;
print "$true\n";
exit;

my $record;
print 'id ' . $record->id . "\n";
print 'type ' . $record->type . "\n";
print 'name ' . $record->name . "\n";
print 'data ' . $record->data . "\n";
print 'priority ' . $record->priority . "\n";
print 'port ' . $record->port . "\n";
print 'weight ' . $record->weight . "\n";

my $true = $record->delete;

print "$true\n";
exit;

            $record = $record->update(
                        type => 'A',
                        name => 'lizra',
                                data => '194.87.89.45',
                                    );


print 'id ' . $record->id . "\n";
print 'type ' . $record->type . "\n";
print 'name ' . $record->name . "\n";
print 'data ' . $record->data . "\n";
print 'priority ' . $record->priority . "\n";
print 'port ' . $record->port . "\n";
print 'weight ' . $record->weight . "\n";



exit;
my $r_coll = $domain->records;

my $rec;
while($rec = $r_coll->next) { 
    print $rec->name . " " . $rec->id . "\n";

    if($rec->id == 7110018) { 
            my $record = $rec->update(
                        type => 'A',
                        priority => '6',
                        name => 'heyha',
                                data => '196.87.89.45',
                                    );

print 'id ' . $record->id . "\n";
print 'type ' . $record->type . "\n";
print 'name ' . $record->name . "\n";
print 'data ' . $record->data . "\n";
print 'priority ' . $record->priority . "\n";
print 'port ' . $record->port . "\n";
print 'weight ' . $record->weight . "\n";

                                     
    }
}
exit;

#    my $record = $domain->create_record(
#        type => 'A',
#        name => 'test',
#        data => '196.87.89.45',
#    );

my $record = $domain->record(7096051);

print 'id ' . $record->id . "\n";
print 'type ' . $record->type . "\n";
print 'name ' . $record->name . "\n";
print 'data ' . $record->data . "\n";
print 'priority ' . $record->priority . "\n";
print 'port ' . $record->port . "\n";
print 'weight ' . $record->weight . "\n";
exit;

$do->per_page(2);

    my $records_collection = $domain->records(1);
    my $obj;

    while($obj = $records_collection->next) { 
        print $obj->id . "\n";
        print "   " . $obj->name . "\n";
        print "\n";
    }

exit;

print "name " . $domain->name . "\n";
print "ttl " . $domain->ttl . "\n";
print "zone_file " . $domain->zone_file . "\n";

my $true = $domain->delete;

print "$true\n";

exit;

$do->per_page(2);

    my $domains_collection = $do->domains;
    my $obj;

    while($obj = $domains_collection->next) { 
        print $obj->name . "\n";
    }
exit;




my $domain = $do->create_domain(
            name => 'abcd.nethop.com',
                    ip_address => '127.0.0.1',
);

print "name " . $domain->name . "\n";
print "ttl " . $domain->ttl . "\n";
print "zone_file " . $domain->zone_file . "\n";

exit;
 my $action = $do->action(2266714);
 print "ID " . $action->id . "\n";
 print "status " . $action->status . "\n";
 print "type " . $action->type . "\n";
 print "started_at " . $action->started_at . "\n";
 print "completed_at " . $action->completed_at . "\n";
 print "resource id " . $action->resource_id . "\n";
 print "resource_type " . $action->resource_type . "\n";
 print "region " . $action->region->name . "\n";
 print "region_slug " . $action->region_slug . "\n";
 exit;

$do->per_page(300);

    my $actions_collection = $do->actions;
    my $obj;

    while($obj = $actions_collection->next) { 
        print $obj->id . "\n";
    }

exit;

my $droplets_collection = $do->droplets(3);
print "$droplets_collection\n";

print $droplets_collection->total . "\n";

my $next;
while($next = $droplets_collection->next) { 
    print $next->name . "\n";
    print "  " . $next->id . "\n";
}


print "LR TOTAL: " . $do->last_response->meta->total . "\n";

print "rl limit " . $do->ratelimit_limit . "\n";
print "rl remaining " . $do->ratelimit_remaining . "\n";
print "rl reset " . $do->ratelimit_reset . "\n";

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
