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
"for a stable rainbow and an integer and an integer",
[IsColorGraph and IsRainbow and IsStableRainbow, IsInt],
function(cgr,maxclasssize)
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
              maxclasssize:=maxclasssize
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

# InstallMethod(ExtendedPartialStablePartition,
# "for a partial regular fusion and a regular set",
# [IsPartialRegularFusion and IsPartialColorPartitionRep, IsRegularSet],
# function(pfusion,gs)
#     local  vdomain, rset, arset, i, lclass, npart, pos, nppart, obj, ppart, 
#            part, varpart, maxclasssize, nvarpart, npfusion;
    
#     rset:=AsSet(gs);
#     arset:=OnSets(rset, ColorMates(pfusion!.cgr));
    
    
#     # when new slice starts, then rset can be its first element only if it is smaller than
#     # OnSets(rset, ColorMates(pfusion!.cgr))
#     if pfusion!.ppart = [] or Length(rset) > Length(Last(pfusion!.ppart)) then 
#         if arset < rset then 
#             return fail;
#         fi;
#     fi;
    
    
#     i:=First([1..Length(pfusion!.varpart)], j->IsSubset(pfusion!.varpart[j],rset));
#     if i = fail then
#         return fail;
#     fi;
    
#     vdomain:=pfusion!.varpart[i];
    
#     if ForAny([1..i-1], j->Length(pfusion!.varpart[j]) <= Length(rset)) then
#        return fail;
#     fi;
    
#      # when new slice starts, then rset can be its first element only if it is smaller than
#     # OnSets(rset, ColorMates(pfusion!.cgr))
#     if Length(vdomain) > Length(rset) and arset < rset then
#         return fail;
#     fi;
    
    
#     # if the mate of rset is smaller then its mate must come before in pfusion!.ppart
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
#         if Length(vdomain) <> Length(rset) then
#             if Length(vdomain)-Length(rset) < Length(lclass) then
#                 return fail;
#             fi;
#             if Length(vdomain) - Length(rset) = Length(lclass) and
#                Difference(vdomain, rset) < lclass then
#                 return fail;
#             fi;
#         fi;
#     fi;
    
            
#     if vdomain =rset then
#         npart:=WLShallowCopyStablePartition(pfusion!.part);
#         pos:=Position(npart.classes,rset);
#         AddSet(npart.fixed, pos);
#         RemoveSet(npart.variable,pos);
#         nppart:=ShallowCopy(pfusion!.ppart);
#         Add(nppart,AsSet(gs));
        
#         obj:=rec( cgr:=pfusion!.cgr,
#                   ppart:=nppart,
#                   part:=npart,
#                   varpart:=pfusion!.varpart{[2..Length(pfusion!.varpart)]},
#                   maxclasssize:=pfusion!.maxclasssize);
#     else
#         npart:=WLShallowCopyStablePartition(pfusion!.part);
#         npart:=RRefinedPartition(npart,gs);
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
#     fi;
#     npfusion:=Objectify(NewType(PartialRegularFusionsFamily(pfusion!.cgr), IsPartialRegularFusion and IsPartialColorPartitionRep), obj);
#     if Length(rset) < Length(vdomain) then
#         SetIsIrredundantPartialStablePartition(npfusion,true);
#         SetPartialStablePartitionHasSmallerBase(npfusion,false);
#         if Length(vdomain)-Length(rset) > Length(rset) then
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
#     elif Length(obj!.varpart[1]) = Length(rset) then 
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
        
#     #    Assert(1, OnSetsSets(Set(npfusion!.part.classes),Mates(npfusion!.tensor))=Set(npfusion!.part.classes));
#     return npfusion;
    
# end);

# InstallMethod(IsCompatibleWithPartialStablePartition,
# "for a partial regular fusion and a regular set",
#         [IsPartialRegularFusion and IsPartialColorPartitionRep, IsRegularSet],
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
"for a partial regular fusion",
[IsPartialRegularFusion and IsPartialColorPartitionRep],
function(pfus)
    return Concatenation("<partial regular fusion: ", String(pfus!.ppart), ">");
end);

# InstallImmediateMethod( IsCompletePartialStablePartition,
# "for a partial regular fusion",
# IsPartialRegularFusion,
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


# InstallGlobalFunction(RRefinedPartition,
# function(newPart,gs)
#     local   repart,  T,  M,  res,  iM,xres;
#     repart:=function(newPart,u,fix)
#         local   i,  newclass;
#         i:=1;
#         while i<=Length(newPart.variable) and
#           not IsSubset(WLPartitionClass(newPart,newPart.variable[i]),u) do
#             i:=i+1;
#         od;
#         if i > Length(newPart.variable) then
#             return fail;
#         fi;

#         i:=newPart.variable[i];
#         if WLPartitionClass(newPart,i)=u then
#             if fix then
#                 RemoveSet(newPart.variable,i);
#                 AddSet(newPart.fixed,i);
#             fi;
#             WLInstabilQueueAdd(newPart,i);

#             return newPart;
#         fi;
#         newclass:=Difference(WLPartitionClass(newPart,i), u);
#         if Length(newclass)<Length(u)  then
#             return fail;
#         fi;
#         if fix and Length(newclass)=Length(u) and newclass<u then
#             return fail;
#         fi;

#         newPart.classes[i]:=newclass;
#         WLInstabilQueueAdd(newPart,i);
#         Add(newPart.classes,u);
#         if fix then
#             AddSet(newPart.fixed, Length(newPart.classes));
#         else
#             AddSet(newPart.variable,Length(newPart.classes));
#         fi;


#         newPart.instabilFlags[Length(newPart.classes)]:=false;
#         newPart.totestFlags[Length(newPart.classes)]:=false;
#         WLInstabilQueueAdd(newPart, Length(newPart.classes));
#         return newPart;
#     end;
    
    
#     M:=AsSet(gs);
#     iM:=OnSets(M,ColorMates(UnderlyingCgrOfColorSet(gs)));

#     res:=repart(newPart,M,true);
#     if res=fail then
#         return fail;
#     fi;


#     if iM>M then
#         res:=repart(res,iM,false);
#         if res=fail then
#             return fail;
#         fi;
#     fi;

#     return res;
# end);

InstallMethod(StabilizedInternalPartition,
"for a partial ragular fusion, a regular set and an internal partition",
[IsPartialRegularFusion, IsRegularSet, IsRecord],
function(pfus,gs,part)
    return part;
end);
