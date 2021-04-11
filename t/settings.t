#!/usr/bin/perl

use strict;
use warnings;
use Test::More 'tests' => 16;
use Test::Fatal qw< exception >;
use Lib::PWQuality;

can_ok(
    Lib::PWQuality::,
    qw<
        new
        _default_settings
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

is(
    $pwq->get_int_value('MIN_LENGTH'),
    8, ## no critic
    'Default MIN_LENGTH is 8',
);

is(
    $pwq->set_option('minlen=10'),
    'SUCCESS',
    'set_option(minlen=10) works',
);

is(
    $pwq->get_int_value('MIN_LENGTH'),
    10, ## no critic
    'New MIN_LENGTH set correctly',
);

is(
    $pwq->get_int_value('MAX_REPEAT'),
    0,
    'MAX_REPEAT default is 0',
);

is(
    $pwq->set_int_value( 'MAX_REPEAT', 1 ),
    'SUCCESS',
    'set_int_value(MAX_REPEAT,1) works',
);

is(
    $pwq->get_int_value('MAX_REPEAT'),
    1,
    'MAX_REPEAT set to 1',
);

is(
    $pwq->get_str_value('BAD_WORDS'),
    undef,
    'BAD_WORDS default is empty',
);

is(
    $pwq->set_str_value( 'BAD_WORDS', 'foo' ),
    'SUCCESS',
    'set_str_value(BAD_WORDS,foo) works',
);

is(
    $pwq->get_str_value('BAD_WORDS'),
    'foo',
    'BAD_WORDS set to foo',
);

like(
    exception( sub { $pwq->set_option('foo=bar') } ),
    qr/^\QUnrecognized option: 'foo'\E/xms,
    'Cannot set_option to non-supported key',
);

like(
    exception( sub { $pwq->set_int_value('foo', 'bar') } ),
    qr/^\QUnrecognized value: 'foo'\E/xms,
    'Cannot set_int_value to non-supported key',
);

like(
    exception( sub { $pwq->set_str_value('foo', 'bar') } ),
    qr/^\QUnrecognized value: 'foo'\E/xms,
    'Cannot set_str_value to non-supported key',
);

like(
    exception( sub { $pwq->get_int_value('foo') } ),
    qr/^\QUnrecognized value: 'foo'\E/xms,
    'Cannot get_int_value to non-supported key',
);

like(
    exception( sub { $pwq->get_str_value('foo') } ),
    qr/^\QUnrecognized value: 'foo'\E/xms,
    'Cannot get_str_value to non-supported key',
);
