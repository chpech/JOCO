# given a universe [1..n] and an ordered partition imap on it
# map be the unique mapping from [1..n] to [1..Length(imap)] with the property
# that map[i] is the unique j with the property that i \in imap[j]
#
# given further a family F of subsets of [1..n] such that for every M \in F holds
# that 
# (*)  \forall i : if i \in M then imap[map[i]] \subseteq M. 
# The elements of F are called stable sets.
#
# A family FF of [1..n] is called a family of partial stable sets if 
#   (1) each of its elements satisfies (*),
#   (2) every subset satisfying (*) and contained in some element of FF is also in FF
#   (3) every element of F is in FF
# 
# An element of FF is called complete if it is in F
# 
# The domain of some M from FF consists of all elements j of [1..Length(imap)] such that
#    (a) imap[j] \cap M = \emptyset,
#    (b) M \cup imap[j] \in FF
#
# When talking about orbits of partial stable sets then we have in mind a 
# permutation group G on [1..n] such that
#    (i)   G leaves invariant Set(imap) in action OnSetsSets,
#    (ii)  G leaves invariant FF in action OnSetsSets,
#    (iii) G leaves invariant F in action OnSetsSets.
# then orbit representatives of G on F may be found by enumerating orbit 
# representatives of G on FF and returning only those that are from F
# the efficiency of this aproach depends strongly on the clever choice of FF
# Generally, the smaller is FF, the more efficient the approach becomes.

BindConstant("nonextensible", false);

DeclareRepresentation("IsPartialStableSetRep",
        IsAttributeStoringRep,
        [ "set",                   # the partial stable set
          "map",
          "imap",
          "domain"
        ]);

InstallMethod(IsEmptyPartialStableSet,
        "for partial stable sets in PartialStableSetRep",
        [IsCocoPartialStableSet and IsPartialStableSetRep],
function(cand)
    return cand!.set=[];
end);

InstallMethod(IMapOfPartialStableSet,
        "for partial stable sets in PartialStableSetRep",
        [IsCocoPartialStableSet and IsPartialStableSetRep],
function(cand)
    return cand!.imap;
end);

InstallMethod(DomainOfPartialStableSet,
        "for partial stable sets in PartialStableSetRep",
        [IsCocoPartialStableSet and IsPartialStableSetRep],
function(cand)
    return cand!.domain;
end);


##############################################################################
#
#  orbits of partial stable sets 
#
##############################################################################
DeclareRepresentation( "IsPartialStableSetOrbitRep",
        IsCocoOrbitRep,
        [ "group",
          "rep",
          "stab" ]);

InstallMethod(PartialStableSetOrbitNC,
"for a permutation group and a partial stable set",
[IsPermGroup, IsCocoPartialStableSet, IsPermGroup],
function(g,pgs,stab)
    local res;

    res:=rec(
             group:=g,
             rep:=pgs,
             stab:=stab );
    return Objectify(NewType(GetPartialStableSetOrbitFamily(pgs,g), IsPartialStableSetOrbit and 
                                                                   IsPartialStableSetOrbitRep), res);
end);

InstallMethod(ConstructorOfCocoOrbitNC,
        "for all partial stable set orbits",
        [IsPartialStableSetOrbit],
function(orb)
    return PartialStableSetOrbitNC;
end);


##############################################################################
#
# the iterator for orbits of partial stable sets 
#
##############################################################################

DeclareRepresentation( "IsPartialStableSetOrbitIterRep", IsComponentObjectRep, ["state"]);

PartialStableSetOrbitIteratorsFamily := NewFamily("PartialStableSetOrbitIteratorsFamily", 
                                      IsIteratorOfPartialStableSetOrbits);

InstallMethod(IteratorOfPartialStableSetOrbits,
    "for permutation groups and partial stable sets",
    [IsPermGroup, IsCocoPartialStableSet],
function(aaut,cand)
    local S,SM,state,act;
    
    if not IsEmptyPartialStableSet(cand) then
        ErrorNoReturn("IteratorOfPartialStableSetOrbits: Expected an empty candidate as input.");
    fi;
    
    act:=ActionHomomorphism(aaut,IMapOfPartialStableSet(cand),OnSets);
    
    S:=Stbc(Image(act));
    SM:=StbcCopy(S);
    
    state:=rec( cand:=cand,
                act:=act,
                S:=S,        
                SM:=SM,            
                M:=[],
                orbreps:=StbcMinimalOrbitReps(SM,DomainOfPartialStableSet(cand)),
                orbidx:=1,
                linkback:=fail
               );
    
    return Objectify(NewType(PartialStableSetOrbitIteratorsFamily,
                   IsIteratorOfPartialStableSetOrbits and IsPartialStableSetOrbitIterRep and IsMutable),
                   rec(state:=state));
end);


