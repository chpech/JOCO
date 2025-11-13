#############################################################################
##
##  wlpartfus.gd                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Declarations for partial WL fusions 
##
#############################################################################


DeclareCategory( "IsPartialWLFusion", IsPartialColorPartition );
DeclareAttribute( "PartialWLFusionsFamily", IsColorGraph );
KeyDependentOperation( "PartialWLFusionOrbitsFamily", IsColorGraph, IsPermGroup, ReturnTrue );

DeclareOperation( "EmptyPartialWLFusion", [IsColorGraph,IsInt] );
DeclareGlobalFunction( "WLRefinedPartition@JOCO" );     # undocumented

DeclareGlobalFunction("PartialWLFusion");
