InstallMethod(IsRainbow,
              "for a color graph in ColorGraphRep",
              [IsColorGraph and IsColorGraphRep],
function(cgr)
    local  tor, part, refl, i, c, irefl, mates, cls, tcls;
    
    tor:=List([1..Rank(cgr!.schurianCC)], x->ColorRepresentative(cgr!.schurianCC,x));
    part:=List([1..Rank(cgr)], i->[]);
    refl:=[];
    
    for i in [1..Rank(cgr!.schurianCC)] do
        c:=ArcColorOfColorGraph(cgr,tor[i]);
        irefl:=tor[i][1]=tor[i][2];
        if IsBound(refl[c]) then
            if refl[c] and not irefl then
                return false;
            elif not refl[c] and irefl then
                return false;
            fi;
        else  
            refl[c]:=irefl;
        fi;
        
        Add(part[c],i);
    od;
    mates:=ColorMates(cgr!.schurianCC);
    
    for i in [1..Rank(cgr)] do
        if i in refl then
            continue;
        fi;
        
        cls:=part[i];
        tcls:=OnSets(cls,mates);
        if cls=tcls or Intersection(cls,tcls)=[] then
            continue;
        fi;
        return false;
    od;
    
    return true;
end);

InstallMethod( VertexPartitionOfRainbow,
"for rainbows",
[IsColorGraph and IsRainbow],
function(cgr)
    local  map, types, vpart;
    map:=List([1..OrderOfColorGraph(cgr)], v->Filtered([1..RankOfColorGraph(cgr)], i->Neighbors(cgr,v,i)<>[]));
    types:=Set(map);
    vpart:=Set(types, x->Filtered([1..OrderOfColorGraph(cgr)], i->map[i]=x));
    return vpart;
end);

InstallMethod( IsStableRainbow,
"for rainbows",
[IsColorGraph and IsRainbow],
function(cgr)
    local  vpart, i, j, p, q, val;
    vpart:=VertexPartitionOfRainbow(cgr);
    
    for i in [1..RankOfColorGraph(cgr)] do
        for p in vpart do
            for q in vpart do
                val:=Length(Intersection(Neighbors(cgr,p[1],i),q));
                for j in [2..Length(p)] do
                    if val <> Length(Intersection(Neighbors(cgr,p[j],i),q)) then
                        return false;
                    fi;
                od;
            od;
        od;
    od;
    return true;
end);

InstallMethod( IsWellFibredRainbow, 
"for rainbows",
[IsColorGraph and IsRainbow],
function(cgr)
    return Length(VertexPartitionOfRainbow(cgr)) = NumberOfFibres(cgr);
end);


InstallMethod( RAlgebraicAutomorphismGroup,
"for stable rainbows",
[IsRainbow and IsStableRainbow],
function(cgr)
    local  OnPointsAndPairs, vpart, vrtmu, refl, mu, g;
    
    OnPointsAndPairs:=function(e,g)
        if IsList(e) then
            return OnPairs(e,g);
        fi;
        return OnPoints(e,g);
    end;

    vpart:=VertexPartitionOfRainbow(cgr);
    vrtmu:=[1..RankOfColorGraph(cgr)];
    Append(vrtmu, Tuples([1..Length(vpart)],2));
    refl:=ReflexiveColors(cgr);
    
               
    mu:=ColorGraph(Group(()),vrtmu,OnPointsAndPairs, true, 
                   function(a,b)
                       local colout,colin,col;
                       
                       if IsInt(a) and IsList(b) then
                           colout:=Length(Intersection(Neighbors(cgr,vpart[b[1]][1],a), vpart[b[2]]));
                           colin:=Length(Intersection(Neighbors(cgr, vpart[b[2]][1],a^ColorMates(cgr)), vpart[b[1]]));
                           col:=[colin,colout];
                       elif IsList(a) and IsInt(b) then
                           colout:=Length(Intersection(Neighbors(cgr,vpart[a[1]][1],b), vpart[a[2]]));
                           colin:=Length(Intersection(Neighbors(cgr, vpart[a[2]][1],b^ColorMates(cgr)), vpart[a[1]]));
                           col:=[colin,colout];
                       elif IsInt(a) and IsInt(b) then
                           col:=[a in refl, b in refl, b=a^ColorMates(cgr)];
                       else
                           col:=[a[1]=a[2],a[1]=b[1],a[1]=b[2],a[2]=b[1],a[2]=b[2],b[1]=b[2]];
                           Append(col, [Length(vpart[a[1]]), Length(vpart[a[2]]), 
                                  Length(vpart[b[1]]), Length(vpart[b[2]])]);
                       fi;
                       return col;
                   end);
    g:=AutomorphismGroup(mu);
    return Action(g,[1..RankOfColorGraph(cgr)]);
end);


InstallTrueMethod(IsRainbow,IsColorGraph and IsWLStableColorGraph);
InstallTrueMethod(IsRainbow,IsColorGraph and IsJStableColorGraph);
InstallTrueMethod(IsStableRainbow, IsRainbow and IsRegularColorGraph);
InstallTrueMethod(IsStableRainbow, IsWLStableColorGraph);


