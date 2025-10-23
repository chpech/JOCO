
InstallMethod(RegularSet,
"for arc regular sets",
[ IsRegularSet and IsArcRegularSet, IsColorGraph, IsList ],
function(filter, cgr, set)
   local res;

    res:=RegularSet(IsRegularSet, cgr,set);
    SetIsArcRegularSet(res,true);
    
    return res;
    
end);

InstallMethod(StableSetFromPartialStableSet,
"for a partial arc regular set in PartialArcRegularSetRep",
[IsPartialArcRegularSet and IsPartialArcRegularSetRep],
function(cand)
    return RegularSet( IsRegularSet and IsArcRegularSet, cand!.cgr, cand!.set);
end);

InstallMethod(OnRegularSets,
"for an arc regular set and a permutation",
[IsRegularSet and IsArcRegularSet and IsColorSetRep, IsPerm],
function(gs, g)
    return RegularSet(IsRegularSet and IsArcRegularSet, gs!.cgr, MakeImmutable(OnSets(gs!.set,g)));
end);

InstallMethod(ViewString,
"for an arc regular set",
[IsRegularSet and IsArcRegularSet],
function(x) 
    return Concatenation("<", "ArcRegularSet: ", String(AsSet(x)), ">");
end);

InstallMethod(HomogeneousSymArcRegularSetOrbits,
"for a J-stable color graph",
[IsColorGraph and IsJStableColorGraph],
function(cgr)
    local  g, iter, allgsorb;
    
    g:=JAlgebraicAutomorphismGroup(cgr);
    
    
    iter:=IteratorOfPartialStableSetOrbits(g, EmptySymPartialArcRegularSet(cgr));
    allgsorb:=AllStableSetOrbits(iter);
    
    return allgsorb;
    
end);

InstallOtherMethod(HomogeneousSymArcRegularSetOrbits,
"for a J-stable color graph and a permutation group",
[IsColorGraph and IsJStableColorGraph, IsPermGroup],
function(cgr,g)
    local  iter, allgsorb;
    
    iter:=IteratorOfPartialStableSetOrbits(g, EmptySymPartialArcRegularSet(cgr));
    allgsorb:=AllStableSetOrbits(iter);
    
    return allgsorb;
    
end);

InstallMethod(HomogeneousAsymArcRegularSetOrbits,
"for a J-stable color graph",
[IsColorGraph and IsJStableColorGraph],
function(cgr)
    local  g, iter, agsorbs;
    
    g:=JAlgebraicAutomorphismGroup(cgr);
    
    iter:=IteratorOfPartialStableSetOrbits(g,EmptyAsymPartialArcRegularSet(cgr));
    
    agsorbs:=AllStableSetOrbits(iter);
    
    return agsorbs;
    
end);

InstallOtherMethod(HomogeneousAsymArcRegularSetOrbits,
"for a J-stable color graph and a permutation group",
[IsColorGraph and IsJStableColorGraph, IsPermGroup],
function(cgr,g)
    local iter;
    
    iter:=IteratorOfPartialStableSetOrbits(g,EmptyAsymPartialArcRegularSet(cgr));
    
    return AllStableSetOrbits(iter);
end);

InstallMethod(HomogeneousArcRegularSetOrbits,
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
    lgs:=Set(HomogeneousSymArcRegularSetOrbits(cgr));
    if not sym then
        lgs:=Union(lgs, HomogeneousAsymArcRegularSetOrbits(cgr));
    fi;
    # if prim then
    #     lgs:=Filtered(lgs, x->ClosureSet(tensor, AsSet(Representative(x)))=[1..OrderOfTensor(tensor)]);
    # fi;
    
    return lgs;
end);

InstallOtherMethod(HomogeneousArcRegularSetOrbits,
"for a J-stable color graph and a permutation group",
[IsColorGraph and IsJStableColorGraph, IsPermGroup],
function(cgr,g)
    local lgs,sym,prim;
    
    
    sym:=ValueOption("sym");
    if sym=fail then
        sym:=false;
    fi;
    # prim:=ValueOption("prim");
    # if prim=fail then
    #     prim:=false;
    # fi;
    lgs:=Set(HomogeneousSymArcRegularSetOrbits(cgr,g));
    if not sym then
        lgs:=Union(lgs, HomogeneousAsymArcRegularSetOrbits(cgr,g));
    fi;
    # if prim then
    #     lgs:=Filtered(lgs, x->ClosureSet(tensor, AsSet(Representative(x)))=[1..OrderOfTensor(tensor)]);
    # fi;
    
    return lgs;
end);

InstallMethod(IsArcRegularSet,
"for a regular set",
[IsRegularSet],
function(rset)
    local  cgr, set, m, iset, g, gor, lval, v, h, dom, hor, w, lx;
    
    cgr:=UnderlyingCgrOfColorSet(rset);
    set:=AsSet(rset);
    m:=ColorMates(cgr);
    iset:=OnSets(set,m);
    g:=KnownGroupOfAutomorphisms(cgr);
    gor:=StbcMinimalOrbitReps(Stbc(g),[1..OrderOfColorGraph(cgr)]);
    lval:=[];
    
    for v in gor do
        h:=Stabilizer(g,v,OnPoints);
        dom:=Neighbors(cgr,v,set);
        hor:=StbcMinimalOrbitReps(Stbc(h), dom);
        for w in hor do
            lx:=Intersection(dom, Neighbors(cgr,w,iset));
            AddSet(lval,Length(lx));
            if Length(lval)>1 then
                return false;
            fi;
        od;
    od;
    return true;
end);

        
