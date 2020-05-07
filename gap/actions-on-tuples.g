# TODO These functions should be in the GAP library!
# TODO: Also use this function in WreathProductProductAction
# To have the same behaviour as before need to handle groups with
# LargestMovedPoint <> Lenght(MovedPoints) differently:
# conjugate them so that MovedPoints = [1 .. LMP].

# n = m ^ d
# We use a map {1, ..., m} ^ d -> {1, .., m ^ d} to identify
# a tuple (a_1, .., a_d) with a number x as follows:
# the tuple is mapped to
#   1 +  sum_{j=0}^{d-1} (a_{d-j} - 1) m ^ j
# Let g \in S_m. Acting with g on the i-th component maps the above number to
#   1 + (sum_{j=0}^{d-1} (a_{d-j} - 1) m ^ j)
#       + ( -(a_i - 1) + (a_i ^ g - 1) ) m ^ {d-i}
PermActionOnIthComponentUnderNaturalProductIdentification :=
        function(g, i, m, d)
    local nrPoints, imgList, power, differences, counter, limit, x, point;
    if not IsPerm(g) then
        ErrorNoReturn("PermActionOnIthComponent",
                      "UnderNaturalProductIdentification: ",
                      "<g> must be a permutation (not ", g, ")");
    elif not ForAll([i, m, d], IsPosInt) then
        ErrorNoReturn("PermActionOnIthComponent",
                      "UnderNaturalProductIdentification: ",
                      "<i>, <m>, and <d> must be positive integers ",
                      "(not ", i, ", ", m, ", and ", d, ")");
    elif i > d then
        ErrorNoReturn("PermActionOnIthComponent",
                      "UnderNaturalProductIdentification: ",
                      "<i> must be less or equal than <d> ",
                      "(but i = ", i, " and d = ", d, ")");
    elif LargestMovedPoint(g) > m then
        ErrorNoReturn("PermActionOnIthComponent",
                      "UnderNaturalProductIdentification: ",
                      "<g> must not act on more than <m> points (but g = ", g,
                      " and m = ", m, ")");
    fi;
    if g = () then
        return ();
    fi;
    nrPoints := m ^ d;
    imgList := ListWithIdenticalEntries(nrPoints, 0);
    power := m ^ (d - i);
    differences := List([1 .. m], x -> (x ^ g - x) * power);
    # Each m ^ (d-i) points increase the i-th component of the tuple
    # (a_1, .., a_d);
    counter := 1;
    limit := m ^ (d - i);
    x := 1;
    for point in [1 .. nrPoints] do
        imgList[point] := point + differences[x];
        if counter < limit then
            counter := counter + 1;
        else
            counter := 1;
            if x < m then
                x := x + 1;
            else
                x := 1;
            fi;
        fi;
    od;
    return PermList(imgList);
end;

# For an explanation of the natural product identification see
# PermActionOnIthComponentUnderNaturalProductIdentification
PermPermutingComponentsUnderNaturalProductIdentification := function(g, m, d)
    local nrPoints, imgList, iteratorTuples, tuple, imgTuple, imgPoint, point,
        i;
    if not IsPerm(g) then
        ErrorNoReturn("PermPermutingComponents",
                      "UnderNaturalProductIdentification: ",
                      "<g> must be a permutation (not ", g, ")");
    elif not ForAll([m, d], IsPosInt) then
        ErrorNoReturn("PermPermutingComponents",
                      "UnderNaturalProductIdentification: ",
                      "<m> and <d> must be positive integers ",
                      "(not ", m, " and ", d, ")");
    elif LargestMovedPoint(g) > d then
        ErrorNoReturn("PermPermutingComponents",
                      "UnderNaturalProductIdentification: ",
                      "<g> must not act on more than <d> points (but g = ", g,
                      " and d = ", d, ")");
    fi;
    if g = () then
        return ();
    fi;
    nrPoints := m ^ d;
    imgList := ListWithIdenticalEntries(nrPoints, 0);
    iteratorTuples := IteratorOfTuples([1 .. m], d);
    for point in [1 .. nrPoints] do
        tuple := NextIterator(iteratorTuples);
        imgTuple := Permuted(tuple, g);
        imgPoint := 0;
        for i in [1 .. d] do
            imgPoint := imgPoint * m + imgTuple[i] - 1;
        od;
        imgPoint := imgPoint + 1;
        imgList[point] := imgPoint;
    od;
    return PermList(imgList);
end;

NaturalProductIdentificationNumberToTupleNC := function(x, m, d)
    local tuple, rem, i;
    tuple := ListWithIdenticalEntries(d, 0);
    # Correction since lists don't start at 0.
    x := x - 1;
    rem := RemInt(x, m);
    tuple[d] := rem + 1;
    for i in [d - 1 , d - 2 .. 1] do
        x := (x - rem) / m;
        rem := RemInt(x, m);
        tuple[i] := rem + 1;
    od;
    return tuple;
end;

