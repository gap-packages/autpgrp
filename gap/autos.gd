#############################################################################
##
#W  autos.gd                 AutPGrp package                     Bettina Eick
##

#############################################################################
##
#C Choose functionality 
##
if not IsBound( InitAutGroup ) then InitAutGroup := false; fi;
if not IsBound( CHOP_MULT ) then CHOP_MULT := true; fi;
if not IsBound( NICE_STAB ) then NICE_STAB := true; fi;
if not IsBound( REDU_OPER ) then REDU_OPER := false; fi;
if not IsBound( USE_LABEL ) then USE_LABEL := false; fi;
if not IsBound( PERM_STAB ) then PERM_STAB := true; fi;
if not IsBound( CHECK ) then CHECK := false; fi;

#############################################################################
##
#C Tuning constants for the stabilizer computation
##
## Number of gl-orbit blocks enumerated before the set stabilizer
## (PGPermStabilizer) is first tried, and the factor by which that number
## grows between attempts.
BindGlobal( "PG_ESCALATE_BLOCKS", 2000 );
BindGlobal( "PG_ESCALATE_GROWTH", 4 );
## Sections with at most this many lines are used whole as permutation
## domain; for larger ones only the lines in the orbits of the subspace's
## lines are computed, at most this many, and taking at most as long as the
## enumeration has run so far.
BindGlobal( "PG_PERM_FULL_LIMIT", 10^5 );
BindGlobal( "PG_PERM_DOMAIN_LIMIT", 10^6 );

#############################################################################
##
#D Declarations for PGAutomorphisms
##
DeclareRepresentation( "IsPGAutomorphismRep",
                       IsGroupGeneralMappingByImages,
                       ["base", "baseimgs", "pcgs", "pcgsimgs"] );

IsPGAutomorphism := IsMapping and IsPGAutomorphismRep;
DeclareOperation( "PGAutomorphism", [ IsPGroup and IsFinite, IsList, IsList ] );


DeclareGlobalFunction( "AutomorphismGroupPGroup" );
DeclareGlobalFunction( "PcGroupAutPGroup" );
DeclareGlobalFunction( "ConvertHybridAutGroup" );
DeclareGlobalFunction( "PGOrbitStabilizer" );
DeclareGlobalFunction( "PGPermStabilizer" );
DeclareGlobalFunction( "IdentityPGAutomorphism" );

DeclareGlobalFunction( "CountOrbitsGL" );
DeclareGlobalFunction( "NumberOfPClass2PGroups" );
DeclareGlobalFunction( "NumberOfClass2LieAlgebras" );

DeclareOperation( "PGMult", [IsObject, IsObject] );
DeclareOperation( "PGInverse",[IsObject] );
DeclareOperation( "PGPower",[IsInt, IsObject] );
DeclareOperation( "PGMultList", [IsList] );

############################################################################
## 
#V for external applications
##
DeclareGlobalFunction( "ImageAutPGroup" );
DeclareGlobalFunction( "InnerAutGroupPGroup" );
DeclareGlobalFunction( "ConvertAutGroup" );
DeclareGlobalFunction( "InduceAutGroup" );
DeclareGlobalFunction( "LinearActionAutGrp" );
DeclareGlobalFunction( "AddInfoCover" );
DeclareGlobalFunction( "InitAutomorphismGroupOver" );
