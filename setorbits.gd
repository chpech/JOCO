DeclareCategory( "IsSetOrbit", IsCocoSetOrbit );

DeclareGlobalFunction( "SetOrbitNC" );
DeclareGlobalFunction( "SetOrbit" );

DeclareGlobalFunction( "SetOrbits" );

DeclareAttribute( "SetOrbitsFamily",  IsPermGroup );

################################################################################

DeclareCategory( "IsIteratorOfSetOrbits", IsIterator );
DeclareOperation( "IteratorOfSetOrbits", [IsPermGroup, IsList, IsList] ); 
DeclareOperation( "AllSetOrbits", [IsIteratorOfSetOrbits] );  

DeclareOperation( "RejectSetOrbit", [IsIteratorOfSetOrbits] );
DeclareOperation( "NextSetOrbit", [IsIteratorOfSetOrbits] );

DeclareGlobalFunction( "NumberOrbitsPerm@JOCO" );
DeclareGlobalFunction( "SetOrbits" );

