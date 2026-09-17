#############################################################################
##
#W  cfstab.gi                AutPGrp package                     Bettina Eick
##
##  Canonical forms of vectors and subspaces under a p-group, with the
##  stabilizer of the canonical form [ELO02, Sec. 5.2].  Ported from the
##  ModIsom package, gap/cfstab/pgroup.gi.
##
##  Group elements are pairs [ elm, mat ]: mat acts on row vectors from the
##  right, elm is carried along and needs only * and positive powers, so
##  elements acting trivially are kept.  The pcgs has relative orders p and
##  acts upper unitriangularly (see PGUnipotentFlagBasis).  Nothing here
##  depends on the rest of the package.
##

#############################################################################
##
#F PGTriangulizedBaseMat( mat ) . . . . . reduced echelon basis of row space
##
BindGlobal( "PGTriangulizedBaseMat", function( mat )
    local new, j;
    if Length( mat ) = 0 then return mat; fi;
    new := TriangulizedMat( mat );
    j := Position( new, 0 * new[1] );
    if j = fail then return new; fi;
    return new{[1..j-1]};
end );

#############################################################################
##
#F PGSolutionMatInt( mat, vec ) . . . . integer coefficients of vec, or fail
##
BindGlobal( "PGSolutionMatInt", function( mat, vec )
    local s;
    if IsZero( vec ) then return List( mat, x -> 0 ); fi;
    if Length( mat ) = 0 then return fail; fi;
    s := SolutionMat( mat, vec );
    if s = fail then return fail; fi;
    return IntVecFFE( s );
end );

#############################################################################
##
#F PGCoeffsMinimalElement( vec, base ) . . . .least element of vec + <base>
##
## Integer coefficients c with vec + c * <base> the least element of the
## coset in the order used by the canonical form.
##
BindGlobal( "PGCoeffsMinimalElement", function( vec, base )
    local mat, cof, d;
    if Length( base ) = 0 then return []; fi;
    cof := List( base, x -> 0 * vec[1] );
    mat := SemiEchelonMatTransformation( base );
    for d in [1..Length( vec )] do
        if mat.heads[d] <> 0 and not IsZero( vec[d] ) then
            cof[mat.heads[d]] := cof[mat.heads[d]] - vec[d];
            vec := vec - vec[d] * mat.vectors[mat.heads[d]];
        fi;
    od;
    return IntVecFFE( cof * mat.coeffs );
end );

#############################################################################
##
#F PGIndVector( v, l, base ) . . . . . . . . . first l coordinates in <base>
##
BindGlobal( "PGIndVector", function( v, l, base )
    if base = fail then return v; fi;
    return SolutionMat( base, v ){[1..l]};
end );

#############################################################################
##
#F PGUnipotentFlagBasis( mats, d, F ) . . . basis making a p-group triangular
##
## <mats> generate a p-group acting on F^<d>.  The rows of the result are
## adapted to the flag W_1 = F^d > W_2 > ... > 0 with W_{k+1} the sum of
## W_k (g - 1) over g in <mats>; in this basis the group acts upper
## unitriangularly.
##
BindGlobal( "PGUnipotentFlagBasis", function( mats, d, F )
    local I, W, next, basis, g;

    I := IdentityMat( d, F );
    W := I;
    basis := [];
    while Length( W ) > 0 do
        next := [];
        for g in mats do
            Append( next, W * ( g - I ) );
        od;
        next := PGTriangulizedBaseMat( next );
        if Length( next ) = Length( W ) then
            Error( "<mats> do not generate a p-group" );
        fi;
        Append( basis, BaseSteinitzVectors( W, next ).factorspace );
        W := next;
    od;
    return ImmutableMatrix( F, basis );
end );

