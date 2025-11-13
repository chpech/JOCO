#############################################################################
##
##  arcregset.gd                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Declarations for the datatype of arc regular sets 
##
#############################################################################

#! @Chapter ArcRegSet
#! Let $R$ be a relation of a set $V$
#! with $o(u,v)$ we denote $|\{w | (u,w), (v,w) \in R \}|$, and
#! in &JOCO; we call a set of colors $M$ with associated relation $R_M$ __arc regular__ if 
#!  * $R_M$ is irreflexive,
#!  * $R_M$ is symmetric or asymmetric,
#!  * $M$ is regular,
#!  * there is a number $\lambda$ such that for all $(u,v)\in R_M$ we have
#!       $$          o(u,v) = \lambda. $$
#! Arc regular sets may be enumerated in WL-stable color graphs.


#! @Section Properties
#! @Description
#! The property of a regular set to be arc regular 
#! (see Chapter <Ref Sect='Chapter_regsets'/>).
DeclareProperty( "IsArcRegularSet", IsRegularSet );


#! @Section Orbits of arc regular sets 
#! @BeginGroup ArcRegularSetOrbits
#! @Description
#! Computes all orbits of arc regular sets of the WL-stable color graph
#! <A>cgr</A> under <A>grp</A>. The group
#! <A>grp</A> is expected to be a subgroup of `AAut(cgr)`. If <A>grp</A> is not given, then 
#! it is taken to be equal to `AAut(cgr)`. If the option `:sym` is given, then only 
#! symmetric arc regular sets are computed.
#! @Arguments cgr[,grp] :sym
DeclareOperation( "HomogeneousArcRegularSetOrbits", [IsColorGraph and IsWLStableColorGraph] );

#! @Arguments cgr[,grp]
DeclareAttribute( "HomogeneousSymArcRegularSetOrbits", IsColorGraph and IsWLStableColorGraph ); 

#! @Arguments cgr[,grp]
DeclareAttribute( "HomogeneousAsymArcRegularSetOrbits", IsColorGraph and IsWLStableColorGraph); 
#! @EndGroup
