#############################################################################
##
##  Compares two outputs of bench.g, see there: the times are summed over
##  the seeds.
##
SetPrintFormattingStatus( "*stdout*", false );

BenchRead := function( file )
    local res, line, w, k;
    res := [];
    for line in SplitString( StringFile( file ), "\n" ) do
        # name, a time per seed, result
        w := Filtered( SplitString( line, " " ), x -> x <> "" );
        k := PositionProperty( w{[2..Length( w )]}, x -> Int( x ) = fail );
        if k = fail or k = 1 then continue; fi;
        Add( res, rec( name := w[1], time := Sum( w{[2..k]}, Int ),
                       result := w[k+1] ) );
    od;
    return res;
end;

BenchRatio := function( x, y )
    local q;
    if x = 0 then return ""; fi;
    q := String( QuoInt( 100 * y, x ) + 1000 );
    return Concatenation( String( Int( q{[1..Length( q )-2]} ) - 10 ), ".",
                          q{[Length( q )-1, Length( q )]} );
end;

a := BenchRead( before );;
b := BenchRead( after );;
Print( String( "case", -30 ), String( "before", 10 ), String( "after", 10 ),
       String( "ratio", 8 ), "\n" );
for x in a do
    y := First( b, z -> z.name = x.name );
    if y = fail then continue; fi;
    Print( String( x.name, -30 ), String( x.time, 10 ), String( y.time, 10 ),
           String( BenchRatio( x.time, y.time ), 8 ) );
    if x.result <> "ok" then Print( "  before: ", x.result ); fi;
    if y.result <> "ok" then Print( "  after: ", y.result ); fi;
    Print( "\n" );
od;
QUIT;
