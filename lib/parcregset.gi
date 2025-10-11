DeclareRepresentation("IsPartialArcRegularSetRep",
        IsPartialStableSetRep,
        [ "cgr",
          "map",
          "imap",
          "domain",
          "set",
          "maxlength",
          "square"
          ]);

InstallMethod(PartialArcRegularSetsFamily,
"for color graphs",
[IsColorGraph],
function(cgr)
   local fam;
   fam:=NewFamily("PartialArcRegularSetsFam", IsPartialArcRegularSet);
   return fam;
end);

InstallMethod(PartialArcRegularSetOrbitFamilyOp,
        "for color graphs and permutation groups",
        [IsColorGraph, IsPermGroup],
function(cgr,g)
    return NewFamily("PartialArcRegularSetOrbitFam", IsPartialStableSetOrbit);
end);

InstallMethod(GetPartialStableSetOrbitFamily,
"for partial arc regular sets in PartialArcRegularSetRep and a permutation group",
[IsPartialArcRegularSet and IsPartialArcRegularSetRep, IsPermGroup],
function(prset,grp)  
    return PartialArcRegularSetOrbitFamily(prset!.cgr,grp);
end);

InstallMethod( ViewString,
        "for partial arc regular sets in PartialArcRegularSetRep",
        [IsPartialArcRegularSet and IsPartialArcRegularSetRep],
function(prs)
    local cgr,s,res;
    
    cgr:=prs!.cgr;
    s:=prs!.set;

    res:="<";
    if s<>[] and not s[1]^ColorMates(cgr) in s then
        Append(res,"antisymmetric ");
    else
        Append(res,"symmetric ");
    fi;

    return Concatenation(res,"partial arc regular set ", String(s), ">");
end);


InstallMethod(IsCompletePartialStableSet,
    "for partial arc regular sets in PartialArcRegularSetRep",
    [IsPartialArcRegularSet and IsPartialArcRegularSetRep],
function(pgs)
    local set,sqr;
    
    set:=pgs!.set;
    
    if set = [] then
        return false;
    fi;

    sqr:=pgs!.square;
    if Length(set)>1 and ForAny([2..Length(set)], i->sqr[set[1]]<>sqr[set[i]]) then
        return false;
    fi;
    return true;
end);

InstallMethod(ExtendedPartialStableSet,
"for symmetric partial arc regular sets in PartialArcRegularSetRep",
[IsSymPartialArcRegularSet and IsPartialArcRegularSetRep, IsPosInt],
function(cand,pt)
    local tensor,ndom,obj,ent,sq,mates,i;
    
    mates:=cand!.imap[pt];
    if Length(cand!.set) + Length(mates) > cand!.maxlength then
        return fail;
    fi;
    
    tensor:=JStructureConstantsOfColorGraph(cand!.cgr);
    if not IsTensorRep(tensor) then
        Error("this is not supposed to happen");
    fi;
    
    ent:=tensor!.entries;
    sq:=ShallowCopy(cand!.square);
    for i in cand!.set do
        sq:=sq+2*ent[i][mates[1]];
#        sq:=sq+ent[mates[1]][i];
    od;
    sq:=sq+ent[mates[1]][mates[1]];
    if Length(mates)=2 then
        for i in cand!.set do
            sq:=sq + 2*ent[i][mates[2]];
#            sq:=sq+ent[mates[2]][i];
        od;
        sq:=sq + 2*ent[mates[1]][mates[2]];
#        sq:=sq+ent[mates[2]][mates[1]];
        sq:=sq+ent[mates[2]][mates[2]];
    fi;
   
    if Length(cand!.set) + Length(mates) = cand!.maxlength then
        ndom := [];
    else
        ndom:=Filtered(cand!.domain, x->x>pt);
    fi;
    

    obj:=rec(
              cgr:=cand!.cgr,
              map:=cand!.map,
              imap:=cand!.imap,
              domain:=ndom,
              set:=Union(cand!.set,mates),
              maxlength:=cand!.maxlength,
              square:=sq);
    
    return Objectify(NewType(PartialArcRegularSetsFamily(cand!.cgr), IsSymPartialArcRegularSet and IsPartialArcRegularSetRep), obj);
end);

