# The GAP package NormalizersOfPrimitiveGroups

`NormalizersOfPrimitiveGroups` is a [GAP](https://www.gap-system.org/) package
to compute normalizers of primitive groups.

You can use it as follows:

1. Download `NormalizersOfPrimitiveGroups` and extract it into a GAP `pkg`
   directory.

2. Start GAP and load the `NormalizersOfPrimitiveGroups` package:

    LoadPackage("NormalizersOfPrimitiveGroups");

3. You can use the function `NormalizerInSymmetricGroupOfPrimitiveGroup` to
   compute the normalizer of a primitive group inside the symmetric group on
   the same number of points.

4. You can use the function `WeakCanonizerOfPrimitiveGroup` to compute a
   permutation which conjugates a given primitive group into weak canonical
   form and the corresponding socle-component.

Note: `NormalizerInSymmetricGroupOfPrimitiveGroup` and
`WeakCanonizerOfPrimitiveGroup` are currently **only** implemented for groups
of type PA.

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
gap> WP := WreathProductProductAction(T, Group(SymmetricGroup(d).1));;
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

## Documentation

Run the `makedoc.g` script to build the documentation.

Note: It is currently not possible to build the documentation due to
incompatibilities between AutoDoc and the current GAP master branch.

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