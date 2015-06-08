use strict;
package DigitalOcean::Region;
use Mouse;

#ABSTRACT: Represents a Region object in the DigitalOcean API

has slug => ( 
    is => 'ro',
    isa => 'Undef|Str',
);

has name => ( 
    is => 'ro',
    isa => 'Str',
);

has sizes => (
    is => 'ro',
    isa => 'ArrayRef[Str]',
    default => sub { [] },
);

has available => ( 
    is => 'ro',
    isa => 'Bool',
);

has features => (
    is => 'ro',
    isa => 'ArrayRef[Str]',
    default => sub { [] },
);

=head1 SYNOPSIS
 
    FILL ME IN   

=head1 DESCRIPTION
 
FILL ME IN
 
=method id
=cut

__PACKAGE__->meta->make_immutable();

1;
