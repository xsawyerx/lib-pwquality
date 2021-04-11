package Lib::PWQuality;
# ABSTRACT: Perl interface to the libpwquality C library

## no critic

use strict;
use warnings;
use experimental qw< signatures >;
use FFI::CheckLib 0.06 qw< find_lib_or_die >;
use FFI::Platypus;
use FFI::C;
use Carp ();

use constant {
   'SETTINGS_INT' => {
        'DIFF_OK'          => undef,
        'MIN_LENGTH'       => undef,
        'DIG_CREDIT'       => undef,
        'UP_CREDIT'        => undef,
        'LOW_CREDIT'       => undef,
        'OTH_CREDIT'       => undef,
        'MIN_CLASS'        => undef,
        'MAX_REPEAT'       => undef,
        'MAX_CLASS_REPEAT' => undef,
        'MAX_SEQUENCE'     => undef,
        'GECOS_CHECK'      => undef,
        'DICT_CHECK'       => undef,
        'USER_CHECK'       => undef,
        'USER_SUBSTR'      => undef,
        'ENFORCING'        => undef,
        'RETRY_TIMES'      => undef,
        'ENFORCE_ROOT'     => undef,
        'LOCAL_USERS'      => undef,
    },

    'SETTINGS_STR' => {
        'BAD_WORDS' => undef,
        'DICT_PATH' => undef,
    },

    'SETTINGS_ALL' => {
        'difok'            => undef,
        'minlen'           => undef,
        'dcredit'          => undef,
        'ucredit'          => undef,
        'lcredit'          => undef,
        'ocredit'          => undef,
        'minclass'         => undef,
        'maxrepeat'        => undef,
        'maxclassrepeat'   => undef,
        'maxsequence'      => undef,
        'gecoscheck'       => undef,
        'dictcheck'        => undef,
        'usercheck'        => undef,
        'usersubstr'       => undef,
        'enforcing'        => undef,
        'badwords'         => undef,
        'dictpath'         => undef,
        'retry'            => undef,
        'enforce_for_root' => undef,
        'local_users_only' => undef,
    },
};

my $ffi = FFI::Platypus->new( 'api' => 1 );
FFI::C->ffi($ffi);

$ffi->lib( find_lib_or_die( 'lib' => 'pwquality' ) );

package Lib::PWQuality::Setting {

    FFI::C->enum( 'pwquality_setting' => [
        [ 'DIFF_OK'          =>  1 ],
        [ 'MIN_LENGTH'       =>  3 ],
        [ 'DIG_CREDIT'       =>  4 ],
        [ 'UP_CREDIT'        =>  5 ],
        [ 'LOW_CREDIT'       =>  6 ],
        [ 'OTH_CREDIT'       =>  7 ],
        [ 'MIN_CLASS'        =>  8 ],
        [ 'MAX_REPEAT'       =>  9 ],
        [ 'DICT_PATH'        => 10 ],
        [ 'MAX_CLASS_REPEAT' => 11 ],
        [ 'GECOS_CHECK'      => 12 ],
        [ 'BAD_WORDS'        => 13 ],
        [ 'MAX_SEQUENCE'     => 14 ],
        [ 'DICT_CHECK'       => 15 ],
        [ 'USER_CHECK'       => 16 ],
        [ 'ENFORCING'        => 17 ],
        [ 'RETRY_TIMES'      => 18 ],
        [ 'ENFORCE_ROOT'     => 19 ],
        [ 'LOCAL_USERS'      => 20 ],
        [ 'USER_SUBSTR'      => 21 ],
    ]);
}

