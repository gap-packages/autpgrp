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

includes := [
    "autpgrp.xml",
    "method.xml",
    "underl.xml",
    "influen.xml",
    "additional.xml",
];

# The actual call to AutoDoc

AutoDoc("AutPGrp", rec(
    autodoc := rec(scan_dirs := []),
    gapdoc  := rec(main := "main", files := []),
    extract_examples := true,
    scaffold := rec(includes := includes)
));

QuitGap();
