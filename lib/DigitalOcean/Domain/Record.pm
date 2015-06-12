use strict;
package DigitalOcean::Domain::Record;
use Mouse;

#ABSTRACT: Represents a Domain object in the DigitalOcean API

has DigitalOcean => (
    is => 'rw',
    isa => 'DigitalOcean',
);

has Domain => (
    is => 'rw',
    isa => 'DigitalOcean::Domain',
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

=method path

Returns the api path for this record.

=cut

sub path {
    my ($self) = @_;
    return $self->Domain->path . '/' . $self->id;
}

=method update
 
This method edits an existing domain record. It updates the L<DigitalOcean::Domain::Record> object
to reflect the changes.
 
=over 4
 
=item 
 
B<type> String, The record type (A, MX, CNAME, etc).
 
=item
 
B<name> String (A, AAAA, CNAME, TXT, SRV), The host name, alias, or service being defined by the record.
 
=item
 
B<data> String (A, AAAA, CNAME, MX, TXT, SRV, NS), Variable data depending on record type. 
 
=item
 
B<priority> Number (MX, SRV), The priority of the host (for SRV and MX records. null otherwise).
 
=item
 
B<port> Number, The port that the service is accessible on (for SRV records only. null otherwise).
 
=item
 
B<weight> Number, The weight of records with the same priority (for SRV records only. null otherwise).
 
=back
 
    $record->update(
        record_type => 'A',
        name => 'newname',
        data => '196.87.89.45',
    );
 
=cut

sub update { 
    my $self = shift;
    my (%args) = @_;

    my $do_response = $self->DigitalOcean->_put_object($self->path, 'DigitalOcean::Domain::Record', 'domain_record', \%args);
}

=method delete

This deletes the record for the associated domain from your account. This will return 1 on success and undef on failure.

=cut

sub delete { 
    my ($self) = @_;
    return $self->DigitalOcean->_delete(path => $self->path);
}

=head1 SYNOPSIS
 
    FILL ME IN   

=head1 DESCRIPTION
 
FILL ME IN
 
=method id
=cut

__PACKAGE__->meta->make_immutable();

1;
