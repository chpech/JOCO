DeclareRepresentation("IsColorPartitionRep",
        IsAttributeStoringRep,
        ["cgr",             # a color graph
         "partition"        # a partition of colors of cgr
        ]);

InstallMethod(ColorPartitionsFamily,
"for color graphs",
[IsColorGraph],
function(cgr)
   local fam;
   fam:=NewFamily("ColorPartitionsFam", IsColorPartition);
   return fam;
end);

InstallMethod(ColorPartition,
"for color partitions",
[ IsColorPartition, IsColorGraph, IsList ],
function(filter, cgr, part)
   local obj;
    
    obj:= rec(
               cgr:=cgr,
               partition:=MakeImmutable(ShortLexSorted(part)));
    
    return Objectify(NewType(ColorPartitionsFamily(cgr), IsColorPartition and IsColorPartitionRep), obj);

end);

InstallMethod(OnColorPartitions,
"for a color partition and a permutation",
[IsColorPartition, IsPerm],
function(cpart, g)
    local res;
    
    return ColorPartition(IsColorPartition, UnderlyingCgrOfColorPartition(cpart),
                          OnTuplesSets(UnderlyingPartitionOfColorPartition(cpart), g));
end);


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

InstallMethod(FusionColorGraph,
"for a color partition",
[IsColorPartition],
function(cpart)
    return ColorGraphByFusion(UnderlyingCgrOfColorPartition(cpart),
                              UnderlyingPartitionOfColorPartition(cpart));
end);

InstallGlobalFunction(ColorPartitionOrbit,
function(arg)
    local group,fusion,stab, can,xstab,nstab;

    group:=arg[1];
    fusion:=arg[2];
    if Length(arg)=2 then
        stab:=Stabilizer(group,AsPartition(fusion), OnSetsSets);
    else
        stab:=arg[3];
    fi;

    can:=SetsSetsCanonifiers(group, stab, UnderlyingPartitionOfColorPartition(fusion));
    nstab:=ClosureGroup(stab, List(can, x->can[1]*x^(-1)));
    Assert(1, nstab=Stabilizer(group, UnderlyingPartitionOfColorPartition(OnColorPartitions(fusion,can[1])),OnSetsSets));
    

    return ColorPartitionOrbitNC(group, OnColorPartitions(fusion,can[1]), nstab^can[1]);
end);


InstallGlobalFunction(ColorPartitionOrbitNC,
function(group,fusion,stab)
    local res;
    
    
    res:=rec(
              group:=group,
              rep:=fusion,
              stab:=stab);
    return Objectify(NewType(ColorPartitionOrbitsFamily(UnderlyingCgrOfColorPartition(fusion),group), 
                             IsColorPartitionOrbit and IsCocoOrbitRep), res);
end);


InstallMethod(ColorPartitionOrbitsFamilyOp,
"for a color graph and a permutation groups",
[IsColorGraph, IsPermGroup],
function(cgr,g)
    return NewFamily("ColorPartitionOrbitsFam", IsColorPartitionOrbit);
end);


InstallMethod(ConstructorOfStablePartitionOrbit,
"for a color partition",
[IsColorPartition],
function(cpart)
    return ColorPartitionOrbit;
end);

InstallMethod(ConstructorOfStablePartitionOrbitNC,
"for a color partition",
[IsJordanFusion],
function(cpart)
    return ColorPartitionOrbitNC;
end);

InstallMethod(OnCocoOrbits,
"for a color partition orbit and a permutation",
[IsColorPartitionOrbit, IsPerm],
function(orb,perm)
    local   grp,  rep,  stab,  nrep;
    
    if perm=() then
        return orb;
    fi;
    
    grp:=UnderlyingGroupOfCocoOrbit(orb);
    rep:=CanonicalRepresentativeOfCocoOrbit(orb);
    stab:=StabilizerOfCanonicalRepresentative(orb);

    nrep:=OnColorPartitions(rep,perm);

    return ColorPartitionOrbitNC(grp,nrep,Stabilizer(grp,AsPartition(nrep),OnSetsSets));
end);


InstallMethod(ActionOfCocoOrbit,
"for a color partition orbit",
[IsColorPartitionOrbit],
function(orb)
    return OnColorPartitions;
end);


InstallMethod(ConstructorOfCocoOrbit,
"for a  color partition orbit",
[IsColorPartitionOrbit],
function(orb)
    return ColorPartitionOrbit;
end);

InstallMethod(ConstructorOfCocoOrbitNC,
"for a color partition orbit",
[IsColorPartitionOrbit],
function(orb)
    return ColorPartitionOrbitNC;
end);

