package DigitalOcean::Droplet;
use strict;
use Object::Tiny::RW::XS qw /status name created_at region_id backups_active backups snapshots locked image_id id size_id ip_address private_ip_address DigitalOcean/;
use Method::Signatures::Simple;

#use 5.006;
#use warnings FATAL => 'all';

=head1 NAME

DigitalOcean::Droplet - Represents a Droplet object in the L<DigitalOcean> API

=head1 VERSION

Version 0.03

=cut

our $VERSION = '0.03';

=head1 SYNOPSIS

    use DigitalOcean;

    my $do = DigitalOcean->new(client_id=> $client_id, api_key => $api_key);
    my $droplet = $do->droplet(56789);

    $droplet->reboot;

    $droplet->power_cycle;

    $droplet->power_off(wait_on_event => 1);
    $droplet->snapshot(wait_on event => 1);
    $droplet->power_on(wait_on_event => 1);

    #same as last three statements
    $droplet->snapshot_reboot;

=head1 SUBROUTINES/METHODS

=cut 
=head2 GETTERS

Below is a list of getters that will return the information as set by Digital Ocean.

=over 4

=item

id

=item

name

=item

image_id

=item

size_id

=item

region_id

=item

size_id

=item

backups_active

=item

backups

=item

snapshots

=item

ip_address

=item

private_ip_address

=item

locked

=item

status

=back

Example use: 

    my $droplet_id = $droplet->id;

    my $droplet_name = $droplet->name;

    #returns an arrayref of backups associated with the droplet
    my $backups = $droplet->backups;

    #returns an arrayref of snapshots associated with the droplet
    my $snapshots = $droplet->snapshots;

=cut

=head2 reboot

This method allows you to reboot a droplet. This is the preferred method to use if a server is not responding.
 
    $droplet->reboot;

=cut

method reboot { $self->DigitalOcean->_external_request($self->id, @_) }

=head2 power_cycle

This method allows you to power cycle a droplet. This will turn off the droplet and then turn it back on.

    $droplet->power_cycle;

=cut

method power_cycle { $self->DigitalOcean->_external_request($self->id, @_) }

=head2 shutdown

This method allows you to shutdown a running droplet. The droplet will remain in your account.

    $droplet->shutdown;

=cut

method shutdown { $self->DigitalOcean->_external_request($self->id, @_) }

=head2 power_off

This method allows you to poweroff a running droplet. The droplet will remain in your account.

    $droplet->power_off;

=cut

method power_off { $self->DigitalOcean->_external_request($self->id, @_) }

=head2 power_on

This method allows you to poweron a powered off droplet.

    $droplet->power_on;

=cut

method power_on { $self->DigitalOcean->_external_request($self->id, @_) }

=head2 password_reset

This method will reset the root password for a droplet. Please be aware that this will reboot the droplet to allow resetting the password.

    $droplet->password_reset;

=cut

method password_reset { $self->DigitalOcean->_external_request($self->id, @_) }

=head2 resize

This method allows you to resize a specific droplet to a different size. This will affect the number of processors and memory allocated to the droplet.

=over 4

=item

B<size_id> Required, Numeric, this is the id of the size you would like the droplet to be resized to

=back

    $droplet->resize(size_id => 62);

In order to resize your droplet, it must first be powered off, and you must wait for the droplet
to be powered off before you can call resize on the droplet. Making the call accurately would look something like this:

    $droplet->power_off(wait_on_event => 1);
    $droplet->resize(size_id => 62, wait_on_event => 1);
    $droplet->power_on(wait_on_event => 1);

If your droplet is already on and you essentially want to resize it and boot your droplet
back up, you can call L<resize_reboot|/"resize_reboot"> to do the above code for you.

=cut

#slow because we have to call shutdown first. Make not of this in documentation
method resize { 
	$self->DigitalOcean->_external_request($self->id, @_);
}

=head2 resize_reboot

If your droplet is already running, this method makes a call to L<resize|/"resize">
for you and powers off your droplet, and then powers it on after it is done resizing
and handles L<waiting on each event|DigitalOcean/"WAITING ON EVENTS"> to finish so you do not have to write this code.
This is essentially the code that L<resize_reboot|/"resize_reboot"> performs for you:

    $droplet->power_off(wait_on_event => 1);
    $droplet->resize(size_id => 62, wait_on_event => 1);
    $droplet->power_on(wait_on_event => 1);

