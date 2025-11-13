#! @Chapter WLStableSet
#! @Section Theory
#! Let $R$ be a relation of a set $V$
#! We call $R$ __WL-stable__ if there exists a WL-stable color graph $(V,C,f)$ and a color 
#! $c\in C$, such that $R = R_c$
#!
#! In &JOCO; we call a set of colors $M$ of a color graph $(V,C,f)$ __WL-stable__ if its 
#! associated relation $R_M$ is WL-stable. Note that regular WL-stable sets are automatically
#! arc regular
#! regular WL-stable sets  may be enumerated in WL-stable color graphs.

#! @Section Properties

#! @Description
#! The property of a color set to be WL-stable 
#! (see Chapter <Ref Sect='Chapter_ColorSets'/>).
DeclareProperty( "IsWLStableSet", IsColorSet );

#! @Section Orbits of regular WL-stable sets 

#! @BeginGroup RegularWLStableSetOrbits
#! @Description
#! Computes all orbits of regular WL-stable sets of the WL-stable  color graph
#! <A>cgr</A> under <A>grp</A>. The group
#! <A>grp</A> is expected to be a subgroup of `AAut(cgr)`. If <A>grp</A> is not given, then 
#! it is taken to be equal to `AAut(cgr)`. If the option `:sym` is given, then only 
#! symmetric regular WL-stable sets are computed.
#! @Arguments cgr[,grp] :sym
DeclareOperation( "HomogeneousWLStableSetOrbits", [IsColorGraph and IsWLStableColorGraph] );

#! @Arguments cgr[,grp]
DeclareAttribute( "HomogeneousSymWLStableSetOrbits", IsColorGraph and IsWLStableColorGraph ); 

#! @Arguments cgr[,grp]
DeclareAttribute( "HomogeneousAsymWLStableSetOrbits", IsColorGraph and IsWLStableColorGraph); 
#! @EndGroup
