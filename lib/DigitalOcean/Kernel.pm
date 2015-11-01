use strict;
package DigitalOcean::Kernel;
use Mouse;

#ABSTRACT: Represents a Kernel object in the DigitalOcean API

has id => ( 
    is => 'ro',
    isa => 'Num',
);

has name => ( 
    is => 'ro',
    isa => 'Str',
);

has version => ( 
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
