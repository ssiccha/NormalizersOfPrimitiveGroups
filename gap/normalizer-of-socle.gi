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
        gensSocle, SdMinusOne, gensSdMinusOne, gensLiftSdMinusOne,
        normalizerOfSocle;
    m := LargestMovedPoint(T);
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
    TLeftRegular := Image(ActionHomomorphism(TRightRegular, TRightRegular,
                                             OnLeftInverse, "surjective"));
    gensDiagonalTLeftRegular := List(
        GeneratorsOfGroup(TLeftRegular),
        gen -> Product([1..dMinusOne],
                       i -> PermActionOnIthComponentUnderNaturalProductIdentification(
                           gen, i, m, dMinusOne
                       ))
    );
    gensSocle := Concatenation(gensLiftTRightRegular, gensDiagonalTLeftRegular);
    # The diagonal automorphisms
    # TODO
    # The top group TODO, this is only a part
    SdMinusOne := SymmetricGroup(dMinusOne);
    gensSdMinusOne := GeneratorsOfGroup(SdMinusOne);
    gensLiftSdMinusOne := List(
        gensSdMinusOne,
        g -> PermPermutingComponentsUnderNaturalProductIdentification(
            g, m, dMinusOne
        )
    );
    #TODO remove check
    if not Size(Group(gensLiftSdMinusOne)) = Size(Sd) then
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
        normalizerOfSocle := normalizerOfSocle,
        gensSocle := gensSocle,
        gensLiftTRightRegular := gensLiftTRightRegular,
        gensDiagonalTLeftRegular := gensDiagonalTLeftRegular,
        gensLiftSdMinusOne := gensLiftSdMinusOne
    );
end;
