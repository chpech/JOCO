PartialPartitionsFamily := NewFamily("PartialPartitionsFam", IsPartialPartition);

DeclareRepresentation( "IsPartialPartitionRep",
        IsAttributeStoringRep,
        [ "ppart",
          "domain",
          "maxclasssize",
          "noLargeClass",
          ]);

InstallMethod(EmptyPartialPartition,
        "for a permutation group and an integer",
        [ IsList, IsInt],
function(domain,maxclasssize)
    local obj,part,varpart,noLargeClass;
    
    # during their construction the sets in a partition are short-lex sorted
    # every partial partition may be completed to a partition by adding one large class
    # this class is always larger than all the other classes with respect to the
    # short lex ordering. 
    # if the option NoLargeClass is given, then partial partitons
    #  are not automatically completed to partitions when 
    # enumerating partiton orbits. This is desirable when all the partition classes should c
    # ome from a predefined pool of sets

    noLargeClass:=ValueOption("noLargeClass");
    if noLargeClass = fail then
        noLargeClass := false;
    fi;
    
    obj:=rec( ppart:=[],
              domain:=domain,
              maxclasssize:=maxclasssize,
              noLargeClass:=noLargeClass
              );
    return Objectify(NewType(PartialPartitionsFamily, IsPartialPartition and IsPartialPartitionRep), obj);
end);

InstallMethod( DomainOfPartialPartition,
        "for a partial partition in PartialPartitionRep",
        [IsPartialPartition and IsPartialPartitionRep],
function(ppart)
    return ppart!.domain;
end);

        
InstallMethod(ExtendedPartialPartition,
        "for a partial partition and a list",
        [IsPartialPartition and IsPartialPartitionRep, IsList],
function(ppartition,set)
    local  nppart, ndomain, obj, 
           nppartition;
      
    Assert(1,IsSubset(ppartition!.domain,set));
    
    nppart:=ShallowCopy(ppartition!.ppart);
    Add(nppart,Set(set));
    ndomain:=Difference(ppartition!.domain,set);
    obj:=rec( ppart:=nppart,
              domain:=ndomain,
              maxclasssize:=ppartition!.maxclasssize,
              noLargeClass:=ppartition!.noLargeClass
            );
    
    nppartition:=Objectify(NewType(PartialPartitionsFamily, 
                                   IsPartialPartition and IsPartialPartitionRep), obj);
    return nppartition;
    
end);


InstallMethod(IsCompatibleWithPartialPartition,
        "for a partial partition and a list",
        [IsPartialPartition and IsPartialPartitionRep, IsList],
function(ppartition, set)
    local class;
    
    if not IsSubset(ppartition!.domain, set) then
        return false;
    fi;
    if Length(set)=Length(ppartition!.domain) then
        return true;
    fi;
    
    if 2*Length(set)<Length(ppartition!.domain) then
        return true;
    fi;
    
    if 2*Length(set)=Length(ppartition!.domain) then
        if set < Difference(ppartition!.domain,set) then
            return true;
        fi;
    fi;
    return false;    
end);

InstallMethod( ViewString,
        "for a partial partition",
        [IsPartialPartition and IsPartialPartitionRep],
function(ppartition)
    return Concatenation("<partial partition: ", String(ppartition!.ppart), ">");
end);

InstallMethod( AsSetsSet,
        "for a partial partition in PartialPartitionRep",
        [IsPartialPartition and IsPartialPartitionRep],
function(ppartition)
    return ShallowCopy(ppartition!.ppart);
end);

InstallMethod(ViewString,
        "for partition  orbits",
        [IsPartitionOrbit],
function(x)
    local res;
    
    res:="<";
    if IsMutable(x) then
        Append(res,"mutable ");
    fi;
    Append(res, Concatenation("PartitionOrbit of length ", String(Size(x)),">"));
    return res;
end);

