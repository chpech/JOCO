#! @Chapter partregset

#! Partial regular sets are a tool for enumerating regular sets 
#! (see Chapter <Ref Sect='Chapter_regsets'/>).
#! The precise definition of a partial regular set depends on the kind
#! of color graph in question as well as of its representation. 

#! @Section Types
#! @BeginGroup IsPartialRegularSet
#! @Description
#! The data types of partial regular sets. It is derived from the data type of partial stable sets
#! (see Chapter <Ref Sect='Chapter_PStabSet'/>).
DeclareCategory( "IsPartialRegularSet", IsCocoPartialStableSet );
DeclareCategory( "IsAsymPartialRegularSet", IsPartialRegularSet );
DeclareCategory( "IsSymPartialRegularSet",  IsPartialRegularSet );
#! @EndGroup

#! @Section Constructors

#! @Description
#! This function createsreturns an empty asymmetric partial regular set of the color graph <A>cgr</A>.
#! It this point &JOCO; implements asymmetric partial regular sets only for well-fibred rainbows 
#! (see Chapter <Ref Sect='Chapter_Rainbows'/>).
#! @Arguments cgr
DeclareOperation( "EmptyAsymPartialRegularSet", [IsColorGraph] );

#! @Description
#! This function returns an empty symmetric partial regular set of the color graph <A>cgr</A>.
#! It this point &JOCO; implements symmetric partial regular sets only for well-fibred rainbows 
#! (see Chapter <Ref Sect='Chapter_Rainbows'/>).
#! @Arguments cgr
DeclareOperation( "EmptySymPartialRegularSet", [IsColorGraph] ); 


#! @Section Families

#! @Description 
#! The family of partial regular sets of colors of <A>cgr</A>.
#! @Arguments cgr
DeclareAttribute( "PartialRegularSetsFamily",  IsColorGraph );


#! @Description 
#! The families of orbits of partial regular sets of colors of <A>cgr</A>.
#! For every permutation group <A>G</A> acting on the colors of <A>cgr</A> a
#! different family is created.
#! @Arguments cgr, G
KeyDependentOperation( "PartialRegularSetOrbitFamily", IsColorGraph, IsPermGroup, ReturnTrue );
