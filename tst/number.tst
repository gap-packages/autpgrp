gap> START_TEST("number.tst");
gap> SetInfoLevel( InfoAutGrp, 0 );

#
gap> NumberOfPClass2PGroups(4, 2);
[ 6, 54, 604, 3566, 6709, 3566, 604, 54, 6, 1 ]
gap> List([0..11], i -> NumberOfPClass2PGroups(4, 2, i));
[ 0, 6, 54, 604, 3566, 6709, 3566, 604, 54, 6, 1, 0 ]

#
gap> NumberOfPClass2PGroups(4, 3);
[ 6, 60, 1361, 23361, 66667, 23361, 1361, 60, 6, 1 ]
gap> List([0..11], i -> NumberOfPClass2PGroups(4, 3, i));
[ 0, 6, 60, 1361, 23361, 66667, 23361, 1361, 60, 6, 1, 0 ]

#
gap> NumberOfClass2LieAlgebras(4, 2);
[ 2, 4, 6, 4, 2, 1 ]
gap> List([0..7], i -> NumberOfClass2LieAlgebras(4, 2, i));
[ 1, 2, 4, 6, 4, 2, 1, 0 ]

#
gap> NumberOfClass2LieAlgebras(4, 3);
[ 2, 4, 6, 4, 2, 1 ]
gap> List([0..7], i -> NumberOfClass2LieAlgebras(4, 3, i));
[ 1, 2, 4, 6, 4, 2, 1, 0 ]

#
gap> NumberOfClass2AssocAlgebras(4, 2);
[ 27, 37269, 83200199, 37269, 27, 1 ]
gap> List([1..3], i -> NumberOfClass2AssocAlgebras(4, 2, i));
[ 27, 37269, 83200199 ]

#
gap> NumberOfClass2AssocAlgebras(4, 3);
[ 46, 3205858, 585449616953, 3205858, 46, 1 ]
gap> List([1..3], i -> NumberOfClass2AssocAlgebras(4, 3, i));
[ 46, 3205858, 585449616953 ]

#
gap> STOP_TEST( "number.tst" ,1);