package Lib::PWQaulity::Return {

    FFI::C->enum( 'pwquality_return' => [
        [ 'SUCCESS'           =>   0 ],
        [ 'FATAL_FAILURE'     =>  -1 ],
        [ 'INTEGER'           =>  -2 ],
        [ 'CFGFILE_OPEN'      =>  -3 ],
        [ 'CFGFILE_MALFORMED' =>  -4 ],
        [ 'UNKNOWN_SETTING'   =>  -5 ],
        [ 'NON_INT_SETTING'   =>  -6 ],
        [ 'NON_STR_SETTING'   =>  -7 ],
        [ 'MEM_ALLOC'         =>  -8 ],
        [ 'TOO_SIMILAR'       =>  -9 ],
        [ 'MIN_DIGITS'        => -10 ],
        [ 'MIN_UPPERS'        => -11 ],
        [ 'MIN_LOWERS'        => -12 ],
        [ 'MIN_OTHERS'        => -13 ],
        [ 'MIN_LENGTH'        => -14 ],
        [ 'PALINDROME'        => -15 ],
        [ 'CASE_CHANGES_ONLY' => -16 ],
        [ 'ROTATED'           => -17 ],
        [ 'MIN_CLASSES'       => -18 ],
        [ 'MAX_CONSECUTIVE'   => -19 ],
        [ 'EMPTY_PASSWORD'    => -20 ],
        [ 'SAME_PASSWORD'     => -21 ],
        [ 'CRACKLIB_CHECK'    => -22 ],
        [ 'RNG'               => -23 ],
        [ 'GENERATION_FAILED' => -24 ],
        [ 'USER_CHECK'        => -25 ],
        [ 'GECOS_CHECK'       => -26 ],
        [ 'MAX_CLASS_REPEAT'  => -27 ],
        [ 'BAD_WORDS'         => -28 ],
        [ 'MAX_SEQUENCE'      => -29 ],
    ]);
}

package Lib::PWQuality::Settings {
    use experimental qw< signatures >;

    FFI::C->struct( 'pwquality_settings_t' => [
        'diff_ok'          => 'int',
        'min_length'       => 'int',
        'dig_credit'       => 'int',
        'up_credit'        => 'int',
        'low_credit'       => 'int',
        'oth_credit'       => 'int',
        'min_class'        => 'int',
        'max_repeat'       => 'int',
        'max_class_repeat' => 'int',
        'max_sequence'     => 'int',
        'gecos_check'      => 'int',
        'dict_check'       => 'int',
        'user_check'       => 'int',
        'user_substr'      => 'int',
        'enforcing'        => 'int',
        'retry_times'      => 'int',
        'enforce_for_root' => 'int',
        'local_users_only' => 'int',

        '_bad_words'       => 'opaque',
        '_dict_path'       => 'opaque',
    ]);

    sub bad_words ($self) {
        return $self->{'bad_words'}
           //= $ffi->cast( 'opaque', 'string', $self->_bad_words() );
    }

    sub dict_path ($self) {
        return $self->{'dict_path'}
           //= $ffi->cast( 'opaque', 'string', $self->_dict_path() );
    }
}

$ffi->mangler( sub ($symbol) {
    return "pwquality_$symbol";
});

$ffi->attach(
    [ 'default_settings' => '_default_settings' ], [], 'pwquality_settings_t'
);

$ffi->attach(
    [ 'free_settings' => '_free_settings' ],
    ['pwquality_settings_t'],
    'void',
);

$ffi->attach(
    'read_config' => [ 'pwquality_settings_t', 'string', 'opaque*' ] => 'pwquality_return',
    sub ( $xsub, $self, $filename ) {
        return $xsub->( $self->settings(), $filename, undef );
    },
);

$ffi->attach(
    'set_option' => [ 'pwquality_settings_t', 'string' ] => 'pwquality_return',
    sub ( $xsub, $self, $pair ) {
        my ($name) = split /=/xms, $pair;
        exists SETTINGS_ALL()->{$name}
            or Carp::croak("Unrecognized option: '$name'");

        return $xsub->( $self->settings(), $pair );
    },
);

$ffi->attach(
    'set_int_value',
    [ 'pwquality_settings_t', 'pwquality_setting', 'int' ],
    'pwquality_return',
    sub ( $xsub, $self, $key, $value ) {
        exists SETTINGS_INT()->{$key}
            or Carp::croak("Unrecognized value: '$key'");

        return $xsub->( $self->settings(), $key, $value );
    },
);

$ffi->attach(
    'set_str_value',
    [ 'pwquality_settings_t', 'pwquality_setting', 'string' ],
    'pwquality_return',
    sub ( $xsub, $self, $key, $value ) {
        exists SETTINGS_STR()->{$key}
            or Carp::croak("Unrecognized value: '$key'");

        return $xsub->( $self->settings(), $key, $value );
    },
);

