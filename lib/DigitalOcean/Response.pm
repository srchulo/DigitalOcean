use strict;
package DigitalOcean::Response;
use Mouse;

has json => ( 
    is => 'ro',
    isa => 'Any',
);

has status_code => (
    is => 'rw',
    isa => 'Num',
);

has status_message => (
    is => 'rw',
    isa => 'Str',
);

has status_line => (
    is => 'rw',
    isa => 'Str',
);

has meta => (
    is => 'rw',
    isa => 'DigitalOcean::Meta',
);

has links => (
    is => 'rw',
    isa => 'DigitalOcean::Links',
);

#ABSTRACT: Represents an HTTP error returned by the DigitalOcean API

=head1 SYNOPSIS
 
  my $do_error = DigitalOcean::Error->new(id => "forbidden", message => "You do not have access for the attempted action.", status_code => 403, status_message => "403 Forbidden", DigitalOcean => $do);
   
=head1 DESCRIPTION
 
Represents an HTTP error returned by the DigitalOcean API. 
 
=method id
    The id of the error returned by the Digital Ocean API. This method is just a getter.
=cut

=method message
    The message of the error returned by the Digital Ocean API. This method is just a getter.
=cut

=method status_code
    A 3 digit number that encode the overall outcome of an HTTP response. This is the C<code> returned by the L<HTTP::Response> object. This method is just a getter.
=cut

=method status_message
    This returns a message that is a short human readable single line string that explains the response code. This is the C<message> returned by the L<HTTP::Response> object. This method is just a getter.
=cut

=method status_line
    Returns the string "<code> <message>". This is the C<status_line> returned by the L<HTTP::Response> object. This method is just a getter.
=cut

=method status_line
    Returns the associated L<DigitalOcean> object that created the L<DigitalOcean::Error> object. This method is just a getter.
=cut

1;
