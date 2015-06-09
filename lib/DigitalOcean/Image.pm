use strict;
package DigitalOcean::Image;
use Mouse;

#ABSTRACT: Represents a Region object in the DigitalOcean API

has DigitalOcean => ( 
    is => 'rw',
    isa => 'DigitalOcean',
);

has id => ( 
    is => 'ro',
    isa => 'Num',
);

has name => (
    is => 'ro',
    isa => 'Str',
);

has type => (
    is => 'ro',
    isa => 'Str',
);

has distribution => (
    is => 'ro',
    isa => 'Str',
);

has slug => ( 
    is => 'ro',
    isa => 'Undef|Str',
    coerce => 1,
);

has public => ( 
    is => 'ro',
    isa => 'Bool',
);

has regions => ( 
    is => 'ro',
    isa => 'ArrayRef[Str]',
    coerce => 1,
);

has created_at => ( 
    is => 'ro',
    isa => 'Str',
);

has min_disk_size => ( 
    is => 'ro',
    isa => 'Num',
);

=head1 SYNOPSIS
 
    FILL ME IN   

=head1 DESCRIPTION
 
FILL ME IN
 
=method id
=cut

__PACKAGE__->meta->make_immutable();

1;