InstallImmediateMethod( IsCompletePartialPartition,
        "for a partial partition",
       IsPartialPartition and IsPartialPartitionRep,0,
function(ppart)
    if ppart!.domain = [] then
        return true;
    fi;
    if ppart!.noLargeClass then 
        return false;
    fi;
    
    if Length(ppart!.domain) > ppart!.maxclasssize then
        return true;
    fi;
    
    return false;
end);

InstallMethod( PartitionFromCompletePartialPartition,
        "for a complete partial partition",
        [IsPartialPartition and IsPartialPartitionRep],
function(cppart)
    local part;
    
    part:=ShallowCopy(cppart!.ppart);
    if cppart!.domain<>[] then
        Add(part,ShallowCopy(cppart!.domain));
    fi;
    return part;
end);

InstallMethod(RankOfPartialPartition,
              [IsPartialPartition and IsPartialPartitionRep],
function(ppart)
    local rnk;
    rnk:=Length(ppart!.ppart);
    if ppart!.domain<>[] then
        rnk:=rnk+1;
    fi;
    return rnk;
end);

              

InstallGlobalFunction(PartitionOrbitNC,
function(arg)
    local  grp, part, stab, fam, res;
    
    grp:=arg[1];
    part:=arg[2];
    stab:=arg[3];
    
    fam:=PartitionOrbitsFamily(grp);

    res:=rec(
             group:=grp,
             rep:=part,
             stab:=stab);
   return Objectify(NewType(fam, IsPartitionOrbit and IsCocoOrbitRep),res);
end);


InstallGlobalFunction(PartialPartitionOrbitNC,
function(group,ppart,stab)
    local res;

    res:=rec(
            group:=group,
            rep:=ppart,
            stab:=stab);
   return Objectify(NewType(PartialPartitionOrbitsFamily(group), IsPartialPartitionOrbit and IsCocoOrbitRep), res);
end);


InstallMethod( ViewString,
        "for a partial partition orbit",
        [IsPartialPartitionOrbit],
function(pporb)
    return Concatenation("<partial partition orbit of length ", String(Size(pporb)), ">");
end);


InstallMethod(PartitionOrbitsFamily,
    "for permutation groups",
	[IsPermGroup],
function(grp)
   local fam;
   fam:=NewFamily("PartitionsOrbitsFam", IsPartitionOrbit);
   return fam;
end);

InstallMethod(PartialPartitionOrbitsFamily,
    "for permutation groups",
	[IsPermGroup],
function(grp)
   local fam;
   fam:=NewFamily("PartialPartitionsOrbitsFam", IsPartialPartitionOrbit);
   return fam;
end);


DeclareRepresentation( "IsPPOrbitIterRep", IsComponentObjectRep, ["state"]);

PPOrbitIteratorsFamily := NewFamily("PPOrbitIteratorsFam", 
                                      IsIteratorOfPPOrbits);

