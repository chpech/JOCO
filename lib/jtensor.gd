#############################################################################
##
##  jtensor.gd                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Declaration for J-tensors
##
#############################################################################

#! @Chapter jtensor


#! @Section Properties of tensors of intersection numbers of J-stable color graphs
#! @Description
#! The property of a tensor <A>tns</A> to be the intersection numbers  tensor of some
#! J-stable color graph. 
#! #Arguments tns
DeclareProperty( "IsTensorOfJC", IsTensor );  

#! @Section Constructors
#! @Description
#! Trys to construct a tensor of J-structure constants for <A>cgr</A>
#! <A>creps</A> is a list of arcs of <A>cgr</A>.
#! There has to be at least one arc from each color of <A>cgr</A>.
#!
#! <A>cgr</A> must be a rainbow (otherwise it can not be J-stable and hence 
#! it cannot have a tensor of J-structure constants).
#! For well-fibred rainbows the colors of <A>cgr</A> may be blocked according to the 
#! reflexive colors  of <A>cgr</A> if there is just one reflexive color then a tensor 
#! in `IsTensorRep` is returned. Otherwise a tensor in `IsBlockedTensorRep` is returned.
#! Note that the partition of vertices into fibres is not necessarily equitable for <A>cgr</A>
#! as there are, e.g.,  homogeneous J-stable cgrs that are not regular
#! @Arguments cgr,creps
DeclareOperation( "JTensorFromColorReps", [IsColorGraph, IsList ] );



