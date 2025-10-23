DeclareCategory( "IsPartialRegularSet", IsCocoPartialStableSet );
DeclareCategory( "IsAsymPartialRegularSet", IsPartialRegularSet );
DeclareCategory( "IsSymPartialRegularSet",  IsPartialRegularSet );

DeclareOperation( "EmptyAsymPartialRegularSet", [IsColorGraph] );
DeclareOperation( "EmptySymPartialRegularSet", [IsColorGraph] ); 

DeclareAttribute( "PartialRegularSetsFamily",  IsColorGraph );
KeyDependentOperation( "PartialRegularSetOrbitFamily", IsColorGraph, IsPermGroup, ReturnTrue );
