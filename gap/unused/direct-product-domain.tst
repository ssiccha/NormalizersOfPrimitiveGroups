#@local dpd, dpdAsList, actionPermutingComps, actionPermutingCompsHom, D8OnDpd
#@local S3, onFirstComp, onFirstCompHom, S3OnFirstComp
#@local wreathProductProductAction
#@local bijToRange, onFirstCompAsActionOnRange
#@local actionPermutingCompsAsActionOnRange

# ActionByPermutingComponentsOfDirectProductDomain
gap> dpd := DirectProductDomain(Domain([1..3]), 4);;
gap> dpdAsList := AsList(dpd);;
gap> OnDirectProductDomainPermutingComponents(dpdAsList[2], D8.1);
DirectProductElement( [ 1, 2, 1, 1 ] )
gap> actionPermutingCompsHom :=
>   ActionHomomorphism(D8, dpdAsList,
>                      OnDirectProductDomainPermutingComponents);;
gap> D8OnDpd := Image(actionPermutingCompsHom);;
gap> Size(D8OnDpd);
8
gap> # The action of D8 by permuting the components has 4 fixed points
gap> NrMovedPoints(D8OnDpd);
78

# ActionOnDirectProductDomain
gap> S3 := SymmetricGroup(3);;
gap> onFirstComp := ActionOnDirectProductDomain(OnPoints, 1);;
gap> onFirstCompHom :=
>   ActionHomomorphism(S3, dpdAsList, onFirstComp);;
gap> S3OnFirstComp := Image(onFirstCompHom);;
gap> onFirstComp(dpdAsList[1], S3.1);
DirectProductElement( [ 2, 1, 1, 1 ] )
gap> Size(S3OnFirstComp);
6

# ActionByPermutingComponentsOfDirectProductDomain and
# ActionOnDirectProductDomain should together generate a wreath
# product in product action.
gap> wreathProductProductAction :=
>   Group([D8OnDpd.1, D8OnDpd.2, S3OnFirstComp.1, S3OnFirstComp.2]);;
gap> Size(wreathProductProductAction) = Size(S3) ^ NrMovedPoints(D8) * Size(D8);
true

# ActionOnRangeByActionOnDirectProductDomain
gap> bijToRange := BijectiveMappingFromDirectProductDomainToRange(dpd);;
gap> onFirstCompAsActionOnRange :=
>   ActionOnRangeByActionOnDirectProductDomain(onFirstComp, dpd);;
gap> onFirstCompAsActionOnRange(1, S3.1);
2
gap> PreImage(bijToRange, 1);
DirectProductElement( [ 1, 1, 1, 1 ] )
gap> PreImage(bijToRange, 2);
DirectProductElement( [ 2, 1, 1, 1 ] )
gap> actionPermutingCompsAsActionOnRange :=
>   ActionOnRangeByActionOnDirectProductDomain(
>       OnDirectProductDomainPermutingComponents,
>       dpd
>   );;
gap> actionPermutingCompsAsActionOnRange(2, D8.1);
4
gap> PreImage(bijToRange, 2);
DirectProductElement( [ 2, 1, 1, 1 ] )
gap> PreImage(bijToRange, 4);
DirectProductElement( [ 1, 2, 1, 1 ] )
