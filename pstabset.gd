# in COCO2P a set of colors
DeclareCategory("IsCocoPartialStableSet", IsObject );

DeclareOperation( "IsEmptyPartialStableSet", [IsPartialStableSet] );
DeclareOperation( "IMapOfPartialStableSet", [IsPartialGoodSet] );

DeclareProperty( "IsCompletePartialStableSet", IsPartialStableSet );
DeclareOperation( "DomainOfPartialStableSet", [IsPartialStableSet] );                            # internal
DeclareProperty( "IsExtendiblePartialStableSet", IsPartialStable );                           # internal
DeclareOperation( "ExtendedPartialStableSet", [IsPartialStableSet, IsPosInt] );                  # internal

DeclareOperation( "IsCompatiblePoint", [IsPartialStableSet,IsPosInt] );

DeclareOperation( "StableSetFromPartialStableSet", [IsPartialStableSet] );

################################################################################

DeclareCategory( "IsPartialStableSetOrbit", IsCocoSetOrbit );
DeclareGlobalFunction( "PartialStableSetOrbitNC" );


################################################################################

DeclareCategory( "IsIteratorOfPartialStableSetOrbits", IsIterator );
DeclareOperation( "IteratorOfPartialStableSetOrbits", [IsPermGroup, IsPartialStableSet] );                     # internal
DeclareOperation( "AllStableSetOrbits", [IsIteratorOfPartialStableSetOrbits] );                  # internal

