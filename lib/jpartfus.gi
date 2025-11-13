#############################################################################
##
##  jpartfus.gi                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Implementation of partial Jordan fusions 
##
#############################################################################

# DeclareRepresentation( "IsPartialJordanFusionRep",
#          IsPartialStablePartitionRep,
#         [ "cgr",
#           "ppart",
#           "part", 
#           "varpart",
#           "maxclasssize",
#         ]);


InstallMethod(PartialJordanFusionsFamily,
"for a color graph",
[IsColorGraph],
function(cgr)
   local fam;
   fam:=NewFamily("PartialJordanFusionsFam", IsPartialJordanFusion);
   return fam;
end);

InstallMethod(EmptyPartialJordanFusion,
"for a Jordan stable color graph and an integer",
[IsColorGraph and IsJStableColorGraph, IsInt],
function(cgr,maxclasssize)
    local  tensor, part, varpart, obj, pjfus;
    
    tensor:=JStructureConstantsOfColorGraph(cgr);
    
    part:=WLBuildTrivialPartition(tensor);
    varpart:=ShortLexSorted(StructuralCopy(part.classes{part.variable}));
    varpart:=Filtered(varpart, x->not x[1] in ReflexiveColors(tensor));
    
    obj:=rec( cgr:=cgr,
              ppart:=[],
              part:=part,
              varpart:=varpart,
              maxclasssize:=maxclasssize
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


    
# InstallMethod(ExtendedPartialStablePartition,
# "for a partial Jordan fusion in  PartialJordanFusionRep and a regular J-stable set",
# [IsPartialJordanFusion and IsPartialStablePartitionRep, IsRegularSet and IsJStableSet],
# function(pfusion,gs)
#     local  tensor, rset, arset, i, class, lclass, npart, pos, nppart, obj, 
#            nvarpart, npfusion;
    
#     tensor:=JStructureConstantsOfColorGraph(pfusion!.cgr);
    
#     rset:=AsSet(gs);
#     arset:=OnSets(rset, ColorMates(pfusion!.cgr));
    
#     # when new slice starts, then rset can be its first element only if it is smaller than
#     # arset
#     if pfusion!.ppart = [] or Length(rset) > Length(Last(pfusion!.ppart)) then 
#         if arset < rset then 
#             return fail;
#         fi;
#     fi;
    
#     # rset must be a subset of some variable class of ppart
#     i:=First([1..Length(pfusion!.varpart)], j->IsSubset(pfusion!.varpart[j],rset));
#     if i = fail then
#         return fail;
#     fi;
#     class:=pfusion!.varpart[i];
#     #########
#     if ForAny([1..i-1], j->Length(pfusion!.varpart[j]) < Length(rset) 
#                         or Length(pfusion!.varpart[j]) = Length(rset) 
#                         and pfusion!.varpart[j] < rset)  
#     then
        
#        return fail;
#     fi;
#     #################
#     # if ForAny([1..i-1], j->Length(pfusion!.varpart[j]) <= Length(rset)) then
#     #     return fail;
#     # fi;
#     ###############3
#     # when new slice starts, then rset can be its first element only if it is smaller than
#     # OnSets(rset, ColorMates(pfusion!.cgr))
#     if Length(class) > Length(rset) and arset < rset then
#         return fail;
#     fi;
    
#     # if arset <rset  then arset must come before rset in pfusion!.ppart
#     # the two tests before for the situation that slice is new could be replaced by 
#     # the following test, if it is placed n the beginning of the function
#     # however, checking that arset is in pfusion!.ppart takes more time
#     if arset < rset and not arset in pfusion!.ppart then
#         return fail;
#     fi;

#     if pfusion!.ppart<>[] then
#         lclass:=Last(pfusion!.ppart);
#         if Length(rset) < Length(lclass) then
#             return fail;
#         fi;
#         if Length(rset) = Length(lclass) and rset < lclass then
#             return fail;
#         fi;
#         if Length(class) <> Length(rset) then
#             if Length(class)-Length(rset) < Length(lclass) then
#                 return fail;
#             fi;
#             if Length(class) - Length(rset) = Length(lclass) and
#                Difference(class, rset) < lclass then
#                 return fail;
#             fi;
#         fi;
#     fi;

    
#     if class = rset then
#         npart:=WLShallowCopyStablePartition(pfusion!.part);
#         pos:=Position(npart.classes,rset);
#         AddSet(npart.fixed, pos);
#         RemoveSet(npart.variable,pos);
#         nppart:=ShallowCopy(pfusion!.ppart);
#         Add(nppart,rset);
        
#         obj:=rec( cgr:=pfusion!.cgr,
#                   ppart:=nppart,
#                   part:=npart,
#                   varpart:= pfusion!.varpart{Difference([1..Length(pfusion!.varpart)],[i])},
#                   maxclasssize:=pfusion!.maxclasssize);
#     else # lif Length(gs)<Length(class) or (Length(gs)=Length(class) and AsSet(gs)<=class) then
#         npart:=WLShallowCopyStablePartition(pfusion!.part);
#         npart:=JRefinedPartition(npart,gs);
#         if npart=fail then
#             return fail;
#         fi;
        
#         npart:=JStabil(tensor, npart, rset);
#         if npart=fail then
#             return fail;
#         fi;
        
#         nppart:=ShallowCopy(pfusion!.ppart);
#         Add(nppart,rset);
#         nvarpart:=ShortLexSorted(StructuralCopy(npart.classes{npart.variable}));
#         nvarpart:=Filtered(nvarpart, x->not x[1] in ReflexiveColors(pfusion!.cgr));
                
#         obj:=rec( cgr:=pfusion!.cgr,
#                   ppart:=nppart,
#                   part:=npart,
#                   varpart:=nvarpart,
#                   maxclasssize:=pfusion!.maxclasssize);
#     # else
#     #     return fail;
#     fi;
#     npfusion:=Objectify(NewType(PartialJordanFusionsFamily(pfusion!.cgr), IsPartialJordanFusion and IsPartialStablePartitionRep), obj);
#     if Length(rset) < Length(class) then
#         SetIsIrredundantPartialStablePartition(npfusion,true);
#         SetPartialStablePartitionHasSmallerBase(npfusion,false);
#         if Length(class)-Length(rset) > Length(rset) then
#             SetIsCompletePartialStablePartition(npfusion,true);
#         else
#             SetIsCompletePartialStablePartition(npfusion,false);
#         fi;
#     elif obj!.varpart = [] then 
#         SetIsCompletePartialStablePartition(npfusion,true);
#         SetIsIrredundantPartialStablePartition(npfusion,false);
#         SetPartialStablePartitionHasSmallerBase(npfusion,
#            IsCompletePartialStablePartition(pfusion) 
#            or PartialStablePartitionHasSmallerBase(pfusion));
#     elif Length(obj!.varpart[1]) = Length(rset) then  # at this point Length(rset)=Length(class)
#         SetIsCompletePartialStablePartition(npfusion,false);
#         SetIsIrredundantPartialStablePartition(npfusion,false);
#         SetPartialStablePartitionHasSmallerBase(npfusion,
#            IsCompletePartialStablePartition(pfusion) 
#            or PartialStablePartitionHasSmallerBase(pfusion));
#     else  
#         SetIsCompletePartialStablePartition(npfusion,true);
#         SetIsIrredundantPartialStablePartition(npfusion,false);
#         SetPartialStablePartitionHasSmallerBase(npfusion,
#            IsCompletePartialStablePartition(pfusion) 
#            or PartialStablePartitionHasSmallerBase(pfusion));
#     fi;
        
#     Assert(1, OnSetsSets(Set(npfusion!.part.classes),ColorMates(npfusion!.cgr))=Set(npfusion!.part.classes));
#     Assert(1, ForAll(npfusion!.ppart, x->ForAll(npfusion!.varpart, y->Length(x)<Length(y) 
#                                                                   or Length(x)= Length(y) and x < y)));
    
#     return npfusion;
# end);

# InstallMethod(IsCompatibleWithPartialStablePartition,
# "for a partial Jordan fusion and a J-stable regular set",
# [IsPartialJordanFusion and IsPartialStablePartitionRep, IsRegularSet and IsJStableSet],
# function(pfusion, gs)
#     local class;
    
#     for class in pfusion!.varpart do
#         if IsSubset(class, AsSet(gs)) then
#             return true;
#         fi;
#     od;
#     return false;
# end);


InstallMethod( ViewString,
"for a partial Jordan fusion",
[IsPartialJordanFusion and IsPartialStablePartitionRep],
function(pfus)
    return Concatenation("<partial Jordan fusion: ", String(pfus!.ppart), ">");
end);


# InstallImmediateMethod( IsCompletePartialStablePartition,
# "for a partial Jordan fusions",
# IsPartialJordanFusion,
# function(pfus)
#     if pfus!.varpart = [] then
#         return true;
#     elif Length(pfus!.varpart[1]) > pfus!.maxclasssize then
#         return true;
#     else
#         return false;
#     fi;
# end);





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
