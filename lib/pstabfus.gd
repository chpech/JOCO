DeclareCategory("IsCocoStablePartition", IsObject );
DeclareCategory("IsCocoPartialStablePartition", IsObject );

DeclareOperation( "IsEmptyPartialStablePartition", [IsCocoPartialStablePartition] );
DeclareAttribute("RankOfPartialStablePartition", IsCocoPartialStablePartition );

DeclareProperty( "IsIrredundantPartialStablePartition", IsCocoPartialStablePartition );
DeclareAttribute( "IsCompletePartialStablePartition", IsCocoPartialStablePartition );
DeclareProperty( "PartialStablePartitionHasSmallerBase", IsCocoPartialStablePartition );

DeclareOperation( "ExtendedPartialStablePartition", [IsCocoPartialStablePartition, IsCocoStableSet] );

DeclareProperty( "IsExtendiblePartialStablePartition", IsCocoPartialStablePartition );
DeclareOperation( "IsCompatibleWithPartialStablePartition", [IsCocoPartialStablePartition, IsCocoStableSet] );





DeclareOperation( "StablePartitionFromCompletePartialStablePartition", [IsCocoPartialStablePartition ] );



DeclareCategory( "IsPartialStablePartitionOrbit", IsCocoOrbit );
DeclareOperation( "PartialStablePartitionOrbitNC", [IsPermGroup, IsCocoPartialStablePartition, IsPermGroup] );

DeclareOperation( "ConstructorOfStablePartitionOrbit", [IsCocoStablePartition] );
DeclareOperation( "ConstructorOfStablePartitionOrbitNC", [IsCocoStablePartition] );

DeclareOperation( "GetPartialStablePartitionOrbitFamily", [IsCocoPartialStablePartition, IsPermGroup] );


################################################################################

DeclareCategory( "IsIteratorOfPartialStablePartitionOrbits", IsIterator );
DeclareOperation( "IteratorOfPartialStablePartitionOrbits", [IsCocoPartialStablePartition, IsList] );
DeclareOperation( "AllStablePartitionOrbits", [IsIteratorOfPartialStablePartitionOrbits] );





