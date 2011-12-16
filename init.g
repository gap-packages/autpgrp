#############################################################################
##
#W  init.g                   AutPGrp package                     Bettina Eick
##
#H  @(#)$Id: init.g,v 1.3 2002/11/19 14:30:19 gap Exp $
##

DeclareAutoPackage( "autpgrp", "1.2", 
  function()
    if not CompareVersionNumbers( VERSION, "4.3fix4" ) then
      Info( InfoWarning, 1, "This version of the AutPGrp package requires ",
                            "at least GAP 4.3fix4" );
      return fail;
    fi;
    return true;
  end );
  
DeclarePackageAutoDocumentation( "AutPGrp", "doc", "AutPGrp",
                                 "Computing automorphism groups of p-groups" );

ReadPkg( "autpgrp", "gap/autos.gd" );
