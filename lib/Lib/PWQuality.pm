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

package Lib::PWQaulity::Error {

    FFI::C->enum( 'pwquality_error' => [
        [ 'PWQ_ERROR_SUCCESS'           =>   0 ],
        [ 'PWQ_ERROR_FATAL_FAILURE'     =>  -1 ],
        [ 'PWQ_ERROR_INTEGER'           =>  -2 ],
        [ 'PWQ_ERROR_CFGFILE_OPEN'      =>  -3 ],
        [ 'PWQ_ERROR_CFGFILE_MALFORMED' =>  -4 ],
        [ 'PWQ_ERROR_UNKNOWN_SETTING'   =>  -5 ],
        [ 'PWQ_ERROR_NON_INT_SETTING'   =>  -6 ],
        [ 'PWQ_ERROR_NON_STR_SETTING'   =>  -7 ],
        [ 'PWQ_ERROR_MEM_ALLOC'         =>  -8 ],
        [ 'PWQ_ERROR_TOO_SIMILAR'       =>  -9 ],
        [ 'PWQ_ERROR_MIN_DIGITS'        => -10 ],
        [ 'PWQ_ERROR_MIN_UPPERS'        => -11 ],
        [ 'PWQ_ERROR_MIN_LOWERS'        => -12 ],
        [ 'PWQ_ERROR_MIN_OTHERS'        => -13 ],
        [ 'PWQ_ERROR_MIN_LENGTH'        => -14 ],
        [ 'PWQ_ERROR_PALINDROME'        => -15 ],
        [ 'PWQ_ERROR_CASE_CHANGES_ONLY' => -16 ],
        [ 'PWQ_ERROR_ROTATED'           => -17 ],
        [ 'PWQ_ERROR_MIN_CLASSES'       => -18 ],
        [ 'PWQ_ERROR_MAX_CONSECUTIVE'   => -19 ],
        [ 'PWQ_ERROR_EMPTY_PASSWORD'    => -20 ],
        [ 'PWQ_ERROR_SAME_PASSWORD'     => -21 ],
        [ 'PWQ_ERROR_CRACKLIB_CHECK'    => -22 ],
        [ 'PWQ_ERROR_RNG'               => -23 ],
        [ 'PWQ_ERROR_GENERATION_FAILED' => -24 ],
        [ 'PWQ_ERROR_USER_CHECK'        => -25 ],
        [ 'PWQ_ERROR_GECOS_CHECK'       => -26 ],
        [ 'PWQ_ERROR_MAX_CLASS_REPEAT'  => -27 ],
        [ 'PWQ_ERROR_BAD_WORDS'         => -28 ],
        [ 'PWQ_ERROR_MAX_SEQUENCE'      => -29 ],
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
    'read_config' => [ 'pwquality_settings_t', 'string', 'opaque*' ] => 'pwquality_error',
    sub ( $xsub, $self, $filename ) {
        return $xsub->( $self->settings(), $filename, undef );
    },
);

# FIXME: Check results of everything that returns pwquality_error

$ffi->attach(
    'set_option' => [ 'pwquality_settings_t', 'string' ] => 'pwquality_error',
    sub ( $xsub, $self, $pair ) {
        my ($name) = split /=/xms;
        exists SETTINGS_ALL()->{$name}
            or Carp::croak("Unrecognized option: '$name'");

        return $xsub->( $self->settings(), $pair );
    },
);

$ffi->attach(
    'set_int_value',
    [ 'pwquality_settings_t', 'pwquality_setting', 'int' ],
    'pwquality_error',
    sub ( $xsub, $self, $key, $value ) {
        exists SETTINGS_INT()->{$key}
            or Carp::croak("Unrecognized option: '$key'");

        return $xsub->( $self->settings(), $key, $value );
    },
);

$ffi->attach(
    'set_str_value',
    [ 'pwquality_settings_t', 'pwquality_setting', 'string' ],
    'pwquality_error',
    sub ( $xsub, $self, $key, $value ) {
        exists SETTINGS_STR()->{$key}
            or Carp::croak("Unrecognized option: '$key'");

        return $xsub->( $self->settings(), $key, $value );
    },
);

$ffi->attach(
    'get_int_value',
    [ 'pwquality_settings_t', 'pwquality_setting', 'int*' ],
    'pwquality_error',
    sub ( $xsub, $self, $key ) {
        exists SETTINGS_INT()->{$key}
            or Carp::croak("Unrecognized option: '$key'");

        my $value;
        $xsub->( $self->settings(), $key, \$value );
        return $value;
    },
);

$ffi->attach(
    'get_str_value',
    [ 'pwquality_settings_t', 'pwquality_setting', 'string*' ],
    'pwquality_error',
    sub ( $xsub, $self, $key ) {
        exists SETTINGS_STR()->{$key}
            or Carp::croak("Unrecognized option: '$key'");

        my $value;
        $xsub->( $self->settings(), $key, \$value );
        return $value;
    },
);

$ffi->attach(
    'generate' => [ 'pwquality_settings_t', 'int', 'string*' ] => 'pwquality_error',
    sub ( $xsub, $self, $key ) {
        my $value;
        $xsub->( $self->settings(), $key, \$value );
        return $value;
    },
);

# auxerr is last arg
# XXX: The return can be pwquality_error (if it's negative)
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

# FIXME: mix user opts and default settings
sub new ( $class, $opts = {} ) {
    my $settings = _default_settings();
    my $self     = bless { 'settings' => $settings }, $class;
    return $self;
}

sub settings ($self) {
    return $self->{'settings'};
}

sub DESTROY ($self) {
    my $settings = $self->{'settings'}
        or die "Cannot clear instance without settings";

    _free_settings($settings);
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

=head2 C<read_config>

=head2 C<set_option>

=head2 C<set_int_value>

=head2 C<set_str_value>

=head2 C<get_int_value>

=head2 C<get_str_value>

=head2 C<generate>

=head2 C<check>

=head2 C<settings>

=head1 BENCHMARKS

=over 4

=item * Checking password quality

=item * Generating password

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
