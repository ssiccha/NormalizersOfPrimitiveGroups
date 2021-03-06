#!/usr/bin/env bash
#
# DO NOT EDIT THIS FILE!
#
# If you need to run additional setup steps before the package tests,
# edit the run script in .travis.yml instead
#
# If you have any questions about this script, or think it is not general
# enough to cover your use case (i.e., you feel that you need to modify it
# anyway), please contact Max Horn <max.horn@math.uni-giessen.de>.
#
set -ex

# start GAP with custom GAP root, to ensure correct package version is loaded
GAP="$GAPROOT/bin/gap.sh -l $PWD/gaproot; --quitonbreak"

# Unless explicitly turned off by setting the NO_COVERAGE environment variable,
# we collect coverage data
if [[ -z $NO_COVERAGE ]]; then
    mkdir $COVDIR
    GAP="$GAP --cover $COVDIR/test.coverage"
fi

$GAP tst/teststandard.g
