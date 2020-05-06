#
# NormalizersOfPrimitiveGroups:
# A package to compute normalizers of primitive groups
#
# What is product decomposition of a permutation group?
# TODO: define product decomposition "object type"?
# TODO all functins assume that domain is [1 .. n]?
# A list of surjective permutation homomorphisms with the property that their
# direct product is an isomorphism.
DeclareAttribute("ProductDecompositionOfPermGroup", IsPermGroup);
DeclareAttribute("StrictlyHomogeneousProductDecompositionOfPermGroup",
                 IsPermGroup);

DeclareGlobalName("WeakCanonizerOfPrimitiveGroup");

DeclareGlobalName("NaturalProductDecomposition");
