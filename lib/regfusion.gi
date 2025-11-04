#############################################################################
##
##  regfusion.gi                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Implementation of the datatype of regular fusions
##
#############################################################################


InstallMethod(RegularFusionsFamily,
"for a color graph",
[IsColorGraph],
function(cgr)
   local fam;
   fam:=NewFamily("RegularFusionsFam", IsRegularFusion);
   return fam;
end);


InstallMethod( StablePartitionFromCompletePartialStablePartition,
"for a partial regular fusion in PartialRegularFusionRep",
[IsPartialRegularFusion and IsPartialRegularFusionRep],
function(cpfus)
    local obj;
    
    #   Assert(1, OnSetsSets(Set(cpfus!.part.classes),Mates(cpfus!.tensor))=Set(cpfus!.part.classes));
    obj:=rec(
   	      cgr := cpfus!.cgr,
   	      partition := Immutable(ShortLexSorted(cpfus!.part.classes)));
    return Objectify(NewType(RegularFusionsFamily(cpfus!.cgr), IsRegularFusion and IsColorPartitionRep), obj);
end);



#########################################################################################

InstallMethod(ViewString,
"for a regular fusion",
[IsRegularFusion],
function(x)
    return Concatenation("<Regular fusion of order ", String(Order(x)), " and rank ", String(Rank(x)), ">");
end);

InstallMethod(ViewString,
"for a regular fusion orbit",
[IsRegularFusionOrbit],
function(x)
    local res;
    
    res:="<";
    if IsMutable(x) then
        Append(res,"mutable ");
    fi;
    Append(res, Concatenation("RegularFusionOrbit of length ", String(Size(x)),">"));
    return res;
end);

InstallOtherMethod(HomogeneousRegularFusionOrbits,
"for a stable rainbow and a list of regular set orbits",
[IsRainbow and IsStableRainbow, IsList],
function(cgr,gsorbits)
    local pfus, iter,max;
    
    if not ForAll(gsorbits, IsRegularSetOrbit) then
        ErrorNoReturn("HomogeneousRegularFusionOrbits: expecting a list of regular set orbits");
    fi;
    if not ForAll(gsorbits, gso->IsIdenticalObj(FamilyObj(Representative(gso)),FamilyObj(Representative(gsorbits[1])))) then
        ErrorNoReturn("HomogeneousRegularFusionOrbits: regular set orbits are incompatible");
    fi;
    
    if gsorbits=[] then
        max:=0;
    else
        max:=Maximum(List(gsorbits, x->Size(Representative(x))));
        if not IsIdenticalObj(cgr,UnderlyingCgrOfColorSet(Representative(gsorbits[1]))) then
            ErrorNoReturn("HomogeneousRegularFusionOrbits: regular set orbits are incompatible");
        fi;
    fi;
    
    pfus:=EmptyPartialRegularFusion(cgr, max);

    iter:=IteratorOfPartialStablePartitionOrbits(pfus,gsorbits);
    
    return AllStablePartitionOrbits(iter);
end);

InstallMethod(RegularFusionOrbitsFamilyOp,
"for a color graph and a permutation groups",
[IsColorGraph, IsPermGroup],
function(cgr,g)
    return NewFamily("RegularFusionOrbitsFam", IsRegularFusionOrbit);
end);


# RegularFusionOrbit(<group>, <Rfusion> [,<stab>] )
# <stab> is supposed to be a subgroup of the stabilizer of <fusion> in <group>
InstallGlobalFunction(RegularFusionOrbit,
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
    Assert(1, nstab=Stabilizer(group, UnderlyingPartitionOfColorPartition(OnRegularFusions(fusion,can[1])),OnSetsSets));
    

    return RegularFusionOrbitNC(group, OnRegularFusions(fusion,can[1]), nstab^can[1]);
end);


