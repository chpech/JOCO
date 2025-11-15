#############################################################################
##
##  rpartfus.gd                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Declarations for partial R-fusions 
##
#############################################################################


#! @Chapter rpartfus


#! @Section Types and families
#! @Description
#! The data type of partial regular fusions
DeclareCategory( "IsPartialRegularFusion", IsPartialColorPartition );

#! @Description
#! The families of partial regular fusions. For every underlying color graph <A>cgr</A>
#! another family gets created
#! @Arguments cgr
DeclareAttribute( "PartialRegularFusionsFamily", IsColorGraph );

#! @Description
#! The families of orbits of partial regular fusions. For every underlying color graph <A>cgr</A> 
#! and every permutation group <A>grp</A> another family gets created.
#! @Arguments cgr, grp
KeyDependentOperation( "PartialRegularFusionOrbitsFamily", IsColorGraph, IsPermGroup, ReturnTrue );


#! @Section Constructors

#! @Description
#! This function gets as input a stable rainbow <A>cgr</A>. It
#! returns an empty partial regular fusion for <A>cgr</A>.
#! @Arguments cgr
DeclareOperation( "EmptyPartialRegularFusion", [IsColorGraph] );


#! @Description
#! An internal constructor. It recieves as input a record <A>obj</A> with all components of
#! a partial regular fusion. It objectifies this record using the proper type and family and 
#! returns the resulting object. This constructor is returned by the operation 
#! `ConstructorOfPartialColorPartition` when invoking it with a partial regular fusion.
#! @Arguments obj
DeclareGlobalFunction("PartialRegularFusion");


