#############################################################################
##
#W  hybridst.gi              AutPGrp package                     Bettina Eick
##

#############################################################################
##
#F CollectToWord( list )
##
BindGlobal( "CollectToWord", function( list )
    local coll, t, i;
    coll := [];
    t := [list[1], 1];
    for i in [2..Length(list)] do
        if t[1] <> list[i] then
            Add( coll, t );
            t := [list[i], 1];
        else
            t[2] := t[2] + 1;
        fi;
    od; 
    Add( coll, t );
    return coll;
end );

#############################################################################
##
#F TransformPG( get, list, id )  . . . . . . . . . . . .convert get to element
##
BindGlobal( "TransformPG", function( get, list, id )
    local coll, res, i;

    # catch the special case
    if Length( get ) = 0 then return id; fi;

    # otherwise compute
    coll := CollectToWord( get );

    if coll[1][1] > 0 then 
        res := [PGPower( coll[1][2],list[coll[1][1]] )];
    else
        res := [PGPower( coll[1][2], PGInverse(list[-coll[1][1]]))];
    fi;
    for i in [2..Length(coll)] do
        if coll[i][1] > 0 then 
            Add( res, PGPower(coll[i][2],list[coll[i][1]] ) );
        else
            Add( res, PGPower(coll[i][2], PGInverse(list[-coll[i][1]]) ) );
        fi;
    od;
    return PGMultList( res );
end );

#############################################################################
##
#F Transform( get, list, id ) . . . . . . . . . . . . .convert get to element
##
BindGlobal( "Transform", function( get, list, id )
    local res, i;
    if Length( get ) = 0 then return id; fi;
    if get[1] > 0 then res := list[get[1]];
    else res := list[-get[1]]^-1;
    fi;
    for i in [2..Length( get )] do
        if get[i] > 0 then res := res * list[get[i]];
        else res := res * list[-get[i]]^-1;
        fi;
    od;
    return res;
end );

#############################################################################
##
#F ReduceGet( ords, get ) . . . . . . . . . . . . . . .reduce get with orders
##
BindGlobal( "ReduceGet", function( ords, get )
    local found, i, j, o;

    found := true;
    while found do

        # first reduce by inverses
        i := 1;
        found := false;
        while i <= Length( get ) - 1 do
            if not IsBool( get[i+1] ) and get[i] = - get[i+1] then
                get[i] := false;
                get[i+1] := false;
                found := true;
                i := i + 1;
            fi;
            i := i + 1;
        od;

        # now reduce by orders
        i := 1;
        while i <= Length( get ) do
            if not IsBool( get[i] ) then
                if get[i] > 0 then
                    o := ords[ get[i] ];
                else
                    o := ords[ -get[i] ];
                fi;
                if i+o-1 <= Length( get ) and 
                   ForAll( get{[i..i+o-1]}, x -> x = get[i] ) then
                    for j in [i..i+o-1] do
                        get[j] := false;
                    od;
                    found := true;
                    i := i + o - 1;
                fi;
            fi;
            i := i + 1;
        od;
    od;
    return Filtered( get, x -> not IsBool( x ) );
end );

#############################################################################
##
#F OSTransversalInverse( j, trans, trels, id )
##
BindGlobal( "OSTransversalInverse", function( j, trans, trels, id )
    local l, g, s, p, t;
    if j = 1 then return id; fi;
    l := Product( trels );
    j := j - 1;
    g := id;
    for s in Reversed( [1..Length( trans )] ) do
        p := trels[s];
        l := l/p;
        t := QuoInt( j, l );
        j := RemInt( j, l );
        if t > 0 then
           g := PGMult( g, PGInverse(trans[s])^t );
        fi;
    od;
    return g;
end );

#############################################################################
##
#F PGOrbitLimit( A ) . . . . . . . . . . . . . . user budget for orbit lengths
##
BindGlobal( "PGOrbitLimit", function( A )
    if IsBound( A.orbitLimit ) then return A.orbitLimit; fi;
    return infinity;
end );

#############################################################################
##
#F PGSchreierWord( parent, gen, k ) . . . . . . . . . word for orbit block k
##
## The transversal of BlockOrbitStabilizer is a Schreier vector: block k
## was obtained from block parent[k] by generator gen[k].
##
BindGlobal( "PGSchreierWord", function( parent, gen, k )
    local word;
    word := [];
    while k > 1 do
        Add( word, gen[k] );
        k := parent[k];
    od;
    return Reversed( word );
end );

