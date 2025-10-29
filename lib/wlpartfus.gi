#############################################################################
##
##  wlpartfus.gi                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Implementation of partial WL-stable  fusions 
##
#############################################################################

DeclareRepresentation( "IsPartialWLFusionRep",
         IsPartialStablePartitionRep,
        [ "cgr",
          "ppart",
          "part", 
          "varpart",
          "maxclasssize",
        ]);

InstallMethod(RankOfPartialStablePartition,
"for partilal WL-stable fusions in PartialWLFusionRep",
[IsPartialWLFusion and IsPartialWLFusionRep],
function(ppart)
    return Length(ppart!.part.classes);
end);

InstallMethod(PartialWLFusionsFamily,
"for a color graph",
[IsColorGraph],
function(cgr)
   local fam;
   fam:=NewFamily("PartialWLFusionsFam", IsPartialWLFusion);
   return fam;
end);

InstallMethod(EmptyPartialWLFusion,
"for a WL-stable color graph and an integer",
[IsColorGraph and IsWLStableColorGraph, IsInt],
function(cgr,maxclasssize)
    local  tensor, part, varpart, obj, pjfus;
    
    tensor:=StructureConstantsOfColorGraph(cgr);
    
    part:=WLBuildTrivialPartition(tensor);
    varpart:=ShortLexSorted(StructuralCopy(part.classes{part.variable}));
    varpart:=Filtered(varpart, x->not x[1] in ReflexiveColors(tensor));
    
    obj:=rec( cgr:=cgr,
              ppart:=[],
              part:=part,
              varpart:=varpart,
              maxclasssize:=maxclasssize
              );
    pjfus:= Objectify(NewType(PartialWLFusionsFamily(cgr), IsPartialWLFusion and IsPartialWLFusionRep), obj);
    SetIsIrredundantPartialStablePartition(pjfus,true);
    SetIsCompletePartialStablePartition(pjfus,true);
    SetPartialStablePartitionHasSmallerBase(pjfus,false);
    return pjfus;
end);


InstallMethod(ExtendedPartialStablePartition,
"for a partial WL stable fusion in  PartialWLFusionRep and a regular WL-stable set",
[IsPartialWLFusion and IsPartialWLFusionRep, IsRegularSet and IsWLStableSet],
function(pfusion,gs)
    local  tensor, rset, arset, i, class, lclass, npart, pos, nppart, obj, 
           nvarpart, npfusion;
    
    tensor:=StructureConstantsOfColorGraph(pfusion!.cgr);
    
    rset:=AsSet(gs);
    arset:=OnSets(rset, ColorMates(pfusion!.cgr));
    
        

    # when new slice starts, then rset can be its first element only if it is smaller than
    # OnSets(rset, ColorMates(pfusion!.cgr))
    if pfusion!.ppart = [] or Length(rset) > Length(Last(pfusion!.ppart)) then 
        if arset < rset then 
            return fail;
        fi;
    fi;
    
            
    
    i:=First([1..Length(pfusion!.varpart)], j->IsSubset(pfusion!.varpart[j],rset));
    if i = fail then
        return fail;
    fi;
    
    
    class:=pfusion!.varpart[i];
    if ForAny([1..i-1], j->Length(pfusion!.varpart[j]) <= Length(rset)) then
       return fail;
    fi;
    
    # when new slice starts, then rset can be its first element only if it is smaller than
    # OnSets(rset, ColorMates(pfusion!.cgr))
    if Length(class) > Length(rset) and arset < rset then
        return fail;
    fi;
    
    
    # if the mate of rset is smaller then its mate must come before in pfusion!.ppart
    # the two tests before for the situation that slice is new could be replaced by 
    # the following test, if it is placed n the beginning of the function
    # however, checking that arset is in pfusion!.ppart takes more time
    if arset < rset and not arset in pfusion!.ppart then
        return fail;
    fi;
        
    if pfusion!.ppart<>[] then
        lclass:=Last(pfusion!.ppart);
        if Length(rset) < Length(lclass) then
            return fail;
        fi;
        if Length(rset) = Length(lclass) and rset < lclass then
            return fail;
        fi;
        if Length(class) <> Length(rset) then
            if Length(class)-Length(rset) < Length(lclass) then
                return fail;
            fi;
            if Length(class) - Length(rset) = Length(lclass) and
               Difference(class, rset) < lclass then
                return fail;
            fi;
        fi;
    fi;

    
    if class = rset then
        npart:=WLShallowCopyStablePartition(pfusion!.part);
        pos:=Position(npart.classes,rset);
        AddSet(npart.fixed, pos);
        RemoveSet(npart.variable,pos);
        nppart:=ShallowCopy(pfusion!.ppart);
        Add(nppart,AsSet(gs));
        obj:=rec( cgr:=pfusion!.cgr,
                  ppart:=nppart,
                  part:=npart,
                  varpart:= pfusion!.varpart{Difference([1..Length(pfusion!.varpart)],[i])},
                  maxclasssize:=pfusion!.maxclasssize);
    else # lif Length(gs)<Length(class) or (Length(gs)=Length(class) and AsSet(gs)<=class) then
        npart:=WLShallowCopyStablePartition(pfusion!.part);
        npart:=WLRefinedPartition@JOCO(npart,gs);
        if npart=fail then
            return fail;
        fi;
        
        npart:=WLStabil(tensor, npart, AsSet(gs));
        if npart=fail then
            return fail;
        fi;
        
        nppart:=ShallowCopy(pfusion!.ppart);
        Add(nppart,rset);
        nvarpart:=ShortLexSorted(StructuralCopy(npart.classes{npart.variable}));
        nvarpart:=Filtered(nvarpart, x->not x[1] in ReflexiveColors(pfusion!.cgr));
                
        obj:=rec( cgr:=pfusion!.cgr,
                  ppart:=nppart,
                  part:=npart,
                  varpart:=nvarpart,
                  maxclasssize:=pfusion!.maxclasssize);
    fi;
    npfusion:=Objectify(NewType(PartialWLFusionsFamily(pfusion!.cgr), IsPartialWLFusion and IsPartialWLFusionRep), obj);
    if Length(rset) < Length(class) then
        SetIsIrredundantPartialStablePartition(npfusion,true);
        SetPartialStablePartitionHasSmallerBase(npfusion,false);
        if Length(class)-Length(rset) > Length(rset) then
            SetIsCompletePartialStablePartition(npfusion,true);
        else
            SetIsCompletePartialStablePartition(npfusion,false);
        fi;
    elif obj!.varpart = [] then 
        SetIsCompletePartialStablePartition(npfusion,true);
        SetIsIrredundantPartialStablePartition(npfusion,false);
        SetPartialStablePartitionHasSmallerBase(npfusion,
           IsCompletePartialStablePartition(pfusion) 
           or PartialStablePartitionHasSmallerBase(pfusion));
    elif Length(obj!.varpart[1]) = Length(rset) then 
        SetIsCompletePartialStablePartition(npfusion,false);
        SetIsIrredundantPartialStablePartition(npfusion,false);
        SetPartialStablePartitionHasSmallerBase(npfusion,
           IsCompletePartialStablePartition(pfusion) 
           or PartialStablePartitionHasSmallerBase(pfusion));
    else  
        SetIsCompletePartialStablePartition(npfusion,true);
        SetIsIrredundantPartialStablePartition(npfusion,false);
        SetPartialStablePartitionHasSmallerBase(npfusion,
           IsCompletePartialStablePartition(pfusion) 
           or PartialStablePartitionHasSmallerBase(pfusion));
    fi;
        
    Assert(1, OnSetsSets(Set(npfusion!.part.classes),ColorMates(npfusion!.cgr))=Set(npfusion!.part.classes));
    return npfusion;
end);

