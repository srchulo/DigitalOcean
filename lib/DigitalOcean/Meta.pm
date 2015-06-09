use strict;
package DigitalOcean::Meta;
use Mouse;

#ABSTRACT: Represents a Meta object in the DigitalOcean API

has total => ( 
    is => 'ro',
    isa => 'Num',
);

#last HTTP::Response. 

=head1 SYNOPSIS
 
    FILL ME IN   

=head1 DESCRIPTION
 
FILL ME IN
 
=method id
=cut

__PACKAGE__->meta->make_immutable();

1;
