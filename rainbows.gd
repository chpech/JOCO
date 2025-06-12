DeclareProperty( "IsRainbow",   IsColorGraph );


DeclareProperty( "IsJStableColorGraph",   IsColorGraph );

DeclareAttribute( "JStructureConstantsOfColorGraph", IsColorGraph and IsJStableColorGraph ); 
DeclareAttribute( "JAlgebraicAutomorphismGroup",     IsColorGraph and IsJStableColorGraph ); 
DeclareSynonymAttr ( "JAut", JAlgebraicAutomorphismGroup );


DeclareAttribute( "NumberOfWeakFibres", IsColorGraph and IsRainbow );



DeclareOperation( "PbagColorInvariant",                [IsColorGraph, IsColorGraph] );

DeclareAttribute("ColorGraphByJStabilization", IsColorGraph ); 

DeclareProperty( "IsInterestingRainbow", IsColorGraph and IsRainbow );
DeclareProperty( "IsProperJordanScheme", IsColorGraph and IsJStableColorGraph );

DeclareGlobalFunction("RegisterStandardInfoRainbow@JOCO");

infoOptions@COCO2P.disabled:=["Aut:","structure:","aAut:","jAut:","cAut/Aut:"];

