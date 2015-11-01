use strict;
package DigitalOcean::Action;
use Mouse;
use DigitalOcean::Types;

#ABSTRACT: Represents an Action object in the DigitalOcean API

has DigitalOcean => (
    is => 'rw',
    isa => 'DigitalOcean',
);

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
    is => 'rw',
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
    is => 'rw',
    isa => 'Str|Undef',
);

=method resource_id

A unique identifier for the resource that the action is associated with.

=cut

has resource_id => ( 
    is => 'ro',
    isa => 'Num|Undef',
);

=method resource_type

The type of resource that the action is associated with.

=cut

has resource_type => ( 
    is => 'ro',
    isa => 'Str',
);

=method region

Returns a L<DigitalOcean::Region> object.

=cut

has region => ( 
    is => 'rw',
    isa => 'Coerced::DigitalOcean::Region|Undef',
    coerce => 1,
);

=method region_slug

A slug representing the region where the action occurred.

=cut

has region_slug => ( 
    is => 'ro',
    isa => 'Undef|Str',
);

=method complete
 
This method returns true if the action is complete, false if it is not.
 
    if($action->complete) { 
        #do something
    }
 
=cut
 
sub complete { shift->status eq 'completed' }
 
=method wait
 
This method will wait for an action to complete and will not return until
the action has completed. It is recommended to not use this directly, but
rather to let L<DigitalOcean> call this for you (see L<WAITING ON EVENTS|DigitalOcean/"WAITING ON EVENTS">).
 
    $action->wait;
 
    #do stuff now that event is done.
 
This method works by making requests to Digital Ocean's API to see if the action
is complete yet. See L<TIME BETWEEN REQUESTS|DigitalOcean/"time_between_requests">.
 
=cut
 
sub wait { 
    my ($self) = @_;
    my $action = $self;
 
    print "going to wait\n";
    until($action->complete) { 
        print "waiting\n";
        sleep($self->DigitalOcean->time_between_requests);
        $action = $self->DigitalOcean->action($action->id);       
    }
    print "complete\n";
 
    $self->status($action->status);
    $self->completed_at($action->completed_at);
}

=head1 SYNOPSIS
 
    FILL ME IN   

=head1 DESCRIPTION
 
FILL ME IN
 
=method id
=cut

__PACKAGE__->meta->make_immutable();

1;
