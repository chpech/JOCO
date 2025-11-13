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

#! @Description
#! The type of orbits of regular sets. This is derived from `IsCocoSetOrbit`.
DeclareCategory( "IsRegularSetOrbit", IsCocoSetOrbit );

#! @Description
#! The families of orbits of regular sets for the color graph <A>cgr</A>. For every permutation 
#! group <A>G</A> another family is created.
#! @Arguments cgr,G
KeyDependentOperation( "RegularSetOrbitsFamily", IsColorGraph, IsPermGroup, ReturnTrue );

#! @BeginGroup constructurs
#! @Description
#! `RegularSetOrbitNC` expects as input a permutation group <A>group</A>, a reglar set <A>gs</A>,
#! and a subgroup <A>stab</A> of <A>group</A>. It expects
#! * <A>group</A> to be a subgroup of `RAut(UnderlyingCgrOfColorSet(gs))`,
#! * `AsSet(gs)` be the smallest element of its orbit under <A>group</A> (in action `OnSets`),
#! * <A>stab</A> to be the set-wise stabilizer of `AsSet(gs)` in <A>group</A>.
#! None of this is checked. The function returns an object representing the orbit of <A>gs</A> 
#! under <A>group</A> with respect to the action `OnRegularSets`.
#!
#! `RegularSetOrbit gets the same kind of input like `RegularSetOrbitNC. However, its expectations
#! on this input are weaker. It expects:
#! * <A>group</A> to be a subgroup of `RAut(UnderlyingCgrOfColorSet(gs))`,
#! * <A>stab</A> to be a subgroup of the set-wise stabilizer of `AsSet(gs)` in <A>group</A>.
#! These two expectations are not checked either. Otherwise it does the same like 
#! `RegularSetOrbitNC`.
#! @Arguments group,gs[,stab]
DeclareGlobalFunction( "RegularSetOrbit" );   
#! @Arguments group,gs[,stab]
DeclareGlobalFunction( "RegularSetOrbitNC" );  
#! @EndGroup


#! @BeginGroup RegularSetOrbits
#! @Description
#! Computes all orbits of regular sets of <A>cgr</A> under <A>grp</A>. The group
#! <A>grp</A> is expected to be a subgroup of `RAut(cgr)`. If <A>grp</A> is not given, then 
#! it is taken to be equal to `RAut(cgr)`. If the option `:sym` is given, then only 
#! symmetric regular sets are computed.
#! @Arguments cgr[,grp] :sym
DeclareOperation( "RegularSetOrbits", [IsColorGraph and IsRainbow and IsStableRainbow] );

#! @Arguments cgr[,grp]
DeclareAttribute( "SymmetricRegularSetOrbits", IsColorGraph and IsRainbow and IsStableRainbow); 

#! @Arguments cgr[,grp]
DeclareAttribute( "AsymmetricRegularSetOrbits", IsColorGraph and IsRainbow and IsStableRainbow ); 
#! @EndGroup
