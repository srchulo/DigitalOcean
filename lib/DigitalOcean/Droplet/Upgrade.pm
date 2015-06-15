use strict;
package DigitalOcean::Droplet::Upgrade;
use Mouse;

#ABSTRACT: Represents a droplet upgrade object in the DigitalOcean API

=method droplet_id

The affected droplet's ID.

=cut

has droplet_id => ( 
    is => 'ro',
    isa => 'Num',
);

=method date_of_migration

A time value given in ISO8601 combined date and time format that represents when the migration will occur for the droplet.

=cut

has date_of_migration => ( 
    is => 'ro',
    isa => 'Str',
);

=method url

A URL pointing to the Droplet's API endpoint. This is the endpoint to be used if you want to retrieve information about the droplet.
 
=cut

has url => ( 
    is => 'ro',
    isa => 'Str',
);

=head1 SYNOPSIS
 
    FILL ME IN   

=head1 DESCRIPTION
 
FILL ME IN
 
=method id
=cut

__PACKAGE__->meta->make_immutable();

1;
