use strict;
package DigitalOcean::Action;
use Mouse;

#ABSTRACT: Represents an Action object in the DigitalOcean API

=method id

A unique numeric ID that can be used to identify and reference an action.

=cut

has id => ( 
    is => 'ro',
    isa => 'Num',
);

=method status

The current status of the action. This can be "in-progress", "completed", or "errored".

=cut

has status => ( 
    is => 'ro',
    isa => 'Str',
);

=method type

This is the type of action that the object represents. For example, this could be "transfer" to represent the state of an image transfer action.

=cut

has type => ( 
    is => 'ro',
    isa => 'Str',
);

=method started_at

A time value given in ISO8601 combined date and time format that represents when the action was initiated.

=cut

has started_at => ( 
    is => 'ro',
    isa => 'Str',
);

=method completed_at

A time value given in ISO8601 combined date and time format that represents when the action was completed.

=cut

has completed_at => ( 
    is => 'ro',
    isa => 'Str',
);

=method resource_id

A unique identifier for the resource that the action is associated with.

=cut

has resource_id => ( 
    is => 'ro',
    isa => 'Num',
);

=method resource_type

The type of resource that the action is associated with.

=cut

has resource_type => ( 
    is => 'ro',
    isa => 'Str',
);

=method region

(deprecated) A slug representing the region where the action occurred.

=cut

has region => ( 
    is => 'ro',
    isa => 'Undef|Str',
);

=method region_slug

A slug representing the region where the action occurred.

=cut

has region_slug => ( 
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
