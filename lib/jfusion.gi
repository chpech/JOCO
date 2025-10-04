#############################################################################
##
##  jfusion.gi                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##                                                             Sven Reichard
##
##  Implementation of the J-fusion data type
##
#############################################################################

DeclareRepresentation("IsJFusionOfTensorRep",
        IsAttributeStoringRep,
        ["tensor",          # the structure constants tensor over which the fusion lives
         "partition"        # the partition of colors of tensor defining the fusion
]);


InstallMethod(JFusionsFamily,
    "for tensors",
	[IsTensor],
function(cgr)
   local fam;
   fam:=NewFamily("JFusionsFam", IsJFusionOfTensor);
   return fam;
end);

InstallGlobalFunction(JFusionFromPartition,
function(arg)
   local tensor,set,part,res;

   tensor:=arg[1];
   part:=arg[2];
   if not IsJStablePartition(tensor,part) then
       return fail;
   fi;
   return JFusionFromPartitionNC(tensor,part);
end);

InstallGlobalFunction(JFusionFromPartitionNC,
function(tensor,part)
   local obj;

   obj:=rec(
   			   tensor := tensor,
   			partition := Immutable(ShortLexSorted(part)));
   return Objectify(NewType(JFusionsFamily(tensor), IsJFusionOfTensor and IsJFusionOfTensorRep), obj);
end);

InstallOtherMethod(AsPartition,
        "for J-fusions in JFusionOfTensorRep",
        [IsJFusionOfTensor and IsJFusionOfTensorRep],
function(f)
    local res;
    res:=Set(f!.partition, ShallowCopy);
    MakeImmutable(res);
    return res;
end);

InstallMethod(TensorOfJFusion,
        "for J-fusions in JFusionOfTensorRep",
        [IsJFusionOfTensor and IsJFusionOfTensorRep],
function(f)
   return f!.tensor;
end);

InstallMethod(RankOfJFusion,
		"for J-fusions of structure constants tensors",
		[IsJFusionOfTensor and IsJFusionOfTensorRep],
function(fusion)
   return Length(fusion!.partition);
end);

InstallOtherMethod(Rank,
		"for J-fusions of structure constants tensors",
		[IsJFusionOfTensor],
function(fusion)
   return RankOfJFusion(fusion);
end);

InstallMethod(OrderOfJFusion,
        "for J-fusions of structure constants tensors",
        [IsJFusionOfTensor],
function(fusion)
   return OrderOfCocoObject(TensorOfJFusion(fusion));
end);

InstallOtherMethod(Order,
        "for J-fusions of structure constants tensors",
        [IsJFusionOfTensor],
function(fusion)
   return OrderOfJFusion(fusion);
end);

InstallMethod(PartitionOfJFusion,
        "for J-fusions of structure constants tensors",
        [IsJFusionOfTensor and IsJFusionOfTensorRep],
function(fusion)
    return fusion!.partition;
end);


# InstallMethod(SubOrbitsOfCocoOrbit,
#         "for all J-fusion orbits",
#         [IsPermGroup, IsJFusionOrbit],
# function(grp,orb)
#     local   ug,  cosreps,  stab,  rep,  nrep;


#     ug:=UnderlyingGroupOfCocoOrbit(orb);

#     if not IsSubgroup(ug,grp) then
#         Error("SubOrbitsOfCocoOrbit: The given group is not a subgroup of the underlying group of the good set orbit!");
#     fi;
#     stab:=StabilizerOfCanonicalRepresentative(orb);
#     cosreps:=List(DoubleCosetsNC(ug,stab, grp), Representative);
#     rep:=CanonicalRepresentativeOfCocoOrbit(orb);
#     nrep:=JFusionOrbitNC(grp,rep, Intersection(stab,grp));

#     return Set(cosreps, x->OnCocoOrbits(nrep,x));
# end);

# InstallMethod(SubOrbitsWithInvariantPropertyOfCocoOrbit,
#         "for J-fusion orbits",
#         [IsPermGroup, IsJFusionOrbit, IsFunction],
# function(grp,orb,func)
#     local   ug,  cosreps,  stab,  rep,  nrep,  res;

#     ug:=UnderlyingGroupOfCocoOrbit(orb);

