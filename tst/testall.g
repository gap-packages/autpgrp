LoadPackage("autpgrp");
TestDirectory(DirectoriesPackageLibrary("autpgrp", "tst"), rec(exitGAP := true,
testOptions := rec(compareFunction := "uptowhitespace")));
FORCE_QUIT_GAP(1);
