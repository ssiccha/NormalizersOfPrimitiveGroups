# TODO also test the corner cases as with e.g.
# PermActionOnIthComponentUnderNaturalProductIdentification
# PermActionOnIthCopyUnderNaturalCoproductIdentification
gap> PermActionOnIthCopyUnderNaturalCoproductIdentification((1,2,3), 1, 3, 2);
(1,2,3)
gap> PermActionOnIthCopyUnderNaturalCoproductIdentification((1,2,3), 1, 3, 3);
(1,2,3)
gap> PermActionOnIthCopyUnderNaturalCoproductIdentification((1,2,3), 1, 4, 3);
(1,2,3)
gap> PermActionOnIthCopyUnderNaturalCoproductIdentification((1,2,3), 2, 4, 3);
(5,6,7)
gap> PermActionOnIthCopyUnderNaturalCoproductIdentification((1,2,3), 2, 3, 3);
(4,5,6)

# PermActionAsTopGroupUnderNaturalCoproductIdentification
gap> PermActionAsTopGroupUnderNaturalCoproductIdentification((1,2,3), 2, 3);
(1,3,5)(2,4,6)
gap> PermActionAsTopGroupUnderNaturalCoproductIdentification((1,2), 3, 2);
(1,4)(2,5)(3,6)
gap> PermActionAsTopGroupUnderNaturalCoproductIdentification((1,2,3), 3, 3);
(1,4,7)(2,5,8)(3,6,9)
