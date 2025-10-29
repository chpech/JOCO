#############################################################################
##
##  wlordanfus.gi                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Implementation of the datatype of WL-stable fusions
##
#############################################################################


InstallMethod( WLFusionsFamily,
"for a color graph",
[IsColorGraph],
function(cgr)
   local fam;
   fam:=NewFamily("WLFusionsFam", IsWLFusion);
   return fam;
end);

InstallMethod( StablePartitionFromCompletePartialStablePartition,
"for a partial WL-stable fusion in PartialWLFusionRep",
[IsPartialWLFusion and IsPartialWLFusionRep],
function(cpfus)
    local obj;
    
    #   Assert(1, OnSetsSets(Set(cpfus!.part.classes),Mates(cpfus!.tensor))=Set(cpfus!.part.classes));
    obj:=rec(
   	      cgr := cpfus!.cgr,
   	      partition := Immutable(ShortLexSorted(cpfus!.part.classes)));
    return Objectify(NewType(WLFusionsFamily(cpfus!.cgr), IsWLFusion and IsColorPartitionRep), obj);
end);

InstallMethod(ViewString,
"for a WL-stable fusion",
[IsWLFusion],
function(x)
    return Concatenation("<WL-stable fusion of order ", String(Order(x)), " and rank ", String(Rank(x)), ">");
end);

InstallOtherMethod(HomogeneousWLFusionOrbits,
"for a WL-stable color graph and a list of WL-stable color sets",
[IsColorGraph and IsWLStableColorGraph, IsList],
function(cgr,gsorbits)
    local  max, pfus, iter;

    if not ForAll(gsorbits, IsRegularSetOrbit) then
        ErrorNoReturn("HomogeneousWLFusionOrbits: expecting a list of regular set orbits");
    fi;
    if not ForAll(gsorbits, gso->IsIdenticalObj(FamilyObj(Representative(gso)),FamilyObj(Representative(gsorbits[1])))) then
        ErrorNoReturn("HomogeneousWLFusionOrbits: regular set orbits are incompatible");
    fi;
    if not ForAll(gsorbits, gso->IsWLStableSet(Representative(gso))) then 
        ErrorNoReturn("HomogeneousWLFusionOrbits: expecting a list of orbits of WL-stable regular set orbits");
    fi;
    
    if gsorbits=[] then
        max:=0;
    else
        max:=Maximum(List(gsorbits, x->Size(Representative(x))));
        if not IsIdenticalObj(cgr,UnderlyingCgrOfColorSet(Representative(gsorbits[1]))) then
            ErrorNoReturn("HomogeneousWLFusionOrbits: regular set orbits are incompatible");
        fi;
    fi;
    
   
    pfus:=EmptyPartialWLFusion(cgr,max);
    
    iter:=IteratorOfPartialStablePartitionOrbits(pfus,gsorbits);
    
    return AllStablePartitionOrbits(iter);
    
end);

# <g> must be from AAut(<fusion!.cgr>)
InstallMethod(OnWLFusions,
"for a WL-stable fusion in ColorPartitionRep and a permutation",
[IsWLFusion and IsColorPartitionRep, IsPerm],
function(fusion, g)
    local res;
    res:=rec(
             cgr:=fusion!.cgr,
             partition:=MakeImmutable(ShortLexSorted(OnSetsSets(Set(fusion!.partition),g)))
    );

    return Objectify(NewType(WLFusionsFamily(fusion!.cgr), IsWLFusion and IsColorPartitionRep), res);
end);

InstallMethod(HomogeneousWLFusionOrbits,
"for a WL-stable color graph",
[IsColorGraph and IsWLStableColorGraph],
function(cgr)
    local gsorbs;
    
    gsorbs:=HomogeneousWLStableSetOrbits(cgr);
    return HomogeneousWLFusionOrbits(cgr,gsorbs);
end);

InstallOtherMethod(HomogeneousWLFusionOrbits,
"for a WL-stable color graph and a permutation group",
[IsColorGraph and IsWLStableColorGraph, IsPermGroup],
function(cgr,grp)
    local  gsorbs, rforb;
    
    gsorbs:=HomogeneousWLStableSetOrbits(cgr,grp);
    rforb:=HomogeneousWLFusionOrbits(cgr,gsorbs);
    
    return gsorbs;
end);


InstallMethod(ConstructorOfStablePartitionOrbit,
"for a WL-stable fusion",
[IsWLFusion],
function(rfus)
    return RegularFusionOrbit;
end);

InstallMethod(ConstructorOfStablePartitionOrbitNC,
"for a WL-stable fusion",
[IsWLFusion],
function(rfus)
    return RegularFusionOrbitNC;
end);
