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

InstallMethod(StableSetFromPartialStableSet,
    "for partial regular sets in PartialRegularSetRep",
    [IsPartialRegularSet and IsPartialRegularSetRep],
function(cand)
    return BuildRegularSet(cand!.cgr, cand!.set);
end);


InstallMethod(UnderlyingCgrOfRegularSet,
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
   return Objectify(NewType(RegularSetOrbitsFamily(UnderlyingCgrOfRegularSet(gs),group), IsRegularSetOrbit and IsCocoOrbitRep), res);
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



InstallMethod(HomogeneousSymRegularSetOrbits,
        "for stable rainbows",
        [IsColorGraph and IsRainbow and IsStableRainbow],
function(cgr)
    local  g, iter, allgsorb;
    
    g:=RAlgebraicAutomorphismGroup(cgr);
    
    
    iter:=IteratorOfPartialStableSetOrbits(g, EmptySymPartialRegularSet(cgr));
    allgsorb:=AllStableSetOrbits(iter);
    
    return Filtered(allgsorb,orb->AsSet(Representative(orb))<>[]);
end);

InstallOtherMethod(HomogeneousSymRegularSetOrbits,
        "for a stable rainbow and a permutation group",
        [IsColorGraph and IsRainbow and IsStableRainbow, IsPermGroup],
function(cgr,g)
    local  iter, allgsorb;
    
    iter:=IteratorOfPartialStableSetOrbits(g, EmptySymPartialRegularSet(cgr));
    allgsorb:=AllStableSetOrbits(iter);
    
    return Filtered(allgsorb,orb->AsSet(Representative(orb))<>[]);
end);

InstallMethod(HomogeneousAsymRegularSetOrbits,
        "for a stable rainbow",
        [IsColorGraph and IsRainbow and IsStableRainbow],
function(cgr)
    local  g, tg, agsorbs;
    
    g:=RAlgebraicAutomorphismGroup(cgr);
    
    tg:=ClosureGroup(g,[ColorMates(cgr)]);
    
    agsorbs:=AllStableSetOrbits(IteratorOfPartialStableSetOrbits(tg,EmptyAsymPartialRegularSet(cgr)));
    agsorbs:=Filtered(agsorbs, orb->AsSet(Representative(orb))<>[]);
    
    return Union(List(agsorbs, orb->SubOrbitsOfCocoOrbit(g,orb)));    
end);

InstallOtherMethod(HomogeneousAsymRegularSetOrbits,
        "for a stable rainbow and a permutation group",
        [IsColorGraph and IsRainbow and IsStableRainbow,IsPermGroup],
function(cgr,g)
    local  tg, agsorbs;
    
    
    tg:=ClosureGroup(g,[ColorMates(cgr)]);
    
    agsorbs:=AllStableSetOrbits(IteratorOfPartialStableSetOrbits(tg,EmptyAsymPartialRegularSet(cgr)));
    agsorbs:=Filtered(agsorbs, orb->AsSet(Representative(orb))<>[]);
    
    return Union(List(agsorbs, orb->SubOrbitsOfCocoOrbit(g,orb)));    
end);

InstallMethod(HomogeneousRegularSetOrbits,
        "for WL-stable color graphs",
        [IsColorGraph and IsRainbow and IsStableRainbow],
function(cgr)
    local g,lgs,sym,prim;
    
    
    sym:=ValueOption("sym");
    if sym=fail then
        sym:=false;
    fi;
    # prim:=ValueOption("prim");
    # if prim=fail then
    #     prim:=false;
    # fi;
    lgs:=Set(HomogeneousSymRegularSetOrbits(cgr));
    if not sym then
        lgs:=Union(lgs, HomogeneousAsymRegularSetOrbits(cgr));
    fi;
    # if prim then
    #     lgs:=Filtered(lgs, x->ClosureSet(tensor, AsSet(Representative(x)))=[1..OrderOfTensor(tensor)]);
    # fi;
    
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
