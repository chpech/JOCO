DeclareCategory( "IsPartialCHadamardSet", IsCocoPartialStableSet );
DeclareOperation( "EmptyPartialCHadamardSet", [IsColorGraph] );

DeclareAttribute( "PartialCHadamardSetsFamily",  IsColorGraph );



KeyDependentOperation( "PartialCHadamardSetOrbitsFamily", IsColorGraph, IsPermGroup, ReturnTrue );;

