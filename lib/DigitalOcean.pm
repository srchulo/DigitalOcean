use strict;
package DigitalOcean;
use Mouse; 

use DigitalOcean::Response;
use DigitalOcean::Droplet;

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

has ratelimit_limit => (
    is => 'rw',
);

has ratelimit_remaining => (
    is => 'rw',
);

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

sub _request { 
    my ($self, $req_method, $path, $params, $req_body) = @_;
    
    #create request
    my $uri = URI->new($self->api . $path);
    $uri->query_form($params);

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
    print "$pretty_printed_unencoded\n";

    #die with DigitalOcean::Error
    if($response->code < 200 or $response->code >= 300) {
        my $do_error = DigitalOcean::Error->new(
            id => $json->{id},
            message => $json->{message},
            status_code => $response->code,
            status_message => $response->message,
            status_line => $response->status_line,
            DigitalOcean => $self,
        );

        die $self->die_pretty ? Data::Dumper->Dump([$do_error]) : $do_error;
    }


    print Data::Dumper->Dump([$json]);
    print "\n";

    #parse ratelimit vars

    #do something with meta and links?

    DigitalOcean::Response->new(
        json => $json,
        status_code => $response->code,
        status_message => $response->message,
        status_line => $response->status_line,
        DigitalOcean => $self,     
    );
}

sub _GET { 
    my ($self, $path) = @_;

    return $self->_request(GET, $path);
}

sub _decode { 
    my ($self, $type, $key, $json) = @_;
    my $attrs = $json->{$key};
    $attrs->{DigitalOcean} = $self;
    return $type->new($attrs);
}

sub _decode_many { 
#   my ($self, $type, $key, $json) = @_;
#    [map { $self->_decode($type, $_) } @{$self->api_obj}];
}

=method droplet

This will retrieve a droplet by id and return a L<DigitalOcean::Droplet> object.

    my $droplet = $do->droplet(56789);

=cut

sub droplet {
    my ($self, $id) = @_;

    my $do_response = $self->_GET("droplets/$id");
    my $droplet = $self->_decode('DigitalOcean::Droplet', 'droplet', $do_response->json);

    $droplet->image->DigitalOcean($self);

    return $droplet;
}

__PACKAGE__->meta->make_immutable();

1;
