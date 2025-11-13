#! @Chapter ColorSets
#! As the name suggests, a color set is a set of colors of a given color graph.
#! Color sets are an abstract data type derived from 
#! `IsCocoStableSet` (see Chapter <Ref Sect='Chapter_PStabSet'/>). The difference to 
#! stable sets is that color sets know that they are sets of colors of a
#! given color graph. 
#! 
#! If $(V,C,f)$ is a color graph and $M$ is a subset of $C$, then we may associate to 
#! $M$ a relation $R_M$ over $V$ as follows:
#!     $$ R_M := \{ (u,v)\in V^2\mid f(u,v)\in M\}.$$
#! Similarly, we may associate with $M$ a $V\times V$-matrix $A_M$ defined by
#! $(A_M)_{u,v} = 1$ if $f(u,v)\in M$ and  $(A_M)_{u,v} = 0$ otherwise,

#! @Section Types

#! @Description
#! The data type of color sets
DeclareCategory("IsColorSet", IsCocoStableSet );


#! @Section Inspection
#! @SectionTitle Functions for the inspection of color sets

#! @Description
#! Every color set knows the color graph over which it is defined. This function
#! returns the underlying color graph of the color set <A>cset</A>.
#! @Arguments cset
DeclareOperation( "UnderlyingCgrOfColorSet", [IsColorSet] ); 

#! @Description
#! Let $M$ be the underlying set of colors of `cset`.  This function returns 
#! `true` if $J-2A_M$ is a Hadamard matrix, and `false` otherwise.
#! @Arguments cset
DeclareProperty("IsHadamardSet", IsColorSet);
