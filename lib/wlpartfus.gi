#############################################################################
##
##  wlpartfus.gi                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Implementation of partial WL-stable  fusions 
##
#############################################################################


InstallMethod(PartialWLFusionsFamily,
"for a color graph",
[IsColorGraph],
function(cgr)
   local fam;
   fam:=NewFamily("PartialWLFusionsFam", IsPartialWLFusion);
   return fam;
end);

InstallMethod(EmptyPartialWLFusion,
"for a WL-stable color graph",
[IsColorGraph and IsWLStableColorGraph],
function(cgr)
    local  tensor, part, varpart, obj, pjfus;
    
    tensor:=StructureConstantsOfColorGraph(cgr);
    
    part:=WLBuildTrivialPartition(tensor);
    varpart:=ShortLexSorted(StructuralCopy(part.classes{part.variable}));
    varpart:=Filtered(varpart, x->not x[1] in ReflexiveColors(tensor));
    
    obj:=rec( cgr:=cgr,
              ppart:=[],
              part:=part,
              varpart:=varpart,
              );
    pjfus:= PartialWLFusion(obj);
    
    SetIsIrredundantPartialStablePartition(pjfus,true);
    SetIsCompletePartialStablePartition(pjfus,true);
    SetPartialStablePartitionHasSmallerBase(pjfus,false);
    return pjfus;
end);

InstallMethod(ConstructorOfPartialColorPartition,
"for a partial WL-fusion",              
[IsPartialWLFusion],
function(pfus)
    return PartialWLFusion;
end);

InstallGlobalFunction(PartialWLFusion,
function(obj)
    return Objectify(NewType(PartialWLFusionsFamily(obj.cgr), IsPartialWLFusion and IsPartialColorPartitionRep), obj);
end);




InstallMethod( ViewString,
"for a partial WL-stable fusion",
[IsPartialWLFusion and IsPartialStablePartitionRep],
function(pfus)
    return Concatenation("<partial WL-stable fusion: ", String(pfus!.ppart), ">");
end);

###################################################################################
# Partial WL-fusion orbits


InstallMethod(PartialWLFusionOrbitsFamilyOp,
"for a color graph and a permutation group",
[IsColorGraph, IsPermGroup],
function(cgr,g)
    return NewFamily("PartialWLFusionOrbitsFam", IsPartialStablePartitionOrbit);
end);

InstallMethod(GetPartialStablePartitionOrbitFamily,
"for a partial WL-stable fusion in PartialWLFusionRep and a permutation group",
[IsPartialWLFusion and IsPartialColorPartitionRep, IsPermGroup],
function(prset,grp)  
    return PartialWLFusionOrbitsFamily(prset!.cgr,grp);
end);


# PartialStablePartitionOrbitNC(<group>, <pjfus> ,<stab>)
# <pjfus> is a partial fusion that is assumed to be minimal (wrt. short lex) in its orbit
# the minimality property is not checked
# <stab> is supposed to be the full (SetsSets-wise) stabilizer of <pfus> in <group>
InstallMethod(PartialStablePartitionOrbitNC,
"for a permutation group, a partial WL-stable fusion, and a permutation group",              
[IsPermGroup, IsPartialWLFusion, IsPermGroup],
function(group,pfus,stab)
    local res,fam;

    res:=rec(
            group:=group,
            rep:=pfus,
            stab:=stab);
    fam:=GetPartialStablePartitionOrbitFamily(pfus,group);
    return Objectify(NewType(fam, IsPartialStablePartitionOrbit and IsPartialStablePartitionOrbitRep), res);
end);

InstallMethod(StabilizedInternalPartition,
"for a partial WL-fusion, a WL-stable set and an internal partition",
[IsPartialWLFusion, IsWLStableSet, IsRecord],
function(pfus,gs,part)
    return WLStabil(StructureConstantsOfColorGraph(UnderlyingCgrOfColorSet(gs)), part, AsSet(gs));
end);

