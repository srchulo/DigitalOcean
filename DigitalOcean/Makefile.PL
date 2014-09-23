use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'DigitalOcean',
    AUTHOR           => q{Adam Hopkins <srchulo@cpan.org>},
    VERSION_FROM     => 'lib/DigitalOcean.pm',
    ABSTRACT_FROM    => 'lib/DigitalOcean.pm',
    LICENSE          => 'Artistic_2_0',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        #'ABC'              => 1.6,
        #'Foo::Bar::Module' => 5.0401,
	'Mouse' => 0,
	'LWP::UserAgent' => 0,
	'LWP::Protocol::https' => 0,
	'JSON::XS' => 0,
	'Object::Tiny::RW::XS' => 0,
	'Object::Tiny::XS' => 0,
	'Method::Signatures::Simple' => 0,
	'MouseX::Types' => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'DigitalOcean-*' },

    (eval { ExtUtils::MakeMaker->VERSION(6.46) } ? (META_MERGE => {
    'meta-spec' => { version => 2 },
     resources => {
         repository => {
             type => 'git',
             url  => 'https://github.com/srchulo/DigitalOcean.git',
             web  => 'https://github.com/srchulo/DigitalOcean',
         },
     }})
     : ()
),
);
