use strict;
package DigitalOcean::Droplet;
use Mouse;
use DigitalOcean::Types;
use DigitalOcean::Snapshot;

#ABSTRACT: Represents a Droplet object in the DigitalOcean API

has DigitalOcean => ( 
    is => 'rw',
    isa => 'DigitalOcean',
);

has id => ( 
    is => 'ro',
    isa => 'Num',
);

has name => (
    is => 'rw',
    isa => 'Str',
);

has memory => ( 
    is => 'rw',
    isa => 'Num',
);

has vcpus => ( 
    is => 'rw',
    isa => 'Num',
);

has disk => ( 
    is => 'rw',
    isa => 'Num',
);

has locked => ( 
    is => 'rw',
    isa => 'Bool',
);

has created_at => ( 
    is => 'rw',
    isa => 'Str',
);

has status => ( 
    is => 'rw',
    isa => 'Str',
);

has backup_ids => ( 
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
);

has snapshot_ids => ( 
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
);

has features => ( 
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
);

has region => ( 
    is => 'rw',
    isa => 'Coerced::DigitalOcean::Region',
    coerce => 1,
);

has image => ( 
    is => 'rw',
    isa => 'Coerced::DigitalOcean::Image',
    coerce => 1,
);

has size => ( 
    is => 'rw',
    isa => 'Coerced::DigitalOcean::Size',
    coerce => 1,
);

has size_slug => ( 
    is => 'rw',
    isa => 'Str',
);

has networks => ( 
    is => 'rw',
    isa => 'Coerced::DigitalOcean::Networks',
    coerce => 1,
);

has kernel => ( 
    is => 'rw',
    isa => 'Undef|Coerced::DigitalOcean::Kernel',
    coerce => 1,
);

has next_backup_window => ( 
    is => 'rw',
    isa => 'Undef|Coerced::DigitalOcean::NextBackupWindow',
    coerce => 1,
);

=method path

Returns the api path for this droplet.

=cut

sub path { 
    'droplets/' . shift->id . '/';
}

=method kernels
 
This will retrieve a list of all kernels available to a Dropet
by returning a L<DigitalOcean::Collection> that can be used to iterate through the L<DigitalOcean::Kernels> objects of the kernels collection. 
 
    my $kernels_collection = $droplet->kernels;
    my $obj;

    while($obj = $kernels_collection->next) { 
        print $obj->name . "\n";
    }

If you would like a different C<per_page> value to be used for this collection instead of L<per_page|DigitalOcean/"per_page">, it can be passed in as a parameter:

    #set default for all collections to be 30
    $do->per_page(30);

    #set this collection to have 2 objects returned per page
    my $kernels_collection = $droplet->kernels(2);
    my $obj;

    while($obj = $kernels_collection->next) { 
        print $obj->name . "\n";
    }
 
=cut

sub kernels { 
    my ($self, $per_page) = @_;
    return $self->DigitalOcean->_get_collection($self->path . 'kernels', 'DigitalOcean::Kernel', 'kernels', $per_page);
}

=method snapshots
 
This will retrieve the snapshots that have been created from a Droplet
by returning a L<DigitalOcean::Collection> that can be used to iterate through the L<DigitalOcean::Snapshot> objects of the snapshots collection. 
 
    my $snapshots_collection = $droplet->snapshots;
    my $obj;

    while($obj = $snapshots_collection->next) { 
        print $obj->name . "\n";
    }

If you would like a different C<per_page> value to be used for this collection instead of L<per_page|DigitalOcean/"per_page">, it can be passed in as a parameter:

    #set default for all collections to be 30
    $do->per_page(30);

    #set this collection to have 2 objects returned per page
    my $snapshots_collection = $droplet->snapshots(2);
    my $obj;

    while($obj = $snapshots_collection->next) { 
        print $obj->name . "\n";
    }
 
=cut

sub snapshots { 
    my ($self, $per_page) = @_;
    return $self->DigitalOcean->_get_collection($self->path . 'snapshots', 'DigitalOcean::Snapshot', 'snapshots', $per_page);
}

=method backups
 
This will retrieve the backups that have been created from a Droplet
by returning a L<DigitalOcean::Collection> that can be used to iterate through the L<DigitalOcean::Backup> objects of the backups collection. 
 
    my $backups_collection = $droplet->backups;
    my $obj;

    while($obj = $backups_collection->next) { 
        print $obj->name . "\n";
    }

If you would like a different C<per_page> value to be used for this collection instead of L<per_page|DigitalOcean/"per_page">, it can be passed in as a parameter:

    #set default for all collections to be 30
    $do->per_page(30);

    #set this collection to have 2 objects returned per page
    my $backups_collection = $droplet->backups(2);
    my $obj;

    while($obj = $backups_collection->next) { 
        print $obj->name . "\n";
    }
 
=cut

sub backups { 
    my ($self, $per_page) = @_;
    return $self->DigitalOcean->_get_collection($self->path . 'backups', 'DigitalOcean::Backup', 'backups', $per_page);
}

=head1 SYNOPSIS
 
    FILL ME IN   

=head1 DESCRIPTION
 
FILL ME IN
 
=method id
=cut

__PACKAGE__->meta->make_immutable();

1;