#     if not IsSubgroup(ug,grp) then
#         Error("SubOrbitsWithInvariantPropertyOfCocoOrbit: The given group is not a subgroup of the underlying group of the good set orbit!");
#     fi;

#     stab:=StabilizerOfCanonicalRepresentative(orb);
#     cosreps:=List(DoubleCosetsNC(ug,stab,grp), Representative); 
#     rep:=CanonicalRepresentativeOfCocoOrbit(orb);
#     nrep:=JFusionOrbitNC(grp,rep, Intersection(stab,grp));
#     cosreps:=Filtered(cosreps, r->func(OnJFusions(CanonicalRepresentativeOfCocoOrbit(nrep),r)));
#     res:=List(cosreps, x->OnCocoOrbits(nrep,x));
#     return Set(res);
# end);

#########################################################################################

InstallMethod(ViewString,
        "for J-fusions of tensors",
        [IsJFusionOfTensor],
function(x)
    return Concatenation("<J-fusion of order ", String(OrderOfCocoObject(TensorOfJFusion(x))), " and rank ", String(RankOfJFusion(x)), ">");
end);

InstallMethod(ViewString,
        "for J-fusion orbits",
        [IsJFusionOrbit],
        function(x)
    local res;
    
    res:="<";
    if IsMutable(x) then
        Append(res,"mutable ");
    fi;
    Append(res, Concatenation("JFusionOrbit of length ", String(Size(x)),">"));
    return res;
end);


InstallOtherMethod(\<,
        "for J-fusions of tensors",
        IsIdenticalObj,
        [IsJFusionOfTensor,IsJFusionOfTensor],
function(fs1,fs2)
    local   p1,  p2,  i;
    if RankOfJFusion(fs1)<>RankOfJFusion(fs2) then
        return RankOfJFusion(fs1)<RankOfJFusion(fs2);
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
        "for J-fusions of tensors",
        IsIdenticalObj,
        [IsJFusionOfTensor,IsJFusionOfTensor],
function(fs1,fs2)
    return PartitionOfJFusion(fs1)=PartitionOfJFusion(fs2);
end);

InstallMethod(JFusionOrbitsFamilyOp,
        "for a tensor  and a permutation group",
        [IsTensor, IsPermGroup],
function(tensor,g)
    return NewFamily("JFusionOrbitsFam", IsJFusionOrbit);
end);




InstallGlobalFunction(JFusionOrbitsFromJGoodSetOrbits,
function(gsorbits)
    local iter;

    
    iter:=IteratorOfPartialJFusionOrbits(gsorbits);
    
    return AllJFusionOrbits(iter);
    
end);

# JFusionOrbit(<group>, <Jfusion> [,<stab>] )
# <stab> is supposed to be a subgroup of the stabilizer of <fusion> in <group>
InstallGlobalFunction(JFusionOrbit,
function(arg)
    local group,fusion,stab, can,xstab,nstab;

    group:=arg[1];
    fusion:=arg[2];
    if Length(arg)=2 then
        stab:=Stabilizer(group,AsPartition(fusion), OnSetsSets);
    else
        stab:=arg[3];
    fi;

    can:=SetsSetsCanonifiers(group, stab, PartitionOfJFusion(fusion));
    nstab:=ClosureGroup(stab, List(can, x->can[1]*x^(-1)));


    return JFusionOrbitNC(group, OnJFusions(fusion,can[1]), nstab^can[1]);
end);

# <g> must be from Aut(<fusion!.tensor>)
InstallMethod(OnJFusions,
        "for J-fusions in JFusionOfTensorRep",
        [IsJFusionOfTensor and IsJFusionOfTensorRep, IsPerm],
function(fusion, g)
    local res;
    res:=rec(
             tensor:=fusion!.tensor,
             partition:=MakeImmutable(ShortLexSorted(OnSetsSets(Set(fusion!.partition),g)))
    );

    return Objectify(NewType(JFusionsFamily(fusion!.tensor), IsJFusionOfTensor and IsJFusionOfTensorRep), res);
end);


