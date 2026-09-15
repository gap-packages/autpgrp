gap> START_TEST("canonform.tst");

# Canonical forms of subspaces under UT(4,3), given by a pcgs of pairs whose
# second component acts
gap> F := GF(3);;
gap> pcgs := [];;
gap> for lev in [1..3] do
>      for i in [1..4-lev] do
>        m := IdentityMat( 4, F );; m[i][i+lev] := One( F );;
>        m := ImmutableMatrix( F, m );;
>        Add( pcgs, DirectProductElement( [ m, m ] ) );
>      od;
>    od;
gap> one := DirectProductElement( [ IdentityMat( 4, F ), IdentityMat( 4, F ) ] );;
gap> U := Immutable( PGTriangulizedBaseMat( Z(3)^0 * [[1,1,0,2],[0,0,1,1]] ) );;
gap> C := PGSubspaceCanonicalForm( pcgs, one, U, F );;
gap> PGTriangulizedBaseMat( U * C.tran[2] ) = C.cano;
true
gap> ForAll( C.stab, x -> PGTriangulizedBaseMat( C.cano * x[2] ) = C.cano );
true

# constant on the orbit, whose length is p^(|pcgs| - |stab|)
gap> orb := Orbit( Group( List( pcgs, x -> x[2] ) ), U, OnSubspacesByCanonicalBasis );;
gap> Length( orb ) = 3^( Length( pcgs ) - Length( C.stab ) );
true
gap> ForAll( orb, W -> PGSubspaceCanonicalForm( pcgs, one, W, F ).cano = C.cano );
true

# elements acting trivially stay in the stabilizer: act on F^4 / <e_4>
gap> qpcgs := List( pcgs, x -> DirectProductElement( [ x[1],
>                   ImmutableMatrix( F, x[2]{[1..3]}{[1..3]} ) ] ) );;
gap> qone := DirectProductElement( [ IdentityMat( 4, F ), IdentityMat( 3, F ) ] );;
gap> V := Immutable( PGTriangulizedBaseMat( Z(3)^0 * [[1,2,1]] ) );;
gap> D := PGSubspaceCanonicalForm( qpcgs, qone, V, F );;
gap> qorb := Orbit( Group( List( qpcgs, x -> x[2] ) ), V, OnSubspacesByCanonicalBasis );;
gap> Length( qorb ) * 3^Length( D.stab ) = 3^Length( qpcgs );
true

# kernel orbit 3^8 on each of 936 blocks: enumerating it exceeds 12 GB
gap> SetInfoLevel( InfoAutGrp, 0 );
gap> G := PcGroupCode( 34107235622955614594649622663806069599727925006187862921539921803051965830944749797962621071927053430224384481968597611680634365209645952646890921047593197265883965752764432453489125506695894153457595288832643828096713552528848874034309053780494970357442454783626120170457326770139410919884027110460792618671773975315136345969430110659930850839385612700439788902890429612006122576317015640351787452199161099955921858934069277822270681421327142920462221026178740808587156139428725899780549156951986752198362696305130880337321826529143173084490015208482240702774664800565295015812982703779568705274648252299735578506675127946215163903, 3^27 );;
gap> AutomorphismGroupPGroup( G ).size = 2 * 3^84;
true

#
gap> STOP_TEST("canonform.tst", 1);
