# TODO
# This file is currently unused! It uses IsDirectProductDomain objects which,
# in their current iteration, are very inefficient. An implementation of
# IsDirectProductDomain objects can be found in the repo `ssiccha/gap` branch
# `add-DirectProductMapping`:
# https://github.com/ssiccha/gap/tree/ss/add-DirectProductMapping

# Declaration part:
DeclareGlobalName("OnDirectProductDomainPermutingComponents");
# TODO: split [action, int] case to ActionOnComponentOfDirectProductDomain.
# TODO: add new case [action, int] with int-fold product action of `action`,
#       short hand for [action, action, action, ...].
DeclareOperation("ActionOnDirectProductDomain",
                 [IsDenseList]);
DeclareGlobalName("ActionOnRangeByActionOnDirectProductDomain");

# Implementation part:
# The components of the DirectProductDomain must be equal, of equal size is not
# sufficient.
BindGlobal("OnDirectProductDomainPermutingComponents",
function(pnt, g)
    if not IsDirectProductElement(pnt) then
        ErrorNoReturn("<pnt> must be an IsDirectProductElement object");
    fi;
    return DirectProductElementNC(FamilyObj(pnt), Permuted(AsList(pnt), g));
end);

InstallMethod(ActionOnDirectProductDomain,
"for a dense list (of actions)",
[IsDenseList],
function(actions)
    local lengthActions;
    if not ForAll(actions, IsFunction) then
        ErrorNoReturn("<actions> must be a dense list of actions");
    fi;
    lengthActions := Length(actions);
    return function(pnt, g)
        local tup, i;
        if not IsDirectProductElement(pnt) then
            ErrorNoReturn("<pnt> must be an IsDirectProductElement object");
        fi;
        if not Length(pnt) = lengthActions then
            ErrorNoReturn("<pnt> and <actions> must have equal length");
        fi;
        tup := ListWithIdenticalEntries(lengthActions, 0);
        for i in [1 .. lengthActions] do
            tup[i] := actions[i](pnt[i], g);
        od;
        return DirectProductElementNC(FamilyObj(pnt), tup);
    end;
end);

InstallOtherMethod(ActionOnDirectProductDomain,
"for an action, an integer, and an integer)",
[IsFunction, IsInt, IsInt],
function(action, i, d)
    return function(pnt, g)
        local tup;
        if not IsDirectProductElement(pnt) then
            ErrorNoReturn("<pnt> must be an IsDirectProductElement object");
        fi;
        tup := pnt{[1 .. d]};
        tup[i] := OnPoints(tup[i] , g);
        return DirectProductElementNC(FamilyObj(pnt), tup);
    end;
end);

BindGlobal("ActionOnRangeByActionOnDirectProductDomain",
function(action, dom)
    local bijToRange;
    if not IsFunction(action) or not IsDirectProductDomain(dom) then
        ErrorNoReturn("<action> must be a function and ",
                      "<dom> must be a direct product domain");
    fi;
    bijToRange := BijectiveMappingFromDirectProductDomainToRange(dom);
    return PushforwardActionByPointMap(bijToRange, action);
end);


# Old product decomposition code using IsDirectProductDomain objects
# TODO unfinished
ProjectionOntoIthComponentUnderNaturalProductIdentification
        := function(g, i, m, d)
    local prefun, representatives, source, range, fun, map,
        actionProjectedToIthComp, ardActionByPoin;
    ErrorNoReturn("unfinished");
    # Set up a MappingByFunction
    source := Domain([1 .. m ^ d]);
    range := Domain([1 .. m]);
    map := MappingByFunction(source, range, fun, false, prefun);
    # Compute the permutation
    actionProjectedToIthComp := PushforwardActionByPointMap(map);
    return Permutation(g, [1 .. m], actionProjectedToIthComp);
end;

# TODO unfinished
BindGlobal("NaturalProductDecomposition",
function(m, l)
        local dom, projectionOnto;
        ErrorNoReturn("unfinished");
        dom := DirectProductDomain(Domain([1 .. m]), l);
        projectionOnto := function(x, i)
            #
        end;
end);
