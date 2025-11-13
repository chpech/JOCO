#! @Chapter CoreHadamardSets

#! @Section Theory
#! We are looking for sets $M$ of colors of a color graph $(V,C,f)$ with the property 
#! that the associated  matrix $H = H(M) = J - 2A_M$ of order $n=|V|$ satisfies 
#!        $$         HH^t = nI - (J-I) = (n+1)I - J, $$
#! and
#!        $$               HJ = JH = -J.    $$
#! Here $A_M$ is the $n \times n$ matric that has $(A_M)_{i,j} = 1$ iff $f(i,j)\in M$, 
#! and $(A_M)_{i,j} = 0$, otherwise. Such sets are called __Core Hadamard sets__
#! Note that $M$ is allowed to contain reflexive colors.
#! If $M$ is a Core Hadamard set of $(V,C,f)$, then adding a row and a column of ones to H(M),
#! we obtain a Hadamard matrix. It follows that n should be congruent 3 mod 4. 
#! The algorithms of &JOCO; search for Core Hadamard sets in well-fibred J-stable color graphs.
#! As there the usual matrix product is not availabble, the first identity above is weakened to 
#!            $$  H * H^t = 2nI - 2(J-I).$$


#! @Section Types

#! @Description
#! The data type of core Hadamard sets. It is derived from IsColorSet.
DeclareCategory( "IsCHadamardSet", IsColorSet );

#! @Description
#! The families of core hadamard sets. For each color graph <A>cgr</A>
#! one is created.
#! @Arguments cgr
DeclareAttribute( "CHadamardSetsFamily", IsColorGraph );

#! @Section Constructors
#! 
#! @Description
#! This function gets as input a color graph <A>cgr</A> and a core
#! Hadamard set <A>set</A>. It returns an object of type 
#! IsCHadamardSet representing this core hadamard set. It is not
#! checked whether <A>set</A> is actually a core Hadamard set for
#! <A>cgr</A>.
#! @Arguments cgr,set
DeclareOperation("CHadamardSet", [IsColorGraph, IsList]);

#! @Description
#! Implements the action of permutations on core Hadamard sets.
#! @Arguments cset, perm
DeclareOperation( "OnCHadamardSets", [IsCHadamardSet, IsPerm] );    

################################################################################

#! @Section Orbits of core Hadamard sets

#! @Description
#! The type of orbits of core Hadamard sets. This is derived from `IsCocoSetOrbit`.
DeclareCategory( "IsCHadamardSetOrbit", IsCocoSetOrbit );

#! @Description
#! The families of orbits of core Hadamard sets for the color graph <A>cgr</A>. 
#! For every permutation group <A>grp</A> another family is created.
#! @Arguments cgr,grp
KeyDependentOperation( "CHadamardSetOrbitsFamily", IsColorGraph, IsPermGroup, ReturnTrue );


#! @BeginGroup CHadamard constructurs
#! @Description
#! `CHadamardSetOrbitNC` expects as input a permutation group <A>grp</A>, a core hadamard set
#! <A>cset</A>, and a subgroup <A>stab</A> of <A>grp</A>. It expects
#! * <A>grp</A> to be a subgroup of `JAut(UnderlyingCgrOfColorSet(cset))`,
#! * `AsSet(cset)` be the smallest element of its orbit under <A>grp</A> (in action `OnSets`),
#! * <A>stab</A> to be the set-wise stabilizer of `AsSet(cset)` in <A>grp</A>.
#! None of this is checked. The function returns an object representing the orbit of <A>cset</A> 
#! under <A>grp</A> with respect to the action `OnCHadamardSets`.
#!
#! `CHadamardSetOrbit gets the same kind of input like `CHadamardSetOrbitNC. However, its 
#! expectations on this input are weaker. It expects:
#! * <A>grp</A> to be a subgroup of `AAut(UnderlyingCgrOfColorSet(cset))`,
#! * <A>stab</A> to be a subgroup of the set-wise stabilizer of `AsSet(cset)` in <A>grp</A>.
#! These two expectations are not checked either. Otherwise it does the same like 
#! `CHadamardSetOrbitNC`.
#! @Arguments grp,cset[,stab]
DeclareGlobalFunction( "CHadamardSetOrbit" );   
#! @Arguments grp,cset[,stab]
DeclareGlobalFunction( "CHadamardSetOrbitNC" );  
#! @EndGroup

#! @Description
#! Computes all orbits of core Hadamard sets of the well-fibred J-stable color graph <A>cgr</A> 
#! under <A>grp</A>. The group <A>grp</A> is expected to be a subgroup of `JAut(cgr)`. If 
#! <A>grp</A> is not given, then it is taken to be equal to `JAut(cgr)`. 
#! @Arguments cgr[,grp] 
DeclareAttribute( "CHadamardSetOrbits", IsColorGraph and IsJStableColorGraph );

