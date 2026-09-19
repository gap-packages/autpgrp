#############################################################################
##
##  Benchmarks for AutomorphismGroupPGroup: groups that were or are hard.
##
##  From the package directory:
##
##      gap -q --packagedirs . dev/benchmarks/bench.g > before.txt
##      ... change the code ...
##      gap -q --packagedirs . dev/benchmarks/bench.g > after.txt
##      gap -q -c 'before := "before.txt";; after := "after.txt";;' \
##          dev/benchmarks/compare.g
##
##  The script does not depend on the version of the package it is part
##  of, so it can also be run against another one.
##
##  A line of output is a name, the CPU time in ms for each of the random
##  seeds in BENCH_SEEDS, and one of
##
##      ok      the order of the automorphism group is the recorded one
##      WRONG   it is not
##      fail    the orbit limit of the case was exceeded
##
##  The seeds matter: the MeatAxe chooses the series the multiplicator is
##  split by at random, and the same group can take 20 ms along one series
##  and exhaust the memory along another.
##
##  Add  -c 'BENCH_SLOW := true;;'  for the cases that take minutes or do
##  not finish at all.
##
LoadPackage( "autpgrp" );
SetInfoLevel( InfoAutGrp, 0 );
SetPrintFormattingStatus( "*stdout*", false );   # no line breaks
if not IsBound( BENCH_SLOW ) then BENCH_SLOW := false; fi;
if not IsBound( BENCH_SEEDS ) then BENCH_SEEDS := [ 1, 2, 3 ]; fi;

# groups.g lies next to this file, whichever version of the package runs
Read( ReplacedString( INPUT_FILENAME(), "bench.g", "groups.g" ) );

BenchUT := function( n, p )
    return Image( IsomorphismPcGroup( SylowSubgroup( GL( n, p ), p ) ) );
end;

BenchWreath := function( n, p )
    local W, i;
    W := CyclicGroup( IsPermGroup, p );
    for i in [2..n] do
        W := WreathProduct( W, CyclicGroup( IsPermGroup, p ) );
    od;
    return Image( IsomorphismPcGroup( W ) );
end;

# name, function returning a group or a list of groups, the sum of the
# orders of their automorphism groups, orbit limit or infinity (a limit
# where a version without canonical forms would exhaust the memory)
BENCH_CASES := [

  # special groups of order 2^9 and groups of order 3^8 whose stabilizer
  # has an orbit of 10^7 to 10^10 subspaces: set stabilizer
  [ "512-10481128", {} -> PcGroupCode( 103045690560068391423508120999240094531550914947096312619671359, 512 ),
    262144, infinity ],
  [ "512-10476779", {} -> PcGroupCode( 201655727495936792097208895242095334952578333282880313040703, 512 ),
    1572864, infinity ],
  [ "6561-282763", {} -> PcGroupCode( 20904135034921108295081685526068260521185952655, 6561 ),
    43046721, infinity ],
  [ "6561-282765", {} -> PcGroupCode( 20904135034921108295081947459720570133799814031, 6561 ),
    43046721, infinity ],
  [ "6561-282767", {} -> PcGroupCode( 20904135034921108295081947459726656858372490127, 6561 ),
    43046721, infinity ],
  [ "6561-282769", {} -> PcGroupCode( 20904135034921108295081947459732744510658102159, 6561 ),
    43046721, infinity ],
  [ "16807-78", {} -> PcGroupCode( 275384336, 16807 ), 3984630451200, infinity ],

  # long orbits under the kernel on the Frattini quotient: canonical forms
  [ "3^27", BENCH_G327, 2 * 3^84, 10^6 ],
  [ "5^26", BENCH_G526, 2^2 * 3^2 * 5^71, 10^6 ],
  [ "3^29-ELO02", BENCH_G329, 2^6 * 3^73 * 13, 10^6 ],

  # [ELO02, Table 2]
  [ "UT(6,3)", {} -> BenchUT( 6, 3 ), 74384733888, infinity ],
  [ "UT(7,2)", {} -> BenchUT( 7, 2 ), 134217728, infinity ],
  [ "C2 wr C2 wr C2 wr C2 wr C2", {} -> BenchWreath( 5, 2 ), 1099511627776, infinity ],
  [ "C3 wr C3 wr C3", {} -> BenchWreath( 3, 3 ), 2^3 * 3^17, infinity ],

  # the cost of the easy cases
  [ "all of order 128", {} -> AllSmallGroups( 128 ), 163873387589696, infinity ],
  [ "all of order 729", {} -> AllSmallGroups( 729 ), 84130681810907250, infinity ],
];

BENCH_SLOW_CASES := [
  # rank 6, a section with 7 * 10^6 lines; not solved
  [ "6561-1395979", {} -> PcGroupCode( 40630155845260754765645298651537609028465811751296, 6561 ),
    0, 10^7 ],
];

if BENCH_SLOW then Append( BENCH_CASES, BENCH_SLOW_CASES ); fi;

BenchRun := function( case )
    local groups, seeds, times, res, seed, sum, t, G, A;
    groups := case[2]();
    if IsGroup( groups ) then groups := [ groups ]; fi;

    # many groups average over the series by themselves
    seeds := BENCH_SEEDS;
    if Length( groups ) > 1 then seeds := seeds{[1]}; fi;

    times := [];
    res := "ok";
    for seed in seeds do
        Reset( GlobalMersenneTwister, seed );
        Reset( GlobalRandomSource, seed );
        sum := 0;
        t := Runtime();
        for G in groups do
            if case[4] = infinity then
                A := AutomorphismGroupPGroup( G );
            else
                A := AutomorphismGroupPGroup( G : OrbitLimit := case[4] );
            fi;
            if A = fail then sum := fail; break; fi;
            sum := sum + A.size;
        od;
        Add( times, Runtime() - t );
        if sum = fail then
            res := "fail";
        elif sum <> case[3] then
            res := Concatenation( "WRONG ", String( sum ) );
        fi;

        # attributes stored in the groups would speed up the next seed
        groups := case[2]();
        if IsGroup( groups ) then groups := [ groups ]; fi;
    od;
    Print( ReplacedString( case[1], " ", "_" ), " ",
           JoinStringsWithSeparator( List( times, String ), " " ), " ", res,
           "\n" );
end;

# The first call in a session costs up to 1.6 s more than later ones.
for n in [ 16, 81, 125, 343 ] do
    for G in AllSmallGroups( n ) do AutomorphismGroupPGroup( G ); od;
od;

for case in BENCH_CASES do BenchRun( case ); od;
QUIT;
