#
# NormalizersOfPrimitiveGroups:
# A package to compute normalizers of primitive groups
#
# TODO
# Use StrictlyHomogeneousProductDecompositionViaConjugation to construct
# - the lift the normaliser of the component,
# - the SymmetricGroup acting on the components.
# BijectiveMappingFromDirectProductDomainToRange
# PermutationFromAutomorphismMapping

# At the end set:
# SetProductDecompositionOfPermGroup
# SetStrictlyHomogeneousProductDecompositionOfPermGroup

# TODO
# make all functions 'global'

# TODO
# Test for l = 1, 2, 3
NORM_SOC_ComplementOfSocleFactors := function(factors, indices)
    local complementIndices, complement, sizes;
    complementIndices := Difference([1 .. Length(factors)], indices);
    complement := factors{complementIndices};
    complement := Group(Concatenation(List(complement, GeneratorsOfGroup)));
    sizes := List(factors, Size){complementIndices};
    SetSize(complement, Product(sizes));
    return complement;
end;

FindConjugatorsHelperFunction := function(G, R, l)
    local simpleSubgroups, conjugators, g, i, conjugateR, foundNew, j;
    simpleSubgroups := ListWithIdenticalEntries(l, 0);
    simpleSubgroups[1] := R;
    conjugators := ListWithIdenticalEntries(l, 0);
    conjugators[1] := ();
    g := ();
    i := 1;
    # TODO instead of R ^ g = simpleSubgroups[j] test whether
    # smallest orbit of R ^ g = smallest orbit simpleSubgroups[j]
    while not i = l do
        g := PseudoRandom(G);
        conjugateR := R ^ g;
        foundNew := true;
        for j in [1 .. i] do
            if conjugateR = simpleSubgroups[j] then
                foundNew := false;
                break;
            fi;
        od;
        if foundNew then
            i := i + 1;
            simpleSubgroups[i] := conjugateR;
            conjugators[i] := g;
        fi;
    od;
    SetMinimalNormalSubgroups(Socle(G), simpleSubgroups);
    conjugators := List(conjugators, x -> x ^ -1);
    return rec(simpleSubgroups := simpleSubgroups, conjugators := conjugators);
end;

SimpleSubgroupsWithConjugatorsOfSocleOfPrimitiveGroup := function(G)
    local movedPoints, soc, compSeriesSoc, l, R, xsetOfSimpleSubgroups,
        rtForSimpleSubgroups, conjugators, simpleSubgroups, complement;
    # TODO if necessary conjugate G such that it acts on [1 .. n]
    # store moved points as range if possible
    if IsRange(MovedPoints(G)) then
        movedPoints := Immutable([SmallestMovedPoint(G)
                                  .. LargestMovedPoint(G)]);
    else
        movedPoints := MovedPoints(G);
    fi;
    soc := Socle(G);
    # Compute one minimal normal subgroup of the socle
    compSeriesSoc := CompositionSeries(soc);
    l := Length(compSeriesSoc) - 1;
    if l = 1 then
        # TODO take care of the trivial case
        return fail;
    fi;
    R := compSeriesSoc[l];
    return FindConjugatorsHelperFunction(G, R, l);
end;

# Ref: Lemma 7.1.5
StrictlyHomogeneousProductDecompositionViaConjugation :=
        function(complement, conjugators)
    local movedPoints, myDelta, Q, conjugatorMaps, PP, P;
    # Compute a block system
    movedPoints := MovedPoints(complement);
    myDelta := OrbitsDomain(complement, movedPoints);
    myDelta := List(myDelta, SortedList);
    MakeImmutable(myDelta);
    # Compute projection for the first simple factor
    Q := MappingByPreImages(Domain(movedPoints), myDelta);
    # g is a list of group elements of G such that g[i] maps the i-th simple
    # factor (simpleSubgroups[i]) to the first one.
    conjugatorMaps :=
        List(conjugators,
             gi -> MappingByPermutation(movedPoints, movedPoints, gi));
    # the strictly homogeneous product decomposition
    return List(conjugatorMaps, gi -> CompositionMapping(Q, gi));
end;

ConjugatorFromProductDecompositionUnderNaturalProductIdentification :=
        function(funcList)
    local domain, n, myDelta, m, d, tuple, funcFromDomainToTuples, imgList, i;
    domain := Source(funcList[1]);
    n := Length(List(domain));
    myDelta := Range(funcList[1]);
    m := Length(List(myDelta));
    d := Length(funcList);
    # TODO: also handle general domain and range
    if not domain = [1 .. n]
            or not myDelta = [1 ..  m] then
        Error("TODO not implemented");
    elif not n = m ^ d then
        Error("TODO not implemented");
    fi;
    tuple := ListWithIdenticalEntries(d, 0);
    funcFromDomainToTuples := x -> List(funcList, f -> ImageElm(f, x));
    imgList := ListWithIdenticalEntries(n, 0);
    for i in [1 .. n] do
        imgList[i] := NaturalProductIdentificationTupleToNumberNC(
            funcFromDomainToTuples(i), m, d
        );
    od;
    return PermList(imgList);
