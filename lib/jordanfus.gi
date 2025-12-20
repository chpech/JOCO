#############################################################################
##
##  jordanfus.gi                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Implementation of the datatype of Jordan fusions
##
#############################################################################



InstallMethod(ColorPartition,
"for Jordan fusions",
[ IsColorPartition and IsJordanFusion, IsColorGraph, IsList ],
function(filter, cgr, cpart)
   local res;

    res:=ColorPartition(IsColorPartition, cgr,cpart);
    SetIsJordanFusion(res,true);

    return res;

end);

InstallMethod(OnColorPartitions,
"for a Jordan fusion and a permutation",
[IsColorPartition and IsJordanFusion, IsPerm],
function(cpart, g)
    local res;
    
    return ColorPartition(IsColorPartition and IsJordanFusion, 
                          UnderlyingCgrOfColorPartition(cpart),
                          OnTuplesSets(UnderlyingPartitionOfColorPartition(cpart), g));
end);


InstallMethod( StablePartitionFromCompletePartialStablePartition,
"for a partial Jordan fusion in PartialJordanFusionRep",
[IsPartialJordanFusion and IsPartialColorPartitionRep],
function(cpfus)
    local obj;
    
    #   Assert(1, OnSetsSets(Set(cpfus!.part.classes),Mates(cpfus!.tensor))=Set(cpfus!.part.classes));
    
    return ColorPartition(IsColorPartition and IsJordanFusion, cpfus!.cgr,
   	      cpfus!.part.classes);
end);

InstallMethod(ViewString,
"for a Jordan fusion",
[IsColorPartition and IsJordanFusion],
function(x)
    return Concatenation("<Jordan fusion of order ", String(Order(x)), " and rank ", String(Rank(x)), ">");
end);

InstallMethod(FusionColorGraph,
"for WL-fusions",              
[IsColorPartition and IsJordanFusion],
function(rfus)
    local cgr;
    
    cgr:=ColorGraphByFusion(UnderlyingCgrOfColorPartition(rfus),
                            UnderlyingPartitionOfColorPartition(rfus));
    SetIsRainbow(cgr,true);
    SetIsRegularColorGraph(cgr,true);
    SetIsJStableColorGraph(cgr,true);
    
    return cgr;
end);

InstallOtherMethod(HomogeneousJordanFusionOrbits,
"for a J-stable color graph and a list of J-stable color sets",
[IsColorGraph and IsJStableColorGraph, IsList],
function(cgr,gsorbits)
    local  pfus, iter;

    if not ForAll(gsorbits, IsRegularSetOrbit) then
        ErrorNoReturn("HomogeneousJordanFusionOrbits: expecting a list of regular set orbits");
    fi;
    if not ForAll(gsorbits, gso->IsIdenticalObj(FamilyObj(Representative(gso)),FamilyObj(Representative(gsorbits[1])))) then
        ErrorNoReturn("HomogeneousJordanFusionOrbits: regular set orbits are incompatible");
    fi;
    if not ForAll(gsorbits, gso->IsJStableSet(Representative(gso))) then 
        ErrorNoReturn("HomogeneousJordanFusionOrbits: expecting a list of orbits of Jordan stable regular set orbits");
    fi;
    
    if gsorbits<>[] then
        if not IsIdenticalObj(cgr,UnderlyingCgrOfColorSet(Representative(gsorbits[1]))) then
            ErrorNoReturn("HomogeneousJordanFusionOrbits: regular set orbits are incompatible");
        fi;
    fi;
    
   
    pfus:=EmptyPartialJordanFusion(cgr);
    
    iter:=IteratorOfPartialStablePartitionOrbits(pfus,gsorbits);
    
    return AllStablePartitionOrbits(iter);
    
end);


InstallMethod(HomogeneousJordanFusionOrbits,
"for a J-stable color graph",
[IsColorGraph and IsJStableColorGraph],
function(cgr)
    local gsorbs;
    
    gsorbs:=HomogeneousJStableSetOrbits(cgr);
    return HomogeneousJordanFusionOrbits(cgr,gsorbs);
end);

