package DigitalOcean::Types;
use Mouse::Util::TypeConstraints;
use DigitalOcean::Region;
use DigitalOcean::Image;
use DigitalOcean::Size;
use DigitalOcean::Kernel;
use DigitalOcean::NextBackupWindow;
use DigitalOcean::Networks;
use DigitalOcean::Network;
use DigitalOcean::Pages;

subtype 'Coerced::DigitalOcean::Region' => as class_type('DigitalOcean::Region');
coerce 'Coerced::DigitalOcean::Region'
    => from 'HashRef'
    => via { DigitalOcean::Region->new( %{$_} ) };

subtype 'Coerced::DigitalOcean::Image' => as class_type('DigitalOcean::Image');
coerce 'Coerced::DigitalOcean::Image'
    => from 'HashRef'
    => via { DigitalOcean::Image->new( %{$_} ) };

subtype 'Coerced::DigitalOcean::Size' => as class_type('DigitalOcean::Size');
coerce 'Coerced::DigitalOcean::Size'
    => from 'HashRef'
    => via { DigitalOcean::Size->new( %{$_} ) };

subtype 'Coerced::DigitalOcean::Kernel' => as class_type('DigitalOcean::Kernel');
coerce 'Coerced::DigitalOcean::Kernel'
    => from 'HashRef'
    => via { DigitalOcean::Kernel->new( %{$_} ) };

subtype 'Coerced::DigitalOcean::NextBackupWindow' => as class_type('DigitalOcean::NextBackupWindow');
coerce 'Coerced::DigitalOcean::NextBackupWindow'
    => from 'HashRef'
    => via { DigitalOcean::NextBackupWindow->new( %{$_} ) };

subtype 'Coerced::DigitalOcean::Networks' => as class_type('DigitalOcean::Networks');
coerce 'Coerced::DigitalOcean::Networks'
    => from 'HashRef'
    => via { DigitalOcean::Networks->new( %{$_} ) };

subtype 'Coerced::DigitalOcean::Links' => as class_type('DigitalOcean::Links');
coerce 'Coerced::DigitalOcean::Links'
    => from 'HashRef'
    => via { DigitalOcean::Links->new( %{$_} ) };

subtype 'Coerced::DigitalOcean::Pages' => as class_type('DigitalOcean::Pages');
coerce 'Coerced::DigitalOcean::Pages'
    => from 'HashRef'
    => via { DigitalOcean::Pages->new( %{$_} ) };

no Mouse::Util::TypeConstraints;
1;
