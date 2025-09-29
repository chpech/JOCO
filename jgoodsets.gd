DeclareCategory( "IsJGoodSet", IsCocoObject );

DeclareGlobalFunction( "BuildJGoodSet" );      
DeclareAttribute( "JGoodSetsFamily", IsTensor );


DeclareOperation( "AllJGoodSetOrbits", [IsIteratorOfPartialGoodSetOrbits] );                  # internal
                       

DeclareOperation( "JGoodSetFromPartialGoodSet", [IsPartialGoodSet] );

DeclareOperation( "TensorOfJGoodSet", [IsJGoodSet] ); 
DeclareOperation( "OnJGoodSets", [IsJGoodSet, IsPerm] ); 
DeclareOperation( "PartitionOfJGoodSet" , [IsJGoodSet] );  

################################################################################

DeclareCategory( "IsJGoodSetOrbit", IsCocoSetOrbit );
KeyDependentOperation( "JGoodSetOrbitsFamily", IsTensor, IsPermGroup, ReturnTrue );



DeclareGlobalFunction( "JGoodSetOrbit" );   
DeclareGlobalFunction( "JGoodSetOrbitNC" );  
DeclareOperation( "HomogeneousJGoodSetOrbits", [IsTensor and IsTensorOfCC] ); 
