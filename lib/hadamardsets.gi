InstallMethod(HadamardSet,
"for a color graph and a set",              
[ IsColorGraph, IsList ],
function(cgr, set)
   local res;
    
    
   res:=rec(
            cgr:=cgr,
            set:=Immutable(set));
   return Objectify(NewType(HadamardSetsFamily(cgr), IsColorSetRep), res);
end);

InstallMethod(HadamardSetsFamily,
"for a color graph",
[IsColorGraph],
function(cgr)
   local fam;
   fam:=NewFamily("HadamardSetsFam", IsHadamardSet);
   return fam;
end);

InstallMethod(StableSetFromPartialStableSet,
"for a partial Hadamard set in PartialHadamardSetRep",
[IsPartialHadamardSet and IsPartialHadamardSetRep],
function(cand)
    return HadamardSet( cand!.cgr, cand!.set);
end);

InstallMethod(OnHadamardSets,
"for a Hadamard set in HadamardSetRep and a permutation",
[IsHadamardSet and IsColorSetRep, IsPerm],
function(gs, g)
    return HadamardSet(gs!.cgr, MakeImmutable(OnSets(gs!.set,g)));
end);


InstallMethod(ViewString,
"for a Hadamard set",
[IsHadamardSet],
function(x) 
    return Concatenation("<HadamardSet: ", String(AsSet(x)), ">");
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
   return Objectify(NewType(HadamardSetOrbitsFamily(UnderlyingCgrOfColorSet(gs),group), IsHadamardSetOrbit and IsCocoOrbitRep), res);
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
"for a Hadamard set orbit and a permutation",
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
"for a J-stable color graph",
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
"for a Hadamard set orbit",
[IsHadamardSetOrbit],
function(orb)
    return OnHadamardSets;
end);

InstallMethod(ViewString,
"for a Hadamard set orbit",
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
"for a Hadamard set orbit",
[IsHadamardSetOrbit],
function(orb)
    return HadamardSetOrbit;
end);

InstallMethod(ConstructorOfCocoOrbitNC,
"for a Hadamard set orbit",
[IsHadamardSetOrbit],
function(orb)
    return HadamardSetOrbitNC;
end);