# JFusionOrbitNC(<group>, <Jfusion> [,<stab>])
# <Jfusion> is a J-fusion that is assumed to be minimal (rev-lex wise) in its orbit
# the minimality property is not checked
# <stab> is supposed to be the full (SetsSets-wise) stabilizer of <Jfusion> in <group>
InstallGlobalFunction(JFusionOrbitNC,
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
   return Objectify(NewType(JFusionOrbitsFamily(TensorOfJFusion(fusion),group), IsJFusionOrbit and IsCocoOrbitRep), res);
end);

InstallMethod(HomogeneousJFusionOrbits,
        "for structure constant tensors",
        [IsTensor and IsTensorOfCC],
function(tensor)
    local gsorbs;

    gsorbs:=HomogeneousJGoodSetOrbits(tensor);
    return JFusionOrbitsFromJGoodSetOrbits(gsorbs);
end);

InstallOtherMethod(HomogeneousJFusionOrbits,
        "for structure constant tensors",
        [IsPermGroup, IsTensor and IsTensorOfCC],
function(grp,T)
    local fsorbs;

    if not ForAll(GeneratorsOfGroup(grp), g->IsAutomorphismOfObject(T,g)) then
        Error("The given group must preserve the tensor of structure-constants!");
        return fail;
    fi;
    
    fsorbs:=HomogeneousJFusionOrbits(T);
    if Size(grp)< Size(AutomorphismGroup(T)) then
        fsorbs:=Union(List(fsorbs, fso->SubOrbitsOfCocoOrbit(grp,fso)));
    fi;
    
    return fsorbs;
end);

InstallMethod(OnCocoOrbits,
        "for all J-fusion orbits",
        [IsJFusionOrbit, IsPerm],
function(orb,perm)
    local   grp,  rep,  stab,  nrep;
    
    if perm=() then
        return orb;
    fi;
    
    grp:=UnderlyingGroupOfCocoOrbit(orb);
    rep:=CanonicalRepresentativeOfCocoOrbit(orb);
    stab:=StabilizerOfCanonicalRepresentative(orb);

    nrep:=OnJFusions(rep,perm);
    return JFusionOrbit(grp,nrep,Stabilizer(grp,AsPartition(nrep),OnSetsSets));
end);


InstallMethod(ActionOfCocoOrbit,
        "for all J-fusion orbits",
        [IsJFusionOrbit],
function(orb)
    return OnJFusions;
end);


InstallOtherMethod(PartitionOfFusion,
        "for J-fusions of structure constants tensors",
        [IsJFusionOfTensor],
function(fusion)
    return PartitionOfJFusion(fusion);
end);

# RegisterStandardInfo@JOCO:=function(node)
#     local cgr,tensor,ppolord,qpolord,krein,i,key,ord,srg,val,fvc,prmstr,identification;
    
#     cgr:=node!.cgr;
    
    
        
#     RegisterInfoCocoNode(node,rec(name:="order:",
#                                   getter:=node->OrderOfColorGraph(node!.cgr)));
#     RegisterInfoCocoNode(node,rec(name:="rank:",
#                                   getter:=node->RankOfColorGraph(node!.cgr)));
#     if not IsUndirectedColorGraph(cgr) then
#         RegisterInfoCocoNode(node,rec(name:="sym. rank:",
#                                       getter:=node->Length(Filtered([1..Rank(node!.cgr)], i->i<=i^ColorMates(node!.cgr)))));
#     fi;

#     if RankOfColorGraph(cgr)>=3 then
#         if IsHomogeneous(cgr) then 
#             RegisterInfoCocoNode(node,rec(name:="valencies:", 
#                                           toStr:=StringMultiset@COCO2P,
#                                           getter:=node->OutValencies(node!.cgr)));
#         else
#             RegisterInfoCocoNode(node,rec(name:="# of fibres:",
#                                           getter:=node->NumberOfFibres(node!.cgr)));
#         fi;
#     fi;
#     if IsHomogeneous(cgr) and RankOfColorGraph(cgr)>3 then
#         RegisterInfoCocoNode(node,rec(name:="primitive:",
#                                       getter:=node->IsPrimitiveColorGraph(node!.cgr)));
#         RegisterInfoCocoNode(node,rec(name:="symmetric:",
#                                       getter:=node->IsUndirectedColorGraph(node!.cgr)));
#     fi;
    
