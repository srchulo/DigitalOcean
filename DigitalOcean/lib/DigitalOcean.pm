package DigitalOcean;
use strict;
use Mouse;
use DigitalOcean::Types qw (PositiveInt);
use LWP::UserAgent;
use LWP::Protocol::https;
use JSON::XS;
use DigitalOcean::Droplet;
use DigitalOcean::Region;
use DigitalOcean::Size;
use DigitalOcean::Image;
use DigitalOcean::SSH::Key;
use DigitalOcean::Domain;
use DigitalOcean::Event;
use DigitalOcean::Domain::Record;

#use 5.006;
#use warnings FATAL => 'all';

has 'client_id'    => ( is => 'ro', isa => 'Str', required => 1 );
has 'api_key'     => ( is => 'ro', isa => 'Str', required => 1 );

has 'ua' => ( 
	is          => 'ro', 
    isa         => 'LWP::UserAgent', 
    required    => 0, 
	default => sub { LWP::UserAgent->new },
);

has 'time_between_requests' => (
	is => 'rw',
	isa => PositiveInt,
	default => 2,
	required => 0,
);

has 'wait_on_events' => (
	is => 'rw',
	isa => 'Bool',
	default => undef,
	required => 0,
);

has 'api' => (
	is => 'ro',
	isa => 'Str',
	default => 'https://api.digitalocean.com/',
	required => 0,
);

has 'api_obj' => ( 
	is => 'rw',
	isa => 'Any'	
);

has 'caller' => ( 
	is => 'rw',
	isa => 'Any',
	default => undef,	
);

has 'request_append' => ( 
	is => 'rw',
	isa => 'Str',
	default => '',	
);

has 'json_obj_key' => ( 
	is => 'rw',
    isa => 'Any',
    default => undef,
);

my %json_keys = ( 
	'DigitalOcean::droplets' => 'droplets',		
	'DigitalOcean::create_droplet' => 'droplet',		
	'DigitalOcean::droplet' => 'droplet',		
	'DigitalOcean::regions' => 'regions',		
	'DigitalOcean::images' => 'images',		
	'DigitalOcean::image' => 'image',		
	'DigitalOcean::sizes' => 'sizes',		
	'DigitalOcean::ssh_keys' => 'ssh_keys',		
	'DigitalOcean::create_ssh_key' => 'ssh_key',		
	'DigitalOcean::ssh_key' => 'ssh_key',		
	'DigitalOcean::domains' => 'domains',		
	'DigitalOcean::create_domain' => 'domain',		
	'DigitalOcean::domain' => 'domain',		
	'DigitalOcean::event' => 'event',		
	'DigitalOcean::_external_request' => 'event_id',		
);

my %ext_request = ( 
	'DigitalOcean::Droplet' => 'droplets',		
#	'DigitalOcean::Event' => 'events',		
	'DigitalOcean::Image' => 'images',		
	'DigitalOcean::SSH::Key' => 'ssh_keys',		
	'DigitalOcean::Domain' => 'domains',		
);

=head1 NAME

DigitalOcean - An OO interface to the Digital Ocean API.

=head1 VERSION

Version 0.13

=cut

our $VERSION = '0.13';

=head1 SYNOPSIS

This module is an object oriented interface into the Digital Ocean API.

    use DigitalOcean;

    #for more efficient use, remove "wait_on_events => 1". See WAITING ON EVENTS section for more info
    my $do = DigitalOcean->new(client_id=> $client_id, api_key => $api_key, wait_on_events => 1);

    for my $droplet (@{$do->droplets}) { 
        print "Droplet " . $droplet->name . " has id " . $droplet->id . "\n";
    }

    my $droplet = $do->droplet($droplet_id);
    $droplet->reboot;
    $droplet->power_off;
    $droplet->power_on;
    $droplet->destroy;

    my $new_droplet = $do->create_droplet(
        name => 'new_droplet',
        size_id => $size_id,
        image_id => $image_id,
        region_id => $region_id,
    );

    $new_droplet->enable_backups;

=head2 API Key

This module uses version 1 of the Digital::Ocean API, so you will need to generate an API v1
key to use it. The access tokens used by the new API will not work.

=head1 HOW THIS MODULE IS WRITTEN

