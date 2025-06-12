#############################################################################
##
##  jpartfus.gd                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##                                                             Sven Reichard
##
##  Declarations for partial J-fusions 
##
#############################################################################


DeclareCategory( "IsPartialJFusion", IsObject );

DeclareAttribute( "PartialJFusionsFamily", IsTensor );

DeclareOperation( "EmptyPartialJFusion", [IsTensor,IsInt] );
DeclareOperation( "ExtendedPartialJFusion", [IsPartialJFusion, IsJGoodSet] );
DeclareProperty( "IsExtendiblePartialJFusion", IsPartialJFusion );
DeclareOperation( "IsJCompatibleWithPart", [IsPartialJFusion, IsJGoodSet] );
DeclareOperation( "TensorOfPartialJFusion", [IsPartialJFusion] );
DeclareAttribute( "IsCompletePartialJFusion", IsPartialJFusion );
DeclareOperation( "JFusionFromCompletePartialJFusion", [IsPartialJFusion ] );


DeclareCategory( "IsPartialJFusionOrbit", IsCocoOrbit );
KeyDependentOperation( "PartialJFusionOrbitsFamily", IsTensor, IsPermGroup, ReturnTrue );
DeclareGlobalFunction( "PartialJFusionOrbitNC" );

DeclareCategory( "IsIteratorOfPJFOrbits", IsIterator );
DeclareOperation( "IteratorOfPartialJFusionOrbits", [IsList] );
DeclareOperation( "AllJFusionOrbits", [IsIteratorOfPJFOrbits] );

DeclareGlobalFunction( "JRefinedPartition" );     # undocumented
