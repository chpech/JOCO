DeclareCategory( "IsPartialColorPartition", IsCocoPartialStablePartition );
DeclareOperation( "ConstructorOfPartialColorPartition", [IsPartialColorPartition]);
DeclareGlobalFunction( "RefinedInternalPartition" );     # undocumented
DeclareOperation("StabilizedInternalPartition", [IsPartialColorPartition, IsColorSet, IsRecord] );
