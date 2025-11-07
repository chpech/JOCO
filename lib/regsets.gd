#! @Chapter regsets
#! @Section Theory
#! Let $(V,C,f)$ be a color graph and let $M$ be a subset of $C$. let further 
#!       $$ R_M = \{ (u,v)\in V^2 \mid f(u,v) \in M \}.$$
#!We call $M$ a __regular set__ of $(V,C,f)$ if
#! * (1) $R_M$ is irreflexive,
#! * (2) $R_M$ is either symmetric or asymmetric,
#! * (3) there exists some $k$ such that for all $v\in V$ we have that 
#!      $$ k = |\{w\in V\mid (v,w)\in R_M\}|.$$

#! @Section Types

#! @Description
#! The data type regular sets is derived from the abstract data type of color sets 
#! (see Chapter <Ref Sect='Chapter_ColorSets'/>) which is in turn derived from the abstract
#! type of stable sets (see Chapter <Ref Sect='Chapter_PStabSet'/>).
DeclareCategory( "IsRegularSet", IsColorSet );

#! @Section Constructors

#! @Description 
#! The argument <A>filter</A> is a type of regular sets.
#! For a color graph <A>cgr</A> and a subset <A>set</A> of colors of <A>cgr</A> this
#! function constructs an object of type <A>filter</A> that represents the set <A>set</A>
#! as a regular set over <A>cgr</A>. The function does not check whether <A>set</A> is 
#! actually a regular set.
#! @Arguments filter,cgr,set
DeclareConstructor("RegularSet", [IsRegularSet, IsColorGraph, IsList]);

#! @Section Families

#! @Description
#! The family of regular sets over <A>cgr</A>
#! #Arguments cgr
DeclareAttribute( "RegularSetsFamily", IsColorGraph );


#! @Section Miscellaneous

#! @Description
#! The action of permutations on regular sets of various types
DeclareOperation( "OnRegularSets", [IsRegularSet, IsPerm] );    

################################################################################

#! @Section Orbits of regular sets

DeclareCategory( "IsRegularSetOrbit", IsCocoSetOrbit );

KeyDependentOperation( "RegularSetOrbitsFamily", IsColorGraph, IsPermGroup, ReturnTrue );


DeclareGlobalFunction( "RegularSetOrbit" );   
DeclareGlobalFunction( "RegularSetOrbitNC" );  


DeclareOperation( "HomogeneousRegularSetOrbits", [IsColorGraph and IsRainbow and IsStableRainbow] );

DeclareAttribute( "HomogeneousSymRegularSetOrbits", IsColorGraph and IsRainbow and IsStableRainbow); 

DeclareAttribute( "HomogeneousAsymRegularSetOrbits", IsColorGraph and IsRainbow and IsStableRainbow ); 
