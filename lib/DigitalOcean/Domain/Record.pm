use strict;
package DigitalOcean::Domain::Record;
use Mouse;

#ABSTRACT: Represents a Domain object in the DigitalOcean API

has DigitalOcean => (
    is => 'rw',
    isa => 'DigitalOcean',
);

=method id

A unique identifier for each domain record.

=cut

has id => ( 
    is => 'ro',
    isa => 'Num',
);

=method type

The type of the DNS record (ex: A, CNAME, TXT, ...).

=cut

has type => ( 
    is => 'ro',
    isa => 'Str|Undef',
);

=method name

The name to use for the DNS record.

=cut

has name => ( 
    is => 'ro',
    isa => 'Str|Undef',
);

=method data

The value to use for the DNS record.

=cut

has data => ( 
    is => 'ro',
    isa => 'Str|Undef',
);

=method priority

The priority for SRV and MX records.

=cut

has priority => ( 
    is => 'ro',
    isa => 'Num|Undef',
);

=method port

The port for SRV records.

=cut

has port => ( 
    is => 'ro',
    isa => 'Num|Undef',
);

=method weight

The weight for SRV records.

=cut

has weight => ( 
    is => 'ro',
    isa => 'Num|Undef',
);

=method delete

This deletes the domain from your account. This will return 1 on success and undef on failure.

=cut

sub delete { 
    my ($self) = @_;
    my $do_response = $self->DigitalOcean->_DELETE(path => 'domains/' . $self->name);

    return $do_response->status_code == 204;
}

=head1 SYNOPSIS
 
    FILL ME IN   

=head1 DESCRIPTION
 
FILL ME IN
 
=method id
=cut

__PACKAGE__->meta->make_immutable();

1;
