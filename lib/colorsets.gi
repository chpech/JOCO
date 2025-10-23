DeclareRepresentation("IsColorSetRep",
        IsAttributeStoringRep,
        [ "cgr",                # the color graph over which the set "lives"
          "set"                 # a set of colors of <cgr>
        ]);




InstallMethod(UnderlyingCgrOfColorSet,
"for a color set in ColorSetRep",
[IsColorSet and IsColorSetRep],
function(gs)
   return gs!.cgr;
end);


InstallOtherMethod(AsSet,
"for a color set in ColorSetRep",
[IsColorSet and IsColorSetRep],
function(gs)
  return gs!.set;
end);

InstallOtherMethod(Length,
"for a color set",
[IsColorSet],
function(gs)
    return Length(AsSet(gs));
end);

InstallOtherMethod(\<,
"for two color sets",
IsIdenticalObj,
[IsColorSet,IsColorSet],
function(gs1,gs2)
    if Length(gs1)<>Length(gs2) then
        return Length(gs1)<Length(gs2);
    else
        return AsSet(gs1)<AsSet(gs2);
    fi;
end);

InstallOtherMethod(\=,
"for two color sets",
IsIdenticalObj,
[IsColorSet,IsColorSet],
function(gs1,gs2)
    return AsSet(gs1)=AsSet(gs2);
end);

InstallOtherMethod(Size,
"for a color set in ColorSetRep",
[IsColorSet and IsColorSetRep],
function(gs)
    return Size(gs!.set);
end);

InstallMethod(ViewString,
"for a color set",
[IsColorSet],
function(x) 
    return Concatenation("<", "ColorSet ", String(AsSet(x)), ">");
end);


InstallMethod(IsXHadamard,
"for a color set",
[IsColorSet],
function(scs)
    
end);
