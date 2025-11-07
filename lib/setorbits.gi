InstallGlobalFunction(SetOrbitNC,
function(arg)
    local  grp, set, stab, res, group, rep,fam;
    
    grp:=arg[1];
    set:=arg[2];
    if Length(arg)=2 then
        stab:=Stabilizer(grp,AsSet(set), OnSets);
    else
        stab:=arg[3];
    fi;
    fam:=SetOrbitsFamily(grp);
    
    Assert(1, stab=Stabilizer(grp,Set(set),OnSets));
    
    res:=rec(
             group:=grp,
             rep:=set,
             stab:=stab);
   return Objectify(NewType(fam, IsSetOrbit and IsCocoOrbitRep),res);
end);

InstallGlobalFunction(SetOrbit,
function(arg)
    local  grp,set,stab,fam, can, nstab;
    
    grp:=arg[1];
    set:=arg[2];
    if Length(arg)=2 then
        stab:=Stabilizer(grp,AsSet(set), OnSets);
    else
        stab:=arg[3];
    fi;
    
    Assert(1,IsSubgroup(Stabilizer(grp,set,OnSets), stab));
    
    
    fam:=SetOrbitsFamily(grp);

    can:=SetCanonifiers(Stbc(grp), Stbc(stab), set);
    nstab:=ClosureGroup(stab, List(can, x->can[1]*x^(-1)));

    Assert(1, Stabilizer(grp, OnSets(set,can[1]),OnSets) = nstab^can[1]);
    
    return SetOrbitNC(grp, OnSets(set,can[1]), nstab^can[1],fam);
end);

InstallMethod(OnCocoOrbits,
        "for all set orbits",
        [IsSetOrbit, IsPerm],
function(sorb,perm)
    local  grp, set, stab, nset;
    
    if perm=() then
        return sorb;
    fi;
    
    grp:=UnderlyingGroupOfCocoOrbit(sorb);
    set:=CanonicalRepresentativeOfCocoOrbit(sorb);
    stab:=StabilizerOfCanonicalRepresentative(sorb);

    nset:=OnSets(set,perm);
    return SetOrbit(grp,nset,Stabilizer(grp,nset,OnTuples),FamilyObj(sorb));
end);


InstallMethod(\<,
        "for set orbits",
        IsIdenticalObj,
        [IsSetOrbit,IsSetOrbit],
function(orb1,orb2)
    local s1,s2;
    s1:=CanonicalRepresentativeOfCocoOrbit(orb1);
    s2:=CanonicalRepresentativeOfCocoOrbit(orb2);
    if Length(s1) <> Length(s2) then
        return Length(s1) < Length(s2);
    fi;
    
    return s1 < s2;
end);

DeclareRepresentation( "IsSetOrbitIterRep", IsComponentObjectRep, ["G","domain","sizes","state"]);

SetOrbitIteratorsFamily := NewFamily("SetOrbitIteratorsFamily", 
                                      IsIteratorOfSetOrbits);

InstallMethod(IteratorOfSetOrbits,
    "for a permutation group, a positive integer, and a set of positive integers",
    [IsPermGroup, IsList, IsList],
function(grp, domain, sizes)
    local S,SM,state,act;
        
    
    if ForAny(GeneratorsOfGroup(grp), g->OnSets(domain,g)<>domain) then
        ErrorNoReturn("<domain> is not invariant under <grp>!");
    fi;
    
    S:=Stbc(grp);
    SM:=StbcCopy(S);
    
    state:=rec( S:=S,        
                SM:=SM,            
                M:=[],
                domain:=domain,
                maxsize:=Maximum(sizes),
                orbreps:=StbcMinimalOrbitReps(SM,domain),
                orbidx:=1,
                linkback:=fail
               );
    
    return Objectify(NewType(SetOrbitIteratorsFamily,
                   IsIteratorOfSetOrbits and IsSetOrbitIterRep and IsMutable),
                     rec(G:=grp,
                         domain:=domain,
                         sizes:=Set(sizes),
                         state:=state));
end);

InstallMethod( NextIterator,
        "for iterators of partial good set orbits",
        [IsIteratorOfSetOrbits and IsSetOrbitIterRep and IsMutable],
function(iter)
    local NextState, res,cand;
        
    NextState:=function(state)
        local pt, SC, ncand, nextstate,ndomain;
        
        if state=fail then 
            return fail; 
        fi;
        
        
        if Length(state.M) >= state.maxsize then
            return NextState(state.linkback);
        fi;
        
        if state.orbidx>Length(state.orbreps) then
            return NextState(state.linkback);
        fi;
        
        SC:=();
        
        repeat
            pt:=state.orbreps[state.orbidx];
            state.orbidx:=state.orbidx+1;
            SC:=CocoSetReducibilityTest(state.S,state.SM,state.M,pt);
        until not IsPerm(SC) or state.orbidx > Length(state.orbreps);
        
        if IsPerm(SC) then
            return NextState(state.linkback);
        fi;
        
        ndomain:=Filtered(state.domain,x->x>pt);
        
        nextstate:=rec(S:=state.S,
                       SM:=SC,
                       M:=Union(state.M,[pt]),
                       domain:=ndomain,
                       maxsize:=state.maxsize,
                       orbreps:=StbcMinimalOrbitReps(SC,ndomain),
                       orbidx:=1,
                       linkback:=state);
        return nextstate;
    end;
    
    
    while iter!.state<>fail and not Length(iter!.state.M) in iter!.sizes do
        iter!.state:=NextState(iter!.state);
    od;
    
    if iter!.state=fail then
        return fail;
    fi;
    
    res:=SetOrbitNC(iter!.G, iter!.state.M, StbcGroup(CopyStabChain(iter!.state.SM)));
    iter!.state:=NextState(iter!.state);
    
    return res;
end);