InstallTrueMethod(IsRegularColorGraph, IsWLStableColorGraph and IsHomogeneous);
InstallTrueMethod(IsRegularColorGraph, IsJStableColorGraph and IsUndirectedColorGraph);

InstallTrueMethod(IsHomogeneous, IsRainbow and IsRegularColorGraph);
InstallTrueMethod(IsWellFibredRainbow, IsWLStableColorGraph);
InstallTrueMethod(IsWellFibredRainbow, IsJStableColorGraph and IsRegularColorGraph);

                 
                 
InstallOtherMethod(ColorMates,
   "for WL-stable color graphs in SchurianCCRep",
   [IsColorGraph and IsRainbow],
function(cgr)
   return PermList(List([1..RankOfColorGraph(cgr)], x->ArcColorOfColorGraph(cgr, Reversed(ColorRepresentative(cgr,x)))));
end);


InstallOtherMethod(ColorGraphByFusion,
        "for a color graph and a J-stable fusion",
        [IsColorGraph, IsJordanFusion],
function(cgr,fusion)
    local res;

    res:= ColorGraphByFusion(cgr, UnderlyingPartitionOfColorPartition(fusion));
    SetIsJStableColorGraph(res,true);
    return res;
end);

InstallOtherMethod(ColorGraphByFusion,
        "for a color graph and a WL-stable-fusion",
        [IsColorGraph, IsWLFusion],
function(cgr,fusion)
    local res;

    res:= ColorGraphByFusion(cgr, UnderlyingPartitionOfColorPartition(fusion));
    SetIsWLStableColorGraph(res,true);
    return res;
end);

InstallOtherMethod(ColorGraphByFusion,
"for a color graph and for a regular fusion",
[IsColorGraph, IsRegularFusion],
function(cgr,fusion)
    local res;

    if not IsIdenticalObj(RegularFusionsFamily(cgr), FamilyObj(fusion)) then
        Error("The given fusion must belong to the given color graph!");
    fi;
    res:= ColorGraphByFusion(cgr, PartitionOfFusion(fusion));
    SetIsRainbow(res,true);
    SetIsHomogeneous(res,true);
    SetIsStableRainbow(res,true);
    
    return res;
end);


InstallOtherMethod(ReflexiveColors,
     "for Rainbows",
     [IsColorGraph and IsRainbow],
function(cgr)
   return Filtered([1..RankOfColorGraph(cgr)],
      function(x)
         local rep;
         rep:=ColorRepresentative(cgr,x);
         return rep[1]=rep[2];
      end);
end);

InstallOtherMethod(ColorMates,
   "for Rainbows",
   [IsColorGraph and IsRainbow],
function(cgr)
   return PermList(List([1..RankOfColorGraph(cgr)], x->ArcColorOfColorGraph(cgr, Reversed(ColorRepresentative(cgr,x)))));
end);


InstallMethod(NumberOfFibres,
		"for Rainbows",
		[IsColorGraph and IsRainbow],
function(cgr)
   return Length(ReflexiveColors(cgr));
end);


InstallMethod(IsJStableColorGraph,
         "for color graphs in ColorGraphRep",
         [IsColorGraph and IsColorGraphRep],
function(cgr)
   local tensor,tor;

   tor:=List([1..Rank(cgr!.schurianCC)], x->ColorRepresentative(cgr!.schurianCC,x));
   tensor:=JTensorFromColorReps(cgr,tor);
   if tensor=fail then
      return false;
   else
      SetJStructureConstantsOfColorGraph(cgr,tensor);
      SetIsTensorOfJC(tensor,true);
      return true;
   fi;
end);


#InstallTrueMethod(IsJStableColorGraph, IsColorGraph and IsSchurianCCRep);
InstallTrueMethod(IsJStableColorGraph, IsColorGraph and IsWLStableColorGraph);



InstallMethod(JStructureConstantsOfColorGraph,
         "for J-stable color graphs",
         [IsColorGraph and IsJStableColorGraph],
function(cgr)
   local reps,tensor;

   reps:=List([1..RankOfColorGraph(cgr)], i->ColorRepresentative(cgr,i));
   tensor:=JTensorFromColorReps(cgr,reps);
   SetIsTensorOfJC(tensor,true);
   return tensor;
end);



InstallOtherMethod(OutValencies,
  "for rainbows",
  [IsColorGraph and IsRainbow],
function(cgr)
   local reps;
   reps:=List([1..Rank(cgr)], x->ColorRepresentative(cgr,x));
   return List([1..Rank(cgr)], x->Length(Neighbors(cgr,reps[x][1],x)));
end);

InstallMethod(IsThin,
"for a rainbow",
[ IsColorGraph and IsRainbow ],
function(cgr)
    return IsSubset([0,1],Set(OutValencies(cgr)));
end);

InstallMethod(IsQuasithin,
"for a rainbow",
[ IsColorGraph and IsRainbow ],
function(cgr)
    return IsSubset([0,1,2],Set(OutValencies(cgr)));
end);
              
