#############################################################################
##
##  regfusion.gd                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##                                                             Sven Reichard
##
##  Declarations for the R-fusion-datatype
##
#############################################################################


DeclareCategory( "IsRFusionOfCgr", IsObject );

DeclareGlobalFunction( "RFusionFromPartition" ); 
DeclareGlobalFunction( "RFusionFromPartitionNC" ); 
DeclareGlobalFunction( "RFusionOrbitsFromRegularSetOrbits" ); 
KeyDependentOperation( "RFusionOrbitsFamily", IsColorGraph, IsPermGroup, ReturnTrue );


DeclareOperation( "PartitionOfRFusion", [IsRFusionOfCgr] ); 
DeclareOperation( "RainbowOfRFusion", [IsRFusionOfCgr] );    
DeclareOperation( "OnRFusions", [IsRFusionOfCgr, IsPerm] ); 

DeclareAttribute("RankOfRFusion", IsRFusionOfCgr);          
DeclareAttribute("OrderOfRFusion", IsRFusionOfCgr);         
 
DeclareAttribute( "HomogeneousRFusionOrbits", IsColorGraph and IsWLStableColorGraph );

DeclareAttribute( "RFusionsFamily", IsColorGraph );



DeclareCategory( "IsRFusionOrbit", IsPartitionOrbit );
DeclareGlobalFunction( "RFusionOrbitNC" );
DeclareGlobalFunction( "RFusionOrbit" );  


DeclareCategory("IsPosetOfRFusionOrbits", IsCocoPoset);

DeclareAttribute("RComputationTime", IsPosetOfRFusionOrbits);

DeclareGlobalFunction( "PosetOfHomogeneousRFusionOrbits" ); 
