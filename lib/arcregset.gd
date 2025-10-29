#############################################################################
##
##  arcregset.gd                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Declarations for the datatype of arc regular sets 
##
#############################################################################
## Let R be a regular relation (symmetric or asymmetric) of a set V
## with o(u,v) we denote |{w | (u,w), (v,w) in R }|.
## in JOCO we call a set  of colors with associated relation R arc regular if 
##      - it is symmetric or asymmetric,
##      - it is regular,
##      - there is a number lbd such that for all (u,v) in R we have
##                 o(u,v) = lbd.
##
## Arc regular sets may be enumerated in WL-stable color graphs.


DeclareProperty( "IsArcRegularSet", IsRegularSet );

DeclareOperation( "HomogeneousArcRegularSetOrbits", [IsColorGraph and IsWLStableColorGraph] );

DeclareAttribute( "HomogeneousSymArcRegularSetOrbits", IsColorGraph and IsWLStableColorGraph ); 

DeclareAttribute( "HomogeneousAsymArcRegularSetOrbits", IsColorGraph and IsWLStableColorGraph); 
