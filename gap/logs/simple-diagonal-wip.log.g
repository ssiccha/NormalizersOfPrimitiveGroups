A6 := AlternatingGroup(6);
A6right := Image(RegularActionHomomorphism(A6));
A6left := Image(ActionHomomorphism(A6right, A6right,
                                   OnLeftInverse, "surjective"));
gensA6right := GeneratorsOfGroup(A6right);;

# Find conjugator of ConjugatorAutomorphism
g := PseudoRandom(A6right);;
ranAuto := GroupHomomorphismByImages(A6right, A6right, gensA6right,
        List(gensA6right, x -> x ^ g));;
HasConjugatorOfConjugatorIsomorphism(ranAuto);
g = ConjugatorOfConjugatorIsomorphism(ranAuto);


# Construct copies of A6 acting on 360 ^ 2 points
dpd := DirectProductDomain(Domain([1 .. 360]), 2);
A6right1 := Image(ActionHomomorphism(A6right, dpd,
    ActionOnDirectProductDomain(OnPoints, 1, 2)));
A6right2 := Image(ActionHomomorphism(A6right, dpd,
    ActionOnDirectProductDomain(OnPoints, 2, 2)));
A6left1 := Image(ActionHomomorphism(A6left, dpd,
    ActionOnDirectProductDomain(OnPoints, 1, 2)));
A6left2 := Image(ActionHomomorphism(A6left, dpd,
    ActionOnDirectProductDomain(OnPoints, 2, 2)));
A6left12 := ClosureGroup(A6left1, A6left2);
diagonalA6left := Image(ActionHomomorphism(A6left, dpd,
    ActionOnDirectProductDomain([OnPoints, OnPoints])));

ForAll([A6right1, A6right2, A6left1, A6left2], grp -> Size(grp) = 360);
# takes roughly 20s
ForAll(List(Combinations([A6right1, A6right2, A6left1, A6left2], 2),
    x -> ClosureGroup(x[1], x[2])), grp -> Size(grp) = 360 ^ 2);
fourA6es := Group(Concatenation(List([A6right1, A6right2, A6left1, A6left2],
                                     GeneratorsOfGroup)));
Size(fourA6es) = 360 ^ 4;

# Projections
veeSoc := ClosureGroup(A6right1, A6right2);
soc := ClosureGroup(veeSoc, diagonalA6left);
Size(soc) = 360 ^ 3;
myDelta := OrbitsDomain(A6right2, [1 .. 360 ^ 2]);;
Q1 := MappingByPreImages(Domain([1 .. 360 ^ 2]), myDelta);
projectedAction1 := PushforwardActionByPointMap(Q1);
phi1 := ActionHomomorphism(soc, AsList(Range(Q1)), projectedAction1);
Image(phi1, veeSoc) = A6right;
transposition := Permutation((1,2), dpd,
                             OnDirectProductDomainPermutingComponents);;
Order(transposition) = 2;
# Note that Range(R) must need to be identical to Source(Q1), otherwise
# Q1 \circ R will not know that it is a mapping!
R := MappingByPermutation(Source(Q1), Source(Q1), transposition);
Q2 := CompositionMapping(Q1, R);
projectedAction2 := PushforwardActionByPointMap(Q2);
phi2 := ActionHomomorphism(soc, AsList(Range(Q2)), projectedAction2);
Image(phi2, veeSoc) = A6right;
Image(phi1, diagonalA6left) = A6left;
Image(phi2, diagonalA6left) = A6left;

# Perturb diagonalA6left
# Choose this one to be e.g. conjugation with diagonalA6left.1 and
# diagonalA6left.2 in the first and second component, respectively.
# In an example we can than explicitly reconstruct this "perturbation".
ran := PseudoRandom(A6left12);;
conjSoc := soc ^ ran;
conjDiagonalA6left := diagonalA6left ^ ran;
conjDiagonalA6left = diagonalA6left;
conjPhi1 := ActionHomomorphism(conjSoc, AsList(Range(Q1)), projectedAction1);
conjPhi2 := ActionHomomorphism(conjSoc, AsList(Range(Q2)), projectedAction2);
Image(conjPhi1, veeSoc ^ ran) = A6right;
Image(conjPhi2, veeSoc ^ ran) = A6right;
Image(conjPhi1, conjDiagonalA6left) = A6left;
Image(conjPhi2, conjDiagonalA6left) = A6left;

# This takes roughly 50s
# It could be instantaneous though since transposition normalizes soc.
# TODO turn this into an issue!
# Normalizer(ClosureGroup(soc, transposition), soc);

# Reconstruct diagonal from perturbed
# What is quicker? Do the "phi maps H_alpha to H_beta" once with H = soc G or
# for several H_i but with H_i = TC being onec component of soc G.
gensConjDiagonal := GeneratorsOfGroup(conjDiagonalA6left);;
projectionsGensCD := List([conjPhi1, conjPhi2],
                          p -> List(gensConjDiagonal, g -> Image(p, g)));;
