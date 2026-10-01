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

#
gap> STOP_TEST("permstab.tst", 1);
