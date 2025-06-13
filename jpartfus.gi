#############################################################################
##
##  jpartfus.gi                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##                                                             Sven Reichard
##
##  Implementation of partial J-fusions 
##
#############################################################################

DeclareRepresentation( "IsPartialJFusionRep",
        IsAttributeStoringRep,
        [ "tensor",
          "ppart",
          "part", 
          "varpart",
          "maxclasssize",
        ]);


InstallMethod(PartialJFusionsFamily,
    "for tensors",
	[IsTensor],
function(cgr)
   local fam;
   fam:=NewFamily("PartialJFusionsFam", IsPartialJFusion);
   return fam;
end);

InstallMethod(EmptyPartialJFusion,
        "for tensors of structure constants",
        [IsTensor and IsTensorOfCC, IsInt],
function(tensor,maxclasssize)
    local obj,part,varpart;
    
    part:=WLBuildTrivialPartition(tensor);
    varpart:=ShortLexSorted(StructuralCopy(part.classes{part.variable}));
    varpart:=Filtered(varpart, x->not x[1] in ReflexiveColors(tensor));
    
    obj:=rec( tensor:=tensor,
              ppart:=[],
              part:=part,
              varpart:=varpart,
              maxclasssize:=maxclasssize
              );
    return Objectify(NewType(PartialJFusionsFamily(tensor), IsPartialJFusion and IsPartialJFusionRep), obj);
end);


InstallMethod(ExtendedPartialJFusion,
        "for partial fusions and good sets",
        [IsPartialJFusion and IsPartialJFusionRep, IsJGoodSet],
function(pfusion,gs)
    local obj,tensor,class,npart,pos,nppart,nvarpart,sortpart,npfusion,mates;
    
    tensor:=pfusion!.tensor;
        
    class:=pfusion!.varpart[1];
    if class =AsSet(gs) then
        npart:=WLShallowCopyStablePartition(pfusion!.part);
        pos:=Position(npart.classes,AsSet(gs));
        AddSet(npart.fixed, pos);
        RemoveSet(npart.variable,pos);
        nppart:=ShallowCopy(pfusion!.ppart);
        Add(nppart,AsSet(gs));
        
        obj:=rec( tensor:=tensor,
                  ppart:=nppart,
                  part:=npart,
                  varpart:=pfusion!.varpart{[2..Length(pfusion!.varpart)]},
                  maxclasssize:=pfusion!.maxclasssize);
    elif Length(gs)<Length(class) or (Length(gs)=Length(class) and AsSet(gs)<=class) then
        npart:=WLShallowCopyStablePartition(pfusion!.part);
        npart:=JRefinedPartition(npart,gs);
        if npart=fail then
            return fail;
        fi;
        
        npart:=JStabil(tensor, npart, AsSet(gs):sym);
        if npart=fail then
            return fail;
        fi;
        
        nppart:=ShallowCopy(pfusion!.ppart);
        Add(nppart,AsSet(gs));
        nvarpart:=ShortLexSorted(StructuralCopy(npart.classes{npart.variable}));
        nvarpart:=Filtered(nvarpart, x->not x[1] in ReflexiveColors(tensor));
                
        obj:=rec( tensor:=tensor,
                  ppart:=nppart,
                  part:=npart,
                  varpart:=nvarpart,
                  maxclasssize:=pfusion!.maxclasssize);
    else
        return fail;
    fi;
    npfusion:=Objectify(NewType(PartialJFusionsFamily(tensor), IsPartialJFusion and IsPartialJFusionRep), obj);
    Assert(1, OnSetsSets(Set(npfusion!.part.classes),Mates(npfusion!.tensor))=Set(npfusion!.part.classes));
    return npfusion;
    
end);

InstallMethod(IsJCompatibleWithPart,
        "for partial J-fusions and J-good sets",
        [IsPartialJFusion and IsPartialJFusionRep, IsJGoodSet],
function(pfusion, gs)
    local class;
    
    for class in pfusion!.varpart do
        if IsSubset(class, AsSet(gs)) then
            return true;
        fi;
    od;
    return false;
end);

InstallMethod( TensorOfPartialJFusion,
        "for partial fusions",
        [IsPartialJFusion and IsPartialJFusionRep],
function(pfus)
    return pfus!.tensor;
end);

InstallMethod( ViewString,
        "for partial J-fusions",
        [IsPartialJFusion and IsPartialJFusionRep],
function(pfus)
    return Concatenation("<partial J-fusion: ", String(pfus!.ppart), ">");
end);