InstallMethod(JAlgebraicAutomorphismGroup,
	"for J-stabil color graphs",
	[IsColorGraph and IsJStableColorGraph],
function(cgr)
    local t,jaut;
    t := JStructureConstantsOfColorGraph(cgr);
    
    jaut:=AutGroupOfCocoObject(t);
#    SetKnownGroupOfAlgebraicAutomorphismsNC(cgr,aaut);
    return jaut;
end);

InstallMethod( IsHomogeneous,
        "for a color graph",       
        [IsColorGraph],
function(cgr)
    return Length(Set([1..OrderOfColorGraph(cgr)], x->ArcColorOfColorGraph(cgr,x,x)))=1;
end);

InstallMethod( IsPrimitiveColorGraph,
        "for rainbows",
        [IsColorGraph and IsRainbow],
function(cgr)
    if not IsHomogeneous(cgr) then
        return false;
    fi;
    return ForAll(Difference([1..RankOfColorGraph(cgr)],ReflexiveColors(cgr)),
                  i->IsConnectedGraph(BaseGraphOfColorGraph(cgr,i)));
end);
               
        
InstallImmediateMethod( IsHomogeneous,
        "for a J-stable color graph",
        IsColorGraph and IsJStableColorGraph,0,
function(cgr)
    return Length(ReflexiveColors(cgr)) = 1;
end);

# InstallOtherMethod(KnownGroupOfAlgebraicAutomorphisms,
# 		"for J-stable color graphs",
# 		[IsColorGraph and IsJStableColorGraph],
# function(cgr)
#    local kg;

#    kg:=KnownGroups(cgr);
#    if not IsBound(kg.knownGroupOfAlgebraicAutomorphisms) then
#       kg.knownGroupOfAlgebraicAutomorphisms:=Group(());
#    fi;
#    return kg.knownGroupOfAlgebraicAutomorphisms;
# end);

InstallOtherMethod(ColorAutomorphismGroup,
		"for J-stable color graphs",
		[IsColorGraph and IsJStableColorGraph],
function(W)
    local S, xcgr1,xcgr2,result, subH,wautv,wautc;

    
    AutomorphismGroup(W); # KnownGroupOfAutomorphisms(W) is used later on in CheckGroup
    S:=StabChainMutable(JAlgebraicAutomorphismGroup(W));
    xcgr1:=BuildXCgr(W,[1..RankOfColorGraph(W)]);
    xcgr2:=BuildXCgr(W,[1..RankOfColorGraph(W)]);

    result:=[];
    subH:=CheckGroup(xcgr1,xcgr2, S, rec(orbits:=[[1..RankOfColorGraph(W)]], map:=ListWithIdenticalEntries(RankOfColorGraph(W),1)),result);

    wautv:=Group(Concatenation(GeneratorsOfGroup(AutomorphismGroup(W)), result),());
    wautc:=Group(subH.generators,());
    SetColorAutomorphismGroupOnColors(W, wautc);
    SetKnownGroupOfColorAutomorphismsNC(W,wautv);
    SetKnownGroupOfColorAutomorphismsOnColorsNC(W,wautc);

    return wautv;
end);

InstallMethod(ColorAutomorphismGroupOnColors,
		"for J-stable color graphs",
		[IsColorGraph and IsJStableColorGraph],
function(cgr)
   ColorAutomorphismGroup(cgr); # this sets the attribute ColorAutomorphismGroupOnColors
   return ColorAutomorphismGroupOnColors(cgr);
end);

# InstallOtherMethod(SetKnownGroupOfAlgebraicAutomorphismsNC,
# 		"for J-stable color graphs",
#      	[IsColorGraph and IsJStableColorGraph, IsPermGroup],
# function(cgr,g)
#    local kg;

#    kg:=KnownGroups(cgr);
#    kg.knownGroupOfAlgebraicAutomorphisms:=g;
# end);


InstallMethod(IsUndirectedColorGraph,
   "for J-stable color graphs",
   [IsColorGraph and IsJStableColorGraph],
function(cgr)
   return ColorMates(cgr)=();
end);


InstallMethod(ColorIsomorphismColorGraphs,
		"for J-stable color graphs",
		IsIdenticalObj,
	[IsColorGraph and IsJStableColorGraph, IsColorGraph and IsJStableColorGraph],
function(cgr1,cgr2)
   local T1,T2,aiso,xcgr1,xcgr2,naiso,res,PrepareStabChains,S,rS;

   PrepareStabChains:=function(S, rS, part)

       if StbcIsTrivialStabChainNode(S) then
           rS.part:=rec(map:=[1..Length(part.map)],
                        orbits:=List([1..Length(part.map)], x->[x]));
           return;
       fi;

       S.part:=StbcRefineOrbits(S,part, OrderOfTensor(T1));
       rS.part:=StbcRefineOrbits(rS, S.part, OrderOfTensor(T1));

       PrepareStabChains(S.stabilizer, rS.stabilizer, S.part);
   end;


   T1:=JStructureConstantsOfColorGraph(cgr1);
   T2:=JStructureConstantsOfColorGraph(cgr2);
   aiso:=IsomorphismCocoObjects(T1,T2);
   if aiso=fail then
       return fail;
   fi;
   S:=StabChainMutable(JAlgebraicAutomorphismGroup(cgr1)); #AutGroupOfCocoObject(T1));
   rS:=StabChainMutable(KnownGroupOfColorAutomorphismsOnColors(cgr1));
   ChangeStabChain(rS, BaseStabChain(S), false);

   PrepareStabChains(S,rS,rec(orbits:=[[1..RankOfColorGraph(cgr1)]], map:=ListWithIdenticalEntries(RankOfColorGraph(cgr1),1)));


   xcgr1:=BuildXCgr(cgr1,[1..RankOfColorGraph(cgr1)]);
   xcgr2:=BuildXCgr(cgr2,[1..RankOfColorGraph(cgr2)]);
   res:=[];
   naiso:=FindCosRep(S, rS, xcgr1,xcgr2,aiso, res);
   if naiso=false then
      return fail;
   fi;
   return [res[1],naiso];
end);

