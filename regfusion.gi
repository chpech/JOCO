#############################################################################
##
##  regfusion.gi                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##                                                             Sven Reichard
##
##  Implementation of the R-fusion data type
##
#############################################################################


DeclareRepresentation("IsRFusionOfCgrRep",
        IsAttributeStoringRep,
        ["cgr",             # the rainbow over which the fusion lives
         "partition"        # the partition of colors of cgr
]);

InstallMethod(RFusionsFamily,
    "for rainbows",
	[IsColorGraph],
function(cgr)
   local fam;
   fam:=NewFamily("RFusionsFam", IsRFusionOfCgr);
   return fam;
end);

InstallGlobalFunction(RFusionFromPartition,
function(arg)
   local cgr,set,part,res;

   cgr:=arg[1];
   part:=arg[2];
   return RFusionFromPartitionNC(cgr,part);
end);

InstallGlobalFunction(RFusionFromPartitionNC,
function(cgr,part)
   local obj;

   obj:=rec(
   			      cgr := cgr,
   			partition := Immutable(ShortLexSorted(part)));
   return Objectify(NewType(RFusionsFamily(cgr), IsRFusionOfCgr and IsRFusionOfCgrRep), obj);
end);

InstallOtherMethod(AsPartition,
        "for R-fusions in RFusionOfCgrRep",
        [IsRFusionOfCgr and IsRFusionOfCgrRep],
function(f)
    local res;
    res:=Set(f!.partition, ShallowCopy);
    MakeImmutable(res);
    return res;
end);

InstallMethod(RainbowOfRFusion,
        "for R-fusions in RFusionOfCgrRep",
        [IsRFusionOfCgr and IsRFusionOfCgrRep],
function(f)
   return f!.cgr;
end);

InstallMethod(RankOfRFusion,
		"for R-fusions of rainbows",
		[IsRFusionOfCgr and IsRFusionOfCgrRep],
function(fusion)
   return Length(fusion!.partition);
end);

InstallOtherMethod(Rank,
		"for R-fusions of rainbow",
		[IsRFusionOfCgr],
function(fusion)
   return RankOfRFusion(fusion);
end);

InstallMethod(OrderOfRFusion,
        "for R-fusions of rainbows",
        [IsRFusionOfCgr],
function(fusion)
   return OrderOfCocoObject(RainbowOfRFusion(fusion));
end);

InstallOtherMethod(Order,
        "for R-fusions of rainbows",
        [IsRFusionOfCgr],
function(fusion)
   return OrderOfRFusion(fusion);
end);

InstallMethod(PartitionOfRFusion,
        "for R-fusions of rainbows",
        [IsRFusionOfCgr and IsRFusionOfCgrRep],
function(fusion)
    return fusion!.partition;
end);

# InstallMethod(SubOrbitsOfCocoOrbit,
#         "for all R-fusion orbits",
#         [IsPermGroup, IsRFusionOrbit],
# function(grp,orb)
#     local   ug,  cosreps,  stab,  rep,  nrep;


#     ug:=UnderlyingGroupOfCocoOrbit(orb);

#     if not IsSubgroup(ug,grp) then
#         Error("SubOrbitsOfCocoOrbit: The given group is not a subgroup of the underlying group of the good set orbit!");
#     fi;
#     stab:=StabilizerOfCanonicalRepresentative(orb);
#     cosreps:=List(DoubleCosetsNC(ug,stab, grp), Representative);
#     rep:=CanonicalRepresentativeOfCocoOrbit(orb);
#     nrep:=RFusionOrbitNC(grp,rep, Intersection(stab,grp));

#     return Set(cosreps, x->OnCocoOrbits(nrep,x));
# end);

# InstallMethod(SubOrbitsWithInvariantPropertyOfCocoOrbit,
#         "for R-fusion orbits",
#         [IsPermGroup, IsRFusionOrbit, IsFunction],
# function(grp,orb,func)
#     local   ug,  cosreps,  stab,  rep,  nrep,  res;

