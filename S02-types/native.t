use v6;
use Test;

plan 15;

{
    my int $x;
    is $x, 0, 'int default value';
    is $x + 1, 1, 'can do basic math with int';
}

{
    my num $num;
    is $num, NaN, 'num default value';
    $num = 3e0;
    ok $num * 2e0 == 6e0, 'can do basic math with num';
}

{
    my str $str;
    is $str, '', 'str default value';
    my str $s2 = 'foo';
    is $s2 ~ $s2, 'foofoo', 'string concatentation with native strings';
}

{
    multi f(int $x) { 'int' }
    multi f(Int $x) { 'Int' }
    multi f(num $x) { 'num' }
    multi f(Num $x) { 'Num' }
    multi f(str $x) { 'str' }
    multi f(Str $x) { 'Str' }
    my int $int = 3;
    my Int $Int = 4;
    my num $num = 5e0;
    my Num $Num = 6e0;
    my str $str = '7';
    my Str $Str = '8';
    is f($int), 'int', 'can identify native type with multi dispatch (int)';
    is f($Int), 'Int', 'can identify non-native type with multi dispatch (Int)';
    is f($num), 'num', 'can identify native type with multi dispatch (num)';
    is f($Num), 'Num', 'can identify non-native type with multi dispatch (Num)';
    is f($str), 'str', 'can identify native type with multi dispatch (str)';
    is f($Str), 'Str', 'can identify non-native type with multi dispatch (Str)';

    is $int * $Int, 12, 'can do math with mixed native/boxed ints';
    is_approx $num * $Num, 30e0, 'can do math with mixed native/boxed nums';
    is $str ~ $Str, '78', 'can concatenate native and boxed strings';
}

# vim: ft=perl6