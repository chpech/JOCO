#############################################################################
##
##  jfusion.gd                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Declarations for the datatype of Jordan fusions
##
#############################################################################

DeclareCategory( "IsJordanFusion", IsColorPartition );

DeclareAttribute( "JordanFusionsFamily", IsColorGraph );
KeyDependentOperation( "JordanFusionOrbitsFamily", IsColorGraph, IsPermGroup, ReturnTrue );

#DeclareGlobalFunction( "JFusionFromPartition" ); 
#DeclareGlobalFunction( "JFusionFromPartitionNC" ); 

###### implement as alternative of HomogeneousJordanFusionOrbits:
#   DeclareGlobalFunction( "JFusionOrbitsFromJGoodSetOrbits" ); 


# DeclareOperation( "PartitionOfJFusion", [IsJFusionOfTensor] ); 
# DeclareOperation( "TensorOfJFusion", [IsJFusionOfTensor] );    
DeclareOperation( "OnJordanFusions", [IsJordanFusion, IsPerm] ); 

#DeclareAttribute("RankOfJFusion", IsJFusionOfTensor);          
#DeclareAttribute("OrderOfJFusion", IsJFusionOfTensor);         
 
DeclareAttribute( "HomogeneousJordanFusionOrbits", IsColorGraph and IsJStableColorGraph );

DeclareCategory( "IsJordanFusionOrbit", IsCocoSetOrbit );

DeclareGlobalFunction( "JordanFusionOrbitNC" );
DeclareGlobalFunction( "JordanFusionOrbit" );


DeclareCategory("IsPosetOfJFusionOrbits", IsCocoPoset);


DeclareGlobalFunction( "PosetOfFusionOrbits" );
