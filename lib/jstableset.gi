InstallMethod(RegularSet,
"for J-stable sets",
[ IsRegularSet and IsJStableSet, IsColorGraph, IsList ],
function(filter, cgr, set)
   local res;

    res:=RegularSet(IsRegularSet, cgr,set);
    SetIsJStableSet(res,true);
    
    
    return res;
    
end);
InstallTrueMethod(IsJArcRegularSet, IsRegularSet and IsJStableSet);

InstallMethod(OnRegularSets,
"for a J-stable set and a permutation",
[IsRegularSet and IsJStableSet and IsColorSetRep, IsPerm],
function(gs, g)
    return RegularSet(IsRegularSet and IsJStableSet, gs!.cgr, MakeImmutable(OnSets(gs!.set,g)));
end);

InstallMethod(ViewString,
"for a J-stable set",
[IsRegularSet and IsJArcRegularSet and IsJStableSet],
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
    
    if HasHomogeneousSymJArcRegularSetOrbits(cgr) then
        return Filtered(HomogeneousSymJArcRegularSetOrbits(cgr), x->IsJStableSet(Representative(x)));
    else
        iter:=IteratorOfPartialStableSetOrbits(g, EmptySymPartialJArcRegularSet(cgr));
    fi;
    act:= ActionOfPartialStableSetOrbitIterator(iter);
    if act = fail then 
        return fail;
    fi;
    grp:=Source(act);

        
    res:=[];
    symarsets:=[];
    
    Info(InfoJOCO,1,"Computing orbits of symmetric J-stable sets.\n");
    
    for sorb in iter do
        if iter!.state<>fail and Length(iter!.state.M)<=COCOInfoGSSize then
            Info(InfoJOCO,2,iter!.state.M,"\n");
        fi;
        
        rep:=Representative(sorb);

        if IsCompletePartialStableSet(rep) then
            gs:=StableSetFromPartialStableSet(rep);
            if gs <> fail then 
                stab:=PreImage(act, StabilizerOfCanonicalRepresentative(sorb));
                gsorb:=ConstructorOfStableSetOrbit(gs)(grp,gs, stab);
                Add(symarsets,gsorb);
                if IsJStableSet(Representative(gsorb)) then
                    Add(res, gsorb);
                    Info(InfoJOCO,1,"*");
                fi;
            fi;
        fi;
    od;
    Info(InfoJOCO,1,"\nDone computing orbits of symmetric J-stable sets.\n");
    SetHomogeneousSymJArcRegularSetOrbits(cgr,symarsets);
    
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
    
    if HasHomogeneousAsymJArcRegularSetOrbits(cgr) then
        return Filtered(HomogeneousAsymJArcRegularSetOrbits(cgr), x->IsJStableSet(Representative(x)));
    else
        iter:=IteratorOfPartialStableSetOrbits(g, EmptyAsymPartialJArcRegularSet(cgr));
    fi;
    act:= ActionOfPartialStableSetOrbitIterator(iter);
    if act = fail then 
        return fail;
    fi;
    grp:=Source(act);

        
    res:=[];
    asymarsets:=[];
    
    Info(InfoJOCO,1,"Computing orbits of asymmetric J-stable sets.\n");
    for sorb in iter do
        if iter!.state<>fail and Length(iter!.state.M)<=COCOInfoGSSize then
            Info(InfoJOCO,2,iter!.state.M,"\n");
        fi;

        rep:=Representative(sorb);
        
        if IsCompletePartialStableSet(rep) then
            gs:=StableSetFromPartialStableSet(rep);
            if gs <> fail then 
                stab:=PreImage(act, StabilizerOfCanonicalRepresentative(sorb));
                gsorb:=ConstructorOfStableSetOrbit(gs)(grp,gs, stab);
                Add(asymarsets,gsorb);
                if IsJStableSet(Representative(gsorb)) then
                    Add(res, gsorb);
                    Info(InfoJOCO,1,"*");
                fi;
            fi;
        fi;
    od;
    Info(InfoJOCO,1,"\nDone computing orbits of asymmetric J-stable sets.\n");
    SetHomogeneousAsymJArcRegularSetOrbits(cgr,asymarsets);
    
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
