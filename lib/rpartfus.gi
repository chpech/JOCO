#############################################################################
##
##  rpartfus.gi                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##                                                             Sven Reichard
##
##  Implementation of partial R-fusions 
##
#############################################################################

DeclareRepresentation( "IsPartialRFusionRep",
        IsPartialStablePartitionRep,
        [ "cgr",
          "ppart",
          "part", 
          "varpart",
          "maxclasssize",
        ]);


InstallMethod(RankOfPartialStablePartition,
"for partilal R-fusions in PartialRFusionRep",
[IsPartialRFusion and IsPartialRFusionRep],
function(ppart)
    return Length(ppart!.part.classes);
end);
              

InstallMethod(PRFusionsFamily,
    "for color graphs ",
	[IsColorGraph],
function(cgr)
   local fam;
   fam:=NewFamily("PRFusionsFam", IsPartialRFusion);
   return fam;
end);


InstallMethod(EmptyPartialRFusion,
        "for tensors of structure constants",
        [IsColorGraph and IsRainbow and IsStableRainbow, IsInt],
function(cgr,maxclasssize)
    local rclr,obj,part,varpart,tensor;
    
    rclr:=ReflexiveColors(cgr);
    
    part:=rec();
    part.classes:=[rclr, Difference([1..RankOfColorGraph(cgr)], rclr)];
    part.fixed:=[];
    part.variable:=[1,2];
    part.instabilFlags:=[false,false];
    part.instabil:=FiFoNew();
    part.totest:=FiFoNew();
    part.totestFlags:=[false,false];
    part.colorNames:=List([1..Length(part.classes)], x->[x,1]);
    part.numberClasses:=ListWithIdenticalEntries(Length(part.classes), 1);
    
    varpart:=Difference([1..RankOfColorGraph(cgr)], rclr);
    
    obj:=rec( cgr:=cgr,
              ppart:=[],
              part:=part,
              varpart:=varpart,
              maxclasssize:=maxclasssize
              );
    return Objectify(NewType(PRFusionsFamily(cgr), IsPartialRFusion and IsPartialRFusionRep), obj);
end);

InstallMethod(ExtendedPartialStablePartition,
        "for partial R-fusions and regular sets",
        [IsPartialRFusion and IsPartialRFusionRep, IsRegularSet],
function(pfusion,gs)
    local obj,class,npart,pos,nppart,nvarpart,sortpart,npfusion,mates;
    
        
    class:=pfusion!.varpart[1];
    if class =AsSet(gs) then
        npart:=WLShallowCopyStablePartition(pfusion!.part);
        pos:=Position(npart.classes,AsSet(gs));
        AddSet(npart.fixed, pos);
        RemoveSet(npart.variable,pos);
        nppart:=ShallowCopy(pfusion!.ppart);
        Add(nppart,AsSet(gs));
        
        obj:=rec( cgr:=pfusion!.cgr,
                  ppart:=nppart,
                  part:=npart,
                  varpart:=pfusion!.varpart{[2..Length(pfusion!.varpart)]},
                  maxclasssize:=pfusion!.maxclasssize);
    elif Length(gs)<Length(class) or (Length(gs)=Length(class) and AsSet(gs)<=class) then
        npart:=WLShallowCopyStablePartition(pfusion!.part);
        npart:=RRefinedPartition(npart,gs);
        if npart=fail then
            return fail;
        fi;
                
        nppart:=ShallowCopy(pfusion!.ppart);
        Add(nppart,AsSet(gs));
        nvarpart:=ShortLexSorted(StructuralCopy(npart.classes{npart.variable}));
        nvarpart:=Filtered(nvarpart, x->not x[1] in ReflexiveColors(pfusion!.cgr));
                
        obj:=rec( cgr:=pfusion!.cgr,
                  ppart:=nppart,
                  part:=npart,
                  varpart:=nvarpart,
                  maxclasssize:=pfusion!.maxclasssize);
    else
        return fail;
    fi;
    npfusion:=Objectify(NewType(PRFusionsFamily(pfusion!.cgr), IsPartialRFusion and IsPartialRFusionRep), obj);
#    Assert(1, OnSetsSets(Set(npfusion!.part.classes),Mates(npfusion!.tensor))=Set(npfusion!.part.classes));
    return npfusion;
    
end);

InstallMethod(IsCompatibleWithPartialStablePartition,
        "for partial R-fusions and regular sets",
        [IsPartialRFusion and IsPartialRFusionRep, IsRegularSet],
function(pfusion, gs)
    local class;
    
    for class in pfusion!.varpart do
        if IsSubset(class, AsSet(gs)) then
            return true;
        fi;
    od;
    return false;
end);

