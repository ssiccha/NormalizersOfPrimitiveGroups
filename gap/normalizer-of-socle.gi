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
        permsInducingDiagonalOuters, psiOnLeftRegular, outDiagOnOneComponent,
        liftPermsInducingDiagonalOuters, gensSdMinusOne, gensLiftSdMinusOne,
        imgList, i, rho_x_1, lambda_x_1, highestTerm, iteratorTuples, point,
        tuple, imgTuple,
        gensFullTopGroup, psi,
        gensNormalizerOfSocle, normalizerOfSocle;
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
    #   Take an automorphism psi of TRightRegular and construct an
    # automorphism phi of simpleDiagonalSocleOnOneComponent :=
    # <TRightRegular, TLeftRegular> which does the
    # following. Let lambda be leftActionHomomorphism, that is an isomorphism
    # from TRightRegular to TLeftRegular. Let TRightRegular = <X>. Note that
    # TLeftRegular = <lambda(X)>. The automorphism phi maps an x in X to
    # psi(x) and a lambda(x) in lambda(X) to
    # lambda(psi(x)
    #     = (lambda o psi o lambda ^ -1)(lambda(x)).
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
    for psi in outGens do
        psiOnLeftRegular := mapAutOfRightRegularToAutOfLeftRegular(psi);
        outDiagOnOneComponent := GroupHomomorphismByImagesNC(
            simpleDiagonalSocleOnOneComponent,
            simpleDiagonalSocleOnOneComponent,
            GeneratorsOfGroup(simpleDiagonalSocleOnOneComponent),
            Concatenation(
                List(GeneratorsOfGroup(TRightRegular),
                     x -> Image(psi, x)),
                List(GeneratorsOfGroup(TLeftRegular),
                     x -> Image(psiOnLeftRegular, x))
            )
        );
        Add(permsInducingDiagonalOuters,
            ConjugatorOfConjugatorIsomorphism(outDiagOnOneComponent));
    od;
    # Take the unique permutation of Sym(m) which induces the automorphism
    # phi of <TRightRegular, TLeftRegular>. Then let this permutation act on
    # every component of the n = m ^ dMinusOne points simultaneously. The
    # result induces psi on every component of the socle.
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
    # Now construct the missing permutation pi which we need to generate the
    # full Sym(d) as a top group.
    # We use the following bijections. One can identify each point of the set
    # {1..n} with a dMinusOne-tuple of numbers in {1..m} via
    # NORM_SOC_TupleToMAdicWithOffset.
    # By identifying each number in {1..m} with an element of T, such a tuple
    # can be identified with a tuple (x_1, ..., x_dMinusOne) in T ^ dMinusOne.
    # That tuple in turn is identified with a block [x_1, ..., x_{dMinusOne}, 1]
    # of a diagonal action domain.
    # The permutation pi in Sym_n needs to transpose the first and last
    # component of every block. That is pi maps
    # [x_1, ..., x_{dMinusOne}, 1]
    # to
    # [1, x_2, ..., x_{dMinusOne}, x_1] =
    #     [x_1 ^ {-1}, x_1 ^ {-1} * x_2, ..., x_1 ^ {-1} * x_{dMinusOne}, 1]
    # For each x_1 in the first component we now need to do two things: how do
    # we find the x_i and how do we multiply with x_1 ^ {-1} from the left?
    # Denote the right regular action homomorphism by rho : T -> TRightRegular.
    # For each i in {1..m} we can find a unique rho(x_1) in TRightRegular with
    # 1 ^ rho(x_1) = i via RepresentativeAction.
    # Denote the left regular action homomorphism by lambda : T -> TLeftRegular.
    # We have leftActionHomomorphism(rho(x_1)) = lambda(x_1), that is the
    # permutation induced on {1..m} by multiplying with x_1 ^ -1 from the left.
    # We build an imgList which we turn into a permutation via PermList.
    imgList := EmptyPlist(m ^ dMinusOne);
    # Map a number which represents
    # (x_1, ..., x_{dMinusOne})
    # to the number which represents
    # (x_1 ^ {-1}, x_1 ^ {-1} * x_2, ..., x_1 ^ {-1} * x_{dMinusOne}).
    for i in [1..m] do
        #i := testArg;
        # Find rho(x_1) and lambda(x_1).
        rho_x_1 := RepresentativeAction(TRightRegular, 1, i);
        lambda_x_1 := Image(leftActionHomomorphism, rho_x_1);
        # We handle the first component separately. x_1 is mapped to its
        # inverse. Take the number corresponding to x_1 ^ -1. Multiply it by
        # m ^ (dMinusOne - 1) to get the highest term of the numbers
        # representing tuples which have x_1 ^ -1 in its first component.
        highestTerm := ((1 ^ lambda_x_1) - 1) * m ^ (dMinusOne - 1);
        # For each (x_2, ..., x_{dMinusOne}) ...
        iteratorTuples := IteratorOfTuples([1 .. m], dMinusOne - 1);
        for point in [1 .. m ^ (dMinusOne - 1)] do
            tuple := NextIterator(iteratorTuples);
            # apply lambda(x_1) to each entry of the tuple.
            imgTuple := List(tuple, j -> j ^ lambda_x_1);
            imgList[(i - 1) * m ^ (dMinusOne - 1) + point] := highestTerm
            + NORM_SOC_TupleToMAdicWithOffset(
                imgTuple,
                m,
                dMinusOne - 1
            );
        od;
    od;
    gensFullTopGroup := Concatenation(gensLiftSdMinusOne, [PermList(imgList)]);

    # Now the normalizer of the socle. The generators gensDiagonalTLeftRegular
    # are not really needed, I just add them since they can be used to do some
    # sanity checks.
    gensNormalizerOfSocle := Concatenation(
        gensLiftTRightRegular,
        gensDiagonalTLeftRegular,
        liftPermsInducingDiagonalOuters,
        gensFullTopGroup
    );
    normalizerOfSocle := Group(Concatenation(gensSocle, gensLiftSdMinusOne));
    SetSize(normalizerOfSocle, m ^ (dMinusOne + 1) * Factorial(dMinusOne + 1)
            * (Size(autOfRightRegular) / m));
    return rec(
        gensLiftTRightRegular := gensLiftTRightRegular,
        gensDiagonalTLeftRegular := gensDiagonalTLeftRegular,
        liftPermsInducingDiagonalOuters := liftPermsInducingDiagonalOuters,
        gensFullTopGroup := gensFullTopGroup,
        normalizerOfSocle := normalizerOfSocle
    );
end;