InstallMethod(EmptySymPartialArcRegularSet,
        "for regular j-stable color graphs",
        [IsColorGraph and IsJStableColorGraph and IsRegularColorGraph],
function(cgr)
    local aaut,rclr,clr,sclr,aclr,imap,map, i, j,act,cand;
   
    rclr:=ReflexiveColors(cgr);
    clr:=Difference([1..RankOfColorGraph(cgr)], rclr);
    sclr:=Filtered(clr, x->x^ColorMates(cgr)=x);
    aclr:=Filtered(clr, x->x<x^ColorMates(cgr));
    imap:=[];
 
    Append(imap, List(sclr, x->[x]));
    Append(imap,List(aclr, x->[x,x^ColorMates(cgr)]));
    map:=[];
    for i in [1..Length(imap)] do
        for j in imap[i] do
            map[j]:=i;
        od;
    od;
    
    cand:=rec(cgr:=cgr,
              map:=map,
              imap:=imap,
              domain:=[1..Length(imap)],
              set:=[],               
              maxlength:=Int((RankOfColorGraph(cgr)-1)/2),
              square:=ListWithIdenticalEntries(RankOfColorGraph(cgr),0)
              );
   
   return Objectify(NewType(PartialArcRegularSetsFamily(cgr), IsSymPartialArcRegularSet and IsPartialArcRegularSetRep), cand);
end);


InstallMethod(ExtendedPartialStableSet,
    "for asymmetric partial arc regular sets in PartialArcRegularSetRep",
    [IsAsymPartialArcRegularSet and IsPartialArcRegularSetRep, IsPosInt],
function(cand,pt)
    local cgr,t,clr,ent,ipt,ndom,obj,sq,i;
    

    cgr:=cand!.cgr;
    t:=JStructureConstantsOfColorGraph(cgr);
    if not IsTensorRep(t) then
        Error("this is not supposed to happen");
    fi;
    
    clr:=cand!.imap[pt][1];
    ipt:=cand!.map[cand!.imap[pt][1]^ColorMates(cgr)];
    
    ent:=t!.entries;
    if Length(cand!.set) + 1 > cand!.maxlength then
        Error("not supposed to happen");
        return fail;
    fi;
    
    sq:=ShallowCopy(cand!.square);
    for i in cand!.set do
        sq:=sq + 2*ent[i][clr];
#        sq:=sq+ent[clr][i];
    od;
    sq:=sq+ent[clr][clr];
    
    if Length(cand!.set) + 1 = cand!.maxlength then
        ndom := [];
    else
        ndom:=Filtered(cand!.domain, x->x>pt and x<>ipt);
    fi;
    
    obj:=rec(
             cgr:=cand!.cgr,
             map:=cand!.map,
             imap:=cand!.imap,
             domain:=ndom,
             set:=Union(cand!.set,cand!.imap[pt]),
             maxlength:=cand!.maxlength,
             square:=sq);
    
    
   return Objectify(NewType(PartialArcRegularSetsFamily(cand!.cgr), IsAsymPartialArcRegularSet and IsPartialArcRegularSetRep), obj);
end);

InstallMethod(EmptyAsymPartialArcRegularSet,
"for homogeneous tensors of structure constants",
[IsColorGraph and IsJStableColorGraph and IsRegularColorGraph],
function(cgr)
    local imap,map,i,grp,act,cand;
    
    imap:=Filtered([1..RankOfColorGraph(cgr)], x->x^ColorMates(cgr)<>x);
    map:=[];
    for i in [1..Length(imap)] do
        map[imap[i]]:=i;
    od;

    imap:=List(imap, x->[x]);
      
    cand:=rec(cgr:=cgr,
              map:=map,
              imap:=imap,
              domain:=[1..Length(imap)],
              set:=[],
              maxlength:=Int((RankOfColorGraph(cgr)-1)/2),
              square:=ListWithIdenticalEntries(RankOfColorGraph(cgr),0)
              );
    
    return Objectify(NewType(PartialArcRegularSetsFamily(cgr), IsAsymPartialArcRegularSet and IsPartialArcRegularSetRep), cand);
end);

InstallMethod(ConstructorOfStableSetOrbit,
        "for all arc regular sets",
        [IsRegularSet and IsArcRegularSet],
function(orb)
    return RegularSetOrbit;
end);
