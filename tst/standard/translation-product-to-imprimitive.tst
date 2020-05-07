# Note that the "with-assert" version of teststandard tests whether phi is
# well-defined and bijective
gap> T := AlternatingGroup(5);;
gap> S3 := SymmetricGroup(3);;
gap> W := WreathProductProductAction(T, S3);;
gap> M := NormalizerOfSocleForWeaklyCanonicalPrimitivePA(W, T);;
gap> phi := IsomorphismProductActionToImprimitiveWreathProduct(M);;