InstallOtherMethod(HomogeneousJordanFusionOrbits,
"for a color graph and a permutation group",
        [IsColorGraph and IsJStableColorGraph, IsPermGroup],
function(cgr,grp)
    local  gsorbs, rforb;
    
    gsorbs:=HomogeneousJStableSetOrbits(cgr,grp);
    rforb:=HomogeneousJordanFusionOrbits(cgr,gsorbs);
    
    return gsorbs;
end);

InstallGlobalFunction(PosetOfFusionOrbits,
function(lforb)
    local  cgr, order, linorder, runtime, tstart, tensor, aaut, caut, 
           aautfusorbs, cautfusorbs, ltwins, algebraicFusions, i, 
           suborbs, twins, forb, mrg, part, isAlgFus, j, poset, rt;
    
    order:=function(yy,xx)
        local part1,part2,cosreps;
        
        part1:=AsPartition(Representative(cautfusorbs[yy]));
        part2:=AsPartition(Representative(cautfusorbs[xx]));
        
        if Length(part1)=Length(part2) then 
            return part1=part2;
        fi;
        
        cosreps:=List(DoubleCosetsNC(UnderlyingGroupOfCocoOrbit(cautfusorbs[xx]), StabilizerOfCanonicalRepresentative(cautfusorbs[xx]),  StabilizerOfCanonicalRepresentative(cautfusorbs[yy])),Representative);
        return ForAny(cosreps, r->ForAll(OnSetsSets(part2,r), x->ForAny(part1, y->IsSubset(y,x))));
    end;
    
    if lforb=[] then
        return fail;
    fi;
    
    
    if not ForAll(lforb, IsColorPartitionOrbit) then
        ErrorNoReturn("PosetOfFusionOrbits: expecting a list of color partition orbits");
    fi;
    
    if not ForAll(lforb, forb->IsIdenticalObj(FamilyObj(forb),FamilyObj(lforb[1]))) then
        ErrorNoReturn("PosetOfFusionOrbits: fusion orbits are incompatible");
    fi;
    
    cgr:=UnderlyingCgrOfColorPartition(Representative(lforb[1]));
    if not IsIdenticalObj(cgr,UnderlyingCgrOfColorPartition(Representative(lforb[1]))) then
        ErrorNoReturn("PosetOfFusionOrbits: fusion orbits are incompatible");
    fi;
    
    
    linorder:=function(x,y)
        return cautfusorbs[x]<cautfusorbs[y];
    end;

    
    runtime:=ValueOption("runtime");
    if runtime=fail then
        runtime:=false;
    fi;
    
    if runtime then
        tstart:=NanosecondsSinceEpoch();
    fi;
    
    aaut:=UnderlyingGroupOfCocoOrbit(lforb[1]);
    caut:=ColorAutomorphismGroupOnColors(cgr);
    
    
    aautfusorbs:=Set(lforb);
    cautfusorbs:=[];ltwins:=[];
    algebraicFusions:=[];
    Info(InfoJOCO,1,"Computing algebraic fusions and algebraic twins.\n");
    for i in [1..Length(aautfusorbs)] do
        suborbs:=SubOrbitsOfCocoOrbit(caut,aautfusorbs[i]);
        twins:=[Length(cautfusorbs)+1..Length(cautfusorbs)+Length(suborbs)];
        forb:=aautfusorbs[i];
        mrg:=AsPartition(CanonicalRepresentativeOfCocoOrbit(forb));
        part:=Orbits(Stabilizer(StabilizerOfCanonicalRepresentative(forb),mrg,OnTuplesSets),[1..Order(Representative(forb))]);
        if Length(part)=Length(mrg) then
            isAlgFus:=true;
        else
            isAlgFus:=false;
        fi;
        
        for j in [1..Length(suborbs)] do
            Add(cautfusorbs,suborbs[j]);
            Add(ltwins, Difference(twins, [twins[j]]));
            if isAlgFus then 
                Add(algebraicFusions,Length(cautfusorbs));
            fi;
        od;
        Info(InfoJOCO,1,"*");
    od;
    Info(InfoJOCO,1,"\nDone computing algebraic fusions and algebraic twins.\n");
    
    poset:=CocoPosetByFunctions([1..Length(cautfusorbs)], order, linorder);
    poset!.algTwins:=Immutable(List(poset!.elements, x->List(ltwins[x],y->Position(poset!.elements,y))));
    poset!.algebraicFusions:=Immutable(Filtered([1..Length(poset!.elements)], i->poset!.elements[i] in algebraicFusions));
    poset!.elements:=Immutable(List(poset!.elements, i->cautfusorbs[i]));
    poset!.colorGraphs:=Immutable(List(poset!.elements, 
                       forb->FusionColorGraph(CanonicalRepresentativeOfCocoOrbit(forb))));
    poset!.cgr:=cgr;
    
    
    SetFilterObj(poset,IsPosetOfFusionOrbits);
    SetFilterObj(poset,IsPosetOfFusionOrbitsRep);
    
    if runtime then
        rt:=StringTime(Int((NanosecondsSinceEpoch()-tstart)/1000000));
        RemoveCharacters(rt," ");
        
        SetComputationTime(poset, rt);
    fi;

    return poset;
end);