InstallImmediateMethod( IsCompletePartialJFusion,
        "for partial J-fusions",
       IsPartialJFusion,0,
function(pfus)
    if pfus!.varpart = [] then
        return true;
    elif Length(pfus!.varpart[1]) > pfus!.maxclasssize then
        return true;
    else
        return false;
    fi;
end);

InstallMethod( JFusionFromCompletePartialJFusion,
        "for partial J-fusions",
        [IsPartialJFusion and IsPartialJFusionRep],
function(cpfus)
 #   Assert(1, OnSetsSets(Set(cpfus!.part.classes),Mates(cpfus!.tensor))=Set(cpfus!.part.classes));
    
    return JFusionFromPartitionNC(cpfus!.tensor,cpfus!.part.classes);
end);




###################################################################################
# Partial J-fusion orbits


InstallMethod(PartialJFusionOrbitsFamilyOp,
        "for a tensor  and a permutation group",
        [IsTensor, IsPermGroup],
function(tensor,g)
    return NewFamily("PartialJFusionOrbitsFam", IsPartialJFusionOrbit);
end);


# PartialJFusionOrbitNC(<group>, <pjfus> ,<stab>)
# <pjfus> is a partial fusion that is assumed to be minimal (wrt. short lex) in its orbit
# the minimality property is not checked
# <stab> is supposed to be the full (SetsSets-wise) stabilizer of <pfus> in <group>
InstallGlobalFunction(PartialJFusionOrbitNC,
function(group,pfus,stab)
    local res;

    res:=rec(
            group:=group,
            rep:=pfus,
            stab:=stab);
   return Objectify(NewType(PartialJFusionOrbitsFamily(TensorOfPartialJFusion(pfus),group), IsPartialJFusionOrbit and IsCocoOrbitRep), res);
end);

InstallMethod( ViewString,
        "for partial J-fusion orbits",
        [IsPartialJFusionOrbit],
function(pforb)
    return Concatenation("<partial J-fusion orbit of length ", String(Size(pforb)), ">");
end);

###################################################################################
# Iterators of partial J-fusion orbits

DeclareRepresentation( "IsPJFOrbitIterRep", IsComponentObjectRep, ["state"]);

PJFOrbitIteratorsFamily := NewFamily("PJFOrbitIteratorsFamily", 
                                      IsIteratorOfPJFOrbits);

InstallMethod(IteratorOfPartialJFusionOrbits,
    "for partial J-fusions",
    [IsList],
function(gsorb)
    local state,aaut,tensor,pfus;
    
    
    if gsorb= [] then
        state:=fail;
    else
        if not ForAll(gsorb, IsJGoodSetOrbit) then
            ErrorNoReturn("IteratorOfPartialJFusionOrbits: expecting a list of J-good set orbits");
        fi;
        
        if not ForAll(gsorb, gso->IsIdenticalObj(FamilyObj(gso),FamilyObj(gsorb[1]))) then
            ErrorNoReturn("IteratorOfJPartialFusionOrbits: J-good sets are incompatible");
        fi;
        aaut:=UnderlyingGroupOfCocoOrbit(gsorb[1]);
        tensor:=TensorOfJGoodSet(Representative(gsorb[1]));
        pfus:=EmptyPartialJFusion(tensor, Maximum(List(gsorb, x->Size(Representative(x)))));
        
        state:=rec( pfus:=pfus,
                    G:=aaut,         # the group under which we enumerate orbits
                    GS:=aaut,        # the SetsSetsStabilizer of the finished slices
                    H:=aaut,         # the SetsSetsStabilizer of the current slice
                    slice:=[],       # the current slice
                    orbits:=Set(gsorb),   # compatible H-orbit representatives of good sets
                    orbidx:=1,
                    linkback:=fail
                    );
    fi;
    
    return Objectify(NewType(PJFOrbitIteratorsFamily,
                   IsIteratorOfPJFOrbits and IsPJFOrbitIterRep and IsMutable),
                   rec(state:=state));
end);


