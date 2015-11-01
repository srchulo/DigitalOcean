use strict;
package DigitalOcean::Links;
use Mouse;
use DigitalOcean::Types;

#ABSTRACT: Represents a Links object in the DigitalOcean API

has pages => ( 
    is => 'ro',
    isa => 'Coerced::DigitalOcean::Pages',
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
