package DigitalOcean::Type::Network;
use Mouse::Util::TypeConstraints;
use DigitalOcean::Network;

subtype 'ArrayRefOfNetworks' => as 'ArrayRef[DigitalOcean::Network]';
subtype 'CoercedArrayRefOfNetworks' => as 'ArrayRefOfNetworks';
coerce 'CoercedArrayRefOfNetworks'
    => from 'ArrayRef[HashRef]'
    => via { [map { DigitalOcean::Network->new( %{$_} ) } @{$_}] };

no Mouse::Util::TypeConstraints;
1;
