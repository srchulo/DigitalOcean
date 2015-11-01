use strict;
package DigitalOcean::NextBackupWindow;
use Mouse;

#ABSTRACT: Represents a Network object in the DigitalOcean API

has end => ( 
    is => 'ro',
    isa => 'Str',
);

has start => ( 
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