#############################################################################
##
#F PGVectorCanonicalForm( pcgs, one, v, F, l, base )
##
## Canonical form of <v> modulo the span of <base>{[l+1..]} (modulo nothing
## if <base> = fail).  Returns rec( cano, stab, tran ): the canonical form,
## a pcgs of its stabilizer, and tran with <v> * tran = cano.
##
BindGlobal( "PGVectorCanonicalForm", function( pcgs, one, v, F, l, base )
    local p, d, o, B, stab, tran, cano, indu, tail, i, j, k, e, ec, w, wc,
          b, s, t;

    if Length( pcgs ) = 0 then return fail; fi;

    p := Characteristic( F );
    d := Length( v );
    o := IdentityMat( d, F );
    B := Basis( F );

    stab := ShallowCopy( pcgs );
    tran := one;
    cano := ShallowCopy( v );
    indu := PGIndVector( cano, l, base );
    tail := List( stab, x -> PGIndVector( cano * ( x[2] - o ), l, base ) );

    # coordinate i of the tail is additive on the stabilizer of v modulo
    # coordinates >= i; its kernel is that stabilizer one step further
    for i in [2..l] do
        e  := List( tail, x -> x[i] );
        ec := List( e, x -> Coefficients( B, x ) );
        w  := indu[i];
        wc := Coefficients( B, w );

        # choose pivots b and reduce the other elements into the kernel
        b := [];
        for j in Reversed( [1..Length( e )] ) do
            s := PGSolutionMatInt( ec{b}, ec[j] );
            if s = fail then
                Add( b, j );
                continue;
            fi;
            for k in Reversed( [1..Length( s )] ) do
                if s[k] <> 0 then
                    stab[j] := stab[j] * stab[b[k]]^( -s[k] mod p );
                fi;
            od;
        od;

        # move coordinate i to the least value reachable by the pivots
        t := PGCoeffsMinimalElement( wc, ec{b} );
        for k in Reversed( [1..Length( t )] ) do
            if t[k] <> 0 then
                tran := tran * stab[b[k]]^t[k];
            fi;
        od;

        if ForAny( t, x -> x <> 0 ) then
            cano := v * tran[2];
            indu := PGIndVector( cano, l, base );
        fi;
        if Length( b ) > 0 then
            stab := stab{ Difference( [1..Length( e )], b ) };
            tail := List( stab,
                          x -> PGIndVector( cano * ( x[2] - o ), l, base ) );
        fi;
    od;

    Assert( 2, ForAll( stab,
                       x -> PGIndVector( cano * x[2], l, base ) = indu ) );
    return rec( cano := cano, stab := stab, tran := tran );
end );

#############################################################################
##
#F PGSubspaceCanonicalForm( pcgs, one, base, F )
##
## Canonical form of the row space of <base>, which must be in reduced
## echelon form.  Returns rec( cano, stab, tran ) as PGVectorCanonicalForm,
## with cano again in reduced echelon form.
##
BindGlobal( "PGSubspaceCanonicalForm", function( pcgs, one, base, F )
    local d, l, I, stab, cano, tran, n, c, b, f;

    if Length( pcgs ) = 0 or Length( base ) = 0 then
        return rec( cano := base, stab := pcgs, tran := one );
    fi;

    d := Length( base[1] );
    l := Length( base );
    I := IdentityMat( d, F );

    # the last rows span the intersections with the flag; canonise the last
    # row, then each earlier row modulo the rows after it, in the stabilizer
    # found so far
    for n in Reversed( [1..l] ) do
        if n = l then
            c := PGVectorCanonicalForm( pcgs, one, base[n], F, d, fail );
            stab := c.stab;
            tran := c.tran;
        elif Length( stab ) = 0 then
            break;
        else
            f := BaseSteinitzVectors( I, cano{[n+1..l]} ).factorspace;
            b := Concatenation( f, cano{[n+1..l]} );
            c := PGVectorCanonicalForm( stab, one, cano[n], F, d-l+n, b );
            stab := c.stab;
            tran := tran * c.tran;
        fi;
        cano := PGTriangulizedBaseMat( base * tran[2] );
    od;

    Assert( 2, ForAll( stab,
                       x -> cano = PGTriangulizedBaseMat( cano * x[2] ) ) );
    return rec( cano := cano, stab := stab, tran := tran );
end );
