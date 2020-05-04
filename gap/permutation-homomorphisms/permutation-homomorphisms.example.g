# vi: set ft=gap
## Preparation
# B_0 := AlternatingGroup(5);
B_0 := PSL(2,5);
K_0 := SymmetricGroup(3);
G_0 := WreathProductProductAction(B_0, K_0);
# Almost the base group
## find direct factors of the socle
soc_0 := Socle(G_0);
factors_0 := MinimalNormalSubgroups(soc_0);
# Top group
top_0 := Action(SymmetricGroup(3), Tuples([1..NrMovedPoints(B_0)], 3), Permuted);
# Random conjugate
sigma := PseudoRandom(SymmetricGroup(MovedPoints(G_0)));;
G := G_0 ^ sigma;;
soc := soc_0 ^ sigma;;
factors := MinimalNormalSubgroups(soc);
n := NrMovedPoints(G);
l := Length(factors);
m := RootInt(n,l);

# Function for some fundamental computations
ComplementOfSocleFactor := function(factors, i)
    local gens, complement;
    factors := ShallowCopy(factors);
    Remove(factors, i);
    gens := Concatenation(List(factors, GeneratorsOfGroup));
    complement := Group(gens);
    SetSize(complement, Product(List(factors, Size)));
    return complement;
end;

C1 := ComplementOfSocleFactor(factors, 1);
Delta1 := List(OrbitsDomain(C1, [1..n]), SortedList);
rangeDomain := Domain([1..n]);
g := [];
for i in [1..l] do
    g_i := RepresentativeAction(G, factors[i], factors[1]);
    Add(g, g_i);
od;
r := List(g, gi -> MappingByPermutation(rangeDomain, rangeDomain, gi));
q1 := MappingByPreImages(rangeDomain, Delta1);
p := List(r, ri -> CompositionMapping(q1, ri));
# we don't need the group homs
#psi1 := GroupHomomorphismFromPointMap(soc, q1);
#phi := List(p, pi -> ActionHomomorphism(soc,
#                                        AsList(Range(pi)),
#                                        PushforwardActionByPointMap(pi)));

# TODO try to get rid of the "on DPD step"? Directly construct H1OnRange from
# H1 somehow?
bijToDirectProduct := DirectProductMapping(p);
dpd := Range(bijToDirectProduct);
bijToRange := CompositionMapping(
    BijectiveMappingFromDirectProductDomainToRange(Range(bijToDirectProduct)),
    bijToDirectProduct
);
SetIsBijective(bijToRange, true);
SetIsEndoGeneralMapping(bijToRange, true);
conjugatorIntoWreathProductFromDirectProduct :=
    PermutationFromAutomorphismMapping(bijToRange);


phi1 := ActionHomomorphism(factors[1], AsList(Range(p[1])),
                           PushforwardActionByPointMap(p[1]));
T1 := Image(phi1);
H1 := Normalizer(SymmetricGroup(NrMovedPoints(T1)), T1);
actionOnFirstComp := ActionOnDirectProductDomain(dpd, OnPoints, 1);
actionOnRangeByOnFirstComp :=
    ActionOnRangeByActionOnDirectProductDomain(actionOnFirstComp, dpd);
actionOnRangeByOnFirstCompHom :=
    ActionHomomorphism(H1, [1..n], actionOnRangeByOnFirstComp);
H1OnRange := Image(actionOnRangeByOnFirstCompHom);
Size(H1OnRange);

# USE PushforwardActionByPointMap to translate
# ActionOnComps into ActionOnRangeByComps


actionPermutingComps :=
    ActionByPermutingComponentsOfDirectProductDomain(dpd);;
actionPermutingCompsAsActionOnRange :=
    ActionOnRangeByActionOnDirectProductDomain(actionPermutingComps, dpd);;
actionPermutingCompsAsActionOnRangeHom :=
    ActionHomomorphism(SymmetricGroup(l), [1..n], actionPermutingCompsAsActionOnRange);;
SellOnRange := Image(actionPermutingCompsAsActionOnRangeHom);
Size(SellOnRange) = Factorial(l);
normalizerOfSocle := ClosureGroup(H1OnRange, SellOnRange);
Size(normalizerOfSocle) = Size(H1) ^ l * Factorial(l);
