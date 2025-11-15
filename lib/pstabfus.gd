#! @Chapter pstabfus
#! @Section Theory
#! <List>
#! <Mark>Partitions:</Mark> 
#!      <Item> Let $X$ be a finite set (totally ordered by $&lt;$, and let $P$ be a 
#!      set of partitions of $X$. On $P$ we consider the refinement order: a 
#!      partition $\pi_1$ is said to be __finer__ than the partition $\pi_2$ if 
#!      every class of $\pi_2$ is the union of classes of $\pi_1$. We require that 
#!      $P$ is closed with respect to $\land$ of partitions. Here $\pi_1 \land \pi_2$ 
#!      is the finest partition coarser than both, $\pi_1$ and $\pi_2$. Also, let 
#!      $G$, the group of all permutations of $X$ that maps elements of $P$ to elements  
#!      of $P$ (in the natural action on sets of subsets of $X$). </Item>
#! <Mark>Partial partitions:</Mark>
#!      <Item> A tuple $M=(M_1,\dots,M_m)$ of pairwise disjoint non-empty 
#!      subsets of $X$ is called a __partial partition__ if 
#!          - for all i &lt; j we have that $M_i &lt; M_j$ in the shortlex ordering, 
#!          - there exists a partition $\pi\in P$ with 
#!            $M^s := \{M_i\mid 1\le i\le m\} \subseteq \pi$, such that all classes 
#!            of $\pi$ not in $M$ are greater than all elements of $M$, with respect 
#!            to the shortlex ordering of subsets of $X$. 
#!
#!      </Item>
#! <Mark>Complete partial partitions:</Mark> 
#!    <Item>A partial partition $M$ is called __complete__ if
#!     there is a partition $\pi\in P$ with $M^s\subseteq \pi$ and such that all 
#!     classes of $\pi$ not in $M^s$ have a larger cardinality than all elements of
#!     $M^s$.</Item>
#! <Mark>Partitions from partial partitions:</Mark> 
#!    <Item> By $\phi(M)$ we denote the coarsest partition 
#!      from $P$ that contains $M^s$ (exists because $P$ is closed with respect to 
#!      $\land$). We also say that $M$ generates $\phi(M)$.</Item>
#! <Mark>Partial partitions from partitions:</Mark> 
#!    <Item> Every partition $\pi$ from $P$ gives rise to a 
#!     partial partition $\psi(\pi)$ conisting of all classes of $\pi$ ordered by
#!     shortlex.</Item>
#! <Mark>Irredundant partial partitions:</Mark>
#!    <Item> A partial partition $M$ is called __irredundant__
#!     if for the partial partition $M'$ obtained from $M$ by removing the last element
#!     we have $\phi(M') \neq \phi(M)$.</Item>
#! <Mark>Observation A:</Mark> 
#!    <Item> Partial partitions are themself ordered by a shortlex ordering, 
#!     where the primery soring criterion is the number of classes, and where partial
#!     partition with the same number of classes are sorded lexicographically,
#!     using the shortlex ordering of subsets of $X$.</Item>
#! <Mark> Observation B:</Mark>
#!    <Item> Let $\pi\in P$ and let $M$ be a partial partition with $\phi(M)=\pi$. 
#!     Then $M$ is a prefix of $\psi(\pi)$. The smallest complete partial partition 
#!     that generates $\pi$ is called the __base__ of $\pi$ (exists because 
#!     $\psi(\pi)$ is a complete partial partition).</Item>
#! <Mark>Observation C:</Mark> 
#!    <Item> Every partition from $P$ has a unique base and a unique irredundant 
#!     generating partial partition.</Item>
#! <Mark>HasSmallerBase:</Mark> 
#!    <Item> A partial partition $M$ is said to have a __smaller base__ if it 
#!     has a prefix $M'$ that is complete, and such that $\phi(M)=\phi(M')$.</Item>
#! </List>

#! @Section Types

#! @Description
#! The abstract data type of stable partitions. Other types like `IsColorPartition` are derived 
#! from this type.
DeclareCategory("IsCocoStablePartition", IsObject );



#! @Description
#! The abstract data type of partial stable partitions. Other datatypes like `IsPartialRegularFusion`, 
#! `IsPartialJordanFusion`, or `IsPartialWLFusion` are derived from this type. 
DeclareCategory("IsCocoPartialStablePartition", IsObject );


#! @Section Functions for the inspection of partial stable partitions

#! @Description
#! Returns `true` if the partial stable partition <A>ppart</A> is empty, `false` otherwise.
#! @Arguments ppart
DeclareOperation( "IsEmptyPartialStablePartition", [IsCocoPartialStablePartition] );



#! @Description
#! Returns `true` if adding the stable set  <A>gs</A> to the partial stable partition <A>ppart</A>
#! results in another partial stable partition, `false` otherwise.
#! @Arguments ppart,gs
DeclareOperation( "IsCompatibleWithPartialStablePartition", [IsCocoPartialStablePartition, IsCocoStableSet] );


