DeclareProperty( "IsRainbow",   IsColorGraph );


DeclareAttribute( "VertexPartitionOfRainbow" , IsColorGraph and IsRainbow );
DeclareProperty( "IsStableRainbow", IsColorGraph and IsRainbow );
DeclareProperty( "IsWellFibredRainbow", IsColorGraph and IsRainbow );



DeclareAttribute( "RAlgebraicAutomorphismGroup", IsColorGraph and IsRainbow and IsStableRainbow );
DeclareSynonymAttr( "RAut", RAlgebraicAutomorphismGroup);


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