projectionsGensCD[1][1] in A6left;
sigma1 := IdentityMapping(A6left);;
sigma2 := GroupHomomorphismByImages(A6left, A6left, projectionsGensCD[1],
                                    projectionsGensCD[2]);;
Q := DirectProductMapping([Q1, Q2]);

# diagonalize a single element
actionFirstComp := ActionOnDirectProductDomain(OnPoints, 1, 2);
actionSecondComp := ActionOnDirectProductDomain(OnPoints, 2, 2);
c1 := conjDiagonalA6left.1;;
d1 := Permutation(Image(conjPhi1, c1), dpd, actionFirstComp);;
d2 := Permutation(PreImage(sigma2, Image(conjPhi2, c1)), dpd, actionSecondComp);;
d := d1 * d2;;
d in diagonalA6left;

TL := ClosureGroup(A6right, A6left);;
gensT := GeneratorsOfGroup(A6right);;
gensL := GeneratorsOfGroup(A6left);;
gensTL := Concatenation(gensT, gensL);;
tau1 := GroupHomomorphismByImages(TL, TL, gensTL, Concatenation(gensT, List(gensL, x -> Image(sigma1, x))));;
tau1 = IdentityMapping(TL);
tau2 := GroupHomomorphismByImages(TL, TL, gensTL, Concatenation(gensT, List(gensL, x -> Image(sigma2, x))));;
t2 := ConjugatorOfConjugatorIsomorphism(tau2);;
t := Permutation(t2, dpd, ActionOnDirectProductDomain(OnPoints, 2, 2));;
t in A6left12;
diagonalA6left ^ t = conjDiagonalA6left;

# Reconstruct perturbation
# PushforwardActionByPointMap is "adjoint" to ActionOnDirectProductDomain
ran1 := Permutation(ran, [1..360], PushforwardActionByPointMap(Q1));;
ran2 := Permutation(ran, [1..360], PushforwardActionByPointMap(Q2));;
ran1onO := Permutation(ran1, dpd, ActionOnDirectProductDomain(OnPoints, 1, 2));;
ran2onO := Permutation(ran2, dpd, ActionOnDirectProductDomain(OnPoints, 2, 2));;
ran = ran1onO * ran2onO;
t = Permutation(ran1 ^ -1 * ran2, dpd, ActionOnDirectProductDomain(OnPoints, 2, 2));

# Construct the top group of T_1 \wr S_{\ell - 1}
topElm := Permutation((1,2), dpd, OnDirectProductDomainPermutingComponents);;
diagonalA6left ^ topElm = diagonalA6left;
soc ^ topElm = soc;

# Construct Aut(T) acting diagonally on the socle
# Only if Out(T) is non-trivial.
autGroup := AutomorphismGroup(A6right);;
leftActionHom := ActionHomomorphism(A6right, A6right, OnLeftInverse, "surjective");;
translateAutRightToAutLeft := x -> CompositionMapping(leftActionHom, x, InverseGeneralMapping(leftActionHom));

# first some sanity checks
inn := autGroup.1;;
innInd := ConjugatorOfConjugatorIsomorphism(translateAutRightToAutLeft(inn));;
innInd in A6left;
Image(leftActionHom, ConjugatorOfConjugatorIsomorphism(inn)) = innInd;

outGens := Filtered(GeneratorsOfGroup(autGroup), x -> not IsInnerAutomorphism(x));;
out := outGens[1];;
outDiag := GroupHomomorphismByImages(TL, TL, gensTL, Concatenation(List(gensT, x -> Image(out, x)), List(gensL, x -> Image(translateAutRightToAutLeft(out), x))));;
outDiagPerm := ConjugatorOfConjugatorIsomorphism(outDiag);;
actionOnDPD := ActionOnDirectProductDomain([OnPoints, OnPoints]);;
outDiagPermOnDPD := Permutation(outDiagPerm, dpd, actionOnDPD);;
soc ^ outDiagPermOnDPD = soc;
diagonalA6left ^ outDiagPermOnDPD = diagonalA6left;


# Efficiency of using DPDs for action calcs
# Improve `PositionCanonical`
S3 := SymmetricGroup(3);
S3right := Image(RegularActionHomomorphism(S3));
dpd := DirectProductDomain(Domain([1 .. 6]), 4);
onPointsFourFold := ActionOnDirectProductDomain(List([1..4], x -> OnPoints));
LoadPackage("profil");
LineByLineProfileFunction(ActionHomomorphism, [S3right, dpd, onPointsFourFold]);
phi := ActionHomomorphism(S3right, dpd, onPointsFourFold);
LineByLineProfileFunction(Image, [phi]);
