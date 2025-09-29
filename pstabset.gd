# in COCO2P a set of colors
DeclareCategory("IsCocoPartialStableSet", IsObject );

DeclareProperty( "IsCompletePartialStableSet", IsPartialStableSet );

DeclareOperation( "ExtendedPartialStableSet", [IsPartialStableSet, IsPosInt] );                  # internal
DeclareProperty( "IsExtendiblePartialStableSet", IsPartialStable );                           # internal
DeclareOperation( "DomainOfPartialStableSet", [IsPartialStableSet] );                            # internal
DeclareOperation( "IsCompatiblePoint", [IsPartialStableSet,IsPosInt] );

DeclareOperation( "StableSetFromPartialStableSet", [IsPartialStableSet] );
DeclareOperation( "IsEmptyPartialStableSet", [IsPartialStableSet] );
DeclareOperation( "IMapOfPartialStableSet", [IsPartialGoodSet] );

################################################################################

DeclareCategory( "IsPartialStableSetOrbit", IsCocoSetOrbit );
DeclareGlobalFunction( "PartialStableSetOrbitNC" );


################################################################################

DeclareCategory( "IsIteratorOfPartialStableSetOrbits", IsIterator );
DeclareOperation( "IteratorOfPartialStableSetOrbits", [IsPermGroup, IsPartialStableSet] );                     # internal
DeclareOperation( "AllStableSetOrbits", [IsIteratorOfPartialStableSetOrbits] );                  # internal

