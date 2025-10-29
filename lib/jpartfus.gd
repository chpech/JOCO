#############################################################################
##
##  jpartfus.gd                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Declarations for partial Jordan fusions 
##
#############################################################################


DeclareCategory( "IsPartialJordanFusion", IsCocoPartialStablePartition );
DeclareAttribute( "PartialJordanFusionsFamily", IsColorGraph );
KeyDependentOperation( "PartialJordanFusionOrbitsFamily", IsColorGraph, IsPermGroup, ReturnTrue );

DeclareOperation( "EmptyPartialJordanFusion", [IsColorGraph,IsInt] );
DeclareGlobalFunction( "JRefinedPartition" );     # undocumented


