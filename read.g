#############################################################################
##
#W  read.g                   AutPGrp package                     Bettina Eick
##

if not IsBound(SolvableRadical) then
    # for backwards compatibility with GAP versions before 4.12
    BindGlobal( "SolvableRadical", RadicalGroup );
fi;

ReadPackage( "autpgrp", "gap/general.gi");
ReadPackage( "autpgrp", "gap/autoops.gi");
ReadPackage( "autpgrp", "gap/matrix.gi");

ReadPackage( "autpgrp", "gap/nicestab.gi");
ReadPackage( "autpgrp", "gap/initmat.gi");
ReadPackage( "autpgrp", "gap/initperm.gi");

ReadPackage( "autpgrp", "gap/hybrstab.gi");
ReadPackage( "autpgrp", "gap/matrstab.gi");
ReadPackage( "autpgrp", "gap/orbstab.gi");

ReadPackage( "autpgrp", "gap/autos.gi");

ReadPackage( "autpgrp", "gap/pcpres.gi");

ReadPackage( "autpgrp", "gap/countcl.gi");

