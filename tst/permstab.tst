gap> START_TEST("permstab.tst");
gap> SetInfoLevel( InfoAutGrp, 1 );

# Special 2-groups of order 512 whose automorphism group induces a small
# group on G/Phi(G): the orbit of the allowable subgroup under GL(6,2) has
# length 10^8 to 10^10 and must be found as a set stabiliser.
gap> G := PcGroupCode( 103045690560068391423508120999240094531550914947096312619671359, 512 );;  # SmallGroup(512, 10481128)
gap> A := AutomorphismGroupPGroup( G );;
#I  step 1: 2^6 -- init automorphisms 
#I  step 2: 2^3 -- aut grp has size 20158709760
#I  final step: convert
gap> A.size;
262144
gap> B := ConvertHybridAutGroup( A );;
gap> ForAll( GeneratorsOfGroup( B ), x -> IsGroupHomomorphism( x ) and IsBijective( x ) );
true
gap> G := PcGroupCode( 201655727495936792097208895242095334952578333282880313040703, 512 );;  # SmallGroup(512, 10476779)
gap> A := AutomorphismGroupPGroup( G );;
#I  step 1: 2^6 -- init automorphisms 
#I  step 2: 2^3 -- aut grp has size 20158709760
#I  final step: convert
gap> A.size;
1572864

# The orbit budget
gap> AUTPGRP_PERM_STAB := false;;
gap> AutomorphismGroupPGroup( G : OrbitLimit := 1000 );
#I  step 1: 2^6 -- init automorphisms 
#I  step 2: 2^3 -- aut grp has size 20158709760
#I  step 2: orbit limit exceeded
fail
gap> AUTPGRP_PERM_STAB := true;;
gap> A := AutomorphismGroupPGroup( G : OrbitLimit := 1000 );;
#I  step 1: 2^6 -- init automorphisms 
#I  step 2: 2^3 -- aut grp has size 20158709760
#I  final step: convert
gap> A.size;
1572864

# The permutation domain as the closure of the lines of the subspace:
# attempts that run out of their budget are continued by the next one
gap> MakeReadWriteGlobal( "AUTPGRP_PERM_FULL_LIMIT" );
gap> AUTPGRP_PERM_FULL_LIMIT := 1;;
gap> log := [];;
gap> SetInfoLevel( InfoAutGrp, 3 );
gap> SetInfoHandler( InfoAutGrp, function( cls, lev, msg )
>      msg := Concatenation( List( msg, String ) );
>      if PositionSublist( msg, "line closure" ) <> fail
>         or PositionSublist( msg, "set stabilizer on" ) <> fail then
>        Add( log, msg );
>      fi;
>    end );
gap> A := AutomorphismGroupPGroup( G );;
gap> SetInfoHandler( InfoAutGrp, DefaultInfoHandler );
gap> A.size;
1572864
gap> ForAny( log, x -> PositionSublist( x, "line closure not done" ) <> fail );
true
gap> PositionSublist( log[Length( log )], "set stabilizer on" ) <> fail;
true

# a closure with too many lines: the orbit is enumerated, up to its limit
gap> MakeReadWriteGlobal( "AUTPGRP_PERM_DOMAIN_LIMIT" );
gap> AUTPGRP_PERM_DOMAIN_LIMIT := 10;;
gap> SetInfoLevel( InfoAutGrp, 1 );
gap> AutomorphismGroupPGroup( G : OrbitLimit := 10000 );
#I  step 1: 2^6 -- init automorphisms 
#I  step 2: 2^3 -- aut grp has size 20158709760
#I  step 2: orbit limit exceeded
fail
gap> AUTPGRP_PERM_FULL_LIMIT := 10^5;; AUTPGRP_PERM_DOMAIN_LIMIT := 10^6;;
gap> MakeReadOnlyGlobal( "AUTPGRP_PERM_FULL_LIMIT" );
gap> MakeReadOnlyGlobal( "AUTPGRP_PERM_DOMAIN_LIMIT" );

# The set stabilizer at the first opportunity, for groups whose ag part
# moves the subspace: the orders found by enumeration
gap> MakeReadWriteGlobal( "AUTPGRP_ESCALATE_BLOCKS" );
gap> AUTPGRP_ESCALATE_BLOCKS := 1;;
gap> used := 0;;
gap> SetInfoLevel( InfoAutGrp, 2 );
gap> SetInfoHandler( InfoAutGrp, function( cls, lev, msg )
>      msg := Concatenation( List( msg, String ) );
>      if PositionSublist( msg, "ag-orbit 2, " ) <> fail
>         and PositionSublist( msg, "(set stabilizer)" ) <> fail then
>        used := used + 1;
>      fi;
>    end );
gap> for code in [ 216784607404254823527,      # SmallGroup(729, 132)
>                  216784607411143967847 ] do  # SmallGroup(729, 135)
>      G := PcGroupCode( code, 729 );
>      AUTPGRP_PERM_STAB := false;; A := AutomorphismGroupPGroup( G );
>      AUTPGRP_PERM_STAB := true;;  B := AutomorphismGroupPGroup( G );
>      Print( A.size = B.size, " ", B.size, "\n" );
>    od;
true 472392
true 59049
gap> used > 0;
true

# a group of order 5^13 where the automorphism lifted from the set
# stabilizer moves the subspace within its ag orbit and is corrected by the
# transversal; the series chosen by the MeatAxe must be the right one
gap> G := PcGroupCode( 5605193871074593139975521182096050399791949368835240269520205604047990992739869421348011584472666015625000000004096000016777216068719477861899935665661733230336955311458188251669882711304269951, 5^13 );;
gap> Reset( GlobalMersenneTwister, 1 );; Reset( GlobalRandomSource, 1 );;
gap> AUTPGRP_PERM_STAB := false;; A := AutomorphismGroupPGroup( G );;
gap> Reset( GlobalMersenneTwister, 1 );; Reset( GlobalRandomSource, 1 );;
gap> AUTPGRP_PERM_STAB := true;; B := AutomorphismGroupPGroup( G );;
gap> A.size = B.size;
true
gap> SetInfoHandler( InfoAutGrp, DefaultInfoHandler );
gap> SetInfoLevel( InfoAutGrp, 1 );
gap> AUTPGRP_ESCALATE_BLOCKS := 2000;;
gap> MakeReadOnlyGlobal( "AUTPGRP_ESCALATE_BLOCKS" );

#
gap> STOP_TEST("permstab.tst", 1);
