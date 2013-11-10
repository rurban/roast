use v6;
use Test;

plan 17;

#?rakudo.parrot skip 'NYI'
{
    my $p = Publisher.new;
    
    my @vals;
    my $saw_last;
    my $tap = $p.tap(
        -> $val { @vals.push($val) },
        { $saw_last = True });

    $p.next(1);
    is @vals.join, "1", "Tap got initial value";
    nok $saw_last, "No last yet";
    
    $p.next(2);
    $p.next(3);
    $p.last;
    is ~@vals, "1 2 3", "Tap saw all values";
    ok $saw_last, "Saw last";
}

#?rakudo.parrot skip 'NYI'
{
    my $p = Publisher.new;
    
    my @tap1_vals;
    my @tap2_vals;
    my $tap1 = $p.tap(-> $val { @tap1_vals.push($val) });
    
    $p.next(1);
    is @tap1_vals.join, "1", "First tap got initial value";
    
    my $tap2 = $p.tap(-> $val { @tap2_vals.push($val) });
    $p.next(2);
    is ~@tap1_vals, "1 2", "First tap has both values";
    is ~@tap2_vals, "2", "Second tap missed first value";
    
    $tap1.close;
    $p.next(3);
    is ~@tap1_vals, "1 2", "First tap closed, missed third value";
    is ~@tap2_vals, "2 3", "Second tap gets third value";
}

#?rakudo.parrot skip 'NYI'
{
    my $p = Publish.for(1..10, :scheduler(CurrentThreadScheduler));
    
    my @a1;
    my $tap1 = $p.tap(
        -> $val { @a1.push($val) },
        { @a1.push("end") });
    is ~@a1, "1 2 3 4 5 6 7 8 9 10 end", "Synchronous publish worked";
    
    my @a2;
    my $tap2 = $p.tap(
        -> $val { @a2.push($val) },
        { @a2.push("end") });
    is ~@a2, "1 2 3 4 5 6 7 8 9 10 end", "Second tap also gets all values";
}

#?rakudo.parrot skip 'NYI'
{
    my $p = Publish.for(1..5);
    my $c = $p.Channel;
    my @a;
    loop {
        winner(
            $c        => { @a.push($^val) },
            $c.closed => { @a.push("done"); last }
        );
    }
    is ~@a, "1 2 3 4 5 done", "Publish.for and .Channel work";
}

#?rakudo.parrot skip 'NYI'
{
    my $p = Publish.for(2..6);
    my @a;
    for $p.list {
        @a.push($_);
    }
    is ~@a, "2 3 4 5 6", "Publish.for and .list work";
}

#?rakudo.parrot skip 'NYI'
{
    my $p1 = Publisher.new;
    my $p2 = Publisher.new;

    my @res;
    my $tap = $p1.zip($p2, &infix:<~>).tap({ @res.push($_) });

    $p1.next(1);
    $p1.next(2);
    $p2.next('a');
    $p2.next('b');
    $p2.next('c');
    $p1.last();
    $p2.last();
    
    is @res.join(','), '1a,2b', 'zipping taps works';
}

#?rakudo.parrot skip 'NYI'
{
    my $p1 = Publisher.new;
    my $p2 = Publisher.new;

    my @res;
    my $tap = $p1.merge($p2).tap({ @res.push($_) });

    $p1.next(1);
    $p1.next(2);
    $p2.next('a');
    $p1.next(3);
    $p1.last();
    $p2.next('b');
    
    is @res.join(','), '1,2,a,3,b', "merging taps works";
}

#?rakudo.parrot skip 'NYI'
{
    my $p1 = Publish.for(1..10, :scheduler(CurrentThreadScheduler));
    my @res;
    $p1.grep(* > 5).tap({ @res.push($_) });
    is ~@res, '6 7 8 9 10', "grepping taps works";
}

#?rakudo.parrot skip 'NYI'
{
    my $p1 = Publish.for(1..5, :scheduler(CurrentThreadScheduler));
    my @res;
    $p1.map(2 * *).tap({ @res.push($_) });
    is ~@res, '2 4 6 8 10', "mapping taps works";
}