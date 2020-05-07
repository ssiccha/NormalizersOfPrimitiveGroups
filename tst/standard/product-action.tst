#@local tups1, tups2, tups3

# Action on I-th Component
# Corner cases and errors
gap> PermActionOnIthComponentUnderNaturalProductIdentification(1, 1, 2, 2);
Error, PermActionOnIthComponentUnderNaturalProductIdentification: <g> must be \
a permutation (not 1)
gap> PermActionOnIthComponentUnderNaturalProductIdentification((), 0, 2, 2);
Error, PermActionOnIthComponentUnderNaturalProductIdentification: <i>, <m>, an\
d <d> must be positive integers (not 0, 2, and 2)
gap> PermActionOnIthComponentUnderNaturalProductIdentification((1,3), 1, 2, 2);
Error, PermActionOnIthComponentUnderNaturalProductIdentification: <g> must not\
 act on more than <m> points (but g = (1,3) and m = 2)
gap> PermActionOnIthComponentUnderNaturalProductIdentification((1,2), 3, 2, 2);
Error, PermActionOnIthComponentUnderNaturalProductIdentification: <i> must be \
less or equal than <d> (but i = 3 and d = 2)

# Non-trivial tests
gap> PermActionOnIthComponentUnderNaturalProductIdentification((1,2), 1, 2, 2);
(1,3)(2,4)
gap> PermActionOnIthComponentUnderNaturalProductIdentification((1,2), 2, 2, 2);
(1,2)(3,4)
gap> PermActionOnIthComponentUnderNaturalProductIdentification((1,2), 3, 2, 3);
(1,2)(3,4)(5,6)(7,8)
gap> PermActionOnIthComponentUnderNaturalProductIdentification((1,2,3), 2, 3, 2);
(1,2,3)(4,5,6)(7,8,9)
gap> PermActionOnIthComponentUnderNaturalProductIdentification((1,2)(3,4), 2, 4, 2);
(1,2)(3,4)(5,6)(7,8)(9,10)(11,12)(13,14)(15,16)
gap> PermActionOnIthComponentUnderNaturalProductIdentification((1,2), 3, 3, 3);
(1,2)(4,5)(7,8)(10,11)(13,14)(16,17)(19,20)(22,23)(25,26)

# Permuting Components
# Corner cases and errors
gap> PermPermutingComponentsUnderNaturalProductIdentification(1, 2, 1);
Error, PermPermutingComponentsUnderNaturalProductIdentification: <g> must be a\
 permutation (not 1)
gap> PermPermutingComponentsUnderNaturalProductIdentification((), 0, 1);
Error, PermPermutingComponentsUnderNaturalProductIdentification: <m> and <d> m\
ust be positive integers (not 0 and 1)
gap> PermPermutingComponentsUnderNaturalProductIdentification((1,3), 2, 1);
Error, PermPermutingComponentsUnderNaturalProductIdentification: <g> must not \
act on more than <d> points (but g = (1,3) and d = 1)
gap> PermPermutingComponentsUnderNaturalProductIdentification((), 2, 3);
()
gap> PermPermutingComponentsUnderNaturalProductIdentification((1,2,3), 1, 3);
()

# Non-trivial tests
gap> PermPermutingComponentsUnderNaturalProductIdentification((1,2), 2, 2);
(2,3)
gap> PermPermutingComponentsUnderNaturalProductIdentification((1,2), 2, 3);
(3,5)(4,6)
gap> PermPermutingComponentsUnderNaturalProductIdentification((1,3), 2, 3);
(2,5)(4,7)
gap> PermPermutingComponentsUnderNaturalProductIdentification((1,2), 3, 2);
(2,4)(3,7)(6,8)
gap> PermPermutingComponentsUnderNaturalProductIdentification((1,2,3), 3, 3);
(2,10,4)(3,19,7)(5,11,13)(6,20,16)(8,12,22)(9,21,25)(15,23,17)(18,24,26)

# NaturalProductIdentification functions
# NaturalProductIdentificationNumberToTuple
# Corner cases and errors
gap> NaturalProductIdentificationNumberToTuple(0, 1, 1);
Error, NaturalProductIdentificationNumberToTuple: <x>, <m>, and <d> must be po\
sitive integers (not 0, 1, and 1)

# Non-trivial tests
gap> tups1 := Tuples([1,2,3], 1);;
gap> tups2 := Tuples([1], 3);;
gap> tups3 := Tuples([1,2,3], 2);;
gap> tups1 =
> List([1..3], x -> NaturalProductIdentificationNumberToTuple(x, 3, 1));
true
gap> tups2 =
> List([1], x -> NaturalProductIdentificationNumberToTuple(x, 1, 3));
true
gap> tups3 =
> List([1..9], x -> NaturalProductIdentificationNumberToTuple(x, 3, 2));
true

# NaturalProductIdentificationTupleToNumber
# Corner cases and errors
gap> NaturalProductIdentificationTupleToNumber(0, 1, 1);
Error, NaturalProductIdentificationTupleToNumber: <tuple> must be a dense list\
 of integers (not 0)
gap> NaturalProductIdentificationTupleToNumber([1, 1], 0, 1);
Error, NaturalProductIdentificationTupleToNumber: <m> and <d> must be positive\
 integers (not 0 and 1)

# Non-trivial tests
gap> [1 .. 3] =
> List(tups1, tup -> NaturalProductIdentificationTupleToNumber(tup, 3, 1));
true
gap> [1 .. 1] =
> List(tups2, tup -> NaturalProductIdentificationTupleToNumber(tup, 1, 3));
true
gap> [1 .. 9] =
> List(tups3, tup -> NaturalProductIdentificationTupleToNumber(tup, 3, 2));
true
