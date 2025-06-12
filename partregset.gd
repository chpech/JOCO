

DeclareCategory( "IsPartialRegularSet", IsPartialGoodSet );
DeclareCategory( "IsAsymPartialRegularSet", IsPartialRegularSet );
DeclareCategory( "IsSymPartialRegularSet",  IsPartialRegularSet );

DeclareOperation( "EmptyAsymPartialRegularSet", [IsColorGraph and IsWLStableColorGraph] );
DeclareOperation( "EmptySymPartialRegularSet", [IsColorGraph and IsWLStableColorGraph] ); 

#DeclareOperation( "RegularSetFromPartialGoodSet", [IsPartialGoodSet] );


DeclareOperation( "AllRegularSetOrbits", [IsIteratorOfPartialGoodSetOrbits] );                  # internal
DeclareAttribute( "PartialRegularSetsFamily",  IsColorGraph );