InstallMethod(IteratorOfPPOrbits,
    "for set orbits",
    [IsList,IsList],
function(domain, setorb)
    local  state, G, part,maxrank,orbitBounds,i,hasTypes,noLargeClass;
    
    
    if setorb= [] then
        state:=fail;
    else
        if not ForAll(setorb, IsSetOrbit) then
            ErrorNoReturn("IteratorOfPartitionOrbits: expecting a list of set orbits");
        fi;
        
        if not ForAll(setorb, so->IsIdenticalObj(FamilyObj(so),FamilyObj(setorb[1]))) then
            ErrorNoReturn("IteratorOfPartitionOrbits: set orbits are incompatible");
        fi;
        
        maxrank:=ValueOption("maxrank");
        orbitBounds:=ValueOption("orbitBounds");
        hasTypes:=ValueOption("hasTypes");
        if hasTypes=fail then
            hasTypes:=false;
        fi;
        noLargeClass:=ValueOption("noLargeClass");
        if noLargeClass = fail then
            noLargeClass := false;
        fi;
        
        
        if orbitBounds<>fail then
            if not IsList(orbitBounds) or Length(orbitBounds)<> Length(setorb) 
                   or not ForAll(orbitBounds, x->IsInt(x) and x>=0) then
                ErrorNoReturn("orbitsBound needs to be a list of non-negative integers of the same langth like <setorb>");
            fi;
        else
            orbitBounds:=List(setorb, x->Length(domain));
        fi;
        
        if not hasTypes then
            for i in [1..Length(orbitBounds)] do
                setorb[i]!.type:=i;
            od;
        fi;
        
            
        
        
        
        G:=UnderlyingGroupOfCocoOrbit(setorb[1]);
        part:=EmptyPartialPartition(domain, Maximum(List(setorb, x->Size(Representative(x)))));
        
        state:=rec( allsorb:=setorb,
                    ppart:=part,
                    maxrank:=maxrank,
                    orbitBounds:=orbitBounds,
                    G:=G,         # the group under which we enumerate orbits
                    GS:=G,        # the SetsSetsStabilizer of the finished slices
                    H:=G,         # the SetsSetsStabilizer of the current slice
                    slice:=[],       # the current slice
                    orbits:=Set(setorb),   # compatible H-orbit representatives of sets
                    orbidx:=1,
                    noLargeClass:=noLargeClass,
                    linkback:=fail
                    );
    fi;
    
    return Objectify(NewType(PPOrbitIteratorsFamily,
                   IsIteratorOfPPOrbits and IsPPOrbitIterRep and IsMutable),
                   rec(state:=state));
end);