InstallMethod(IsCompatibleWithPartialStablePartition,
"for a partial WL-stable fusion and a WL-stable regular set",
[IsPartialWLFusion and IsPartialWLFusionRep, IsRegularSet and IsWLStableSet],
function(pfusion, gs)
    local class;
    
    for class in pfusion!.varpart do
        if IsSubset(class, AsSet(gs)) then
            return true;
        fi;
    od;
    return false;
end);


InstallMethod( ViewString,
"for a partial WL-stable fusion",
[IsPartialWLFusion and IsPartialWLFusionRep],
function(pfus)
    return Concatenation("<partial WL-stable fusion: ", String(pfus!.ppart), ">");
end);


InstallImmediateMethod( IsCompletePartialStablePartition,
"for a partial WL-stable fusions",
IsPartialWLFusion,
function(pfus)
    if pfus!.varpart = [] then
        return true;
    elif Length(pfus!.varpart[1]) > pfus!.maxclasssize then
        return true;
    else
        return false;
    fi;
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
[IsPartialWLFusion and IsPartialWLFusionRep, IsPermGroup],
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


# this is the same as JRefinedPartition
InstallGlobalFunction(WLRefinedPartition@JOCO,
function(newPart,gs)
    local  repart, M, iM, res;
    repart:=function(newPart,u,fix)
        local   i,  newclass;
        i:=1;
        while i<=Length(newPart.variable) and
          not IsSubset(WLPartitionClass(newPart,newPart.variable[i]),u) do
            i:=i+1;
        od;
        if i > Length(newPart.variable) then
            return fail;
        fi;

        i:=newPart.variable[i];
        if WLPartitionClass(newPart,i)=u then
            if fix then
                RemoveSet(newPart.variable,i);
                AddSet(newPart.fixed,i);
            fi;
            WLInstabilQueueAdd(newPart,i);

            return newPart;
        fi;
        newclass:=Difference(WLPartitionClass(newPart,i), u);
        if Length(newclass)<Length(u)  then
            return fail;
        fi;
        if fix and Length(newclass)=Length(u) and newclass<u then
            return fail;
        fi;

        newPart.classes[i]:=newclass;
        WLInstabilQueueAdd(newPart,i);
        Add(newPart.classes,u);
        if fix then
            AddSet(newPart.fixed, Length(newPart.classes));
        else
            AddSet(newPart.variable,Length(newPart.classes));
        fi;


        newPart.instabilFlags[Length(newPart.classes)]:=false;
        newPart.totestFlags[Length(newPart.classes)]:=false;
        WLInstabilQueueAdd(newPart, Length(newPart.classes));
        return newPart;
    end;
    
    M:=AsSet(gs);
    iM:=OnSets(M,ColorMates(UnderlyingCgrOfColorSet(gs)));
    
    res:=repart(newPart,M,true);
    if res=fail then
        return fail;
    fi;
    
    
    if iM>M then
        res:=repart(res,iM,false);
        if res=fail then
            return fail;
        fi;
    fi;
    
    return res;
    
    # M:=AsSet(gs);
    
    # return repart(newPart,M,true);
end);
