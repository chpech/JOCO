
# partitions: Let $X$ be a finite set (totally ordered by $<$, and let $P$ be a 
#      set of partitions of $X$. On $P$ we consider the refinement order: a 
#      partition $\pi_1$ is said to be \emph{finer} than the partition $\pi_2$ if 
#      every class of $\pi_2$ is the union o classes of $\pi_1$. We require that 
#      $P$ is closed with respect to $\land$ of partitions. Here $\pi_1 \land \pi_2$ 
#      is the finest partition coarser than both, $\pi_1$ and $\pi_2$. Also, let 
#      $G$, the group of all permutations of $X$ that maps elements of $P$ to elements  
#      of $P$ (in the canonical action on sets of subsets of $X$).
#
# partial partitions: A tuple $M=(M_1,\dots,M_m)$ of pairwise disjoint non-empty 
#      subsets of $X$ is called a partial partition if 
#          - for all i<j we have that $M_i<M_j$ in the shortlex ordering, 
#          - there exists a partition $\pi\in P$ with 
#            $M^s := \{M_i\mid 1\le i\le m\} \subseteq \pi$, such that all classes 
#            of $\pi$ not in $M$ are greater than all elements of $M$, with respect 
#            to the shortlex ordering of subsets of $X$.
#
# complete partial partitions: A partial partition $M$ is called \emph{complete} if
#      there is a partition $\pi\in P$ with M^s\subseteq \pi$ and such that all 
#      classes of $\pi$ not in $M^s$ have a larger cardinality than all elements of
#      $M^s$.
#
# partitions from partial partitions: By $\Phi(M)$ we denote the coarsest partition 
#      from $P$ that contains $M^s$ (exists because $P$ is closed with respect to 
#      $\land$). We also say that $M$ generates $\phi(M)
# 
# partial partitions from partitions: every partition $\pi$ from $P$ gives rise to a 
#      partial partition $\psi(\pi)$ conisting of all classes of $\pi$ ordered 
#      shortlex.
#
# irredundant partial partitions: A partial partition $M$ is called \emph{irredundant}
#      if for the partial partition $M'$ obtained from $M$ by removing the last element
#      we have $\varphi(M') \neq \varphi(M)$
#
# Observation A: partial partitions are themself ordered by a shortlex ordering, 
#      where the primery soring criterion is the number of classes, and where partial
#      partition with the same number of classes are sorded lexicographically,
#      using the shortlex ordering of subsets of $X$.
#
# Observation B: Let $\pi\in P$ and let $M$ be a partial partition with $\varphi(M)=\pi$. 
#      Then $M$ is a prefix of $\psi(\pi)$. The smallest complete partial partition 
#      that generates $\pi$ is called the \emph{base} of $\pi$ (exists because 
#      $\psi(\pi)$ is a complete partial partition).
#
# Observation C: Every partition from $P$ has a unique base and a unique irredundant 
#      generating partial partition.
# 
# HasSmallerBase: a partial partition $M$ is said to have a \emph{smaller base} if it 
#      has a prefix $M'$ that is complete, and such that $\varphi(M)=\varphi(M')$.

PartialPartitionsFamily := NewFamily("PartialPartitionsFam", IsPartialPartition);

DeclareRepresentation( "IsPartialPartitionRep",
        IsAttributeStoringRep,
        [ "ppart",
          "domain"
          ]);

InstallMethod(EmptyPartialPartition,
        "for a permutation group",
        [ IsList ],
function(domain)
    local  obj,ppart;
        
    obj:=rec( ppart:=[],
              domain:=domain
              );
    ppart := Objectify(NewType(PartialPartitionsFamily, IsPartialPartition and IsPartialPartitionRep), obj);
    SetIsIrredundantPartialPartition(ppart,true);
    SetIsCompletePartialPartition(ppart,true);
    SetHasSmallerBase(ppart,false);
    
    return ppart;
end);

InstallMethod( DomainOfPartialPartition,
        "for a partial partition in PartialPartitionRep",
        [IsPartialPartition and IsPartialPartitionRep],
function(ppart)
    return ppart!.domain;
end);


