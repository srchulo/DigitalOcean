use strict;
package DigitalOcean;
use Mouse; 

use DigitalOcean::Response;
use DigitalOcean::Droplet;
use DigitalOcean::Meta;
use DigitalOcean::Links;
use DigitalOcean::Collection;
use DigitalOcean::Account;
use DigitalOcean::Action;
use DigitalOcean::Domain;

#for requesting
use LWP::UserAgent;
use LWP::Protocol::https;

#for dealing with JSON
use JSON::XS;

#for printing pretty deaths
use Data::Dumper qw//;

#DigitalOcean packages
use DigitalOcean::Error;

#ABSTRACT: An OO interface to the Digital Ocean API (v2).

has oauth_token => ( 
    is => 'rw',
    isa => 'Str',
    required => 1,
);

has ua => ( 
    is  => 'ro', 
    isa => 'LWP::UserAgent', 
    required    => 0, 
    default => sub { LWP::UserAgent->new },
);

has api => (
    is => 'ro',
    isa => 'Str',
    default => 'https://api.digitalocean.com/v2/',
    required => 0,
);

=method ratelimit_limit

Returns the number of requests that can be made per hour. See L<here|https://developers.digitalocean.com/documentation/v2/#rate-limit> for more details.

=cut

has ratelimit_limit => (
    is => 'rw',
);

=method ratelimit_remaining

Returns the number of requests that remain before you hit your request limit. See L<here|https://developers.digitalocean.com/documentation/v2/#rate-limit> for more details.

=cut

has ratelimit_remaining => (
    is => 'rw',
);

=method ratelimit_reset

This returns the time when the oldest request will expire. The value is given in Unix epoch time. See L<here|https://developers.digitalocean.com/documentation/v2/#rate-limit> for more details.

=cut

has ratelimit_reset => (
    is => 'rw',
);

#define constants for HTTP request types
use constant {
    GET => 'GET',
    DELETE => 'DELETE',
    PUT => 'PUT',
    POST => 'POST',
    HEAD => 'HEAD',
};

=method die_pretty

This method controls how L<DigitalOcean> will die when it receives an error from the Digital Ocean API.
If it is set to 1, then L<DigitalOcean> will die with a string representation of a L<DigitalOcean::Error> object. 
This is useful for debugging and seeing immediately what caused the error. If it is set to undef, then L<DigitalOcean> 
will die with a L<DigitalOcean::Error> object instead of its string representation. This is useful if you want to 
handle the returned error programmatically. The default is 1.

    $do->die_pretty(undef); #when a Digital Ocean API error is received, will die with DigitalOcean::Error object

    $do->die_pretty(1); #when a Digital Ocean API error is received, will die with the string representation of the DigitalOcean::Error object

    my $droplets;
    try { 
        $droplets = $do->droplets;
    }
    catch { 
        my $do_error = $_;

        if($do_error->status_code >= 400 and $do_error->status_code < 500) { 
            print "probably an issue with the request...\n";
        }
        elsif($do_error->status_code >= 500) {
            print "probably an issue with the Digital Ocean API...\n"; 
        }
        if($do_error->status_code >= 200 and $do_error->status_code < 300) { 
            print "this should not have been an error...\n";
        }
        else { 
            print "not sure what the error means...\n";
        }

        print "id: " . $do_error->id . "\n";
        print "message: " . $do_error->message . "\n";
        print "status_code: " . $do_error->status_code . "\n";
        print "status_message: " . $do_error->status_message . "\n";
        print "status_line: " . $do_error->status_line . "\n";
    }

=cut 

has die_pretty => ( 
    is => 'rw',
    isa => 'Bool',
    default => 1, 
);

=method last_response

This method returns the last L<DigitalOcean::Response> from the most recent API request. This contains useful information about
the request, such as the L<DigitalOcean::Response's status_code|DigitalOcean::Response/"status_code"> or the L<DigitalOcean::Meta> object.
It returns undef if no API requests have been made yet. 

    my $last_response = $do->last_response;

    my $status_code = $do->status_code;
    print "Status code from last response $status_code\n";

    my $status_message = $do->status_message;
    print "Status message from last response $status_message\n";

    my $total = $do->meta->total;
    print "Total objects returned in last response $total\n";

