gap> START_TEST("");

#
gap> SetInfoLevel( InfoAutGrp, 1 );

#
gap> H := SmallGroup (729, 34);
<pc group of size 729 with 6 generators>
gap> A := AutomorphismGroupPGroup(H);
#I  step 1: 3^2 -- init automorphisms 
#I  step 2: 3^1 -- aut grp has size 8
#I  step 3: 3^2 -- aut grp has size 72
#I  step 4: 3^1 -- aut grp has size 5832
#I  final step: convert
rec( 
  agAutos := 
    [ Pcgs([ f1, f2, f3, f4, f5, f6 ]) -> [ f2, f1, f3^2, f5^2, f4^2, f6^2 ], 
      Pcgs([ f1, f2, f3, f4, f5, f6 ]) -> [ f1, f2^2, f3^2*f5, f4^2*f6, f5, 
          f6 ], Pcgs([ f1, f2, f3, f4, f5, f6 ]) -> 
        [ f1^2, f2^2, f3*f4^2*f5^2*f6, f4^2*f6, f5^2*f6, f6 ], 
      Pcgs([ f1, f2, f3, f4, f5, f6 ]) -> [ f1*f3, f2, f3*f5^2, f4*f6^2, f5, 
          f6 ], Pcgs([ f1, f2, f3, f4, f5, f6 ]) -> 
        [ f1, f2*f3, f3*f4, f4, f5*f6, f6 ], 
      Pcgs([ f1, f2, f3, f4, f5, f6 ]) -> [ f1*f4, f2, f3*f6^2, f4, f5, f6 ], 
      Pcgs([ f1, f2, f3, f4, f5, f6 ]) -> [ f1, f2*f4, f3, f4, f5, f6 ], 
      Pcgs([ f1, f2, f3, f4, f5, f6 ]) -> [ f1*f5, f2, f3, f4, f5, f6 ], 
      Pcgs([ f1, f2, f3, f4, f5, f6 ]) -> [ f1, f2*f5, f3*f6, f4, f5, f6 ], 
      Pcgs([ f1, f2, f3, f4, f5, f6 ]) -> [ f1*f6, f2, f3, f4, f5, f6 ], 
      Pcgs([ f1, f2, f3, f4, f5, f6 ]) -> [ f1, f2*f6, f3, f4, f5, f6 ] ], 
  agOrder := [ 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3 ], glAutos := [  ], 
  glOper := [  ], glOrder := 1, group := <pc group of size 729 with 
    6 generators>, one := IdentityMapping( <pc group of size 729 with 
    6 generators> ), size := 52488 )
gap> ConvertHybridAutGroup( A );
<group of size 52488 with 11 generators>
gap> H := SmallGroup (729, 34);;
gap> A := AutomorphismGroupPGroup(H);;
#I  step 1: 3^2 -- init automorphisms 
#I  step 2: 3^1 -- aut grp has size 8
#I  step 3: 3^2 -- aut grp has size 72
#I  step 4: 3^1 -- aut grp has size 5832
#I  final step: convert
gap> B := PcGroupAutPGroup( A );
<pc group of size 52488 with 11 generators>
gap> I := InnerAutGroupPGroup( B );
Group([ f5, f4^2*f8, f6^2*f9^2, f11^2, f10^2, <identity> of ... ])

#
gap> STOP_TEST( "" ,1);
