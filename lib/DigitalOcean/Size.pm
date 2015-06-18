use strict;
package DigitalOcean::Size;
use Mouse;

#ABSTRACT: Represents a Size object in the DigitalOcean API

=method slug

A human-readable string that is used to uniquely identify each size.

=cut

has slug => ( 
    is => 'ro',
    isa => 'Str',
);

=method available

This is a boolean value that represents whether new Droplets can be created with this size.

=cut

has available => ( 
    is => 'ro',
    isa => 'Bool',
);

=method transfer

The amount of transfer bandwidth that is available for Droplets created in this size. This only counts traffic on the public interface. The value is given in terabytes.

=cut

has transfer => ( 
    is => 'ro',
    isa => 'Num',
);

=method price_monthly

This attribute describes the monthly cost of this Droplet size if the Droplet is kept for an entire month. The value is measured in US dollars.

=cut

has price_monthly => ( 
    is => 'ro',
    isa => 'Num',
);

=method price_hourly

This describes the price of the Droplet size as measured hourly. The value is measured in US dollars.

=cut

has price_hourly => ( 
    is => 'ro',
    isa => 'Num',
);

=method memory

The amount of RAM allocated to Droplets created of this size. The value is represented in megabytes.

=cut

has memory => ( 
    is => 'ro',
    isa => 'Num',
);

=method vcpus

The number of virtual CPUs allocated to Droplets of this size.

=cut

has vcpus => ( 
    is => 'ro',
    isa => 'Num',
);

=method disk

The amount of disk space set aside for Droplets of this size. The value is represented in gigabytes.

=cut

has disk => ( 
    is => 'ro',
    isa => 'Num',
);

=method regions

An array containing the region slugs where this size is available for Droplet creates.

=cut

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
