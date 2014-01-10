#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

unless($ENV{API_KEY} and $ENV{CLIENT_ID}) {
	plan skip_all => 'API_KEY and CLIENT_ID not set';
}

use_ok( 'DigitalOcean' ) || print "Bail out!\n";

my $do = DigitalOcean->new(client_id=> $ENV{CLIENT_ID}, api_key => $ENV{API_KEY}, wait_on_events => 1);
my $domain_name = 'test-' . time() . '-' . int(rand(100)) . '.com';
my $ip = '127.0.0.1';

my $domain = $do->create_domain(
				name => $domain_name,
				ip_address => $ip,
			  );

isa_ok($domain, 'DigitalOcean::Domain');

#get domain
$domain = $do->domain($domain->id);
isa_ok($domain, 'DigitalOcean::Domain');

#add domain record
my $record = $domain->create_record( 
				domain_id => $domain->id,
				record_type => 'A',
				data => '127.0.0.1',
				name => "subdomain.$domain_name",
			 );

isa_ok($record, 'DigitalOcean::Domain::Record');

#get domain records
my $records = $domain->records;

for(@{$records}) { 
	isa_ok($_, 'DigitalOcean::Domain::Record');
}


#get specific domain record
$record = $domain->record($record->id);
isa_ok($record, 'DigitalOcean::Domain::Record');

#edit domain record
$record->edit( 
				record_type => 'A',
				data => '127.0.1.1',
				name => "subdomain.test.com",
			 );

ok($record->data eq '127.0.1.1', 'Data successfully updated');
ok($record->name eq 'subdomain.test.com', 'Name successfully updated');

#destroy domain record
$domain->destroy;

done_testing(7 + @{$records});