#     ug:=UnderlyingGroupOfCocoOrbit(orb);

#     if not IsSubgroup(ug,grp) then
#         Error("SubOrbitsWithInvariantPropertyOfCocoOrbit: The given group is not a subgroup of the underlying group of the good set orbit!");
#     fi;

#     stab:=StabilizerOfCanonicalRepresentative(orb);
#     cosreps:=List(DoubleCosetsNC(ug,stab,grp), Representative); 
#     rep:=CanonicalRepresentativeOfCocoOrbit(orb);
#     nrep:=RFusionOrbitNC(grp,rep, Intersection(stab,grp));
#     cosreps:=Filtered(cosreps, r->func(OnJFusions(CanonicalRepresentativeOfCocoOrbit(nrep),r)));
#     res:=List(cosreps, x->OnCocoOrbits(nrep,x));
#     return Set(res);
# end);

#########################################################################################

InstallMethod(ViewString,
        "for R-fusions of rainbows",
        [IsRFusionOfCgr],
function(x)
    return Concatenation("<R-fusion of order ", String(OrderOfCocoObject(RainbowOfRFusion(x))), " and rank ", String(RankOfRFusion(x)), ">");
end);

InstallMethod(ViewString,
        "for R-fusion orbits",
        [IsRFusionOrbit],
        function(x)
    local res;
    
    res:="<";
    if IsMutable(x) then
        Append(res,"mutable ");
    fi;
    Append(res, Concatenation("RFusionOrbit of length ", String(Size(x)),">"));
    return res;
end);


InstallOtherMethod(\<,
        "for R-fusions of rainbows",
        IsIdenticalObj,
        [IsRFusionOfCgr,IsRFusionOfCgr],
function(fs1,fs2)
    local   p1,  p2,  i;
    if RankOfRFusion(fs1)<>RankOfRFusion(fs2) then
        return RankOfRFusion(fs1)<RankOfRFusion(fs2);
    else
        p1:=AsPartition(fs1);
        p2:=AsPartition(fs2);
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
        "for R-fusions of rainbows",
        IsIdenticalObj,
        [IsRFusionOfCgr,IsRFusionOfCgr],
function(fs1,fs2)
    return PartitionOfRFusion(fs1)=PartitionOfRFusion(fs2);
end);

InstallGlobalFunction(RFusionOrbitsFromRegularSetOrbits,
function(gsorbits)
    local iter;

    
    iter:=IteratorOfPartialRFusionOrbits(gsorbits);
    
    return AllRFusionOrbits(iter);
end);


InstallMethod(RFusionOrbitsFamilyOp,
        "for color graphs and permutation groups",
        [IsColorGraph, IsPermGroup],
function(T,g)
    return NewFamily("RFusionOrbitsFam", IsRFusionOrbit);
end);


# RFusionOrbit(<group>, <Rfusion> [,<stab>] )
# <stab> is supposed to be a subgroup of the stabilizer of <fusion> in <group>
InstallGlobalFunction(RFusionOrbit,
function(arg)
    local group,fusion,stab, can,xstab,nstab;

    group:=arg[1];
    fusion:=arg[2];
    if Length(arg)=2 then
        stab:=Stabilizer(group,AsPartition(fusion), OnSetsSets);
    else
        stab:=arg[3];
    fi;

    can:=SetsSetsCanonifiers(group, stab, PartitionOfRFusion(fusion));
    nstab:=ClosureGroup(stab, List(can, x->can[1]*x^(-1)));
    Assert(1, nstab=Stabilizer(group, PartitionOfRFusion(OnRFusions(fusion,can[1])),OnSetsSets));
    

    return RFusionOrbitNC(group, OnRFusions(fusion,can[1]), nstab^can[1]);
end);

