DeclareCategory( "IsPartialHadamardSet", IsCocoPartialStableSet );
DeclareOperation( "EmptyPartialHadamardSet", [IsColorGraph] );

DeclareAttribute( "PartialHadamardSetsFamily",  IsColorGraph );



KeyDependentOperation( "PartialHadamardSetOrbitsFamily", IsColorGraph, IsPermGroup, ReturnTrue );;