This module is written to be flexible, so that if changes are made to the Digital Ocean API,
then I don't have to update this module every time they make changes so that this module will
still work. What I mean by this is that if Digital Ocean adds new parameters that need to be
passed into their calls, these parameters can be passed into the current calls even if I don't
specify them as options and it should still work. For example, say that for the L<create_droplet|/"create_droplet">
call Digital Ocean adds a new required parameter "timestamp". All you would have to do is pass in timestamp:

    $do->create_droplet(
        name => 'new_droplet',
        size_id => $size_id,
        image_id => $image_id,
        region_id => $region_id,
        timestamp => $timestamp,
    );

And timestamp will be added to the request call with the other parameters. However, if Digital Ocean adds
any new attributes to an object, such as droplet_type for L<DigitalOcean::Droplet>, this I will have
to add to the L<DigitalOcean::Droplet> in order for the L<DigitalOcean::Droplet> objects to respect
this new attribute. If you see that Digital Ocean has added a new attribute that I do not have in one
of my objects, please let me know in L<bugs|http://rt.cpan.org/NoAuth/Bugs.html?Dist=DigitalOcean>.


=head1 WAITING ON EVENTS

=head2 wait_on_events

For some calls in Digital Ocean's API, you need to wait for one call to finish before you can
submit another request that depends on the first call. For instance, if you resize a droplet
and then want to take a snapshot of the droplet, you must wait until the action of resizing
the droplet is complete before you can take the snapshot of this droplet. If you set wait_on_events
to 1, then L<DigitalOcean> will wait on every event until it is complete, so this way you do not have to worry 
about the synchronization of events or if you need to wait between two events. However,
turning wait_on_events on for every event can also cause your script to run much slower if you do not need
to be waiting on every event.

You may wait on all events by passing in wait_on_events when you create the L<DigitalOcean> object:

    my $do = DigitalOcean->new(client_id=> $client_id, api_key => $api_key, wait_on_events => 1);

Or you can toggle it after you have created the L<DigitalOcean> object:

    $do->wait_on_events(1);
    $do->wait_on_events(undef);

The default for wait_on_events is that it is set to undef and does not wait on events.

=head2 wait_on_event

A more efficient solution is to only wait on indiviudal events that you have to wait on. You can pass in the
wait_on_event flag to any subroutine (this includes subroutines in L<DigitalOcean>'s sub modules, such as
L<DigitalOcean::Droplet>) and L<DigitalOcean> will wait until that call is complete before returning.

    my $droplet = $do->create_droplet(
        name => 'new_droplet',
        size_id => $size_id,
        image_id => $image_id,
        region_id => $region_id,
        wait_on_event => 1,
    );

    $droplet->reboot(wait_on_event => 1);
    $droplet->snapshot(wait_on_event => 1);

    my $domain = $do->domain(56789);
    my $record = $domain->record(98765);

    $record->edit(
        record_type => 'A',
        data => '196.87.89.45',
        wait_on_event => 1,
    );

    etc.

L<DigitalOcean> uses L<DigitalOcean::Event's wait|DigitalOcean::Event/"wait"> subroutine to wait on events.

=head2 time_between_requests

L<DigitalOcean> uses L<DigitalOcean::Event's wait|DigitalOcean::Event/"wait"> subroutine to wait on events. It does
this by making requests to Digital Ocean until the L<event|DigitalOcean::Event> is complete. You can use time_between_requests
to determine how long L<DigitalOcean> waits between requests before making another request to Digital Ocean to see if an event is
done. You can use it like so:

    $do->time_between_requests(1);

or

    my $do = DigitalOcean->new(client_id=> $client_id, api_key => $api_key, time_between_requests => 1);

An integer value must be passed in. The default is 2.

=head1 SUBROUTINES/METHODS

=cut

