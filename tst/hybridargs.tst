gap> START_TEST("hybridargs.tst");
gap> SetInfoLevel( InfoAutGrp, 0 );

# PGHybridOrbitStabilizer as the Polycyclic package calls it in SchurCovers:
# six arguments, the automorphisms act themselves, and the points are
# subgroups, not subspaces
gap> G := PcGroupCode( 16385, 3^5 );;  # SmallGroup(3^5, 61)
gap> A := InitAutomorphismGroupOver( G );;
gap> size := A.glOrder * Product( A.agOrder );;
gap> U := Subgroup( A.group, [ Pcgs( A.group )[1] ] );;
gap> OnSubs := function( U, auto, info ) return Image( auto, U ); end;;
gap> PGHybridOrbitStabilizer( A, A.glAutos, A.agAutos, U, OnSubs, true );
true
gap> size / ( A.glOrder * Product( A.agOrder ) );
27
gap> ForAll( Concatenation( A.glAutos, A.agAutos ), a -> Image( a, U ) = U );
true

# but not eight
gap> PGHybridOrbitStabilizer( A, A.glAutos, A.agAutos, U, OnSubs, true, 1, 2 );
Error, PGHybridOrbitStabilizer takes six or seven arguments

#
gap> STOP_TEST("hybridargs.tst", 1);
