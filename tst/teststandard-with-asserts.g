#
# NormalizersOfPrimitiveGroups
#
# This file runs standard package tests. It is referenced in the package
# metadata in PackageInfo.g.
#
LoadPackage( "NormalizersOfPrimitiveGroups" );

SetAssertionLevel(1);
Print("Set assertion level to 1!\n");
TestDirectory(DirectoriesPackageLibrary("NormalizersOfPrimitiveGroups",
                                        "tst/standard"),
              rec(exitGAP := true));

FORCE_QUIT_GAP(1); # if we ever get here, there was an error
