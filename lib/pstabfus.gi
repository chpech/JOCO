DeclareRepresentation( "IsPartialStablePartitionRep",
        IsAttributeStoringRep,
        [ "ppart" ]);

InstallMethod(IsEmptyPartialStablePartition,
        "for partial stable partitions in  PartialStablePartitionRep",
        [IsCocoPartialStablePartition and IsPartialStablePartitionRep],
function(cand)
    return cand!.ppart=[];
end);




##############################################################################
#
#  orbits of partial stable partition 
#
##############################################################################
DeclareRepresentation( "IsPartialStablePartitionOrbitRep",
        IsCocoOrbitRep,
        [ "group",
          "rep",
          "stab" ]);

InstallMethod(PartialStablePartitionOrbitNC,
"for a permutation group, a partial stable partition, and a permutation group",
[IsPermGroup, IsCocoPartialStablePartition, IsPermGroup],
function(g,ppart,stab)
    local res, fam;

    res:=rec(
             group:=g,
             rep:=ppart,
             stab:=stab );
    fam:=GetPartialStablePartitionOrbitFamily(ppart,g);
    
    return Objectify(NewType(fam, IsPartialStablePartitionOrbit and 
                                  IsPartialStablePartitionOrbitRep), res);
end);

InstallMethod(ConstructorOfCocoOrbitNC,
        "for all partial stable partition orbits",
        [IsPartialStablePartitionOrbit],
function(orb)
    return PartialStablePartitionOrbitNC;
end);

##############################################################################
#
# the iterator for orbits of partial stable partitions 
#
##############################################################################

DeclareRepresentation( "IsPartialStablePartitionOrbitIterRep", IsComponentObjectRep, ["state"]);

PartialStablePartitionOrbitIteratorsFamily := NewFamily("PartialStablepartitionOrbitIteratorsFamily", 
                                      IsIteratorOfPartialStablePartitionOrbits);

InstallMethod(IteratorOfPartialStablePartitionOrbits,
    "for a set, a stable partial partition, and a list of stable set orbits",
    [IsCocoPartialStablePartition, IsList],
function(part, setorb)
    local  state, G, orbitBounds, i, hasTypes;
    
    
    if not IsEmptyPartialStablePartition(part) then
        ErrorNoReturn("IteratorOfPartialStablePartitionOrbits: Expected an empty stable partial pertition as input.");
    fi;
    
    if setorb= [] then
        state:=fail;
    else
        if not ForAll(setorb, IsCocoSetOrbit) then
            ErrorNoReturn("IteratorOfPartialStablePartitionOrbits: expecting a list of set orbits");
        fi;
        
        if not ForAll(setorb, so->IsIdenticalObj(FamilyObj(so),FamilyObj(setorb[1]))) then
            ErrorNoReturn("IteratorOfPartialStablePartitionOrbits: set orbits are incompatible");
        fi;
        
        orbitBounds:=ValueOption("orbitBounds");
        hasTypes:=ValueOption("hasTypes");
        if hasTypes=fail then
            hasTypes:=false;
        fi;
        
        if orbitBounds<>fail then
            if not IsList(orbitBounds) or Length(orbitBounds)<> Length(setorb) 
                   or not ForAll(orbitBounds, x->IsInt(x) and x>=0) then
                ErrorNoReturn("orbitsBound needs to be a list of non-negative integers of the same length like <setorb>");
            fi;
        else
            orbitBounds:=List(setorb, x->Size(x));
        fi;
        
        if not hasTypes then
            for i in [1..Length(orbitBounds)] do
                setorb[i]!.type:=i;
            od;
        fi;
        
        G:=UnderlyingGroupOfCocoOrbit(setorb[1]);
        
        state:=rec( allsorb:=Set(setorb),
                    ppart:=part,
                    orbitBounds:=orbitBounds,
                    G:=G,         # the group under which we enumerate orbits
                    GS:=G,        # the SetsSetsStabilizer of the finished slices
                    H:=G,         # the SetsSetsStabilizer of the current slice
                    slice:=[],       # the current slice
                    orbits:=Set(setorb),   # compatible H-orbit representatives of sets
                    orbidx:=1,
                    linkback:=fail
                    );
    fi;
    
    return Objectify(NewType(PartialStablePartitionOrbitIteratorsFamily,
                   IsIteratorOfPartialStablePartitionOrbits and IsPartialStablePartitionOrbitIterRep and IsMutable),
                   rec(state:=state));
end);



