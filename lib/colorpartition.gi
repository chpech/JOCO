DeclareRepresentation("IsColorPartitionRep",
        IsAttributeStoringRep,
        ["cgr",             # a color graph
         "partition"        # a partition of colors of cgr
        ]);

InstallMethod(UnderlyingCgrOfColorPartition,
"for a color partition in ColorPartitionRep",
[IsColorPartition and IsColorPartitionRep],
function(gs)
   return gs!.cgr;
end);

InstallMethod(UnderlyingPartitionOfColorPartition,
"for a color partition in ColorPartitionRep",
[IsColorPartition and IsColorPartitionRep],
function(gs)
   return gs!.partition;
end);

InstallOtherMethod(AsPartition,
"for a color partition in ColorPartitionRep",
[IsColorPartition and IsColorPartitionRep],
function(f)
    local res;
    res:=Set(f!.partition, ShallowCopy);
    MakeImmutable(res);
    return res;
end);

InstallOtherMethod(PartitionOfFusion,
        "for a color partition in ColorPartitionRep",
        [IsColorPartition and IsColorPartitionRep],
function(fusion)
    return fusion!.partition;
end);

InstallOtherMethod(Rank,
"for a color partition in ColorPartitionRep",
[IsColorPartition and IsColorPartitionRep],
function(gs)
    return Length(gs!.partition);
end);

InstallOtherMethod(Order,
"for a color partition in ColorPartitionRep",
[IsColorPartition and IsColorPartitionRep],
function(gs)
    return OrderOfColorGraph(gs!.cgr);
end);

InstallOtherMethod(\<,
"for two color partitions",
IsIdenticalObj,
[IsColorPartition,IsColorPartition],
function(fs1,fs2)
    local   p1,  p2,  i;
    if Rank(fs1)<>Rank(fs2) then
        return Rank(fs1)<Rank(fs2);
    else
        p1:=UnderlyingPartitionOfColorPartition(fs1);
        p2:=UnderlyingPartitionOfColorPartition(fs2);
        for i in [1..Length(p1)] do
            if Length(p1[i])<>Length(p2[i]) then
                return Length(p1[i])<Length(p2[i]);
            elif p1[i]<>p2[i] then
                return p1[i]<p2[i];
            fi;
        od;
    fi;
    return false;
end);

InstallOtherMethod(\=,
"for two color partitions",
IsIdenticalObj,
[IsColorPartition,IsColorPartition],
function(fs1,fs2)
    return UnderlyingPartitionOfColorPartition(fs1)=UnderlyingPartitionOfColorPartition(fs2);
end);


InstallMethod(ViewString,
"for a color partition",
[IsColorPartition],
function(x) 
    return Concatenation("<", "ColorPartition of order ", String(Order(x)), " and rank ", String(Rank(x)),">");
end);

