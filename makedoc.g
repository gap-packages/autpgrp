#############################################################################
##
##  makedoc.g
##  Copyright (C) 2025                                  James D. Mitchell
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##

LoadPackage("AutoDoc");

# Helper functions

UrlEntity := function(name, url)
  return StringFormatted("""<Alt Not="Text"><URL Text="{1}">{2}</URL></Alt>
    <Alt Only="Text"><Package>{1}</Package></Alt>""", name, url);
end;

PackageEntity := function(name)
  if TestPackageAvailability(name) <> fail then
    return UrlEntity(PackageInfo(name)[1].PackageName,
                     PackageInfo(name)[1].PackageWWWHome);
  fi;
  return StringFormatted("<Package>{}</Package>", name);
end;

# The scaffold files (chapters)

Includes := ["autpgrp.xml", "method.xml", "underl.xml", "influen.xml",
             "additional.xml"];

# The actual call to AutoDoc

AutoDoc("AutPGrp", rec(
    autodoc := rec(scan_dirs := []),
    gapdoc  := rec(main  := "main", files := []),
    extract_examples := true,

    scaffold := rec(
        includes := Includes,
        entities := rec(
        AUTPGRP := PackageEntity("AutPGrp")))));

QuitGap();