# InstallMethod( RainbowOfPartialRFusion,
#         "for partial R-fusions",
#         [IsPartialRFusion and IsPartialRFusionRep],
# function(pfus)
#     return pfus!.cgr;
# end);

InstallMethod( ViewString,
        "for partial R-fusions",
        [IsPartialRFusion and IsPartialRFusionRep],
function(pfus)
    return Concatenation("<partial R-fusion: ", String(pfus!.ppart), ">");
end);

InstallImmediateMethod( IsCompletePartialStablePartition,
        "for partial R-fusions",
       IsPartialRFusion,
function(pfus)
    if pfus!.varpart = [] then
        return true;
    elif Length(pfus!.varpart[1]) > pfus!.maxclasssize then
        return true;
    else
        return false;
    fi;
end);


###################################################################################
# Partial R-fusion orbits




InstallMethod(PRFusionOrbitsFamilyOp,
        "for tensors and permutation groups",
        [IsColorGraph, IsPermGroup],
function(cgr,g)
    return NewFamily("PRFusionOrbitsFam", IsPartialRFusionOrbit);
end);

InstallMethod(GetPartialStablePartitionOrbitFamily,
"for partial regular R-fusions in PartialRFusionRep and a permutation group",
[IsPartialRFusion and IsPartialRFusionRep, IsPermGroup],
function(prset,grp)  
    return PRFusionOrbitsFamily(prset!.cgr,grp);
end);

# PartialRFusionOrbitNC(<group>, <pjfus> ,<stab>)
# <pjfus> is a partial R-fusion that is assumed to be minimal (wrt. short lex) in its orbit
# the minimality property is not checked
# <stab> is supposed to be the full (SetsSets-wise) stabilizer of <pfus> in <group>
InstallMethod(PartialStablePartitionOrbitNC,
"for a permutation group, a partial R-fusion, and a permutation group",              
[ IsPermGroup, IsPartialRFusion and IsPartialRFusionRep, IsPermGroup],
function(group,pfus,stab)
    local res,fam;

    res:=rec(
            group:=group,
            rep:=pfus,
            stab:=stab);
    fam:=GetPartialStablePartitionOrbitFamily(pfus,group);
    
    return Objectify(NewType(fam, IsPartialRFusionOrbit and IsCocoOrbitRep), res);
end);

InstallMethod( ViewString,
        "for partial R-fusion orbits",
        [IsPartialRFusionOrbit],
function(pforb)
    return Concatenation("<partial R-fusion orbit of length ", String(Size(pforb)), ">");
end);


###################################################################################
# Iterators of partial R-fusion orbits

DeclareRepresentation( "IsPRFOrbitIterRep", IsComponentObjectRep, ["state"]);

PRFOrbitIteratorsFamily := NewFamily("PRFOrbitIteratorsFamily", 
                                      IsIteratorOfPRFOrbits);

InstallMethod(IteratorOfPartialRFusionOrbits,
    "for partial R-fusions",
    [IsList],
function(gsorb)
    local maxrank,state,aaut,tensor,pfus;
    
    
    if gsorb= [] then
        state:=fail;
    fi;
    
    if not ForAll(gsorb, IsRegularSetOrbit) then
        ErrorNoReturn("IteratorOfPartialRFusionOrbits: expecting a list of regular set orbits");
    fi;
        
    if not ForAll(gsorb, gso->IsIdenticalObj(FamilyObj(gso),FamilyObj(gsorb[1]))) then
        ErrorNoReturn("IteratorOfRPartialFusionOrbits: Regular sets are incompatible");
    fi;
    
    
    maxrank:=ValueOption("maxrank");

    aaut:=UnderlyingGroupOfCocoOrbit(gsorb[1]);
    pfus:=EmptyPartialRFusion(UnderlyingCgrOfRegularSet(Representative(gsorb[1])), Maximum(List(gsorb, x->Size(Representative(x)))));
        
    state:=rec( pfus:=pfus,
                maxrank:=maxrank,
                G:=aaut,         # the group under which we enumerate orbits
                GS:=aaut,        # the SetsSetsStabilizer of the finished slices
                H:=aaut,         # the SetsSetsStabilizer of the current slice
                slice:=[],       # the current slice
                orbits:=Set(gsorb),   # compatible H-orbit representatives of good sets
                orbidx:=1,
                linkback:=fail
              );
    
    return Objectify(NewType(PRFOrbitIteratorsFamily,
                   IsIteratorOfPRFOrbits and IsPRFOrbitIterRep and IsMutable),
                   rec(state:=state));
end);



