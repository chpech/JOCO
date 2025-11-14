DeclareCategory( "IsCocoPartialPartition", IsObject );
DeclareCategory( "IsPartialPartition", IsCocoPartialPartition );



DeclareProperty( "IsIrredundantPartialPartition", IsCocoPartialPartition );
DeclareProperty( "IsCompletePartialPartition", IsCocoPartialPartition );
DeclareProperty( "HasSmallerBase", IsCocoPartialPartition );

DeclareOperation( "EmptyPartialPartition", [IsList] );
DeclareOperation( "ExtendedPartialPartition", [IsCocoPartialPartition, IsList] );

DeclareOperation( "IsCompatibleWithPartialPartition", [IsCocoPartialPartition, IsList] );

DeclareOperation( "PartitionFromCompletePartialPartition", [IsCocoPartialPartition ] );

DeclareAttribute( "RankOfPartialPartition", IsCocoPartialPartition );

DeclareOperation( "AsSetsSet", [IsCocoPartialPartition] );
# DeclareOperation( "DomainOfPartialPartition" ,[IsCocoPartialPartition] );

DeclareCategory( "IsPartitionOrbit", IsCocoPartitionOrbit );
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
