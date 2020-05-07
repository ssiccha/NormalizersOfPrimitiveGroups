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

# TODO: use these
DeclareProperty("IsInWeakCanonicalForm", IsPermGroup);

DeclareAttribute("WCFSocleComponent",
                 IsPermGroup and IsInWeakCanonicalForm);
DeclareAttribute("WCFTopGroup",
                 IsPermGroup and IsInWeakCanonicalForm);
DeclareAttribute("WCFTopGroupLift",
                 IsPermGroup and IsInWeakCanonicalForm);
DeclareAttribute("WCFSocleComponentNormalizer",
                 IsPermGroup and IsInWeakCanonicalForm);
DeclareAttribute("WCFSocleComponentNormalizerLift",
                 IsPermGroup and IsInWeakCanonicalForm);

DeclareGlobalName("WeakCanonizerOfPrimitiveGroup");

DeclareGlobalName("NaturalProductDecomposition");
