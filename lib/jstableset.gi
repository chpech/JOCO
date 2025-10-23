InstallMethod(RegularSet,
"for J-stable sets",
[ IsRegularSet and IsJStableSet, IsColorGraph, IsList ],
function(filter, cgr, set)
   local res;

    res:=RegularSet(IsRegularSet, cgr,set);
    SetIsJStableSet(res,true);
    
    
    return res;
    
end);
InstallTrueMethod(IsArcRegularSet, IsRegularSet and IsJStableSet);

InstallMethod(OnRegularSets,
"for a J-stable set and a permutation",
[IsRegularSet and IsJStableSet and IsColorSetRep, IsPerm],
function(gs, g)
    return RegularSet(IsRegularSet and IsJStableSet, gs!.cgr, MakeImmutable(OnSets(gs!.set,g)));
end);

InstallMethod(ViewString,
"for a J-stable set",
[IsRegularSet and IsArcRegularSet and IsJStableSet],
function(x) 
    return Concatenation("<", "JStableSet: ", String(AsSet(x)), ">");
end);


InstallMethod(IsJStableSet,
"for a color set",
[IsColorSet],
function(cset)
    local  cgr, t, set, iset, part;
    cgr:=UnderlyingCgrOfColorSet(cset);
    if not IsJStableColorGraph(cgr) then
        Error("only implemented for color sets of J-stable color graphs");
        return fail;
    fi;
    t:=JStructureConstantsOfColorGraph(cgr);
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
    
    part:=JStabil(t,part);
    if part <> fail then
        return true;
    fi;
    return false;
end);

              
InstallMethod(HomogeneousSymJStableSetOrbits,
"for a J-stable color graph",
[IsColorGraph and IsJStableColorGraph],
function(cgr)
    local  g, t, iter, act, grp, res, symarsets, sorb, rep, gs, stab, 
           gsorb;
    
    g:=JAlgebraicAutomorphismGroup(cgr);
    
    t:=JStructureConstantsOfColorGraph(cgr);
    
    if HasHomogeneousSymArcRegularSetOrbits(cgr) then
        return Filtered(HomogeneousSymArcRegularSetOrbits(cgr), x->IsJStableSet(Representative(x)));
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
        
        rep:=Representative(sorb);
        
        if IsCompletePartialStableSet(rep) then
            gs:=StableSetFromPartialStableSet(rep);
            if gs <> fail then 
                stab:=PreImage(act, StabilizerOfCanonicalRepresentative(sorb));
                gsorb:=ConstructorOfStableSetOrbit(gs)(grp,gs, stab);
                Add(symarsets,gsorb);
                if IsJStableSet(Representative(gsorb)) then
                    Add(res, gsorb);
                    Info(InfoCOCO,1,"*");
                fi;
            fi;
        fi;
    od;
    SetHomogeneousSymArcRegularSetOrbits(cgr,symarsets);
    
    return res;
end);

InstallMethod(HomogeneousAsymJStableSetOrbits,
"for a J-stable color graph",
[IsColorGraph and IsJStableColorGraph],
function(cgr)
    local  g, t, iter, act, grp, res, asymarsets, sorb, rep, gs, stab, 
           gsorb;
    
    g:=JAlgebraicAutomorphismGroup(cgr);
    
    t:=JStructureConstantsOfColorGraph(cgr);
    
    if HasHomogeneousAsymArcRegularSetOrbits(cgr) then
        return Filtered(HomogeneousAsymArcRegularSetOrbits(cgr), x->IsJStableSet(Representative(x)));
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
        
        rep:=Representative(sorb);
        
        if IsCompletePartialStableSet(rep) then
            gs:=StableSetFromPartialStableSet(rep);
            if gs <> fail then 
                stab:=PreImage(act, StabilizerOfCanonicalRepresentative(sorb));
                gsorb:=ConstructorOfStableSetOrbit(gs)(grp,gs, stab);
                Add(asymarsets,gsorb);
                if IsJStableSet(Representative(gsorb)) then
                    Add(res, gsorb);
                    Info(InfoCOCO,1,"*");
                fi;
            fi;
        fi;
    od;
    SetHomogeneousAsymArcRegularSetOrbits(cgr,asymarsets);
    
    return res;
end);

InstallMethod(HomogeneousJStableSetOrbits,
"for a J-stable color graph",
[IsColorGraph and IsJStableColorGraph],
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
    lgs:=Set(HomogeneousSymJStableSetOrbits(cgr));
    if not sym then
        lgs:=Union(lgs, HomogeneousAsymJStableSetOrbits(cgr));
    fi;
    # if prim then
    #     lgs:=Filtered(lgs, x->ClosureSet(tensor, AsSet(Representative(x)))=[1..OrderOfTensor(tensor)]);
    # fi;
    
    return lgs;
end);
