gap> START_TEST("");

#
gap> SetInfoLevel( InfoAutGrp, 1 );

#
gap> G := SmallGroup( 32, 15 );
<pc group of size 32 with 5 generators>
gap> AutomorphismGroup(G);
#I  step 1: 2^2 -- init automorphisms 
#I  step 2: 2^2 -- aut grp has size 2
#I  step 3: 2^1 -- aut grp has size 32
#I  final step: convert
<group of size 64 with 6 generators>
gap> G := DihedralGroup( IsPermGroup, 2^5 );;
gap> IsPGroup(G);
true
gap> CanEasilyComputePcgs(G);
true
gap> IsFinite(G);
true
gap> A := AutomorphismGroup(G);
#I  step 1: 2^2 -- init automorphisms 
#I  step 2: 2^1 -- aut grp has size 2
#I  step 3: 2^1 -- aut grp has size 8
#I  step 4: 2^1 -- aut grp has size 32
#I  final step: convert
<group of size 128 with 7 generators>
gap> A.1;
Pcgs([ (2,16)(3,15)(4,14)(5,13)(6,12)(7,11)(8,10), 
  (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), (1,3,5,7,9,11,13,15)(2,4,6,8,10,
    12,14,16), (1,5,9,13)(2,6,10,14)(3,7,11,15)(4,8,12,16), 
  (1,9)(2,10)(3,11)(4,12)(5,13)(6,14)(7,15)(8,16) ]) -> 
[ (1,2)(3,16)(4,15)(5,14)(6,13)(7,12)(8,11)(9,10), 
  (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), (1,3,5,7,9,11,13,15)(2,4,6,8,10,
    12,14,16), (1,5,9,13)(2,6,10,14)(3,7,11,15)(4,8,12,16), 
  (1,9)(2,10)(3,11)(4,12)(5,13)(6,14)(7,15)(8,16) ]
gap> Order(A.1);
16

#
gap> STOP_TEST( "" ,1);
