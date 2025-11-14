#! @Chapter pcolpart

#! @Section Types

#! @Description
#! The abstract data type of partial color partitions.
DeclareCategory( "IsPartialColorPartition", IsCocoPartialStablePartition );

#! @Section Constructors
#! This function gets as input a partial color partiton <A>ppart</A>. It returns the constructor
#! for this type of partial color partitions.
#! @Arguments ppart
DeclareOperation( "ConstructorOfPartialColorPartition", [IsPartialColorPartition]);

#! @Section Internal partitions

#! @Description
#! This function takes as input an internal partitoin <A>ipart</A> and a color set <A>gs</A>
#! If no class of <A>ipart</A> contains `AsSet(<A>gs</A>)`, then fail is returned. Otherwise
#! this class is splitt into two parts, one of them being equal to `AsSet(<A>gs</A>)`.
#! The new parts are marked as instable the class `AsSet(<A>gs</A>)` is marked as fixed.
#! If  <A>gs</A> is asymmetric, then this process is repeated with the mate of <A>gs</A>.
#! @Arguments ipart, gs
DeclareGlobalFunction( "RefinedInternalPartition" );     # undocumented


#! @Description
#! This function gets as input a partial color partition <A>ppart</A>, a color set <A>gs</A>,
#! and an internal pertition <A>ipart</A> encoding some partial color partition.
#! It computes $\phi(M)$, where $M$ is the partial color partition that is 
#! encoded by <A>ipart</A>. During the stabilization process,
#! whenever a class splits, the new classes are tested against <A>gs</A>. If any of them 
#! is smaller than <A>gs</A> with respect to short-lex ordering, then `fail` is returned.
#! Also when a fixed class needs to split during the stabilization, `false` is returned.
#! When everything goes well, a stable internal partition is returned. This operation is 
#! implemented by the  various subtypes of `IsPartialColorPartition`. The argument ppart 
#! is used only to  determin, which stabilization method should be used. This function 
#! changes the internal partition <A>ipart</A>  in place.
#! @Arguments ppart, gs, ipart
DeclareOperation("StabilizedInternalPartition", [IsPartialColorPartition, IsColorSet, IsRecord] );