InstallMethod(ConstructorOfStablePartitionOrbit,
"for a color partition",
[IsColorPartition],
function(rfus)
    return ColorPartitionOrbit;
end);

InstallMethod(ConstructorOfStablePartitionOrbitNC,
"for a color partition",
[IsColorPartition],
function(rfus)
    return ColorPartitionOrbitNC;
end);

InstallGlobalFunction(DisplayStringColorPartitions,
function(lfus)
    local  cgr, lcgr, long, cisomap, map, i, cgrr, ord, nodes, node, 
           outp, res, ninf, str, maxlength, scgr, mrg, idx, v, mcgr, 
           index, mnode, cisorep, strucexp;
    
    long:=ValueOption("long");
    if long=fail then
        long:=false;
    fi;

    cisomap:=ValueOption("cisomap");
    if cisomap=fail then
        cisomap:=false;
    fi;
    
    strucexp:=ValueOption("strucexp");
    if strucexp=fail then
        strucexp:=12;
    fi;

    if lfus = [] then
        return;
    fi;
    cgr:=UnderlyingCgrOfColorPartition(lfus[1]);
    if ForAny([2..Length(lfus)], i->cgr <> UnderlyingCgrOfColorPartition(lfus[i])) then
        ErrorNoReturn("The color partitions need to have the same underlying color graph!");
    fi;
    
    lcgr:=List(lfus, FusionColorGraph);
    
    if ForAny (lcgr, x-> not IsRainbow(x)) then
        ErrorNoReturn("All fusion color graphs should be rainbows!");
    fi;
    
    
    map:=MapReps(lcgr, IsColorIsomorphicColorGraph);
    
    Info(InfoJOCO,1,"Computing structure descriptions for symmetry groups of color graphs.\n");
    for i in [1..Length(lcgr)] do
        cgrr:=lcgr[i];
        if Rank(cgrr)>2 and not (Rank(cgrr)=3 and not IsPrimitiveColorGraph(cgrr)) then
            ord:=PrimePowersInt(Size(AutomorphismGroup(cgrr)));
            ord:=ord{[2,4..Length(ord)]};
            if ForAll(ord, x->x<=strucexp) then
                StructureDescription(AutomorphismGroup(cgrr):short);
            fi;
        fi;Info(InfoJOCO,1,".");
    od;
    Info(InfoJOCO,1,"\nDone computing structure descriptions for symmetry groups of color graphs.\n");
    
    Info(InfoJOCO,1,"Generating COCO-nodes for the color graphs.\n");
    nodes:=[];
    for i in [1..Length(lcgr)] do
        node:=NewCocoNode(lcgr[i]);
        node!.index:=i;
        node!.ucgr:=cgr;
        RegisterInfoCocoNode(node, rec(name:="Number:", value:=String(node!.index)));
        RegisterStandardInfoRainbow@JOCO(node);
        
        Add(nodes,node);
        Info(InfoJOCO,1,".");
    od;
    Info(InfoJOCO,1,"\nDone generating COCO-nodes for the color graphs.\n");
    
    outp:="";
    res:=OutputTextString(outp,true);
    SetPrintFormattingStatus(res,false);


    PrintTo(res,"JOCO - Information about a List of Rainbows\n",
                "-------------------------------------------\n");
    Info(InfoJOCO,1,"Creating node and gathering infomration about cgr.\n");
    node:=NewCocoNode(cgr);
    RegisterStandardInfo@COCO2P(node);
    ninf:=node!.nodeInfo;

    ComputeAllInfos(node);
    for str in infoOptions@COCO2P.disabled do
        ComputeInfo(node,str);
    od;
    AppendTo(res, NodeInfoString(node));
    maxlength:=Maximum(ninf.maxlength, 20);
    AppendTo(res,String("Color Reps: ",-maxlength),"\n");
    AppendTo(res,"   ", StringCocoIndented(StringCocoColorReps(cgr),3));
    
    if long and Rank(node!.cgr)>2 and not ( Rank(node!.cgr)=3 and not IsPrimitive(node!.cgr)) then
        if not IsTransitive(AutomorphismGroup(node!.cgr),[1..OrderOfColorGraph(cgr)]) then
            AppendTo(res, String("Orbits of Aut: ",-maxlength));
            AppendTo(res, StringCocoOrbReps@COCO2P(AutomorphismGroup(node!.cgr),[1..OrderOfColorGraph(cgr)]));
        fi;
        AppendTo(res, String("Generators of Aut: ",-maxlength),"\n");
        AppendTo(res, StringCocoGenerators@COCO2P(AutomorphismGroup(node!.cgr), OrderOfColorGraph(cgr)));
        
        scgr:=ColorGraph(AutomorphismGroup(node!.cgr),[1..OrderOfColorGraph(cgr)],OnPoints,true);
        if not IsSchurian(node!.cgr) then
            AppendTo(res, String("Merging in Cgr(Aut): ",-maxlength),"\n");
            mrg:=Set([1..Rank(node!.cgr)], i->Filtered([1..Rank(scgr)], j->ArcColorOfColorGraph(node!.cgr,ColorRepresentative(scgr,j))=i));
            AppendTo(res, StringCocoMerging@COCO2P(mrg));
        fi;
    fi;
    Info(InfoJOCO,1,"\nDone creating node and gathering infomration about cgr.\n");
    
    AppendTo(res, "-------------------------------------------------\n");
    
    PrintTo(res, String("Number of rainbows: ",-maxlength), Length(nodes),"\n");
    PrintTo(res, String("         primitive: ",-maxlength), Length(Filtered(nodes, x->IsPrimitiveColorGraph(x!.cgr))),"\n");
    PrintTo(res,  "-------------------------------------------------\n");
    
    
    
    idx:=0;
    Info(InfoJOCO,1,"Gathering information about color graphs.\n");
    for v in [1..Length(nodes)] do
        node:=nodes[v];
        ninf:=node!.nodeInfo;
        mcgr:=ColorGraphByWLStabilization(node!.cgr);
               
        idx:=idx+1;

        maxlength:=Maximum(ninf.maxlength, 20);
        index:=IndexOfCocoNode(node);
        
        AppendTo(res, NodeInfoString(node));
        mrg:=Set([1..Rank(node!.cgr)], i->Filtered([1..Rank(cgr)], j->ArcColorOfColorGraph(node!.cgr,ColorRepresentative(cgr,j))=i));
        AppendTo(res, String("Merging in Cgr: ", -maxlength),"\n");
        AppendTo(res, "   ", StringCocoIndented(StringCocoMerging@COCO2P(mrg),3));
        
        
        if not IsWLStableColorGraph(node!.cgr) then
            AppendTo(res, String("WL-stabilization: ",-maxlength),"\n");
            
            mnode:=NewCocoNode(mcgr);
            RegisterStandardInfo@COCO2P(mnode);

            ComputeAllInfos(mnode);
            for str in infoOptions@COCO2P.disabled do
                ComputeInfo(mnode,str);
            od;
            AppendTo(res, "   ",StringCocoIndented(NodeInfoString(mnode),3));
        fi;
        


        if cisomap then
            cisorep:=map[index];
            if cisorep<>index then
                AppendTo(res, String("C-isomorphic to: ",-maxlength), "#",cisorep,"\n");
            fi;
        fi;
        if long and Rank(node!.cgr)>2 and not (Rank(node!.cgr)=3 and not IsPrimitiveColorGraph(node!.cgr)) then
            if not IsTransitive(AutomorphismGroup(node!.cgr),[1..OrderOfColorGraph(cgr)]) then
                AppendTo(res, String("Orbits of Aut: ",-maxlength));
                AppendTo(res, StringCocoOrbReps@COCO2P(AutomorphismGroup(node!.cgr),[1..OrderOfColorGraph(cgr)]));
            fi;
            AppendTo(res, String("Generators of Aut: ",-maxlength),"\n");
            AppendTo(res, StringCocoGenerators@COCO2P(AutomorphismGroup(node!.cgr), OrderOfColorGraph(cgr)));
            
            scgr:=ColorGraph(AutomorphismGroup(node!.cgr),[1..OrderOfColorGraph(cgr)],OnPoints,true);
            AppendTo(res, String("Merging in Cgr(Aut): ",-maxlength),"\n");
            mrg:=Set([1..Rank(node!.cgr)], i->Filtered([1..Rank(mcgr)], j->ArcColorOfColorGraph(node!.cgr,ColorRepresentative(mcgr,j))=i));
            AppendTo(res, StringCocoMerging@COCO2P(mrg));
        fi;

        AppendTo(res,"\n");
        Info(InfoJOCO,1,".");
    od;
    Info(InfoJOCO,1,"\nDone gathering information about color graphs.\n");

    CloseStream(res);
    return outp;
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

InstallMethod( ViewString,
        "for a color partition orbit",
        [IsColorPartitionOrbit],
function(pporb)
    return Concatenation("<color partition orbit of length ", String(Size(pporb)), ">");
end);