end;

# TODO
# Store the socle-component somewhere so that we can simply call
# NormalizerOfSocleForWeaklyCanonicalPrimitivePA(G);
# or
# NormalizerOfSocleForWeaklyCanonicalPrimitive(G);
# MovedPoints(G) needs to be [1 .. LargestMovedPoint(G)]
# T is the socle component of G
NormalizerOfSocleForWeaklyCanonicalPrimitivePA := function(G, T)
    local n, m, d, NT, gensNT, gensLiftNT, liftNT, Sd, gensSd, gensLiftSd,
        liftSd, normalizerOfSocle;
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
    liftNT := Group(gensLiftNT);
    #TODO turn all checks into asserts as below
    #TODO remove check
    if not Size(liftNT) = Size(NT) then
        ErrorNoReturn("TODO: this shouldn't have happened!");
    fi;
    Sd := SymmetricGroup(d);
    gensSd := GeneratorsOfGroup(Sd);
    # TODO document that the map gensSd -> gensLiftSd extends to iso
    # Sd -> liftSd
    # same for NT -> liftNT
    gensLiftSd := List(
        gensSd,
        g -> PermPermutingComponentsUnderNaturalProductIdentification(
            g, m, d
        )
    );
    liftSd := Group(gensLiftSd);
    #TODO remove check
    if not Size(liftSd) = Size(Sd) then
        ErrorNoReturn("TODO: this shouldn't have happened!");
    fi;
    normalizerOfSocle := Group(Concatenation(gensLiftNT, gensLiftSd));
    Assert(1, Size(normalizerOfSocle) = Size(NT) ^ d * Size(Sd));
    SetSize(normalizerOfSocle, Size(NT) ^ d * Size(Sd));
    SetIsInWeakCanonicalForm(normalizerOfSocle, true);
    SetWCFSocleComponent(normalizerOfSocle, T);
    SetWCFSocleComponentNormalizer(normalizerOfSocle, NT);
    SetWCFSocleComponentNormalizerLift(normalizerOfSocle, liftNT);
    SetWCFTopGroup(normalizerOfSocle, Sd);
    SetWCFTopGroupLift(normalizerOfSocle, liftSd);
    return normalizerOfSocle;
end;

BindGlobal("WeakCanonizerOfPrimitiveGroup",
function(G)
    local tmp, simpleSubgroups, conjugators, l, complement, productDec,
        conjugatorToWeakCanonicalForm, actionOnFirstComponent, socleComponent,
        ardActionByPoin;
    if not IsPrimitive(G)  then
        ErrorNoReturn("WeakCanonizerOfPrimitiveGroup: ",
                      "<G> must be primitive");
    fi;
    tmp := SimpleSubgroupsWithConjugatorsOfSocleOfPrimitiveGroup(G);
    simpleSubgroups := tmp.simpleSubgroups;
    conjugators := tmp.conjugators;
    l := Length(simpleSubgroups);
    # PA type
    if ONanScottType(G) = "4c" then
        # TODO: NORM_SOC -> NORM_PRIM
        complement := NORM_SOC_ComplementOfSocleFactors(simpleSubgroups, [1]);
        productDec := StrictlyHomogeneousProductDecompositionViaConjugation(
            complement, conjugators
        );
    # SD type
    # TODO: trivial case l = 1
    elif ONanScottType(G) = "3b" and l > 2 then
        complement := NORM_SOC_ComplementOfSocleFactors(simpleSubgroups, [1, l]);
        # TODO do not remove!!
        Remove(conjugators, l);
        productDec := StrictlyHomogeneousProductDecompositionViaConjugation(
            complement, conjugators
        );
    else
        ErrorNoReturn("WeakCanonizerOfPrimitiveGroup: ",
                      "case not yet implemented");
    fi;
    # TODO use pragmas to measure the time of only this call?
    conjugatorToWeakCanonicalForm :=
        ConjugatorFromProductDecompositionUnderNaturalProductIdentification(
            productDec
        );
    # Compute socleComponent
    actionOnFirstComponent := PushforwardActionByPointMap(productDec[1]);
    socleComponent := Action(
        simpleSubgroups[1],
        [1 .. Length(List(Range(productDec[1])))],
        actionOnFirstComponent
    );
    return rec(
        conjugatorToWeakCanonicalForm := conjugatorToWeakCanonicalForm,
        socleComponent := socleComponent,
    );
end);
