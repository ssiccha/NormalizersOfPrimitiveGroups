gap> grps := AllPrimitiveGroups(NrMovedPoints, [60^2], ONanScottType, ["4b"]);       
[ <permutation group of size 51840000 with 2 generators>, 
  <permutation group of size 51840000 with 2 generators>, 
  <permutation group of size 51840000 with 2 generators>, 
  <permutation group of size 51840000 with 2 generators>, 
  <permutation group of size 103680000 with 2 generators>, 
  <permutation group of size 103680000 with 2 generators>, 
  <permutation group of size 103680000 with 2 generators>, 
  <permutation group of size 103680000 with 2 generators>, 
  <permutation group of size 103680000 with 2 generators>, 
  <permutation group of size 103680000 with 3 generators>, 
  <permutation group of size 103680000 with 2 generators>, 
  <permutation group of size 103680000 with 2 generators>, 
  <permutation group of size 103680000 with 2 generators>, 
  <permutation group of size 207360000 with 2 generators>, 
  <permutation group of size 207360000 with 2 generators>, 
  <permutation group of size 207360000 with 2 generators>, 
  <permutation group of size 207360000 with 3 generators>, 
  <permutation group of size 207360000 with 3 generators>, 
  <permutation group of size 207360000 with 3 generators>, 
  <permutation group of size 414720000 with 3 generators> ]
gap> 60 ^ 4 * 4;
51840000
gap> G := grps[1] ^ Random(SymmetricGroup(60^2));
<permutation group of size 51840000 with 2 generators>
gap> Socle(G); time;
<permutation group with 3 generators>
128
gap> cs := CompositionSeries(Socle(G)); time;
[ <permutation group of size 12960000 with 3 generators>, 
  <permutation group of size 216000 with 6 generators>, 
  <permutation group of size 3600 with 5 generators>, 
  <permutation group of size 60 with 2 generators>, Group(()) ]
68
gap> mnsg := cs[4];
<permutation group of size 60 with 2 generators>
gap> xsetOfSimpleFactors := ConjugacyClassSubgroups(G, R);;
gap> xsetOfSimpleFactors := ConjugacyClassSubgroups(G, mnsg);;
gap> mnsgs := AsList(xsetOfSimpleFactors);
[ <permutation group of size 60 with 2 generators>, 
  <permutation group of size 60 with 2 generators>, 
  <permutation group of size 60 with 2 generators>, 
  <permutation group of size 60 with 2 generators> ]
gap> orbits := List(mnsgs, OrbitsDomain);;
gap> IsSet(orbits[1]);
true
gap> IsSet(orbits[3]);
true
gap> IsSet(orbits[2]);
true
gap> IsSet(orbits[4]);
true
gap> IsSet(orbits[1][1]);
false
gap> orbits := List(orbits, x -> List(x, Set));;
gap> orbits[1] = orbits[2];
false
gap> orbits[1] = orbits[3];
true
gap> orbits[1] = orbits[4];
false
gap> orbits[2] = orbits[4];
