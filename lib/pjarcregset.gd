#! @Chapter pjarcregset

#! Partial J-arc regular sets are a tool for enumerating J-arc regular sets 
#! (see Chapter <Ref Sect='Chapter_JArcRegSet'/>).
#! The precise definition of a partial J-arc regular set depends on the kind
#! of color graph in question as well as of its representation. 

#! @Section Types
#! @BeginGroup IsPartialJArcRegularSet
#! @Description
#! The data types of partial J-arc regular sets. It is derived from the data type of 
#! partial stable sets (see Chapter <Ref Sect='Chapter_PStabSet'/>).
DeclareCategory( "IsPartialJArcRegularSet", IsCocoPartialStableSet );
DeclareCategory( "IsAsymPartialJArcRegularSet", IsPartialJArcRegularSet );
DeclareCategory( "IsSymPartialJArcRegularSet",  IsPartialJArcRegularSet );
#! @EndGroup

#! @Section Constructors

#! @Description
#! This function creates an empty asymmetric partial J-arc regular set of the color graph <A>cgr</A>.
#! It this point &JOCO; implements asymmetric partial arc-regular sets only for well-fibred 
#! J-stable color graphs.
#! @Arguments cgr
DeclareOperation( "EmptyAsymPartialJArcRegularSet", [IsColorGraph] );

#! @Description
#! This function returns an empty symmetric partial J-arc regular set of the color graph <A>cgr</A>.
#! It this point &JOCO; implements symmetric partial J-arc-regular sets only for well-fibred 
#! J-stable  color graphs
#! @Arguments cgr
DeclareOperation( "EmptySymPartialJArcRegularSet", [IsColorGraph] ); 


#! @Section Families

#! @Description 
#! The family of partial J-arc regular sets of colors of <A>cgr</A>.
#! @Arguments cgr
DeclareAttribute( "PartialJArcRegularSetsFamily",  IsColorGraph );

#! @Description 
#! The families of orbits of partial J-arc regular sets of colors of <A>cgr</A>.
#! For every permutation group <A>G</A> acting on the colors of <A>cgr</A> a
#! different family is created.
#! @Arguments cgr, G
KeyDependentOperation( "PartialJArcRegularSetOrbitFamily", IsColorGraph, IsPermGroup, ReturnTrue );