InstallMethod( NextIterator,
        "for iterators of partial R-fusions",
        [IsIteratorOfPRFOrbits and IsPRFOrbitIterRep and IsMutable],
function(iter)
    local NextState, pfus,grp,stab;
        
    NextState:=function(state)
        local gsorb,gs,ags,npfus,nH,nextstate,norbits,xnorbits;
        
        if state=fail then 
            return fail; 
        fi;        
        
        if state.maxrank<>fail and RankOfPartialFusion(state.pfus) > state.maxrank  or 
           RankOfPartialFusion(state.pfus) = state.maxrank and IsCompletePartialRFusion(state.pfus) then
            Info(InfoCOCO,2,"*");
            
            return NextState(state.linkback);
        fi;
            
        if state.orbidx>Length(state.orbits) then
            return NextState(state.linkback);
        fi;
        
        repeat
            gsorb:=state.orbits[state.orbidx];
            gs:=CanonicalRepresentativeOfCocoOrbit(gsorb);
            state.orbidx:=state.orbidx+1;
            
            if state.slice=[] then
                ags:=OnRegularSets(gs, ColorMates(UnderlyingCgrOfRegularSet(gs)));
                if AsSet(ags)<AsSet(gs) then
                    nH:=();
                    continue;
                fi;
                npfus:=ExtendedPartialRFusion(state.pfus,gs);
                if npfus=fail then
                    nH:=();
                    continue;
                fi;
                nH:=StabilizerOfCanonicalRepresentative(gsorb);
                xnorbits:=Filtered(state.orbits, x->Length(Representative(x))>=Length(gs));
                norbits:=Union(List(xnorbits, 
                                    x->SubOrbitsWithInvariantPropertyOfCocoOrbit(nH, x, 
                                        y->IsRCompatibleWithPart(npfus,y))));
                Assert(1,norbits=Union(List(xnorbits, 
                                    x->Filtered(SubOrbitsOfCocoOrbit(nH,x),
                                         y->IsRCompatibleWithPart(npfus,Representative(y))))));
                
                norbits:=Filtered(norbits, x->Representative(x)>gs);
#                Assert(1, npfus!.varpart=[] or 2*Length(npfus!.varpart[1])>Order(npfus!.tensor) or npfus!.varpart[1] in Set(norbits, x->AsSet(Representative(x))));
                
                nextstate:=rec( pfus:=npfus,
                                maxrank:=state.maxrank,
                                G:=state.G,
                                GS:=state.G,
                                H:=nH,
                                slice:=[AsSet(gs)],
                                orbits:=norbits,
                                orbidx:=1,
                                linkback:=state);
            elif Length(state.slice[1])<Length(gs) then
                ags:=OnRegularSets(gs, ColorMates(UnderlyingCgrOfRegularSet(gs)));
                if AsSet(ags)<AsSet(gs) then
                    nH:=();
                    continue;
                fi;
                npfus:=ExtendedPartialRFusion(state.pfus,gs);
                if npfus=fail then
                    nH:=();
                    continue;
                fi;
                nH:=StabilizerOfCanonicalRepresentative(gsorb);
                xnorbits:=Filtered(state.orbits, x->Length(Representative(x))>=Length(gs));
                norbits:=Union(List(xnorbits, x->SubOrbitsWithInvariantPropertyOfCocoOrbit(nH, x, y->IsRCompatibleWithPart(npfus,y))));
#                Assert(1, norbits=Union(List(xnorbits, x->Filtered(SubOrbitsOfCocoOrbit(nH,x), y->IsCompatibleWithPart(npfus,Representative(y))))));
                
                norbits:=Filtered(norbits, x->Representative(x)>gs);                
#                Assert(1, npfus!.varpart=[] or 2*Length(npfus!.varpart[1])>Order(npfus!.tensor) or npfus!.varpart[1] in Set(norbits, x->AsSet(Representative(x))));

                nextstate:=rec( pfus:=npfus,
                                maxrank:=state.maxrank,
                                G:=state.G,
                                GS:=state.H,
                                H:=nH,
                                slice:=[AsSet(gs)],
                                orbits:=norbits,
                                orbidx:=1,
                                linkback:=state);
            else
#                Assert(1, Length(gs)>=Length(state.slice[1]));
                ags:=OnRegularSets(gs, ColorMates(UnderlyingCgrOfRegularSet(gs)));
                if AsSet(ags)<AsSet(gs) then
                    if not AsSet(ags) in state.slice then
                        nH:=();
                        continue;
                    fi;
                fi;
                
                npfus:=ExtendedPartialRFusion(state.pfus,gs);
                if npfus=fail then
                    nH:=();
                    continue;
                fi;
                nH:=SetsSetsReducibilityTestOneCard(state.GS, StabilizerOfCanonicalRepresentative(gsorb),state.slice,AsSet(gs));
                if IsPerm(nH) then
                    continue;
                fi;
                norbits:=Union(List(state.orbits, x->SubOrbitsWithInvariantPropertyOfCocoOrbit(StabilizerOfCanonicalRepresentative(gsorb), x, y->IsRCompatibleWithPart(npfus,y))));
#                Assert(1,norbits=Union(List(state.orbits, x->Filtered(SubOrbitsOfCocoOrbit(StabilizerOfCanonicalRepresentative(gsorb),x),y->IsCompatibleWithPart(npfus,Representative(y))))));

                norbits:=Set(norbits, x->RegularSetOrbit(nH, CanonicalRepresentativeOfCocoOrbit(x),
                    ClosureGroup(StabilizerOfCanonicalRepresentative(x), Stabilizer(nH, AsSet(CanonicalRepresentativeOfCocoOrbit(x)),OnTuples))));
                norbits:=Filtered(norbits, x->Representative(x)>gs);               
#                Assert(1,npfus!.varpart=[] or 2*Length(npfus!.varpart[1])>Order(npfus!.tensor) or npfus!.varpart[1] in Set(norbits, x->AsSet(Representative(x))));

                nextstate:=rec( pfus:=npfus,
                                maxrank:=state.maxrank,
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
    return PartialRFusionOrbitNC(grp,pfus,stab);
end);

InstallMethod( IsDoneIterator,
        "for partial R-fusion iterators",
        [IsIteratorOfPRFOrbits and IsPRFOrbitIterRep],
function(iter)
    return iter!.state=fail;
end);


COCOInfoPFUSSize:=5;
InstallMethod(AllRFusionOrbits,
        "for iterators of partial R-fusion orbits",
        [IsIteratorOfPRFOrbits and IsPRFOrbitIterRep],
function(iter)
    local res,pfus,fus,fusorb,flt;
    
    flt:=ValueOption("filter");
    if flt=fail then
        flt:=ReturnTrue;
    fi;

    if IsDoneIterator(iter) then
        return [];
    fi;
    
    res:=[];
        
    while not IsDoneIterator(iter) do
        if Length(iter!.state.slice)<=COCOInfoPFUSSize then
            Info(InfoCOCO,1,iter!.state.slice,"\n");
        fi;
        if IsCompletePartialRFusion(iter!.state.pfus) then
            pfus:=iter!.state.pfus;
            fus:=RFusionFromCompletePartialRFusion(pfus);
            
            fusorb:=RFusionOrbitNC(iter!.state.G, fus, iter!.state.H);
            Assert(1,iter!.state.H = Stabilizer(iter!.state.G, AsPartition(fus),OnSetsSets));
            
            if flt(fusorb) then
                Info(InfoCOCO,1,"!");
                Add(res, fusorb);
            fi;
            
        fi;
        
        NextIterator(iter);
    od;
    return res;
end);

InstallMethod( ViewString,
        "for partial R-fusion iterators",
        [IsIteratorOfPRFOrbits and IsPRFOrbitIterRep],
function(iter)
    return Concatenation("<partial R-fusion orbit iterator, current slice: ",
          String(iter!.state.slice), ">");
end);

InstallGlobalFunction(RRefinedPartition,
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
    iM:=OnSets(M,ColorMates(UnderlyingCgrOfRegularSet(gs)));

    res:=repart(newPart,M,true);
    if res=fail then
        return fail;
    fi;


    if iM>M then
        res:=repart(res,iM,false);
        if res=fail then
            return fail;
        fi;
    fi;

    return res;
end);

# InstallMethod(ConstructorOfCocoOrbit,
#         "for all partial R-fusion orbits",
#         [IsPartialRFusionOrbit],
# function(orb)
#     return PartialRFusionOrbit;
# end);

InstallMethod(ConstructorOfCocoOrbitNC,
        "for all partial fusion orbits",
        [IsPartialFusionOrbit],
function(orb)
    return PartialRFusionOrbitNC;
end);
