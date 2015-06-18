use strict;
package DigitalOcean::SSH::Key;
use Mouse;

#ABSTRACT: Represents a SSH Key object in the DigitalOcean API

has DigitalOcean => (
    is => 'rw',
    isa => 'DigitalOcean',
);

=method id

This is a unique identification number for the key. This can be used to reference a specific SSH key when you wish to embed a key into a Droplet.

=cut

has id => ( 
    is => 'ro',
    isa => 'Num',
);

=method fingerprint

This attribute contains the fingerprint value that is generated from the public key. This is a unique identifier that will differentiate it from other keys using a format that SSH recognizes.

=cut

has fingerprint => ( 
    is => 'ro',
    isa => 'Str',
);

=method public_key

This attribute contains the entire public key string that was uploaded. This is what is embedded into the root user's authorized_keys file if you choose to include this SSH key during Droplet creation.

=cut

has public_key => ( 
    is => 'ro',
    isa => 'Str',
);

=method name

This is the human-readable display name for the given SSH key. This is used to easily identify the SSH keys when they are displayed.

=cut

has name => ( 
    is => 'ro',
    isa => 'Str',
);

=method path

Returns the api path for this domain

=cut

has path => (
    is => 'rw',
    isa => 'Str',
);

sub BUILD { 
    my ($self) = @_;

    $self->path('account/keys/' . $self->id);
}

=method update
 
This method updates an SSH key.
 
=over 4
 
=item 
 
B<name> Required, String, The name to give the new SSH key in your account.
 
=back
 
    my $updated_ssh_key = $ssh_key->update(name => 'newname');
 
This method returns the updated L<DigitalOcean::SSH::Key>.

=cut

sub update { 
    my $self = shift;
    my (%args) = @_;

    return $self->DigitalOcean->_put_object($self->path, 'DigitalOcean::SSH::Key', 'ssh_key', \%args);
}

=head1 SYNOPSIS
 
    FILL ME IN   

=head1 DESCRIPTION
 
FILL ME IN
 
=method id
=cut

__PACKAGE__->meta->make_immutable();

1;