#     if IsJStableColorGraph(cgr) and IsHomogeneous(cgr) and IsUndirectedColorGraph(cgr) then
#         RegisterInfoCocoNode(node,rec(name:="proper:",
#                                       getter:=node->IsUndirectedColorGraph(node!.cgr) and 
#                                               Rank(ColorGraphBySymmetrization(ColorGraphByWLStabilization(node!.cgr)))
#                                               <>Rank(node!.cgr)));
#     fi;

#     if RankOfColorGraph(cgr)>2  then
#         RegisterInfoCocoNode(node,rec(name:="order(Aut):",
#                                       toStr:=StringPP,
#                                       tester:=node->HasAutGroupOfCocoObject(node!.cgr),
#                                       getter:=node->Order(AutGroupOfCocoObject(node!.cgr))));
#         RegisterInfoCocoNode(node,rec(name:="Aut:",
#                                       tester:=node->HasAutGroupOfCocoObject(node!.cgr) and HasStructureDescription(AutGroupOfCocoObject(node!.cgr)),
#                                       getter:=node->StructureDescription(AutGroupOfCocoObject(node!.cgr):short)));
#         RegisterInfoCocoNode(node,rec(name:="order(cAut/Aut):", 
#                                       toStr:=StringPP,
#                                       tester:=node->HasColorAutomorphismGroupOnColors(node!.cgr),
#                                       getter:=node->Order(ColorAutomorphismGroupOnColors(node!.cgr))));
#         RegisterInfoCocoNode(node,rec(name:="cAut/Aut:",
#                                       tester:=node->HasColorAutomorphismGroupOnColors(node!.cgr),
#                                       getter:=node->StructureDescription(ColorAutomorphismGroupOnColors(node!.cgr):short)));
#         if IsJStableColorGraph(cgr) then
#             RegisterInfoCocoNode(node,rec(name:="[aAut:cAut/Aut]:", 
#                                           toStr:=StringPP, 
#                                           tester:=node->HasAlgebraicAutomorphismGroup(node!.cgr) and HasColorAutomorphismGroupOnColors(node!.cgr),
#                                           getter:=node->Order(AlgebraicAutomorphismGroup(node!.cgr))/Order(ColorAutomorphismGroupOnColors(node!.cgr))));
#             RegisterInfoCocoNode(node,rec(name:="aAut:", 
#                                           tester:=node->HasAlgebraicAutomorphismGroup(node!.cgr),
#                                           getter:=node->StructureDescription(AlgebraicAutomorphismGroup(node!.cgr):short)));
#         fi;
#     fi;
# end;




# StringJFusionInfo:=function(cgr,lcgr)
#     local  proper, long, cisomap, map, i, cgrr, ord, nodes, node, 
#            outp, res, ninf, str, maxlength, scgr, mrg, idx, v, mcgr, 
#            isproper, index, mnode, cisorep;
    
        
    
#     proper:=ValueOption("proper");
#     if proper=fail then
#         proper:=false;
#     fi;
#     long:=ValueOption("long");
#     if long=fail then
#         long:=false;
#     fi;

#     cisomap:=ValueOption("cisomap");
#     if cisomap=fail then
#         cisomap:=false;
#     fi;
    
#     Perform(lcgr, IsJStableColorGraph);
    
#     map:=MapReps(lcgr, IsColorIsomorphicColorGraph);
    
    
#     for i in [1..Length(lcgr)] do
#         cgrr:=lcgr[i];
#         if Rank(cgrr)>2 and (Rank(cgrr)>3 or IsPrimitive(JStructureConstantsOfColorGraph(cgrr))) then
#             ord:=PrimePowersInt(Size(AutomorphismGroup(cgrr)));
#             ord:=ord{[2,4..Length(ord)]};
#             if ForAll(ord, x->x<=12) then
# #            if RemInt(Size(AutomorphismGroup(cgrr)),2^12)<>0 then
#                 StructureDescription(AutomorphismGroup(cgrr):short);
#             fi;
#         fi;Info(InfoCOCO,1,".");
#     od;
#     Info(InfoCOCO,1,"|");
    
#     nodes:=[];
#     for i in [1..Length(lcgr)] do
#         node:=NewCocoNode(lcgr[i]);
#         node!.index:=i;
#         node!.ucgr:=cgr;
#         RegisterInfoCocoNode(node, rec(name:="Number:", value:=String(node!.index)));
#         RegisterStandardInfo@JOCO(node);
        
