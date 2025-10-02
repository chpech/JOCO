#############################################################################
##
##  rpartfus.gd                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##                                                             Sven Reichard
##
##  Declarations for partial R-fusions 
##
#############################################################################


DeclareCategory( "IsPartialRFusion", IsCocoPartialStablePartition );
DeclareAttribute( "PRFusionsFamily", IsColorGraph );
KeyDependentOperation( "PRFusionOrbitsFamily", IsColorGraph, IsPermGroup, ReturnTrue );



DeclareOperation( "EmptyPartialRFusion", [IsColorGraph,IsInt] );
DeclareOperation( "ExtendedPartialRFusion", [IsPartialRFusion, IsRegularSet] );
DeclareProperty( "IsExtendiblePartialRFusion", IsPartialRFusion );
DeclareOperation( "IsRCompatibleWithPart", [IsPartialRFusion, IsRegularSet] );
DeclareOperation( "RainbowOfPartialRFusion", [IsPartialRFusion] );
DeclareAttribute( "IsCompletePartialRFusion", IsPartialRFusion );
DeclareOperation( "RFusionFromCompletePartialRFusion", [IsPartialRFusion ] );

DeclareAttribute("RankOfPartialFusion", IsPartialRFusion );



DeclareCategory( "IsPartialRFusionOrbit", IsCocoOrbit );
DeclareGlobalFunction( "PartialRFusionOrbitNC" );

DeclareCategory( "IsIteratorOfPRFOrbits", IsIterator );
DeclareOperation( "IteratorOfPartialRFusionOrbits", [IsList] );
DeclareOperation( "AllRFusionOrbits", [IsIteratorOfPRFOrbits] );

DeclareGlobalFunction( "RRefinedPartition" );     # undocumented
