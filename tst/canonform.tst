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

# a stabilizer that is trivial before all rows are done, and nothing to do
gap> W := Immutable( Z(3)^0 * [[1,0,0,0],[0,1,0,0]] );;
gap> C := PGSubspaceCanonicalForm( pcgs{[5]}, one, W, F );;
gap> C.stab = [] and PGTriangulizedBaseMat( W * C.tran[2] ) = C.cano;
true
gap> PGSubspaceCanonicalForm( [], one, U, F ).cano = U;
true
gap> PGSubspaceCanonicalForm( pcgs, one, [], F ).stab = pcgs;
true

# over GF(4) a coordinate has several pivots
gap> F4 := GF(4);;
gap> pcgs4 := [];;
gap> for pos in [ [1,2], [2,3], [1,3] ] do
>      for lam in Basis( F4 ) do
>        m := IdentityMat( 3, F4 );; m[pos[1]][pos[2]] := lam;;
>        m := ImmutableMatrix( F4, m );;
>        Add( pcgs4, DirectProductElement( [ m, m ] ) );
>      od;
>    od;
gap> one4 := pcgs4[1]^0;;
gap> for U4 in [ [[Z(4),Z(4)^2,Z(4)^0]], [[Z(4)^0,Z(4),0*Z(4)],[0*Z(4),0*Z(4),Z(4)^0]] ] do
>      U4 := Immutable( PGTriangulizedBaseMat( U4 ) );
>      for sub in [ pcgs4, pcgs4{[2,3,5,6]} ] do
>        C := PGSubspaceCanonicalForm( sub, one4, U4, F4 );
>        orb := Orbit( Group( List( sub, x -> x[2] ) ), U4, OnSubspacesByCanonicalBasis );
>        if Length( orb ) <> 2^( Length( sub ) - Length( C.stab ) )
>           or C.tran[1] <> C.tran[2]
>           or ForAny( C.stab, x -> x[1] <> x[2]
>                or PGTriangulizedBaseMat( C.cano * x[2] ) <> C.cano )
>           or ForAny( orb, W -> PGSubspaceCanonicalForm( sub, one4, W, F4 ).cano <> C.cano ) then
>          Print( "wrong canonical form\n" );
>        fi;
>      od;
>    od;

# matrices that do not generate a p-group
gap> PGUnipotentFlagBasis( [ Z(3)^0 * [[0,1],[1,0]] ], 2, GF(3) );
Error, <mats> do not generate a p-group

# kernel orbit 3^8 on each of 936 blocks: enumerating it exceeds 12 GB
gap> SetInfoLevel( InfoAutGrp, 0 );
gap> G := PcGroupCode( 34107235622955614594649622663806069599727925006187862921539921803051965830944749797962621071927053430224384481968597611680634365209645952646890921047593197265883965752764432453489125506695894153457595288832643828096713552528848874034309053780494970357442454783626120170457326770139410919884027110460792618671773975315136345969430110659930850839385612700439788902890429612006122576317015640351787452199161099955921858934069277822270681421327142920462221026178740808587156139428725899780549156951986752198362696305130880337321826529143173084490015208482240702774664800565295015812982703779568705274648252299735578506675127946215163903, 3^27 );;
gap> AutomorphismGroupPGroup( G ).size = 2 * 3^84;
true

# Canonical forms at every opportunity and the checks of the package on:
# the order is the one found without canonical forms, and for the small
# groups it is the order of the group the generators generate.  The groups:
# no gl part; a gl part
# fixing the point; a gl orbit of several blocks, enumerated and as a set
# stabilizer.
gap> MakeReadWriteGlobal( "AUTPGRP_CANON_MIN_ORBIT" );
gap> MakeReadWriteGlobal( "AUTPGRP_ESCALATE_BLOCKS" );
gap> AUTPGRP_CANON_MIN_ORBIT := 1;;
gap> used := [];;
gap> SetInfoLevel( InfoAutGrp, 2 );
gap> SetInfoHandler( InfoAutGrp, function( cls, lev, msg )
>      Append( used, Filtered( msg, x -> IsString( x )
>                and PositionSublist( x, "kernel orbit" ) <> fail ) );
>    end );
gap> codes := [ [ 67665945, 32 ], [ 69206033, 64 ],
>      [ 15046327693606768025641179526938449971591705291162899276287134876474750041961669984375000000004096000016777216068719477861899935665661733230336955311458188251669882711237095551, 5^13 ] ];;
gap> for blocks in [ 2000, 1 ] do
>      AUTPGRP_ESCALATE_BLOCKS := blocks;
>      for c in codes do
>        G := PcGroupCode( c[1], c[2] );
>        AUTPGRP_CANON_FORM := false;; AUTPGRP_CHECK := false;;
>        A := AutomorphismGroupPGroup( G );
>        AUTPGRP_CANON_FORM := true;; AUTPGRP_CHECK := true;;
>        B := AutomorphismGroupPGroup( G );
>        if A.size <> B.size then Print( "wrong order for ", c, "\n" ); fi;
>        if Size( G ) > 64 then continue; fi;
>        H := Group( Concatenation( B.glAutos, B.agAutos ) );
>        SetIsGroupOfAutomorphismsFiniteGroup( H, true );
>        if Size( H ) <> B.size then Print( "wrong group for ", c, "\n" ); fi;
>      od;
>    od;

# which kernel orbits occur depends on the series the MeatAxe chooses
gap> ForAny( used, x -> PositionSublist( x, "enumerated" ) = 1 );
true
gap> ForAny( used, x -> PositionSublist( x, "set stabilizer" ) = 1 );
true

# the orbit limit is reached above the kernel
gap> G := PcGroupCode( 216782169967590115555, 729 );;  # SmallGroup(729, 154)
gap> AutomorphismGroupPGroup( G : OrbitLimit := 2 );
fail
gap> SetInfoHandler( InfoAutGrp, DefaultInfoHandler );
gap> SetInfoLevel( InfoAutGrp, 0 );
gap> AUTPGRP_CHECK := false;; AUTPGRP_CANON_MIN_ORBIT := 1000;; AUTPGRP_ESCALATE_BLOCKS := 2000;;
gap> MakeReadOnlyGlobal( "AUTPGRP_CANON_MIN_ORBIT" );
gap> MakeReadOnlyGlobal( "AUTPGRP_ESCALATE_BLOCKS" );

#
gap> STOP_TEST("canonform.tst", 1);
