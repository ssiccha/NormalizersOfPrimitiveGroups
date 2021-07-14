# vi: set ft=gap
# Call: gap-master ../permutation-homomorphisms/read.g product-action.g
#   product-decomposition.g?
gap> T := AlternatingGroup(5);;
gap> S3 := SymmetricGroup(3);;
gap> W := WreathProductProductAction(T, S3);;
gap> random := Random(SymmetricGroup(5 ^ 3));; G := W ^ random;;
gap> r := WeakCanonizerOfPrimitiveGroup(G);;
gap> canonizer := r.conjugatorToWeakCanonicalForm;;
gap> G ^ canonizer = W;
true
gap> random := Random(SymmetricGroup(5 ^ 3));; G := W ^ random;;
gap> r := WeakCanonizerOfPrimitiveGroup(G);;
gap> canonizer := r.conjugatorToWeakCanonicalForm;;
gap> G ^ canonizer = W;
true

gap> T := PSL(2, 5);;
gap> Sd := SymmetricGroup(3);;
gap> WP := WreathProductProductAction(T, Sd);;
gap> m := LargestMovedPoint(T);;
gap> d := LargestMovedPoint(Sd);;
gap> random := Random(SymmetricGroup(m ^ d));; G := WP ^ random;;
gap> tmpCanonize := WeakCanonizerOfPrimitiveGroup(G);;
gap> WCG := G ^ tmpCanonize.conjugatorToWeakCanonicalForm;;
gap> socleComponent := tmpCanonize.socleComponent;;
gap> M := NormalizerOfSocleForWeaklyCanonicalPrimitivePA(LargestMovedPoint(WCG), socleComponent);;
gap> IsSubgroup(M, WCG);
true
gap> IsNormal(M, Socle(WCG));
true
gap> N1 := Normalizer(M, WCG);; time;
12
gap> N2 := Normalizer(SymmetricGroup(m^d), WCG);; time;
2852
gap> N1 = N2;
true


gap> T := PSL(2, 7);;
gap> Sd := SymmetricGroup(4);;
gap> WP := WreathProductProductAction(T, Sd);;
gap> m := LargestMovedPoint(T);;
gap> d := LargestMovedPoint(Sd);;
gap> random := Random(SymmetricGroup(m ^ d));; G := WP ^ random;;
gap> tmpCanonize := WeakCanonizerOfPrimitiveGroup(G);; time;
684
gap> WCG := G ^ tmpCanonize.conjugatorToWeakCanonicalForm;;
gap> socleComponent := tmpCanonize.socleComponent;;
# Needs to compute normalizer of socle component, is this expensive?
gap> M := NormalizerOfSocleForWeaklyCanonicalPrimitivePA(LargestMovedPoint(WCG), socleComponent);;
gap> time;
216
gap> IsSubgroup(M, WCG);
true
gap> IsNormal(M, Socle(WCG));
true
gap> N1 := Normalizer(M, WCG);; time;
228
gap> N2 := Normalizer(SymmetricGroup(m^d), WCG);; time;
439796
gap> N1 = N2;
true


gap> Read("primitive-socle.g");
gap> random := Random(SymmetricGroup(m ^ d));; G := WP ^ random;;
gap> N1 := NormalizerInSymmetricGroupOfPrimitiveGroup(G);; time;
904
gap> random := Random(SymmetricGroup(m ^ d));; G := WP ^ random;;
gap> N1 := NormalizerInSymmetricGroupOfPrimitiveGroup(G);; time;
964
gap> random := Random(SymmetricGroup(m ^ d));; G := WP ^ random;;
gap> N1 := NormalizerInSymmetricGroupOfPrimitiveGroup(G);; time;