# <set> is a class to be added to ppart.
# it must be greater than any class of <ppart> w.r.t. shortlex,
# and it must be disjoint from any class of <ppart>.
# If adding <set> to <ppart> does not result in a partial partition (see above),
# then the operation should return fail.
InstallMethod(ExtendedPartialPartition,
        "for a partial partition and a list",
        [IsPartialPartition and IsPartialPartitionRep, IsList],
function(ppartition,set)
    local  class, nppart, ndomain, obj, 
           nppartition;
      
    
    if ppartition!.ppart<>[] then
        class:=Last(ppartition!.ppart);

        if Length(set) < Length(class) then
            return fail;
        fi;
    
        if Length(set) = Length(class) and set < class then
            return fail;
        fi;    
    
        if Length(ppartition!.domain) <> Length(set) then
            if Length(ppartition!.domain) - Length(set) < Length(class) then
                return fail;
            fi;
            
            if Length(ppartition!.domain) - Length(set) = Length(class)  and 
               Difference(ppartition!.domain,set) < class then
                return fail;
            fi;
        fi;
    fi;
    

    ndomain:=Difference(ppartition!.domain,set);
    if Length(set) = Length(ndomain) and set > ndomain then
        return fail;
    fi;
    
    nppart:=ShallowCopy(ppartition!.ppart);
    Add(nppart,Set(set));
    ndomain:=Difference(ppartition!.domain,set);
    obj:=rec( ppart:=nppart,
              domain:=ndomain
            );
    
    nppartition:=Objectify(NewType(PartialPartitionsFamily, 
                                   IsPartialPartition and IsPartialPartitionRep), obj);
    if ndomain <> [] then
        SetIsIrredundantPartialPartition(nppartition,true);
        SetHasSmallerBase(nppartition,false);
        if Length(ndomain) > Length(set) then
            SetIsCompletePartialPartition(nppartition,true);
        else
            SetIsCompletePartialPartition(nppartition,false);
        fi;
    else
        SetIsCompletePartialPartition(nppartition,true);
        SetIsIrredundantPartialPartition(nppartition,false);
        SetHasSmallerBase(nppartition, 
           IsCompletePartialPartition(ppartition) or HasSmallerBase(ppartition));
    fi;
                                        
    return nppartition;
    
end);



# <set> is is compatible with ppartition if it has at least as many elements
# as the largest set of ppart and if it is disjoint from any class of ppart
InstallMethod(IsCompatibleWithPartialPartition,
        "for a partial partition and a list",
        [IsPartialPartition and IsPartialPartitionRep, IsList],
function(ppartition, set)
    
    
    if Length(set) < Length(Last(ppartition!.ppart)) then
        return false;
    fi;
    if not IsSubset(ppartition!.domain, set) then
        return false;
    fi;
    
    return true;
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
    return Set(ppartition!.ppart);
end);

