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

DeclareOperation( "OnJordanFusions", [IsJordanFusion, IsPerm] ); 

 
DeclareAttribute( "HomogeneousJordanFusionOrbits", IsColorGraph and IsJStableColorGraph );



# DeclareCategory("IsPosetOfJFusionOrbits", IsCocoPoset);


DeclareGlobalFunction( "PosetOfFusionOrbits" );