# <g> must be from Aut(<fusion!.tensor>)
InstallMethod(OnRFusions,
        "for R-fusions in RFusionOfCgrRep",
        [IsRFusionOfCgr and IsRFusionOfCgrRep, IsPerm],
function(fusion, g)
    local res;
    res:=rec(
                   cgr:=fusion!.cgr,
             partition:=MakeImmutable(ShortLexSorted(OnSetsSets(Set(fusion!.partition),g)))
    );

    return Objectify(NewType(RFusionsFamily(fusion!.cgr), IsRFusionOfCgr and IsRFusionOfCgrRep), res);
end);

# RFusionOrbitNC(<group>, <Jfusion> [,<stab>])
# <Rfusion> is a R-fusion that is assumed to be minimal (rev-lex wise) in its orbit
# the minimality property is not checked
# <stab> is supposed to be the full (SetsSets-wise) stabilizer of <Rfusion> in <group>
InstallGlobalFunction(RFusionOrbitNC,
function(arg)
    local group,fusion,stab,res;

    group:=arg[1];
    fusion:=arg[2];
    if Length(arg)=2 then
        stab:=Stabilizer(group,AsPartition(fusion), OnSetsSets);
    else
        stab:=arg[3];
    fi;

    res:=rec(
            group:=group,
            rep:=fusion,
            stab:=stab);
   return Objectify(NewType(RFusionOrbitsFamily(RainbowOfRFusion(fusion),group), IsRFusionOrbit and IsCocoOrbitRep), res);
end);


InstallOtherMethod(ColorGraphByFusion,
        "for color graphs and for an R-fusion",
        [IsColorGraph, IsRFusionOfCgr],
function(cgr,fusion)
    local res;

    if not IsIdenticalObj(RFusionsFamily(cgr), FamilyObj(fusion)) then
        Error("The given fusion must belong to the given color graph!");
    fi;
    res:= ColorGraphByFusion(cgr, PartitionOfFusion(fusion));
    SetIsRainbow(res,true);
        
    return res;
end);

InstallMethod(HomogeneousRFusionOrbits,
        "for WL-stable color graphs",
        [IsColorGraph and IsWLStableColorGraph],
function(cgr)
    local gsorbs,tensor;
    
    tensor:=StructureConstantsOfColorGraph(cgr);
    
    gsorbs:=HomogeneousRegularSetOrbits(cgr);
    return RFusionOrbitsFromRegularSetOrbits(gsorbs);
end);

InstallOtherMethod(HomogeneousRFusionOrbits,
        "for WL-stable color graphs",
        [IsPermGroup, IsColorGraph and IsWLStableColorGraph],
function(grp,cgr)
    local fsorbs,T;
    
    T:=StructureConstantsOfColorGraph(cgr);
    
    if not ForAll(GeneratorsOfGroup(grp), g->IsAutomorphismOfObject(T,g)) then
        Error("The given group must preserve the tensor of structure-constants!");
        return fail;
    fi;
    
    fsorbs:=HomogeneousRFusionOrbits(T);
    if Size(grp)< Size(AutomorphismGroup(T)) then
        fsorbs:=Union(List(fsorbs, fso->SubOrbitsOfCocoOrbit(grp,fso)));
    fi;
    
    return fsorbs;
end);

InstallMethod(OnCocoOrbits,
        "for all R-fusion orbits",
        [IsRFusionOrbit, IsPerm],
function(orb,perm)
    local   grp,  rep,  stab,  nrep;
    
    if perm=() then
        return orb;
    fi;
    
    grp:=UnderlyingGroupOfCocoOrbit(orb);
    rep:=CanonicalRepresentativeOfCocoOrbit(orb);
    stab:=StabilizerOfCanonicalRepresentative(orb);

    nrep:=OnRFusions(rep,perm);
    return RFusionOrbit(grp,nrep,Stabilizer(grp,AsPartition(nrep),OnSetsSets));
end);

InstallMethod(ActionOfCocoOrbit,
        "for all R-fusion orbits",
        [IsRFusionOrbit],
function(orb)
    return OnRFusions;
end);

