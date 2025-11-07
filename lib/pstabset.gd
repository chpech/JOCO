#! @Chapter PStabSet

#! @Section Theory
#! Partial stable sets are an abstract data-type. 

#!Given a universe $\{1,\dots,n\}$ and an ordered partition $(M_1,\dots,M_k)$ on it.
#! Let $\chi\colon\{1,\dots,n\}\to\{1,\dots,k\}$ be the unique map with the property
#! that $\chi(i)$ is the unique $j$ with the property that $i\in M_j$.
#!
#! Given further a family $F$ of subsets of $\{1,\dots,n\}$ such that for every $M \in F$ holds
#! condition (*): 
#!    $$  \forall i : i \in M \Rightarrow M_{\chi(i)} \subseteq M.$$
#! The elements of $F$ are called __stable sets__.
#!
#! A family $F'$ of subsets of $\{1,\dots,n\}$ is called a family of __partial stable sets__ 
#! for $F$ if: 
#! * (1) each of its elements satisfies (*),
#! * (2) every subset satisfying (*) that is contained in some element of $F'$ is also in $F'$,
#! * (3) every element of $F$ is in $F'$.
#! 
#! An element of $F'$ is called __complete__ if it is in $F$.
#! 
#! The __domain__ of some $M$ from $F'$ consists of all elements j of $\{1,\dots,k\}$ such that
#! * (a) $M_j \cap M = \emptyset$,
#! * (b) $M \cup M_j \in F'$.
#!
#! When talking about orbits of partial stable sets then we have in mind a 
#! permutation group $G$ on $\{1,\dots,n\}$ such that
#! *   (i) $G$ leaves invariant $\{M_1,\dots,M_k\}$ (in action `OnSetsSets`),
#! *  (ii) $G$ leaves invariant $F'$ (in action `OnSetsSets`),
#! * (iii) $G$ leaves invariant $F$ (in action `OnSetsSets`).
#! In such a setting orbit representatives of $G$ on $F$ may be found by enumerating orbit 
#! representatives of $G$ on $F'$ and returning only the complete ones.
#! The efficiency of this aproach depends strongly on the clever choice of $F'$
#! Generally, the smaller is $F'$, the more efficient the approach becomes.

#! @Description
#! The abstract data type of stable sets. Other types like `IsColorSet` are derived from this type.
DeclareCategory("IsCocoStableSet", IsObject );

#! @Description
#! The abstract data type of partial stable sets. Other datatypes like `IsPartialRegularSet`, 
#! `IsPartialHadamardSet`, `IsPartialArcRegularSet`, or `IsPartialJArcRegularSet` are derived 
#! from this type. 
DeclareCategory("IsCocoPartialStableSet", IsObject );

#! @Description
#! Returns `true` if the partial stable set <A>pgs</A> is empty, `false` otherwise.
#! @Arguments pgs
DeclareOperation( "IsEmptyPartialStableSet", [IsCocoPartialStableSet] );


#! @Description
#! Returns the ordered partition $(M_1,\dots,M_k)$ for the type of partial stable sets that 
#! <A>pgs</A> belongs to (see above...).
#! @Arguments pgs
DeclareOperation( "IMapOfPartialStableSet", [IsCocoPartialStableSet] );

#! @Description
#! Returns the domain of <A>pgs</A> for the type of partial stable sets that 
#! <A>pgs</A> belongs to (see above...).
#! @Arguments pgs
DeclareOperation( "DomainOfPartialStableSet", [IsCocoPartialStableSet] );                            # internal

#! @Description
#! Returns `true` if the partial stable set <A>pgs</A> is complete, `false` otherwise.
#! @Arguments pgs
DeclareProperty( "IsCompletePartialStableSet", IsCocoPartialStableSet );