sub _request { 
	my ($self, $path, $params) = @_;
	
	#see if we need to wait on this individual event
	my $wait_on_event = delete $params->{wait_on_event};

	$params->{client_id} = $self->client_id;
	$params->{api_key} = $self->api_key;

	my $uri = URI->new($self->api . $path);
	$uri->query_form($params);

	my $req = HTTP::Request->new(
		'GET',
		$uri,
	);

	#print "$uri\n";
	my $response = $self->ua->request($req);

	my $caller = $self->caller ? $self->caller : $self->_caller;
	$self->caller(undef);

	my $json = JSON::XS->new->utf8->decode ($response->content);
	my $message = $json->{message} || $json->{error_message};
	die "ERROR $message" if $json->{status} ne 'OK';

	my $obj_key = $self->json_obj_key ? $self->json_obj_key : 
                  $json_keys{$caller} ? $json_keys{$caller} : '';
	$self->json_obj_key(undef);

	#convert all event_id's into Event objects
	my $api_obj;
	my $event_obj;

	if($obj_key eq 'event_id' and exists $json->{$obj_key}) { 
		$api_obj = $self->event($json->{$obj_key});
		$event_obj = $api_obj;
	}
	else { 
		$api_obj = $json->{$obj_key};

		if(ref($json->{$obj_key}) eq 'HASH' and exists $json->{$obj_key}->{event_id}) {
			$event_obj = $self->event($json->{$obj_key}->{event_id});
		}
	}

	#if we have an event object, and we are supposed to return when the api call is complete then wait
	if($event_obj and ($self->wait_on_events or $wait_on_event)) { 
		$event_obj->wait;
	}

	$self->api_obj($api_obj);
}

sub _external_request { 
	my ($self, $id, %params) = @_;
	my $caller = $self->caller ? $self->caller : $self->_caller(1);

	my $package = $self->_package;
	$self->_request("$ext_request{$package}/$id/$caller/" . $self->request_append, \%params);
	$self->request_append('');

	my $api_obj = $self->api_obj;
	return $api_obj;
}

sub _decode { 
	my ($self, $type, $attrs) = @_;
	$attrs = $self->api_obj unless $attrs;
	$attrs->{DigitalOcean} = $self;
	return $type->new(%$attrs);
}

sub _decode_many { 
	my ($self, $type) = @_;
	[map { $self->_decode($type, $_) } @{$self->api_obj}];
}

sub _create { 
	my ($self, $request, $params, $obj) = @_;
	$self->caller($self->_caller);
	$self->_request($request, $params);
	return $self->_decode($obj);
}

sub _caller { 
	my ($self, $just_func) = @_;
	my $caller = (caller(2))[3];
	$caller =~ s/.*:://g if $just_func;
	return $caller;
}

sub _package { (caller(1))[0] }

=head2 droplets

This will return an array reference of L<DigitalOcean::Droplet> objects.

    my $droplets = $do->droplets;
    
    for my $droplet (@{$droplets}) { 
        print $droplet->name . "\n";
    }

=cut

sub droplets {
	my ($self) = @_;
	
	$self->_request('droplets');
	return $self->_decode_many('DigitalOcean::Droplet');
}

=head2 create_droplet

This will create a new droplet and return a L<DigitalOcean::Droplet> object. The parameters are:

=over 4

=item 

B<name> Required, String, this is the name of the droplet - must be formatted by hostname rules

=item

B<size_id> Required, Numeric, this is the id of the size you would like the droplet created at

=item

B<image_id> Required, Numeric, this is the id of the image you would like the droplet created with

=item

B<region_id> Required, Numeric, this is the id of the region you would like your server in

=item

B<ssh_key_ids> Optional, Numeric CSV, comma separated list of ssh_key_ids that you would like to be added to the server

=item

B<private_networking> Optional, Boolean, enables a private network interface if the region supports private networking

=back

    my $new_droplet = $do->create_droplet(
        name => 'new_droplet',
        size_id => $size_id,
        image_id => $image_id,
        region_id => $region_id,
    );

=cut

sub create_droplet {
	my $self = shift;
	my %params = @_;
	return $self->_create('droplets/new', \%params, 'DigitalOcean::Droplet');
}

=head2 droplet

This will retrieve a droplet by id and return a L<DigitalOcean::Droplet> object.

    my $droplet = $do->droplet(56789);

=cut

sub droplet {
	my ($self, $id) = @_;

	$self->_request("droplets/$id");
	return $self->_decode('DigitalOcean::Droplet');
}

=head2 regions

This will return an array reference of L<DigitalOcean::Region> objects.

    my $regions = $do->regions;
    
    for my $region (@{$regions}) { 
        print $region->name . "\n";
    }

=cut

sub regions {
	my ($self) = @_;
	
	$self->_request('regions');
	return $self->_decode_many('DigitalOcean::Region');
}

