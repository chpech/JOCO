#############################################################################
##
##  jpartfus.gi                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Implementation of partial Jordan fusions 
##
#############################################################################

DeclareRepresentation( "IsPartialJordanFusionRep",
         IsPartialStablePartitionRep,
        [ "cgr",
          "ppart",
          "part", 
          "varpart",
          "maxclasssize",
        ]);

InstallMethod(RankOfPartialStablePartition,
"for partilal Jordan fusions in PartialJordanFusionRep",
[IsPartialJordanFusion and IsPartialJordanFusionRep],
function(ppart)
    return Length(ppart!.part.classes);
end);

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
    pjfus:= Objectify(NewType(PartialJordanFusionsFamily(cgr), IsPartialJordanFusion and IsPartialJordanFusionRep), obj);
    SetIsIrredundantPartialStablePartition(pjfus,true);
    SetIsCompletePartialStablePartition(pjfus,true);
    SetPartialStablePartitionHasSmallerBase(pjfus,false);
    return pjfus;
end);


InstallMethod(ExtendedPartialStablePartition,
"for a partial Jordan fusion in  PartialJordanFusionRep and a regular J-stable set",
[IsPartialJordanFusion and IsPartialJordanFusionRep, IsRegularSet and IsJStableSet],
function(pfusion,gs)
    local  tensor, rset, arset, i, class, lclass, npart, pos, nppart, obj, 
           nvarpart, npfusion;
    
    tensor:=JStructureConstantsOfColorGraph(pfusion!.cgr);
    
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
    if ForAny([1..i-1], j->Length(pfusion!.varpart[i]) <= Length(rset)) then
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
        npart:=JRefinedPartition(npart,gs);
        if npart=fail then
            return fail;
        fi;
        
        npart:=JStabil(tensor, npart, AsSet(gs));
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
    # else
    #     return fail;
    fi;
    npfusion:=Objectify(NewType(PartialJordanFusionsFamily(pfusion!.cgr), IsPartialJordanFusion and IsPartialJordanFusionRep), obj);
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
"for a partial Jordan fusion and a J-stable regular set",
[IsPartialJordanFusion and IsPartialJordanFusionRep, IsRegularSet and IsJStableSet],
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
"for a partial Jordan fusion",
[IsPartialJordanFusion and IsPartialJordanFusionRep],
function(pfus)
    return Concatenation("<partial Jordan fusion: ", String(pfus!.ppart), ">");
end);


InstallImmediateMethod( IsCompletePartialStablePartition,
"for a partial Jordan fusions",
IsPartialJordanFusion,
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
# Partial J-fusion orbits


InstallMethod(PartialJordanFusionOrbitsFamilyOp,
"for a color graph and a permutation group",
[IsColorGraph, IsPermGroup],
function(cgr,g)
    return NewFamily("PartialJordanFusionOrbitsFam", IsPartialStablePartitionOrbit);
end);

InstallMethod(GetPartialStablePartitionOrbitFamily,
"for a partial Jordan fusion in PartialJordanFusionRep and a permutation group",
[IsPartialJordanFusion and IsPartialJordanFusionRep, IsPermGroup],
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


InstallGlobalFunction(JRefinedPartition,
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