#############################################################################
##
#F PcgsOrbitStabilizer( A, oper, pt, fpt, info, limit )
##
## Returns fail if the orbit would exceed <limit> points.
##
BindGlobal( "PcgsOrbitStabilizer", function( A, oper, pt, fpt, info, limit )
    local pcgs, rels, stabl, srels, trans, trels, orbit, i, y, j, p, l, s,
          k, t, h, g, dict;

    pcgs := A.agAutos;
    rels := A.agOrder;

    # catch trivial case
    if Length( pcgs ) = 0 then
        return rec( stabl := pcgs,
                    srels := rels,
                    orbit := [pt],
                    trans := [],
                    trels := [] );
    fi; 

    # initialise orbit, stabiliser and transversal
    stabl := [];
    srels := [];
    trans := [];
    trels := [];
    orbit := [pt];
    dict := NewDictionary( pt, true );
    AddDictionary( dict, pt, 1 );

    # Start constructing orbit.
    i := Length( pcgs );
    while i >= 1 do
        if oper[i] = 1 then
            Add( stabl, pcgs[i] );
            Add( srels, rels[i] );
        else
            y := fpt( pt, oper[i], info );
            j := LookupDictionary( dict, y );
            if IsBool( j ) then
    
                # enlarge transversal
                Add( trans, pcgs[i] );
                Add( trels, rels[i] );

                # enlarge orbit
                p := rels[i];
                l := Length( orbit );
                if p * l > limit then return fail; fi;
                orbit[p*l] := true;
                s := 0;
                for k  in [ 1 .. p - 1 ]  do
                    t := s + l;
                    for h  in [ 1 .. l ]  do
                        orbit[h + t] := fpt( orbit[h + s], oper[i], info );
                        AddDictionary( dict, orbit[h + t], h + t );
                    od;
           	        s := t;
                od;
            else

                # enlarge stabilizer
                if j > 1 then
                    g := OSTransversalInverse(j, trans, trels, A.one);
                    Add( stabl, PGMult( pcgs[i], g ) );
                else
                    Add( stabl, pcgs[i] );
                fi;
                Add( srels, rels[i] );
            fi;
        fi;
        i := i - 1;
    od;
   
    return rec( stabl := Reversed( stabl ),
                srels := Reversed( srels ),
                orbit := orbit,
                trans := trans,
                trels := trels );
end );

#############################################################################
##
#F BlockOrbitStabilizer( B, oper, os, fpt, info, limit, state )
##
## Orbit of the block <os>.orbit under the gl part of <B>.  Once the orbit
## has more than <limit> blocks the enumeration stops and returns its
## state with the component partial := true; passing that record as
## <state> resumes it (<state> = fail starts afresh).
##
BindGlobal( "BlockOrbitStabilizer", function( B, oper, os, fpt, info, limit,
                                              state )
    local bl, l, li, orbit, parent, gen, stabl, pstab, mats, auts, ords,
          pers, k, pt, i, y, j, new, get, aut, g, per, s, dict, r, stabGrp;

    # the block and limit for orbit length
    bl := os.orbit;
    l  := Length( bl );
    li := B.glOrder / Factors( B.glOrder )[1];

    # get acting elements
    auts := B.glAutos;
    ords := List( auts, Order );
    if IsBound( B.glOper ) then pers := B.glOper; fi;

    if state = fail then
        # set up orbit, transversal (Schreier vector) and stab
        orbit := [ bl ];
        dict := NewDictionary( bl[1], true );
        for j in [1..l] do
            AddDictionary( dict, bl[j], [1,j] );
        od;
        parent := [ 0 ];
        gen := [ 0 ];
        stabl := [];
        pstab := [];
        stabGrp := Group( () );
        k := 1;
    else
        orbit := state.orbit;   dict := state.dict;
        parent := state.parent; gen := state.gen;
        stabl := state.stabl;   pstab := state.pstab;
        stabGrp := state.stabGrp; k := state.k;
    fi;

    # loop
    while k <= Length( orbit ) do
        if Length( orbit ) > limit then
            return rec( partial := true, orbit := orbit, dict := dict,
                        parent := parent, gen := gen, stabl := stabl,
                        pstab := pstab, stabGrp := stabGrp, k := k );
        fi;
        if k mod 10000 = 0 then
            Info( InfoAutGrp, 5, "      orbit pos ", k, " of ",Length(orbit));
        fi;
        pt := orbit[k][1];
        for i in [ 1..Length(oper) ] do

            # compute the image of a point
            y := fpt( pt, oper[i], info );
            j := LookupDictionary( dict, y );
            if IsBool( j ) then

                # enlarge orbit and transversal
                new := List( [1..l], x -> true );
                for s in [1..l] do
                    new[s] := fpt( orbit[k][s], oper[i], info );
                    AddDictionary( dict, new[s], [Length(orbit)+1, s] );
                od;
                Add( orbit, new );
                Add( parent, k );
                Add( gen, i );
            else

                # enlarge stabilizer
                get := Concatenation( PGSchreierWord( parent, gen, k ), [i],
                           Reversed( -PGSchreierWord( parent, gen, j[1] ) ) );
                get := ReduceGet( ords, get );
                aut := TransformPG( get, auts, B.one );

                # reduce from block-stab to point-stab
                if j[2] > 1 then
                    g := OSTransversalInverse(j[2], os.trans, os.trels, B.one);
                    aut := PGMult( aut, g );
                fi;

                # add permutations if known
                if IsBound( B.glOper ) then
                    g := Transform( get, pers, () );
                    if not g in stabGrp then
                        stabGrp := ClosureGroup( stabGrp, g );
                        Add( pstab, g );
                        Add( stabl, aut );
                    fi;
                else
                    Add( stabl, aut );
                fi;
            fi;
        od;
        if Length( orbit ) * Size(stabGrp) > li then
            # orbit is going to be the whole domain, and the
            # stabilizer cannot get any larger, so we are done
            return rec( stabl := stabl, pstab := pstab,
                        length := B.glOrder / Size(stabGrp) );
        else
            k := k + 1;
        fi;
    od;

    return rec( stabl := stabl, pstab := pstab, 
                length := Length(orbit) );
end );

