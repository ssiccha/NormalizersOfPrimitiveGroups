#
# NormalizersOfPrimitiveGroups:
# A package to compute normalizers of primitive groups
#
BindGlobal("NormalizerInSymmetricGroupOfPrimitiveGroup",
function(G)
    local type, tmp, WeaklyCanonicalG, socleComponent, M;
    type := ONanScottType(G);
    # product action of almost simple
    if type = "4c" then
        tmp := WeakCanonizerOfPrimitiveGroup(G);
        WeaklyCanonicalG := G ^ tmp.conjugatorToWeakCanonicalForm;
        socleComponent := tmp.socleComponent;;
        M := NormalizerOfSocleForWeaklyCanonicalPrimitivePA(WeaklyCanonicalG,
                                                            socleComponent);
        M := M ^ (tmp.conjugatorToWeakCanonicalForm ^ -1);
    else
        ErrorNoReturn("TODO: not yet implemented");
    fi;
    return Normalizer(M, G);
end);
