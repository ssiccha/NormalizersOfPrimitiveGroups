#
# NormalizersOfPrimitiveGroups
#
# This file runs all available package tests.
#
LoadPackage( "NormalizersOfPrimitiveGroups" );

TestDirectory(DirectoriesPackageLibrary( "NormalizersOfPrimitiveGroups", "tst" ),
  rec(exitGAP := true));

FORCE_QUIT_GAP(1); # if we ever get here, there was an error
