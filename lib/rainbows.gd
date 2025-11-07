#! @Chapter Rainbows 
#!  @Section Theory
#! A color graph $(V,C,f)$ is called a __rainbow__ if 
#! * There exists a subset $I$ of $C$ such that for all $v,w \in V$ we have 
#!       $$ f(v,w) \in I \iff v = w. $$
#! * For every $i\in C$ there exists some $j\in C$ such that for all $v,w\in V$ we have
#!       $$ f(v,w) = i \iff f(w,v) = j.$$
#! The elements of $I$ are called the __reflexive colors__ of $(V,C,f)$. 
#! Each element of $i\in I$ determines a __fibre__ $F_i$ of $(V,C,f)$ defined by
#!         $$ F_i := \{ v\in V\mid f(v,v) = i\}. $$
#! The fibres partition the vartex set $V$. This partition is called the __fibre partition__ 
#! of $(V,C,f)$
#! 
#! The __vertex partition__ of a rainbow $(V,C,f)$ is the partition of $V$ corresponding to
#! the following equivalence relation:
#!          $$ v \sim w :\iff \{f(v,x)\mid x\in V \} = \{f(w,x)\mid x\in V \}.$$
#! The equivalence classes of the vertex partiton are called __weak fibres__
#!
#! The fibre partition and the vertex partition of $(V,C,f)$ need not be equal. If they are 
#! then we call $(V,C,F)$ __well-fibred__. 
#!
#! A rainbow $(V,C,f)$ is called __stable__ if its vertex partition is __equitable__. This means 
#! that for all classes  $M_1,M_2$ of the vertex partition of $(V,C,f)$ and every $i\in C$ there 
#! is a number $n_i(M_1,N_2)$ such that for every vertex $v\in M_1$ the set
#!       $$ \{ w\in M_2 \mid f(v,w) = i \} $$
#! has exactly $n_i(M_1,M_2)$ elements.
#!
#! A rainbow is called __homogeneous__ if it has just one fibre. Note that there exist homogeneous 
#! rainbows with more than one weak fibre.
#! 
#! A homogeneous rainbow $(V,C,f)$ is called __thin__ if for every $v\in V$ and for every 
#! $i\in C$ there is  at most one $w\in V$, such that $f(v,w)=i$.




#! @Section Properties
#! @SectionTitle Properties of rainbows

#! @Description
#! Returns `true` if the color graph <A>cgr</A> is a rainbow, otherwise `false`.
#! @Arguments cgr
DeclareProperty( "IsRainbow",   IsColorGraph );

#! @Description
#! Returns `true` if the rainbow <A>cgr</A> is stable, `false` otherwise.
#! @Arguments cgr
DeclareProperty( "IsStableRainbow", IsColorGraph and IsRainbow );


#! @Description
#! Returns `true` if the rainbow <A>cgr</A> is well-fibred, `false` otherwise.
#! @Arguments cgr
DeclareProperty( "IsWellFibredRainbow", IsColorGraph and IsRainbow );


#! @Description
#! Returns `true` if the rainbow <A>cgr</A> is thin, `false` otherwise.
#! @Arguments cgr
DeclareProperty("IsThin", IsColorGraph and IsRainbow );


#! @Description
#! Returns `true` if the rainbow <A>cgr</A> is quasithin, `false` otherwise.
#! @Arguments cgr
DeclareProperty("IsQuasithin", IsColorGraph and IsRainbow );


#! @Section Inspection
#! @SectionTitle Functions for the inspection of rainbows

#! @Description
#! Returns the vertex-partition (the partition into weak fibres) of the rainbow  <A>cgr</A>.
#! @Arguments cgr
DeclareAttribute( "VertexPartitionOfRainbow" , IsColorGraph and IsRainbow );



#! @Section Symmetries
#! @SectionTitle Symmetries of rainbows
#! Next to the usual symmetry groups of color graphs on vertices (automorphism group 
#! and color automorphism group), stable rainbows have an additional, weaker type of symmetry 
#! on colors --- the R-algebraic automorphisms. 
#!
#! Let $(V,C,f)$ be a stable color graph. A permutation $\phi$ of $C$ is called an 
#! R-algebraic automorphisms of $(V,C,f)$ if it preserves reflexive colors and if there exists
#! a permutation $\psi$ of weak fibres of $(V,C,f)$ such that for all $i\in C$ and for all weak 
#! fibres $M_1$ and $M_2$, and for all $v\in M_1$ and for all $w\in \psi(M_1)$ we have that 
#!     $$ |\{x\in M_2\mid f(v,x)=c\}| = |\{y\in\psi(M_2)\mid f(w,y) = \phi(c)\}|.$$ 
#! R-algebraic automorphisms are important because they act (set-wise) on the regular sets 
#! of $(V,C,f)$ (see...). More precisely they map every regular set to another regular set 
#! of the same valency.



