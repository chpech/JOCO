
InstallMethod(RegularSetsFamily,
    "for color graphs",
	[IsColorGraph],
function(cgr)
   local fam;
   fam:=NewFamily("RegularSetsFam", IsRegularSet);
   return fam;
end);

InstallMethod(RegularSet,
"for Regular sets",              
[ IsRegularSet, IsColorGraph, IsList ],
function(filter, cgr, set)
   local res;
    
    res:=rec(
            cgr:=cgr,
            set:=Immutable(set));
   return Objectify(NewType(RegularSetsFamily(cgr), filter and IsColorSetRep), res);
end);


InstallMethod(StableSetFromPartialStableSet,
    "for partial regular sets in PartialRegularSetRep",
    [IsPartialRegularSet and IsPartialRegularSetRep],
function(cand)
    return RegularSet( IsRegularSet, cand!.cgr, cand!.set);
end);


InstallMethod(OnRegularSets,
        "for a regular set in RegularSetRep and a permutation",
        [IsRegularSet and IsColorSetRep, IsPerm],
function(gs, g)
    return RegularSet(IsRegularSet, gs!.cgr, MakeImmutable(OnSets(gs!.set,g)));
end);

InstallMethod(ViewString,
        "for regular sets",
        [IsRegularSet],
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
    
    Assert(1, res.stab = Stabilizer(res.group, AsSet(res.rep),OnSets));
    
   return Objectify(NewType(RegularSetOrbitsFamily(UnderlyingCgrOfColorSet(gs),group), IsRegularSetOrbit and IsCocoOrbitRep), res);
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



InstallMethod(SymmetricRegularSetOrbits,
        "for stable rainbows",
        [IsColorGraph and IsRainbow and IsStableRainbow],
function(cgr)
    local  g, iter, allgsorb;
    
    g:=RAlgebraicAutomorphismGroup(cgr);
    
    
    iter:=IteratorOfPartialStableSetOrbits(g, EmptySymPartialRegularSet(cgr));
    allgsorb:=AllStableSetOrbits(iter);
    
    return Filtered(allgsorb,orb->AsSet(Representative(orb))<>[]);
end);

InstallOtherMethod(SymmetricRegularSetOrbits,
        "for a stable rainbow and a permutation group",
        [IsColorGraph and IsRainbow and IsStableRainbow, IsPermGroup],
function(cgr,g)
    local  iter, allgsorb;
    
    iter:=IteratorOfPartialStableSetOrbits(g, EmptySymPartialRegularSet(cgr));
    allgsorb:=AllStableSetOrbits(iter);
    
    return Filtered(allgsorb,orb->AsSet(Representative(orb))<>[]);
end);

InstallMethod(AsymmetricRegularSetOrbits,
        "for a stable rainbow",
        [IsColorGraph and IsRainbow and IsStableRainbow],
function(cgr)
    local  g, tg, agsorbs;
    
    g:=RAlgebraicAutomorphismGroup(cgr);
    
    tg:=ClosureGroup(g,[ColorMates(cgr)]);
    
    agsorbs:=AllStableSetOrbits(IteratorOfPartialStableSetOrbits(tg,EmptyAsymPartialRegularSet(cgr)));
    agsorbs:=Filtered(agsorbs, orb->AsSet(Representative(orb))<>[]);
    
#    Error("brk");
    
    
    return Union(List(agsorbs, orb->SubOrbitsOfCocoOrbit(g,orb)));    
end);

InstallOtherMethod(AsymmetricRegularSetOrbits,
        "for a stable rainbow and a permutation group",
        [IsColorGraph and IsRainbow and IsStableRainbow,IsPermGroup],
function(cgr,g)
    local  tg, agsorbs;
    
    
    tg:=ClosureGroup(g,[ColorMates(cgr)]);
    
    agsorbs:=AllStableSetOrbits(IteratorOfPartialStableSetOrbits(tg,EmptyAsymPartialRegularSet(cgr)));
    agsorbs:=Filtered(agsorbs, orb->AsSet(Representative(orb))<>[]);
    
    return Union(List(agsorbs, orb->SubOrbitsOfCocoOrbit(g,orb)));    
end);

InstallMethod(RegularSetOrbits,
"for stable rainbows",
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
    lgs:=Set(SymmetricRegularSetOrbits(cgr));
    if not sym then
        lgs:=Union(lgs, AsymmetricRegularSetOrbits(cgr));
    fi;
    # if prim then
    #     lgs:=Filtered(lgs, x->ClosureSet(tensor, AsSet(Representative(x)))=[1..OrderOfTensor(tensor)]);
    # fi;
    
    return lgs;
end);

InstallOtherMethod(RegularSetOrbits,
"for a stable rainbow and a permutation group",
[IsColorGraph and IsRainbow and IsStableRainbow, IsPermGroup],
function(cgr,g)
    local lgs,sym,prim;
    
    
    sym:=ValueOption("sym");
    if sym=fail then
        sym:=false;
    fi;
    # prim:=ValueOption("prim");
    # if prim=fail then
    #     prim:=false;
    # fi;
    lgs:=Set(SymmetricRegularSetOrbits(cgr,g));
    if not sym then
        lgs:=Union(lgs, AsymmetricRegularSetOrbits(cgr,g));
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
