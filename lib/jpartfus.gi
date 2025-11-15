#############################################################################
##
##  jpartfus.gi                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Implementation of partial Jordan fusions 
##
#############################################################################


InstallMethod(PartialJordanFusionsFamily,
"for a color graph",
[IsColorGraph],
function(cgr)
   local fam;
   fam:=NewFamily("PartialJordanFusionsFam", IsPartialJordanFusion);
   return fam;
end);

InstallMethod(EmptyPartialJordanFusion,
"for a Jordan stable color graph",
[IsColorGraph and IsJStableColorGraph],
function(cgr)
    local  tensor, part, varpart, obj, pjfus;
    
    tensor:=JStructureConstantsOfColorGraph(cgr);
    
    part:=WLBuildTrivialPartition(tensor);
    varpart:=ShortLexSorted(StructuralCopy(part.classes{part.variable}));
    varpart:=Filtered(varpart, x->not x[1] in ReflexiveColors(tensor));
    
    obj:=rec( cgr:=cgr,
              ppart:=[],
              part:=part,
              varpart:=varpart,
              );
    pjfus:= PartialJordanFusion(obj);
    
    SetIsIrredundantPartialStablePartition(pjfus,true);
    SetIsCompletePartialStablePartition(pjfus,true);
    SetPartialStablePartitionHasSmallerBase(pjfus,false);
    return pjfus;
end);

InstallMethod(ConstructorOfPartialColorPartition,
"for a partial Jordan fusion",              
[IsPartialJordanFusion],
function(pjfus)
    return PartialJordanFusion;
end);

InstallGlobalFunction(PartialJordanFusion,
function(obj)
    return Objectify(NewType(PartialJordanFusionsFamily(obj.cgr), IsPartialJordanFusion and IsPartialColorPartitionRep), obj);
end);

InstallMethod( ViewString,
"for a partial Jordan fusion",
[IsPartialJordanFusion and IsPartialStablePartitionRep],
function(pfus)
    return Concatenation("<partial Jordan fusion: ", String(pfus!.ppart), ">");
end);

###################################################################################
# Partial J-fusion orbits


InstallMethod(PartialJordanFusionOrbitsFamilyOp,
"for a color graph and a permutation group",
[IsColorGraph, IsPermGroup],
function(cgr,g)
    return NewFamily("PartialJordanFusionOrbitsFam", IsPartialStablePartitionOrbit);
end);

InstallMethod(GetPartialStablePartitionOrbitFamily,
"for a partial Jordan fusion in PartialJordanFusionRep and a permutation group",
[IsPartialJordanFusion and IsPartialColorPartitionRep, IsPermGroup],
function(prset,grp)  
    return PartialJordanFusionOrbitsFamily(prset!.cgr,grp);
end);


# PartialStablePartitionOrbitNC(<group>, <pjfus> ,<stab>)
# <pjfus> is a partial fusion that is assumed to be minimal (wrt. short lex) in its orbit
# the minimality property is not checked
# <stab> is supposed to be the full (SetsSets-wise) stabilizer of <pfus> in <group>
InstallMethod(PartialStablePartitionOrbitNC,
"for a permutation group, a partial Jordan fusion, and a permutation group",              
[IsPermGroup, IsPartialRegularFusion, IsPermGroup],
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
"for a partial J-fusion, a J-stable set  and an internal partition",
[IsPartialJordanFusion, IsJStableSet, IsRecord],
function(pfus, gs,part)
    return JStabil(JStructureConstantsOfColorGraph(UnderlyingCgrOfColorSet(gs)), part, AsSet(gs));
end);
