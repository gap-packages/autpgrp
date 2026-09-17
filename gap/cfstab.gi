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
#F PGIndVectorMatrix( l, base, F ) . . . . . PGIndVector as a matrix, or fail
##
## <base> is a basis of the whole space, so the coordinates with respect to
## it are given by its inverse, of which only the first <l> columns are
## needed.  fail if PGIndVector has nothing to do.
##
BindGlobal( "PGIndVectorMatrix", function( l, base, F )
    if base = fail or Length( base ) <> Length( base[1] ) then
        return fail;
    fi;
    return ImmutableMatrix( F, List( base^-1, r -> r{[1..l]} ) );
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
    local p, d, o, B, zero, im, ind, stab, tran, cano, indu, tail, act,
          dead, hit, moved, piv, vecs, cf, u, c, a, r, n, i, j, k, e, ec,
          w, wc, b, bi, s, t;

    if Length( pcgs ) = 0 then return fail; fi;

    p := Characteristic( F );
    d := Length( v );
    o := IdentityMat( d, F );
    B := Basis( F );
    zero := Zero( GF(p) );

    # PGIndVector is applied to every tail in every round; as a matrix it
    # costs a vector by matrix product instead of solving a linear system
    im := PGIndVectorMatrix( l, base, F );
    if im = fail then
        ind := x -> PGIndVector( x, l, base );
    else
        ind := x -> x * im;
    fi;

    stab := ShallowCopy( pcgs );
    tran := one;
    cano := ShallowCopy( v );
    indu := ind( cano );
    tail := List( stab, x -> ind( cano * ( x[2] - o ) ) );

    # an element with a zero tail has a zero entry in every coordinate, so
    # it is neither a pivot nor reduced by one; such elements are skipped
    # until cano moves, and are nearly all of them
    dead := BlistList( [1..Length( stab )], [] );
    act := Filtered( [1..Length( stab )], j -> not IsZero( tail[j] ) );

    # coordinate i of the tail is additive on the stabilizer of v modulo
    # coordinates >= i; its kernel is that stabilizer one step further
    for i in [2..l] do
        e  := List( act, j -> tail[j][i] );
        ec := List( e, x -> Coefficients( B, x ) );
        w  := indu[i];
        wc := Coefficients( B, w );

        # choose pivots b and reduce the other elements into the kernel;
        # the pivot entries are kept echelonised, each as a combination of
        # the entries chosen before it, so that no linear system is solved
        b := [];
        bi := [];
        piv := [];
        vecs := [];
        cf := [];
        hit := [];
        for n in Reversed( [1..Length( act )] ) do
            j := act[n];
            u := ec[n];
            c := ListWithIdenticalEntries( Length( b ), zero );
            for k in [1..Length( vecs )] do
                a := u[piv[k]];
                if a <> zero then
                    u := u - a * vecs[k];
                    c := c + a * cf[k];
                fi;
            od;
            r := PositionNonZero( u );

            # the entry is reached by the pivots
            if r > Length( u ) then
                s := List( c, IntFFE );
                for k in Reversed( [1..Length( s )] ) do
                    if s[k] <> 0 then
                        stab[j] := stab[j] * stab[b[k]]^( -s[k] mod p );
                        AddSet( hit, j );
                    fi;
                od;
                continue;
            fi;

            # it is a new pivot
            a := u[r];
            Add( b, j );
            Add( bi, n );
            Add( piv, r );
            Add( vecs, u / a );
            cf := List( cf, x -> Concatenation( x, [zero] ) );
            Add( cf, Concatenation( List( c, x -> -x/a ), [a^-1] ) );
        od;

        # move coordinate i to the least value reachable by the pivots
        t := PGCoeffsMinimalElement( wc, ec{bi} );
        for k in Reversed( [1..Length( t )] ) do
            if t[k] <> 0 then
                tran := tran * stab[b[k]]^t[k];
            fi;
        od;

        moved := ForAny( t, x -> x <> 0 );
        if moved then
            cano := v * tran[2];
            indu := ind( cano );
        fi;
        for j in b do dead[j] := true; od;

        # a tail changes with cano or with its own element
        if moved then
            act := [];
            for j in [1..Length( stab )] do
                if dead[j] then continue; fi;
                tail[j] := ind( cano * ( stab[j][2] - o ) );
                if not IsZero( tail[j] ) then Add( act, j ); fi;
            od;
        else
            for j in hit do
                tail[j] := ind( cano * ( stab[j][2] - o ) );
            od;
            act := Filtered( act,
                             j -> not dead[j] and not IsZero( tail[j] ) );
        fi;
    od;

    stab := stab{ Filtered( [1..Length( stab )], j -> not dead[j] ) };

    Assert( 2, ForAll( stab, x -> ind( cano * x[2] ) = indu ) );
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
