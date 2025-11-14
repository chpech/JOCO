DeclareRepresentation( "IsPartialColorPartitionRep",
        IsPartialStablePartitionRep,
        [ "cgr",
          "ppart",
          "part", 
          "varpart",
          "maxclasssize",
        ]);


InstallMethod(ExtendedPartialStablePartition,
"for a partial color partition in  PartialColorPartitionRep and a color set",
[IsPartialColorPartition and IsPartialColorPartitionRep, IsColorSet],
function(pfusion,gs)
    local  cgr, rset, arset, i, class, lclass, npart, pos, nppart, obj, 
           nvarpart, npfusion, sset;
    
    cgr:=pfusion!.cgr;
    rset:=AsSet(gs);
    arset:=OnSets(rset, ColorMates(cgr));
    
    # when new slice starts, then rset can be its first element only if it is smaller than
    # arset
    if pfusion!.ppart = [] or Length(rset) > Length(Last(pfusion!.ppart)) then 
        if arset < rset then 
            return fail;
        fi;
    fi;
    
    # rset must be a subset of some variable class of ppart
    i:=First([1..Length(pfusion!.varpart)], j->IsSubset(pfusion!.varpart[j],rset));
    if i = fail then
        return fail;
    fi;
    class:=pfusion!.varpart[i];
    #########
    if ForAny([1..i-1], j->Length(pfusion!.varpart[j]) < Length(rset) 
                        or Length(pfusion!.varpart[j]) = Length(rset) 
                        and pfusion!.varpart[j] < rset)  
    then
        
       return fail;
    fi;
    
    # when new slice starts, then rset can be its first element only if it is smaller than
    # OnSets(rset, ColorMates(pfusion!.cgr))
    if Length(class) > Length(rset) and arset < rset then
        return fail;
    fi;
    
    # if arset <rset  then arset must come before rset in pfusion!.ppart
    # the two tests before for the situation that slice is new could be replaced by 
    # the following test, if it is placed n the beginning of the function
    # however, checking that arset is in pfusion!.ppart takes more time
    if arset < rset and not arset in pfusion!.ppart then
        return fail;
    fi;
    
    sset:=Intersection(class, Union(rset,arset));
    if class <> sset then 
        if Length(class)-Length(sset) < Length(rset) or
           Length(class)-Length(sset) = Length(rset) and Difference(class, sset) < rset then
            return fail;
        fi;
    fi;
    
    
    if pfusion!.ppart<>[] then
        lclass:=Last(pfusion!.ppart);
        if Length(rset) < Length(lclass) then
            return fail;
        fi;
        if Length(rset) = Length(lclass) and rset < lclass then
            return fail;
        fi;
        if Length(class) <> Length(sset) then
            if Length(class)-Length(sset) < Length(lclass) then
                return fail;
            fi;
            if Length(class) - Length(sset) = Length(lclass) and
               Difference(class, sset) < lclass then
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
        Add(nppart,rset);
        
        obj:=rec( cgr:=pfusion!.cgr,
                  ppart:=nppart,
                  part:=npart,
                  varpart:= pfusion!.varpart{Difference([1..Length(pfusion!.varpart)],[i])},
                  maxclasssize:=pfusion!.maxclasssize);
    else # lif Length(gs)<Length(class) or (Length(gs)=Length(class) and AsSet(gs)<=class) then
        npart:=WLShallowCopyStablePartition(pfusion!.part);
        npart:=RefinedInternalPartition(npart,gs);
        if npart=fail then
            return fail;
        fi;
        
        npart:=StabilizedInternalPartition(pfusion, gs, npart);
        if npart=fail then
            return fail;
        fi;
        
        nppart:=ShallowCopy(pfusion!.ppart);
        Add(nppart,rset);
        nvarpart:=ShortLexSorted(StructuralCopy(npart.classes{npart.variable}));
        nvarpart:=Filtered(nvarpart, x->not x[1] in ReflexiveColors(cgr));
                
        obj:=rec( cgr:=pfusion!.cgr,
                  ppart:=nppart,
                  part:=npart,
                  varpart:=nvarpart,
                  maxclasssize:=pfusion!.maxclasssize);
    fi;
    npfusion:=ConstructorOfPartialColorPartition(pfusion)(obj);
    
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
    elif Length(obj!.varpart[1]) = Length(rset) then  # at this point Length(rset)=Length(class)
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
    Assert(1, ForAll(npfusion!.ppart, x->ForAll(npfusion!.varpart, y->Length(x)<Length(y) 
                                                                  or Length(x)= Length(y) and x < y)));
    
    return npfusion;
end);


InstallMethod(IsCompatibleWithPartialStablePartition,
"for a partial color partition in PartialColorPartitionRep and a color set",
[IsPartialColorPartition and IsPartialColorPartitionRep, IsColorSet],
function(pfusion, gs)
    local class;
    
    for class in pfusion!.varpart do
        if IsSubset(class, AsSet(gs)) then
            return true;
        fi;
    od;
    return false;
end);

InstallMethod(RankOfPartialStablePartition,
"for partilal color partitions in PartialColorPartitionRep",
[IsPartialColorPartition and IsPartialColorPartitionRep],
function(ppart)
    return Length(ppart!.part.classes);
end);

##############################################################################
#
# internal partitions
#
##############################################################################
InstallGlobalFunction(RefinedInternalPartition,
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
    
end);