#! @Description
#! Returns the R-algebnraic automorphism group of the stable rainbow <A>cgr</A>. A synonym for 
#! `RAlgebraicAutomorphismGroup` is `RAut`.
#! @Arguments cgr
DeclareAttribute( "RAlgebraicAutomorphismGroup", IsColorGraph and IsRainbow and IsStableRainbow );

DeclareSynonymAttr( "RAut", RAlgebraicAutomorphismGroup);


#! @Chapter Jordan
#! @Section Theory 
#!
#!  
#! A color graph $(V,C,f)$ is called __J-stable__ if
#! * it is a rainbow,
#! * for all $i,j,k\in C$ there is a number $p_{\{i,j\}}^k$ such that for all $u,v\in V$ 
#!   with $f(u,v)=k$ we have that
#!   $$ p_{\{i,j\}}^k = |\{ x\in V\mid f(u,x)=i, f(x,v)=j\}| + |\{ y\in V\mid f(u,y)=j, f(y,v)=i\}|.$$
#! the numbers $p_{\{i,j\}}^k$ are called the __intersection numbers__ of the J-stable color graph 
#! $(V,C,f)$. Homogeneous J-stable color graphs are called __Jordan schemes__.
#!
#! Every J-stable color graph is a stable rainbow. Note also that there exist J-stable color 
#! graphs that are not well-fibred (add an example...).
#!
#! It was shown by Rosemary Bayley (add citation...) that the symmetrization of any association 
#! scheme is a Jordan scheme. If a Jordan scheme is not equal to the symmetrization of some 
#! association scheme, then we call it __proper__.


#! @Section Constructors
#! @SectionTitle Constructors of J-stable color graphs

#!
DeclareAttribute("ColorGraphByJStabilization", IsColorGraph ); 


#! @Section Properties
#! @SectionTitle Properties of J-stable color graphs

#! @Description
#! Returns `true` if the color graph <A>cgr</A> is J-stable, `false` otherwise.
#! To check whether color graph is a Jordan scheme the synonym `IsJordanScheme` may be used.
#! @Arguments cgr
DeclareProperty( "IsJStableColorGraph",   IsColorGraph );

DeclareSynonym( "IsJordanScheme", IsJStableColorGraph and IsHomogeneous );

#! @Description
#! Returns `true` if the J-stable color graph <A>cgr</A> is a proper Jordan scheme, 
#! `false` otherwise.
#! @Arguments cgr
DeclareProperty( "IsProperJordanScheme", IsColorGraph and IsJStableColorGraph );

#! @Section Inspection
#! @SectionTitle Function for the inspection of J-stable color graphs

#! @Description
#! Returns the tensor of intersection numbers of the J-stable color graph <A>cgr</A>.
#! @Arguments cgr
DeclareAttribute( "JStructureConstantsOfColorGraph", IsColorGraph and IsJStableColorGraph ); 

#!@ChapterInfo Rainbows, Inspection
#! @Description
#! Gathers information about the rainbow <A>cgr</A>. The options have the following meaning:
#! * `:long` the generators of the various symmetry groups of <A>cgr</A> are included,
#! * `:fvc` it is checked wheter <A>cgr</A> is a strongly regular graph with the 4-vertex 
#!   condition. If so, then the parameters alpha and beta are included
#! * `:strucexp:=d` the structure description of a symmetry group $G$ is only computed if no 
#!    exponent of a prime divisor of $|G|$ excieds `d`. If this option is not given, then
#!    a standard value `d=12` is used.
#! @Arguments cgr:long,fvc,strucexp:=d
#DeclareOperation( DisplayString, [IsColorGraph and IsRainbow]);



#! @Section Symmetries
#! @SectionTitle Symmetries of J-stable color graphs
#! @Description
#! Returns the automorphism group of the tensor of intersection numbers of the 
#! J-stable color graph <A>cgr</A>. The function name `JAut` may be used as a synonym
#! for `JAlgebraicAutomorphismGroup`.
#! @Arguments cgr
DeclareAttribute( "JAlgebraicAutomorphismGroup", IsColorGraph and IsJStableColorGraph ); 

DeclareSynonymAttr ( "JAut", JAlgebraicAutomorphismGroup );


DeclareOperation( "PbagColorInvariant", [IsColorGraph, IsColorGraph] );


DeclareProperty( "IsInterestingRainbow", IsColorGraph and IsRainbow );

DeclareGlobalFunction("RegisterStandardInfoRainbow@JOCO");

infoOptions@COCO2P.disabled:=["Aut:","structure:","aAut:","jAut:","cAut/Aut:"];

