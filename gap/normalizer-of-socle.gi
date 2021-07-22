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
    local m, dMinusOne, TRightRegular, gensLiftTRightRegular,
        leftActionHomomorphism, TLeftRegular, gensDiagonalTLeftRegular,
        simpleDiagonalSocleOnOneComponent, autOfRightRegular,
        mapAutOfRightRegularToAutOfLeftRegular, outGens,
        permsInducingDiagonalOuters, sigmaOnLeftRegular, outDiagOnOneComponent,
        liftPermsInducingDiagonalOuters, gensSdMinusOne, gensLiftSdMinusOne,
        dMinusOneCycle, liftDMinusOneCycle, gensSocleComponents, socle,
        transposingAutOfSocle, transposition, gensFullTopGroup, sigma;
    m := Size(T);
    dMinusOne := LogInt(n, m);
    if not n = m ^ dMinusOne then
        ErrorNoReturn("<n> must be a power of <m>");
    fi;
    # T in right regular action on the first component
    TRightRegular := Image(RegularActionHomomorphism(T));
    
    gensLiftTRightRegular := List(
        GeneratorsOfGroup(TRightRegular),
        g -> PermActionOnIthComponentUnderNaturalProductIdentification(
            g, 1, m, dMinusOne
        )
    );
    #TODO remove check
    if not Size(Group(gensLiftTRightRegular)) = Size(T) then
        ErrorNoReturn("TODO: this shouldn't have happened!");
    fi;
    # T in left regular action diagonally on all components
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
    # Construct Out(T) acting diagonally on the socle
    # First we work on a single component of our n = m ^ dMinusOne points, that
    # is on m points. We only need to do the following construction for
    # generators of the outer automorphism group.
    #   Take an automorphism sigma of TRightRegular and construct an
    # automorphism phi of simpleDiagonalSocleOnOneComponent :=
    # <TRightRegular, TLeftRegular> which does the
    # following. Let lambda be leftActionHomomorphism, that is an isomorphism
    # from TRightRegular to TLeftRegular. Let TRightRegular = <X>. Note that
    # TLeftRegular = <lambda(X)>. The automorphism phi maps an x in X to
    # sigma(x) and a lambda(x) in lambda(X) to
    # lambda(sigma(x)
    #     = (lambda o sigma o lambda ^ -1)(lambda(x)).
    # Thus on simpledi the diagonal application of
    simpleDiagonalSocleOnOneComponent := GroupWithGenerators(Concatenation(
        GeneratorsOfGroup(TRightRegular),
        GeneratorsOfGroup(TLeftRegular)
    ));
    StabChain(simpleDiagonalSocleOnOneComponent, rec(size := m^2));
    autOfRightRegular := AutomorphismGroup(TRightRegular);
    # TODO: what happens if Out(T) is trivial?
    mapAutOfRightRegularToAutOfLeftRegular
        := x -> CompositionMapping(leftActionHomomorphism,
                                   x,
                                   InverseGeneralMapping(leftActionHomomorphism));
    outGens := Filtered(GeneratorsOfGroup(autOfRightRegular),
                        x -> not IsInnerAutomorphism(x));
    permsInducingDiagonalOuters := [];
    for sigma in outGens do
        sigmaOnLeftRegular := mapAutOfRightRegularToAutOfLeftRegular(sigma);
        outDiagOnOneComponent := GroupHomomorphismByImagesNC(
            simpleDiagonalSocleOnOneComponent,
            simpleDiagonalSocleOnOneComponent,
            GeneratorsOfGroup(simpleDiagonalSocleOnOneComponent),
            Concatenation(
                List(GeneratorsOfGroup(TRightRegular),
                     x -> Image(sigma, x)),
                List(GeneratorsOfGroup(TLeftRegular),
                     x -> Image(sigmaOnLeftRegular, x))
            )
        );
        Add(permsInducingDiagonalOuters,
            ConjugatorOfConjugatorIsomorphism(outDiagOnOneComponent));
    od;
    # Take the unique permutation pi of Sym(m) which induces the automorphism
    # phi of <TRightRegular, TLeftRegular>. Then let this pi act on every
    # component of the n = m ^ dMinusOne points simultaneously. The result
    # induces sigma on every component of the socle.
    liftPermsInducingDiagonalOuters := List(
        permsInducingDiagonalOuters,
        g -> Product(
            [1..dMinusOne],
            i -> PermActionOnIthComponentUnderNaturalProductIdentification(
                g, i, m, dMinusOne
            )
        )
    );
    # Now construct the top group.
    # The top group should act via conjugation on the components of the socle as
    # the full symmetric group. We construct the full symmetric group on the
    # first dMinusOne components by permuting the components of the
    # n = m ^ dMinusOne points. Then we construct one more element of the top
    # group by constructing a permutation which conjugates the first to the
    # last component of the socle, and which fixes all other components.
    # First the full symmetric group on the dMinusOne components.
    if dMinusOne = 1 then
        gensSdMinusOne := [()];
    else
        gensSdMinusOne := GeneratorsOfGroup(SymmetricGroup(dMinusOne));
    fi;
    gensLiftSdMinusOne := List(
        gensSdMinusOne,
        g -> PermPermutingComponentsUnderNaturalProductIdentification(
            g, m, dMinusOne
        )
    );
    #TODO remove check
    if not Size(Group(gensLiftSdMinusOne)) = Factorial(dMinusOne) then
        ErrorNoReturn("TODO: this shouldn't have happened!");
    fi;
    # Now the missing permutation to generate the full Sym(d) as a top group.
    # First explicitly construct all components of the socle.
    dMinusOneCycle := PermList(Concatenation([2..dMinusOne], [1]));
    liftDMinusOneCycle :=
        PermPermutingComponentsUnderNaturalProductIdentification(
            dMinusOneCycle, m, dMinusOne
        );
    # First do all socle components except for the last one.
    gensSocleComponents := List(
        [0..dMinusOne-1],
        i -> OnTuples(gensLiftTRightRegular, liftDMinusOneCycle ^ i)
    );
    # Now add the last component.
    Add(gensSocleComponents, gensDiagonalTLeftRegular);
    # Now we can compute an automorphism which transposes the first and the
    # last socle component and fixes all others.
    socle := Group(Concatenation(gensSocleComponents));
    SetSize(socle, m ^ (dMinusOne + 1));
    transposingAutOfSocle := GroupHomomorphismByImagesNC(
        socle,
        socle,
        GeneratorsOfGroup(socle),
        Concatenation(
            Permuted(gensSocleComponents, (1,(dMinusOne+1)))
        )
    );
    transposition := ConjugatorOfConjugatorIsomorphism(transposingAutOfSocle);
    gensFullTopGroup := Concatenation(gensLiftSdMinusOne, [transposition]);

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
        gensSocleComponents := gensSocleComponents,
        gensLiftSdMinusOne := gensLiftSdMinusOne,
        gensFullTopGroup := gensFullTopGroup,
        sizeOfSocleNormalizer := m ^ (dMinusOne + 1) * Factorial(dMinusOne + 1)
            * (Size(autOfRightRegular) / m)
    );
end;