#         Add(nodes,node);
#         Info(InfoCOCO,1,".");
#     od;
#     Info(InfoCOCO,1,"|");
    
    
#     outp:="";
#     res:=OutputTextString(outp,true);
#     SetPrintFormattingStatus(res,false);


#     PrintTo(res,"JOCO - Information about a List of Jordan schemes\n",
#                 "-------------------------------------------------\n");
#     node:=NewCocoNode(cgr);
#     RegisterStandardInfo@COCO2P(node);
#     ninf:=node!.nodeInfo;

#     ComputeAllInfos(node);
#     for str in infoOptions@COCO2P.disabled do
#         ComputeInfo(node,str);
#     od;
#     AppendTo(res, NodeInfoString(node));
#     maxlength:=Maximum(ninf.maxlength, 20);
#     AppendTo(res,String("Color Reps: ",-maxlength),"\n");
#     AppendTo(res,"   ", StringCocoIndented(StringCocoColorReps(cgr),3));
    
#     if long and Rank(node!.cgr)>2 and not ( Rank(node!.cgr)=3 and not IsPrimitive(node!.cgr)) then
#         if not IsTransitive(AutomorphismGroup(node!.cgr),[1..OrderOfColorGraph(cgr)]) then
#             AppendTo(res, String("Orbits of Aut: ",-maxlength));
#             AppendTo(res, StringCocoOrbReps@COCO2P(AutomorphismGroup(node!.cgr),[1..OrderOfColorGraph(cgr)]));
#         fi;
#         AppendTo(res, String("Generators of Aut: ",-maxlength),"\n");
#         AppendTo(res, StringCocoGenerators@COCO2P(AutomorphismGroup(node!.cgr), OrderOfColorGraph(cgr)));
        
#         scgr:=ColorGraph(AutomorphismGroup(node!.cgr),[1..OrderOfColorGraph(cgr)],OnPoints,true);
#         if not IsSchurian(node!.cgr) then
#             AppendTo(res, String("Merging in Cgr(Aut): ",-maxlength),"\n");
#             mrg:=Set([1..Rank(node!.cgr)], i->Filtered([1..Rank(scgr)], j->ArcColorOfColorGraph(node!.cgr,ColorRepresentative(scgr,j))=i));
#             AppendTo(res, StringCocoMerging@COCO2P(mrg));
#         fi;
#     fi;
#     AppendTo(res, "-------------------------------------------------\n");
    
#     PrintTo(res, String("Number of Jordan schemes: ",-maxlength), Length(nodes),"\n");
#     PrintTo(res, String("               primitive: ",-maxlength), Length(Filtered(nodes, x->IsPrimitive(JStructureConstantsOfColorGraph(x!.cgr)))),"\n");
#     PrintTo(res,  "-------------------------------------------------\n");
    
    
    
#     idx:=0;
    
#     for v in [1..Length(nodes)] do
#         node:=nodes[v];
#         ninf:=node!.nodeInfo;
#         mcgr:=ColorGraphByWLStabilization(node!.cgr);
#         isproper:=Rank(ColorGraphBySymmetrization(mcgr))<>Rank(node!.cgr);
        
#         if proper then
#             if not isproper then
#                 continue;
#             fi;
#         fi;
       
#         idx:=idx+1;

#         maxlength:=Maximum(ninf.maxlength, 20);
#         if proper then
#             AppendTo(res,String("Index: ",-maxlength), idx,"\n");
#         fi;
#         index:=IndexOfCocoNode(node);
        
#         AppendTo(res, NodeInfoString(node));
#         mrg:=List([1..Rank(node!.cgr)], x->Filtered([1..Rank(cgr)], y->ArcColorOfColorGraph(node!.cgr,ColorRepresentative(cgr,y))=x));
#         mrg:=List(mrg, x->Set(x, y->Set([y,y^ColorMates(cgr)])));
#         AppendTo(res, String("Merging in sym(Cgr): ", -maxlength),"\n");
#         AppendTo(res, "   ", StringCocoIndented(StringCocoListListsSets(mrg-1),3));
        
        
#         if isproper then
#             AppendTo(res, String("WL-stabilization: ",-maxlength),"\n");
            
