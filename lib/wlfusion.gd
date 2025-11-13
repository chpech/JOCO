#############################################################################
##
##  wlfusion.gd                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Declarations for the datatype of WL-stable fusions
##
#############################################################################

#! @Chapter wlfusion

#! @Section Properties

#! @Description
#! The property of a color partition to be a WL-stable fusion
DeclareProperty( "IsWLFusion", IsColorPartition );

 
#! @Section Orbits of WL-stable fusions
 
#! @Description
#! Computes all orbits of homogeneous  WL-fusions of <A>cgr</A> under <A>grp</A>. The group
#! <A>grp</A> is expected to be a subgroup of `AAut(cgr)`. If <A>grp</A> is not given, then 
#! it is taken to be equal to `AAut(cgr)`. If the option `:sym` is given, then only 
#! those WL-fusions are computed whose classes are symmetric WL-stable sets.
#! @Arguments cgr[,grp] :sym
DeclareAttribute( "HomogeneousWLFusionOrbits", IsColorGraph and IsWLStableColorGraph );



