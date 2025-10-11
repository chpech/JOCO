# in COCO2P a set of colors
DeclareCategory("IsCocoStableSet", IsObject );

DeclareCategory("IsCocoPartialStableSet", IsObject );

DeclareOperation( "IsEmptyPartialStableSet", [IsCocoPartialStableSet] );
DeclareOperation( "IMapOfPartialStableSet", [IsCocoPartialStableSet] );
DeclareOperation( "DomainOfPartialStableSet", [IsCocoPartialStableSet] );                            # internal


DeclareProperty( "IsCompletePartialStableSet", IsCocoPartialStableSet );



# ExtendedPartialStableSet extends a partial stable set by one point from its domain
# if during the process of extension it becomes clear that the new partial stable set 
# can not be completed to a complete partial stable set, then ExtendedPartialStableSet 
# may return fail instead of a new partial stable set.
DeclareOperation( "ExtendedPartialStableSet", [IsCocoPartialStableSet, IsPosInt] );                  # internal

# the following two operations should be eliminated
# By definition, IsExtendiblePartialStableSet should be equivalent to the condition
# DomainOfPartialStableSet <> []
#
# also by definition, every point in DomainOfPartialStableSet is compatible
# if partial stable sets are artificially restricted in size, then this can be 
# implemented in ExtendedPartialStableSet
# DeclareProperty( "IsExtendiblePartialStableSet", IsCocoPartialStableSet );                           # internal
# DeclareOperation( "IsCompatiblePoint", [IsCocoPartialStableSet,IsPosInt] );


# this is just a type conversion operation that is there mainly to get rid of 
# auxiliary data stored in partial stable sets
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

