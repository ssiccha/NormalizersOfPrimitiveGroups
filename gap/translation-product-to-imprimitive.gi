#
# NormalizersOfPrimitiveGroups: A package to compute normalizers of primitive
# groups
#
# TODO this can only be called on socle norms for now. It's easy to extend to
# general product action WPs. Should I?
BindGlobal("IsomorphismProductActionToImprimitiveWreathProduct",
function(socleNormalizer)
    local n, socleComponentNormalizer, m, d, gensOfSocleComponentNormalizer,
        gensOfSocleComponentNormalizerLift,
        gensOfSocleComponentNormalizerImprimitive, gensOfTopGroup,
        gensOfTopGroupLift, gensOfTopGroupImprimitive, gensImprimitive,
        gensProduct, imprimitive;
    n := LargestMovedPoint(socleNormalizer);
    socleComponentNormalizer := WCFSocleComponentNormalizer(socleNormalizer);
    m := LargestMovedPoint(socleComponentNormalizer);
    d := LogInt(n, m);
    if not n = m ^ d then
        # TODO: better error msg
        ErrorNoReturn("n must be m ^ d");
    fi;
    gensOfSocleComponentNormalizer :=
        GeneratorsOfGroup(WCFSocleComponentNormalizer(socleNormalizer));
    gensOfSocleComponentNormalizerLift :=
        GeneratorsOfGroup(WCFSocleComponentNormalizerLift(socleNormalizer));
    gensOfSocleComponentNormalizerImprimitive := List(
        gensOfSocleComponentNormalizer,
        g -> PermActionOnIthCopyUnderNaturalCoproductIdentification(
            g, 1, m, d
        )
    );
    # For socle normalizers this is always S_d
    gensOfTopGroup := GeneratorsOfGroup(WCFTopGroup(socleNormalizer));
    gensOfTopGroupLift := GeneratorsOfGroup(WCFTopGroupLift(socleNormalizer));
    gensOfTopGroupImprimitive := List(
        gensOfTopGroup,
        g -> PermActionAsTopGroupUnderNaturalCoproductIdentification(
            g, m, d
        )
    );
    gensImprimitive := Concatenation(gensOfSocleComponentNormalizerImprimitive,
                                     gensOfTopGroupImprimitive);
    gensProduct := Concatenation(gensOfSocleComponentNormalizerLift,
                                 gensOfTopGroupLift);
    imprimitive := Group(gensImprimitive);
    Assert(1, Size(imprimitive) = Size(socleNormalizer));
    SetSize(imprimitive, Size(socleNormalizer));
    # Tests whether the homomorphism is well-defined (note the missing NC) and
    # bijective
    Assert(1,
           IsBijective(GroupHomomorphismByImages(socleNormalizer,
                                                 imprimitive,
                                                 gensProduct,
                                                 gensImprimitive)));
    return GroupHomomorphismByImagesNC(socleNormalizer,
                                       imprimitive,
                                       gensProduct,
                                       gensImprimitive);
end);
