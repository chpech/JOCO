DeclareRepresentation("IsHadamardSetRep",
        IsAttributeStoringRep,
        [ "cgr",                # the rainbow over which the Hadamard set "lives"
          "set"                 # the Hadamard set of colors of <cgr>
        ]);

InstallMethod(HadamardSetsFamily,
    "for color graphs",
	[IsColorGraph],
function(cgr)
   local fam;
   fam:=NewFamily("HadamardSetsFam", IsHadamardSet);
   return fam;
end);

InstallMethod(HadamardSet,
"for a color graph and a set",              
[ IsColorGraph, IsList ],
function(cgr, set)
   local res;
    
    
   res:=rec(
            cgr:=cgr,
            set:=Immutable(set));
   return Objectify(NewType(HadamardSetsFamily(cgr), IsHadamardSetRep), res);
end);

InstallMethod(StableSetFromPartialStableSet,
"for partial Hadamard sets in PartialHadamardSetRep",
[IsPartialHadamardSet and IsPartialHadamardSetRep],
function(cand)
    return HadamardSet( cand!.cgr, cand!.set);
end);

InstallMethod(UnderlyingCgrOfHadamardSet,
        "for Hadamard sets in hadamardSetRep",
        [IsHadamardSet and IsHadamardSetRep],
function(gs)
   return gs!.cgr;
end);

InstallOtherMethod(AsSet,
        "for Hadamard sets in HadamardSetRep",
        [IsHadamardSet and IsHadamardSetRep],
function(gs)
  return gs!.set;
end);

InstallOtherMethod(Length,
        "for Hadamard sets",
        [IsHadamardSet],
function(gs)
    return Length(AsSet(gs));
end);

InstallOtherMethod(\<,
        "for Hadamard sets",
        IsIdenticalObj,
        [IsHadamardSet,IsHadamardSet],
function(gs1,gs2)
    if Length(gs1)<>Length(gs2) then
        return Length(gs1)<Length(gs2);
    else
        return AsSet(gs1)<AsSet(gs2);
    fi;
end);

InstallOtherMethod(\=,
        "for Hadamard sets",
        IsIdenticalObj,
        [IsHadamardSet,IsHadamardSet],
function(gs1,gs2)
    return AsSet(gs1)=AsSet(gs2);
end);

InstallMethod(OnHadamardSets,
        "for a Hadamard set in HadamardSetRep and a permutation",
        [IsHadamardSet and IsHadamardSetRep, IsPerm],
function(gs, g)
    return HadamardSet(gs!.cgr, MakeImmutable(OnSets(gs!.set,g)));
end);

InstallOtherMethod(Size,
        "for Hadamard sets in HadamardSetRep",
        [IsHadamardSet and IsHadamardSetRep],
function(gs)
    return Size(gs!.set);
end);

InstallMethod(ViewString,
        "for Hadamard sets",
        [IsHadamardSet],
function(x) 
    return Concatenation("<HadamardSet ", String(AsSet(x)), ">");
end);

InstallMethod(HadamardSetOrbitsFamilyOp,
        "for a color graph  and a permutation group",
        [IsColorGraph, IsPermGroup],
function(cgr,g)
    return NewFamily("HadamardSetOrbitsFam", IsHadamardSetOrbit);
end);

InstallGlobalFunction(HadamardSetOrbitNC,
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
   return Objectify(NewType(HadamardSetOrbitsFamily(UnderlyingCgrOfHadamardSet(gs),group), IsHadamardSetOrbit and IsCocoOrbitRep), res);
end);

InstallGlobalFunction(HadamardSetOrbit,
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


    return HadamardSetOrbitNC(group, OnHadamardSets(gs,can[1]), nstab^can[1]);
end);

InstallMethod(OnCocoOrbits,
        "for all Hadamard set orbits",
        [IsHadamardSetOrbit, IsPerm],
function(gsorb,perm)
    local   grp,  gs,  stab,  ngs,  ngrp,  nstab;
    
    if perm=() then
        return gsorb;
    fi;
    
    grp:=UnderlyingGroupOfCocoOrbit(gsorb);
    gs:=CanonicalRepresentativeOfCocoOrbit(gsorb);
    stab:=StabilizerOfCanonicalRepresentative(gsorb);

    ngs:=OnHadamardSets(gs,perm);
    return HadamardSetOrbit(grp,ngs,Stabilizer(grp,AsSet(ngs),OnTuples),FamilyObj(gsorb));
end);

InstallMethod(HadamardSetOrbits,
        "for J-stable color graphs",
        [IsColorGraph and IsJStableColorGraph],
function(cgr)
    local  g, iter, allgsorb;
    
    g:=JAlgebraicAutomorphismGroup(cgr);
    
    
    iter:=IteratorOfPartialStableSetOrbits(g, EmptyPartialHadamardSet(cgr));
    allgsorb:=AllStableSetOrbits(iter);
    
    return allgsorb;
    
    return Filtered(allgsorb,orb->AsSet(Representative(orb))<>[]);
end);

InstallOtherMethod(HadamardSetOrbits,
        "for a J-stable color graph and a permutation group",
        [IsColorGraph and IsJStableColorGraph, IsPermGroup],
function(cgr,g)
    local  iter, allgsorb;
    
    iter:=IteratorOfPartialStableSetOrbits(g, EmptyPartialHadamardSet(cgr));
    allgsorb:=AllStableSetOrbits(iter);
    
    return allgsorb;
    
    return Filtered(allgsorb,orb->AsSet(Representative(orb))<>[]);
end);

InstallMethod(ActionOfCocoOrbit,
        "for all Hadamard set orbits",
        [IsHadamardSetOrbit],
function(orb)
    return OnHadamardSets;
end);

InstallMethod(ViewString,
        "for Hadamard set orbits",
        [IsHadamardSetOrbit],
function(x)
    local res;
    
    res:=("<");
    if IsMutable(x) then
        Append(res, "mutable ");
    fi;
    return Concatenation(res, "HadamardSetOrbit of length ", String(Size(x)), ">");
end);

InstallMethod(ConstructorOfCocoOrbit,
        "for all Hadamard set orbits",
        [IsHadamardSetOrbit],
function(orb)
    return HadamardSetOrbit;
end);

InstallMethod(ConstructorOfCocoOrbitNC,
        "for all Hadamard set orbits",
        [IsHadamardSetOrbit],
function(orb)
    return HadamardSetOrbitNC;
end);

