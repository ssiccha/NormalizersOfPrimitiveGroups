gap> res := NormalizerOfSocleForWeaklyCanonicalPrimitiveSD(60^3, AlternatingGroup(5));;
gap> WeirdSd := Group(res.gensFullTopGroup);;
gap> Size(WeirdSd); Factorial(4);
24
24
gap> transpo := WeirdSd.3;;
gap> LiftTRightRegular := Group(res.gensLiftTRightRegular);;
gap> Size(LiftTRightRegular);
60
gap> DiagonalTLeftRegular := Group(res.gensDiagonalTLeftRegular);; Size(last);
60
gap> LiftTRightRegular ^ transpo = DiagonalTLeftRegular;
true


# A more compact test
gap> result := NormalizerOfSocleForWeaklyCanonicalPrimitiveSD(60^3, AlternatingGroup(5));
gap> normalizerOfSocle := Group(GeneratorsOfGroup(result.normalizerOfSocle));
gap> Size(normalizerOfSocle) = Size(result.normalizerOfSocle);