=cut

has last_response => (
    is => 'rw',
    isa => 'Undef|DigitalOcean::Response',
    default => undef,
);

=method per_page

This method can force pagination to a certain value instead of the default value of 25 when requesting collections.

    #now 2 items will be returned per page for collections
    $do->per_page(2);

The default is undef, which just means that the Digital Ocean API's default will be used.

=cut

has per_page => (
    is => 'rw',
    isa =>'Undef|Int',
    default => undef,
);

sub _request { 
    my $self = shift;
    my (%args) = @_;
    my ($req_method, $path, $params, $req_body_hash, $per_page) = ($args{req_method}, $args{path}, $args{params}, $args{req_body_hash}, $args{per_page});
    
    #create request
    my $uri = URI->new($self->api . $path);

    $params->{per_page} = $per_page ? $per_page : $self->per_page;
    delete $params->{per_page} unless $params->{per_page}; #only put in url if a value was stored

    $uri->query_form($params);
    print "REQUESTING " . $uri->as_string . "\n";

    my $req = HTTP::Request->new(
        $req_method,
        $uri,
    );

    #add authentication
    $req->header(Authorization => 'Bearer ' . $self->oauth_token);

    #set body content
    if($req_body_hash) {
        #set json header
        $req->header('Content-Type' => 'application/json');

        #put json in body
        my $json_coder = JSON::XS->new->ascii->allow_nonref;
        my $req_body = $json_coder->encode($req_body_hash);
        $req->content($req_body);
    }

    my $response = $self->ua->request($req);
    my $json;
    if($response->content) {
        $json = JSON::XS->new->utf8->decode($response->content);

        #TEMPORARY
        my $coder = JSON::XS->new->ascii->pretty->allow_nonref;
        my $pretty_printed_unencoded = $coder->encode ($json);
        print "$pretty_printed_unencoded\n";

        #die with DigitalOcean::Error
        if($response->code < 200 or $response->code >= 300) {
            my $do_error = DigitalOcean::Error->new(
                id => $json->{id},
                message => $json->{message},
                status_code => $response->code,
                status_message => $response->message,
                status_line => $response->status_line,
            );

            die $self->die_pretty ? Data::Dumper->Dump([$do_error, $self]) : $do_error;
        }

    }

    my $do_response = DigitalOcean::Response->new(
        json => $json,
        status_code => $response->code,
        status_message => $response->message,
        status_line => $response->status_line,
    );

    if($json) {
        #add meta object if one was passed back
        $do_response->meta(DigitalOcean::Meta->new(%{$json->{meta}})) if $json->{meta};

        #add links object if one was passed back
        $do_response->links(DigitalOcean::Links->new(%{$json->{links}})) if $json->{links};
    }

    $self->last_response($do_response);

    #parse ratelimit headers
    $self->ratelimit_limit($response->header('RateLimit-Limit'));
    $self->ratelimit_remaining($response->header('RateLimit-Remaining'));
    $self->ratelimit_reset($response->header('RateLimit-Reset'));

    return $do_response;
}

sub _GET { 
    my $self = shift;
    my (%args) = @_;
    $args{req_method} = GET;

    return $self->_request(%args);
}

sub _POST { 
    my $self = shift;
    my (%args) = @_;
    $args{req_method} = POST;

    return $self->_request(%args);
}

sub _DELETE { 
    my $self = shift;
    my (%args) = @_;
    $args{req_method} = DELETE;

    return $self->_request(%args);
}

sub _PUT { 
    my $self = shift;
    my (%args) = @_;
    $args{req_method} = PUT;

    return $self->_request(%args);
}

sub _decode { 
    my ($self, $type, $json, $key) = @_;
    my $attrs = $key ? $json->{$key} : $json;
    $attrs->{DigitalOcean} = $self;
    return $type->new($attrs);
}

sub _decode_many { 
    my ($self, $type, $arr) = @_;
    [map { $self->_decode($type, $_) } @{$arr}];
}

=method get_user_information

