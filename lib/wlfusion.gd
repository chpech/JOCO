#############################################################################
##
##  wlfusion.gd                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Declarations for the datatype of WL-stable fusions
##
#############################################################################

DeclareCategory( "IsWLFusion", IsColorPartition );

DeclareAttribute( "WLFusionsFamily", IsColorGraph );

DeclareOperation( "OnWLFusions", [IsWLFusion, IsPerm] ); 

 
DeclareAttribute( "HomogeneousWLFusionOrbits", IsColorGraph and IsWLStableColorGraph );



# DeclareCategory("IsPosetOfWLFusionOrbits", IsCocoPoset);

