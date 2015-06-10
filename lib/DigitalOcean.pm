use strict;
package DigitalOcean;
use Mouse; 

use DigitalOcean::Response;
use DigitalOcean::Droplet;
use DigitalOcean::Meta;
use DigitalOcean::Links;
use DigitalOcean::Collection;
use DigitalOcean::Account;

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
    my ($req_method, $path, $params, $req_body, $per_page) = ($args{req_method}, $args{path}, $args{params}, $args{req_body}, $args{per_page});
    
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
    $req->content($req_body);

    my $response = $self->ua->request($req);
    my $json = JSON::XS->new->utf8->decode($response->content);

    #TEMPORARY
    my $coder = JSON::XS->new->ascii->pretty->allow_nonref;
    my $pretty_printed_unencoded = $coder->encode ($json);
    #print "$pretty_printed_unencoded\n";

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


    #print Data::Dumper->Dump([$json]);
    #print "\n";

    #parse ratelimit headers
    $self->ratelimit_limit($response->header('RateLimit-Limit'));
    $self->ratelimit_remaining($response->header('RateLimit-Remaining'));
    $self->ratelimit_reset($response->header('RateLimit-Reset'));

    my $do_response = DigitalOcean::Response->new(
        json => $json,
        status_code => $response->code,
        status_message => $response->message,
        status_line => $response->status_line,
    );

    #add meta object if one was passed back
    $do_response->meta(DigitalOcean::Meta->new(%{$json->{meta}})) if $json->{meta};

    #add links object if one was passed back
    $do_response->links(DigitalOcean::Links->new(%{$json->{links}})) if $json->{links};

    $self->last_response($do_response);

    return $do_response;
}

sub _GET { 
    my $self = shift;
    my (%args) = @_;
    $args{req_method} = GET;

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

=method droplet

This will retrieve a droplet by id and return a L<DigitalOcean::Droplet> object.

    my $droplet = $do->droplet(56789);

=cut

sub droplet {
    my ($self, $id) = @_;

    my $do_response = $self->_GET(path => "droplets/$id");
    my $droplet = $self->_decode('DigitalOcean::Droplet', $do_response->json, 'droplet');

    $droplet->image->DigitalOcean($self);

    return $droplet;
}

=head2 droplets
 
This will return L<DigitalOcean::Collection> that can be used to iterate through the objects of the collection. 
 
    my $droplets_collection = $do->droplets;
    my $obj;

    while($obj = $droplets_collection) { 
        print $obj->name . "\n";
    }

If you would like a different C<per_page> value to be used for this collection instead of L</per_page>, it can be passed in as a parameter:

    #set default for all collections to be 30
    $do->per_page(30);

    #set this collection to have 2 objects returned per page
    my $droplets_collection = $do->droplets(2);
    my $obj;

    while($obj = $droplets_collection) { 
        print $obj->name . "\n";
    }
 
=cut

sub droplets {
    my ($self, $per_page) = @_;
    my ($type_name, $json_key) = ('DigitalOcean::Droplet', 'droplets');

    my $do_response = $self->_GET(path => "droplets", per_page => $per_page);

    my $do_collection = DigitalOcean::Collection->new (
        DigitalOcean => $self,
        type_name => $type_name,
        json_key => $json_key,
        per_page => $per_page,
        response => $do_response,
    );

    return $do_collection;
}

__PACKAGE__->meta->make_immutable();

1;