#! @Description
#! `ExtendedPartialStableSet` extends the partial stable set <A>pgs</A> by one point from its domain.
#! If during the process of extension it becomes clear that the new partial stable set 
#! can not be completed to a complete partial stable set, then `ExtendedPartialStableSet` 
#! may return `fail` instead of a new partial stable set. If it becomes clear that no other point 
#! can lead to a new completable partial stable set, then `ExtendedPartialStableSet` may return 
#! the value `nonextensible` (a synonym for `false`).
#! @Arguments pgs,pt
DeclareOperation( "ExtendedPartialStableSet", [IsCocoPartialStableSet, IsPosInt] );                  # internal


#! @Description This operation translates from a datatype of partial stable sets to 
#! the corresponding datatype of stable sets. Its input is a complete partial stable 
#! set <A>pgs</A>. Its output is the corresponding stable set. 
#! @Arguments pgs
DeclareOperation( "StableSetFromPartialStableSet", [IsCocoPartialStableSet] );


DeclareGlobalName( "nonextensible" );


################################################################################

#! @Section Orbits
#! @SectionTitle Orbits of (partial) stable sets 

#! @Description
#! The abstract data type of orbits of partial stable set orbits
DeclareCategory( "IsPartialStableSetOrbit", IsCocoOrbit );

#! @Description 
#! Constructs a new object representing the orbit of the partial stable set <A>pgs</A>
#! under the permutation group <A>G</A>, where the set-wise stabilizer of <A>pgs</A> 
#! in <A>G</A> is equal to <A>H</A>. It is not checked whether <A>H</A> is really equal to 
#! the setwise stabilizer.
#! @Arguments G,pgs,H
DeclareOperation( "PartialStableSetOrbitNC", [IsPermGroup, IsCocoPartialStableSet, IsPermGroup] );

#! @Description
#! Returns the construcror of stable set orbits that corresponds to the type of stable sets that 
#! <A>gs</A> belongs to. 
#! @Arguments gs
DeclareOperation( "ConstructorOfStableSetOrbit", [IsCocoStableSet] );


#! @Description
#! Returns the family of orbits of partial stable sets of the same type as <A>pgs</A> with 
#! respect to the permutation group <A>G</A>.
#! @Arguments pgs,G
DeclareOperation( "GetPartialStableSetOrbitFamily", [IsCocoPartialStableSet, IsPermGroup] );

                
                
################################################################################

#! @Section Iterators
#! @SectionTitle Iterators of orbits of partial stable sets

#! @Description 
#! The data type of iterators of orbits of partial stable sets
DeclareCategory( "IsIteratorOfPartialStableSetOrbits", IsIterator );


#! @Description
#! This operation gets as input a permutation group <A>G</A> and an empty partial stable set 
#! <A>pgs</A> of some kind. It returns an iterator of all <A>G</A>-orbits of partial stable sets
#! of this type. The group <A>G</A> needs to preserve the partition $\{M_1,\dots,M_k\}$ 
#! (in action OnSetsSets) corresponding  to the kindtype  of partial stable sets that 
#! <A>pgs</A> belongs to (see above...). 
#! @Arguments G,pgs
DeclareOperation( "IteratorOfPartialStableSetOrbits", [IsPermGroup, IsCocoPartialStableSet] );                     # internal


#! @Description
#! This function gets as input an iterator of orbits of partial stable sets (not necessarily 
#! in initial state). It iterates the iterator till the end and returns all orbits of 
#! stable sets encountered on the way. As a side effect, the iterator is spent (done) 
#! et the end.
#! @Arguments iter
DeclareOperation( "AllStableSetOrbits", [IsIteratorOfPartialStableSetOrbits] );  


#! @Description
#! This function returns the action homomorphism of the group $G$ with respect to which orbits 
#! are considered on the partition $\{M_1,\dots,M_k\}$ corresponding to the type partial stable 
#! sets for which <A>iter</A> computes $G$-orbits. If <A>iter</A> is already done, then `fail` is
#! returned. This is needed when recovering an actual partial stable set from its internal 
#! representation used by the iterator.
#! @Arguments iter
DeclareOperation( "ActionOfPartialStableSetOrbitIterator",  [IsIteratorOfPartialStableSetOrbits] );

