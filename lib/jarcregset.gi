#############################################################################
##
##  jarcregset.gi                 JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Implementation of J-arc regular sets 
##
#############################################################################




InstallMethod(RegularSet,
"for J-arc regular sets",
[ IsRegularSet and IsJArcRegularSet, IsColorGraph, IsList ],
function(filter, cgr, set)
   local res;

    res:=RegularSet(IsRegularSet, cgr,set);
    SetIsJArcRegularSet(res,true);
    
    return res;
    
end);

InstallMethod(StableSetFromPartialStableSet,
"for a partial J-arc regular set in PartialJArcRegularSetRep",
[IsPartialJArcRegularSet and IsPartialJArcRegularSetRep],
function(cand)
    return RegularSet( IsRegularSet and IsJArcRegularSet, cand!.cgr, cand!.set);
end);

InstallMethod(OnRegularSets,
"for a J-arc regular set and a permutation",
[IsRegularSet and IsJArcRegularSet and IsColorSetRep, IsPerm],
function(gs, g)
    return RegularSet(IsRegularSet and IsJArcRegularSet, gs!.cgr, MakeImmutable(OnSets(gs!.set,g)));
end);

InstallMethod(ViewString,
"for a J-arc regular set",
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
    local  cgr, set, m, iset, g, gor, lval, v, h, domx, domy, hor, w, 
           lx, ly;
    
    cgr:=UnderlyingCgrOfColorSet(rset);
    set:=AsSet(rset);
    m:=ColorMates(cgr);
    iset:=OnSets(set,m);
    g:=KnownGroupOfAutomorphisms(cgr);
    gor:=StbcMinimalOrbitReps(Stbc(g),[1..OrderOfColorGraph(cgr)]);
    lval:=[];
    
    for v in gor do
        h:=Stabilizer(g,v,OnPoints);
        domx:=Neighbors(cgr,v,set);
        domy:=Neighbors(cgr,v,iset);
        hor:=StbcMinimalOrbitReps(Stbc(h), domx);
        for w in hor do
            lx:=Intersection(domx, Neighbors(cgr,w,set));
            ly:=Intersection(domy, Neighbors(cgr,w,iset));
            AddSet(lval,Length(lx)+Length(ly));
            if Length(lval)>1 then
                return false;
            fi;
        od;
    od;
    return true;
end);

        
