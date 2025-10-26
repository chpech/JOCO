#############################################################################
##
##  arcregset.gi                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Implementation of arc regular sets 
##
#############################################################################
## Let R be a regular relation (symmetric or asymmetric) of a set V
## with o(u,v) we denote |{w | (u,w), (v,w) in R }|, and
## with i(u,v) we denote |{w | (w,u), (w,v) in R }|.
## in JOCO we call a set of colors arc-regular if 
##      - it is symmetric or asymmetric,
##      - it is regular,
##      - there is a number lbd such that for all (u,v) in R we have
##                 o(u,v) + i(u,v) = lbd.
##
## Arc regular sets may be enumerated in well-fibred J-stable color graphs.




InstallMethod(RegularSet,
"for arc regular sets",
[ IsRegularSet and IsJArcRegularSet, IsColorGraph, IsList ],
function(filter, cgr, set)
   local res;

    res:=RegularSet(IsRegularSet, cgr,set);
    SetIsJArcRegularSet(res,true);
    
    return res;
    
end);

InstallMethod(StableSetFromPartialStableSet,
"for a partial arc regular set in PartialJArcRegularSetRep",
[IsPartialJArcRegularSet and IsPartialJArcRegularSetRep],
function(cand)
    return RegularSet( IsRegularSet and IsJArcRegularSet, cand!.cgr, cand!.set);
end);

InstallMethod(OnRegularSets,
"for an arc regular set and a permutation",
[IsRegularSet and IsJArcRegularSet and IsColorSetRep, IsPerm],
function(gs, g)
    return RegularSet(IsRegularSet and IsJArcRegularSet, gs!.cgr, MakeImmutable(OnSets(gs!.set,g)));
end);

InstallMethod(ViewString,
"for an arc regular set",
[IsRegularSet and IsJArcRegularSet],
function(x) 
    return Concatenation("<", "JArcRegularSet: ", String(AsSet(x)), ">");
end);

InstallMethod(HomogeneousSymJArcRegularSetOrbits,
"for a J-stable color graph",
[IsColorGraph and IsJStableColorGraph],
function(cgr)
    local  g, iter, allgsorb;
    
    g:=JAlgebraicAutomorphismGroup(cgr);
    
    
    iter:=IteratorOfPartialStableSetOrbits(g, EmptySymPartialJArcRegularSet(cgr));
    allgsorb:=AllStableSetOrbits(iter);
    
    return allgsorb;
    
end);

InstallOtherMethod(HomogeneousSymJArcRegularSetOrbits,
"for a J-stable color graph and a permutation group",
[IsColorGraph and IsJStableColorGraph, IsPermGroup],
function(cgr,g)
    local  iter, allgsorb;
    
    iter:=IteratorOfPartialStableSetOrbits(g, EmptySymPartialJArcRegularSet(cgr));
    allgsorb:=AllStableSetOrbits(iter);
    
    return allgsorb;
    
end);

InstallMethod(HomogeneousAsymJArcRegularSetOrbits,
"for a J-stable color graph",
[IsColorGraph and IsJStableColorGraph],
function(cgr)
    local  g, iter, agsorbs;
    
    g:=JAlgebraicAutomorphismGroup(cgr);
    
    iter:=IteratorOfPartialStableSetOrbits(g,EmptyAsymPartialJArcRegularSet(cgr));
    
    agsorbs:=AllStableSetOrbits(iter);
    
    return agsorbs;
    
end);

InstallOtherMethod(HomogeneousAsymJArcRegularSetOrbits,
"for a J-stable color graph and a permutation group",
[IsColorGraph and IsJStableColorGraph, IsPermGroup],
function(cgr,g)
    local iter;
    
    iter:=IteratorOfPartialStableSetOrbits(g,EmptyAsymPartialJArcRegularSet(cgr));
    
    return AllStableSetOrbits(iter);
end);

InstallMethod(HomogeneousJArcRegularSetOrbits,
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
    lgs:=Set(HomogeneousSymJArcRegularSetOrbits(cgr));
    if not sym then
        lgs:=Union(lgs, HomogeneousAsymJArcRegularSetOrbits(cgr));
    fi;
    # if prim then
    #     lgs:=Filtered(lgs, x->ClosureSet(tensor, AsSet(Representative(x)))=[1..OrderOfTensor(tensor)]);
    # fi;
    
    return lgs;
end);

InstallOtherMethod(HomogeneousJArcRegularSetOrbits,
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
    lgs:=Set(HomogeneousSymJArcRegularSetOrbits(cgr,g));
    if not sym then
        lgs:=Union(lgs, HomogeneousAsymJArcRegularSetOrbits(cgr,g));
    fi;
    # if prim then
    #     lgs:=Filtered(lgs, x->ClosureSet(tensor, AsSet(Representative(x)))=[1..OrderOfTensor(tensor)]);
    # fi;
    
    return lgs;
end);

InstallMethod(IsJArcRegularSet,
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

        