InstallMethod( PartitionFromCompletePartialPartition,
        "for a complete partial partition",
        [IsPartialPartition and IsCompletePartialPartition and IsPartialPartitionRep],
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
    local  state, G, part,maxrank,orbitBounds,i,hasTypes;
    
    
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
        part:=EmptyPartialPartition(domain);
        
        state:=rec( allsorb:=Set(setorb),
                    ppart:=part,
                    maxrank:=maxrank,
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
    
    return Objectify(NewType(PPOrbitIteratorsFamily,
                   IsIteratorOfPPOrbits and IsPPOrbitIterRep and IsMutable),
                   rec(state:=state));
end);

IsConsistentState:=function(tstate)
    local  tGS, tpart, tH, torbits;
    if tstate.ppart!.ppart <> ShortLexSorted(tstate.ppart!.ppart) then
        Info(InfoCOCO,1,"tstate.ppart is not shortLex ordered!");
        return false;
    fi;
    
    if tstate.slice = [] then
        tGS:=Stabilizer(tstate.G, Set(tstate.ppart!.ppart), OnSetsSets);
        if tstate.GS <> tGS then
            Info(InfoCOCO,1,"tstate.slice = [] but tstate.GS is not the stabilizer of tstate.ppart!");
            return false;
        fi;
        if tstate.H <> tGS then
            Info(InfoCOCO,1,"tstate.slice = [] but tstate.H is not the stabilizer of tstate.ppart!");
            return false;
        fi;
    else
        if not IsSet(tstate.slice) then
            Info(InfoCOCO,1,"tstate.slice must be a set!");
            return false;
        fi;
        tpart:=Difference(Set(tstate.ppart!.ppart), tstate.slice);
        tGS:=Stabilizer(tstate.G, tpart, OnSetsSets);
        tH:=Stabilizer(tGS, tstate.slice,OnSetsSets);
        if tGS <> tstate.GS then
            Info(InfoCOCO,1,"tstate.slice <> [] but tstate.GS is not the stabilizer of the complete slices of tstate.ppart!");
            return false;
        fi;
        if tH <> tstate.H then
            Info(InfoCOCO,1,"tstate.slice <> [] but tstate.H is not the stabilizer of tstate.ppart in tstate.GS!");
            return false;
        fi;
    fi;
    
    if tstate.H <> Stabilizer(tstate.G, Set(tstate.ppart!.ppart), OnSetsSets) then
        Info(InfoCOCO,1,"tstate.H is not the stabilizer of tstate.ppart in tstate.G!");
        return false;
    fi;
    if List(tstate.orbits,Representative) <> ShortLexSorted(List(tstate.orbits, Representative)) then
        Info(InfoCOCO,1,"tstate.orbits mut be shortLexSorted!");
        return false;
    fi;
    torbits:=Union(List(tstate.allsorb, AsSet));
    torbits:=List(Orbits(tstate.H, torbits,OnSets),Minimum);
    torbits:=Filtered(torbits, o->IsCompatibleWithPartialPartition(tstate.ppart,o));
    torbits:=ShortLexSorted(torbits);
    if torbits <> List(tstate.orbits,Representative) then
        Info(InfoCOCO,1,"tstate.orbits is not consistent!\n");
        Info(InfoCOCO,1,torbits,"\n");
        Info(InfoCOCO,1,List(tstate.orbits,Representative),"\n");
        
        return false;
    fi;
    if ForAny([1..Length(tstate.orbits)], i->Stabilizer(tstate.H, torbits[i],OnSets)
                                         <>StabilizerOfCanonicalRepresentative(tstate.orbits[i])) then
        Info(InfoCOCO,1,"an element tstate.orbits has the wrong stabilizer!");
        return false;
    fi;
    return true;
end;

    
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
            
            if state.slice=[] then
                nH:=StabilizerOfCanonicalRepresentative(setorb);
                xnorbits:=Filtered(state.orbits, 
                                   x->Length(Representative(x))>=Length(set));
            
                Info(InfoCOCO,2,"Computing suborbits...");
                norbits:=List(xnorbits, 
                              x->SubOrbitsWithInvariantPropertyOfCocoOrbit(nH, x, 
                                 y->IsCompatibleWithPartialPartition(nppart,y)));
                
                Info(InfoCOCO,2,"done.\n");
                
                for i in [1..Length(xnorbits)] do
                    Perform(norbits[i], function(x) x!.type:=xnorbits[i]!.type;end);
                od;
                norbits:=Concatenation(norbits);
                
                # norbits:=Filtered(norbits, x->(Length(Representative(x))>Length(set)) or
                #                            (Length(Representative(x))=Length(set) and 
                #                             Representative(x)>set));
            

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
                                linkback:=state);
                Assert(1, IsConsistentState(nextstate));
                
                if nextstate.H <> Stabilizer(nextstate.G, AsSetsSet(nextstate.ppart), OnSetsSets) then
                    Error("!!!c");
                fi;
                Assert(1, 
                       ForAll(norbits, 
                              o->StabilizerOfCanonicalRepresentative(o) 
                              = Stabilizer(nextstate.H, Representative(o),OnSets)));
                       

                
            elif Length(state.slice[1])<Length(set) then
                nH:=StabilizerOfCanonicalRepresentative(setorb);
                xnorbits:=Filtered(state.orbits, 
                                   x->Length(Representative(x))>=Length(set));
            
                Info(InfoCOCO,2,"Computing suborbits...");
                norbits:=List(xnorbits, 
                              x->SubOrbitsWithInvariantPropertyOfCocoOrbit(nH, x, 
                                y->IsCompatibleWithPartialPartition(nppart,y)));
                Info(InfoCOCO,2,"done.\n");
                
                for i in [1..Length(xnorbits)] do
                    Perform(norbits[i], function(x) x!.type:=xnorbits[i]!.type;end);
                od;
                norbits:=Concatenation(norbits);
            
                # norbits:=Filtered(norbits, x->(Length(Representative(x))>Length(set)) or
                #                            (Length(Representative(x))=Length(set) and 
                #                             Representative(x)>set));
            
                nextstate:=rec( allsorb:=state.allsorb,
                                ppart:=nppart,
                                maxrank:=state.maxrank,
                                orbitBounds:=ShallowCopy(state.orbitBounds),
                                G:=state.G,
                                GS:=state.H,
                                H:=nH,
                                slice:=[set],
                                orbits:=Set(norbits),
                                orbidx:=1,
                                linkback:=state);
                Assert(1, IsConsistentState(nextstate));
                if nextstate.H <> Stabilizer(nextstate.G, AsSetsSet(nextstate.ppart), OnSetsSets) then
                    Error("!!!b");
                fi;
                Assert(1, ForAll(norbits, o->StabilizerOfCanonicalRepresentative(o) = Stabilizer(nextstate.H, Representative(o),OnSets)));
            else
                Info(InfoCOCO,2,"Checking irreducibility...");
                nH:=SetsSetsReducibilityTestOneCard(state.GS, StabilizerOfCanonicalRepresentative(setorb),state.slice,set);
                Info(InfoCOCO,2,"done.\n");
                
                if IsPerm(nH) then
                    continue;
                fi;
                