InstallOtherMethod(NewCocoNode,
        "for color graphs",
        [IsColorGraph],
function(cgr)
    local tensor,nodeInfo, node;
    
    nodeInfo:=rec(names:=[],
                  values:=[],
                  testers:=[],
                  toStr:=[],
                  getters:=[],
                  maxlength:=0);
        
    node:=Objectify(NewType(CocoNodesFam, IsCocoNode and IsColorGraphNodeRep),
                   rec( poset:=fail,
                        index:=0,
                        level:=RankOfColorGraph(cgr),
                        cgr:=cgr,
                        nodeInfo:=nodeInfo));
#    RegisterStandardInfo@(node);
    return node;
end);



InstallMethod(PbagColorInvariant,
   "for color graphs",
   [IsColorGraph, IsColorGraph],
function(cgr1,cgr2)
    local TestIsomorphism, TestAutomorphism, Invariant, HashFunction;
    
    
    TestIsomorphism:=function(TRec1, TRec2, perm)
        local  W1, W2, cplist, i, arc, arc2, xcgr1, xcgr2, ciso;
        
        
        W1:=TRec1.T;
        W2:=TRec2.T;
        cplist:=List([1..Rank(W1)], x->ArcColorOfColorGraph(W2,OnPairs(ColorRepresentative(W1,x),perm)));
        ciso:=PermList(cplist);
        if ciso=fail then
            return false;
        fi;
        
        xcgr1:=BuildXCgrObject(W1,cplist);
        xcgr2:=BuildXCgrObject(W2,[1..Rank(W2)]);
        
        return TestIsomorphismXCgr(xcgr1,xcgr2,perm);
    end;
    
    TestAutomorphism:=function(TRec1, perm)
        local  W1, cplist, i, arc, arc2, xcgr1, xcgr2;

        W1:=TRec1.T;
        cplist:=[];
        for i in [1..Rank(W1)] do
            arc:=ColorRepresentative(W1,i);
            arc2:=OnTuples(arc,perm);
            Add(cplist,ArcColorOfColorGraph(W1,arc2));
        od;
        xcgr1:=BuildXCgrObject(W1,cplist);
        xcgr2:=BuildXCgrObject(W1,[1..Rank(W1)]);
#        Error("test");
        
        return TestIsomorphismXCgr(xcgr1,xcgr2,perm);
    end;

    Invariant:=function(obj,v)
        local inv,row,res;

        row:=RowOfCgrObject(obj,v);
        inv:=List(obj.ST, y->row[y]);
        res:=Set(Set(inv), x->Filtered([1..Length(inv)], i->inv[i]=x));
        
        
        Add(res, [obj.fvc[v]]);
        return res;
    end;

    HashFunction:=function(inv)
        local cinv;
        cinv:=Concatenation(inv);
        
        return cinv*[1..Length(cinv)];
    end;

    return rec(finv    := Invariant,
               hashinv := HashFunction,
               test    := TestIsomorphism,
               autTest := TestAutomorphism);
end);


InstallMethod(ColorIsomorphismColorGraphs,
		"for color graphs",
		IsIdenticalObj,
	[IsColorGraph, IsColorGraph],
function(o1,o2)
    local   iso,  kaut1,  kaut2, pbagobjs, ciso;

    pbagobjs:=NewPbagObjects(o1,o2);
    iso:=IsomorphismPbagObjects(pbagobjs[1], pbagobjs[2], PbagColorInvariant(o1,o2));
    if iso=false then
        return fail;
    fi;
    
    kaut1:=KnownGroupOfColorAutomorphisms(o1);
    kaut2:=KnownGroupOfColorAutomorphisms(o2);

    SetKnownGroupOfColorAutomorphismsNC(o1, ClosureGroup(kaut1,
                     List(GeneratorsOfGroup(kaut2), h->h^(iso^-1))));
    SetKnownGroupOfColorAutomorphismsNC(o2, ClosureGroup(kaut2,
                     List(GeneratorsOfGroup(kaut1), h->h^iso)));
    ciso:=PermList(List([1..Rank(o1)], x->ArcColorOfColorGraph(o2,OnPairs(ColorRepresentative(o1,x),iso))));

   return [iso,ciso];
end);

