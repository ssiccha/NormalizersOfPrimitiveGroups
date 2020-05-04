#@local simples, T, d, WP, m, random, G, N

gap> simples := AllPrimitiveGroups(NrMovedPoints, [5 .. 7], ONanScottType,
>                                  ["2"]);;
gap> simples := Filtered(simples, IsSimpleGroup);;

# TODO compare to built-in method
gap> for T in simples do
>     m := NrMovedPoints(T);
>     Print("T = ", ViewString(T), ", m = ", m, ":\n");
>     for d in [2 .. 4] do
>         WP := WreathProductProductAction(T, Group(SymmetricGroup(d).1));
>         random := Random(SymmetricGroup(m ^ d));
>         G := WP ^ random;
>         N := NormalizerInSymmetricGroupOfPrimitiveGroup(G);
>         Print("d = ", d, ", n = ", m^d, ", \c");
>         Print("|N| = ", PrintString(Size(N)), "\n");
>     od;
>     Print("\n");
> od;
T = A(5), m = 5:
d = 2, n = 25, |N| = 14400
d = 3, n = 125, |N| = 2592000
d = 4, n = 625, |N| = 207360000

T = PSL(2,5), m = 6:
d = 2, n = 36, |N| = 14400
d = 3, n = 216, |N| = 2592000
d = 4, n = 1296, |N| = 207360000

T = A(6), m = 6:
d = 2, n = 36, |N| = 518400
d = 3, n = 216, |N| = 559872000
d = 4, n = 1296, |N| = 268738560000

T = L(3, 2), m = 7:
d = 2, n = 49, |N| = 56448
d = 3, n = 343, |N| = 28449792
d = 4, n = 2401, |N| = 6372753408

T = A(7), m = 7:
d = 2, n = 49, |N| = 25401600
d = 3, n = 343, |N| = 192036096000
d = 4, n = 2401, |N| = 645241282560000

