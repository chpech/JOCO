DeclareCategory( "IsRegularSet", IsCocoObject );

DeclareGlobalFunction( "BuildRegularSet" ); 

DeclareAttribute( "RegularSetsFamily", IsColorGraph );

                       

DeclareOperation( "RegularSetFromPartialGoodSet", [IsPartialGoodSet] );

DeclareOperation( "RainbowOfRegularSet", [IsRegularSet] ); 
DeclareOperation( "OnRegularSets", [IsRegularSet, IsPerm] );    

################################################################################

DeclareCategory( "IsRegularSetOrbit", IsCocoSetOrbit );
KeyDependentOperation( "RegularSetOrbitsFamily", IsColorGraph, IsPermGroup, ReturnTrue );


DeclareGlobalFunction( "RegularSetOrbit" );   
DeclareGlobalFunction( "RegularSetOrbitNC" );  
DeclareOperation( "HomogeneousRegularSetOrbits", [IsColorGraph and IsWLStableColorGraph] );

DeclareAttribute( "HomogeneousSymRegularSetOrbits", IsColorGraph and IsWLStableColorGraph); 

DeclareAttribute( "HomogeneousAsymRegularSetOrbits", IsColorGraph and IsWLStableColorGraph ); 