InstallMethod(ColorAutomorphismGroup,
		"for color graphs",
		[IsColorGraph],
function(W)
    local  myact, aut, caut;
    
    myact:=function(e,g)
        return ArcColorOfColorGraph(W, OnPairs(ColorRepresentative(W,e),g));
    end;
    
    
    aut:=AutGroupOfPbagObject(NewPbagObject(W),KnownGroupOfColorAutomorphisms(W), PbagColorInvariant(W,W));
    caut:=Action(aut,[1..Rank(W)], myact);
    SetColorAutomorphismGroupOnColors(W, caut);
    SetKnownGroupOfColorAutomorphismsNC(W,aut);
    SetKnownGroupOfColorAutomorphismsOnColorsNC(W,caut);
    return aut;
end);

InstallMethod(ColorAutomorphismGroupOnColors,
		"for color graphs",
		[IsColorGraph],
function(cgr)
   ColorAutomorphismGroup(cgr); # this sets the attribute ColorAutomorphismGroupOnColors
   return ColorAutomorphismGroupOnColors(cgr);
end);


InstallMethod(ColorGraphByJStabilization,
              "for color graphs",
              [IsColorGraph],
function(cgr)
    local   aut,  scgr,  tor,  part,  i,  c,  h,  spart,  npart,  acl,
            ccounter,  colors,rpart,scl,rcgr;

    if IsJStableColorGraph(cgr) then
        return cgr;
    fi;

    aut:=KnownGroupOfAutomorphisms(cgr);
    scgr:=ColorGraphByOrbitals(aut,[1..OrderOfColorGraph(cgr)], OnPoints,true);
    tor:=ColorNames(scgr);
    part:=List([1..RankOfColorGraph(cgr)], x->[]);
    for i in [1..Length(tor)] do
        c:=ArcColorOfColorGraph(cgr,tor[i]);
        AddSet(part[c],i);
    od;
    h:=ColorMates(scgr);
    spart:=List(part, x->Intersection(x,OnSets(x,h)));
    rpart:=List(spart, x->Intersection(x, ReflexiveColors(scgr)));

    npart:=[];
    for i in [1..Length(part)] do
        if spart[i]<>[] then
            acl:=Difference(part[i],spart[i]);
            if acl<>[] then
                Add(npart,acl);
            fi;

            if rpart[i]<>[] then
                Add(npart,rpart[i]);
                scl:=Difference(spart[i],rpart[i]);
                if scl<>[] then
                    Add(npart, scl);
                fi;
            else
                Add(npart, spart[i]);
            fi;
        else
            Add(npart,part[i]);
        fi;
    od;
    part:=WLBuildPartition(npart);
    part:=JStabil(StructureConstantsOfColorGraph(scgr),part);
    if part=fail then
        return fail;
    fi;

    rcgr:=ColorGraph(aut,[1..OrderOfColorGraph(cgr)], OnPoints,true,
    function(u,v)
        local col,cidx;
        col:=ArcColorOfColorGraph(scgr,u,v);
        cidx:=First([1..Length(part.classes)],i->col in part.classes[i]);
        return part.colorNames[cidx];
    end);
    SetIsRainbow(rcgr,true);
    
    SetIsJStableColorGraph(rcgr,true);
    return rcgr;
end);


InstallMethod(IsProperJordanScheme,
              "for J-stable color graphs",
              [IsColorGraph and IsJStableColorGraph],
function(cgr)              
    if not IsUndirectedColorGraph(cgr) then
        return true;
    fi;
    return Rank(cgr) < Rank(ColorGraphBySymmetrization(ColorGraphByWLStabilization(cgr)));
end);


