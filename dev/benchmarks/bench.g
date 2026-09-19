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
  [ "3^27",
    # p-quotients of random finitely presented groups, of order 3^27 and 5^26.
    # The kernel on the Frattini quotient has an orbit of length 3^8 resp. 5^8.
    {} -> PcGroupCode( 34107235622955614594649622663806069599727925006187862921539921803051965830944749797962621071927053430224384481968597611680634365209645952646890921047593197265883965752764432453489125506695894153457595288832643828096713552528848874034309053780494970357442454783626120170457326770139410919884027110460792618671773975315136345969430110659930850839385612700439788902890429612006122576317015640351787452199161099955921858934069277822270681421327142920462221026178740808587156139428725899780549156951986752198362696305130880337321826529143173084490015208482240702774664800565295015812982703779568705274648252299735578506675127946215163903, 3^27 ),
    2 * 3^84, 10^6 ],
  [ "5^26",
    {} -> PcGroupCode( 1180197644356035218666780480452727575339641865181036842298945225074104694823922897754944667682138221902390662217242768251015406463358212739252487006245927141481772802937305979973361998788496256585896142500280960247424177344843479680374816415711799939753736327546011375994705960308147639314979839164742870366511264648428377138149852314109864365537913425021580537996144535572242965612481111148593371380878408592952471074954341363830089949636621476578013387737087214190982282161712646726565994893568000026214400000000000087960930222080000000000000000000123794003928538027905296171082786211676236281245771631022787631499412465929214972559970799565668447289219471275094058369114245743823489889838366523181268929314030411311406956401683932733811416485416258445576309020898016857809400153409554560638077503692894062690844299981802726486018361343, 5^26 ),
    2^2 * 3^2 * 5^71, 10^6 ],
  [ "3^29-ELO02",
    # the group of order 3^29 of [ELO02, Sec. 12.2]
    {} -> PcGroupCode( 222065104328105494323477498496453850150189419646857335164787910028489216785377685112737867018889053177725740734088006724680297091058558347607113065163884522663806642367216363109182215706477905093198862311937471010947333401236844342213286612547350910826764409696629874898911465514398853986966668841603979302132187303747322730024971295926371983495308740879994000971215000702620307079307995022298570228587644986026400117445590454562711883464105792898014023950544270231175550497528017183158713323036523323549469257155691200062225934647733364448626935546932819779026684981785684222597255098937863686845253006444280284864881845814153905657851898123971346427590797881658490825310003214397722736655347493744649054147339098161159060559788093875173453544293336798094772822421954108563398158198761713873588673189551210024579688607592549399700730150901021257485226769107960244726440010891599357126594002671366026807847448657259331143386866402462798144718813581513052987718728251291105105128735527587285627562449954301782557956523076290700977638006569683836739947385736746353405894429821109300542213184748456877812334815544233943738146334010185503079266472326615719157680363604812489501706697071966501510953856669770011892745639145839135629650039930880, 3^29 ),
    2^6 * 3^73 * 13, 10^6 ],

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
