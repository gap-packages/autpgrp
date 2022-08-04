#############################################################################
##
#W  general.gi               AutPGrp package                     Bettina Eick
##

#############################################################################
##
#F Interrupt
##
BindGlobal( "Interrupt", function(text)
    local str, ans;
    Print("\n",text);
    Print(": \c");
    str := InputTextUser();
    ans := ReadLine(str);
    ans := ans{[1..Length(ans)-1]};
    Print("\n");
    return ans;
end );

#############################################################################
##
#F RewriteDef( pcgs, defn, p )
##
BindGlobal( "RewriteDef", function( pcgs, defn, p )
    local words, i, d, e, w;
    words := [];
    for i in [1..Length(defn)] do
        d := defn[i];
        if IsNegRat( d ) then
            Add( words, d );
        elif IsInt( d ) then
            w := pcgs[d]^p;
            e := ExponentsOfPcElement( pcgs, w );
            e[i] := 0;
            Add( words, [d, e] );
        elif IsList( d ) then
            w := Comm( pcgs[d[1]], pcgs[d[2]] );
            e := ExponentsOfPcElement( pcgs, w );
            e[i] := 0;
            Add( words, [d, e] );
        fi;
    od;
    return words;
end );

#############################################################################
##
#F SubstituteDef( def, gens, p )
##
BindGlobal( "SubstituteDef", function( def, gens, p )
   local i, e;

   # definition part
   if IsInt( def ) then
       return gens[-def];
   elif IsInt( def[1] ) then
       e := gens[def[1]]^p;
   else
       e := Comm( gens[def[1][1]], gens[def[1][2]] );
   fi;

   # tail part
   for i in [1..Length(def[2])] do
       if def[2][i] <> 0 then
           e := gens[i]^-def[2][i] * e;
       fi;
   od;
   return e;
end );

#############################################################################
##
#F InducedPcgsByBasis( pcgs, basis )
##
BindGlobal( "InducedPcgsByBasis", function( pcgs, basis )
    local pcgsN, pcgsM, seq, pcs;
    pcgsN := NumeratorOfModuloPcgs( pcgs );
    pcgsM := DenominatorOfModuloPcgs( pcgs );
    seq   := List( basis, b -> PcElementByExponents( pcgs, b ) );
    pcs   := InducedPcgsByPcSequenceAndGenerators( pcgsN, pcgsM, seq );
    return InducedPcgsByPcSequenceNC( pcgsN, pcs );
end );

#############################################################################
##
#F IsHomoCyclic( G )
##
BindGlobal( "IsHomoCyclic", function( G )
    return IsAbelian(G) and Length(Set(AbelianInvariants(G))) = 1;
end );

#############################################################################
##
#F FrattiniQuotientPGroup( G )
##
BindGlobal( "FrattiniQuotientPGroup", function( G )
    local spec, firs, frat, H;
    spec := SpecialPcgs(G);
    firs := LGFirst(spec);
    frat := InducedPcgsByPcSequenceNC( spec, spec{[firs[2]..Length(spec)]});
    H := GroupByPcgs( spec mod frat );
    SetIsPGroup(H, true );
    SetPrimePGroup( H, PrimePGroup(G) );
    SetRankPGroup( H, firs[2] - 1 );
    H!.definitions := List( [1..firs[2]-1], x -> -x );
    return H;
end );

#############################################################################
##
#F InitGlAutos( H, mats )
##
BindGlobal( "InitGlAutos", function( H, mats )
    local pcgs;
    pcgs := Pcgs(H);
    return List( mats, x -> PGAutomorphism( H, pcgs, List( x, 
                       y -> PcElementByExponents( pcgs, y) ) ) );
end );

#############################################################################
##
#F InitAgAutos( H, p )
##
BindGlobal( "InitAgAutos", function( H, p )
    local pcgs, auts, alpha, fac, i, imgs;
    if p <> 2 then
        pcgs  := Pcgs(H);
        auts  := [];
        alpha := PrimitiveRoot( GF(p) );
        fac   := Factors( p - 1 );
        for i in [1..Length(fac)] do
            imgs := List( pcgs, x-> x^IntFFE( alpha ) );
            Add( auts, PGAutomorphism( H, pcgs, imgs ) );
            alpha := alpha ^ fac[i];
        od;
        return rec( auts := auts, rels := fac );
    else
        return rec( auts := [], rels := [] );
    fi;
end );

#############################################################################
##
#F EcheloniseMat( mat )
##
BindGlobal( "EcheloniseMat",
  function( mat )
    local ech, tmp, i;

    if Length(mat) = 0 then return mat; fi;
    ech := SemiEchelonMat( mat );
    tmp := [];
    for i in [1..Length(ech.heads)] do
        if ech.heads[i] <> 0 then
            Add( tmp, ech.vectors[ech.heads[i]] );
        fi;
    od;
    return tmp;
  end);