#! @Description
#! Returns the rank of $\phi(M)$ of the partial partiton represented by the input <A>ppart</A>
#! @Arguments ppart
DeclareAttribute("RankOfPartialStablePartition", IsCocoPartialStablePartition );

#! @Section Properties

#! @Description
#! Returns the rank of $\phi(M)$ of the partial partiton represented by the input <A>ppart</A>
#! @Arguments ppart
DeclareProperty( "IsIrredundantPartialStablePartition", IsCocoPartialStablePartition );

#! @Description
#! Returns the `true` if the partial stable setpartition <A>ppart</A> is complete 
#! (see Section <Ref Sect='Chapter_pstabfus_Section_Theory'/>),
#! and `false` otherwise.
#! @Arguments ppart
DeclareProperty( "IsCompletePartialStablePartition", IsCocoPartialStablePartition );


#! @Description
#! Let $M$ be the partial stable partition represented by <A>ppart</A>. This function
#! returns `true` if $M$ is not the base of $\phi(M)$ 
#! (see Section <Ref Sect='Chapter_pstabfus_Section_Theory'/>),
#! and `false` otherwise.
#! @Arguments ppart
DeclareProperty( "PartialStablePartitionHasSmallerBase", IsCocoPartialStablePartition );

#! @Section Constructors

#! @Description
#! `ExtendedPartialStablePartition` extends the partial stable partition <A>ppart</A> with
#! by a stable set <A>gs</A>. If this is impossible for some reason, then `fail` is returned,
#! otherwise the new extended partial stable partition is returned.
#! @Arguments ppart,gs
DeclareOperation( "ExtendedPartialStablePartition", [IsCocoPartialStablePartition, IsCocoStableSet] );



#! @Description This operation translates from the data type of partial stable partitions to 
#! the corresponding data type of stable partitions. Its input is a complete partial stable 
#! partition <A>ppart</A>. Its output is the corresponding stable partition. 
#! @Arguments pgs
DeclareOperation( "StablePartitionFromCompletePartialStablePartition", [IsCocoPartialStablePartition ] );

############################################################################################

#! @Section Orbits of (partial) stable partitions 

#! @Description
#! The abstract data type of orbits of partial stable partitions. It is directly derived from 
#! `IsCocoOrbit`.
DeclareCategory( "IsPartialStablePartitionOrbit", IsCocoOrbit );


#! @Description 
#! Constructs a new object representing the orbit of the partial stable partiton <A>ppart</A>
#! under the permutation group <A>grp</A>. The following expectations are made on the input:
#! * The stabilizer `OnSetsSets` of <A>ppart</A> in <A>grp</A> is equal to <A>stab</A>;
#! * ppartis the smallest element in its orbit with respect to the short lex ordering. 
#! It is not checked whether these conditions are acually fulfilled.
#! @Arguments grp,ppart,stab
DeclareOperation( "PartialStablePartitionOrbitNC", [IsPermGroup, IsCocoPartialStablePartition, IsPermGroup] );

#! @BeginGroup ConstructorOfStablePartitionOrbit
#! @Description
#! Returns the constructor of stable partition orbits that corresponds to the type of stable 
#! partitions that <A>ppart</A> belongs to. 
#! @Arguments ppart. 
DeclareOperation( "ConstructorOfStablePartitionOrbit", [IsCocoStablePartition] );
DeclareOperation( "ConstructorOfStablePartitionOrbitNC", [IsCocoStablePartition] );
#! @EndGroup

#! @Description
#! Returns the family of orbits of partial stable partitions of the same type as <A>ppart</A> 
#! with  respect to the permutation group <A>grp</A>.
#! @Arguments ppart,grp
DeclareOperation( "GetPartialStablePartitionOrbitFamily", [IsCocoPartialStablePartition, IsPermGroup] );


################################################################################

#! @Section Iterators of orbits of partial stable partitions

#! @Description 
#! The data type of iterators of orbits of partial stable partitions
DeclareCategory( "IsIteratorOfPartialStablePartitionOrbits", IsIterator );


#! @Description
#! This operation gets as input a permutation group <A>grp</A> and an empty partial stable 
#! partition  <A>ppart</A> of some kind. It returns an iterator of all <A>grp</A>-orbits of 
#! partial stable partitions of this type.  
#! @Arguments grp, ppart
DeclareOperation( "IteratorOfPartialStablePartitionOrbits", [IsCocoPartialStablePartition, IsList] );


#! @Description
#! This function gets as input an iterator of orbits of partial stable partitions 
#! (not necessarily in initial state). It iterates the iterator till the end and returns 
#! all orbits of stable partitions encountered on the way. As a side effect, the iterator 
#! is spent (done) et the end.
#! @Arguments iter
DeclareOperation( "AllStablePartitionOrbits", [IsIteratorOfPartialStablePartitionOrbits] );





