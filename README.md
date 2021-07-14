# The GAP package NormalizersOfPrimitiveGroups

`NormalizersOfPrimitiveGroups` is a [GAP](https://www.gap-system.org/) package
to compute normalizers of primitive groups.

## Example

The following is an example session using this package to compute for a
primitive group of type PA:
- the weak canonical form
- the normalizer in the ambient symmetric group

```
gap> LoadPackage("NormalizersOfPrimitiveGroups");;
# Construct a primitive group of type PA via the function
# WreathProductProductAction
gap> T := AlternatingGroup(5);;
gap> m := NrMovedPoints(T);;
gap> d := 2;;
gap> top := Group((1,2));
gap> WP := WreathProductProductAction(T, top);;
# Conjugate this group with a random permutation
gap> random := Random(SymmetricGroup(m ^ d));;
gap> G := WP ^ random;;
# Notice how WeakCanonizerOfPrimitiveGroup transforms the conjugate back into a
# product action wreath product.
# We omit the explicit permutation and group
gap> r := WeakCanonizerOfPrimitiveGroup(G);
rec(
    conjugatorToWeakCanonicalForm := ...,
    socleComponent := ...
 )
gap> GeneratorsOfGroup(G ^ r.conjugatorToWeakCanonicalForm);
[ (1,5,2,4,3)(6,10,7,9,8)(11,15,12,14,13)(16,20,17,19,18)(21,25,22,24,23),
  (1,6,11,16,21)(2,7,12,17,22)(3,8,13,18,23)(4,9,14,19,24)(5,10,15,20,25),
  (1,5,2)(6,10,7)(11,15,12)(16,20,17)(21,25,22),
  (1,6,11)(2,7,12)(3,8,13)(4,9,14)(5,10,15),
  (2,11)(3,21)(4,16)(5,6)(7,15)(8,25)(9,20)(13,22)(14,17)(18,24) ]
# Compute the normalizer with our algorithm and compare it to the built-in
# method
gap> N := NormalizerInSymmetricGroupOfPrimitiveGroup(G);;
gap> N = Normalizer(SymmetricGroup(25), G);
true
```

## Generating more examples
If you want more examples of PA type try the following code.
This does not generate all PA type groups with a given socle though, since
subgroups of those groups can still be primitive.
```
gap> m := 5;;
gap> d := 3;;
gap> T := OnePrimitiveGroup(NrMovedPoints, m, ONanScottType, "2");;
gap> top := OneTransitiveGroup(NrMovedPoints, d);;
gap> WP := WreathProductProductAction(T, top);;
```

## Documentation

Run the `makedoc.g` script to build the documentation.

Note: It is currently not possible to build the documentation due to
incompatibilities between AutoDoc and the current GAP master branch.

## Tests

For the package tests run any of the files
`tst/teststandard.g`
`tst/teststandard-with-asserts.g`
`tst/testall.g`
with the current master branch of GAP.

## Contact

Please submit bug reports, suggestions for improvements and patches via the
[issue tracker](https://github.com/ssiccha/NormalizersOfPrimitiveGroups/issues)
or via email to
[Sergio Siccha](mailto:sergio@mathb.rwth-aachen.de).

## License

`NormalizersOfPrimitiveGroups` is free software you can redistribute it and/or
modify it under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 2 of the License, or (at your option)
any later version. For details, see the file `LICENSE` distributed as part of
this package or see the FSF's own site.
