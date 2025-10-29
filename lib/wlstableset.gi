InstallMethod(RegularSet,
"for WL-stable sets",
[ IsRegularSet and IsWLStableSet, IsColorGraph, IsList ],
function(filter, cgr, set)
   local res;

    res:=RegularSet(IsRegularSet, cgr,set);
    SetIsWLStableSet(res,true);
    
    
    return res;
    
end);
InstallTrueMethod(IsArcRegularSet, IsRegularSet and IsWLStableSet);
InstallTrueMethod(IsJArcRegularSet, IsRegularSet and IsWLStableSet);
InstallTrueMethod(IsJStableSet, IsRegularSet and IsWLStableSet);

InstallMethod(OnRegularSets,
"for a WL-stable set and a permutation",
[IsRegularSet and IsWLStableSet and IsColorSetRep, IsPerm],
function(gs, g)
    return RegularSet(IsRegularSet and IsWLStableSet, gs!.cgr, MakeImmutable(OnSets(gs!.set,g)));
end);

InstallMethod(ViewString,
"for a WL-stable set",
[IsRegularSet and IsArcRegularSet and IsWLStableSet],
function(x) 
    return Concatenation("<", "WLStableSet: ", String(AsSet(x)), ">");
end);


InstallMethod(IsWLStableSet,
"for a color set",
[IsColorSet],
function(cset)
    local  cgr, t, set, iset, part;
    cgr:=UnderlyingCgrOfColorSet(cset);
    if not IsWLStableColorGraph(cgr) then
        Error("only implemented for color sets of WL-stable color graphs");
        return fail;
    fi;
    t:=StructureConstantsOfColorGraph(cgr);
    set:=AsSet(cset);
    iset:=OnSets(set,ColorMates(cgr));
    
    if iset = set then
        part:=WLBuildSymGoodSetPartition(t,set);
    elif Intersection(iset,set)=[] then
        part:=WLBuildAsymGoodSetPartition(t,[set,iset]);
    else
        Error("cset should be either symmetric or asymmetric!");
        return fail;
    fi;
    
    part:=WLStabil(t,part);
    if part <> fail then
        return true;
    fi;
    return false;
end);

              
InstallMethod(HomogeneousSymWLStableSetOrbits,
"for a WL-stable color graph",
[IsColorGraph and IsWLStableColorGraph],
function(cgr)
    local  g, t, iter, act, grp, res, symarsets, sorb, rep, gs, stab, 
           gsorb;
    
    g:=AlgebraicAutomorphismGroup(cgr);
    
    t:=StructureConstantsOfColorGraph(cgr);
    
    if HasHomogeneousSymArcRegularSetOrbits(cgr) then
        return Filtered(HomogeneousSymArcRegularSetOrbits(cgr), x->IsWLStableSet(Representative(x)));
    else
        iter:=IteratorOfPartialStableSetOrbits(g, EmptySymPartialArcRegularSet(cgr));
    fi;
    act:= ActionOfPartialStableSetOrbitIterator(iter);
    if act = fail then 
        return fail;
    fi;
    grp:=Source(act);

        
    res:=[];
    symarsets:=[];
    
    for sorb in iter do
        if iter!.state<>fail and Length(iter!.state.M)<=COCOInfoGSSize then
            Info(InfoCOCO,1,iter!.state.M,"\n");
        fi;
        
        rep:=Representative(sorb);

        if IsCompletePartialStableSet(rep) then
            gs:=StableSetFromPartialStableSet(rep);
            if gs <> fail then 
                stab:=PreImage(act, StabilizerOfCanonicalRepresentative(sorb));
                gsorb:=ConstructorOfStableSetOrbit(gs)(grp,gs, stab);
                Add(symarsets,gsorb);
                if IsWLStableSet(Representative(gsorb)) then
                    Add(res, gsorb);
                    Info(InfoCOCO,1,"*");
                fi;
            fi;
        fi;
    od;
    SetHomogeneousSymArcRegularSetOrbits(cgr,symarsets);
    
    return res;
end);

InstallMethod(HomogeneousAsymWLStableSetOrbits,
"for a WL-stable color graph",
[IsColorGraph and IsWLStableColorGraph],
function(cgr)
    local  g, t, iter, act, grp, res, asymarsets, sorb, rep, gs, stab, 
           gsorb;
    
    g:=AlgebraicAutomorphismGroup(cgr);
    
    t:=StructureConstantsOfColorGraph(cgr);
    
    if HasHomogeneousAsymArcRegularSetOrbits(cgr) then
        return Filtered(HomogeneousAsymArcRegularSetOrbits(cgr), x->IsWLStableSet(Representative(x)));
    else
        iter:=IteratorOfPartialStableSetOrbits(g, EmptyAsymPartialArcRegularSet(cgr));
    fi;
    act:= ActionOfPartialStableSetOrbitIterator(iter);
    if act = fail then 
        return fail;
    fi;
    grp:=Source(act);

        
    res:=[];
    asymarsets:=[];
    
    for sorb in iter do
        if iter!.state<>fail and Length(iter!.state.M)<=COCOInfoGSSize then
            Info(InfoCOCO,1,iter!.state.M,"\n");
        fi;

        rep:=Representative(sorb);
        
        if IsCompletePartialStableSet(rep) then
            gs:=StableSetFromPartialStableSet(rep);
            if gs <> fail then 
                stab:=PreImage(act, StabilizerOfCanonicalRepresentative(sorb));
                gsorb:=ConstructorOfStableSetOrbit(gs)(grp,gs, stab);
                Add(asymarsets,gsorb);
                if IsWLStableSet(Representative(gsorb)) then
                    Add(res, gsorb);
                    Info(InfoCOCO,1,"*");
                fi;
            fi;
        fi;
    od;
    SetHomogeneousAsymArcRegularSetOrbits(cgr,asymarsets);
    
    return res;
end);

InstallMethod(HomogeneousWLStableSetOrbits,
"for a WL-stable color graph",
[IsColorGraph and IsWLStableColorGraph],
function(cgr)
    local g,lgs,sym,prim;
    
    
    sym:=ValueOption("sym");
    if sym=fail then
        sym:=false;
    fi;
    # prim:=ValueOption("prim");
    # if prim=fail then
    #     prim:=false;
    # fi;
    lgs:=Set(HomogeneousSymWLStableSetOrbits(cgr));
    if not sym then
        lgs:=Union(lgs, HomogeneousAsymWLStableSetOrbits(cgr));
    fi;
    # if prim then
    #     lgs:=Filtered(lgs, x->ClosureSet(tensor, AsSet(Representative(x)))=[1..OrderOfTensor(tensor)]);
    # fi;
    
    return lgs;
end);
