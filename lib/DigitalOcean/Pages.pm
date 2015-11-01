use strict;
package DigitalOcean::Pages;
use Mouse;

#ABSTRACT: Represents a Links object in the DigitalOcean API

has first => ( 
    is => 'ro',
    isa => 'Undef|Str',
);

has prev => ( 
    is => 'ro',
    isa => 'Undef|Str',
);

has next => ( 
    is => 'ro',
    isa => 'Undef|Str',
);

has last => ( 
    is => 'ro',
    isa => 'Undef|Str',
);

=head1 SYNOPSIS
 
    FILL ME IN   

=head1 DESCRIPTION
 
FILL ME IN
 
=method id
=cut

__PACKAGE__->meta->make_immutable();

1;