#############################################################################
##
#F PGHybridOrbitStabilizer( A, glMats, agMats, pt, oper, info, induce )
##
## Replaces <A> by the stabilizer of <pt>.  Returns fail if the orbit
## budget of <A> (see PGOrbitLimit) is exceeded, true otherwise.  <induce>
## maps the matrix of an automorphism on the multiplicator to its action
## on the section the points live in.
##
## The gl orbit is enumerated in rounds of geometrically growing length.
## After each round the set stabilizer method (PGPermStabilizer) is
## attempted, allowed to spend on its permutation domain at most as many
## vector-matrix products as the enumeration has done so far, so failed
## attempts cost at most as much as the enumeration they try to replace.
## The domain built so far is kept between attempts.  The bound counts
## work, not time, so the computation takes the same path on every
## machine.
##
BindGlobal( "PGHybridOrbitStabilizer",
  function( A, glMats, agMats, pt, oper, info, induce )
    local os, OS, agAutos, limit, blocks, method, time, l, round, state,
          dstate, budget, exhausted;

    # compute ag orbit stabilizier
    if Length( glMats ) = 0 and Length( agMats ) = 0 then return true; fi;
    time := Runtime();
    limit := PGOrbitLimit( A );
    os := PcgsOrbitStabilizer( A, agMats, pt, oper, info, limit );
    if os = fail then
        Info( InfoAutGrp, 2, "    ag-orbit exceeds limit ", limit );
        return fail;
    fi;
    Info( InfoAutGrp, 4, "    ag-orbit -- length ",Length(os.orbit));

    # add info to A; keep the generators of the full ag part for the set
    # stabilizer, which needs the whole group S, not just its stabilizer
    agAutos := A.agAutos;
    A.agAutos := os.stabl;
    A.agOrder := os.srels;

    # compute block orbit and stabiliser
    if Length( glMats ) = 0 then return true; fi;
    l := Length( os.orbit );
    if limit = infinity then
        blocks := infinity;
    else
        blocks := QuoInt( limit, l );
    fi;

    method := "enumerated";
    round := PG_ESCALATE_BLOCKS;
    state := fail;
    dstate := rec();
    repeat
        OS := BlockOrbitStabilizer( A, glMats, os, oper, info,
                                    Minimum( round, blocks ), state );
        if not IsBound( OS.partial ) then break; fi;
        state := OS;
        exhausted := round >= blocks;
        if PERM_STAB and IsBound( A.glOper ) then
            # once the orbit budget is spent, one last attempt without a
            # work bound; otherwise the enumeration has applied each gl
            # generator to about every point of every block
            if exhausted then
                budget := infinity;
            else
                budget := Length( state.orbit ) * l * Length( glMats );
            fi;
            OS := PGPermStabilizer( A, glMats, agMats, agAutos, os, pt,
                                    oper, info, induce, budget, dstate );
            if OS <> fail then
                method := "set stabilizer";
                break;
            fi;
        fi;
        if exhausted then
            Info( InfoAutGrp, 2, "    gl-orbit exceeds limit ", limit );
            return fail;
        fi;
        round := round * PG_ESCALATE_GROWTH;
    until false;
    Info( InfoAutGrp, 4, "    gl-orbit -- length ", OS.length,
                         " -- gens ",Length(OS.stabl));

    # set up new aut grp
    A.glAutos := OS.stabl;
    A.glOrder := A.glOrder / OS.length;
    Assert(1,IsInt(A.glOrder));
    if IsBound( A.glOper ) then A.glOper := OS.pstab; fi;

    Info( InfoAutGrp, 2, "    stabilizer: ag-orbit ", l,
          ", gl-orbit ", OS.length, " (", method, "), gl part ", A.glOrder,
          ", ", Runtime() - time, " ms" );

    # nice the glAutos if necessary
    if NICE_STAB and OS.length > 1 then NiceHybridGroup( A ); fi;
    return true;
end );