InstallOtherMethod(PartitionOfFusion,
        "for R-fusions of rainbows",
        [IsRFusionOfCgr],
function(fusion)
    return PartitionOfRFusion(fusion);
end);

RegisterStandardInfoRFusion@JOCO:=function(node)
    local cgr,tensor,ppolord,qpolord,krein,i,key,ord,srg,val,fvc,prmstr,identification;
    
    cgr:=node!.cgr;    
        
    RegisterInfoCocoNode(node,rec(name:="order:",
                                  getter:=node->OrderOfColorGraph(node!.cgr)));
    RegisterInfoCocoNode(node,rec(name:="rank:",
                                  getter:=node->RankOfColorGraph(node!.cgr)));
    if RankOfColorGraph(cgr)=3 then
        if IsWLStableColorGraph(cgr) then
            srg:=GetSrgParams@COCO2P(StructureConstantsOfColorGraph(cgr));
            prmstr:=Concatenation("(",String(srg.v),",",String(srg.k),",",String(srg.lambda),",",String(srg.mu),")");
            if Length(srg.seidelspec)=2 then
                Append(prmstr,"  (2-graph)");
            fi;
            if srg.mu*2=srg.k then
                Append(prmstr,"  (2-graph\\*)");
            fi;
            
            
            RegisterInfoCocoNode(node,rec(name:="srg:",
                                          value:=prmstr));
            if srg.isPseudoGeometric then
                if srg.psg.alpha=1 then
                    val:=Concatenation("GQ(",String(srg.psg.s),",",String(srg.psg.t),")");
                else
                    val:=Concatenation("PG(",String(srg.psg.s),",",String(srg.psg.t),",",String(srg.psg.alpha),")");
                fi;
                
                RegisterInfoCocoNode(node, rec(name:="pseudo-geometric:",
                                               value:=val));
            elif srg.isPseudoPartialQuadrangle then
                val:=Concatenation("PQ(",String(srg.ppq.s),",",String(srg.ppq.t),",",String(srg.ppq.mu),")");
                if srg.ppq.threeisoregular then
                    Append(val,"_3");
                fi;
                
                RegisterInfoCocoNode(node, rec(name:="pseudo-PQ:", 
                                               value:=val));
            fi;
            if srg.k<>srg.complement.k then
                if srg.complement.isPseudoGeometric then
                    if srg.complement.psg.alpha=1 then
                        val:=Concatenation("GQ(",String(srg.complement.psg.s),",",String(srg.complement.psg.t),")");
                    else
                        val:=Concatenation("PG(",String(srg.complement.psg.s),",",String(srg.complement.psg.t),",",String(srg.complement.psg.alpha),")");
                    fi;
                    
                    RegisterInfoCocoNode(node, rec(name:="pseudo-geometric cmpl:",
                                                   value:=val));
                elif srg.complement.isPseudoPartialQuadrangle then
                    val:=Concatenation("PQ(",String(srg.complement.ppq.s),",",String(srg.complement.ppq.t),",",String(srg.complement.ppq.mu),")");
                    if srg.complement.ppq.threeisoregular then
                        Append(val,"_3");
                    fi;
                    
                    RegisterInfoCocoNode(node, rec(name:="pseudo-PQ cmpl:", 
                                                   value:=val));
                fi;
            fi;
        fi;
    fi;
    
    
    
    if RankOfColorGraph(cgr)>3 then
        if IsHomogeneous(cgr) then 
            RegisterInfoCocoNode(node,rec(name:="valencies:", 
                                          toStr:=StringMultiset@COCO2P,
                                          getter:=node->OutValencies(node!.cgr)));
        else
            RegisterInfoCocoNode(node,rec(name:="# of fibres:",
                                          getter:=node->NumberOfFibres(node!.cgr)));
        fi;
    fi;        

    if RankOfColorGraph(cgr)>2  then
        RegisterInfoCocoNode(node,rec(name:="order(Aut):",
                                      toStr:=StringPP,
                                      tester:=node->HasAutGroupOfCocoObject(node!.cgr),
                                      getter:=node->Order(AutGroupOfCocoObject(node!.cgr))));
        RegisterInfoCocoNode(node,rec(name:="Aut:",
                                      tester:=node->HasAutGroupOfCocoObject(node!.cgr) and HasStructureDescription(AutGroupOfCocoObject(node!.cgr)),
                                      getter:=node->StructureDescription(AutGroupOfCocoObject(node!.cgr):short)));
        RegisterInfoCocoNode(node,rec(name:="order(cAut/Aut):", 
                                      toStr:=StringPP,
                                      tester:=node->HasColorAutomorphismGroupOnColors(node!.cgr),
                                      getter:=node->Order(ColorAutomorphismGroupOnColors(node!.cgr))));
        RegisterInfoCocoNode(node,rec(name:="cAut/Aut:",
                                      tester:=node->HasColorAutomorphismGroupOnColors(node!.cgr),
                                      getter:=node->StructureDescription(ColorAutomorphismGroupOnColors(node!.cgr):short)));
    fi;
