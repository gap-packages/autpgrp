#############################################################################
##
#W  orbstab.gi              AutPGrp package                      Bettina Eick
##

#############################################################################
##
#F BasesCompositionSeriesThrough( M, base )
##
BindGlobal( "BasesCompositionSeriesThrough", function( M, base )
    local full, chop, indu, smll, i, facb;

    full := IdentityMat( M.dimension, M.field );
    chop := [[]];

    # chop N
    if Length( base ) > 0 then
        indu := MTX.InducedActionSubmoduleNB( M, base );
        smll := MTX.BasesCompositionSeries( indu );
        for i in [2..Length( smll )] do
            smll[i] := smll[i] * base;
            Add( chop, EcheloniseMat( smll[i] ) );
        od;
    fi;

    # chop M/N
    if Length( base ) < Length( full ) then
        indu := MTX.InducedActionFactorModuleWithBasis( M, base );
        facb := indu[2];
        indu := indu[1];
        smll := MTX.BasesCompositionSeries( indu );
        for i in [2..Length( smll )] do
            smll[i] := smll[i] * facb;
            Append( smll[i], base );
            Add( chop, EcheloniseMat( smll[i] ) );
        od;
    fi;

    return chop;
end );

#############################################################################
##
#F PGOrbitStabilizer( <A>, <baseU>, <baseN>, <interrupt> )
##
## Replaces A by the stabilizer of U.  Returns fail if the orbit budget
## A.orbitLimit is exceeded, true otherwise.  <interrupt> is unused; other
## packages pass it, so it stays.
##
InstallGlobalFunction( PGOrbitStabilizer, 
    function( A, baseU, baseN, interrupt )
    local u, n, l, baseM, glMats, agMats, mats, modu, chop;

    # set up and catch some trivial cases 
    u := Length( baseU );
    n := Length( baseN );
    if u = 0 or ( A.glOrder = 1 and Length( A.agOrder ) = 0 ) then
        return true;
    fi;

    l := Length( baseU[1] );
    baseM := IdentityMat( l, A.field );
    if l = u then return true; fi;

    # print some info
    Info( InfoAutGrp, 3, "  dim U = ",u, "  dim N = ",n, "  dim M = ",l );

    # compute series
    glMats := List( A.glAutos, x -> x!.mat );
    agMats := List( A.agAutos, x -> x!.mat );
    mats   := Filtered( Concatenation( glMats, agMats ), x -> x<>1 );
    modu := GModuleByMats( mats, l, A.field );
    chop := [[], baseN, baseM];

    if AUTPGRP_CHOP_MULT then
        chop := BasesCompositionSeriesThrough( modu, chop[2] );
    fi;

    return PGOrbitStabilizerBySeries( A, baseU, chop );
end );
