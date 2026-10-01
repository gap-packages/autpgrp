#############################################################################
##
#W  autos.gd                 AutPGrp package                     Bettina Eick
##

#############################################################################
##
#C Choose functionality 
##
if not IsBound( InitAutGroup ) then InitAutGroup := false; fi;
if not IsBound( AUTPGRP_CHOP_MULT ) then AUTPGRP_CHOP_MULT := true; fi;
if not IsBound( AUTPGRP_NICE_STAB ) then AUTPGRP_NICE_STAB := true; fi;
if not IsBound( AUTPGRP_REDU_OPER ) then AUTPGRP_REDU_OPER := false; fi;
if not IsBound( AUTPGRP_PERM_STAB ) then AUTPGRP_PERM_STAB := true; fi;
if not IsBound( AUTPGRP_CHECK ) then AUTPGRP_CHECK := false; fi;

# the Sophus package reads this name
if not IsBound( REDU_OPER ) then REDU_OPER := false; fi;

#############################################################################
##
#C Tuning constants for the stabilizer computation
##
## Number of gl-orbit blocks enumerated before the set stabilizer
## (PGPermStabilizer) is first tried, and the factor by which that number
## grows between attempts.
BindGlobal( "AUTPGRP_ESCALATE_BLOCKS", 2000 );
BindGlobal( "AUTPGRP_ESCALATE_GROWTH", 4 );
## Sections with at most this many lines are used whole as permutation
## domain; for larger ones only the lines in the orbits of the subspace's
## lines are computed, at most this many, and with at most as many
## vector-matrix products as the enumeration has done so far.
BindGlobal( "AUTPGRP_PERM_FULL_LIMIT", 10^5 );
BindGlobal( "AUTPGRP_PERM_DOMAIN_LIMIT", 10^6 );

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