InstallOtherMethod(DisplayString,
"for posets of fusion orbits",
[IsPosetOfFusionOrbits and IsPosetOfFusionOrbitsRep, IsList],10,
function(pos, indices)
    local  MapRepsPoset, jstable, wlstable, filt, proper, nonsch, long, 
           schfiss, fvc, onlyfvc, cisomap, date, runtime, strucexp, i, 
           cgrr, ord, nodes, node, srg, value, outp, res, cgr, ninf, 
           str, maxlength, scgr, mrg, idx, v, mcgr, isproper, index, 
           algtwins, jcl, wcl, sch, showjclosure, showwlclosure, 
           strictupperbounds, maxin, jcgr, mnode, cisorep, flt, showidx, 
           symfus, ideal,comma,cisoreps;
    
    
    MapRepsPoset:=function(i)
        local  list,fct, idx;
        
        list:=List(nodes, x->x!.cgr);
        fct:=IsColorIsomorphicColorGraph;
        
                 
        if not IsBound(pos!.cisoMap) then
            pos!.cisoMap:=[];
        fi;
        
        if IsBound(pos!.cisoMap[i]) then
            idx:=pos!.cisoMap[i];
        else
            idx:=First([1..Length(list)], j->fct(list[i],list[j]));
            pos!.cisoMap[i]:=idx;
        fi;
        
        return idx;
    end;
    
    showidx:=false;
    if indices <> [1..Size(pos)] then
        showidx:=true;
    fi;
    
    
    jstable:=ValueOption("jstable");
    if jstable=fail then
        jstable:=false;
    fi;
    if jstable then 
        showidx:=true;
    fi;
    
    
    wlstable:=ValueOption("wlstable");
    if wlstable=fail then
        wlstable:=false;
    fi;
    if wlstable then 
        showidx:=true;
    fi;
    
    
    filt:=ValueOption("filter");
    if filt=fail then
        filt:=ReturnTrue;
    fi;
    if filt<>ReturnTrue then 
        showidx:=true;
    fi;

    
    proper:=ValueOption("proper");
    if proper=fail then
        proper:=false;
    fi;
    if proper then 
        showidx:=true;
    fi;
    
    
    nonsch:=ValueOption("nonschurian");
    if nonsch=fail then
        nonsch:=false;
    fi;
    if nonsch then 
        showidx:=true;
    fi;
    
    long:=ValueOption("long");
    if long=fail then
        long:=false;
    fi;

    schfiss:=ValueOption("schurianfission");
    if schfiss=fail then
        schfiss:=false;
    fi;
    
    fvc:=ValueOption("fvc");
    if fvc=fail then
        fvc:=false;
    fi;
    
    onlyfvc:=ValueOption("onlyfvc");
    if onlyfvc=fail then
        onlyfvc:=false;
    fi;
    if onlyfvc then 
        showidx:=true;
    fi;

    
    cisomap:=ValueOption("cisomap");
    if cisomap=fail then
        cisomap:=false;
    fi;
    
    date:=ValueOption("date");
    if date=fail then
        date:=false;
    fi;
    
    runtime:=ValueOption("runtime");
    if runtime=fail then
        runtime:=false;
    fi;
    
    strucexp:=ValueOption("strucexp");
    if strucexp=fail then
        strucexp:=12;
    fi;
    
    cisoreps:=ValueOption("cisoreps");
    if cisoreps=fail then
        cisoreps:=false;
    fi;
    
    
    Perform(pos!.colorGraphs, IsRainbow);
    Perform(pos!.colorGraphs, IsJStableColorGraph);
    Perform(pos!.colorGraphs, IsWLStableColorGraph);
    
    Info(InfoJOCO,1,"Computing structure descriptions of symmetry groups of cgr.\n");
    if Rank(pos!.cgr)>2 and (Rank(pos!.cgr)>3 or IsPrimitiveColorGraph(pos!.cgr)) then
        ord:=PrimePowersInt(Size(AutomorphismGroup(pos!.cgr)));
        ord:=ord{[2,4..Length(ord)]};
        if ForAll(ord, x->x<=strucexp) then
            StructureDescription(AutomorphismGroup(pos!.cgr):short);
        fi;
    fi;
    
    if IsJStableColorGraph(pos!.cgr) then
        ord:=PrimePowersInt(Size(JAlgebraicAutomorphismGroup(pos!.cgr)));
        ord:=ord{[2,4..Length(ord)]};
        if ForAll(ord, x->x<=strucexp) then
            StructureDescription(JAlgebraicAutomorphismGroup(pos!.cgr):short);
        fi;
        
        if IsWLStableColorGraph(pos!.cgr) then 
            ord:=PrimePowersInt(Size(AlgebraicAutomorphismGroup(pos!.cgr)));
            ord:=ord{[2,4..Length(ord)]};
            if ForAll(ord, x->x<=strucexp) then
                StructureDescription(AlgebraicAutomorphismGroup(pos!.cgr):short);
            fi;
        fi;
    fi;
    Info(InfoJOCO,1,"\nDone computing structure descriptions of symmetry groups of cgr.\n");
    
    Info(InfoJOCO,1,"Computing structure descriptions of symmetry groups of poset elements.\n");
    for i in [1..Size(pos)] do
        cgrr:=pos!.colorGraphs[i];
        if Rank(cgrr)>2 and (Rank(cgrr)>3 or IsPrimitiveColorGraph(cgrr)) then
            ord:=PrimePowersInt(Size(AutomorphismGroup(cgrr)));
            ord:=ord{[2,4..Length(ord)]};
            if ForAll(ord, x->x<=strucexp) then
                StructureDescription(AutomorphismGroup(cgrr):short);
            fi;
        
            ord:=PrimePowersInt(Size(ColorAutomorphismGroupOnColors(cgrr)));
            ord:=ord{[2,4..Length(ord)]};
            if ForAll(ord, x->x<=strucexp) then
                StructureDescription(ColorAutomorphismGroupOnColors(cgrr):short);
            fi;
            if IsJStableColorGraph(cgrr) then
                ord:=PrimePowersInt(Size(JAlgebraicAutomorphismGroup(cgrr)));
                ord:=ord{[2,4..Length(ord)]};
                if ForAll(ord, x->x<=strucexp) then
                    StructureDescription(JAlgebraicAutomorphismGroup(cgrr):short);
                fi;
                              
                if IsWLStableColorGraph(cgrr) then 
                    ord:=PrimePowersInt(Size(AlgebraicAutomorphismGroup(cgrr)));
                    ord:=ord{[2,4..Length(ord)]};
                    if ForAll(ord, x->x<=strucexp) then
                        StructureDescription(AlgebraicAutomorphismGroup(cgrr):short);
                    fi;
                fi;
            fi;
        fi;
        

        Info(InfoJOCO,1,".");
    od;
    Info(InfoJOCO,1,"\nDone computing structure descriptions of symmetry groups of poset elements.\n");
    
    Info(InfoJOCO,1,"Creating COCO-nodes for poset elements.\n");
    nodes:=[];
    for i in [1..Size(pos)] do
        node:=NewCocoNode(pos!.colorGraphs[i]);
        node!.index:=i;
        node!.poset:=pos;
        RegisterInfoCocoNode(node, rec(name:="Number:", value:=String(node!.index)));
        RegisterInfoCocoNode(node, rec(name:="Orbit length:", value:=String(Size(pos!.elements[i]))));
        if IsWLStableColorGraph(node!.cgr) then
            RegisterStandardInfoRainbow@JOCO(node);
            if fvc then
                if Rank(node!.cgr)=3 and IsSymmetricColorGraph(node!.cgr) and not IsSchurian(node!.cgr) then
                    srg:=SrgFromCgr@COCO2P(node!.cgr);
                    RegisterInfoCocoNode(node, rec(name:="4-vc:",
                                                   value:=String(IsHighlyRegularGraph(srg,2,4))));
                fi;
            fi;
        else
            RegisterStandardInfoRainbow@JOCO(node);
        fi;
        
        RegisterInfoCocoNode(node, rec(name:="algebraic:", value:=String(node!.index in node!.poset!.algebraicFusions)));
        Add(nodes,node);
        Info(InfoJOCO,1,".");
    od;
    Info(InfoJOCO,1,"\nDone creating COCO-nodes for poset elements.\n");
    
    
    outp:="";
    res:=OutputTextString(outp,true);
    SetPrintFormattingStatus(res,false);


    PrintTo(res,"JOCO - Information about a poset of FusionOrbits\n",
                "------------------------------------------------\n");
    Info(InfoJOCO,1,"Creating COCO-node cgr and gathering information about cgr.\n");
    cgr:=pos!.cgr;
    node:=NewCocoNode(cgr);
    RegisterStandardInfoRainbow@JOCO(node);
    if IsWLStableColorGraph(node!.cgr) and fvc then
        if Rank(node!.cgr)=3 and IsSymmetricColorGraph(node!.cgr) and not IsSchurian(node!.cgr) then
            srg:=SrgFromCgr@COCO2P(node!.cgr);
            RegisterInfoCocoNode(node, rec(name:="4-vc:",
                                           value:=String(IsHighlyRegularGraph(srg,2,4))));
        fi;
    fi;
    ninf:=node!.nodeInfo;

    ComputeAllInfos(node);
    for str in infoOptions@COCO2P.disabled do
        ComputeInfo(node,str);
    od;
    AppendTo(res, NodeInfoString(node));
    maxlength:=Maximum(ninf.maxlength, 20);
    if IsRainbow(node!.cgr) and not IsUndirectedColorGraph(node!.cgr) then
        AppendTo(res, String("asymm. mates: ",-maxlength), StringCocoPerm@COCO2P(ColorMates(node!.cgr)),"\n");
    fi;
    if not IsTransitive(AutomorphismGroup(node!.cgr),[1..OrderOfColorGraph(cgr)]) then
        AppendTo(res, String("Orbits of Aut: ",-maxlength));
        AppendTo(res, StringCocoOrbReps@COCO2P(AutomorphismGroup(node!.cgr),[1..OrderOfColorGraph(cgr)]));
    fi;
    AppendTo(res,String("Color Reps: ",-maxlength),"\n");
    AppendTo(res,"   ", StringCocoIndented(StringCocoColorReps(cgr),3));
    if long and Rank(node!.cgr)>2 and not ( Rank(node!.cgr)=3 and not IsPrimitive(node!.cgr)) then
        AppendTo(res, String("Generators of Aut: ",-maxlength),"\n");
        AppendTo(res, StringCocoGenerators@COCO2P(AutomorphismGroup(node!.cgr), OrderOfColorGraph(cgr)));
        
        scgr:=ColorGraph(AutomorphismGroup(node!.cgr),[1..OrderOfColorGraph(cgr)],OnPoints,true);
        if not IsWLStableColorGraph(node!.cgr) or not IsSchurian(node!.cgr) then
            AppendTo(res, String("Merging in Cgr(Aut): ",-maxlength),"\n");
            mrg:=Set([1..Rank(node!.cgr)], i->Filtered([1..Rank(scgr)], j->ArcColorOfColorGraph(node!.cgr,ColorRepresentative(scgr,j))=i));
            AppendTo(res, StringCocoMerging@COCO2P(mrg));
        fi;
    fi;
    Info(InfoJOCO,1,"\nDone creating COCO-node cgr and gathering information about cgr.\n");
    
    AppendTo(res, "-------------------------------------------------\n");
    if date then
        PrintTo(res, String("                   Date: ",-maxlength), TodayString@COCO2P(),"\n");
    fi;
    if runtime then
        PrintTo(res, String("                Runtime: ",-maxlength), ComputationTime(pos),"\n");
    fi;
    if IsWLStableColorGraph(pos!.cgr) then
        PrintTo(res, "Algebraic fusions are with respect to AAut!\n\n");
    elif IsJStableColorGraph(pos!.cgr) then
        PrintTo(res, "Algebraic fusions are with respect to JAut!\n\n");
    else
        PrintTo(res, "Algebraic fusions are with respect to CAut/Aut!\n\n");
    fi;
    
    PrintTo(res, String("Number of fusion orbits: ",-maxlength), Length(nodes{indices}),"\n");
    PrintTo(res, String("              symmetric: ",-maxlength), Length(Filtered(nodes{indices}, x->IsSymmetricColorGraph(x!.cgr))),"\n");
    PrintTo(res, String("              primitive: ",-maxlength), Length(Filtered(nodes{indices}, x->IsPrimitiveColorGraph(x!.cgr))),"\n");
    PrintTo(res, String("  symmetric & primitive: ",-maxlength), Length(Filtered(nodes{indices}, x->IsSymmetricColorGraph(x!.cgr) and IsPrimitiveColorGraph(x!.cgr))),"\n");
    PrintTo(res, "-------------------------------------------------\n\n");
    PrintTo(res, "options: ");
    
    comma:=false;
    if onlyfvc then 
        PrintTo(res, "onlyfvc");
        comma:=true;
    fi;
    if jstable then
        if comma then
            PrintTo(res,", ");
        fi;
        PrintTo(res, "jstable");
        comma:=true;
    fi;
    if wlstable then
        if comma then
            PrintTo(res,", ");
        fi;
        PrintTo(res, "wlstable");
        comma:=true;
    fi;
    
    if filt<>ReturnTrue then
        if comma then
            PrintTo(res,", ");
        fi;
        PrintTo(res, "filter");
        comma:=true;
    fi;
    if proper then
        if comma then
            PrintTo(res,", ");
        fi;
        PrintTo(res, "proper");
        comma:=true;
    fi;
    if nonsch then
        if comma then
            PrintTo(res,", ");
        fi;
        PrintTo(res, "nonschurian");
        comma:=true;
    fi;
    if long then
        if comma then
            PrintTo(res,", ");
        fi;
        PrintTo(res, "long");
        comma:=true;
    fi;
    if cisoreps then
        if comma then
            PrintTo(res,", ");
        fi;
        PrintTo(res, "cisoreps");
        comma:=true;
    fi;
    
    if cisomap then
        if comma then
            PrintTo(res,", ");
        fi;
        PrintTo(res, "cisomap");
        comma:=true;
    fi;
    
    if not comma then
        PrintTo(res, "none");
    fi;
    
    PrintTo(res, "\n\n-------------------------------------------------\n\n");
    
    
    idx:=0;
    
    Info(InfoJOCO,1, "Gathering info about fusion orbits.\n");
    for v in indices do
        node:=nodes[v];
        ninf:=node!.nodeInfo;
        
        if jstable and not IsJStableColorGraph(node!.cgr) then
            continue;
        fi;
        
        if wlstable and not IsWLStableColorGraph(node!.cgr) then
            continue;
        fi;
        
        if proper and not IsJStableColorGraph(node!.cgr) then
            continue;
        fi;
        
        mcgr:=ColorGraphByWLStabilization(node!.cgr);
        

        if IsJStableColorGraph(node!.cgr) then
            isproper:=SymmetrizedRank(mcgr)<>Rank(node!.cgr);
        
            if proper then
                if not isproper then
                    continue;
                fi;
            fi;
        fi;

        if nonsch and not IsWLStableColorGraph(node!.cgr) then
            continue;
        fi;
        
        if IsWLStableColorGraph(node!.cgr) then
            if nonsch then
                if IsSchurian(node!.cgr) then
                    continue;
                fi;
            fi;
        fi;
        
        if onlyfvc and not IsWLStableColorGraph(node!.cgr) then
            continue;
        fi;
        
        if IsWLStableColorGraph(node!.cgr) then
            if onlyfvc then
                if Rank(node!.cgr)>3 or 
                   not IsSymmetricColorGraph(node!.cgr) or 
                       IsSchurian(node!.cgr) or 
                       not IsHighlyRegularGraph(SrgFromCgr@COCO2P(node!.cgr),2,4) 
                then
                    continue;
                fi;
            fi;
        fi;
        
        if not filt(node!.cgr) then
            continue;
        fi;
        
        index:=IndexOfCocoNode(node);
        if cisoreps then
            cisorep:=MapRepsPoset(index);
            if cisorep<>index then
                continue;
            fi;
        fi;
        
        idx:=idx+1;

        maxlength:=Maximum(ninf.maxlength, 20);
        if showidx then
            AppendTo(res,String("Index: ",-maxlength), idx,"\n");
        fi;
        AppendTo(res, NodeInfoString(node));
        if IsRainbow(node!.cgr) and not IsUndirectedColorGraph(node!.cgr) then
            AppendTo(res, String("asymm. mates: ",-maxlength), StringCocoPerm@COCO2P(ColorMates(node!.cgr)),"\n");
        fi;
        mrg:=List([1..Rank(node!.cgr)], x->Filtered([1..Rank(cgr)], y->ArcColorOfColorGraph(node!.cgr,ColorRepresentative(cgr,y))=x));
        if IsUndirectedColorGraph(node!.cgr) then
            mrg:=List(mrg, x->Set(x, y->Set([y,y^ColorMates(cgr)])));
            AppendTo(res, String("Merging in sym(Cgr): ", -maxlength),"\n");
            AppendTo(res, "   ", StringCocoIndented(StringCocoListListsSets(mrg-1),3));
        else
            AppendTo(res, String("Merging in Cgr: ", -maxlength),"\n");
            AppendTo(res, "   ", StringCocoIndented(StringCocoMerging@COCO2P(mrg),3));
        fi;
        algtwins:=Intersection(pos!.algTwins[index], indices);
        if algtwins<>[] then
            AppendTo(res, String("Algebraic Twins: ",-maxlength), algtwins,"\n");
        fi;
        flt:=FilterInCocoPoset(pos, v);
                
        jcl:=Filtered(flt, i->IsJStableColorGraph(pos!.colorGraphs[i]));
        ideal:=IdealInCocoPoset(pos,v);
        symfus:=Filtered(ideal, i->IsUndirectedColorGraph(pos!.colorGraphs[i]));
        symfus:=MaximalElementsInCocoPoset(pos,symfus);
        if Length(symfus)=1 then
            if symfus[1]<>v then 
                AppendTo(res, String("Symm. fus. in pos.: ",-maxlength),"#", symfus[1],"\n");
            fi;
        elif Length(symfus)>1 then
            AppendTo(res, String("Symm. fus. in pos.: ",-maxlength), StringList@JOCO(symfus),"\n");
        else
            AppendTo(res, String("No symm. fus. in pos. ",-maxlength), "\n");
        fi;
        
        wcl:=Filtered(jcl, i->IsWLStableColorGraph(pos!.colorGraphs[i]));
        if schfiss then 
            sch:=Filtered(wcl, i-> IsSchurian(pos!.colorGraphs[i]));
            sch:=MinimalElementsInCocoPoset(pos,sch);
            if Length(sch)=1 then
                if sch[1]<>v then 
                    AppendTo(res, String("Sch. fiss. in pos.: ",-maxlength),"#", sch[1],"\n");
                fi;
            elif Length(sch)>1 then
                AppendTo(res, String("Sch. fiss. in pos.: ",-maxlength), StringList@JOCO(sch),"\n");
            fi;
        fi;
        jcl:=MinimalElementsInCocoPoset(pos,jcl);
        showjclosure:=true;
        
        if Length(jcl)=1 then
            if IsJStableColorGraph(node!.cgr) or Rank(ColorGraphByJStabilization(node!.cgr)) = Rank(pos!.colorGraphs[jcl[1]]) then
                showjclosure:=false;
            fi;
            if jcl[1]<>v then
                AppendTo(res, String("J-fiss. in pos.: ",-maxlength), "#",jcl[1],"\n");
            fi;
        elif Length(jcl)>1 then
            AppendTo(res, String("J-fiss. in pos.: ",-maxlength), StringList@JOCO(jcl),"\n");
        fi;
        wcl:=MinimalElementsInCocoPoset(pos,wcl);
        showwlclosure:=true;
        if Length(wcl)=1 then
            if IsWLStableColorGraph(node!.cgr) or Rank(mcgr) = Rank(pos!.colorGraphs[wcl[1]]) then
                showwlclosure:=false;
            fi;
            if wcl[1]<>v then
                AppendTo(res, String("WL-fiss. in pos.: ",-maxlength),"#", wcl[1],"\n");
            fi;
        elif Length(wcl)>1 then
            AppendTo(res, String("WL-fiss. in pos.: ",-maxlength), StringList@JOCO(wcl),"\n");
        fi;
        

        strictupperbounds:=Difference(FilterInCocoPoset(pos,index),[index]);
        strictupperbounds:=Intersection(strictupperbounds,indices);
        maxin:=[];
        if strictupperbounds<>[] then
            maxin:=MinimalElementsInCocoPoset(pos,strictupperbounds);
        fi;

        AppendTo(res, String("Maximal Merging in: ",-maxlength), maxin,"\n");
        
        
        if showwlclosure then
            AppendTo(res, String("WL-stabilization: ",-maxlength));
            if IsSchurian(mcgr) then
                AppendTo(res, "Schurian\n");
            else
                AppendTo(res,"\n");
                
                mnode:=NewCocoNode(mcgr);
                RegisterStandardInfoRainbow@JOCO(mnode);
            
                ComputeAllInfos(mnode);
                for str in infoOptions@COCO2P.disabled do
                    ComputeInfo(mnode,str);
                od;
                AppendTo(res, "   ",StringCocoIndented(NodeInfoString(mnode),3));
            fi;
        fi;
        
        
        if showjclosure then
            jcgr:=ColorGraphByJStabilization(node!.cgr);
            AppendTo(res, String("J-stabilization: ",-maxlength));
            
            if Rank(jcgr)= Rank(mcgr) then 
                AppendTo(res, "equal to WL-stabilization\n");
            elif IsUndirectedColorGraph(jcgr) and 
                 Rank(jcgr) = Length(Filtered([1..Rank(mcgr)], i->i<=i^ColorMates(mcgr))) then
                AppendTo(res, "equal to symmetrization of WL-stabilization\n");
            else
                AppendTo(res, "\n");
                
                mnode:=NewCocoNode(jcgr);
                RegisterStandardInfoRainbow@JOCO(mnode);
                
                ComputeAllInfos(mnode);
                
                for str in infoOptions@COCO2P.disabled do
                    ComputeInfo(mnode,str);
                od;
                
                
                AppendTo(res, "   ",StringCocoIndented(NodeInfoString(mnode),3));
            fi;
        fi;
        
        
            
        if cisomap then
            cisorep:=MapRepsPoset(index);
            if cisorep<>index then
                AppendTo(res, String("C-isomorphic to: ",-maxlength), "#",cisorep,"\n");
            fi;
        fi;
        if long and Rank(node!.cgr)>2 and not (Rank(node!.cgr)=3 and not IsPrimitive(node!.cgr)) then
            if not IsTransitive(AutomorphismGroup(node!.cgr),[1..OrderOfColorGraph(cgr)]) then
                AppendTo(res, String("Orbits of Aut: ",-maxlength));
                AppendTo(res, StringCocoOrbReps@COCO2P(AutomorphismGroup(node!.cgr),[1..OrderOfColorGraph(cgr)]));
            fi;
            AppendTo(res, String("Generators of Aut: ",-maxlength),"\n");
            AppendTo(res, StringCocoGenerators@COCO2P(AutomorphismGroup(node!.cgr), OrderOfColorGraph(cgr)));

            scgr:=ColorGraph(AutomorphismGroup(node!.cgr),[1..OrderOfColorGraph(cgr)],OnPoints,true);
            if not IsWLStableColorGraph(node!.cgr) or not IsSchurian(node!.cgr) then
                AppendTo(res, String("Merging in Cgr(Aut): ",-maxlength),"\n");
                mrg:=Set([1..Rank(node!.cgr)], i->Filtered([1..Rank(scgr)], j->ArcColorOfColorGraph(node!.cgr,ColorRepresentative(scgr,j))=i));
                AppendTo(res, StringCocoMerging@COCO2P(mrg));
            fi;
        fi;

        AppendTo(res,"\n");
        Info(InfoJOCO,1,".");
    od;
    Info(InfoJOCO,1, "\nDone gathering info about fusion orbits.\n");

    CloseStream(res);
    return outp;
end);


