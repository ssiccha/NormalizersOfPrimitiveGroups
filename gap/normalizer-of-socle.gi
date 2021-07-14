# TODO
# Store the socle-component somewhere so that we can simply call
# NormalizerOfSocleForWeaklyCanonicalPrimitivePA(G);
# or
# NormalizerOfSocleForWeaklyCanonicalPrimitive(G);
# MovedPoints(G) needs to be [1 .. LargestMovedPoint(G)]
# T is the socle component of G
NormalizerOfSocleForWeaklyCanonicalPrimitivePA := function(G, T)
    local n, m, d, NT, gensNT, gensLiftNT, LiftNT, Sd, gensSd, gensLiftSd,
        LiftSd, normalizerOfSocle;
    n := LargestMovedPoint(G);
    m := LargestMovedPoint(T);
    d := LogInt(n, m);
    if not n = m ^ d then
        ErrorNoReturn("TODO: not n = m ^ d");
    fi;
    NT := Normalizer(SymmetricGroup(m), T);
    gensNT := GeneratorsOfGroup(NT);
    gensLiftNT := List(
        gensNT,
        g -> PermActionOnIthComponentUnderNaturalProductIdentification(
            g, 1, m, d
        )
    );
    #TODO remove check
    LiftNT := Group(gensLiftNT);
    if not Size(LiftNT) = Size(NT) then
        ErrorNoReturn("TODO: this shouldn't have happened!");
    fi;
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
