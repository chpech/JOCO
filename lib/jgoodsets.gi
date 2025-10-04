
DeclareRepresentation("IsJGoodSetRep",
        IsAttributeStoringRep,
        [ "tensor",             # the tensor over which the J-good set "lives"
          "set",                # the J-good set of colors of <tensor>
          "part",               # the J-stable partition induced by <set>
        ]);

InstallMethod(JGoodSetsFamily,
    "for tensors",
	[IsTensor],
function(cgr)
   local fam;
   fam:=NewFamily("JGoodSetsFam", IsJGoodSet);
   return fam;
end);

InstallMethod(JGoodSetFromPartialGoodSet,
    "for symmetric partial good sets in PartialGoodSetRep",
    [IsSymPartialGoodSet and IsPartialGoodSetRep],
function(cand)
    local  part;
       
    part:=WLBuildSymGoodSetPartition(cand!.tensor,cand!.set);
    part:=JStabil(cand!.tensor,part:sym);
    if part= fail then
        return fail;
    fi;
    
    return BuildJGoodSet(cand!.tensor, cand!.set, part.classes);
    
end);

InstallGlobalFunction(BuildJGoodSet,
function(arg)
   local tensor,set,part,res;

   tensor:=arg[1];
   set:=arg[2];
   if Length(arg)=3 then
       part:=arg[3];
   else
       part:=WLBuildSymGoodSetPartition(tensor,set);
       part:=JStabil(tensor,part:sym);
       if part=fail then
           return fail;
       fi;
       part:=part.classes;
   fi;


   res:=rec(
            tensor:=tensor,
            set:=Immutable(set),
            part:=Immutable(part));
   return Objectify(NewType(JGoodSetsFamily(tensor), IsJGoodSet and IsJGoodSetRep), res);
end);

InstallMethod(TensorOfJGoodSet,
        "for J-good sets in JGoodSetRep",
        [IsJGoodSet and IsJGoodSetRep],
function(gs)
   return gs!.tensor;
end);

InstallOtherMethod(AsSet,
        "for J-good sets in JGoodSetRep",
        [IsJGoodSet and IsJGoodSetRep],
function(gs)
  return gs!.set;
end);

InstallOtherMethod(Length,
        "for J-good sets",
        [IsJGoodSet],
function(gs)
    return Length(AsSet(gs));
end);

InstallOtherMethod(\<,
        "for J-good sets",
        IsIdenticalObj,
        [IsJGoodSet,IsJGoodSet],
function(gs1,gs2)
    if Length(gs1)<>Length(gs2) then
        return Length(gs1)<Length(gs2);
    else
        return AsSet(gs1)<AsSet(gs2);
    fi;
end);

InstallOtherMethod(\=,
        "for J-good sets",
        IsIdenticalObj,
        [IsJGoodSet,IsJGoodSet],
function(gs1,gs2)
    return AsSet(gs1)=AsSet(gs2);
end);

# <g> must be from Aut(<gs!.tensor>)
InstallMethod(OnJGoodSets,
        "for J-good sets in JGoodSetRep",
        [IsJGoodSet and IsJGoodSetRep, IsPerm],
function(gs, g)
    local res;
   res:=rec(
            tensor:=gs!.tensor,
            set:=MakeImmutable(OnSets(gs!.set,g)),
            part:=MakeImmutable(OnSetsSets(gs!.part,g)));
   return Objectify(NewType(JGoodSetsFamily(gs!.tensor), IsJGoodSet and IsJGoodSetRep), res);
end);

InstallMethod(PartitionOfJGoodSet,
        "for J-good sets in JGoodSetRep",
        [IsJGoodSet and IsJGoodSetRep],
function(gs)
    return gs!.part;
end);

InstallOtherMethod(Size,
        "for J-good sets in JGoodSetRep",
        [IsJGoodSet and IsJGoodSetRep],
function(gs)
    return Size(gs!.set);
end);

InstallMethod(ViewString,
        "for J-good set orbits",
        [IsJGoodSet and IsJGoodSetRep],
function(x) 
    return Concatenation("<", "JGoodSet ", String(AsSet(x)), ">");
end);