=cut

method resize_reboot { 
	$self->power_off(wait_on_event => 1);
	$self->resize(@_, wait_on_event => 1);
	$self->power_on(wait_on_event => 1);
}

=head2 snapshot

This method allows you to take a snapshot of the droplet once it has been powered off, which can later be restored or used to create a new droplet from the same image.

=over 4

=item

B<name> Optional, String, this is the name of the new snapshot you want to create. If not set, the snapshot name will default to date/time

=back

In order to take a snapshot of your droplet, it must first be powered off, and you must wait for the droplet
to be powered off before you can call snapshot on the droplet. Making the call accurately would look something like this:

    $droplet->power_off(wait_on_event => 1);
    $droplet->snapshot(wait_on_event => 1);
    $droplet->power_on(wait_on_event => 1);

If your droplet is already on and you essentially want to take a snapshot and boot your droplet
back up, you can call L<snapshot_reboot|/"snapshot_reboot"> to do the above code for you.

=cut

method snapshot { 
	my $event = $self->DigitalOcean->_external_request($self->id, @_);
	#update droplets snapshots
	my $temp_droplet = $self->DigitalOcean->droplet($self->id);
	$self->snapshots($temp_droplet->snapshots);
	return $event;
}

=head2 snapshot_reboot

If your droplet is already running, this method makes a call to L<snapshot|/"snapshot">
for you and powers off your droplet, and then powers it on after it is done taking a snapshot
and handles L<waiting on each event|DigitalOcean/"WAITING ON EVENTS"> to finish so you do not have to write this code.
This is essentially the code that L<snapshot_reboot|/"snapshot_reboot"> performs for you:

    $droplet->power_off(wait_on_event => 1);
    $droplet->snapshot(wait_on_event => 1);
    $droplet->power_on(wait_on_event => 1);

=cut

method snapshot_reboot { 
	$self->power_off(wait_on_event => 1);
	my $event = $self->snapshot(@_, wait_on_event => 1);
	$self->power_on(wait_on_event => 1);
	return $event;
}

=head2 restore

This method allows you to restore a droplet with a previous image or snapshot. This will be a mirror copy of the image or snapshot to your droplet. Be sure you have backed up any necessary information prior to restore.

=over 4

=item

B<image_id> Required, Numeric, this is the id of the image you would like to use to restore your droplet with

=back

    $droplet->restore(image_id => 56789);

=cut

method restore { $self->DigitalOcean->_external_request($self->id, @_) }

=head2 rebuild

This method allows you to reinstall a droplet with a default image. This is useful if you want to start again but retain the same IP address for your droplet.

=over 4

=item

B<image_id> Required, Numeric, this is the id of the image you would like to use to restore your droplet with

=back

    $droplet->rebuild(image_id => 56789);

=cut

method rebuild { $self->DigitalOcean->_external_request($self->id, @_) }

=head2 enable_backups

This method enables bakcups on your droplet.

    $droplet->enable_backups;

=cut

method enable_backups { $self->DigitalOcean->_external_request($self->id, @_) }

=head2 disable_backups

This method disables bakcups on your droplet.

    $droplet->disable_backups;

=cut

method disable_backups { $self->DigitalOcean->_external_request($self->id, @_) }

=head2 rename

This method renames the droplet to the specified name. The new name is reflected in the droplet object.

=over 4

=item

B<name> Required, String, new name of the droplet

=back

    $droplet->rename(name => 'my_new_droplet_name');

=cut

method rename { 
	my (%params) = @_;
	my $event = $self->DigitalOcean->_external_request($self->id, @_);
	$self->name($params{name});
	return $event;
}

=head2 destroy

This method destroys your droplet - this is irreversible.

    $droplet->destroy;

=cut

method destroy { $self->DigitalOcean->_external_request($self->id, @_) }

=head1 AUTHOR

Adam Hopkins, C<< <srchulo at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-webservice-digitalocean at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=DigitalOcean>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc DigitalOcean


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=DigitalOcean>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/DigitalOcean>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/DigitalOcean>

=item * Search CPAN

L<http://search.cpan.org/dist/DigitalOcean/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2013 Adam Hopkins.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of DigitalOcean
