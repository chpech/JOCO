#! @Chapter parcregset

#! Partial arc-regular sets are a tool for enumerating arc-regular sets 
#! (see Chapter <Ref Sect='Chapter_ArcRegSet'/>).
#! The precise definition of a partial arc-regular set depends on the kind
#! of color graph in question as well as of its representation. 

#! @Section Types
#! @BeginGroup IsPartialArcRegularSet
#! @Description
#! The data types of partial arc-regular sets. It is derived from the data type of partial stable sets
#! (see Chapter <Ref Sect='Chapter_PStabSet'/>).
DeclareCategory( "IsPartialArcRegularSet", IsCocoPartialStableSet );
DeclareCategory( "IsAsymPartialArcRegularSet", IsPartialArcRegularSet );
DeclareCategory( "IsSymPartialArcRegularSet",  IsPartialArcRegularSet );
#! @EndGroup


#! @Section Constructors

#! @Description
#! This function creates an empty asymmetric partial arc-regular set of the color graph <A>cgr</A>.
#! It this point &JOCO; implements asymmetric partial arc-regular sets only for WL-stable
#! color graphs.
#! @Arguments cgr
DeclareOperation( "EmptyAsymPartialArcRegularSet", [IsColorGraph] );

#! @Description
#! This function returns an empty symmetric partial arc-regular set of the color graph <A>cgr</A>.
#! It this point &JOCO; implements symmetric partial arc-regular sets only for WL-stable 
#! color graphs
#! @Arguments cgr
DeclareOperation( "EmptySymPartialArcRegularSet", [IsColorGraph] ); 

#! @Section Families

#! @Description 
#! The family of partial arc-regular sets of colors of <A>cgr</A>.
#! @Arguments cgr
DeclareAttribute( "PartialArcRegularSetsFamily",  IsColorGraph );


#! @Description 
#! The families of orbits of partial arc-regular sets of colors of <A>cgr</A>.
#! For every permutation group <A>G</A> acting on the colors of <A>cgr</A> a
#! different family is created.
#! @Arguments cgr, G
KeyDependentOperation( "PartialArcRegularSetOrbitFamily", IsColorGraph, IsPermGroup, ReturnTrue );
