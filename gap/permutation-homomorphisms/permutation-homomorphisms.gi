#
# NormalizersOfPrimitiveGroups:
# A package to compute normalizers of primitive groups
#
InstallMethod(PushforwardActionByPointMap,
"for a mapping and a function",
[IsMapping, IsFunction],
function(map, action)
    if not NumberArgumentsFunction(action) in [-2, -1, 2] then
        ErrorNoReturn("<action> must accept two arguments");
    fi;
    return function(pnt, elm)
        local preImage;
        preImage := PreImagesRepresentative(map, pnt);
        return Image(map, action(preImage, elm));
    end;
end);

InstallOtherMethod(PushforwardActionByPointMap,
"for a mapping using the default action OnPoints",
[IsMapping],
function(map)
    return PushforwardActionByPointMap(map, OnPoints);
end);

InstallMethod(PushforwardActionByPointMap,
"for a bijective mapping and a function",
[HasIsBijective and IsBijective and IsMapping, IsFunction],
function(map, action)
    if not NumberArgumentsFunction(action) in [-2, -1, 2] then
        ErrorNoReturn("<action> must accept two arguments");
    fi;
    return function(pnt, elm)
        local preImage;
        preImage := PreImage(map, pnt);
        return Image(map, action(preImage, elm));
    end;
end);

# TODO: test the error msg
BindGlobal("MappingByPermutation",
function(source, range, perm)
    if not OnSets(AsSet(source), perm) = AsSet(range) then
        ErrorNoReturn("<perm> must map <source> to <range>");
    fi;
    if IsSet(source) and IsSet(range) then
        source := Domain(source);
        range := Domain(range);
    fi;
    return MappingByFunction(source, range,
                             x -> x ^ perm, x -> x ^ (perm ^ -1));
end);

# TODO introduce a filter "IsMappingStoringPreimages"
#   overload PreImagesElm
# source
#   the union of partition
# partition
#   a dense list of disjoint sets
#
# Returns:
#   a map that sends the elements of partition[i] to i.
BindGlobal("MappingByPreImages",
function(source, partition)
    local fun, range, prefun;
    if not IsDomain(source) or not IsDenseList(partition) then
        ErrorNoReturn("<source> must be a domain and ",
                      "<partition> must be a dense list");
    fi;
    fun := x -> PositionProperty(partition, block -> x in block);
    range := Domain([1 .. Length(partition)]);
    prefun := x -> partition[x][1];
    return MappingByFunction(source, range, fun, false, prefun);
end);
