DeclareRepresentation("IsRegularSetRep",
        IsAttributeStoringRep,
        [ "cgr",                # the rainbow over which the regular set "lives"
          "set"                 # the regular set of colors of <cgr>
        ]);


InstallMethod(RegularSetsFamily,
    "for structure constants tensors",
	[IsColorGraph],
function(cgr)
   local fam;
   fam:=NewFamily("RegularSetsFam", IsRegularSet);
   return fam;
end);

InstallGlobalFunction(BuildRegularSet,
function(arg)
   local cgr,set,part,res;

   cgr:=arg[1];
   set:=arg[2];

   res:=rec(
            cgr:=cgr,
            set:=Immutable(set));
   return Objectify(NewType(RegularSetsFamily(cgr), IsRegularSet and IsRegularSetRep), res);
end);


InstallMethod(RainbowOfRegularSet,
        "for regular sets in RegularSetRep",
        [IsRegularSet and IsRegularSetRep],
function(gs)
   return gs!.cgr;
end);


InstallOtherMethod(AsSet,
        "for regular sets in RegularSetRep",
        [IsRegularSet and IsRegularSetRep],
function(gs)
  return gs!.set;
end);

InstallOtherMethod(Length,
        "for regular sets",
        [IsRegularSet],
function(gs)
    return Length(AsSet(gs));
end);

InstallOtherMethod(\<,
        "for regular sets",
        IsIdenticalObj,
        [IsRegularSet,IsRegularSet],
function(gs1,gs2)
    if Length(gs1)<>Length(gs2) then
        return Length(gs1)<Length(gs2);
    else
        return AsSet(gs1)<AsSet(gs2);
    fi;
end);

InstallOtherMethod(\=,
        "for regular sets",
        IsIdenticalObj,
        [IsRegularSet,IsRegularSet],
function(gs1,gs2)
    return AsSet(gs1)=AsSet(gs2);
end);

# <g> must be from Aut(<gs!.tensor>)
InstallMethod(OnRegularSets,
        "for regular sets in RegularSetRep",
        [IsRegularSet and IsRegularSetRep, IsPerm],
function(gs, g)
    local res;
   res:=rec(
            cgr:=gs!.cgr,
            set:=MakeImmutable(OnSets(gs!.set,g)));
   return Objectify(NewType(RegularSetsFamily(gs!.cgr), IsRegularSet and IsRegularSetRep), res);
end);

InstallOtherMethod(Size,
        "for Regular sets in RegularSetRep",
        [IsRegularSet and IsRegularSetRep],
function(gs)
    return Size(gs!.set);
end);

InstallMethod(ViewString,
        "for regular set orbits",
        [IsRegularSet and IsRegularSetRep],
function(x) 
    return Concatenation("<", "RegularSet ", String(AsSet(x)), ">");
end);


InstallMethod(RegularSetOrbitsFamilyOp,
        "for a color graph  and a permutation group",
        [IsColorGraph, IsPermGroup],
function(cgr,g)
    return NewFamily("RegularSetOrbitsFam", IsRegularSetOrbit);
end);


InstallGlobalFunction(RegularSetOrbitNC,
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
   return Objectify(NewType(RegularSetOrbitsFamily(RainbowOfRegularSet(gs),group), IsRegularSetOrbit and IsCocoOrbitRep), res);
end);

InstallGlobalFunction(RegularSetOrbit,
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


    return RegularSetOrbitNC(group, OnRegularSets(gs,can[1]), nstab^can[1]);
end);

InstallMethod(OnCocoOrbits,
        "for all regular set orbits",
        [IsRegularSetOrbit, IsPerm],
function(gsorb,perm)
    local   grp,  gs,  stab,  ngs,  ngrp,  nstab;
    
    if perm=() then
        return gsorb;
    fi;
    
    grp:=UnderlyingGroupOfCocoOrbit(gsorb);
    gs:=CanonicalRepresentativeOfCocoOrbit(gsorb);
    stab:=StabilizerOfCanonicalRepresentative(gsorb);

    ngs:=OnRegularSets(gs,perm);
    return RegularSetOrbit(grp,ngs,Stabilizer(grp,AsSet(ngs),OnTuples),FamilyObj(gsorb));
end);

# InstallMethod(SubOrbitsOfCocoOrbit,
#         "for all regular set orbits",
#         [IsPermGroup, IsRegularSetOrbit],
# function(grp,gsorb)
#     local   ug,  cosreps,  stab,  gs,  ngs;


#     ug:=UnderlyingGroupOfCocoOrbit(gsorb);

#     if not IsSubgroup(ug,grp) then
#         Error("SubOrbitsOfCocoOrbit: The given group is not a subgroup of the underlying group of the orbit!");
#     fi;
#     stab:=StabilizerOfCanonicalRepresentative(gsorb);
#     cosreps:=List(DoubleCosetRepsAndSizes(ug,stab,grp), x->x[1]); 
#     gs:=CanonicalRepresentativeOfCocoOrbit(gsorb);
#     ngs:=RegularSetOrbitNC(grp,gs, Intersection(stab,grp));

#     return List(cosreps, x->OnCocoOrbits(ngs,x));
# end);


# InstallMethod(SubOrbitsWithInvariantPropertyOfCocoOrbit,
#         "for regular set orbits",
#         [IsPermGroup, IsRegularSetOrbit, IsFunction],
# function(grp,gsorb,func)
#     local  ug, stab, gs, cosreps, ngs, res, cr,i,signs;

#     ug:=UnderlyingGroupOfCocoOrbit(gsorb);

