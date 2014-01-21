package DigitalOcean::Event;
use strict;
use Object::Tiny::RW::XS qw /id action_status droplet_id event_type_id percentage DigitalOcean/;
use Method::Signatures::Simple;

#use 5.006;
#use warnings FATAL => 'all';

=head1 NAME

DigitalOcean::Event - Represents an Event object in the L<DigitalOcean> API

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';

=head1 SYNOPSIS

    use DigitalOcean;
    my $do = DigitalOcean->new(client_id=> $client_id, api_key => $api_key);
	my $event = $do->event(56789);

    #wait for event to finish
    $event->wait;

=head1 SUBROUTINES/METHODS

=cut 
=head2 GETTERS

Below is a list of getters that will return the information as set by Digital Ocean.

=over 4

=item

id

=item

action_status

=item

droplet_id

=item

event_type_id

=item

percentage

=back

Example use: 

    my $event_id = $event->id;

    my $droplet_id = $event->droplet_id;

    #get the percent that the event is complete out of 100
    my $percentage = $event->percentage;


=cut

=head2 complete

This method returns true if the event is complete, false if it is not.

    if($event->complete) { 
        #do something
    }

=cut

method complete { $self->percentage == 100 }

=head2 wait

This method will wait for an event to complete and will not return until
the event has completed. It is recommended to not use this directly, but
rather to let L<DigitalOcean> call this for you (see L<WAITING ON EVENTS|DigitalOcean/"WAITING ON EVENTS">).

    $event->wait;

    #do stuff now that event is done.

This method works by making requests to Digital Ocean's API to see if the event
is complete yet. See L<TIME BETWEEN REQUESTS|DigitalOcean/"time_between_requests">.

=cut

method wait { 
	my $event = $self;

	until($event->complete) { 
		sleep($self->DigitalOcean->time_between_requests);
		$event = $self->DigitalOcean->event($event->id);	
	}

	$self->percentage(100);
}

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