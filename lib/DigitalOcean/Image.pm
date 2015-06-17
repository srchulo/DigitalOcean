use strict;
package DigitalOcean::Image;
use Mouse;

#ABSTRACT: Represents a Region object in the DigitalOcean API

has DigitalOcean => ( 
    is => 'rw',
    isa => 'DigitalOcean',
);

=method id

A unique number that can be used to identify and reference a specific image.

=cut 

has id => ( 
    is => 'ro',
    isa => 'Num',
);

=method name

The display name that has been given to an image. This is what is shown in the control panel and is generally a descriptive title for the image in question.

=cut

has name => (
    is => 'ro',
    isa => 'Str',
);

=method type

The kind of image, describing the duration of how long the image is stored. This is one of "snapshot", "temporary" or "backup".

=cut

has type => (
    is => 'ro',
    isa => 'Str',
);

=method distribution

This attribute describes the base distribution used for this image.

=cut

has distribution => (
    is => 'ro',
    isa => 'Str',
);

=method slug

A uniquely identifying string that is associated with each of the DigitalOcean-provided public images. These can be used to reference a public image as an alternative to the numeric id.

=cut

has slug => ( 
    is => 'ro',
    isa => 'Undef|Str',
    coerce => 1,
);

=method public

This is a boolean value that indicates whether the image in question is public or not. An image that is public is available to all accounts. A non-public image is only accessible from your account.

=cut

has public => ( 
    is => 'ro',
    isa => 'Bool',
);

=method regions

This attribute is an array of the regions that the image is available in. The regions are represented by their identifying slug values.

=cut

has regions => ( 
    is => 'ro',
    isa => 'ArrayRef[Str]',
    coerce => 1,
);

=method min_disk_size

The minimum 'disk' required for a size to use this image.

=cut

has min_disk_size => ( 
    is => 'ro',
    isa => 'Num',
);

=method created_at

A time value given in ISO8601 combined date and time format that represents when the Image was created.

=cut

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
