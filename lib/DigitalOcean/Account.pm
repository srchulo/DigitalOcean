use strict;
package DigitalOcean::Account;
use Mouse;

#ABSTRACT: Represents an Account object in the DigitalOcean API

=method droplet_limit

The total number of droplets the user may have

=cut

has droplet_limit => ( 
    is => 'ro',
    isa => 'Num',
);

=method email

The email the user has registered for Digital Ocean with

=cut

has email => ( 
    is => 'ro',
    isa => 'Str',
);

=method uuid

The universal identifier for this user

=cut

has uuid => ( 
    is => 'ro',
    isa => 'Str',
);

=method

If true, the user has verified their account via email. False otherwise.

=cut

has email_verified => ( 
    is => 'ro',
    isa => 'Bool',
);

=head1 SYNOPSIS
 
    FILL ME IN   

=head1 DESCRIPTION
 
FILL ME IN
 
=method id
=cut

__PACKAGE__->meta->make_immutable();

1;
