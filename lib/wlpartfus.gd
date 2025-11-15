#############################################################################
##
##  wlpartfus.gd                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Declarations for partial WL fusions 
##
#############################################################################


#! @Chapter wlpartfus


#! @Section Types and families
#! @Description
#! The data type of partial WL-stable fusions
DeclareCategory( "IsPartialWLFusion", IsPartialColorPartition );

#! @Description
#! The families of partial WL-stable fusions. For every underlying color graph <A>cgr</A>
#! another family gets created
#! @Arguments cgr
DeclareAttribute( "PartialWLFusionsFamily", IsColorGraph );

#! @Description
#! The families of orbits of partial WL-stable fusions. For every underlying color graph <A>cgr</A> 
#! and every permutation group <A>grp</A> another family gets created.
#! @Arguments cgr, grp
KeyDependentOperation( "PartialWLFusionOrbitsFamily", IsColorGraph, IsPermGroup, ReturnTrue );

#! @Section Constructors

#! @Description
#! This function gets as input a WL-stable color graph <A>cgr</A>. It
#! returns an empty partial WL-stable fusion for <A>cgr</A>.
#! @Arguments cgr
DeclareOperation( "EmptyPartialWLFusion", [IsColorGraph] );

#! @Description
#! An internal constructor. It recieves as input a record <A>obj</A> with all components of
#! a partial WL-stable fusion. It objectifies this record using the proper type and family and 
#! returns the resulting object. This constructor is returned by the operation 
#! `ConstructorOfPartialColorPartition` when invoking it with a partial WL-stable fusion.
#! @Arguments obj
DeclareGlobalFunction("PartialWLFusion");
