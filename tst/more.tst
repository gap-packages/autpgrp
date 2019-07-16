gap> START_TEST("more.tst");
gap> SetInfoLevel( InfoAutGrp, 1 );

#
#
#
gap> G:=SmallGroup(16,2);
<pc group of size 16 with 4 generators>
gap> StructureDescription(G);
"C4 x C4"

#
gap> A := AutomorphismGroupPGroup(G);;
#I  step 1: 2^2 -- init automorphisms 
#I  step 2: 2^2 -- aut grp has size 6
#I  final step: convert
gap> SortedList(A.agOrder); A.glOrder; A.size;
[ 2, 2, 2, 2 ]
6
96
gap> ConvertHybridAutGroup( A );
<group of size 96 with 6 generators>

#
gap> A := AutomorphismGroupPGroup(G, "Full");;
#I  step 1: 2^2 -- init automorphisms 
#I  step 2: 2^2 -- aut grp has size 6
#I  final step: convert
gap> SortedList(A.agOrder); A.glOrder; A.size;
[ 2, 2, 2, 2 ]
6
96
gap> ConvertHybridAutGroup( A );
<group of size 96 with 6 generators>

#
gap> A := AutomorphismGroupPGroup(G, "Over");;
#I  step 1: 2^2 -- init automorphisms 
#I  step 2: 2^2 -- aut grp has size 6
#I  final step: convert
gap> SortedList(A.agOrder); A.glOrder; A.size;
[ 2, 2, 2, 2, 2, 3 ]
1
96
gap> ConvertHybridAutGroup( A );
<group of size 96 with 6 generators>

#
gap> A := AutomorphismGroupPGroup(G, "Char");;
#I  step 1: 2^2 -- init automorphisms 
#I  step 2: 2^2 -- aut grp has size 6
#I  final step: convert
gap> SortedList(A.agOrder); A.glOrder; A.size;
[ 2, 2, 2, 2 ]
6
96
gap> ConvertHybridAutGroup( A );
<group of size 96 with 6 generators>

#
#
#
gap> G:=SmallGroup(32,50);
<pc group of size 32 with 5 generators>

#
gap> A := AutomorphismGroupPGroup(G);;
#I  step 1: 2^4 -- init automorphisms 
#I  step 2: 2^1 -- aut grp has size 120
#I  final step: convert
gap> SortedList(A.agOrder); A.glOrder; A.size;
[ 2, 2, 2, 2 ]
120
1920
gap> ConvertHybridAutGroup( A );
<group of size 1920 with 6 generators>

#
gap> A := AutomorphismGroupPGroup(G, "Full");;
#I  step 1: 2^4 -- init automorphisms 
#I  step 2: 2^1 -- aut grp has size 20160
#I  final step: convert
gap> SortedList(A.agOrder); A.glOrder; A.size;
[ 2, 2, 2, 2 ]
120
1920
gap> ConvertHybridAutGroup( A );
<group of size 1920 with 7 generators>

#
gap> A := AutomorphismGroupPGroup(G, "Over");;
#I  step 1: 2^4 -- init automorphisms 
#I  step 2: 2^1 -- aut grp has size 120
#I  final step: convert
gap> SortedList(A.agOrder); A.glOrder; A.size;
[ 2, 2, 2, 2 ]
120
1920
gap> ConvertHybridAutGroup( A );
<group of size 1920 with 6 generators>

#
gap> A := AutomorphismGroupPGroup(G, "Char");;
#I  step 1: 2^4 -- init automorphisms 
#I  step 2: 2^1 -- aut grp has size 20160
#I  final step: convert
gap> SortedList(A.agOrder); A.glOrder; A.size;
[ 2, 2, 2, 2 ]
120
1920
gap> ConvertHybridAutGroup( A );
<group of size 1920 with 7 generators>

#
#
#
gap> G := SmallGroup(3^5, 61);
<pc group of size 243 with 5 generators>
gap> StructureDescription(G);
"C9 x C3 x C3 x C3"

