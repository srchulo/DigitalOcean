package DigitalOcean::SSH::Key;
use strict;
use Object::Tiny::RW::XS qw /id name ssh_pub_key DigitalOcean/;
use Method::Signatures::Simple;

#use 5.006;
#use warnings FATAL => 'all';

=head1 NAME

DigitalOcean::SSH::Key - Represents an SSH Key object in the L<DigitalOcean> API

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';


=head1 SYNOPSIS

    use DigitalOcean;

    my $do = DigitalOcean->new(client_id=> $client_id, api_key => $api_key);
    my $ssh_key = $do->ssh_key(56789);

    $ssh_key->edit(ssh_pub_key => $ssh_pub_key);

    $ssh_key->destroy;

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

ssh_pub_key

=back

Example use: 

    my $ssh_key_id = $ssh_key->id;

    my $ssh_key_name = $ssh_key->name;

    my $ssh_pub_key = $ssh_key->ssh_pub_key;

=cut

=head2 edit

This method allows you to modify an existing public SSH key in your account.

=over 4

=item

B<ssh_pub_key> Required, String, the new public SSH key.

=back

    $ssh_key->edit(ssh_pub_key => $ssh_pub_key); 

=cut

method edit { 
	my (%params) = @_;
	$self->DigitalOcean->_external_request($self->id, @_);
	$self->ssh_pub_key($params{ssh_pub_key});
}

=head2 destroy

This method will delete the SSH key from your account.

    $ssh_key->destroy;

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
