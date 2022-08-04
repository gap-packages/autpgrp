#############################################################################
##
#W  initmat.gi               AutPGrp package                     Bettina Eick
##

#############################################################################
##
#F TwoStepCentralizersByLcs( G )
##
## The two-step-centralizers of lower p-central series of G.
##
BindGlobal( "TwoStepCentralizersByLcs", function( G )
    local pcgs, first, p, field, list, i, f, m, n, max, pcgsN, pcgsM, 
          pcgsH, gensL, gensC, pcgsR, new;

    # set up
    pcgs := SpecialPcgs( G );
    first := LGFirst( pcgs );
    p := PrimePGroup( G );
    field := GF(p);
    list := [];
    max := Length(pcgs);

    # run through lower p-central series
    for i in [3..Length(first)] do
        f := first[i-2];
        m := first[i-1];
        n := first[i];
        pcgsN := InducedPcgsByPcSequenceNC( pcgs, pcgs{[f..max]} );
        pcgsM := InducedPcgsByPcSequenceNC( pcgs, pcgs{[m..max]} );
        pcgsH := InducedPcgsByPcSequenceNC( pcgs, pcgs{[n..max]} );
        gensL := pcgsN mod pcgsM;
        gensC := pcgs mod pcgsM;
        pcgsR := pcgsM mod pcgsH;
        new := NextStepCentralizer( gensL, gensC, pcgsR, field );
        Append(new, pcgsM );
        #new := InducedPcgsByPcSequenceNC( pcgs, new );
        new := InducedPcgsByGeneratorsNC( pcgs, new );
        Add( list, SubgroupByPcgs( G, new ) );
    od;
    return list;
end );

#############################################################################
##
#F OmegaSubgroupsByLcs( G )
##
## The preimages of Omega-subgroups of G_i for all factors  G_i of the lower
## p-central series of G. 
##
BindGlobal( "OmegaSubgroupsByLcs", function( G )
    local pcgs, first, p, field, list, max, i, pcgsN, N, hom, F, ser, specF;

    # catch the trivial case
    p    := PrimePGroup( G );
    pcgs := SpecialPcgs( G );
    if ForAll( pcgs, x -> Order(x) = p ) then return []; fi;
  
    # set up
    first := LGFirst( pcgs );
    field := GF(p);
    list  := [];
    max   := Length(pcgs);

    # run through lower p-central series
    for i in [2..Length(first)] do
        pcgsN := InducedPcgsByPcSequenceNC( pcgs, pcgs{[first[i]..max]} );
        N := SubgroupByPcgs( G, pcgsN );
        hom := NaturalHomomorphismByNormalSubgroupNC( G, N );
        F := Image( hom );
        specF := SpecialPcgs(F);
        if ForAny( specF, x -> Order(x) > p ) and Size(F) < 10000 then
            ser := OmegaSeries( F );
            ser := List( ser, x -> PreImage( hom, x ) );
            Append( list, ser );
        fi;
    od;
    return list;
end );

#############################################################################
##
#F MaxSubIntersections(G)
##
BindGlobal( "MaxSubIntersections", function(G)
    local max, fp, fpset, fpbin, i, j;
    max := MaximalSubgroups(G);
    fp := List(max, IdGroup);
    fpset := Set(fp);
    fpbin := List(fpset, x -> []);
    for i in [1..Length(max)] do
        j := Position(fpset, fp[i]);
        Add(fpbin[j], max[i]);
    od;
    return List(fpbin, Intersection);
end );
        
#############################################################################
##
#F PGCharSubgroups( G )
##
BindGlobal( "PGCharSubgroups", function(G)
    local  cent, omega;
    cent := TwoStepCentralizersByLcs( G );
    omega := OmegaSubgroupsByLcs( G );
    if Size(G) <= 512 then 
        return Union(cent, omega, MaxSubIntersections(G));
    else
        return Union( cent, omega );
    fi;
end );

#############################################################################
##
#F FrattiniQuotientBase( <spec>, <U> )
##
BindGlobal( "FrattiniQuotientBase", function( spec, U )
    local r, frat, pcgs, subU, base;

    r := LGFirst(spec)[2];
    frat := InducedPcgsByPcSequenceNC( spec, spec{[r..Length(spec)]} );
    pcgs := spec mod frat;
    subU := Filtered(InducedPcgs(spec, U), x -> DepthOfPcElement(spec,x)<r);
    base := List( subU, x -> ExponentsOfPcElement( pcgs, x ) );
    return base;
end );
    
#############################################################################
##
#F InitAutomorphismGroupChar( G ) 
##
BindGlobal( "InitAutomorphismGroupChar", function( G )
    local r, p, chars, bases, S, H, A, z, spec, kern;

    Info( InfoAutGrp, 2, "  init automorphism group : Char ");

    # set up 
    r := RankPGroup( G );
    p := PrimePGroup( G );
    z := One(GF(p));
    spec := SpecialPcgs( G );

    # compute characteristic subgroups 
    Info( InfoAutGrp, 3, "  compute characteristic subgroups ");
    chars := PGCharSubgroups( G );
    bases := List( chars, x -> FrattiniQuotientBase( spec, x ) ) * z;

    # compute the matrixgroup stabilising all subspaces in chain
    Info( InfoAutGrp, 3, "  compute stabilizer ");
    S := StabilizingMatrixGroup( bases, r, p );

    # the Frattini Quotient
    H := FrattiniQuotientPGroup( G );
    kern := InitAgAutos( H, p );

    # the aut group
    A := rec( );
    A.glAutos := InitGlAutos( H, GeneratorsOfGroup(S) );
    A.glOrder := Size(S) / Product( kern.rels );
    A.glOper  := GeneratorsOfGroup(S);
    Assert(1,IsInt(A.glOrder));
    A.agAutos := kern.auts;
    A.agOrder := kern.rels;
    A.one     := IdentityPGAutomorphism( H );
    A.group   := H;
    A.size    := A.glOrder * Product( A.agOrder );

    # try to construct perm rep
    NiceInitGroup( A, true );
    return A;
end );

#############################################################################
##
#F InitAutomorphismGroupFull( G )
##
BindGlobal( "InitAutomorphismGroupFull", function( G )
    local r, p, S, H, A, kern;

    Info( InfoAutGrp, 2, "  init automorphism group : Full ");

    # set up
    r := RankPGroup( G );
    p := PrimePGroup( G );
    S := GL(r, p);
    H := FrattiniQuotientPGroup( G );
    kern := InitAgAutos( H, p );

    # the aut group
    A := rec( );
    A.glAutos := InitGlAutos( H, GeneratorsOfGroup(S) );
    A.glOrder := Size(S) / Product( kern.rels );
    A.glOper  := GeneratorsOfGroup( S );
    Assert(1,IsInt(A.glOrder));
    A.agAutos := kern.auts;
    A.agOrder := kern.rels;
    A.one     := IdentityPGAutomorphism( H );
    A.group   := H;
    A.size    := A.glOrder * Product( A.agOrder );

    # try to compute perm rep
    NiceInitGroup( A, false );
    return A;
end );
