# in COCO2P a set of colors
DeclareCategory("IsCocoStableSet", IsObject );

DeclareCategory("IsCocoPartialStableSet", IsObject );

DeclareOperation( "IsEmptyPartialStableSet", [IsCocoPartialStableSet] );
DeclareOperation( "IMapOfPartialStableSet", [IsCocoPartialStableSet] );

DeclareProperty( "IsCompletePartialStableSet", IsCocoPartialStableSet );
DeclareOperation( "DomainOfPartialStableSet", [IsCocoPartialStableSet] );                            # internal
DeclareProperty( "IsExtendiblePartialStableSet", IsCocoPartialStableSet );                           # internal
DeclareOperation( "ExtendedPartialStableSet", [IsCocoPartialStableSet, IsPosInt] );                  # internal

DeclareOperation( "IsCompatiblePoint", [IsCocoPartialStableSet,IsPosInt] );
DeclareProperty( "IsCompletePartialStableSet", IsCocoPartialStableSet);

DeclareOperation( "StableSetFromPartialStableSet", [IsCocoPartialStableSet] );

################################################################################

DeclareCategory( "IsPartialStableSetOrbit", IsCocoOrbit );
DeclareOperation( "PartialStableSetOrbitNC", [IsPermGroup, IsCocoPartialStableSet, IsPermGroup] );

DeclareOperation( "ConstructorOfStableSetOrbit", [IsCocoStableSet] );
DeclareOperation( "GetPartialStableSetOrbitFamily", [IsCocoPartialStableSet, IsPermGroup] );

                
                
################################################################################

DeclareCategory( "IsIteratorOfPartialStableSetOrbits", IsIterator );
DeclareOperation( "IteratorOfPartialStableSetOrbits", [IsPermGroup, IsCocoPartialStableSet] );                     # internal
DeclareOperation( "AllStableSetOrbits", [IsIteratorOfPartialStableSetOrbits] );                  # internal