NaturalProductIdentificationNumberToTuple := function(x, m, d)
    if not ForAll([x, m, d], IsPosInt) then
        ErrorNoReturn("NaturalProductIdentificationNumberToTuple: ",
                      "<x>, <m>, and <d> must be positive integers ",
                      "(not ", x, ", ", m, ", and ", d, ")");
    fi;
    return NaturalProductIdentificationNumberToTupleNC(x, m, d);
end;

NaturalProductIdentificationTupleToNumberNC := function(tuple, m, d)
    local x, i;
    x := 0;
    for i in [1 .. d] do
        x := x * m + tuple[i] - 1;
    od;
    x := x + 1;
    return x;
end;

NaturalProductIdentificationTupleToNumber := function(tuple, m, d)
    if not IsDenseList(tuple) then
        ErrorNoReturn("NaturalProductIdentificationTupleToNumber: ",
                      "<tuple> must be a dense list of integers (not ", tuple,
                      ")");
    elif not ForAll([m, d], IsPosInt) then
        ErrorNoReturn("NaturalProductIdentificationTupleToNumber: ",
                      "<m> and <d> must be positive integers ",
                      "(not ", m, " and ", d, ")");
    fi;
    return NaturalProductIdentificationTupleToNumberNC(tuple, m, d);
end;

# TODO provide analoga of the
# NaturalProductIdentificationNumberToTuple
# functions?
# TODO put into documentation
# n = m * d
# We use a map {1, ..., m} \times {1, ..., d} -> {1, .., m * d} to identify
# a tuple (x,y) with a number as follows:
# (x,y) is mapped to
#   x + m (y - 1)
# Let g \in S_m. Acting with g on the i-th copy of {1, .., m} maps the above
# number to
#   x + m (y - 1) + (x ^ g - x),        if y = i
#   x + m (y - 1),                      if y != i
# Let g \in S_d. Acting with g maps the above number to
#   x + m (y - 1) + m (y ^ g - y)
#
# These functions are called "..CoproductIdentification" because
# the imprimitive action acts on the iterated coproduct of a domain Delta
# (a coproduct of sets is their disjoint union).
# Compare: the product action acts on the iterated product of a domain Delta.
PermActionOnIthCopyUnderNaturalCoproductIdentification :=
        function(g, i, m, d)
    local domList, imgList, k;
    if not IsPerm(g) then
        ErrorNoReturn("PermActionOnIthCopy",
                      "UnderNaturalCoproductIdentification: ",
                      "<g> must be a permutation (not ", g, ")");
    elif not ForAll([i, m, d], IsPosInt) then
        ErrorNoReturn("PermActionOnIthCopy",
                      "UnderNaturalCoproductIdentification: ",
                      "<i>, <m>, and <d> must be positive integers ",
                      "(not ", i, ", ", m, ", and ", d, ")");
    elif i > d then
        ErrorNoReturn("PermActionOnIthCopy",
                      "UnderNaturalCoproductIdentification: ",
                      "<i> must be less or equal than <d> ",
                      "(but i = ", i, " and d = ", d, ")");
    elif LargestMovedPoint(g) > m then
        ErrorNoReturn("PermActionOnIthCopy",
                      "UnderNaturalCoproductIdentification: ",
                      "<g> must not act on more than <m> points (but g = ", g,
                      " and m = ", m, ")");
    fi;
    if g = () then
        return ();
    fi;
    if i = 1 then
        domList := [1 .. m];
    else
        domList := List([1 .. m], k -> k + m * (i - 1));
    fi;
    imgList := ListWithIdenticalEntries(m, 0);
    for k in [1 .. m] do
        imgList[k] := k ^ g + m * (i - 1);
    od;
    return MappingPermListList(domList, imgList);
end;

# For an explanation of the used identification see
# PermActionOnIthComponentUnderNaturalProductIdentification
PermActionAsTopGroupUnderNaturalCoproductIdentification :=
        function(g, m, d)
    local imgList, iterator, newJ, j, i;
    if not IsPerm(g) then
        ErrorNoReturn("PermActionAsTopGroup",
                      "UnderNaturalCoproductIdentification: ",
                      "<g> must be a permutation (not ", g, ")");
    elif not ForAll([m, d], IsPosInt) then
        ErrorNoReturn("PermActionAsTopGroup",
                      "UnderNaturalCoproductIdentification: ",
                      "<m> and <d> must be positive integers ",
                      "(not ", m, " and ", d, ")");
    elif LargestMovedPoint(g) > d then
        ErrorNoReturn("PermActionAsTopGroup",
                      "UnderNaturalCoproductIdentification: ",
                      "<g> must not act on more than <d> points (but g = ", g,
                      " and d = ", d, ")");
    fi;
    if g = () then
        return ();
    fi;
    imgList := ListWithIdenticalEntries(m, 0);
    iterator := 0;
    for j in [1 .. d] do
        newJ := m * (j ^ g - 1);
        for i in [1 .. m] do
            iterator := iterator + 1;
            # invariant: iterator = i + m (j - 1);
            imgList[iterator] := i + newJ;
        od;
    od;
    return PermList(imgList);
end;

# TODO use this?
#CheckActionUnderNaturalProductOrCoproductIdentificationArguments :=
#    function(functionName, g, m, d)
#end;
