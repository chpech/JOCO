#############################################################################
##
##  rpartfus.gi                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Implementation of partial R-fusions 
##
#############################################################################
              

InstallMethod(PartialRegularFusionsFamily,
"for color graphs ",
[IsColorGraph],
function(cgr)
   local fam;
   fam:=NewFamily("PartialRegularFusionsFam", IsPartialRegularFusion);
   return fam;
end);


InstallMethod(EmptyPartialRegularFusion,
"for a stable rainbow",
[IsColorGraph and IsRainbow and IsStableRainbow],
function(cgr)
    local  rclr, part, varpart, obj, prfus;
    
    rclr:=ReflexiveColors(cgr);
    
    part:=rec();
    part.classes:=[rclr, Difference([1..RankOfColorGraph(cgr)], rclr)];
    part.fixed:=[];
    part.variable:=[1,2];
    part.instabilFlags:=[false,false];
    part.instabil:=FiFoNew();
    part.totest:=FiFoNew();
    part.totestFlags:=[false,false];
    part.colorNames:=List([1..Length(part.classes)], x->[x,1]);
    part.numberClasses:=ListWithIdenticalEntries(Length(part.classes), 1);
    
    varpart:=[Difference([1..RankOfColorGraph(cgr)], rclr)];
    
    obj:=rec( cgr:=cgr,
              ppart:=[],
              part:=part,
              varpart:=varpart,
            );
    prfus:= Objectify(NewType(PartialRegularFusionsFamily(cgr), IsPartialRegularFusion and IsPartialColorPartitionRep), obj);
    SetIsIrredundantPartialStablePartition(prfus,true);
    SetIsCompletePartialStablePartition(prfus,true);
    SetPartialStablePartitionHasSmallerBase(prfus,false);
    return prfus;
end);

InstallMethod(ConstructorOfPartialColorPartition,
"for a partial WL-fusion",              
[IsPartialRegularFusion],
function(pfus)
    return PartialRegularFusion;
end);

InstallGlobalFunction(PartialRegularFusion,
function(obj)
    return Objectify(NewType(PartialRegularFusionsFamily(obj.cgr), IsPartialRegularFusion and IsPartialColorPartitionRep), obj);
end);

InstallMethod( ViewString,
"for a partial regular fusion",
[IsPartialRegularFusion and IsPartialColorPartitionRep],
function(pfus)
    return Concatenation("<partial regular fusion: ", String(pfus!.ppart), ">");
end);



###################################################################################
# Partial R-fusion orbits


InstallMethod(PartialRegularFusionOrbitsFamilyOp,
"for a color graph and a permutation group",
[IsColorGraph, IsPermGroup],
function(cgr,g)
    return NewFamily("PartialRegularFusionOrbitsFam", IsPartialStablePartitionOrbit);
end);

InstallMethod(GetPartialStablePartitionOrbitFamily,
"for a partial regular fusion in PartialRegularFusionRep and a permutation group",
[IsPartialRegularFusion and IsPartialColorPartitionRep, IsPermGroup],
function(prset,grp)  
    return PartialRegularFusionOrbitsFamily(prset!.cgr,grp);
end);

# PartialStablePartitionOrbitNC(<group>, <pfus> ,<stab>)
# <pfus> is a partial R-fusion that is assumed to be minimal (wrt. short lex) in its orbit
# the minimality property is not checked
# <stab> is supposed to be the full (SetsSets-wise) stabilizer of <pfus> in <group>
InstallMethod(PartialStablePartitionOrbitNC,
"for a permutation group, a partial regular fusion, and a permutation group",              
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
"for a partial ragular fusion, a regular set and an internal partition",
[IsPartialRegularFusion, IsRegularSet, IsRecord],
function(pfus,gs,part)
    return part;
end);
