#############################################################################
##
##  jarcregset.gd                 JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Declarations for the datatype of J-arc regular sets 
##
#############################################################################
## Let R be a regular relation (symmetric or asymmetric) of a set V
## with o(u,v) we denote |{w | (u,w), (v,w) in R }|, and
## with i(u,v) we denote |{w | (w,u), (w,v) in R }|.
## in JOCO we call a set of colors with associated relation R J-arc regular if 
##      - it is symmetric or asymmetric,
##      - it is regular,
##      - there is a number lbd such that for all (u,v) in R we have
##                 o(u,v) + i(u,v) = lbd.
##
## J-Arc regular sets may be enumerated in well-fibred J-stable color graphs.


DeclareProperty( "IsJArcRegularSet", IsRegularSet );

DeclareOperation( "HomogeneousJArcRegularSetOrbits", [IsColorGraph and IsJStableColorGraph] );

DeclareAttribute( "HomogeneousSymJArcRegularSetOrbits", IsColorGraph and IsJStableColorGraph ); 

DeclareAttribute( "HomogeneousAsymJArcRegularSetOrbits", IsColorGraph and IsJStableColorGraph); 
