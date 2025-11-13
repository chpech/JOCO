#############################################################################
##
##  jfusion.gd                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Declarations for the datatype of Jordan fusions
##
#############################################################################

#! @Chapter jordanfus

#! @Section Properties

#! @Description
#! The property of a color partition to be a Jordan fusion
DeclareProperty( "IsJordanFusion", IsColorPartition );



################################################################################

#! @Section Orbits of Jordan fusions
 
#! @Description
#! Computes all orbits of homogeneous  Jordan fusions of <A>cgr</A> under <A>grp</A>. The group
#! <A>grp</A> is expected to be a subgroup of `JAut(cgr)`. If <A>grp</A> is not given, then 
#! it is taken to be equal to `JAut(cgr)`. If the option `:sym` is given, then only 
#! those Jordan fusions are computed whose classes are symmetric regular sets.
#! @Arguments cgr[,grp] :sym
DeclareAttribute( "HomogeneousJordanFusionOrbits", IsColorGraph and IsJStableColorGraph );


#! @Description
#! This function expects a list <A>lfus</A> of orbits of color partitions of the same family 
#! (usually this means that they are living over the same color graph and the same group). It creates a coco poset.
#! an orbit `orb1` is below an orbit `orb2` if some member of `orb1` is coarser than some member of
#! `orb2`. The returned poset can be displayed or inspected in &XGAP; or &GAPAPP;, or &FRANCY;.
#! @Arguments lfus
DeclareGlobalFunction( "PosetOfFusionOrbits" );

#! @Description
#! @Arguments pos [, idx] : options
#DeclareOperation( DisplayString, [IsPosetOfFusionOrbits and IsPosetOfFusionOrbitsRep]);
