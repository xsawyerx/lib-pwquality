#!/usr/bin/perl

use strict;
use warnings;
use lib 'lib';
use experimental qw< signatures >;
use Dumbbench;

use Lib::PWQuality;
use App::Genpass;
use Crypt::GeneratePassword;
use Crypt::RandPasswd;
use Crypt::YAPassGen;
use Data::Random qw< rand_chars >;
#use Data::Random::String;
#use Data::SimplePassword;
#use Session::Token;
use String::MkPasswd qw< mkpasswd >;
#use String::Random;
#use String::Urandom;

# not as randomized
#use Crypt::PassGen qw< passgen >;
#use Crypt::PW44;
#use Crypt::XkcdPassword;
#use Text::Password::Pronounceable;

#use Linux::Proc::Cpuinfo;
#use Proc::CPUUsage;

use constant 'MAX_RUN' => 1e4;

my $bench = Dumbbench->new(
    'target_rel_precision' => 0.005,
    'initial_runs'         => 20,
);

#my $pwq = Lib::PWQuality->new();
#foreach my $option ( qw< DIFF_OK MIN_LENGTH DIG_CREDIT UP_CREDIT LOW_CREDIT OTH_CREDIT MIN_CLASS MAX_REPEAT MAX_CLASS_REPEAT MAX_SEQUENCE GECOS_CHECK DICT_CHECK USER_CHECK USER_SUBSTR ENFORCING RETRY_TIMES ENFORCE_ROOT LOCAL_USERS BAD_WORDS DICT_PATH > ) {
#    printf "%s -> %s\n", $option, $pwq->get_value($option);
#}
#exit;

## no critic

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
                $pwq->generate(15);
            }
        },
    ),

    Dumbbench::Instance::PerlSub->new(
        'name' => 'App::Genpass (noverify)',
        'code' => sub {
            my $generator = App::Genpass->new(
                'number'    => 1,
                'readable'  => 0,
                'special'   => 1,
                'verify'    => 0,
                'minlength' => 13,
                'maxlength' => 13,
            );

            for ( 1 .. MAX_RUN() ) {
                $generator->generate();
            }
        },
    ),

    Dumbbench::Instance::PerlSub->new(
        'name' => 'App::Genpass (verify)',
        'code' => sub {
            my $generator = App::Genpass->new(
                'number'    => 1,
                'readable'  => 0,
                'special'   => 1,
                'verify'    => 1,
                'minlength' => 13,
                'maxlength' => 13,
            );

            for ( 1 .. MAX_RUN() ) {
                $generator->generate();
            }
        },
    ),

    Dumbbench::Instance::PerlSub->new(
        'name' => 'Crypt::GeneratePassword::chars()',
        'code' => sub {
            for ( 1 .. MAX_RUN() ) {
                Crypt::GeneratePassword::chars( 13, 13 );
            }
        },
    ),

    Dumbbench::Instance::PerlSub->new(
        'name' => 'Crypt::RandPasswd::chars()',
        'code' => sub {
            for ( 1 .. MAX_RUN() ) {
                Crypt::RandPasswd->chars( 13, 13 );
            }
        },
    ),

    #Dumbbench::Instance::PerlSub->new(
    #    'name' => 'Crypt::YAPassGen',
    #    'code' => sub {
    #        my $passgen  = Crypt::YAPassGen->new();

    #        for ( 1 .. MAX_RUN() ) {
    #            $passgen->generate()
    #        }
    #    },
    #),

    Dumbbench::Instance::PerlSub->new(
        'name' => 'Data::Random',
        'code' => sub {
            for ( 1 .. MAX_RUN() ) {
                rand_chars( 'set' => 'all', 'size' => 13 );
            }
        },
    ),

    Dumbbench::Instance::PerlSub->new(
        'name' => 'String::MkPasswd',
        'code' => sub {
            for ( 1 .. MAX_RUN() ) {
                mkpasswd(
                    '-length'     => 13,
                    '-minnum'     => 1,
                    '-minlower'   => 1,
                    '-minupper'   => 1,
                    '-minspecial' => 1,
                    '-distribute' => 0,
                );
            }
        },
    ),

);

$bench->run;
$bench->report;
