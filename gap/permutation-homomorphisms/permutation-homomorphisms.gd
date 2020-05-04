DeclareOperation("PushforwardActionByPointMap", [IsMapping, IsFunction]);

DeclareGlobalName("MappingByPermutation");
DeclareGlobalName("MappingByPreImages");

# TODO Properly define permutation morphisms one day?
# DeclareCategory("IsPermMorphism",
#                 IsComponentObjectRep and IsAttributeStoringRep);
# BindGlobal("PermMorphismFamily", NewFamily("PermMorphismFamily"));
# BindGlobal("PermMorphismType",
#            NewType(PermMorphismFamily, IsPermMorphism));
