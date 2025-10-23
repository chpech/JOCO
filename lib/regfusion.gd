#############################################################################
##
##  regfusion.gd                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Declarations for the datatype of regular fusions
##
#############################################################################


DeclareCategory( "IsRegularFusion", IsColorPartition );

DeclareAttribute( "RegularFusionsFamily", IsColorGraph );
KeyDependentOperation( "RegularFusionOrbitsFamily", IsColorGraph, IsPermGroup, ReturnTrue );

DeclareGlobalFunction( "StringRegularFusionInfo" );

DeclareOperation( "OnRegularFusions", [IsRegularFusion, IsPerm] ); 

 
DeclareAttribute( "HomogeneousRegularFusionOrbits", IsColorGraph and IsRainbow and IsStableRainbow );

DeclareCategory( "IsRegularFusionOrbit", IsCocoSetOrbit );
DeclareGlobalFunction( "RegularFusionOrbit" );
DeclareGlobalFunction( "RegularFusionOrbitNC" );


DeclareCategory("IsPosetOfRFusionOrbits", IsCocoPoset);

DeclareAttribute("RComputationTime", IsPosetOfRFusionOrbits);

DeclareGlobalFunction( "PosetOfHomogeneousRegularFusionOrbits" ); 
