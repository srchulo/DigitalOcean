use strict;
package DigitalOcean::Backup;
use Mouse;

#ABSTRACT: Represents a Backup object in the DigitalOcean API

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
);

has public => ( 
    is => 'ro',
    isa => 'Bool',
);

has regions => ( 
    is => 'ro',
    isa => 'ArrayRef[Str]',
);

has min_disk_size => (
    is => 'ro',
    isa => 'Num',
);

has created_at => (
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
