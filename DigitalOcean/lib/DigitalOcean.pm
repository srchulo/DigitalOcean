package DigitalOcean;
use strict;
use Mouse;
use LWP::UserAgent;
use LWP::Protocol::https;
use JSON::XS;
use DigitalOcean::Droplet;
use DigitalOcean::Region;
use DigitalOcean::Size;
use DigitalOcean::Image;
use DigitalOcean::SSH::Key;
use DigitalOcean::Domain;
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
	'DigitalOcean::_external_request' => 'event_id',		
);

my %ext_request = ( 
	'DigitalOcean::Droplet' => 'droplets',		
	'DigitalOcean::Image' => 'images',		
	'DigitalOcean::SSH::Key' => 'ssh_keys',		
	'DigitalOcean::Domain' => 'domains',		
);

=head1 NAME

DigitalOcean - An OO interface to the DigitalOcean API.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    use DigitalOcean;

    my $do = DigitalOcean->new(client_id=> $client_id, api_key => $api_key);

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

=head1 SUBROUTINES/METHODS

=cut

sub _request { 
	my ($self, $path, $params) = @_;
	
	$params->{client_id} = $self->client_id;
	$params->{api_key} = $self->api_key;

	my $uri = URI->new($self->api . $path);
	$uri->query_form($params);

	my $req = HTTP::Request->new(
		'GET',
		$uri,
	);

	print "$uri\n";
	my $response = $self->ua->request($req);

	my $caller = $self->caller ? $self->caller : $self->_caller;
	my $json = JSON::XS->new->utf8->decode ($response->content);
	my $message = $json->{message} || $json->{error_message};
	die "ERROR $message" if $json->{status} ne 'OK';

	my $obj_key = $self->json_obj_key ? $self->json_obj_key : 
				  $json_keys{$caller} ? $json_keys{$caller} : '';

	$self->api_obj($json->{$obj_key});

	$self->caller(undef);
	$self->json_obj_key(undef);
}

sub _external_request { 
	my ($self, $id, %params) = @_;
	my $caller = $self->caller ? $self->caller : $self->_caller(1);
	my $package = $self->_package;
	$self->_request("$ext_request{$package}/$id/$caller/" . $self->request_append, \%params);
	$self->request_append('');
	$self->caller(undef);
	return $self->api_obj;
}

sub _decode { 
	my ($self, $type, $attrs) = @_;
	$attrs = $self->api_obj unless $attrs;
	$attrs->{DigitalOcean} = $self;
	return $type->new(%$attrs);
}

sub _decode_many { 
	my ($self, $type) = @_;

	my @objs;
	for my $obj (@{$self->api_obj}) { 
		push @objs, $self->_decode($type,$obj);
	}

	return \@objs;
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

=cut

sub droplets {
	my ($self) = @_;
	
	$self->_request('droplets');
	return $self->_decode_many('DigitalOcean::Droplet');
}

=head2 create_droplet

=cut

sub create_droplet {
	my $self = shift;
	my %params = @_;
	return $self->_create('droplets/new', \%params, 'DigitalOcean::Droplet');
}

=head2 droplet

=cut

sub droplet {
	my ($self, $id) = @_;

	$self->_request("droplets/$id");
	return $self->_decode('DigitalOcean::Droplet');
}

=head2 regions

=cut

sub regions {
	my ($self) = @_;
	
	$self->_request('regions');
	return $self->_decode_many('DigitalOcean::Region');
}

=head2 images

=cut

sub images {
	my ($self) = @_;
	
	$self->_request('images');
	return $self->_decode_many('DigitalOcean::Image');
}

=head2 image

=cut

sub image {
	my ($self, $id) = @_;

	$self->_request("images/$id");
	return $self->_decode('DigitalOcean::Image');
}

=head2 sizes

=cut

sub sizes {
	my ($self) = @_;
	
	$self->_request('sizes');
	return $self->_decode_many('DigitalOcean::Size');
}

=head2 ssh_keys

=cut

sub ssh_keys {
	my ($self) = @_;
	
	$self->_request('ssh_keys');
	return $self->_decode_many('DigitalOcean::SSH::Key');
}

=head2 create_ssh_key

=cut

sub create_ssh_key {
	my $self = shift;
	my %params = @_;
	return $self->_create('ssh_keys/new', \%params, 'DigitalOcean::SSH::Key');
}

=head2 ssh_key

=cut

sub ssh_key {
	my ($self, $id) = @_;

	$self->_request("ssh_keys/$id");
	return $self->_decode('DigitalOcean::SSH::Key');
}

=head2 domains

=cut

sub domains {
	my ($self) = @_;
	
	$self->_request('domains');
	return $self->_decode_many('DigitalOcean::Domain');
}

=head2 create_domain

=cut

sub create_domain {
	my $self = shift;
	my %params = @_;
	return $self->_create('domains/new', \%params, 'DigitalOcean::Domain');
}

=head2 domain

=cut

sub domain {
	my ($self, $id) = @_;

	$self->_request("domains/$id");
	return $self->_decode('DigitalOcean::Domain');
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