InstallMethod(IsInterestingRainbow,
              "for rainbows",
              [IsColorGraph and IsRainbow],
function(cgr)
    local  jcgr,wcgr,SymRank;
    
    SymRank:=cgr->Length(Filtered([1..Rank(cgr)], i->i<=i^ColorMates(cgr)));

    jcgr:=ColorGraphByJStabilization(cgr);
    wcgr:=ColorGraphByWLStabilization(cgr);
    
    if Rank(jcgr)=Rank(wcgr) then
        return false;
    fi;
    
    if IsUndirectedColorGraph(jcgr) and SymRank(wcgr)=Rank(jcgr) then
        return false;
    fi;
    
    return true;
    
end);


                         
InstallGlobalFunction("RegisterStandardInfoRainbow@JOCO",
function(node)
    local  cgr, identification, tensor, srg, prmstr, 
           val, ppolord, i, qpolord, krein;
    
    cgr:=node!.cgr;
    
    if not IsRainbow(cgr) then  
        ErrorNoReturn("RegisterStandardInfoRainbow@COCO2P(node): node!.cgr must be a rainbow!");
    fi;
            
    identification:=ValueOption("identification");
    if identification=fail then
        identification:=false;
    fi;
    
    if HasName(cgr) then 
        RegisterInfoCocoNode(node, rec(name:="Name:",
                                       value:=Name(cgr)));
    fi;
    
    if IsWLStableColorGraph(cgr) then 
        RegisterInfoCocoNode(node, rec(name:="Type:",value:="WL-stable color graph"));

        if identification then
            RegisterInfoCocoNode(node, rec(name:="Identification:",
                                           getter:=node->IdentificationOfColorGraph(cgr)));
        fi;
    elif IsJStableColorGraph(node!.cgr) then
        RegisterInfoCocoNode(node, rec(name:="Type:",value:="J-stable color graph"));
        if IsHomogeneous(node!.cgr) and IsUndirectedColorGraph(node!.cgr) then
            RegisterInfoCocoNode(node,rec(name:="proper:",
                                          getter:=node->IsUndirectedColorGraph(node!.cgr) and 
                                                  Rank(ColorGraphBySymmetrization(ColorGraphByWLStabilization(node!.cgr)))
                                                  <>Rank(node!.cgr)));
        fi;
    elif IsRainbow(node!.cgr) then
        RegisterInfoCocoNode(node, rec(name:="Type:",value:="Rainbow"));
    fi;
    
    
    RegisterInfoCocoNode(node,rec(name:="order:",
                                  getter:=node->OrderOfColorGraph(cgr)));
    RegisterInfoCocoNode(node,rec(name:="rank:",
                                  getter:=node->RankOfColorGraph(cgr)));
    RegisterInfoCocoNode(node,rec(name:="symmetric:",
                                  getter:=node->IsUndirectedColorGraph(node!.cgr)));
    if not IsUndirectedColorGraph(cgr) then
        RegisterInfoCocoNode(node,rec(name:="sym. rank:",
                                      getter:=node->Length(Filtered([1..Rank(cgr)], i->i<=i^ColorMates(cgr)))));
    fi;
    
    if IsWLStableColorGraph(cgr) then 
        tensor:=StructureConstantsOfColorGraph(cgr);
        
        if RankOfColorGraph(cgr)=3  then
            if ColorMates(cgr)=() then
                srg:=GetSrgParams@COCO2P(tensor);
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
            else
                RegisterInfoCocoNode(node,rec(name:="type:",
                                              value:="doubly regular tournament"));
            fi;
        fi;
        
        if RankOfColorGraph(cgr)>3 then
            ppolord:=PPolynomialOrderings(tensor);
            if ppolord<>[] then
                for i in [1..Length(ppolord)] do
                    RegisterInfoCocoNode(node,rec(name:=Concatenation("P-polynomial ordering ",Concatenation(String(i),":")), 
                                                  value:=StringList@COCO2P(ppolord[i])));
                    RegisterInfoCocoNode(node,rec(name:=Concatenation("drg-parameters ",Concatenation(String(i),":")), 
                                                  #                                              toStr:=StringParams@COCO2P, 
                                                  value:=StringParams@COCO2P(GetParams@COCO2P(tensor,ppolord[i]))));
                    if OutValencies(tensor)[ppolord[i][2]] > 2 then
                        RegisterInfoCocoNode(node,rec(name:=Concatenation("antipodal ", Concatenation(String(i),":")),
                                                      value:=String(IsClosedSet(tensor, Set([ppolord[i][1],ppolord[i][Length(ppolord[i])]])))));
                        RegisterInfoCocoNode(node,rec(name:=Concatenation("bipartite ", Concatenation(String(i),":")),
                                                      value:=String(IsClosedSet(tensor, ppolord[i]{Filtered([1..Order(tensor)], IsOddInt)}))));
                    fi;
                od;
            fi;
        fi;
    
        if RankOfColorGraph(cgr)>3 and IsCommutativeTensor(tensor) then
            qpolord:=QPolynomialOrderings(tensor);
            krein:=TensorOfKreinNumbers(tensor);
            if qpolord<>[] then
                for i in [1..Length(qpolord)] do
                    RegisterInfoCocoNode(node,rec(name:=Concatenation("Q-polynomial ordering ",Concatenation(String(i),":")), 
                                                  value:=StringList@COCO2P(qpolord[i])));
                    RegisterInfoCocoNode(node,rec(name:=Concatenation("Krein-parameters ",Concatenation(String(i),":")), 
                                                  toStr:=StringParams@COCO2P, 
                                                  value:=StringParams@COCO2P(GetParams@COCO2P(krein,qpolord[i]))));
                    RegisterInfoCocoNode(node,rec(name:=Concatenation("antipodal ", Concatenation(String(i),":")),
                                                  value:=String(IsClosedSet(krein, Set([qpolord[i][1],qpolord[i][Length(qpolord[i])]])))));
                    RegisterInfoCocoNode(node,rec(name:=Concatenation("bipartite ", Concatenation(String(i),":")),
                                                  value:=String(IsClosedSet(krein, qpolord[i]{Filtered([1..Order(krein)], IsOddInt)}))));
                od;
            fi;
        fi;
        if RankOfColorGraph(cgr)>2 and (RankOfColorGraph(cgr)>3 or IsPrimitiveColorGraph(cgr)) then
            RegisterInfoCocoNode(node,rec(name:="Schurian:",
                                          tester:=node->HasAutGroupOfCocoObject(node!.cgr),
                                          getter:=node->IsSchurian(node!.cgr)));
        fi;
        if not IsUndirectedColorGraph(cgr) then
            RegisterInfoCocoNode(node,rec(name:="commutative:",
                                          getter:=node->IsCommutativeTensor(StructureConstantsOfColorGraph(node!.cgr))));
        fi;
        if IsHomogeneous(cgr) and RankOfColorGraph(cgr)>3 and ppolord=[] then
            RegisterInfoCocoNode(node,rec(name:="primitive:",
                                          getter:=node->IsPrimitiveColorGraph(node!.cgr)));
        fi;
        if RankOfColorGraph(cgr)>3 and IsUndirectedColorGraph(cgr) and IsHomogeneous(cgr) then
            RegisterInfoCocoNode(node, rec(name:="amorphic:", getter:=node->IsAmorphicColorGraph(node!.cgr)));
        fi;
    fi; # IsWLstable
    
    RegisterInfoCocoNode(node,rec(name:="valencies:", 
                                  toStr:=StringMultiset@COCO2P,
                                  getter:=node->OutValencies(cgr)));
    
                         
                                   
    if not IsHomogeneous(cgr) then 
        if not IsWLStableColorGraph(cgr) then 
            RegisterInfoCocoNode(node,rec(name:="# of weak fibres:",
                                          getter:=node->Length(VertexPartitionOfRainbow(node!.cgr))));
        fi;
    
        RegisterInfoCocoNode(node,rec(name:="# of fibres:",
                                      getter:=node->NumberOfFibres(node!.cgr)));
    fi;
    

    if RankOfColorGraph(cgr)>2 and (RankOfColorGraph(cgr)>3 or 
                                    IsPrimitiveColorGraph(cgr)) then
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
                                      tester:=node->HasColorAutomorphismGroupOnColors(node!.cgr) and HasStructureDescription(ColorAutomorphismGroupOnColors(node!.cgr)),
                                      getter:=node->StructureDescription(ColorAutomorphismGroupOnColors(node!.cgr):short)));
        if IsWLStableColorGraph(cgr) then 
            RegisterInfoCocoNode(node,rec(name:="[aAut:cAut/Aut]:", 
                                          toStr:=StringPP, 
                                          tester:=node->HasAlgebraicAutomorphismGroup(node!.cgr) and HasColorAutomorphismGroupOnColors(node!.cgr),
                                          getter:=node->Order(AlgebraicAutomorphismGroup(node!.cgr))/Order(ColorAutomorphismGroupOnColors(node!.cgr))));
            RegisterInfoCocoNode(node,rec(name:="aAut:", 
                                          tester:=node->HasAlgebraicAutomorphismGroup(node!.cgr) and HasStructureDescription(AlgebraicAutomorphismGroup(node!.cgr)),
                                          getter:=node->StructureDescription(AlgebraicAutomorphismGroup(node!.cgr):short)));
        fi;
        if IsJStableColorGraph(cgr) then 
            if IsWLStableColorGraph(cgr) then 
                RegisterInfoCocoNode(node,rec(name:="[jAut:aAut]:", 
                                              toStr:=StringPP, 
                                              tester:=node->HasJAlgebraicAutomorphismGroup(node!.cgr) and HasAlgebraicAutomorphismGroup(node!.cgr),
                                              getter:=node->Order(JAlgebraicAutomorphismGroup(node!.cgr))/Order(AlgebraicAutomorphismGroup(node!.cgr))));
            fi;
            RegisterInfoCocoNode(node,rec(name:="jAut:", 
                                          tester:=node->HasJAlgebraicAutomorphismGroup(node!.cgr) and HasStructureDescription(JAlgebraicAutomorphismGroup(node!.cgr)),
                                          getter:=node->StructureDescription(JAlgebraicAutomorphismGroup(node!.cgr):short)));
            
        fi;
    fi;
