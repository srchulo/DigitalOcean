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

#    my $ssh_key = $do->create_ssh_key(
#        name => 'neww_ssh_key',
#        public_key => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAQQDDHr/jh2Jy4yALcK4JyWbVkPRaWmhck3IgCoeOO3z1e2dBowLh64QAM+Qb72pxekALga2oi4GvT+TlWNhzPH4Z example',
#    );

#my $ssh_key = $do->ssh_key(908682);
my $ssh_key = $do->ssh_key('7b:51:c4:1c:b3:b0:c7:0b:ba:e2:c9:ff:35:f0:e8:dd');


my $true =$ssh_key->delete;
print "$true\n";
exit;

$ssh_key = $ssh_key->update(name => 'srslynewname');

    print "ID " . $ssh_key->id . "\n";
    print "fingerprint " . $ssh_key->fingerprint . "\n";
    print "public_key " . $ssh_key->public_key . "\n";
    print "name " . $ssh_key->name . "\n";

exit;

    $do->per_page(2);

    #set this collection to have 2 objects returned per page
    my $keys_collection = $do->ssh_keys;
    my $obj;

    while($obj = $keys_collection->next) { 
        print $obj->name . "\n";
    }
exit;

my $image = $do->image(12348713);

    my $actions_collection = $image->actions(2);
    my $obj;

    while($obj = $actions_collection->next) { 
        print $obj->id . "\n";
    }
exit;



my $action = $image->convert;

print Data::Dumper->Dump([$action]);
exit;
    #my $true = $image->delete;

    #print "$true\n";
    #exit;

#my $updated_image = $image->update(name => 'DELETE-ME');

#print Data::Dumper->Dump([$updated_image]);
#exit;


    #set this collection to have 2 objects returned per page
    my $actions_collection = $do->user_images;#$image->actions(2);
    my $obj;

    while($obj = $actions_collection->next) { 
        print $obj->name . ' ' . $obj->id . "\n";
    }

exit;

my $image;
    #or

    #my $image = $do->image('ubuntu-14-04-x64');

    print Data::Dumper->Dump([$image]);
    exit;

$do->per_page(20);

    my $images_collection = $do->user_images;
    my $obj;

    while($obj = $images_collection->next) { 
        print $obj->name . "\n";
    }


exit;
    #set this collection to have 2 objects returned per page
    my $images_collection = $do->application_images;
    my $obj;

    while($obj = $images_collection->next) { 
        print $obj->name . "\n";
    }
 



exit;
    my $images_collection = $do->droplets(2);
    my $obj;

    while($obj = $images_collection->next) { 
        print $obj->name . "\n";
    }

exit;

    #set this collection to have 2 objects returned per page
    my $images_collection = $do->images;
    my $obj;

    while($obj = $images_collection->next) { 
        print $obj->name . "\n";
    }
exit;

my $droplet = $do->droplet(1106644);

my $action = $droplet->action(53655017);

print Data::Dumper->Dump([$action]);
exit;

my $action = $droplet->power_cycle(wait_on_action => 1);

print "ID " . $action->id . "\n";
exit;



my $action = $droplet->upgrade;

print $action->id . ' ' . $action->status . "\n";

exit;

    my $actions = $droplet->snapshot_reboot;

    for my $action (@$actions) { 
        print $action->id . ' ' . $action->status . "\n";
    }
exit;

$droplet->power_off(wait_on_action => 1);
my $action = $droplet->snapshot(wait_on_action => 1);

print Data::Dumper->Dump([$droplet]);
exit;
    my $actions = $droplet->enable_private_networking_reboot;

    for my $action (@$actions) { 
        print $action->id . ' ' . $action->status . "\n";
    }

exit;
$droplet->power_off(wait_on_action => 1);
my $action = $droplet->enable_private_networking(wait_on_action => 1);
$droplet->power_on(wait_on_action => 1);
print $action->id . ' ' . $action->status . "\n";
exit;
    my $actions = $droplet->change_kernel_reboot(kernel => 991);

    for my $action (@$actions) { 
        print $action->id . ' ' . $action->status . "\n";
    }
exit;

$droplet->enable_ipv6(wait_on_action => 1);
exit;
$droplet->change_kernel(kernel => 991, wait_on_action => 1);
exit;

$droplet->rename(name => 'dan', wait_on_action => 1);

print 'new name ' . $droplet->name . "\n";

exit;

my $action = $droplet->rebuild(image => 'ubuntu-14-04-x64');

print $action->id . ' ' . $action->status . "\n";

exit;
my $droplet = $do->droplet(5741951);
    my $actions = $droplet->resize_reboot(
        disk => 1,
        size => '1gb', 
    );
    for my $action (@$actions) { 
        print $action->id . ' ' . $action->status . "\n";
    }
    exit;



    $droplet->power_off(wait_on_action => 1);

    my $action = $droplet->resize_reboot(
        disk => 1,
        size => '1gb', 
        wait_on_action => 1,
    );

    $droplet->power_on(wait_on_action => 1);

exit;
$droplet->password_reset(wait_on_action => 1);
exit;
$droplet->restore(image => 12342178, wait_on_action => 1);

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
        wait_on_action => 1,
    );
    exit;



my $droplet = $do->droplet(5735188);
$do->wait_on_actions(1);

my $action = $droplet->disable_backups;

print Data::Dumper->Dump([$action]);

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
        wait_on_action => 1,
    );
    exit;


my $droplet = $do->droplet(5734434);
exit;

my $action = $droplet->disable_backups;

print Data::Dumper->Dump([$action]);


exit;

    my $droplet_upgrades = $do->droplet_upgrades;

    for my $upgrade (@$droplet_upgrades) { 
        print "ID: " . $upgrade->droplet_id . "\n";
        print "Date of migration: " . $upgrade->date_of_migration . "\n";
        print "url " . $upgrade->url . "\n";
        print "\n";
    }

exit;
my $droplet = $do->droplet(207887);

    my $neighbors = $droplet->neighbors;

    print scalar(@$neighbors) . "\n";

    for my $neighbor (@$neighbors) { 
        print $neighbor->name . "\n";
    }

    print Data::Dumper->Dump($neighbors);


exit;
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
