#############################################################################
##
##  jpartfus.gd                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Declarations for partial Jordan fusions 
##
#############################################################################


#! @Chapter jpartfus


#! @Section Types and families
#! @Description
#! The data type of partial Jordan fusions
DeclareCategory( "IsPartialJordanFusion", IsPartialColorPartition );


#! @Description
#! The families of partial Jordan fusions. For every underlying color graph <A>cgr</A>
#! another family gets created
#! @Arguments cgr
DeclareAttribute( "PartialJordanFusionsFamily", IsColorGraph );


#! @Description
#! The families of orbits of partial Jordan fusions. For every underlying color graph <A>cgr</A> 
#! and every permutation group <A>grp</A> another family gets created.
#! @Arguments cgr, grp
KeyDependentOperation( "PartialJordanFusionOrbitsFamily", IsColorGraph, IsPermGroup, ReturnTrue );

#! @Section Constructors

#! @Description
#! This function gets as input a J-stable color graph <A>cgr</A>. It
#! returns an empty partial Jordan fusion for <A>cgr</A>.
#! @Arguments cgr
DeclareOperation( "EmptyPartialJordanFusion", [IsColorGraph] );

#! @Description
#! An internal constructor. It recieves as input a record <A>obj</A> with all components of
#! a partial Jordan fusion. It objectifies this record using the proper type and family and 
#! returns the resulting object. This constructor is returned by the operation 
#! `ConstructorOfPartialColorPartition` when invoking it with a partial Jordan fusion.
#! @Arguments obj
DeclareGlobalFunction("PartialJordanFusion");


