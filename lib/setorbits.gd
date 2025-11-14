#! @Chapter setorbits

#! @Section Types and families

#! @Description
#! The data type of set orbits. It is derived from the abstract type IsCocoSetOrbit
DeclareCategory( "IsSetOrbit", IsCocoSetOrbit );

#! @Description
#! The Families of set orbits. For every permutation group another family is created.
#! @Arguments grp
DeclareAttribute( "SetOrbitsFamily",  IsPermGroup );

#! @Section Constructors
#! @BeginGroup SOconstructors
#! @Description
#! `SetOrbitNC` expects as input a permutation group <A>grp</A>, a set <A>set</A>,
#! and a subgroup <A>stab</A> of <A>grp</A>. It expects
#! * <A>grp</A> to be a permutation group,
#! * <A>set</A> to be the smallest element of its orbit under <A>grp</A> (in action `OnSets`),
#! * <A>stab</A> to be the set-wise stabilizer of <A>set</A> in <A>grp</A>.
#! None of this is checked. The function returns an object representing the orbit of <A>set</A>
#! under <A>grp</A> with respect to the action `OnSets`.
#!
#! `SetOrbit gets the same kind of input like `SetOrbitNC. However, its expectations
#! on this input are weaker. It expects:
#! * <A>grp</A> to be a permutation group,
#! * <A>stab</A> to be a subgroup of the set-wise stabilizer of <A>set</A> in <A>grp</A>.
#! These two expectations are not checked either. Otherwise it does the same like
#! `SetOrbitNC`.
#! @Arguments group,gs[,stab]
DeclareGlobalFunction( "SetOrbit" );
#! @Arguments group,gs[,stab]
DeclareGlobalFunction( "SetOrbitNC" );
#! @EndGroup

#! @Description
#! This function expects a permutation group <A>grp</A>, a set <A>dom</A> invariant under <A>grp</A> 
#! (in the action `OnPoints`), and, optionally, a set <A>sizes</A>. If sizes is not given, 
#! then `sizes:=[1..Int(Length(dom)/2)]` is assumed. The function lets <A>grp</A> act on the
#! set of all subsets of <A>dom</A> whose cardinality is contained in <A>sizes</A> (`OnSets`).
#! it returns the set of orbits of <A>grp</A> on these sets. Every orbit is represented by its
#! lexicographically smallest representative and by the set-wise stabilizer of this 
#! representative. 
#! <A>dom</A> `OnPoints`
#! @Arguments grp, dom [,sizes]
DeclareGlobalFunction( "AllSetOrbits" );


################################################################################
#! @Section Iterators of set orbits

#! @Description 
#! The data type of iterators of set orbits
DeclareCategory( "IsIteratorOfSetOrbits", IsIterator );


#! @Description
#! This operation gets as input a permutation group <A>grp</A>, a set <A>dom</A> on which
#! <A>grp</A> acts `OnPoints`, and a set <A>sizes</A> of positive integers.
#! It returns an iterator of all <A>grp</A>-orbits of subsets of <A>dom</A> whose cardinality 
#! is an element of <A>sizes</A>.  
#! @Arguments grp,dom,sizes
DeclareOperation( "IteratorOfSetOrbits", [IsPermGroup, IsList, IsList] ); 


#! @Description
#! This function gets as input an iterator of set orbits (not necessarily 
#! in initial state). It iterates the iterator till the end and returns all set orbits  
#! encountered on the way. As a side effect, the iterator is spent (done) at the end.
#! @Arguments iter
DeclareOperation( "AllSetOrbitsFromIterator", [IsIteratorOfSetOrbits] );  

#! @Description
#! As they are implemented, iterators of set orbits know the next set orbit before
#! `NextIterator` is invoked. The function NextSetOrbit returns the orbit of the empty 
#! set if <A>iter</A> is in the initial state (even if $0$ is not in `sizes`) or the 
#! setorbit that is going to be returned by `NextIterator<A>(iter</A>)`.
#! @Arguments iter
DeclareOperation( "NextSetOrbit", [IsIteratorOfSetOrbits] );

#! @Description
#! Suppose that `NextSetOrbit(<A>iter</A>)` returnes the set orbit
#! with lexicographically smallest representative $M$. Then invoking `RejectSetOrbit(<A>iter</A>)` 
#! has the effect that the iterator cuts off all set-orbits whose smallest representatives contain
#! $M$. 
DeclareOperation( "RejectSetOrbit", [IsIteratorOfSetOrbits] );

DeclareGlobalFunction( "NumberOrbitsPerm@JOCO" );