Returns a L<DigitalOcean::Account> object.

    my $account = $do->get_user_information;

    print "Droplet limit: " . $account->droplet_limit . "\n";
    print "Email: " . $account->email . "\n";
    print "uuid: " . $account->uuid . "\n";
    print "Email Verified: " . $account->email_verified . "\n";

=cut

sub get_user_information {
    my ($self) = @_;

    my $do_response = $self->_GET(path => "account");
    return $self->_decode('DigitalOcean::Account', $do_response->json, 'account');
}

sub _get_collection { 
    my ($self, $path, $type_name, $json_key, $per_page, $init_objects) = @_;

    my $do_response = $self->_GET(path => $path, per_page => $per_page);

    return DigitalOcean::Collection->new (
        DigitalOcean => $self,
        type_name => $type_name,
        json_key => $json_key,
        per_page => $per_page,
        response => $do_response,
        init_objects => $init_objects,
    );
}

sub _get_object { 
    my ($self, $path, $type_name, $json_key) = @_;

    my $do_response = $self->_GET(path => $path);
    return $self->_decode($type_name, $do_response->json, $json_key);
}

sub _put_object { 
    my ($self, $path, $type_name, $json_key, $req_body_hash) = @_;

    my $do_response = $self->_PUT(path => $path, req_body_hash => $req_body_hash);
    return $self->_decode($type_name, $do_response->json, $json_key);
}

sub _create { 
    my ($self, $path, $type_name, $json_key, $req_body_hash) = @_;

    my $do_response = $self->_POST(path => $path, req_body_hash => $req_body_hash);
    return $self->_decode($type_name, $do_response->json, $json_key);
}

sub _delete { 
    my $self = shift;
    my (%args) = @_;
    my $do_response = $self->_DELETE(%args);

    return $do_response->status_code == 204;
}

=method actions
 
This will return a L<DigitalOcean::Collection> that can be used to iterate through the L<DigitalOcean::Action> objects of the actions collection. 
 
    my $actions_collection = $do->actions;
    my $obj;

    while($obj = $actions_collection->next) { 
        print $obj->id . "\n";
    }

If you would like a different C<per_page> value to be used for this collection instead of L</per_page>, it can be passed in as a parameter:

    #set default for all collections to be 30
    $do->per_page(30);

    #set this collection to have 2 objects returned per page
    my $actions_collection = $do->actions(2);
    my $obj;

    while($obj = $actions_collection->next) { 
        print $obj->id . "\n";
    }
 
=cut

sub actions {
    my ($self, $per_page) = @_;
    return $self->_get_collection('actions', 'DigitalOcean::Action', 'actions', $per_page);
}

=method action

This will retrieve an action by id and return a L<DigitalOcean::Action> object.

    my $action = $do->action(56789);

=cut

sub action {
    my ($self, $id) = @_;

    return $self->_get_object("actions/$id", 'DigitalOcean::Action', 'action');
}

=method domains
 
This will return a L<DigitalOcean::Collection> that can be used to iterate through the L<DigitalOcean::Domain> objects of the domains collection. 
 
    my $domains_collection = $do->domains;
    my $obj;

    while($obj = $domains_collection->next) { 
        print $obj->name . "\n";
    }

If you would like a different C<per_page> value to be used for this collection instead of L</per_page>, it can be passed in as a parameter:

    #set default for all collections to be 30
    $do->per_page(30);

    #set this collection to have 2 objects returned per page
    my $domains_collection = $do->domains(2);
    my $obj;

    while($obj = $domains_collection->next) { 
        print $obj->name . "\n";
    }
 
=cut

sub domains {
    my ($self, $per_page) = @_;
    return $self->_get_collection('domains', 'DigitalOcean::Domain', 'domains', $per_page);
}

=method create_domain
 
This will create a new domain and return a L<DigitalOcean::Domain> object. The parameters are:
 
=over 4
 
=item 
 
B<name> Required, String, The domain name to add to the DigitalOcean DNS management interface. The name must be unique in DigitalOcean's DNS system. The request will fail if the name has already been taken.
 
=item
 
B<ip_address> Required, String, This attribute contains the IP address you want the domain to point to.
 
