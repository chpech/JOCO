DeclareCategory( "IsSetOrbit", IsCocoSetOrbit );

DeclareGlobalFunction( "SetOrbitNC" );
DeclareGlobalFunction( "SetOrbit" );

DeclareGlobalFunction( "AllSetOrbits" );

DeclareAttribute( "SetOrbitsFamily",  IsPermGroup );

################################################################################

DeclareCategory( "IsIteratorOfSetOrbits", IsIterator );
DeclareOperation( "IteratorOfSetOrbits", [IsPermGroup, IsList, IsList] ); 
DeclareOperation( "AllSetOrbitsFromIterator", [IsIteratorOfSetOrbits] );  

DeclareOperation( "RejectSetOrbit", [IsIteratorOfSetOrbits] );
DeclareOperation( "NextSetOrbit", [IsIteratorOfSetOrbits] );

DeclareGlobalFunction( "NumberOrbitsPerm@JOCO" );

