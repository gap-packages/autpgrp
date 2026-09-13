gap> START_TEST("embedding.tst");
gap> SetInfoLevel( InfoAutGrp, 0 );

# automorphism group not solvable: the image is a proper subgroup
gap> G := PcGroupCode( 17734058326, 32 );;  # SmallGroup( 32, 50 )
gap> hom := EmbeddingPcGroupAutPGroup( G );;
gap> IsInjective( hom );
true
gap> aut := AutomorphismGroup( G );;
gap> IsIdenticalObj( Range( hom ), aut );
true
gap> Size( Source( hom ) ); Size( Image( hom ) ); Size( aut );
16
16
1920
gap> x := Product( GeneratorsOfGroup( Source( hom ) ) );;
gap> PreImagesRepresentative( hom, Image( hom, x ) ) = x;
true
gap> a := Source( hom ).1;; b := Source( hom ).2;;
gap> Image( hom, a * b ) = Image( hom, a ) * Image( hom, b );
true
gap> outside := First( GeneratorsOfGroup( aut ), g -> not g in Image( hom ) );;
gap> PreImagesRepresentative( hom, outside );
fail
gap> inn := Group( List( Pcgs( G ), x -> InnerAutomorphism( G, x ) ) );;
gap> Size( PreImage( hom, inn ) );
16

# solvable part trivial
gap> K := PcGroupCode( 0, 2 );;
gap> hom := EmbeddingPcGroupAutPGroup( K );;
gap> Size( Source( hom ) ); Image( hom, One( Source( hom ) ) ) = One( Range( hom ) );
1
true
gap> K := PcGroupCode( 0, 4 );;  # C2 x C2, |Aut| = 6
gap> hom := EmbeddingPcGroupAutPGroup( K );;
gap> Size( Source( hom ) ); Size( Range( hom ) );
1
6
gap> PreImagesRepresentative( hom, Random( Range( hom ) ) ) in [ fail, One( Source( hom ) ) ];
true

# automorphism group already known: it is reused
gap> G := PcGroupCode( 17734058326, 32 );;
gap> aut := AutomorphismGroup( G );;
gap> hom := EmbeddingPcGroupAutPGroup( G );;
gap> IsIdenticalObj( Range( hom ), aut );
true

#
gap> STOP_TEST("embedding.tst", 1);
