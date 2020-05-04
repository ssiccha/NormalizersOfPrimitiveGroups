GET_REAL_TIME_OF_FUNCTION_CALL := function ( method, args, options... )
    local first_time, firstSeconds, firstMicroSeconds, result, second_time,
        secondSeconds, secondMicroSeconds, seconds, microSeconds, total;

    if options = [] then
        options := rec();
    else
        options := options[1];
    fi;
    if not IsBound( options.passResult ) then
        options.passResult := false;
    fi;

    first_time := IO_gettimeofday(    );
    firstSeconds := first_time.tv_sec;
    firstMicroSeconds := first_time.tv_usec;

    result := CallFuncList( method, args );

    second_time := IO_gettimeofday(    );
    secondSeconds := second_time.tv_sec;
    secondMicroSeconds := second_time.tv_usec;

    seconds := (secondSeconds - firstSeconds);
    microSeconds := secondMicroSeconds - firstMicroSeconds;
    total := seconds * 10^6 + microSeconds;
    return rec( result := result, time := total );
end;

simples := AllPrimitiveGroups(NrMovedPoints, [5 .. 20], ONanScottType, ["2"]);
simples := Filtered(simples, IsSimpleGroup);

times := [];
degrees := [];
socleNames := [];
for T in simples do
    for d in [2 .. 4] do
        WP := WreathProductProductAction(T, Group(SymmetricGroup(d).1));
        m := NrMovedPoints(T);
        random := Random(SymmetricGroup(m ^ d));
        G := WP ^ random;
        milliseconds := Int(GET_REAL_TIME_OF_FUNCTION_CALL(
            NormalizerInSymmetricGroupOfPrimitiveGroup,
            [G]
        ).time / 1000.);
        Add(times, milliseconds);
        Print(m, " ^ ", d, " = ", m^d, ", \c");
        Add(degrees, m ^ d);
        Add(socleNames, Concatenation(ViewString(T), " ^ ", PrintString(d)));
    od;
od;
Print(times, "\n");
Print(socleNames, "\n");
Print(degrees, "\n");


# GAP built in method
simples := AllPrimitiveGroups(NrMovedPoints, [5 .. 8], ONanScottType, ["2"]);
simples := Filtered(simples, IsSimpleGroup);

times := [];
degrees := [];
socleNames := [];
for T in simples do
    for d in [4 .. 4] do
        WP := WreathProductProductAction(T, Group(SymmetricGroup(d).1));
        m := NrMovedPoints(T);
        random := Random(SymmetricGroup(m ^ d));
        G := WP ^ random;
        milliseconds := Int(GET_REAL_TIME_OF_FUNCTION_CALL(
            Normalizer,
            [SymmetricGroup(m ^ d), G]
        ).time / 1000.);
        Add(times, milliseconds);
        Print(m, " ^ ", d, " = ", m^d, " in ");
        Print(milliseconds, "ms, \c");
        Add(degrees, m ^ d);
        Add(socleNames, Concatenation(ViewString(T), " ^ ", PrintString(d)));
    od;
od;
Print(times, "\n");
Print(socleNames, "\n");
Print(degrees, "\n");
