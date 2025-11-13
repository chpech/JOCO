InstallMethod(CHadamardSet,
"for a color graph and a set",              
[ IsColorGraph, IsList ],
function(cgr, set)
   local res;
    
    
   res:=rec(
            cgr:=cgr,
            set:=Immutable(set));
   return Objectify(NewType(CHadamardSetsFamily(cgr), IsColorSetRep), res);
end);

InstallMethod(CHadamardSetsFamily,
"for a color graph",
[IsColorGraph],
function(cgr)
   local fam;
   fam:=NewFamily("CHadamardSetsFam", IsCHadamardSet);
   return fam;
end);

InstallMethod(StableSetFromPartialStableSet,
"for a partial CHadamard set in PartialCHadamardSetRep",
[IsPartialCHadamardSet and IsPartialCHadamardSetRep],
function(cand)
    return CHadamardSet( cand!.cgr, cand!.set);
end);

InstallMethod(OnCHadamardSets,
"for a CHadamard set in CHadamardSetRep and a permutation",
[IsCHadamardSet and IsColorSetRep, IsPerm],
function(gs, g)
    return CHadamardSet(gs!.cgr, MakeImmutable(OnSets(gs!.set,g)));
end);


InstallMethod(ViewString,
"for a CHadamard set",
[IsCHadamardSet],
function(x) 
    return Concatenation("<CHadamardSet: ", String(AsSet(x)), ">");
end);

InstallMethod(CHadamardSetOrbitsFamilyOp,
"for a color graph  and a permutation group",
[IsColorGraph, IsPermGroup],
function(cgr,g)
    return NewFamily("CHadamardSetOrbitsFam", IsCHadamardSetOrbit);
end);

InstallGlobalFunction(CHadamardSetOrbitNC,
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
   return Objectify(NewType(CHadamardSetOrbitsFamily(UnderlyingCgrOfColorSet(gs),group), IsCHadamardSetOrbit and IsCocoOrbitRep), res);
end);

InstallGlobalFunction(CHadamardSetOrbit,
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


    return CHadamardSetOrbitNC(group, OnCHadamardSets(gs,can[1]), nstab^can[1]);
end);

InstallMethod(OnCocoOrbits,
"for a CHadamard set orbit and a permutation",
[IsCHadamardSetOrbit, IsPerm],
function(gsorb,perm)
    local   grp,  gs,  stab,  ngs,  ngrp,  nstab;
    
    if perm=() then
        return gsorb;
    fi;
    
    grp:=UnderlyingGroupOfCocoOrbit(gsorb);
    gs:=CanonicalRepresentativeOfCocoOrbit(gsorb);
    stab:=StabilizerOfCanonicalRepresentative(gsorb);

    ngs:=OnCHadamardSets(gs,perm);
    return CHadamardSetOrbit(grp,ngs,Stabilizer(grp,AsSet(ngs),OnTuples),FamilyObj(gsorb));
end);

InstallMethod(CHadamardSetOrbits,
"for a J-stable color graph",
[IsColorGraph and IsJStableColorGraph],
function(cgr)
    local  g, iter, allgsorb;
    
    g:=JAlgebraicAutomorphismGroup(cgr);
    
    iter:=IteratorOfPartialStableSetOrbits(g, EmptyPartialCHadamardSet(cgr));
    allgsorb:=AllStableSetOrbits(iter);
    
    return allgsorb;
    
    return Filtered(allgsorb,orb->AsSet(Representative(orb))<>[]);
end);

InstallOtherMethod(CHadamardSetOrbits,
"for a J-stable color graph and a permutation group",
[IsColorGraph and IsJStableColorGraph, IsPermGroup],
function(cgr,g)
    local  iter, allgsorb;
    
    iter:=IteratorOfPartialStableSetOrbits(g, EmptyPartialCHadamardSet(cgr));
    allgsorb:=AllStableSetOrbits(iter);
    
    return allgsorb;
    
    return Filtered(allgsorb,orb->AsSet(Representative(orb))<>[]);
end);

InstallMethod(ActionOfCocoOrbit,
"for a CHadamard set orbit",
[IsCHadamardSetOrbit],
function(orb)
    return OnCHadamardSets;
end);

InstallMethod(ViewString,
"for a CHadamard set orbit",
[IsCHadamardSetOrbit],
function(x)
    local res;
    
    res:=("<");
    if IsMutable(x) then
        Append(res, "mutable ");
    fi;
    return Concatenation(res, "CHadamardSetOrbit of length ", String(Size(x)), ">");
end);

InstallMethod(ConstructorOfCocoOrbit,
"for a CHadamard set orbit",
[IsCHadamardSetOrbit],
function(orb)
    return CHadamardSetOrbit;
end);

InstallMethod(ConstructorOfCocoOrbitNC,
"for a CHadamard set orbit",
[IsCHadamardSetOrbit],
function(orb)
    return CHadamardSetOrbitNC;
end);

