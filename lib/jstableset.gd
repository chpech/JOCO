#! @Chapter JStableSet
#! @Section Theory
#! Let $R$ be a relation of a set $V$
#! We call $R$ __J-stable__ if there exists a J-stable color graph $(V,C,f)$ and a color 
#! $c\in C$, such that $R = R_c$
#!
#! In &JOCO; we call a set of colors $M$ of a color graph $(V,C,f)$ __J-stable__ if its 
#! associated relation $R_M$ is J-stable. Note that regular J-stable sets are automatically
#! J-arc regular regular J-stable sets  may be enumerated in well-fibred J-stable color graphs.


#! @Section Properties
#! @Description
#! The property of a color set to be J-stable 
#! (see Chapter <Ref Sect='Chapter_ColorSets'/>).
DeclareProperty( "IsJStableSet", IsColorSet );

#! @Section Orbits of regular J-stable sets 

#! @BeginGroup RegularJStableSetOrbits

#! @Description
#! Computes all orbits of regular J-stable sets of the well-fibred J-stable  color graph
#! <A>cgr</A> under <A>grp</A>. The group
#! <A>grp</A> is expected to be a subgroup of `JAut(cgr)`. If <A>grp</A> is not given, then 
#! it is taken to be equal to `JAut(cgr)`. If the option `:sym` is given, then only 
#! symmetric regular WL-stable sets are computed.
#! @Arguments cgr[,grp] :sym
DeclareOperation( "HomogeneousJStableSetOrbits", [IsColorGraph and IsJStableColorGraph] );

#! @Arguments cgr[,grp] :sym
DeclareAttribute( "HomogeneousSymJStableSetOrbits", IsColorGraph and IsJStableColorGraph ); 

#! @Arguments cgr[,grp] :sym
DeclareAttribute( "HomogeneousAsymJStableSetOrbits", IsColorGraph and IsJStableColorGraph); 
#! @EndGroup
