#!/usr/bin/perl

use strict;
use warnings;
use Test::More 'tests' => 2 + 1;
use Lib::PWQuality;

can_ok(
    Lib::PWQuality::,
    qw<
        new
        default_settings
        _free_settings
        check
        generate
        read_config
        set_option
        set_str_value
        set_int_value
        get_str_value
        get_int_value
        _strerror
    >,
);

my $pwq = Lib::PWQuality->new();
isa_ok( $pwq, 'Lib::PWQuality' );