InstallMethod( NextIterator,
        "for iterators of partial J-fusions",
        [IsIteratorOfPJFOrbits and IsPJFOrbitIterRep and IsMutable],
function(iter)
    local NextState, pfus,grp,stab;
        
    NextState:=function(state)
        local gsorb,gs,ags,npfus,nH,nextstate,norbits,xnorbits;
        
        if state=fail then 
            return fail; 
        fi;        
        
        if state.orbidx>Length(state.orbits) then
            return NextState(state.linkback);
        fi;
        
        repeat
            gsorb:=state.orbits[state.orbidx];
            gs:=CanonicalRepresentativeOfCocoOrbit(gsorb);
            state.orbidx:=state.orbidx+1;
            
            if state.slice=[] then
                ags:=OnJGoodSets(gs, Mates(TensorOfJGoodSet(gs)));
                if AsSet(ags)<AsSet(gs) then
                    nH:=();
                    continue;
                fi;
                npfus:=ExtendedPartialJFusion(state.pfus,gs);
                if npfus=fail then
                    nH:=();
                    continue;
                fi;
                nH:=StabilizerOfCanonicalRepresentative(gsorb);
                xnorbits:=Filtered(state.orbits, 
                                   x->Length(Representative(x))>=Length(gs));
                norbits:=Union(List(xnorbits, 
                   x->SubOrbitsWithInvariantPropertyOfCocoOrbit(nH, x, 
                      y->IsJCompatibleWithPart(npfus,y))));
#                Assert(1,norbits=Union(List(xnorbits, x->Filtered(SubOrbitsOfCocoOrbit(nH,x),y->IsCompatibleWithPart(npfus,Representative(y))))));
                
                norbits:=Filtered(norbits, x->Representative(x)>gs);
#                Assert(1, npfus!.varpart=[] or 2*Length(npfus!.varpart[1])>Order(npfus!.tensor) or npfus!.varpart[1] in Set(norbits, x->AsSet(Representative(x))));
                
                nextstate:=rec( pfus:=npfus,
                                G:=state.G,
                                GS:=state.G,
                                H:=nH,
                                slice:=[AsSet(gs)],
                                orbits:=norbits,
                                orbidx:=1,
                                linkback:=state);
            elif Length(state.slice[1])<Length(gs) then
                ags:=OnJGoodSets(gs, Mates(TensorOfJGoodSet(gs)));
                if AsSet(ags)<AsSet(gs) then
                    nH:=();
                    continue;
                fi;
                npfus:=ExtendedPartialJFusion(state.pfus,gs);
                if npfus=fail then
                    nH:=();
                    continue;
                fi;
                nH:=StabilizerOfCanonicalRepresentative(gsorb);
                xnorbits:=Filtered(state.orbits, 
                                   x->Length(Representative(x))>=Length(gs));
                norbits:=Union(List(xnorbits, 
                   x->SubOrbitsWithInvariantPropertyOfCocoOrbit(nH, x, 
                      y->IsJCompatibleWithPart(npfus,y))));
#                Assert(1, norbits=Union(List(xnorbits, x->Filtered(SubOrbitsOfCocoOrbit(nH,x), y->IsCompatibleWithPart(npfus,Representative(y))))));
                
                norbits:=Filtered(norbits, x->Representative(x)>gs);                
#                Assert(1, npfus!.varpart=[] or 2*Length(npfus!.varpart[1])>Order(npfus!.tensor) or npfus!.varpart[1] in Set(norbits, x->AsSet(Representative(x))));

                nextstate:=rec( pfus:=npfus,
                                G:=state.G,
                                GS:=state.H,
                                H:=nH,
                                slice:=[AsSet(gs)],
                                orbits:=norbits,
                                orbidx:=1,
                                linkback:=state);
            else
#                Assert(1, Length(gs)>=Length(state.slice[1]));
                ags:=OnJGoodSets(gs, Mates(TensorOfJGoodSet(gs)));
                if AsSet(ags)<AsSet(gs) then
                    if not AsSet(ags) in state.slice then
                        nH:=();
                        continue;
                    fi;
                fi;
                
                npfus:=ExtendedPartialJFusion(state.pfus,gs);
                if npfus=fail then
                    nH:=();
                    continue;
                fi;
                nH:=SetsSetsReducibilityTestOneCard(state.GS, StabilizerOfCanonicalRepresentative(gsorb),state.slice,AsSet(gs));
                if IsPerm(nH) then
                    continue;
                fi;
                norbits:=Union(List(state.orbits, 
                   x->SubOrbitsWithInvariantPropertyOfCocoOrbit(StabilizerOfCanonicalRepresentative(gsorb), x, 
                        y->IsJCompatibleWithPart(npfus,y))));
#                Assert(1,norbits=Union(List(state.orbits, x->Filtered(SubOrbitsOfCocoOrbit(StabilizerOfCanonicalRepresentative(gsorb),x),y->IsCompatibleWithPart(npfus,Representative(y))))));

                norbits:=Set(norbits, x->JGoodSetOrbit(nH, CanonicalRepresentativeOfCocoOrbit(x),
                    ClosureGroup(StabilizerOfCanonicalRepresentative(x), Stabilizer(nH, AsSet(CanonicalRepresentativeOfCocoOrbit(x)),OnTuples))));
                norbits:=Filtered(norbits, x->Representative(x)>gs);               
#                Assert(1,npfus!.varpart=[] or 2*Length(npfus!.varpart[1])>Order(npfus!.tensor) or npfus!.varpart[1] in Set(norbits, x->AsSet(Representative(x))));

                nextstate:=rec( pfus:=npfus,
                                G:=state.G,
                                GS:=state.GS,
                                H:=nH,
                                slice:=Concatenation(state.slice,[AsSet(gs)]),
                                orbits:=norbits,
                                orbidx:=1,
                                linkback:=state);
            fi;
        until not IsPerm(nH) or state.orbidx > Length(state.orbits);
        if IsPerm(nH) then
            return NextState(state.linkback);
        fi;
 
        return nextstate;
    end;
    
    if iter!.state=fail then
        return fail;
    fi;
    
    pfus:=iter!.state.pfus;
    grp:=iter!.state.G;
    stab:=iter!.state.H;
    
    iter!.state:=NextState(iter!.state);
    return PartialJFusionOrbitNC(grp,pfus,stab);
end);

