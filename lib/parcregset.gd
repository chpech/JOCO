DeclareCategory( "IsPartialArcRegularSet", IsCocoPartialStableSet );
DeclareCategory( "IsAsymPartialArcRegularSet", IsPartialRegularSet );
DeclareCategory( "IsSymPartialArcRegularSet",  IsPartialRegularSet );

DeclareOperation( "EmptyAsymPartialArcRegularSet", [IsColorGraph] );
DeclareOperation( "EmptySymPartialArcRegularSet", [IsColorGraph] ); 

DeclareAttribute( "PartialArcRegularSetsFamily",  IsColorGraph );
KeyDependentOperation( "PartialArcRegularSetOrbitFamily", IsColorGraph, IsPermGroup, ReturnTrue );