=head2 images

This will return an array reference of L<DigitalOcean::Image> objects.

    my $images = $do->images;
    
    for my $image (@{$images}) { 
        print $image->name . "\n";
    }

=cut

sub images {
	my ($self) = @_;
	
	$self->_request('images');
	return $self->_decode_many('DigitalOcean::Image');
}

=head2 image

This will retrieve an image by id and return a L<DigitalOcean::Image> object.

    my $image = $do->image(56789);

=cut

sub image {
	my ($self, $id) = @_;

	$self->_request("images/$id");
	return $self->_decode('DigitalOcean::Image');
}

=head2 sizes

This will return an array reference of L<DigitalOcean::Size> objects.

    my $sizes = $do->sizes;
    
    for my $size (@{$sizes}) { 
        print $size->name . "\n";
    }

=cut

sub sizes {
	my ($self) = @_;
	
	$self->_request('sizes');
	return $self->_decode_many('DigitalOcean::Size');
}

=head2 ssh_keys

This will return an array reference of L<DigitalOcean::SSH::Key> objects.

    my $ssh_keys = $do->ssh_keys;
    
    for my $ssh_key (@{$ssh_keys}) { 
        print $ssh_key->name . "\n";
    }

=cut

sub ssh_keys {
	my ($self) = @_;
	
	$self->_request('ssh_keys');
	return $self->_decode_many('DigitalOcean::SSH::Key');
}

=head2 create_ssh_key

This will create a new ssh key and return a L<DigitalOcean::SSH::Key> object. The parameters are:

=over 4

=item 

B<name> Required, String, the name you want to give this SSH key.

=item

B<ssh_pub_key> Required, String, the actual public SSH key.

=back

    my $new_ssh_key = $do->create_ssh_key(
        name => 'new_ssh_key',
        ssh_pub_key => $ssh_pub_key,
    );

=cut

sub create_ssh_key {
	my $self = shift;
	my %params = @_;
	return $self->_create('ssh_keys/new', \%params, 'DigitalOcean::SSH::Key');
}

=head2 ssh_key

This will retrieve an ssh_key by id and return a L<DigitalOcean::SSH::Key> object.

    my $ssh_key = $do->ssh_key(56789);

=cut

sub ssh_key {
	my ($self, $id) = @_;

	$self->_request("ssh_keys/$id");
	return $self->_decode('DigitalOcean::SSH::Key');
}

=head2 domains

This will return an array reference of L<DigitalOcean::Domain> objects.

    my $domains = $do->domains;
    
    for my $domain (@{$domains}) { 
        print $domain->name . "\n";
    }

=cut

sub domains {
	my ($self) = @_;
	
	$self->_request('domains');
	return $self->_decode_many('DigitalOcean::Domain');
}

=head2 create_domain

This will create a new domain and return a L<DigitalOcean::Domain> object. The parameters are:

=over 4

=item 

B<name> Required, String, the domain name

=item

B<ip_address> Required, String, IP address for the domain's initial A record.

=back

    my $domain = $do->create_domain(
        name => 'example.com',
        ip_address => '127.0.0.1',
    );

=cut

sub create_domain {
	my $self = shift;
	my %params = @_;
	return $self->_create('domains/new', \%params, 'DigitalOcean::Domain');
}

=head2 domain

This will retrieve a domain by id and return a L<DigitalOcean::Domain> object.

    my $domain = $do->domain(56789);

=cut

sub domain {
	my ($self, $id) = @_;

	$self->_request("domains/$id");
	return $self->_decode('DigitalOcean::Domain');
}

=head2 event

This will retrieve an event by id and return a L<DigitalOcean::Event> object.

    my $event = $do->event(56789);

=cut

sub event {
	my ($self, $id) = @_;

	$self->_request("events/$id");
	return $self->_decode('DigitalOcean::Event');
}

=head1 AUTHOR

Adam Hopkins, C<< <srchulo at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-webservice-digitalocean at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=DigitalOcean>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc DigitalOcean


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=DigitalOcean>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/DigitalOcean>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/DigitalOcean>

=item * Search CPAN

L<http://search.cpan.org/dist/DigitalOcean/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2013 Adam Hopkins.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of DigitalOcean
