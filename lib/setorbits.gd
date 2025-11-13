#! @Chapter setorbits

#! @Section Types and families

#! @Description
#! The data type of set orbits. It is derived from the abstract type IsCocoSetOrbit
DeclareCategory( "IsSetOrbit", IsCocoSetOrbit );
DeclareAttribute( "SetOrbitsFamily",  IsPermGroup );

#! @Section Constructors
DeclareGlobalFunction( "SetOrbitNC" );
DeclareGlobalFunction( "SetOrbit" );

DeclareGlobalFunction( "AllSetOrbits" );


################################################################################
#! @Section Iterators of set orbits
DeclareCategory( "IsIteratorOfSetOrbits", IsIterator );
DeclareOperation( "IteratorOfSetOrbits", [IsPermGroup, IsList, IsList] ); 
DeclareOperation( "AllSetOrbitsFromIterator", [IsIteratorOfSetOrbits] );  

DeclareOperation( "RejectSetOrbit", [IsIteratorOfSetOrbits] );
DeclareOperation( "NextSetOrbit", [IsIteratorOfSetOrbits] );

DeclareGlobalFunction( "NumberOrbitsPerm@JOCO" );

