DeclareCategory( "IsRegularSet", IsCocoStableSet );

DeclareConstructor("RegularSet", [IsRegularSet, IsColorGraph, IsList]);


DeclareAttribute( "RegularSetsFamily", IsColorGraph );

                       

# DeclareOperation( "RegularSetFromPartialGoodSet", [IsPartialGoodSet] );

DeclareOperation( "UnderlyingCgrOfRegularSet", [IsRegularSet] ); 
DeclareOperation( "OnRegularSets", [IsRegularSet, IsPerm] );    

################################################################################

DeclareCategory( "IsRegularSetOrbit", IsCocoSetOrbit );
KeyDependentOperation( "RegularSetOrbitsFamily", IsColorGraph, IsPermGroup, ReturnTrue );


DeclareGlobalFunction( "RegularSetOrbit" );   
DeclareGlobalFunction( "RegularSetOrbitNC" );  
DeclareOperation( "HomogeneousRegularSetOrbits", [IsColorGraph and IsRainbow and IsStableRainbow] );

DeclareAttribute( "HomogeneousSymRegularSetOrbits", IsColorGraph and IsRainbow and IsStableRainbow); 

DeclareAttribute( "HomogeneousAsymRegularSetOrbits", IsColorGraph and IsRainbow and IsStableRainbow ); 
