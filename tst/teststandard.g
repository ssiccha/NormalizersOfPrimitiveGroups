#
# NormalizersOfPrimitiveGroups
#
# This file runs standard package tests. It is referenced in the package
# metadata in PackageInfo.g.
#
LoadPackage( "NormalizersOfPrimitiveGroups" );

TestDirectory(DirectoriesPackageLibrary("NormalizersOfPrimitiveGroups",
                                        "tst/standard"),
              rec(exitGAP := true));

FORCE_QUIT_GAP(1); # if we ever get here, there was an error
