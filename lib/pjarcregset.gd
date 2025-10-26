DeclareCategory( "IsPartialJArcRegularSet", IsCocoPartialStableSet );
DeclareCategory( "IsAsymPartialJArcRegularSet", IsPartialJArcRegularSet );
DeclareCategory( "IsSymPartialJArcRegularSet",  IsPartialJArcRegularSet );

DeclareOperation( "EmptyAsymPartialJArcRegularSet", [IsColorGraph] );
DeclareOperation( "EmptySymPartialJArcRegularSet", [IsColorGraph] ); 

DeclareAttribute( "PartialJArcRegularSetsFamily",  IsColorGraph );
KeyDependentOperation( "PartialJArcRegularSetOrbitFamily", IsColorGraph, IsPermGroup, ReturnTrue );


