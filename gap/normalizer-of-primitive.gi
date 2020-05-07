#
# NormalizersOfPrimitiveGroups:
# A package to compute normalizers of primitive groups
#
BindGlobal("NormalizerInSymmetricGroupOfPrimitiveGroup",
function(G)
    local type, tmp, wcfG, socleComponent, M, iso, imprimitiveM,
        imprimitiveWcfG, imprimitiveWcfN, wcfN, N;
    type := ONanScottType(G);
    # product action of almost simple
    if type = "4c" then
        tmp := WeakCanonizerOfPrimitiveGroup(G);
        wcfG := G ^ tmp.conjugatorToWeakCanonicalForm;
        socleComponent := tmp.socleComponent;
        M := NormalizerOfSocleForWeaklyCanonicalPrimitivePA(wcfG,
                                                            socleComponent);
        iso := IsomorphismProductActionToImprimitiveWreathProduct(M);
        imprimitiveM := Image(iso, M);
        imprimitiveWcfG := Image(iso, wcfG);
        imprimitiveWcfN := Normalizer(imprimitiveM, imprimitiveWcfG);
        wcfN := PreImage(iso, imprimitiveWcfN);
        N := wcfN ^ (tmp.conjugatorToWeakCanonicalForm ^ -1);
    else
        ErrorNoReturn("TODO: not yet implemented");
    fi;
    return N;
end);
