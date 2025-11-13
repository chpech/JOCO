#############################################################################
##
##  rpartfus.gd                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Declarations for partial R-fusions 
##
#############################################################################


DeclareCategory( "IsPartialRegularFusion", IsPartialColorPartition );
DeclareAttribute( "PartialRegularFusionsFamily", IsColorGraph );
KeyDependentOperation( "PartialRegularFusionOrbitsFamily", IsColorGraph, IsPermGroup, ReturnTrue );

DeclareOperation( "EmptyPartialRegularFusion", [IsColorGraph,IsInt] );
DeclareGlobalFunction( "RRefinedPartition" );     # undocumented

DeclareGlobalFunction("PartialRegularFusion");

# DeclareOperation( "ExtendedPartialRFusion", [IsPartialRFusion, IsRegularSet] );
#DeclareProperty( "IsExtendiblePartialRFusion", IsPartialRFusion );
# DeclareOperation( "IsRCompatibleWithPart", [IsPartialRFusion, IsRegularSet] );
#DeclareOperation( "RainbowOfPartialRFusion", [IsPartialRFusion] );
# DeclareAttribute( "IsCompletePartialRFusion", IsPartialRFusion );
#DeclareOperation( "RFusionFromCompletePartialRFusion", [IsPartialRFusion ] );

#DeclareAttribute("RankOfPartialFusion", IsPartialRFusion );



#DeclareCategory( "IsPartialRFusionOrbit", IsCocoOrbit );
#DeclareGlobalFunction( "PartialRFusionOrbitNC" );

#DeclareCategory( "IsIteratorOfPRFOrbits", IsIterator );
#DeclareOperation( "IteratorOfPartialRFusionOrbits", [IsList] );
#DeclareOperation( "AllRFusionOrbits", [IsIteratorOfPRFOrbits] );