=back
 
    my $domain = $do->create_domain(
        name => 'example.com',
        ip_address => '127.0.0.1',
    );

Keep in mind that, upon creation, the zone_file field will have a value of null until a zone file is generated and propagated through an automatic process on the DigitalOcean servers.
 
=cut
 
sub create_domain {
    my $self = shift;
    my %args = @_;

    my $domain = $self->_create('domains', 'DigitalOcean::Domain', 'domain', \%args);
    $domain->DigitalOcean($self);

    return $domain;
}

=method domain
 
This will retrieve a domain by name and return a L<DigitalOcean::Domain> object.
 
    my $domain = $do->domain('example.com');
     
=cut

sub domain {
    my ($self, $id) = @_;

    my $domain = $self->_get_object("domains/$id", 'DigitalOcean::Domain', 'domain');
    $domain->DigitalOcean($self);

    return $domain;
}

=method create_droplet
 
This will create a new droplet and return a L<DigitalOcean::Droplet> object. The parameters are:
 
=over 4
 
=item 
 
B<name> Required, String, The human-readable string you wish to use when displaying the Droplet name. The name, if set to a domain name managed in the DigitalOcean DNS management system, will configure a PTR record for the Droplet. The name set during creation will also determine the hostname for the Droplet in its internal configuration.

 =item 
 
B<region> Required, String, The unique slug identifier for the region that you wish to deploy in.
 
=item
 
B<size> Required, String, The unique slug identifier for the size that you wish to select for this Droplet.
 
=item
 
B<image> Required, number (if using an image ID), or String (if using a public image slug), The image ID of a public or private image, or the unique slug identifier for a public image. This image will be the base image for your Droplet.
 
=item
 
B<ssh_keys> Optional, Array Reference, An array reference containing the IDs or fingerprints of the SSH keys that you wish to embed in the Droplet's root account upon creation.
 
=item
 
B<backups> Optional, Boolean, A boolean indicating whether automated backups should be enabled for the Droplet. Automated backups can only be enabled when the Droplet is created.
 
=item
 
B<ipv6> Optional, Boolean, A boolean indicating whether IPv6 is enabled on the Droplet.

=item
 
B<private_networking> Optional, Boolean, A boolean indicating whether private networking is enabled for the Droplet. Private networking is currently only available in certain regions.

=item
 
B<user_data> Optional, String, A string of the desired User Data for the Droplet. User Data is currently only available in regions with metadata listed in their features.
 
=back
 
    my $new_droplet = $do->create_droplet(
        name => 'new_droplet',
        region => $region,
        size => $size,
        image => $image,
    );
 
=cut

sub create_droplet {
    my $self = shift;
    my %args = @_;

    my $droplet = $self->_create('droplets', 'DigitalOcean::Droplet', 'droplet', \%args);
    $droplet->DigitalOcean($self);

    return $droplet;
}

=method droplet

This will retrieve a droplet by id and return a L<DigitalOcean::Droplet> object.

    my $droplet = $do->droplet(56789);

=cut

sub droplet {
    my ($self, $id) = @_;

    my $droplet = $self->_get_object("droplets/$id", 'DigitalOcean::Droplet', 'droplet');
    $droplet->image->DigitalOcean($self);

    return $droplet;
}

=method droplets
 
This will return a L<DigitalOcean::Collection> that can be used to iterate through the L<DigitalOcean::Droplet> objects of the droplets collection. 
 
    my $droplets_collection = $do->droplets;
    my $obj;

    while($obj = $droplets_collection->next) { 
        print $obj->name . "\n";
    }

If you would like a different C<per_page> value to be used for this collection instead of L</per_page>, it can be passed in as a parameter:

    #set default for all collections to be 30
    $do->per_page(30);

    #set this collection to have 2 objects returned per page
    my $droplets_collection = $do->droplets(2);
    my $obj;

    while($obj = $droplets_collection->next) { 
        print $obj->name . "\n";
    }
 
=cut

sub droplets {
    my ($self, $per_page) = @_;
    return $self->_get_collection('droplets', 'DigitalOcean::Droplet', 'droplets', $per_page);
}

__PACKAGE__->meta->make_immutable();

1;
