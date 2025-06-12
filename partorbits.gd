DeclareCategory( "IsPartialPartition", IsObject );


DeclareOperation( "EmptyPartialPartition", [IsList,IsInt] );
DeclareOperation( "ExtendedPartialPartition", [IsPartialPartition, IsList] );
DeclareProperty( "IsExtendiblePartialPartition", IsPartialPartition );
DeclareOperation( "IsCompatibleWithPartialPartition", [IsPartialPartition, IsList] );
DeclareAttribute( "IsCompletePartialPartition", IsPartialPartition );
DeclareOperation( "PartitionFromCompletePartialPartition", [IsPartialPartition ] );

DeclareAttribute( "RankOfPartialPartition", IsPartialPartition );

DeclareOperation( "AsSetsSet", [IsPartialPartition] );
DeclareOperation( "DomainOfPartialPartition" ,[IsPartialPartition] );


DeclareAttribute( "PartialPartitionOrbitsFamily", IsPermGroup );

DeclareAttribute( "PartitionOrbitsFamily",  IsPermGroup );
DeclareCategory( "IsPartialPartitionOrbit", IsCocoOrbit );
DeclareGlobalFunction( "PartialPartitionOrbitNC" );
DeclareGlobalFunction( "PartitionOrbit" );



DeclareGlobalFunction( "PartitionOrbitNC" );
DeclareGlobalFunction( "OnPartitions");

################################################################################

DeclareCategory( "IsIteratorOfPPOrbits", IsIterator );
DeclareOperation( "IteratorOfPPOrbits", [IsList, IsList] ); 
DeclareOperation( "AllPartitionOrbits", [IsIteratorOfPPOrbits] );  

DeclareOperation( "RejectPartialPartitionOrbit", [IsIteratorOfPPOrbits] );
DeclareOperation( "NextPartialPartitionOrbit", [IsIteratorOfPPOrbits] );