#             mnode:=NewCocoNode(mcgr);
#             RegisterStandardInfo@COCO2P(mnode);

#             ComputeAllInfos(mnode);
#             for str in infoOptions@COCO2P.disabled do
#                 ComputeInfo(mnode,str);
#             od;
#             AppendTo(res, "   ",StringCocoIndented(NodeInfoString(mnode),3));
#         fi;
        


#         if cisomap then
#             cisorep:=map[index];
#             if cisorep<>index then
#                 AppendTo(res, String("C-isomorphic to: ",-maxlength), "#",cisorep,"\n");
#             fi;
#         fi;
#         if long and Rank(node!.cgr)>2 and not (Rank(node!.cgr)=3 and not IsPrimitive(JStructureConstantsOfColorGraph(node!.cgr))) then
#             if not IsTransitive(AutomorphismGroup(node!.cgr),[1..OrderOfColorGraph(cgr)]) then
#                 AppendTo(res, String("Orbits of Aut: ",-maxlength));
#                 AppendTo(res, StringCocoOrbReps@COCO2P(AutomorphismGroup(node!.cgr),[1..OrderOfColorGraph(cgr)]));
#             fi;
#             AppendTo(res, String("Generators of Aut: ",-maxlength),"\n");
#             AppendTo(res, StringCocoGenerators@COCO2P(AutomorphismGroup(node!.cgr), OrderOfColorGraph(cgr)));
            
#             scgr:=ColorGraph(AutomorphismGroup(node!.cgr),[1..OrderOfColorGraph(cgr)],OnPoints,true);
#             AppendTo(res, String("Merging in Cgr(Aut): ",-maxlength),"\n");
#             mrg:=Set([1..Rank(node!.cgr)], i->Filtered([1..Rank(mcgr)], j->ArcColorOfColorGraph(node!.cgr,ColorRepresentative(mcgr,j))=i));
#             AppendTo(res, StringCocoMerging@COCO2P(mrg));
#         fi;

#         AppendTo(res,"\n");
#     od;

#     CloseStream(res);
#     return outp;
# end;