#
gap> A := AutomorphismGroupPGroup(G);;
#I  step 1: 3^4 -- init automorphisms 
#I  step 2: 3^1 -- aut grp has size 606528
#I  final step: convert
gap> SortedList(A.agOrder); A.glOrder; A.size;
[ 2, 2, 3, 3, 3, 3, 3, 3, 3 ]
5616
49128768
gap> ConvertHybridAutGroup( A );
<group of size 49128768 with 11 generators>

#
gap> A := AutomorphismGroupPGroup(G, "Full");;
#I  step 1: 3^4 -- init automorphisms 
#I  step 2: 3^1 -- aut grp has size 24261120
#I  final step: convert
gap> SortedList(A.agOrder); A.glOrder; A.size;
[ 2, 2, 3, 3, 3, 3, 3, 3, 3 ]
5616
49128768
gap> ConvertHybridAutGroup( A );
<group of size 49128768 with 11 generators>

#
gap> A := AutomorphismGroupPGroup(G, "Over");;
#I  step 1: 3^4 -- init automorphisms 
#I  step 2: 3^1 -- aut grp has size 606528
#I  final step: convert
gap> SortedList(A.agOrder); A.glOrder; A.size;
[ 2, 2, 3, 3, 3, 3, 3, 3, 3 ]
5616
49128768
gap> ConvertHybridAutGroup( A );
<group of size 49128768 with 11 generators>

#
gap> A := AutomorphismGroupPGroup(G, "Char");;
#I  step 1: 3^4 -- init automorphisms 
#I  step 2: 3^1 -- aut grp has size 606528
#I  final step: convert
gap> SortedList(A.agOrder); A.glOrder; A.size;
[ 2, 3, 3, 3, 3 ]
303264
49128768
gap> ConvertHybridAutGroup( A );
<group of size 49128768 with 9 generators>

#
#
#
gap> G := SmallGroup(11^5, 81);
<pc group of size 161051 with 5 generators>
gap> StructureDescription(G);
"C11 x C11 x ((C11 x C11) : C11)"

#
gap> A := AutomorphismGroupPGroup(G);;
#I  step 1: 11^4 -- init automorphisms 
#I  step 2: 11^1 -- aut grp has size 2551047840000
#I  final step: convert
gap> SortedList(A.agOrder); A.glOrder; A.size;
[ 2, 2, 5, 5, 11, 11, 11, 11, 11, 11, 11, 11 ]
1742400
37349891425440000
gap> ConvertHybridAutGroup( A );
<group of size 37349891425440000 with 14 generators>

#
gap> A := AutomorphismGroupPGroup(G, "Full");;
#I  step 1: 11^4 -- init automorphisms 
#I  step 2: 11^1 -- aut grp has size 41393302251840000
#I  final step: convert
gap> SortedList(A.agOrder); A.glOrder; A.size;
[ 2, 5, 11, 11, 11, 11 ]
255104784000
37349891425440000
gap> ConvertHybridAutGroup( A );
<group of size 37349891425440000 with 16162 generators>

#
gap> A := AutomorphismGroupPGroup(G, "Over");;
#I  step 1: 11^4 -- init automorphisms 
#I  step 2: 11^1 -- aut grp has size 2551047840000
#I  final step: convert
gap> SortedList(A.agOrder); A.glOrder; A.size;
[ 2, 2, 5, 5, 11, 11, 11, 11, 11, 11, 11, 11 ]
1742400
37349891425440000
gap> ConvertHybridAutGroup( A );
<group of size 37349891425440000 with 14 generators>

#
gap> A := AutomorphismGroupPGroup(G, "Char");;
#I  step 1: 11^4 -- init automorphisms 
#I  step 2: 11^1 -- aut grp has size 2551047840000
#I  final step: convert
gap> SortedList(A.agOrder); A.glOrder; A.size;
[ 2, 5, 11, 11, 11, 11 ]
255104784000
37349891425440000
gap> ConvertHybridAutGroup( A );
<group of size 37349891425440000 with 11 generators>

#
gap> STOP_TEST( "more.tst" ,1);
