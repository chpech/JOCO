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

# DeclareOperation( "ExtendedPartialJFusion", [IsPartialJFusion, IsJGoodSet] );
# DeclareProperty( "IsExtendiblePartialJFusion", IsPartialJFusion );
# DeclareOperation( "IsJCompatibleWithPart", [IsPartialJFusion, IsJGoodSet] );
# DeclareOperation( "TensorOfPartialJFusion", [IsPartialJFusion] );
# DeclareAttribute( "IsCompletePartialJFusion", IsPartialJFusion );
# DeclareOperation( "JFusionFromCompletePartialJFusion", [IsPartialJFusion ] );


# DeclareCategory( "IsPartialJFusionOrbit", IsCocoOrbit );
# DeclareGlobalFunction( "PartialJFusionOrbitNC" );

# DeclareCategory( "IsIteratorOfPJFOrbits", IsIterator );
# DeclareOperation( "IteratorOfPartialJFusionOrbits", [IsList] );
# DeclareOperation( "AllJFusionOrbits", [IsIteratorOfPJFOrbits] );