end);



InstallMethod( DisplayString,
               "for rainbows",
               [IsColorGraph and IsRainbow], 100,
function(cgr)
    local  long, fvc, res, str, node, srg, ninf, maxlength, 
           scgr, mrg, aut, caut, jaut, aaut, strucexp, ord, number;
    
    long:=ValueOption("long");
    if long=fail then
        long:=false;
    fi;
    
    fvc:=ValueOption("fvc");
    if fvc=fail then
        fvc:=false;
    fi;
    
    strucexp:=ValueOption("strucexp");
    if strucexp=fail then
        strucexp:=12;
    fi;

    number:=ValueOption("number");
    
    res:="";
    str:=OutputTextString(res,true);
    SetPrintFormattingStatus(str,false);
    
    
    if Rank(cgr)>2 and (Rank(cgr)>3 or IsPrimitiveColorGraph(cgr)) then
        ord:=PrimePowersInt(Size(AutomorphismGroup(cgr)));
        ord:=ord{[2,4..Length(ord)]};
        if ForAll(ord, x->x<=strucexp) then
            StructureDescription(AutomorphismGroup(cgr):short);
        fi;
    fi;
    
    ord:=PrimePowersInt(Size(ColorAutomorphismGroupOnColors(cgr)));
    ord:=ord{[2,4..Length(ord)]};
    if ForAll(ord, x->x<=strucexp) then
        StructureDescription(ColorAutomorphismGroupOnColors(cgr):short);
    fi;
    if IsJStableColorGraph(cgr) then
        ord:=PrimePowersInt(Size(JAlgebraicAutomorphismGroup(cgr)));
        ord:=ord{[2,4..Length(ord)]};
        if ForAll(ord, x->x<=strucexp) then
            StructureDescription(JAlgebraicAutomorphismGroup(cgr):short);
        fi;
                              
        if IsWLStableColorGraph(cgr) then 
            ord:=PrimePowersInt(Size(AlgebraicAutomorphismGroup(cgr)));
            ord:=ord{[2,4..Length(ord)]};
            if ForAll(ord, x->x<=strucexp) then
                StructureDescription(AlgebraicAutomorphismGroup(cgr):short);
            fi;
        fi;
    fi;

    node:=NewCocoNode(cgr);
    if number <> fail then 
        RegisterInfoCocoNode(node, rec(name:="Number:", value:=String(number)));
    fi;
    
    RegisterStandardInfoRainbow@JOCO(node);
    ComputeAllInfos(node);
    
    
    if fvc then
        if Rank(node!.cgr)=3 and IsUndirectedColorGraph(node!.cgr) 
           and IsWLStableColorGraph(node!.cgr) 
           and not IsSchurian(node!.cgr) then
            srg:=SrgFromCgr@COCO2P(node!.cgr);
            RegisterInfoCocoNode(node, rec(name:="4-vc:",
                                           value:=String(IsHighlyRegularGraph(srg,2,4))));
        fi;
    fi;
    
    
    ninf:=node!.nodeInfo;
    AppendTo(str, NodeInfoString(node));
    if long then
        maxlength:=Maximum(ninf.maxlength, 20);
        AppendTo(str, String("color mates:",-maxlength));
        AppendTo(str, StringCocoPerm@COCO2P(ColorMates(node!.cgr)),"\n");
        
        aut:=AutomorphismGroup(node!.cgr);
        if not IsTransitive(aut,[1..OrderOfColorGraph(cgr)]) then
            AppendTo(str, String("Orbits of Aut: ",-maxlength));
            AppendTo(str, StringCocoOrbReps@COCO2P(aut,[1..OrderOfColorGraph(node!.cgr)]));
        fi;
        AppendTo(str, String("Generators of Aut: ",-maxlength),"\n");
        AppendTo(str, StringCocoGenerators@COCO2P(aut, OrderOfColorGraph(node!.cgr)));

        scgr:=ColorGraph(aut,[1..OrderOfColorGraph(node!.cgr)],OnPoints,true);
        if not IsWLStableColorGraph(node!.cgr) or not IsSchurian(node!.cgr) then
            AppendTo(str, String("Merging in Cgr(Aut): ",-maxlength),"\n");
            mrg:=Set([1..Rank(node!.cgr)], i->Filtered([1..Rank(scgr)], j->ArcColorOfColorGraph(node!.cgr,ColorRepresentative(scgr,j))=i));
            AppendTo(str, StringCocoMerging@COCO2P(mrg));
        fi;
        
        caut:=ColorAutomorphismGroup(node!.cgr);
        if Size(caut)>Size(aut) then
            if not IsTransitive(AutomorphismGroup(node!.cgr),[1..OrderOfColorGraph(cgr)]) then
                AppendTo(str, String("Orbits of cAut: ",-maxlength));
                AppendTo(str, StringCocoOrbReps@COCO2P(caut,[1..OrderOfColorGraph(node!.cgr)]));
            fi;
            AppendTo(str, String("Generators of cAut: ",-maxlength),"\n");
            AppendTo(str, StringCocoGenerators@COCO2P(caut, OrderOfColorGraph(node!.cgr)));
        fi;
        
        if IsJStableColorGraph(node!.cgr) then
            jaut:=JAlgebraicAutomorphismGroup(node!.cgr);
            if not IsTrivial(jaut) then 
                AppendTo(str, String("Orbits of jAut: ",-maxlength));
                AppendTo(str, StringCocoOrbReps@COCO2P(jaut,[1..RankOfColorGraph(node!.cgr)]));
                
                AppendTo(str, String("Generators of jAut: ",-maxlength),"\n");
                AppendTo(str, StringCocoGenerators@COCO2P(jaut, RankOfColorGraph(node!.cgr)));
            fi;
        fi;
        
        if IsWLStableColorGraph(node!.cgr) then 
            aaut:=AlgebraicAutomorphismGroup(node!.cgr);
            if not IsTrivial(aaut) and 2*Size(aaut)<Size(jaut) then 
                AppendTo(str, String("Orbits of aAut: ",-maxlength));
                AppendTo(str, StringCocoOrbReps@COCO2P(aaut,[1..RankOfColorGraph(node!.cgr)]));
                
                AppendTo(str, String("Generators of aAut: ",-maxlength),"\n");
                AppendTo(str, StringCocoGenerators@COCO2P(aaut, RankOfColorGraph(node!.cgr)));
            fi;
        fi;
    fi;
    
    CloseStream(str);
    return res;
end);

