#############################################################################
##
##  arcregset.gi                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Declarations for the datatype of arc regular sets 
##
#############################################################################


DeclareProperty( "IsJArcRegularSet", IsRegularSet );

DeclareOperation( "HomogeneousJArcRegularSetOrbits", [IsColorGraph and IsJStableColorGraph] );

DeclareAttribute( "HomogeneousSymJArcRegularSetOrbits", IsColorGraph and IsJStableColorGraph ); 

DeclareAttribute( "HomogeneousAsymJArcRegularSetOrbits", IsColorGraph and IsJStableColorGraph); 