InstallMethod( NextIterator,
        "for a mutable iterator of partial stable partition orbits",
        [IsIteratorOfPartialStablePartitionOrbits and IsPartialStablePartitionOrbitIterRep and IsMutable],
function(iter)
    local NextState, ppart,grp,stab;
        
    NextState:=function(state)
        local setorb,set,nppart,nH,nextstate,norbits,xnorbits,i,torbits,tsto1,tstnh;
        
        if state=fail then 
            return fail; 
        fi;        
        
        if state.orbidx>Length(state.orbits) then
            return NextState(state.linkback);
        fi;
        
        repeat
            setorb:=state.orbits[state.orbidx];
            set:=CanonicalRepresentativeOfCocoOrbit(setorb);
            state.orbidx:=state.orbidx+1;
            
            if state.orbitBounds[setorb!.type]<=0 then
                nH:=();
                continue;
            fi;
            
            nppart:=ExtendedPartialStablePartition(state.ppart,set);
            if nppart=fail then
                nH:=();
                continue;
            fi;
            
            if state.slice=[] then
                nH:=StabilizerOfCanonicalRepresentative(setorb);
                xnorbits:=Filtered(state.orbits, 
                                   x->Length(Representative(x))>=Length(set));
            
                norbits:=List(xnorbits, 
                              x->SubOrbitsWithInvariantPropertyOfCocoOrbit(nH, x, 
                                 y->IsCompatibleWithPartialStablePartition(nppart,y)));
                
                
                for i in [1..Length(xnorbits)] do
                    Perform(norbits[i], function(x) x!.type:=xnorbits[i]!.type;end);
                od;
                norbits:=Concatenation(norbits);
                norbits:=Filtered(norbits, x->Representative(x)>set);
                
                nextstate:=rec( allsorb:=state.allsorb,
                                ppart:=nppart,
                                orbitBounds:=ShallowCopy(state.orbitBounds),
                                G:=state.G,
                                GS:=state.G,
                                H:=nH,
                                slice:=[AsSet(set)],
                                orbits:=Set(norbits),
                                orbidx:=1,
                                linkback:=state);
                
            elif Length(state.slice[1])<Length(set) then
                nH:=StabilizerOfCanonicalRepresentative(setorb);
                xnorbits:=Filtered(state.orbits, 
                                   x->Length(Representative(x))>=Length(set));
            
                norbits:=List(xnorbits, 
                              x->SubOrbitsWithInvariantPropertyOfCocoOrbit(nH, x, 
                                y->IsCompatibleWithPartialStablePartition(nppart,y)));
                
                for i in [1..Length(xnorbits)] do
                    Perform(norbits[i], function(x) x!.type:=xnorbits[i]!.type;end);
                od;
                norbits:=Concatenation(norbits);
                norbits:=Filtered(norbits, x->Representative(x) > set);
                
                nextstate:=rec( allsorb:=state.allsorb,
                                ppart:=nppart,
                                orbitBounds:=ShallowCopy(state.orbitBounds),
                                G:=state.G,
                                GS:=state.H,
                                H:=nH,
                                slice:=[AsSet(set)],
                                orbits:=Set(norbits),
                                orbidx:=1,
                                linkback:=state);
            else
                nH:=SetsSetsReducibilityTestOneCard(state.GS, 
                     StabilizerOfCanonicalRepresentative(setorb),state.slice,AsSet(set));
                
                
                if IsPerm(nH) then
                    continue;
                fi;
                
                
                xnorbits:=Filtered(state.orbits, 
                                   x->Length(Representative(x))>=Length(set));
                # norbits:=List(xnorbits, 
                #               x->SubOrbitsWithInvariantPropertyOfCocoOrbit(
                #                    Intersection(state.H,nH), x, 
                #                  y->IsCompatibleWithPartialStablePartition(nppart,y)));
                norbits:=List(xnorbits, 
                              x->SubOrbitsWithInvariantPropertyOfCocoOrbit(
                                   StabilizerOfCanonicalRepresentative(setorb), x, 
                                 y->IsCompatibleWithPartialStablePartition(nppart,y)));
                              
                Assert(1, IsSubgroup(nH, StabilizerOfCanonicalRepresentative(setorb)));
                
                for i in [1..Length(xnorbits)] do
                    Perform(norbits[i], function(x) x!.type:=xnorbits[i]!.type;end);
                od;
                
                norbits:=Concatenation(norbits);
                
                
                
                # norbits:=List(norbits, o->[
                #    CopyStabChain(Stbc(StabilizerOfCanonicalRepresentative(o))),o]);
                norbits:=List(norbits, o->[
                   CopyStabChain(Stbc(ClosureGroup(StabilizerOfCanonicalRepresentative(o), 
                      Stabilizer(nH, AsSet(CanonicalRepresentativeOfCocoOrbit(o)),
                                 OnTuples)))),o]);
                norbits:=List(norbits, o->[o[1], 
                             SetCanonifiers(Stbc(nH), o[1],
                               AsSet(Representative(o[2])):failIfNotCanonical), o[2]]);
                norbits:=Filtered(norbits, o->o[2]<>fail);
                
                
                
                
                norbits:=List(norbits, 
                    o->[o[3],ConstructorOfCocoOrbitNC(o[3])(nH, Representative(o[3]), 
                                                  Group(Union(o[1].generators,o[2]),()))]);
                
                
                Perform(norbits, function(x) x[2]!.type:=x[1]!.type;end);
                norbits:=List(norbits, x->x[2]);
                
                norbits:=Filtered(norbits,  x->Representative(x)>set);
                
                nextstate:=rec( allsorb:=state.allsorb,
                                ppart:=nppart,
                                orbitBounds:=ShallowCopy(state.orbitBounds),
                                G:=state.G,
                                GS:=state.GS,
                                H:=nH,
                                slice:=Concatenation(state.slice,[AsSet(set)]),
                                orbits:=Set(norbits),
                                orbidx:=1,
                                linkback:=state);
            fi;
                        
            nextstate.orbitBounds[setorb!.type]:=nextstate.orbitBounds[setorb!.type]-1;
            
        until not IsPerm(nH) or state.orbidx > Length(state.orbits);
        if IsPerm(nH) then
            return NextState(state.linkback);
        fi;
        
        return nextstate;
    end;
    
    if iter!.state=fail then
        return fail;
    fi;
    
    grp:=iter!.state.G;
    ppart:=iter!.state.ppart;
    stab:=iter!.state.H;
    
    iter!.state:=NextState(iter!.state);
    return PartialStablePartitionOrbitNC(grp,ppart,stab);
end);

