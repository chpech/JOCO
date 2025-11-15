#! @Chapter phadamard

#! Partial core Hadamard sets are a tool for enumerating core Hadamard sets 
#! (see Chapter <Ref Sect='Chapter_CoreHadamardSets'/>).

#! @Section Types and families

#! @Description
#! The data type of partial core Hadamard sets. It is derived from the data type of 
#! partial stable sets (see Chapter <Ref Sect='Chapter_PStabSet'/>).
DeclareCategory( "IsPartialCHadamardSet", IsCocoPartialStableSet );

#! @Description 
#! The family of partial core Hadamard sets of colors of <A>cgr</A>.
#! @Arguments cgr
DeclareAttribute( "PartialCHadamardSetsFamily",  IsColorGraph );

#! @Description 
#! The families of orbits of partial core Hadamard setsof colors of <A>cgr</A>.
#! For every permutation group <A>grp</A> acting on the colors of <A>cgr</A> a
#! different family gets created.
#! @Arguments cgr, grp
KeyDependentOperation( "PartialCHadamardSetOrbitsFamily", IsColorGraph, IsPermGroup, ReturnTrue );;

#! @Section Constructors

#! @Description
#! This function returns an empty partial core Hadamard set of the color graph <A>cgr</A>.
#! At this point &JOCO; implements core Hadamard sets only for well-fibred 
#! J-stable  color graphs
#! @Arguments cgr
DeclareOperation( "EmptyPartialCHadamardSet", [IsColorGraph] );





