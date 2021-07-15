# TODO
# Store the socle-component somewhere so that we can simply call
# NormalizerOfSocleForWeaklyCanonicalPrimitivePA(G);
# or
# NormalizerOfSocleForWeaklyCanonicalPrimitive(G);
# MovedPoints(G) needs to be [1 .. LargestMovedPoint(G)]
# T is the socle component of G
NormalizerOfSocleForWeaklyCanonicalPrimitivePA := function(n, T)
    local m, d, NT, gensNT, gensLiftNT, Sd, gensSd, gensLiftSd,
        LiftSd, normalizerOfSocle;
    m := LargestMovedPoint(T);
    d := LogInt(n, m);
    if not n = m ^ d then
        ErrorNoReturn("<n> must be a power of <m>");
    fi;
    NT := Normalizer(SymmetricGroup(m), T);
    # Construct NT acting on the first component
    gensNT := GeneratorsOfGroup(NT);
    gensLiftNT := List(
        gensNT,
        g -> PermActionOnIthComponentUnderNaturalProductIdentification(
            g, 1, m, d
        )
    );
    #TODO remove check
    if not Size(Group(gensLiftNT)) = Size(NT) then
        ErrorNoReturn("TODO: this shouldn't have happened!");
    fi;
    # Construct the top group
    Sd := SymmetricGroup(d);
    gensSd := GeneratorsOfGroup(Sd);
    gensLiftSd := List(
        gensSd,
        g -> PermPermutingComponentsUnderNaturalProductIdentification(
            g, m, d
        )
    );
    #TODO remove check
    LiftSd := Group(gensLiftSd);
    if not Size(LiftSd) = Size(Sd) then
        ErrorNoReturn("TODO: this shouldn't have happened!");
    fi;
    normalizerOfSocle := Group(Concatenation(gensLiftNT, gensLiftSd));
    #TODO remove check
    if not Size(normalizerOfSocle) = Size(NT) ^ d * Size(Sd) then
        ErrorNoReturn("TODO: this shouldn't have happened!");
    fi;
    SetSize(normalizerOfSocle, Size(NT) ^ d * Size(Sd));
    return normalizerOfSocle;
end;

NormalizerOfSocleForWeaklyCanonicalPrimitiveSD := function(n, T)
    local m, dMinusOne, TRightRegular, gensTRightRegular,
        gensLiftTRightRegular, TLeftRegular, gensDiagonalTLeftRegular,
        SdMinusOne, gensSdMinusOne, gensLiftSdMinusOne,
        normalizerOfSocle;
    m := Size(T);
    dMinusOne := LogInt(n, m);
    if not n = m ^ dMinusOne then
        ErrorNoReturn("<n> must be a power of <m>");
    fi;
    # T in right regular action on the first component
    TRightRegular := Image(RegularActionHomomorphism(T));
    gensTRightRegular := GeneratorsOfGroup(TRightRegular);
    gensLiftTRightRegular := List(
        gensTRightRegular,
        g -> PermActionOnIthComponentUnderNaturalProductIdentification(
            g, 1, m, dMinusOne
        )
    );
    #TODO remove check
    if not Size(Group(gensLiftTRightRegular)) = Size(T) then
        ErrorNoReturn("TODO: this shouldn't have happened!");
    fi;
    # T in diagonal left regular action on all components
    leftActionHomomorphism := ActionHomomorphism(TRightRegular, TRightRegular,
                                                 OnLeftInverse, "surjective");
    TLeftRegular := Image(leftActionHomomorphism);
    gensDiagonalTLeftRegular := List(
        GeneratorsOfGroup(TLeftRegular),
        gen -> Product([1..dMinusOne],
                       i -> PermActionOnIthComponentUnderNaturalProductIdentification(
                           gen, i, m, dMinusOne
                       ))
    );
    # The diagonal automorphisms
    autOfRightRegular := AutomorphismGroup(TRightRegular);
    # BEGIN
    # Construct Aut(T) acting diagonally on the socle
    # TODO: only if Out(T) is non-trivial.
    mapAutOfRightRegularToAutOfLeftRegular
        := x -> CompositionMapping(leftActionHomomorphism,
                                   x,
                                   InverseGeneralMapping(leftActionHomomorphism));

    # first some sanity checks
    innerOfRightRegular := autGroup.1;;
    conjOfInnerOfLeftRegular := ConjugatorOfConjugatorIsomorphism(mapAutOfRightRegularToAutOfLeftRegular(innerOfRightRegular));;
    conjOfInnerOfLeftRegular in A6left;
    Image(leftActionHomomorphism, ConjugatorOfConjugatorIsomorphism(innerOfRightRegular)) = conjOfInnerOfLeftRegular;

    outGens := Filtered(GeneratorsOfGroup(autGroup), x -> not IsInnerAutomorphism(x));;
    out := outGens[1];;
    outDiag := GroupHomomorphismByImages(TL, TL, gensTL, Concatenation(List(gensT, x -> Image(out, x)), List(gensL, x -> Image(mapAutOfRightRegularToAutOfLeftRegular(out), x))));;
    outDiagPerm := ConjugatorOfConjugatorIsomorphism(outDiag);;
    actionOnDPD := ActionOnDirectProductDomain([OnPoints, OnPoints]);;
    outDiagPermOnDPD := Permutation(outDiagPerm, dpd, actionOnDPD);;
    soc ^ outDiagPermOnDPD = soc;
    diagonalA6left ^ outDiagPermOnDPD = diagonalA6left;
    # END
    # The top group TODO, this is only a part
    SdMinusOne := SymmetricGroup(dMinusOne);
    gensSdMinusOne := GeneratorsOfGroup(SdMinusOne);
    if dMinusOne = 1 then
        gensSdMinusOne := [()];
    fi;
    gensLiftSdMinusOne := List(
        gensSdMinusOne,
        g -> PermPermutingComponentsUnderNaturalProductIdentification(
            g, m, dMinusOne
        )
    );
    #TODO remove check
    if not Size(Group(gensLiftSdMinusOne)) = Size(SdMinusOne) then
        ErrorNoReturn("TODO: this shouldn't have happened!");
    fi;
    # Now the normalizer of the socle
    # TODO: finish this
    #normalizerOfSocle := Group(Concatenation(gensSocle, gensLiftSdMinusOne));
    #TODO remove check
    #if not Size(normalizerOfSocle) = Size(NT) ^ dMinusOne * Size(SdMinusOne) then
    #    ErrorNoReturn("TODO: this shouldn't have happened!");
    #fi;
    #SetSize(normalizerOfSocle, Size(NT) ^ dMinusOne * Size(SdMinusOne));
    return rec(
        #normalizerOfSocle := normalizerOfSocle,
        gensLiftTRightRegular := gensLiftTRightRegular,
        gensDiagonalTLeftRegular := gensDiagonalTLeftRegular,
        gensLiftSdMinusOne := gensLiftSdMinusOne
    );
end;
