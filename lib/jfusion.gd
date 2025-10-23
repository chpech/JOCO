#############################################################################
##
##  jfusion.gd                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Declarations for the J-fusion-datatype
##
#############################################################################

DeclareCategory( "IsJFusionOfTensor", IsObject );

DeclareAttribute( "JFusionsFamily", IsTensor );

DeclareGlobalFunction( "JFusionFromPartition" ); 
DeclareGlobalFunction( "JFusionFromPartitionNC" ); 
DeclareGlobalFunction( "JFusionOrbitsFromJGoodSetOrbits" ); 


DeclareOperation( "PartitionOfJFusion", [IsJFusionOfTensor] ); 
DeclareOperation( "TensorOfJFusion", [IsJFusionOfTensor] );    
DeclareOperation( "OnJFusions", [IsJFusionOfTensor, IsPerm] ); 

DeclareAttribute("RankOfJFusion", IsJFusionOfTensor);          
DeclareAttribute("OrderOfJFusion", IsJFusionOfTensor);         
 
DeclareAttribute( "HomogeneousJFusionOrbits", IsTensor and IsTensorOfCC );

DeclareCategory( "IsJFusionOrbit", IsCocoOrbit );
KeyDependentOperation( "JFusionOrbitsFamily", IsTensor, IsPermGroup, ReturnTrue );

DeclareGlobalFunction( "JFusionOrbitNC" );
DeclareGlobalFunction( "JFusionOrbit" );


DeclareCategory("IsPosetOfJFusionOrbits", IsCocoPoset);


DeclareGlobalFunction( "PosetOfFusionOrbits" );
