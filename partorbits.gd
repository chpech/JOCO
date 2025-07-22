DeclareCategory( "IsCOCOPartialPartition", IsObject );
DeclareCategory( "IsPartialPartition", IsCOCOPartialPartition );

DeclareProperty( "IsIrredundantPartialPartition", IsCOCOPartialPartition );
DeclareProperty( "IsCompletePartialPartition", IsCOCOPartialPartition );
DeclareProperty( "HasSmallerBase", IsCOCOPartialPartition );

DeclareOperation( "EmptyPartialPartition", [IsList] );
DeclareOperation( "ExtendedPartialPartition", [IsCOCOPartialPartition, IsList] );

DeclareOperation( "IsCompatibleWithPartialPartition", [IsCOCOPartialPartition, IsList] );

DeclareOperation( "PartitionFromCompletePartialPartition", [IsCOCOPartialPartition ] );

DeclareAttribute( "RankOfPartialPartition", IsCOCOPartialPartition );

DeclareOperation( "AsSetsSet", [IsCOCOPartialPartition] );
DeclareOperation( "DomainOfPartialPartition" ,[IsCOCOPartialPartition] );


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