InstallMethod(JGoodSetOrbitsFamilyOp,
        "for a tensor  and a permutation group",
        [IsTensor, IsPermGroup],
function(cgr,g)
    return NewFamily("JGoodSetOrbitsFam", IsJGoodSetOrbit);
end);

InstallGlobalFunction(JGoodSetOrbit,
function(arg)
    local group,gs,stab, can,xstab,nstab;

    group:=arg[1];
    gs:=arg[2];
    if Length(arg)=2 then
        stab:=Stabilizer(group,AsSet(gs), OnSets);
    else
        stab:=arg[3];
    fi;

    can:=SetCanonifiers(Stbc(group), Stbc(stab), AsSet(gs));
    nstab:=ClosureGroup(stab, List(can, x->can[1]*x^(-1)));


    return JGoodSetOrbitNC(group, OnJGoodSets(gs,can[1]), nstab^can[1]);
end);

InstallGlobalFunction(JGoodSetOrbitNC,
function(arg)
    local group,gs,stab,res;

    group:=arg[1];
    gs:=arg[2];
    if Length(arg)=2 then
        stab:=Stabilizer(group,AsSet(gs), OnSets);
    else
        stab:=arg[3];
    fi;

    res:=rec(
            group:=group,
            rep:=gs,
            stab:=stab);
   return Objectify(NewType(JGoodSetOrbitsFamily(TensorOfJGoodSet(gs),group), IsJGoodSetOrbit and IsCocoOrbitRep), res);
end);

InstallMethod(OnCocoOrbits,
        "for all J-good set orbits",
        [IsJGoodSetOrbit, IsPerm],
function(gsorb,perm)
    local   grp,  gs,  stab,  ngs,  ngrp,  nstab;
    
    if perm=() then
        return gsorb;
    fi;
    
    grp:=UnderlyingGroupOfCocoOrbit(gsorb);
    gs:=CanonicalRepresentativeOfCocoOrbit(gsorb);
    stab:=StabilizerOfCanonicalRepresentative(gsorb);

    ngs:=OnJGoodSets(gs,perm);
    return JGoodSetOrbit(grp,ngs,Stabilizer(grp,AsSet(ngs),OnTuples),FamilyObj(gsorb));
end);

# InstallMethod(SubOrbitsOfCocoOrbit,
#         "for all J-good set orbits",
#         [IsPermGroup, IsJGoodSetOrbit],
# function(grp,gsorb)
#     local   ug,  cosreps,  stab,  gs,  ngs;


#     ug:=UnderlyingGroupOfCocoOrbit(gsorb);

#     if not IsSubgroup(ug,grp) then
#         Error("SubOrbitsOfCocoOrbit: The given group is not a subgroup of the underlying group of the orbit!");
#     fi;
#     stab:=StabilizerOfCanonicalRepresentative(gsorb);
#     cosreps:=List(DoubleCosetRepsAndSizes(ug,stab,grp), x->x[1]); 
#     gs:=CanonicalRepresentativeOfCocoOrbit(gsorb);
#     ngs:=JGoodSetOrbitNC(grp,gs, Intersection(stab,grp));

#     return List(cosreps, x->OnCocoOrbits(ngs,x));
# end);



# InstallMethod(SubOrbitsWithInvariantPropertyOfCocoOrbit,
#         "for J-good set orbits",
#         [IsPermGroup, IsJGoodSetOrbit, IsFunction],
# function(grp,gsorb,func)
#     local  ug, stab, gs, cosreps, ngs, res, cr,i,signs;

#     ug:=UnderlyingGroupOfCocoOrbit(gsorb);

#     if not IsSubgroup(ug,grp) then
#         Error("SubOrbitsWithInvariantPropertyOfCocoOrbit: The given group is not a subgroup of the underlying group of the orbit!");
#     fi;
    
