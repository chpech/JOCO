#############################################################################
##
##  jarcregset.gd                 JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Declarations for the datatype of J-arc regular sets 
##
#############################################################################

#! @Chapter JArcRegSet
#! @Section Theory
#! Let $R$ be a relation of a set $V$
#! with $o(u,v)$ we denote $|\{w | (u,w), (v,w) \in R \}|$, and
#! with $i(u,v)$ we denote $|\{w | (w,u), (w,v) \in R \}|$.
#! in &JOCO; we call a set of colors $M$ with associated relation $R_M$ __J-arc regular__ if 
#!  * $R_M$ is irreflexive,
#!  * $R_M$ is symmetric or asymmetric,
#!  * $M$ is regular,
#!  * there is a number $\lambda$ such that for all $(u,v)\in R_M$ we have
#!       $$          o(u,v) + i(u,v) = \lambda. $$
#! J-Arc regular sets may be enumerated in well-fibred J-stable color graphs.

#! @Section Properties

#! @Description
#! The property of a regular set to be J-arc regular 
#! (see Chapter <Ref Sect='Chapter_regsets'/>).
DeclareProperty( "IsJArcRegularSet", IsRegularSet );

#! @Section Orbits of J-arc regular sets 
#! @BeginGroup JArcRegularSetOrbits
#! @Description
#! Computes all orbits of J-arc regular sets of the well-fibred J-stable color graph
#! <A>cgr</A> under <A>grp</A>. The group
#! <A>grp</A> is expected to be a subgroup of `JAut(cgr)`. If <A>grp</A> is not given, then 
#! it is taken to be equal to `JAut(cgr)`. If the option `:sym` is given, then only 
#! symmetric J-arc regular sets are computed.
#! @Arguments cgr[,grp] :sym
DeclareOperation( "JArcRegularSetOrbits", [IsColorGraph and IsJStableColorGraph] );

#! @Arguments cgr[,grp]
DeclareAttribute( "SymmetricJArcRegularSetOrbits", IsColorGraph and IsJStableColorGraph ); 

#! @Arguments cgr[,grp]
DeclareAttribute( "AsymmetricJArcRegularSetOrbits", IsColorGraph and IsJStableColorGraph); 
#! @EndGroup