InstallMethod( IsDoneIterator,
        "for iterators of set orbits",
        [IsIteratorOfSetOrbits and IsSetOrbitIterRep],
function(iter)
    return iter!.state=fail;
end);


InstallMethod( RejectSetOrbit,
        "for an iterator of  set orbits",
        [IsIteratorOfSetOrbits and IsSetOrbitIterRep],
function(iter)
    local  state;
    
    if iter!.state=fail then
        return fail;
    fi;
    state:=iter!.state;
    
    while true do
        state:=state!.linkback;
        if state = fail then
            break;
        fi;
        if state.orbidx<=Length(state.orbreps) then
            break;
        fi;
    od;
    iter!.state:=state;
    NextIterator(iter);
    
    return iter;
end);

InstallMethod( ViewString,
        "for set orbit iterators",
        [IsIteratorOfSetOrbits and IsSetOrbitIterRep],
function(iter)
    if iter!.state=fail then
        return "<done set orbit iterator>";
    else
        return Concatenation("<set orbit iterator, current set ",
                             String(iter!.state.M), ">");
    fi;
end);         

InstallMethod( NextSetOrbit,
        "for an iterator of  set orbits",
        [IsIteratorOfSetOrbits and IsSetOrbitIterRep],
function(iter)               
    
    if iter!.state=fail then
        return fail;
    fi;
    return SetOrbitNC(iter!.G, iter!.state.M, StbcGroup(CopyStabChain(iter!.state.SM)));
end);


InstallMethod(ActionOfCocoOrbit,
        "for all set orbits",
        [IsSetOrbit],
function(orb)
    return OnSets;
end);


COCOInfoGSSize:=10;
InstallMethod(AllSetOrbitsFromIterator,
        "for iterators of set orbits",
        [IsIteratorOfSetOrbits and IsSetOrbitIterRep],
function(iter)
    local  res, grp, sorb;
    
    if IsDoneIterator(iter) then
        return [];
    fi;
    
    res:=[];
    grp:=iter!.G;
    
    Info(InfoJOCO,1,"Computing set orbits.\n");
    repeat
        sorb:=NextIterator(iter);
        if sorb<>fail then
            if Length(Representative(sorb))<=COCOInfoGSSize then
                Info(InfoJOCO,2,Representative(sorb),"\n");
            fi;
            Info(InfoJOCO,1,".");
            Add(res,sorb);
        fi;
    until IsDoneIterator(iter);
    Info(InfoJOCO,1,"\nDone computing set orbits.\n");
    return res;
end);


InstallMethod(SetOrbitsFamily,
    "for permutation groups",
	[IsPermGroup],
function(grp)
   local fam;
   fam:=NewFamily("SetOrbitsFam", IsSetOrbit);
   return fam;
end);


InstallMethod(ViewString,
        "for set orbits",
        [IsSetOrbit],
function(x)
    local res;
    
    res:=("<");
    if IsMutable(x) then
        Append(res, "mutable ");
    fi;
    return Concatenation(res, "SetOrbit of length ", String(Size(x)), ">");
end);


InstallMethod(ConstructorOfCocoOrbit,
        "for all set orbits",
        [IsSetOrbit],
function(orb)
    return SetOrbit;
end);

InstallMethod(ConstructorOfCocoOrbitNC,
        "for all set orbits",
        [IsSetOrbit],
function(orb)
    return SetOrbitNC;
end);





InstallGlobalFunction(NumberOrbitsPerm@JOCO,
function(cycle, degree)
    local i, j, k, index,
          lengths, numbers, totalLength,
          result;
    lengths := [];
    numbers := [];
    totalLength := 0;
    for i in [degree, degree-1 .. 2] do
        if IsBound(cycle[i-1]) then
            Add(lengths, i);
            Add(numbers, cycle[i-1]);
            totalLength := totalLength + i*cycle[i-1];
        fi;
    od;
    if totalLength < degree then
        Add(lengths, 1);
        Add(numbers, degree-totalLength);
    fi;
    result := 0*[1..degree];
    for i in Cartesian(List(numbers, x -> [0..x])) do
        index := Sum([1..Length(i)], x -> i[x]*lengths[x]);
        if index > 0 then
            result[index] := 
              result[index] +
              Product([1..Length(i)], x -> Binomial(numbers[x], i[x]));
        fi;
    od;
    return result;
end);

InstallOtherMethod(Size,
        "for iterators of set orbits",
        [IsIteratorOfSetOrbits and IsSetOrbitIterRep],
function(iter)
    local i, j, k, cc, result;
    cc := ConjugacyClasses(Action(iter!.G, iter!.domain));
    result := 0*[1..Size(iter!.domain)];
    for i in cc do
        result := result + NumberOrbitsPerm@JOCO
                                           (CycleStructurePerm(Representative(i)), 
                          Size(iter!.domain))
                  * Size(i);
    od;
    return Sum(iter!.sizes,
                y -> result[y]/Size(iter!.G));
end);

InstallGlobalFunction( AllSetOrbits,
function(arg)
    local  g, dom, sizes, iter;
    
    g:=arg[1];
    dom:=arg[2];
    if IsBound(arg[3]) then
        sizes:=arg[3];
    else
        sizes:=[1..Int(Length(dom)/2)];
    fi;
    iter:=IteratorOfSetOrbits(g,dom,sizes);
    return AllSetOrbitsFromIterator(iter);
end);

                       