$ffi->attach(
    'get_int_value',
    [ 'pwquality_settings_t', 'pwquality_setting', 'int*' ],
    'pwquality_return',
    sub ( $xsub, $self, $key ) {
        exists SETTINGS_INT()->{$key}
            or Carp::croak("Unrecognized value: '$key'");

        my $value;
        $xsub->( $self->settings(), $key, \$value );
        return $value;
    },
);

$ffi->attach(
    'get_str_value',
    [ 'pwquality_settings_t', 'pwquality_setting', 'string*' ],
    'pwquality_return',
    sub ( $xsub, $self, $key ) {
        exists SETTINGS_STR()->{$key}
            or Carp::croak("Unrecognized value: '$key'");

        my $value;
        $xsub->( $self->settings(), $key, \$value );
        return $value;
    },
);

$ffi->attach(
    'generate' => [ 'pwquality_settings_t', 'int', 'string*' ] => 'pwquality_return',
    sub ( $xsub, $self, $entropy_bits ) {
        my $password;
        $xsub->( $self->settings(), $entropy_bits, \$password );
        return $password;
    },
);

# auxerr is last arg
# XXX: The return can be pwquality_return (if it's negative)
#      or score (1 - 100)
$ffi->attach(
    'check',
    # settings, passwod, oldpassword, user, auxerror
    # oldpassword, user, and auxerror can all be NULL
    [ 'pwquality_settings_t', 'string', 'string', 'string', 'opaque*' ],
    'int',
);

$ffi->attach(
    [ 'strerror' => '_strerror' ],
    [ 'string', 'size_t', 'int', 'opaque' ],
    'string',
);

sub new ( $class, $opts = {} ) {
    my $settings = _default_settings();
    my $self     = bless { 'settings' => $settings }, $class;

    foreach my $opt_name ( keys $opts->%* ) {
        if ( SETTINGS_INT()->{$opt_name} ) {
            $self->set_int_value( $opt_name, $opts->{$opt_name} );
        } elsif ( SETTINGS_STR()->{$opt_name} ) {
            $self->set_str_value( $opt_name, $opts->{$opt_name} );
        } else {
            Carp::croak("Option not recognized: '$opt_name'");
        }
    }

    return $self;
}

sub set_value ( $self, $key, $value ) {
    if ( SETTINGS_INT()->{$key} ) {
        $self->set_int_value( $key, $value );
    } elsif ( SETTINGS_STR()->{$key} ) {
        $self->set_str_value( $key, $value );
    } else {
        Carp::croak("Option not recognized: '$key'");
    }
}

sub get_value ( $self, $key ) {
    if ( SETTINGS_INT()->{$key} ) {
        $self->get_int_value($key);
    } elsif ( SETTINGS_STR()->{$key} ) {
        $self->get_str_value($key);
    } else {
        Carp::croak("Option not recognized: '$key'");
    }
}

sub settings ($self) {
    return $self->{'settings'};
}

sub DESTROY ($self) {
    my $settings = $self->{'settings'}
        or die "Cannot clear instance without settings";

    # FIXME: This fails in tests - not sure when it should be cleaned up
    eval { _free_settings($settings); 1; };
}

1;

__END__

=pod

=head1 SYNOPSIS

=head1 DESCRIPTION

This module implements an interface to C<libpwquality> available
L<here|https://github.com/libpwquality/libpwquality/>.

Installing it on Debian and Debian-based distros:

    apt install libpwquality1

I had written it against Debian version 1.4.2-1build1. If you find
differences, please report via GitHub and I'll do my best to handle it.

If you have use for this and need an L<Alien> module to install the library
for you as a dependency, let me know.

=head1 METHODS

The following methods are available:

=head2 C<new>

    my $pwq = Lib::PWQuality->new();

Creates a new C<Lib::PWQuality> (C<libpwquality>) object.

=head2 C<check>

    # Checks strength of password
    my $res = $pwq->check( $password );

    # Checks strength of new versus old passwords
    my $res = $pwq->check( $new_password, $old_password );

    # Checks strength of new versus old passwords and uses user-data
    my $res = $pwq->check( $new_password, $old_password, $username );

Returns a string with values from L<Lib::PWQuality::Return>.

=head2 C<get_int_value>

    my $res = $pwq->get_int_value('MIN_LENGTH');