InstallMethod( IsDoneIterator,
        "for partial J-fusion iterators",
        [IsIteratorOfPJFOrbits and IsPJFOrbitIterRep],
function(iter)
    return iter!.state=fail;
end);

COCOInfoPFUSSize:=5;
InstallMethod(AllJFusionOrbits,
        "for iterators of partial J-fusion orbits",
        [IsIteratorOfPJFOrbits and IsPJFOrbitIterRep],
function(iter)
    local res,pfus,fus,fusorb;
    
    if IsDoneIterator(iter) then
        return [];
    fi;
    
    res:=[];
        
    while not IsDoneIterator(iter) do
        if Length(iter!.state.slice)<=COCOInfoPFUSSize then
            Info(InfoCOCO,1,iter!.state.slice,"\n");
        fi;
        if IsCompletePartialJFusion(iter!.state.pfus) then
            Info(InfoCOCO,1,"!");
            pfus:=iter!.state.pfus;
            fus:=JFusionFromCompletePartialJFusion(pfus);
            
            fusorb:=JFusionOrbitNC(iter!.state.G, fus, iter!.state.H);
            Assert(1,iter!.state.H = Stabilizer(iter!.state.G, AsPartition(fus),OnSetsSets));
#            Assert(1, not fusorb in res);
            
            Add(res, fusorb);
        fi;
        
        NextIterator(iter);
    od;
    return res;
end);


InstallMethod( ViewString,
        "for partial J-fusion iterators",
        [IsIteratorOfPJFOrbits and IsPJFOrbitIterRep],
function(iter)
    return Concatenation("<partial J-fusion orbit iterator, current slice: ",
          String(iter!.state.slice), ">");
end);

InstallGlobalFunction(JRefinedPartition,
function(newPart,gs)
    local   repart,  T,  M,  res,  iM,xres;
    repart:=function(newPart,u,fix)
        local   i,  newclass;
        i:=1;
        while i<=Length(newPart.variable) and
          not IsSubset(WLPartitionClass(newPart,newPart.variable[i]),u) do
            i:=i+1;
        od;
        if i > Length(newPart.variable) then
            return fail;
        fi;

        i:=newPart.variable[i];
        if WLPartitionClass(newPart,i)=u then
            if fix then
                RemoveSet(newPart.variable,i);
                AddSet(newPart.fixed,i);
            fi;
            WLInstabilQueueAdd(newPart,i);

            return newPart;
        fi;
        newclass:=Difference(WLPartitionClass(newPart,i), u);
        if Length(newclass)<Length(u)  then
            return fail;
        fi;
        if fix and Length(newclass)=Length(u) and newclass<u then
            return fail;
        fi;

        newPart.classes[i]:=newclass;
        WLInstabilQueueAdd(newPart,i);
        Add(newPart.classes,u);
        if fix then
            AddSet(newPart.fixed, Length(newPart.classes));
        else
            AddSet(newPart.variable,Length(newPart.classes));
        fi;


        newPart.instabilFlags[Length(newPart.classes)]:=false;
        newPart.totestFlags[Length(newPart.classes)]:=false;
        WLInstabilQueueAdd(newPart, Length(newPart.classes));
        return newPart;
    end;
    
    M:=AsSet(gs);
    
    return repart(newPart,M,true);
end);

# InstallMethod(ConstructorOfCocoOrbit,
#         "for all partial J-fusion orbits",
#         [IsPartialJFusionOrbit],
# function(orb)
#     return PartialJFusionOrbit;
# end);

InstallMethod(ConstructorOfCocoOrbitNC,
        "for all partial J-fusion orbits",
        [IsPartialJFusionOrbit],
function(orb)
    return PartialJFusionOrbitNC;
end);
