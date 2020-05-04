#@local D8, blocksystem, projection, action, actionHom

gap> D8 := DihedralGroup(IsPermGroup, 8);
Group([ (1,2,3,4), (2,4) ])
gap> blocksystem := MaximalBlocks(D8, [1..4]);
[ [ 1, 3 ], [ 2, 4 ] ]

# TODO error handling
# MappingByPreImages
gap> projection := MappingByPreImages(Domain([1..4]), blocksystem);
MappingByFunction( Domain([ 1 .. 4 ]), Domain(
[ 1 .. 2 ]), function( x ) ... end )
gap> List([1..4], x -> Image(projection, x));
[ 1, 2, 1, 2 ]
gap> List([1..2], x -> PreImages(projection, x));
[ [ 1, 3 ], [ 2, 4 ] ]

# PushforwardActionByPointMap
gap> action := PushforwardActionByPointMap(projection);;
gap> actionHom := ActionHomomorphism(D8, AsList(Range(projection)), action);;
gap> Size(Image(actionHom));
2