InstallMethod( NextIterator,
        "for a mutable iterator of partial partition orbits",
        [IsIteratorOfPPOrbits and IsPPOrbitIterRep and IsMutable],
function(iter)
    local NextState, ppart,grp,stab;
        
    NextState:=function(state)
        local setorb,set,nppart,nH,nextstate,norbits,xnorbits,i;
        
        if state=fail then 
            return fail; 
        fi;        
        
        if state.maxrank<>fail and 
           RankOfPartialPartition(state.ppart) > state.maxrank  or 
           RankOfPartialPartition(state.ppart) = state.maxrank and 
           IsCompletePartialPartition(state.ppart) then
            Info(InfoCOCO,2,"*");
            
            return NextState(state.linkback);
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
            
            nppart:=ExtendedPartialPartition(state.ppart,set);
            if nppart=fail then
                nH:=();
                continue;
            fi;
            nH:=StabilizerOfCanonicalRepresentative(setorb);
            xnorbits:=Filtered(state.orbits, 
                               x->Length(Representative(x))>=Length(set));
            
            norbits:=List(xnorbits, 
                          x->SubOrbitsWithInvariantPropertyOfCocoOrbit(nH, x, 
                                                                       y->IsCompatibleWithPartialPartition(nppart,y)));
            for i in [1..Length(xnorbits)] do
                Perform(norbits[i], function(x) x!.type:=xnorbits[i]!.type;end);
            od;
            norbits:=Concatenation(norbits);
            
            norbits:=Filtered(norbits, x->(Length(Representative(x))>Length(set)) or
                                       (Length(Representative(x))=Length(set) and 
                                        Representative(x)>set));
            
            if state.noLargeClass and not ForAny(norbits, x->Representative(x)[1] in DomainOfPartialPartition(nppart)) then
                nH:=();
                Info(InfoCOCO,1,"!");
                
                continue;
            fi;
            
            if state.slice=[] or Length(state.slice[1])<Length(set) then
                nextstate:=rec( allsorb:=state.allsorb,
                                ppart:=nppart,
                                maxrank:=state.maxrank,
                                orbitBounds:=ShallowCopy(state.orbitBounds),
                                G:=state.G,
                                GS:=state.G,
                                H:=nH,
                                slice:=[set],
                                orbits:=Set(norbits),
                                orbidx:=1,
                                noLargeClass:=state.noLargeClass,
                                linkback:=state);
            else
                nextstate:=rec( allsorb:=state.allsorb,
                                ppart:=nppart,
                                maxrank:=state.maxrank,
                                orbitBounds:=ShallowCopy(state.orbitBounds),
                                G:=state.G,
                                GS:=state.GS,
                                H:=nH,
                                slice:=Concatenation(state.slice,[set]),
                                orbits:=Set(norbits),
                                orbidx:=1,
                                noLargeClass:=state.noLargeClass,
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
    return PartialPartitionOrbitNC(grp,ppart,stab);
end);

InstallMethod( NextPartialPartitionOrbit,
        "for an iterator of  partial partition orbits",
        [IsIteratorOfPPOrbits and IsPPOrbitIterRep],
function(iter)               
    local  ppart, grp, stab;
    
    if iter!.state=fail then
        return fail;
    fi;
    ppart:=iter!.state.ppart;
    grp:=iter!.state.G;
    stab:=iter!.state.H;
    return PartialPartitionOrbitNC(grp,ppart,stab);
end);


InstallMethod( RejectPartialPartitionOrbit,
        "for an iterator of  partial partition orbits",
        [IsIteratorOfPPOrbits and IsPPOrbitIterRep],
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
        if state.orbidx<=Length(state.orbits) then
            break;
        fi;
    od;
    iter!.state:=state;
    return iter;
end);

        
InstallMethod( IsDoneIterator,
        "for an iterator of  partial partition orbits",
        [IsIteratorOfPPOrbits and IsPPOrbitIterRep],
function(iter)
    return iter!.state=fail;
end);

    
InstallMethod(AllPartitionOrbits,
        "for an iterator of partial partition orbits",
        [IsIteratorOfPPOrbits and IsPPOrbitIterRep],
function(iter)
    local  res, ppart, part, lastclass, partorb, flt;
    
    
    flt:=ValueOption("filter");
    if flt=fail then
        flt:=ReturnTrue;
    fi;
    
    if IsDoneIterator(iter) then
        return [];
    fi;
    
    res:=[];
        
    while not IsDoneIterator(iter) do
        if Length(iter!.state.slice)<=COCOInfoPFUSSize then
            Info(InfoCOCO,1,iter!.state.slice,"\n");
        fi;
        if IsCompletePartialPartition(iter!.state.ppart) then
#            Info(InfoCOCO,1,"!");
            ppart:=iter!.state.ppart;
            part:=PartitionFromCompletePartialPartition(ppart);
#            lastclass:=part[Length(part)];
#            if SetOrbit(iter!.state.G, lastclass, 
#                        Stabilizer(iter!.state.G, lastclass,OnSets)) in iter!.state.allsorb then 
            partorb:=PartitionOrbitNC(iter!.state.G, part, iter!.state.H);
            Assert(1,iter!.state.H = Stabilizer(iter!.state.G, Set(part),OnSetsSets));
            
            if flt(partorb) then
                Info(InfoCOCO,1,"!");
                Add(res, partorb);
            fi;
            
#           fi;
        fi;
        
            
        NextIterator(iter);
    od;
    return res;
end);

InstallMethod( ViewString,
        "for partial partition orbits iterators",
        [IsIteratorOfPPOrbits and IsPPOrbitIterRep],
function(iter)
    if iter!.state=fail then
        return "<done partition orbit iterator>";
    else
        return Concatenation("<partial partition orbit iterator, current slice: ",
                             String(iter!.state.slice), ">");
    fi;
end);

InstallMethod(ConstructorOfCocoOrbitNC,
        "for all partial partition orbits",
        [IsPartialPartitionOrbit],
function(orb)
    return PartialPartitionOrbitNC;
end);

InstallMethod(ActionOfCocoOrbit,
        "for all partition orbits",
        [IsPartitionOrbit],
function(orb)
    return OnPartitions;
end);

InstallGlobalFunction(OnPartitions,
function(part,g)
    return ShortLexSorted(OnSetsSets(Set(part),g));
end);
                      
