#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

# Ensure a recent version of Test::Pod
my $min_tp = 1.22;
eval "use Test::Pod $min_tp";

if ( not $ENV{TEST_AUTHOR}) {
	plan skip_all => "Author test.";
}

plan skip_all => "Test::Pod $min_tp required for testing POD" if $@;

all_pod_files_ok();
