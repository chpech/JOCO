DeclareCategory( "IsPartialArcRegularSet", IsCocoPartialStableSet );
DeclareCategory( "IsAsymPartialArcRegularSet", IsPartialArcRegularSet );
DeclareCategory( "IsSymPartialArcRegularSet",  IsPartialArcRegularSet );

DeclareOperation( "EmptyAsymPartialArcRegularSet", [IsColorGraph] );
DeclareOperation( "EmptySymPartialArcRegularSet", [IsColorGraph] ); 

DeclareAttribute( "PartialArcRegularSetsFamily",  IsColorGraph );
KeyDependentOperation( "PartialArcRegularSetOrbitFamily", IsColorGraph, IsPermGroup, ReturnTrue );
