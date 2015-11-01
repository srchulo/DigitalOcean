use strict;
package DigitalOcean::Networks;
use Mouse;
use DigitalOcean::Type::Network;

#ABSTRACT: Represents a Network object in the DigitalOcean API

has v4 => ( 
    is => 'ro',
    isa => 'CoercedArrayRefOfNetworks',
    coerce => 1,
);

has v6 => ( 
    is => 'ro',
    isa => 'CoercedArrayRefOfNetworks',
    coerce => 1,
);

=head1 SYNOPSIS
 
    FILL ME IN   

=head1 DESCRIPTION
 
FILL ME IN
 
=method id
=cut

__PACKAGE__->meta->make_immutable();

1;