#     if not IsSubgroup(ug,grp) then
#         Error("SubOrbitsWithInvariantPropertyOfCocoOrbit: The given group is not a subgroup of the underlying group of the orbit!");
#     fi;
    
#     stab:=StabilizerOfCanonicalRepresentative(gsorb);
#     gs:=CanonicalRepresentativeOfCocoOrbit(gsorb);
#     if not IsTrivial(grp) then  
#         if Size(grp)>10  then
#             COCOPrint("***\t",Size(ug),"\t",Size(stab),"\t",Size(grp),"\t\c");
            
#             cosreps:=List(DoubleCosetRepsAndSizes(ug,stab,grp), x->x[1]);
#             COCOPrint(Length(cosreps),"\n");
                      
#             ngs:=RegularSetOrbitNC(grp,gs, Intersection(stab,grp));
#             res:=List(cosreps, x->OnCocoOrbits(ngs,x));
#             return Filtered(res, x->func(CanonicalRepresentativeOfCocoOrbit(x)));
#         else
#             cosreps:=RightTransversal(ug,stab);
#             ngs:=RegularSetOrbitNC(grp,gs, Intersection(stab,grp));
#             res:=[];
# #            COCOPrint(Index(ug,stab),"\n");
            
            
#             i:=0;signs:=["\b-","\b\\","\b|","\b/"];
#             COCOPrint(" \c");

        
#             for cr in cosreps do 
#                 if i mod COCORotorMod = 0 then
#                     COCOPrint(signs[i/COCORotorMod+1],"\c");
#                 fi;
        
#                 i:=(i+1) mod (4*COCORotorMod);
                
#                 if func(OnRegularSets(Representative(ngs), cr)) then 
#                     AddSet(res, OnCocoOrbits(ngs,cr));
#                 fi;
#             od;
#             COCOPrint("\b");
#         fi;
#     else
#         cosreps:=RightTransversal(ug,stab);
#         res:=[];
        
#         i:=0;signs:=["\b-","\b\\","\b|","\b/"];
#         COCOPrint(" \c");

        
#         for cr in cosreps do 
#             if i mod COCORotorMod = 0 then
#                 COCOPrint(signs[i/COCORotorMod+1],"\c");
#             fi;
        
#             i:=(i+1) mod (4*COCORotorMod);
            
#             ngs:=OnRegularSets(gs,cr);
#             if func(ngs) then
#                 ngs:=RegularSetOrbitNC(grp,ngs,Group(()));
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


InstallMethod(HomogeneousSymRegularSetOrbits,
        "for WL-stable color graphs",
        [IsColorGraph and IsWLStableColorGraph],
function(cgr)
    local  tensor, iter, allgsorb;
    
    tensor:=StructureConstantsOfColorGraph(cgr);
    
    iter:=IteratorOfPartialGoodSetOrbits(AutomorphismGroup(tensor), EmptySymPartialRegularSet(cgr));
    allgsorb:=AllRegularSetOrbits(iter);
    
    return Filtered(allgsorb,orb->AsSet(Representative(orb))<>[]);
end);

InstallMethod(HomogeneousAsymRegularSetOrbits,
        "for WL-stable color graphs",
        [IsColorGraph and IsWLStableColorGraph],
function(cgr)
    local tensor,agsorbs,aaut;
    
    tensor:=StructureConstantsOfColorGraph(cgr);
    
    aaut:=AutomorphismGroup(tensor);
    aaut:=ClosureGroup(aaut,[Mates(tensor)]);
    
    agsorbs:=AllRegularSetOrbits(IteratorOfPartialGoodSetOrbits(aaut,EmptyAsymPartialRegularSet(cgr)));
    agsorbs:=Filtered(agsorbs, orb->AsSet(Representative(orb))<>[]);
    
    return Union(List(agsorbs, orb->SubOrbitsOfCocoOrbit(AutomorphismGroup(tensor),orb)));    
end);

InstallMethod(HomogeneousRegularSetOrbits,
        "for WL-stable color graphs",
        [IsColorGraph and IsWLStableColorGraph],
function(cgr)
    local tensor,lgs,sym,prim;
    
    tensor:=StructureConstantsOfColorGraph(cgr);
    
    sym:=ValueOption("sym");
    if sym=fail then
        sym:=false;
    fi;
    prim:=ValueOption("prim");
    if prim=fail then
        prim:=false;
    fi;
    lgs:=Set(HomogeneousSymRegularSetOrbits(cgr));
    if not sym then
        lgs:=Union(lgs, HomogeneousAsymRegularSetOrbits(cgr));
    fi;
    if prim then
        lgs:=Filtered(lgs, x->ClosureSet(tensor, AsSet(Representative(x)))=[1..OrderOfTensor(tensor)]);
    fi;
    
    return lgs;
end);

InstallMethod(ActionOfCocoOrbit,
        "for all regular set orbits",
        [IsRegularSetOrbit],
function(orb)
    return OnRegularSets;
end);

InstallMethod(ViewString,
        "for regular set orbits",
        [IsRegularSetOrbit],
function(x)
    local res;
    
    res:=("<");
    if IsMutable(x) then
        Append(res, "mutable ");
    fi;
    return Concatenation(res, "RegularSetOrbit of length ", String(Size(x)), ">");
end);

InstallMethod(ConstructorOfCocoOrbit,
        "for all regular set orbits",
        [IsRegularSetOrbit],
function(orb)
    return RegularSetOrbit;
end);

InstallMethod(ConstructorOfCocoOrbitNC,
        "for all regular set orbits",
        [IsRegularSetOrbit],
function(orb)
    return RegularSetOrbitNC;
end);