# RegularFusionOrbitNC(<group>, <Jfusion> [,<stab>])
# <Rfusion> is a R-fusion that is assumed to be minimal (rev-lex wise) in its orbit
# the minimality property is not checked
# <stab> is supposed to be the full (SetsSets-wise) stabilizer of <Rfusion> in <group>
InstallGlobalFunction(RegularFusionOrbitNC,
function(group,fusion,stab)
    local res;


    res:=rec(
              group:=group,
              rep:=fusion,
              stab:=stab);
    return Objectify(NewType(RegularFusionOrbitsFamily(UnderlyingCgrOfColorPartition(fusion),group), IsRegularFusionOrbit and IsCocoOrbitRep), res);
end);

InstallMethod(OnRegularFusions,
"for a regular fusion in ColorPartitionRep and a permutation",
[IsRegularFusion and IsColorPartitionRep, IsPerm],
function(fusion, g)
    local res;
    res:=rec(
              cgr:=fusion!.cgr,
              partition:=MakeImmutable(ShortLexSorted(OnSetsSets(Set(fusion!.partition),g)))
             );
    
    return Objectify(NewType(RegularFusionsFamily(fusion!.cgr), IsRegularFusion and IsColorPartitionRep), res);
end);


InstallMethod(HomogeneousRegularFusionOrbits,
"for a stable rainbow",
[IsColorGraph and IsRainbow and IsStableRainbow],
function(cgr)
    local gsorbs,rforb;
    
    gsorbs:=HomogeneousRegularSetOrbits(cgr);
    rforb:=HomogeneousRegularFusionOrbits(cgr,gsorbs);
    return rforb;  
end);

InstallOtherMethod(HomogeneousRegularFusionOrbits,
"for a stable rainbow and a permutation group",
[IsColorGraph and IsRainbow and IsStableRainbow, IsPermGroup],
function(cgr,g)
    local gsorbs,rforb;
    
    gsorbs:=HomogeneousRegularSetOrbits(cgr,g);
    rforb:=HomogeneousRegularFusionOrbits(cgr,gsorbs);
    return rforb;
end);

InstallMethod(OnCocoOrbits,
"for a regular fusion orbit and a permutation",
[IsRegularFusionOrbit, IsPerm],
function(orb,perm)
    local   grp,  rep,  stab,  nrep;
    
    if perm=() then
        return orb;
    fi;
    
    grp:=UnderlyingGroupOfCocoOrbit(orb);
    rep:=CanonicalRepresentativeOfCocoOrbit(orb);
    stab:=StabilizerOfCanonicalRepresentative(orb);

    nrep:=OnRegularFusions(rep,perm);

    return RegularFusionOrbitNC(grp,nrep,Stabilizer(grp,AsPartition(nrep),OnSetsSets));
end);

InstallMethod(ActionOfCocoOrbit,
"for a regular fusion orbit",
[IsRegularFusionOrbit],
function(orb)
    return OnRegularFusions;
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

InstallGlobalFunction(StringRegularFusionInfo,
function(cgr,lcgr)
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
    
    Info(InfoJOCO,1,"Computing structure descriptions for symmetry groups of color graphs.\n");
    for i in [1..Length(lcgr)] do
        cgrr:=lcgr[i];
        if Rank(cgrr)>2 and not (Rank(cgrr)=3 and not IsPrimitiveColorGraph(cgrr)) then
            ord:=PrimePowersInt(Size(AutomorphismGroup(cgrr)));
            ord:=ord{[2,4..Length(ord)]};
            if ForAll(ord, x->x<=12) then
#            if RemInt(Size(AutomorphismGroup(cgrr)),2^12)<>0 then
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
        RegisterStandardInfoRFusion@JOCO(node);
        
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


InstallMethod(ConstructorOfCocoOrbit,
"for a  regular fusion orbit",
[IsRegularFusionOrbit],
function(orb)
    return RegularFusionOrbit;
end);

InstallMethod(ConstructorOfCocoOrbitNC,
"for a regular fusion orbit",
[IsRegularFusionOrbit],
function(orb)
    return RegularFusionOrbitNC;
end);

InstallMethod(ConstructorOfStablePartitionOrbit,
"for a regular Fusion",
[IsRegularFusion],
function(rfus)
    return RegularFusionOrbit;
end);

InstallMethod(ConstructorOfStablePartitionOrbitNC,
"for a regular fusion",
[IsRegularFusion],
function(rfus)
    return RegularFusionOrbitNC;
end);
