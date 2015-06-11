use strict;
package DigitalOcean::Domain;
use Mouse;
use DigitalOcean::Domain::Record;

#ABSTRACT: Represents a Domain object in the DigitalOcean API

has DigitalOcean => (
    is => 'rw',
    isa => 'DigitalOcean',
);

=method name

The name of the domain itself. This should follow the standard domain format of domain.TLD. For instance, example.com is a valid domain name.

=cut

has name => ( 
    is => 'ro',
    isa => 'Str',
);

=method ttl

This value is the time to live for the records on this domain, in seconds. This defines the time frame that clients can cache queried information before a refresh should be requested.

=cut

has ttl => ( 
    is => 'ro',
    isa => 'Num|Undef',
);

=method zone_file

This attribute contains the complete contents of the zone file for the selected domain. Individual domain record resources should be used to get more granular control over records. However, this attribute can also be used to get information about the SOA record, which is created automatically and is not accessible as an individual record resource.

=cut

has zone_file => ( 
    is => 'ro',
    isa => 'Str|Undef',
);

=method records
 
This will return a L<DigitalOcean::Collection> that can be used to iterate through the L<DigitalOcean::Domain::Record> objects of the records collection that is associated with this domain. 
 
    my $records_collection = $domain->records;
    my $obj;

    while($obj = $records_collection->next) { 
        print $obj->id . "\n";
    }

If you would like a different C<per_page> value to be used for this collection instead of L<per_page/DigitalOcean::/"per_page">, it can be passed in as a parameter:

    #set default for all collections to be 30
    $do->per_page(30);

    #set this collection to have 2 objects returned per page
    my $records_collection = $domain->records(2);
    my $obj;

    while($obj = $records_collection->next) { 
        print $obj->id . "\n";
    }
 
=cut

sub records {
    my ($self, $per_page) = @_;
    return $self->DigitalOcean->_get_collection('domains/' . $self->name . '/records', 'DigitalOcean::Domain::Record', 'domain_records', $per_page);
}


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
