#! @Chapter colorpartition
#! As the name suggests, a color partition is a partition of the set of colors of a 
#! given color graph.
#! Color partitions are an abstract data type derived from 
#! `IsCocoStablePartition` (see Chapter <Ref Sect='Chapter_pstabfus'/>). The difference to 
#! stable partitions is that color partitions know that they are sets of colors of a
#! given color graph. 
#! 



#! @Section Types and families

#! @Description
#! The data type of color partitions
DeclareCategory("IsColorPartition", IsCocoStablePartition );

#! @Description
#! The family of color partitions over <A>cgr</A>
#! @Arguments cgr
DeclareAttribute( "ColorPartitionsFamily", IsColorGraph );

#! @Section Constructors

#! @Description
#! The argument <A>filter</A> is a type of color partitions.
#! For a color graph <A>cgr</A> and a partition <A>part</A> of colors of <A>cgr</A> this
#! function constructs an object of type <A>filter</A> that represents the partition <A>part</A>
#! as a color partition over <A>cgr</A>. The function does not check whether <A>part</A> is
#! actually a partition of colors.
#! @Arguments filter,cgr,set
DeclareConstructor("ColorPartition", [IsColorPartition, IsColorGraph, IsList]);

#! @Description
#! This implements the action of permutations on color partitions. It is expected,
#! but not checked, that <A>prm</A> permutes the colors of the underlying color graph 
#! of `cpart`
#! @Arguments cpart, prm
DeclareOperation( "OnColorPartitions", [IsColorPartition, IsPerm] ); 

#! @Section Functions for the inspection of color partitions

#! @Description
#! Every color partition knows the color graph over which it is defined. This function
#! returns the underlying color graph of the color partition <A>cpart</A>.
#! @Arguments cpart
DeclareOperation( "UnderlyingCgrOfColorPartition", [IsColorPartition] ); 


#! @Description
#! This function returns the color partition <A>cpart</A> as an immutable list of 
#! sets of colors. The list is ordered in short-lex ordering.
#! @Arguments cpart
DeclareOperation( "UnderlyingPartitionOfColorPartition", [IsColorPartition] );

#! @Description
#! This function gets as input a color partition <A>cpart</A>. And returns the fusion color graph 
#! of  `UnderlyingCgrOfColorPartition(<A>cpart</A>)` with respect to 
#! `UnderlyingPartitionOfColorPartition(<A>cpart</A>)`.
#! @Arguments cpart
DeclareAttribute("FusionColorGraph", IsColorPartition );

#! Description  
#! This function gets as input a list <A>lcpart</A> of color partitions, all over the same color
#! graph `cgr`. It produces a string containing information about the corresponding
#! fusion color graphs of `cgr`. The function expects that all fusion color graphs are rainbows.
#! Arguments lcpart: long, cisomap, strucexp
DeclareGlobalFunction( "DisplayStringColorPartitions" );

################################################################################

#! @Section Orbits of regular fusions

#! @Description
#! The type of orbits of color partitions. This is derived from `IsCocoPartitionOrbit`.
DeclareCategory( "IsColorPartitionOrbit", IsCocoPartitionOrbit );


#! @Description
#! The families of orbits of color partitions for the color graph <A>cgr</A>. For every 
#! permutation  group <A>grp</A> another family is created.
#! @Arguments cgr,grp
KeyDependentOperation( "ColorPartitionOrbitsFamily", IsColorGraph, IsPermGroup, ReturnTrue );


#! @BeginGroup GrpColorPartitionOrbit
#! @Description
#! `ColorPartitionOrbitNC` expects as input a permutation group <A>grp</A>, a color partition 
#! <A>cpart</A>, and a subgroup <A>stab</A> of <A>grp</A>. It expects
#! * <A>grp</A> to be a permutation group on the colors of `UnderlyingCgrOfColorPartition(cpart)`,
#! * `UnderlyingPartitionOfColorPartition(cpart)` to be the smallest element of its orbit under 
#!   <A>grp</A> (with respect to short-lex ordering),
#! * <A>stab</A> to be the stabilizer of `UnderlyingPartitionOfColorPartition(cpart)` in 
#!   <A>grp</A>.
#! None of this is checked. The function returns an object representing the orbit of <A>cpart</A> 
#! under <A>grp</A> with respect to the action `OnColorPartitions`.
#!
#! `ColorPartitionOrbit` gets the same kind of input like `ColorPartitionOrbitNC`. However, its 
#! expectations on this input are weaker. It expects:
#! * <A>grp</A> to be a permutation group on the colors of `UnderlyingCgrOfColorPartition(cpart)`,
#! * <A>stab</A> to be a subgroup of the stabilizer of `UnderlyingPartitionOfColorPartition(cpart)`
#!   in <A>grp</A> (`OnColorPartitions`).
#! These two expectations are not checked either. Otherwise it does the same like 
#! `ColorPartitionOrbitNC`.
#! @Arguments grp,cpart[,stab]
DeclareGlobalFunction( "ColorPartitionOrbit" );
#! @Arguments grp,rfus,stab
DeclareGlobalFunction( "ColorPartitionOrbitNC" );
#! @EndGroup

