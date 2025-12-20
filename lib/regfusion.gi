#############################################################################
##
##  regfusion.gi                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Implementation of the datatype of regular fusions
##
#############################################################################



InstallMethod(ColorPartition,
"for WL-fusions",
[ IsColorPartition and IsRegularFusion, IsColorGraph, IsList ],
function(filter, cgr, set)
   local res;

    res:=ColorPartition(IsColorPartition, cgr,set);
    SetIsRegularFusion(res,true);

    return res;

end);

InstallMethod(OnColorPartitions,
"for a WL-fusion and a permutation",
[IsColorPartition and IsWLFusion, IsPerm],
function(cpart, g)
    local res;
    
    return ColorPartition(IsColorPartition and IsRegularFusion, 
                          UnderlyingCgrOfColorPartition(cpart),
                          OnTuplesSets(UnderlyingPartitionOfColorPartition(cpart), g));
end);

InstallMethod( StablePartitionFromCompletePartialStablePartition,
"for a partial regular fusion in PartialColorPartitionRep",
[IsPartialRegularFusion and IsPartialColorPartitionRep],
function(cpfus)
    return ColorPartition(IsColorPartition and IsRegularFusion, cpfus!.cgr, cpfus!.part.classes);
end);

InstallMethod(FusionColorGraph,
"for regular fusions",              
[IsColorPartition and IsRegularFusion],
function(rfus)
    local cgr;
    
    cgr:=ColorGraphByFusion(UnderlyingCgrOfColorPartition(rfus),
                            UnderlyingPartitionOfColorPartition(rfus));
    SetIsRainbow(cgr,true);
    SetIsRegularColorGraph(cgr,true);
    return cgr;
end);

#########################################################################################

InstallMethod(ViewString,
"for a regular fusion",
[IsColorPartition and IsRegularFusion],
function(x)
    return Concatenation("<Regular fusion of order ", String(Order(x)), " and rank ", String(Rank(x)), ">");
end);


InstallOtherMethod(RegularFusionOrbits,
"for a stable rainbow and a list of regular set orbits",
[IsRainbow and IsStableRainbow, IsList],
function(cgr,gsorbits)
    local pfus, iter;
    
    
    if not ForAll(gsorbits, IsRegularSetOrbit) then
        ErrorNoReturn("RegularFusionOrbits: expecting a list of regular set orbits");
    fi;
    if not ForAll(gsorbits, gso->IsIdenticalObj(FamilyObj(Representative(gso)),FamilyObj(Representative(gsorbits[1])))) then
        ErrorNoReturn("RegularFusionOrbits: regular set orbits are incompatible");
    fi;
    
    if gsorbits<>[] and  
       not IsIdenticalObj(cgr,UnderlyingCgrOfColorSet(Representative(gsorbits[1]))) then
        ErrorNoReturn("RegularFusionOrbits: regular set orbits are incompatible");
    fi;
    
    pfus:=EmptyPartialRegularFusion(cgr);

    iter:=IteratorOfPartialStablePartitionOrbits(pfus,gsorbits);
    
    return AllStablePartitionOrbits(iter);
end);

InstallMethod(RegularFusionOrbits,
"for a stable rainbow",
[IsColorGraph and IsRainbow and IsStableRainbow],
function(cgr)
    local gsorbs,rforb;
    
    gsorbs:=RegularSetOrbits(cgr);
    rforb:=RegularFusionOrbits(cgr,gsorbs);
    return rforb;  
end);

InstallOtherMethod(RegularFusionOrbits,
"for a stable rainbow and a permutation group",
[IsColorGraph and IsRainbow and IsStableRainbow, IsPermGroup],
function(cgr,g)
    local gsorbs,rforb;
    
    gsorbs:=RegularSetOrbits(cgr,g);
    rforb:=RegularFusionOrbits(cgr,gsorbs);
    return rforb;
end);

