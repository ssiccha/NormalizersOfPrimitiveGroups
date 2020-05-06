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

SimpleFactorsWithConjugatorsOfSocleOfPrimitiveGroup := function(G)
    local movedPoints, soc, compSeriesSoc, l, R, xsetOfSimpleFactors,
        rtForSimpleFactors, conjugators, simpleFactors, complement;
    # TODO if necessary conjugate G such that it acts on [1 .. n]
    # store moved points as range if possible
    if IsRange(MovedPoints(G)) then
        movedPoints := Immutable([SmallestMovedPoint(G)
                                  .. LargestMovedPoint(G)]);
    else
        movedPoints := MovedPoints(G);
    fi;
    soc := Socle(G);
    # Compute the minimal normal subgroups of the socle
    compSeriesSoc := CompositionSeries(soc);
    l := Length(compSeriesSoc) - 1;
    if l = 1 then
        # TODO take care of the trivial case
        return fail;
    fi;
    R := compSeriesSoc[l];
    # TODO Maybe force GAP to use OrbitsDomain? Or does this also dispatch to a
    # normalizer computation somehow?
    # TODO find a way to tell GAP that I know the number of simple factors
    xsetOfSimpleFactors := ConjugacyClassSubgroups(G, R);
    rtForSimpleFactors :=
        RightTransversal(G, StabilizerOfExternalSet(xsetOfSimpleFactors));
    conjugators := AsList(rtForSimpleFactors);
    simpleFactors := List(conjugators, x -> R ^ x);
    SetMinimalNormalSubgroups(soc, simpleFactors);
    conjugators := List(conjugators, x -> x ^ -1);
    return rec(simpleFactors := simpleFactors, conjugators := conjugators);
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
    # factor (simpleFactors[i]) to the first one.
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

BindGlobal("WeakCanonizerOfPrimitiveGroup",
function(G)
    local tmp, simpleFactors, conjugators, l, complement, productDec,
        conjugatorToWeakCanonicalForm, actionOnFirstComponent, socleComponent,
        ardActionByPoin;
    if not IsPrimitive(G)  then
        ErrorNoReturn("WeakCanonizerOfPrimitiveGroup: ",
                      "<G> must be primitive");
    fi;
    tmp := SimpleFactorsWithConjugatorsOfSocleOfPrimitiveGroup(G);
    simpleFactors := tmp.simpleFactors;
    conjugators := tmp.conjugators;
    l := Length(simpleFactors);
    # PA type
    if ONanScottType(G) = "4c" then
        complement := NORM_SOC_ComplementOfSocleFactors(simpleFactors, [1]);
        productDec := StrictlyHomogeneousProductDecompositionViaConjugation(
            complement, conjugators
        );
    # SD type
    # TODO: trivial case l = 1
    elif ONanScottType(G) = "3b" and l > 2 then
        complement := NORM_SOC_ComplementOfSocleFactors(simpleFactors, [1, l]);
        Remove(conjugators, l);
        productDec := StrictlyHomogeneousProductDecompositionViaConjugation(
            complement, conjugators
        );
    else
        ErrorNoReturn("WeakCanonizerOfPrimitiveGroup: ",
                      "case not yet implemented");
    fi;
    conjugatorToWeakCanonicalForm :=
        ConjugatorFromProductDecompositionUnderNaturalProductIdentification(
            productDec
        );
    # TODO finish
    # Compute socleComponent
    actionOnFirstComponent := PushforwardActionByPointMap(productDec[1]);
    socleComponent := Action(
        simpleFactors[1],
        [1 .. Length(List(Range(productDec[1])))],
        actionOnFirstComponent
    );
    return rec(
        conjugatorToWeakCanonicalForm := conjugatorToWeakCanonicalForm,
        socleComponent := socleComponent,
    );
end);
