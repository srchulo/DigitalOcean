use strict;
package DigitalOcean::Domain;
use Mouse;

#ABSTRACT: Represents a Domain object in the DigitalOcean API

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

=head1 SYNOPSIS
 
    FILL ME IN   

=head1 DESCRIPTION
 
FILL ME IN
 
=method id
=cut

__PACKAGE__->meta->make_immutable();

1;
