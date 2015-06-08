use strict;
package DigitalOcean::Size;
use Mouse;

#ABSTRACT: Represents a Region object in the DigitalOcean API

has slug => ( 
    is => 'ro',
    isa => 'Str',
);

has available => ( 
    is => 'ro',
    isa => 'Bool',
);

has transfer => ( 
    is => 'ro',
    isa => 'Num',
);

has price_monthly => ( 
    is => 'ro',
    isa => 'Num',
);

has price_hourly=> ( 
    is => 'ro',
    isa => 'Num',
);

has memory => ( 
    is => 'ro',
    isa => 'Num',
);

has vcpus => ( 
    is => 'ro',
    isa => 'Num',
);

has disk => ( 
    is => 'ro',
    isa => 'Num',
);

has regions => ( 
    is => 'ro',
    isa => 'ArrayRef[Str]',
);

has features => ( 
    is => 'ro',
    isa => 'ArrayRef',
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