InstallMethod( IsDoneIterator,
        "for an iterator of  partial stable partition orbits in PartialStablePartitionOrbitIterRep",
        [IsIteratorOfPartialStablePartitionOrbits and IsPartialStablePartitionOrbitIterRep and IsMutable],
function(iter)
    return iter!.state=fail;
end);

InstallMethod( ViewString,
        "for partial R-fusion iterators",
        [IsIteratorOfPartialStablePartitionOrbits and IsPartialStablePartitionOrbitIterRep],
function(iter)
    return Concatenation("<partial stable partition orbit iterator, current slice: ",
          String(iter!.state.slice), ">");
end);

InstallMethod(AllStablePartitionOrbits,
        "for an iterator of partial stable partition orbits",
        [IsIteratorOfPartialStablePartitionOrbits],
function(iter)
    local  flt, res, pporb, ppart, part, partorb;
    
    
    flt:=ValueOption("filter");
    if flt=fail then
        flt:=ReturnTrue;
    fi;
    
    if IsDoneIterator(iter) then
        return [];
    fi;
    
    res:=[];
    Info(InfoJOCO,1,"Computing orbits of stable partitions.\n");
    while not IsDoneIterator(iter) do
        pporb := NextIterator(iter);

        ppart := Representative(pporb);
        
        if  IsCompletePartialStablePartition(ppart) and 
            not PartialStablePartitionHasSmallerBase(ppart) then
            
            part:=StablePartitionFromCompletePartialStablePartition(ppart);
            
            partorb:=ConstructorOfStablePartitionOrbitNC(part)(UnderlyingGroupOfCocoOrbit(pporb), part, 
                                      StabilizerOfCanonicalRepresentative(pporb));
            # Assert(1,StabilizerOfCanonicalRepresentative(pporb) = 
            #          Stabilizer(UnderlyingGroupOfCocoOrbit(pporb), Set(part),OnSetsSets));
            
            if flt(partorb) then
                Info(InfoJOCO,1,"!");
                Add(res, partorb);
            fi;
        fi;
    od;
    Info(InfoJOCO,1,"\nDone computing orbits of stable partitions.\n");
    
    return res;
end);
