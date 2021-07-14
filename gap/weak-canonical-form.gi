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