Returns a string with values from L<Lib::PWQuality::Return>.

See available integer values under C<INTEGER VALUES> below.

Alternatively, see C<get_value>.

=head2 C<get_str_value>

    my $res = $pwq->get_str_value('BAD_WORDS');

Returns a string with values from L<Lib::PWQuality::Return>.

See available integer values under C<INTEGER VALUES> below.

Alternatively, see C<get_value>.

=head2 C<get_value($key)>

    my $res = $pwq->get_value('MIN_LENGTH');

This method is a simpler form for getting a value. It helps you avoid
the call to C<get_int_value> and C<get_str_value>. It works by understanding
what kind of setting it needs to be and calls the right one.

Returns a string with values from L<Lib::PWQuality::Return>.

=head2 C<generate>

    my $password = $pwq->generate($entropy_bits);

Returns a new password.

=head2 C<read_config($filename)>

    my $res = $pwq->read_config($filename);

This reads a configuration file.

Returns a string with values from L<Lib::PWQuality::Return>.

=head2 C<set_value( $key, $value )>

    my $res = $pwq->set_value( 'MIN_LENGTH' => 10 );

This method is a simpler form for setting a value. It helps you avoid
the call to C<set_int_value> and C<set_str_value>. It works by understanding
what kind of setting it needs to be and calls the right one.

Returns a string with values from L<Lib::PWQuality::Return>.

=head2 C<set_option>

    my $res = $pwq->set_option('minlen=10');

This sets options using a key=value pair. This particular method uses
different naming for the options than the one for integer or string values.

The following options are used:

=over 4

=item * C<difok>

=item * C<minlen>

=item * C<dcredit>

=item * C<ucredit>

=item * C<lcredit>

=item * C<ocredit>

=item * C<minclass>

=item * C<maxrepeat>

=item * C<maxclassrepeat>

=item * C<maxsequence>

=item * C<gecoscheck>

=item * C<dictcheck>

=item * C<usercheck>

=item * C<usersubstr>

=item * C<enforcing>

=item * C<badwords>

=item * C<dictpath>

=item * C<retry>

=item * C<enforce_for_root>

=item * C<local_users_only>

=back

Returns a string with values from L<Lib::PWQuality::Return>.

=head2 C<set_int_value>

    my $res = $pwq->set_int_value( 'MIN_LENGTH' => 20 );

Returns a string with values from L<Lib::PWQuality::Return>.

See available integer values under C<INTEGER VALUES> below.

Alternatively, see C<set_value>.

=head2 C<set_str_value>

    my $res = $pwq->set_str_value( 'BAD_WORDS', 'foo' );

Returns a string with values from L<Lib::PWQuality::Return>.

See available integer values under C<INTEGER VALUES> below.

Alternatively, see C<set_value>.

=head2 C<settings>

    my $settings = $pwq->settings();
    printf "Minimum length: %d\n", $settings->min_length();

Returns the L<Lib::PWQuality::Settings> object.

=head1 BENCHMARKS

=over 4

=item * Checking password quality

=item * Generating password

=back

=head1 INTEGER VALUES

=over 4

=item * C<DIFF_OK>

=item * C<MIN_LENGTH>

=item * C<DIG_CREDIT>

=item * C<UP_CREDIT>

=item * C<LOW_CREDIT>

=item * C<OTH_CREDIT>

=item * C<MIN_CLASS>

=item * C<MAX_REPEAT>

=item * C<MAX_CLASS_REPEAT>

=item * C<MAX_SEQUENCE>

=item * C<GECOS_CHECK>

=item * C<DICT_CHECK>

=item * C<USER_CHECK>

=item * C<USER_SUBSTR>

=item * C<ENFORCING>

=item * C<RETRY_TIMES>

=item * C<ENFORCE_ROOT>

=item * C<LOCAL_USERS>

=back

=head1 STRING VALUES

=over 4

=item * C<BAD_WORDS>

=item * C<DICT_PATH>

=back

=head1 COVERAGE

=head1 SEE ALSO

This module uses L<FFI::Platypus> to connect to the C library and
L<FFI::C> to define the object structs.

These modules also provide quality checks for passwords:

=over 4

=item * Foo

=back

These modules also generate passwords:

=over 4

=item * L<App::Genpass>

=back