InstallGlobalFunction(PosetOfFusionOrbits,
function(cgr,lforb)
    local  order, linorder, runtime, tstart, tensor, aaut, caut, 
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
    
    if not ForAll(lforb, forb->IsIdenticalObj(FamilyObj(forb),FamilyObj(lforb[1]))) then
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
    
    if IsWLStableColorGraph(cgr) then
        tensor:=StructureConstantsOfColorGraph(cgr);
    # if not IsIdenticalObj(FusionFamily(tensor), FamilyObj(Representative(lforb[1]))) then
    #     Error("The given fusion orbits must belong to the given color graph!");
    # fi;
    
        aaut:=AutomorphismGroup(tensor);
        caut:=ColorAutomorphismGroupOnColors(cgr);
    else
        aaut:=ColorAutomorphismGroupOnColors(cgr);
        caut:=ColorAutomorphismGroupOnColors(cgr);
    fi;
    
    if UnderlyingGroupOfCocoOrbit(lforb[1])<>aaut then
        aautfusorbs:=Set(lforb, x->ConstructorOfCocoOrbit(x)(aaut,Representative(x)));
    else
        aautfusorbs:=Set(lforb);
    fi;
    
    
    cautfusorbs:=[];ltwins:=[];
    algebraicFusions:=[];
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
        Info(InfoCOCO,1,"*");
    od;
    
    poset:=CocoPosetByFunctions([1..Length(cautfusorbs)], order, linorder);
    poset!.algTwins:=Immutable(List(poset!.elements, x->List(ltwins[x],y->Position(poset!.elements,y))));
    poset!.algebraicFusions:=Immutable(Filtered([1..Length(poset!.elements)], i->poset!.elements[i] in algebraicFusions));
    poset!.elements:=Immutable(List(poset!.elements, i->cautfusorbs[i]));
    poset!.colorGraphs:=Immutable(List(poset!.elements, forb->ColorGraphByFusion(cgr, CanonicalRepresentativeOfCocoOrbit(forb))));
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
    local  MapReps, jstable, wlstable, filt, proper, nonsch, long, 
           schfiss, fvc, onlyfvc, cisomap, date, runtime, strucexp, i, 
           cgrr, ord, nodes, node, srg, value, outp, res, cgr, ninf, 
           str, maxlength, scgr, mrg, idx, v, mcgr, isproper, index, 
           algtwins, jcl, wcl, sch, showjclosure, showwlclosure, 
           strictupperbounds, maxin, jcgr, mnode, cisorep, flt, showidx, 
           symfus, ideal,comma,cisoreps;
    
    
    MapReps:=function(i)
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
        
        if idx = i then
            Info(InfoCOCO,1,"+");
        else
            Info(InfoCOCO,1,"-");
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

    for i in [1..Size(pos)] do
        cgrr:=pos!.colorGraphs[i];
        if Rank(cgrr)>2 and (Rank(cgrr)>3 or IsPrimitiveColorGraph(cgrr)) then
            ord:=PrimePowersInt(Size(AutomorphismGroup(cgrr)));
            ord:=ord{[2,4..Length(ord)]};
            if ForAll(ord, x->x<=strucexp) then
                StructureDescription(AutomorphismGroup(cgrr):short);
            fi;
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

        Info(InfoCOCO,1,".");
    od;
    Info(InfoCOCO,1,"|");
    
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
        Info(InfoCOCO,1,".");
    od;
    Info(InfoCOCO,1,"|");
    
    
    outp:="";
    res:=OutputTextString(outp,true);
    SetPrintFormattingStatus(res,false);


    PrintTo(res,"JOCO - Information about a poset of FusionOrbits\n",
                "------------------------------------------------\n");
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
    AppendTo(res, "-------------------------------------------------\n");
    if date then
        PrintTo(res, String("                   Date: ",-maxlength), TodayString@COCO2P(),"\n");
    fi;
    if runtime then
        PrintTo(res, String("                Runtime: ",-maxlength), ComputationTime(pos),"\n");
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
        
#        if not IsWLStableColorGraph(node!.cgr) then
            mcgr:=ColorGraphByWLStabilization(node!.cgr);
 #       else
#            mcgr:=node!.cgr;
  #      fi;
        

        if IsJStableColorGraph(node!.cgr) then
            isproper:=Rank(ColorGraphBySymmetrization(mcgr))<>Rank(node!.cgr);
        
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
            cisorep:=MapReps(index);
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
#        if not IsWLStableColorGraph(node!.cgr) or not IsSchurian(node!.cgr) then
#            if IsTransitive(AutomorphismGroup(node!.cgr),[1..OrderOfColorGraph(cgr)]) then
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
            AppendTo(res, String("Symm. fus. in pos.: ",-maxlength), StringCocoList(symfus),"\n");
        else
            AppendTo(res, String("No symm. fus. in pos. ",-maxlength), "\n");
        fi;
        
        wcl:=Filtered(jcl, i->IsWLStableColorGraph(pos!.colorGraphs[i]));
        if schfiss then # and IsWLStableColorGraph(node!.cgr) then 
            sch:=Filtered(wcl, i-> IsSchurian(pos!.colorGraphs[i]));
            sch:=MinimalElementsInCocoPoset(pos,sch);
            if Length(sch)=1 then
                if sch[1]<>v then 
                    AppendTo(res, String("Sch. fiss. in pos.: ",-maxlength),"#", sch[1],"\n");
                fi;
            elif Length(sch)>1 then
                AppendTo(res, String("Sch. fiss. in pos.: ",-maxlength), StringCocoList(sch),"\n");
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
            AppendTo(res, String("J-fiss. in pos.: ",-maxlength), StringCocoList(jcl),"\n");
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
            AppendTo(res, String("WL-fiss. in pos.: ",-maxlength), StringCocoList(wcl),"\n");
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
            cisorep:=MapReps(index);
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
        Info(InfoCOCO,1,".");
    od;

    CloseStream(res);
    return outp;
end);


InstallMethod(ConstructorOfCocoOrbit,
        "for all partial fusion orbits",
        [IsJFusionOrbit],
function(orb)
    return JFusionOrbit;
end);

InstallMethod(ConstructorOfCocoOrbitNC,
        "for all partial fusion orbits",
        [IsJFusionOrbit],
function(orb)
    return JFusionOrbitNC;
end);
