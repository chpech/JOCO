#############################################################################
##
##  regfusion.gd                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Declarations for the datatype of regular fusions
##
#############################################################################

#! @Chapter regfusion
#! @Section Theory
#! Let $(V,C,f)$ be a rainbow.
#! We call a partition $\Pi=\{M_1,\dots,M_k\}$ of $C$ a __regular fusion__ of $(V,C,f)$ if
#! * for some $r\in\{1,\dots,k\}$,  $M_r$ consists of all reflexive colors of $(V,C,f)$,
#! * every other class of $\Pi$ is a regular set,
#! * For every $i\in\{1,\dots,k\}$ there exists a $j\in\{1,\dots,k\}$ such that
#!   $A_{M_i}^t=A_{M_j}$.

#! @Section Properties

#! @Description
#! The property of a color partition to be a regular fusion 
DeclareProperty( "IsRegularFusion", IsColorPartition );


#! @Section Orbits of regular fusions

#! @Description
#! Computes all orbits of regular fusions of <A>cgr</A> under <A>grp</A>. The group
#! <A>grp</A> is expected to be a subgroup of `RAut(cgr)`. If <A>grp</A> is not given, then 
#! it is taken to be equal to `RAut(cgr)`. If the option `:sym` is given, then only 
#! regular fusions are computed whose classes are symmetric regular sets.
#! @Arguments cgr[,grp] :sym
DeclareAttribute( "RegularFusionOrbits", IsColorGraph and IsRainbow and IsStableRainbow );