#                Assert(1,IsSubgroup(nH, StabilizerOfCanonicalRepresentative(setorb)));
                
                xnorbits:=Filtered(state.orbits, 
                                   x->Length(Representative(x))>=Length(set));
                
                Info(InfoCOCO,2,"Computing suborbits...");
                norbits:=List(xnorbits, 
  x->SubOrbitsWithInvariantPropertyOfCocoOrbit(Intersection(state.H,nH), x, 
                                 y->IsCompatibleWithPartialPartition(nppart,y)));
                Info(InfoCOCO,2,"done.\n");
              
                
                for i in [1..Length(xnorbits)] do
                    Perform(norbits[i], function(x) x!.type:=xnorbits[i]!.type;end);
                od;
                
                
                
                norbits:=Concatenation(norbits);
                
                                                                                     
#                norbits:=Filtered(norbits, x->(Length(Representative(x))>Length(set)) or
#                                           (Length(Representative(x))=Length(set) and 
#                                            Representative(x)>set));
                
                norbits:=List(norbits, x->[x,SetOrbit(nH, 
                   CanonicalRepresentativeOfCocoOrbit(x),
                   ClosureGroup(StabilizerOfCanonicalRepresentative(x), 
                      Stabilizer(nH, AsSet(CanonicalRepresentativeOfCocoOrbit(x)),OnTuples)))]);
                Perform(norbits, function(x) x[2]!.type:=x[1]!.type;end);

          #       norbits:=List(norbits, o->[IsCanonicalSetOrbitRep(Stbc(nH),
          # Stbc(StabilizerOfCanonicalRepresentative(o)),Representative(o)),o]);
          #       norbits:=Filtered(norbits, o->not IsPerm(o[1]));
          #       norbits:=List(norbits, 
          #         o->[o[2],SetOrbitNC(nH, Representative(o[2]), StbcGroup(o[1]))]);
          #       Perform(norbits, function(x) x[2]!.type:=x[1]!.type;end);
                norbits:=List(norbits, x->x[2]);
                
                
                # norbits:=Filtered(norbits, x->(Length(Representative(x))>Length(set)) or
                #                            (Length(Representative(x))=Length(set) and 
                #                             Representative(x)>set));
                
                
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
                                linkback:=state);
                Assert(1, IsConsistentState(nextstate));
                if nextstate.H <> Stabilizer(nextstate.G, AsSetsSet(nextstate.ppart), OnSetsSets) then
                    Error("!!!");
                fi;
                Assert(1, ForAll(norbits, o->StabilizerOfCanonicalRepresentative(o) = Stabilizer(nextstate.H, Representative(o),OnSets)));
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
        [IsIteratorOfPPOrbits],
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
        
    while not IsDoneIterator(iter) do
        pporb := NextIterator(iter);

        ppart := Representative(pporb);
        
        if  IsCompletePartialPartition(ppart) and 
            not HasSmallerBase(ppart) then
            
            Info(InfoCOCO,1,"!");
            part:=PartitionFromCompletePartialPartition(ppart);
            
            partorb:=PartitionOrbitNC(UnderlyingGroupOfCocoOrbit(pporb), part, 
                                      StabilizerOfCanonicalRepresentative(pporb));
            Assert(1,StabilizerOfCanonicalRepresentative(pporb) = 
                     Stabilizer(UnderlyingGroupOfCocoOrbit(pporb), Set(part),OnSetsSets));
            
            if flt(partorb) then
                Info(InfoCOCO,1,"!");
                Add(res, partorb);
            fi;
        fi;
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
                      