end;

StringRFusionInfo:=function(cgr,lcgr)
    local  proper, long, cisomap, map, i, cgrr, ord, nodes, node, 
           outp, res, ninf, str, maxlength, scgr, mrg, idx, v, mcgr, 
           isproper, index, mnode, cisorep;
    
        
    
    long:=ValueOption("long");
    if long=fail then
        long:=false;
    fi;

    cisomap:=ValueOption("cisomap");
    if cisomap=fail then
        cisomap:=false;
    fi;
    
    Perform(lcgr, IsRainbow);
    
    map:=MapReps(lcgr, IsColorIsomorphicColorGraph);
    
    
    for i in [1..Length(lcgr)] do
        cgrr:=lcgr[i];
        if Rank(cgrr)>2 and not (Rank(cgrr)=3 and not IsPrimitiveColorGraph(cgrr)) then
            ord:=PrimePowersInt(Size(AutomorphismGroup(cgrr)));
            ord:=ord{[2,4..Length(ord)]};
            if ForAll(ord, x->x<=12) then
#            if RemInt(Size(AutomorphismGroup(cgrr)),2^12)<>0 then
                StructureDescription(AutomorphismGroup(cgrr):short);
            fi;
        fi;Info(InfoCOCO,1,".");
    od;
    Info(InfoCOCO,1,"|");
    
    nodes:=[];
    for i in [1..Length(lcgr)] do
        node:=NewCocoNode(lcgr[i]);
        node!.index:=i;
        node!.ucgr:=cgr;
        RegisterInfoCocoNode(node, rec(name:="Number:", value:=String(node!.index)));
        RegisterStandardInfoRFusion@JOCO(node);
        
        Add(nodes,node);
        Info(InfoCOCO,1,".");
    od;
    Info(InfoCOCO,1,"|");
    
    
    outp:="";
    res:=OutputTextString(outp,true);
    SetPrintFormattingStatus(res,false);


    PrintTo(res,"JOCO - Information about a List of Rainbows schemes\n",
                "---------------------------------------------------\n");
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
    AppendTo(res, "-------------------------------------------------\n");
    
    PrintTo(res, String("Number of rainbows: ",-maxlength), Length(nodes),"\n");
    PrintTo(res, String("         primitive: ",-maxlength), Length(Filtered(nodes, x->IsPrimitiveColorGraph(x!.cgr))),"\n");
    PrintTo(res,  "-------------------------------------------------\n");
    
    
    
    idx:=0;
    
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
    od;

    CloseStream(res);
    return outp;
end;


InstallMethod(ConstructorOfCocoOrbit,
        "for all R-fusion orbits",
        [IsRFusionOrbit],
function(orb)
    return RFusionOrbit;
end);

InstallMethod(ConstructorOfCocoOrbitNC,
        "for all R-fusion orbits",
        [IsRFusionOrbit],
function(orb)
    return RFusionOrbitNC;
end);
