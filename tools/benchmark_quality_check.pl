#!/usr/bin/perl

use strict;
use warnings;
use lib 'lib';
use experimental qw< signatures >;
use Dumbbench;

use Lib::PWQuality;
use Data::Password qw< IsBadPassword >;

use constant 'MAX_RUN' => 1e2;

my $bench = Dumbbench->new(
    'target_rel_precision' => 0.005,
    'initial_runs'         => 20,
);

## no critic

my $rand_pass = Lib::PWQuality->new({'MIN_LENGTH' => 20})->generate(128);

$bench->add_instances(

    Dumbbench::Instance::PerlSub->new(
        'name' => 'Lib::PWQuality',
        'code' => sub {
            my $pwq = Lib::PWQuality->new({
                'DICT_CHECK'  => 0,
                'USER_CHECK'  => 0,
                'ENFORCING'   => 0,
                'RETRY_TIMES' => 0,
            });

            for ( 1 .. MAX_RUN() ) {
                $pwq->check($rand_pass);
            }
        },
    ),

    Dumbbench::Instance::PerlSub->new(
        'name' => 'Data::Password',
        'code' => sub {
            for ( 1 .. MAX_RUN() ) {
                IsBadPassword($rand_pass);
            }
        },
    ),

);

$bench->run;
$bench->report;
