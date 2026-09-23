gap> START_TEST("escalate.tst");

# SmallGroup(7^7, 101827).  Depending on the series the MeatAxe chooses,
# the ag part has an orbit of 2058 points on one section; 2000 blocks of
# those would be 4 million vector-matrix products before the first attempt
# at the set stabilizer.  The first round of every stabilizer computation
# has at most PG_ESCALATE_POINTS points, or one block, and one step of the
# enumeration beyond that, which adds at most one block per generator.
gap> G := PcGroupCode( 34483991951468226442561274477577865504824597029071, 7^7 );;
gap> rounds := [];;
gap> SetInfoLevel( InfoAutGrp, 3 );
gap> SetInfoHandler( InfoAutGrp, function( cls, lev, msg )
>      msg := Concatenation( List( msg, String ) );
>      if PositionSublist( msg, "round 1:" ) <> fail then
>        msg := Filtered( SplitString( msg, " " ), x -> x <> "" );
>        # blocks, points per block, generators
>        Add( rounds, List( msg{[ 3, 6, 10 ]}, Int ) );
>      fi;
>    end );
gap> for seed in [1..6] do
>      Reset( GlobalMersenneTwister, seed );; Reset( GlobalRandomSource, seed );;
>      if AutomorphismGroupPGroup( G ).size <> 13841287201 then
>        Print( "wrong order for seed ", seed, "\n" );
>      fi;
>    od;
gap> SetInfoHandler( InfoAutGrp, DefaultInfoHandler );
gap> SetInfoLevel( InfoAutGrp, 0 );
gap> Length( rounds ) > 0;
true
gap> ForAll( rounds, r -> ( r[1] - r[3] ) * r[2] <= Maximum( PG_ESCALATE_POINTS, r[2] ) );
true

#
gap> STOP_TEST("escalate.tst", 1);
