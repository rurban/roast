module Test::Tap;

use Test;

proto sub tap_ok(|) is export { * }

multi sub tap_ok ($s,$expected,$text,:$sort,:&after-tap,:$timeout is copy = 5) {
    ok $s ~~ Supply, "{$s.^name} appears to be doing Supply";

    my @res;
    my $done;
    $s.tap({ @res.push($_) }, :done( {$done = True} ));
    after-tap() if &after-tap;

    $timeout *= 10;
    for ^$timeout { last if $done or $s.done; sleep .1 }
    ok $done, "$text was really done";
    @res .= sort if $sort;
    is_deeply @res, $expected, $text;
}

=begin pod

=head1 NAME

Test::Tap - Extra utility code for testing Supply

=head1 SYNOPSIS

  use Test;
  use Test::Tap;

  tap_ok( $supply, [<a b c>], "comment" );

  tap_ok( $supply,[<a b c>],"comment",:sort,:after-tap( {...} ),:timeout(50) );

=head1 DESCRIPTION

This module is for Supply test code.

=head1 FUNCTIONS

=head2 tap_ok( $s, [$result], "comment" )

Takes 3 positional parameters: the C<Supply> to be tested, an array with the
expected values, and a comment to describe the test.  Good for B<3> tests.

First tests whether the first positional is a Supply.  Then attempts to put a
C<.tap> on the Supply.  Then runs any code specified to be run after the tap.
Then waits for the Supply to be C<done>, or until the timeout has passed.
Emits a fail if the timeout has passed.  Then sorts the values as received from
the Supply if so indicated.  Then tests the values received.

Takes optional named parameters:

=over 4

=item :sort

Boolean indicating whether to sort the values provided by the supply before
checking it against the desired result.  Default is no sorting.

=item :after-tap( {...} )

Optional code to be executed after a tap has been made on the given C<Supply>.
By default, does B<not> execute any code.

=item :timeout(50)

Optional timeout specification: defaults to B<5> (seconds).

=back

=end pod

# vim: ft=perl6