#     stab:=StabilizerOfCanonicalRepresentative(gsorb);
#     gs:=CanonicalRepresentativeOfCocoOrbit(gsorb);
#     if not IsTrivial(grp) then  
#         cosreps:=List(DoubleCosetRepsAndSizes(ug,stab,grp), x->x[1]); 
#         ngs:=JGoodSetOrbitNC(grp,gs, Intersection(stab,grp));
#         res:=List(cosreps, x->OnCocoOrbits(ngs,x));
#         res:=Filtered(res, x->func(CanonicalRepresentativeOfCocoOrbit(x)));
#     else
#         cosreps:=RightTransversal(ug,stab);
#         res:=[];
        
#         i:=0;signs:=["-\b","\\\b","|\b","/\b"];
#         COCOPrint(" \c");

        
#         for cr in cosreps do 
#             if i mod COCORotorMod = 0 then
#                 COCOPrint(signs[i/COCORotorMod+1],"\c");
#             fi;
        
#             i:=(i+1) mod (4*COCORotorMod);
            
#             ngs:=OnJGoodSets(gs,cr);
#             if func(ngs) then
#                 ngs:=JGoodSetOrbitNC(grp,ngs,Group(()));
#                 Add(res,ngs);
#             fi;
#         od;
#         COCOPrint("\b");
#     fi;
    
#     if Length(res)>0 then
#         Info(InfoCOCO,2,Size(gsorb),"\t",Size(grp),"\t",Length(res),"\n");
#     else
#         Info(InfoCOCO, 2,"-\c");
#     fi;
    
#     return Set(res);
# end);


InstallMethod(HomogeneousJGoodSetOrbits,
        "for structure constants tensors",
        [IsTensor and IsTensorOfCC],
function(tensor)
    local  prim, lgs;
    prim:=ValueOption("prim");
    if prim=fail then
        prim:=false;
    fi;
    lgs:=Filtered(AllJGoodSetOrbits(IteratorOfPartialGoodSetOrbits(AutomorphismGroup(tensor), EmptySymPartialGoodSet(tensor))),orb->AsSet(Representative(orb))<>[]);
    if prim then
        lgs:=Filtered(lgs, x->ClosureSet(tensor, AsSet(Representative(x)))=[1..OrderOfTensor(tensor)]);
    fi;
    return lgs;
end);

InstallMethod(ActionOfCocoOrbit,
        "for all J-good set orbits",
        [IsJGoodSetOrbit],
function(orb)
    return OnJGoodSets;
end);

COCOInfoGSSize:=10;
InstallMethod(AllJGoodSetOrbits,
        "for iterators of good set candidates",
        [IsIteratorOfPartialGoodSetOrbits and IsPartialGoodSetOrbitIterRep],
function(iter)
    local res,T,gens,stab,grp,gs;
    
    if IsDoneIterator(iter) then
        return [];
    fi;
    
    res:=[];
    T:=TensorOfPartialGoodSet(iter!.state.cand);
    grp:=Source(iter!.state.act);
    
    while not IsDoneIterator(iter) do
        if Length(iter!.state.M)<=COCOInfoGSSize then
            Info(InfoCOCO,1,iter!.state.M,"\n");
        fi;
        
        if IsCompletePartialGoodSet(iter!.state.cand) then
            gs:=JGoodSetFromPartialGoodSet(iter!.state.cand);
            if gs <> fail then 
                gens:=ShallowCopy(iter!.state.SM.generators);
                stab:=Group(PreImagesSet(iter!.state.act,gens),());            
                Add(res, JGoodSetOrbit(grp,gs, stab));
                Info(InfoCOCO,1,"*");
            fi;
        fi;
        
        NextIterator(iter);
    od;
    return res;
end);

InstallMethod(ViewString,
        "for J-good set orbits",
        [IsJGoodSetOrbit],
function(x)
    local res;
    
    res:=("<");
    if IsMutable(x) then
        Append(res, "mutable ");
    fi;
    return Concatenation(res, "JGoodSetOrbit of length ", String(Size(x)), ">");
end);

InstallMethod(ConstructorOfCocoOrbit,
        "for all partial fusion orbits",
        [IsJGoodSetOrbit],
function(orb)
    return JGoodSetOrbit;
end);

InstallMethod(ConstructorOfCocoOrbitNC,
        "for all partial fusion orbits",
        [IsJGoodSetOrbit],
function(orb)
    return JGoodSetOrbitNC;
end);
