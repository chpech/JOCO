DeclareCategory( "IsHadamardSet", IsColorSet );
DeclareAttribute( "HadamardSetsFamily", IsColorGraph );

DeclareOperation("HadamardSet", [IsColorGraph, IsList]);


# DeclareOperation( "UnderlyingCgrOfHadamardSet", [IsHadamardSet] ); 
DeclareOperation( "OnHadamardSets", [IsHadamardSet, IsPerm] );    

################################################################################

DeclareCategory( "IsHadamardSetOrbit", IsCocoSetOrbit );
KeyDependentOperation( "HadamardSetOrbitsFamily", IsColorGraph, IsPermGroup, ReturnTrue );


DeclareGlobalFunction( "HadamardSetOrbit" );   
DeclareGlobalFunction( "HadamardSetOrbitNC" );  
DeclareOperation( "HadamardSetOrbits", [IsColorGraph and IsJStableColorGraph] );

