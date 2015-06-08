use strict;
package DigitalOcean::Network;
use Mouse;

#ABSTRACT: Represents a Network object in the DigitalOcean API

has ip_address => ( 
    is => 'ro',
    isa => 'Str',
);

has netmask => ( 
    is => 'ro',
    isa => 'Str',
);

has gateway => ( 
    is => 'ro',
    isa => 'Str',
);

has type => ( 
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
