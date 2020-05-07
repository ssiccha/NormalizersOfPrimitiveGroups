# total time:
# 19364 + 40584 + 104 + 1040 + 4 + 2564 + 40 + 3548
# = 67248
# only 40ms for the actual normalizer computation!
# 5 ^ 7 = 78125 points
gap> T := AlternatingGroup(5);;
gap> Sd := SymmetricGroup(7);;
gap> WP := WreathProductProductAction(T, Sd);; time;
472
gap> G := WP;;
gap> Socle(G);; time;
19364
# 20 of the 40s were used to turn the product decomposition into a conjugator
gap> tmp := WeakCanonizerOfPrimitiveGroup(G);; time;
40584
gap> wcfG := G ^ tmp.conjugatorToWeakCanonicalForm;; time;
104
gap> socleComponent := tmp.socleComponent;; time;
0
gap> M := NormalizerOfSocleForWeaklyCanonicalPrimitivePA(wcfG, socleComponent);; time;
1040
gap> iso := IsomorphismProductActionToImprimitiveWreathProduct(M);; time;
4
gap> imprimitiveM := Image(iso, M);; time;
0
gap> imprimitiveWcfG := Image(iso, wcfG);; time;
2564
gap> imprimitiveWcfN := Normalizer(imprimitiveM, imprimitiveWcfG);; time;
40
gap> wcfN := PreImage(iso, imprimitiveWcfN);; time;
3548
gap> N := wcfN ^ (tmp.conjugatorToWeakCanonicalForm ^ -1);; time;
0


# total time:
# 41208 + 56740 + 160 + 2432 + 6468 + 60 + 6328
# = 113369
# only 60ms for the actual normalizer computation!
gap> T := AlternatingGroup(7);;
gap> Sd := SymmetricGroup(6);;
gap> WP := WreathProductProductAction(T, Sd);; time;
612
gap> G := WP;;
gap> Socle(G);; time;
41208
# ? of the 57s were used to turn the product decomposition into a conjugator
gap> tmp := WeakCanonizerOfPrimitiveGroup(G);; time;
56740
gap> wcfG := G ^ tmp.conjugatorToWeakCanonicalForm;; time;
160
gap> socleComponent := tmp.socleComponent;; time;
0
gap> M := NormalizerOfSocleForWeaklyCanonicalPrimitivePA(wcfG, socleComponent);; time;
2432
gap> iso := IsomorphismProductActionToImprimitiveWreathProduct(M);; time;
4
gap> imprimitiveM := Image(iso, M);; time;
0
gap> imprimitiveWcfG := Image(iso, wcfG);; time;
6468
gap> imprimitiveWcfN := Normalizer(imprimitiveM, imprimitiveWcfG);; time;
60
gap> wcfN := PreImage(iso, imprimitiveWcfN);; time;
6328
gap> N := wcfN ^ (tmp.conjugatorToWeakCanonicalForm ^ -1);; time;
4