InstallMethod( NextIterator,
        "for iterators of partial stable set orbits",
        [IsIteratorOfPartialStableSetOrbits and IsPartialStableSetOrbitIterRep and IsMutable],
function(iter)
    local NextState, res,cand;
        
    NextState:=function(state)
        local pt, SC, ncand, nextstate;
        
        if state=fail then 
            return fail; 
        fi;
        
        
        if DomainOfPartialStableSet(state.cand) = [] then
            return NextState(state.linkback);
        fi;
                
        if state.orbidx>Length(state.orbreps) then
            return NextState(state.linkback);
        fi;
        
        ncand:=fail;
        # while ncand=fail and state.orbidx <= Length(state.orbreps) do 
        repeat
            pt:=state.orbreps[state.orbidx];
            state.orbidx:=state.orbidx+1;
            ncand:=ExtendedPartialStableSet(state.cand,pt);
            if ncand=nonextensible then
                ncand:=fail;
                break;
            fi;
                
                
            if ncand<>fail then
                SC:=CocoSetReducibilityTest(state.S,state.SM,state.M,pt);
                if IsPerm(SC) then
                    ncand:=fail;
                fi;
            fi;
        until ncand<>fail or state.orbidx > Length(state.orbreps);
        
        
        if ncand=fail then
            return NextState(state.linkback);
        fi;
        
            
        nextstate:=rec(cand:=ncand,
                       act:=state.act,
                       S:=state.S,
                       SM:=SC,
                       M:=Union(state.M,[pt]),
                       orbreps:=StbcMinimalOrbitReps(SC,DomainOfPartialStableSet(ncand)),
                       orbidx:=1,
                       linkback:=state);
        return nextstate;
    end;
    
    if iter!.state=fail then
        return fail;
    fi;
    
    res:=PartialStableSetOrbitNC(Image(iter!.state.act), iter!.state.cand, StbcGroup(iter!.state.SM));
    iter!.state:=NextState(iter!.state);
    return res;
end);


InstallMethod( IsDoneIterator,
        "for iterators of partial stable set orbits in PartialStableSetOrbitIterRep",
        [IsIteratorOfPartialStableSetOrbits and IsPartialStableSetOrbitIterRep],
function(iter)
    return iter!.state=fail;
end);

InstallMethod( ViewString,
        "for iterators of partial stable set orbits in PartialStableSetOrbitIterRep",
        [IsIteratorOfPartialStableSetOrbits and IsPartialStableSetOrbitIterRep],
function(iter)
    if iter!.state=fail then
        return "<done partial stable set orbit iterator>";
    else
        return Concatenation("<partial stable set orbit iterator, current set ",
                             String(iter!.state.M), ">");
    fi;
end);         



InstallMethod(ActionOfPartialStableSetOrbitIterator,
        "for iterators of partial stable set orbits in PartialStableSetOrbitIterRep",
        [IsIteratorOfPartialStableSetOrbits and IsPartialStableSetOrbitIterRep],
function(iter)        
    if iter!.state=fail then
        return fail;
    fi;
    return iter!.state.act;
end);

COCOInfoGSSize:=10;
InstallMethod(AllStableSetOrbits,
        "for iterators of partial stable set orbits in PartialStableSetOrbitIterRep",
        [IsIteratorOfPartialStableSetOrbits and IsPartialStableSetOrbitIterRep],
function(iter)
    local  res, grp, gs, gens, act, ker, stab;
    
    if IsDoneIterator(iter) then
        return [];
    fi;
    
    res:=[];
    grp:=Source(iter!.state.act);
    
    Info(InfoJOCO,1,"Computing orbits of stable sets.\n");
    while not IsDoneIterator(iter) do
        if Length(iter!.state.M)<=COCOInfoGSSize then
            Info(InfoJOCO,2,iter!.state.M,"\n");
        fi;
        
        if IsCompletePartialStableSet(iter!.state.cand) then
            gs:=StableSetFromPartialStableSet(iter!.state.cand);
            if gs <> fail then 
                gens:=ShallowCopy(iter!.state.SM.generators);
                act:=iter!.state.act;
                ker:=GeneratorsOfGroup(Kernel(act));
                stab:=Union(List(gens,g->PreImagesRepresentative(act,g)*ker));
                stab:=Group(stab,());
#                stab:=Group(PreImagesSet(iter!.state.act,gens),());            
                Add(res, ConstructorOfStableSetOrbit(gs)(grp,gs, stab));
                Info(InfoJOCO,1,"*");
            fi;
        fi;
        
        NextIterator(iter);
    od;
    Info(InfoJOCO,1,"Done computing orbits of stable sets.\n");
    return res;
end);

