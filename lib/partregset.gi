DeclareRepresentation("IsPartialRegularSetRep",
        IsPartialStableSetRep,
        [ "cgr",
          "map",
          "imap",
          "domain",
          "set",
          "maxlength"
          ]);


InstallMethod(PartialRegularSetsFamily,
"for color graphs",
[IsColorGraph],
function(cgr)
   local fam;
   fam:=NewFamily("PartialRegularSetsFam", IsPartialRegularSet);
   return fam;
end);

InstallMethod(PartialRegularSetOrbitFamilyOp,
        "for color graphs and permutation groups",
        [IsColorGraph, IsPermGroup],
function(cgr,g)
    return NewFamily("PartialRegularSetOrbitFam", IsPartialStableSetOrbit);
end);

InstallMethod(GetPartialStableSetOrbitFamily,
"for partial regular sets in PartialRegularSetRep and a permutation group",
[IsPartialRegularSet and IsPartialRegularSetRep, IsPermGroup],
function(prset,grp)  
    return PartialRegularSetOrbitFamily(prset!.cgr,grp);
end);

InstallMethod( ViewString,
        "for partial regular sets in PartialRegularSetRep",
        [IsPartialRegularSet and IsPartialRegularSetRep],
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

    return Concatenation(res,"partial regular set ", String(s), ">");
end);

InstallMethod(IsCompletePartialStableSet,
    "for partial regular sets in PartialRegularSetRep",
    [IsPartialRegularSet and IsPartialRegularSetRep],
function(prs)
    local set;
    
    set:=prs!.set;
    
    if set = [] then
        return false;
    fi;
    
    return true;
end);


InstallMethod(ExtendedPartialStableSet,
"for symmetric partial regular sets in PartialRegularSetRep",
[IsSymPartialRegularSet and IsPartialRegularSetRep, IsPosInt],
function(cand,pt)
    local  clr, ndom, obj;
    
    clr:=cand!.imap[pt];
    
    if Length(cand!.set) + Length(clr) > cand!.maxlength then
        return fail;
    fi;
    
        
    if Length(cand!.set) + Length(clr) = cand!.maxlength then
        ndom := [];
    else
        ndom:=Filtered(cand!.domain, x->x>pt);
    fi;
    

    obj:=rec(
              cgr:=cand!.cgr,
              map:=cand!.map,
              imap:=cand!.imap,
              domain:=ndom,
              set:=Union(cand!.set,clr),
              maxlength:=cand!.maxlength);
    
    return Objectify(NewType(PartialRegularSetsFamily(cand!.cgr), IsSymPartialRegularSet and IsPartialRegularSetRep), obj);
end);

InstallMethod(EmptySymPartialRegularSet,
        "for regular rainbows",
        [IsColorGraph and IsRainbow and IsRegularColorGraph],
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
              maxlength:=Int((RankOfColorGraph(cgr)-1)/2)
              );
   
   return Objectify(NewType(PartialRegularSetsFamily(cgr), IsSymPartialRegularSet and IsPartialRegularSetRep), cand);
end);



InstallMethod(ExtendedPartialStableSet,
    "for asymmetric partial regular sets in PartialRegularSetRep",
    [IsAsymPartialRegularSet and IsPartialRegularSetRep, IsPosInt],
function(cand,pt)
    local  cgr, clr, ipt, ndom, obj;
    
    cgr:=cand!.cgr;
    clr:=cand!.imap[pt][1];
    ipt:=cand!.map[cand!.imap[pt][1]^ColorMates(cgr)];
    
    if Length(cand!.set) + 1 > cand!.maxlength then
        Error("not supposed to happen");
        return fail;
    fi;
    
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
             maxlength:=cand!.maxlength);
   
   return Objectify(NewType(PartialRegularSetsFamily(cand!.cgr), IsAsymPartialRegularSet and IsPartialRegularSetRep), obj);
end);


InstallMethod(EmptyAsymPartialRegularSet,
        "for homogeneous WL-stable color graphs",
        [IsColorGraph and IsRainbow and IsRegularColorGraph],
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
              maxlength:=Int((RankOfColorGraph(cgr)-1)/2)
              );
    
    return Objectify(NewType(PartialRegularSetsFamily(cgr), IsAsymPartialRegularSet and IsPartialRegularSetRep), cand);
end);




##############################################################################
#
# homogeneous symmetric regular set candidates for inhomogeneous CCs
#
##############################################################################

DeclareRepresentation("IsSymPartialRegularSetBlkRep",
        IsPartialRegularSetRep,
        [ "cgr",
          "blocks",
          "perm",
          "startBlock",
          "finishBlock",
          "map",
          "imap",
          "domain",
          "currentRow",
          "set",
          "maxlength",
          "blockingmat",
          "degreelist",
          "maxdeg",
          "domdegreelist",
          "ridx",
          "fullrows",
          "kIsForced",
          "k"
          ]);


InstallMethod(IsCompletePartialStableSet,
    "for symmetric partial regular sets in SymPartialRegularSetBlkRep",
    [IsSymPartialRegularSet and IsSymPartialRegularSetBlkRep],
function(cand)
    local a,b,block;
    
    if cand!.set=[] then
        return false;
    fi;
    if Length(cand!.set)>cand!.maxlength then
        return false;
    fi;

    if cand!.kIsForced then
        return Length(cand!.fullrows)=Length(cand!.blocks);
    else
        if ForAny([1..Length(cand!.blocks)], b->cand!.degreelist[b]<>cand!.maxdeg) then
            return false;
        fi;
    fi;
    
    return true;
end);





InstallMethod(ExtendedPartialStableSet,
    "for symmetric partial regular sets in SymPartialRegularSetBlk",
    [IsSymPartialRegularSet and IsSymPartialRegularSetBlkRep, IsPosInt],
function(cand,pt)
    local clr,t,npgs,color,icolor,sb,fb,i,b,j,a,block,sd,sbinfr,fbinfr,sq,bm,k,kmts,
          ksb,kfb,ncand,ent,blkIdx,ba,bb,bc,bbl;                
    
    clr:=cand!.imap[pt];
    if Length(cand!.set) + Length(clr) > cand!.maxlength then
        return fail;
    fi;

    t:=StructureConstantsOfColorGraph(cand!.cgr);
    
    npgs:=rec(
              cgr:=cand!.cgr,
              blocks:=cand!.blocks,
              perm:=cand!.perm,
              startBlock:=cand!.startBlock,
              finishBlock:=cand!.finishBlock,
              map:=cand!.map,
              imap:=cand!.imap,
              maxlength:=cand!.maxlength
              );
    
    color:=clr[1];
    icolor:=color^ColorMates(cand!.cgr);
    sb:=cand!.startBlock[color];
    fb:=cand!.finishBlock[color];
    
    if fb<sb then
        color:=clr[2];
        icolor:=clr[1];
        sb:=cand!.startBlock[color];
        fb:=cand!.finishBlock[color];
    fi;
        
    npgs.fullrows:=ShallowCopy(cand!.fullrows);
    npgs.kIsForced:=cand!.kIsForced;
    npgs.k:=cand!.k;
    if not cand!.kIsForced then
        if sb>1 then
            npgs.kIsForced:=true;
            npgs.k:=cand!.degreelist[1];
            if npgs.k<cand!.maxdeg then
                return fail;
            fi;
            if ForAny([2..sb-1], x->cand!.degreelist[x]<>npgs.k) then
                return fail;
            fi;
            
            npgs.fullrows:=Filtered([1..Length(cand!.blocks)], x->cand!.degreelist[x]=npgs.k);
        fi;

    fi;
        
    npgs.currentRow:=sb;
        
    # starting from here we actually define the set of npgs
    npgs.set:=Union(cand!.set, [color,icolor]);
    npgs.ridx:=Union(cand!.ridx,[sb,fb]);
    
    
    npgs.blockingmat:=ShallowCopy(cand!.blockingmat);
    npgs.blockingmat[sb]:=ShallowCopy(npgs.blockingmat[sb]);
    npgs.blockingmat[sb][fb]:=ShallowCopy(npgs.blockingmat[sb][fb]);
    AddSet(npgs.blockingmat[sb][fb],color);
    
    sd:=OutValencies(cand!.cgr);
    
    npgs.degreelist:=ShallowCopy(cand!.degreelist);
    npgs.degreelist[sb]:=npgs.degreelist[sb]+sd[color];
    npgs.maxdeg:=Maximum(cand!.maxdeg, npgs.degreelist[sb]);
    
    if color<>icolor then
        if fb<>sb then
            npgs.blockingmat[fb]:=ShallowCopy(npgs.blockingmat[fb]);
            npgs.blockingmat[fb][sb]:=ShallowCopy(npgs.blockingmat[fb][sb]);
        fi;
        AddSet(npgs.blockingmat[fb][sb],icolor);
        npgs.degreelist[fb]:=npgs.degreelist[fb]+sd[icolor];
        npgs.maxdeg:=Maximum(npgs.maxdeg, npgs.degreelist[fb]);
    fi;
    if npgs.kIsForced and npgs.maxdeg>npgs.k then
        return fail;
    fi;
    
    sbinfr:=npgs.kIsForced and npgs.degreelist[sb]=npgs.k;
    if sbinfr then
        AddSet(npgs.fullrows,sb);
    fi;
    
    if fb<>sb then
        fbinfr:=npgs.kIsForced and npgs.degreelist[fb]=npgs.k;
        if fbinfr then
            AddSet(npgs.fullrows,fb);
        fi;
    else
        fbinfr:=sbinfr;
    fi;
    

    if Length(npgs.set) = npgs!.maxlength then
        npgs.domain:=[];
        npgs.domdegreelist:=ListWithIdenticalEntries(Length(cand!.domdegreelist), 0);
    else
        npgs.domain:=[];
        npgs.domdegreelist:=ShallowCopy(cand!.domdegreelist);
        for j in [1..Length(cand!.domain)] do
            k:=cand!.domain[j];
            kmts:=cand!.imap[k];
            ksb:=cand!.startBlock[kmts[1]];
            kfb:=cand!.finishBlock[kmts[1]];
            if k<=pt 
               or ksb in npgs.fullrows
               or kfb in npgs.fullrows
               or npgs.kIsForced and (sd[kmts[1]]+npgs.degreelist[ksb]>npgs.k 
                                      or  (Length(kmts)=2 and sd[kmts[2]]+npgs.degreelist[kfb]>npgs.k))
            then
                npgs.domdegreelist[ksb]:=npgs.domdegreelist[ksb]-sd[kmts[1]];
                if npgs.domdegreelist[ksb]+npgs.degreelist[ksb]<npgs.maxdeg then
                    return fail;
                fi;
                if Length(kmts)=2 then
                    npgs.domdegreelist[kfb]:=npgs.domdegreelist[kfb]-sd[kmts[2]];
                    if npgs.domdegreelist[kfb]+npgs.degreelist[kfb]<npgs.maxdeg then
                        return fail;
                    fi;
                fi;
            else
                Add(npgs.domain,k);
            fi;
        od;    
    fi;
        
    #blkIdx:=t!.blkIdx;
    
    
    #bm:=npgs.blockingmat;
         
            
    Objectify(NewType(PartialRegularSetsFamily(cand!.cgr), IsSymPartialRegularSet and IsSymPartialRegularSetBlkRep), npgs);
    return npgs;
    
end);

InstallMethod(EmptySymPartialRegularSet,
        "for inhomogeneous WL-stable color graphs",
        [IsColorGraph and IsWLStableColorGraph],
function(cgr)
    local tensor,mat,vec,perm,blocks,startBlock,finishBlock,rclr,clr,nof,imap,a,sclr,aclr,b,map,i,j,domdegreelist,cand,sb,bclr,idxBlk;
    
    tensor:=StructureConstantsOfColorGraph(cgr);
    if not IsBlockedTensorRep(tensor) then
        TryNextMethod();
        
        ErrorNoReturn("This is not supposed to happen!");
    fi;
    
    mat:=List(tensor!.blocks, a->List(tensor!.blocks, Length));
    vec:=List(mat,Sum);
    # perm:=();
    perm:=SortingPerm(vec);
    blocks:=Permuted(List(tensor!.blocks, x->Permuted(x,perm)),perm);
    startBlock:=List([1..Order(tensor)], i->StartBlock(tensor,i)^perm);
    finishBlock:=List([1..Order(tensor)], i->FinishBlock(tensor,i)^perm);
    
    rclr:=ReflexiveColors(tensor);
    clr:=Difference([1..OrderOfTensor(tensor)], rclr);
    nof:=Length(rclr);
    
    imap:=[];
    
    for a in [1..nof] do
        sclr:=Intersection(Filtered(blocks[a][a], x->x^Mates(tensor)=x),clr);
        aclr:=Filtered(blocks[a][a], x->x<x^Mates(tensor));
        imap[a]:=List(sclr, x->[x]);
        Append(imap[a], List(aclr, x->[x,x^Mates(tensor)]));
        SortBy(imap[a], x->-Sum(List(x,i->-OutValencies(tensor)[i])));
    od;

    for a in [1..nof] do
        for b in [a+1..nof] do
            bclr:=ShallowCopy(blocks[a][b]);
            SortBy(bclr, i->-OutValencies(tensor)[i]);
            Append(imap[a], List(bclr, x->Set([x,x^Mates(tensor)])));
        od;
    od;
    imap:=Concatenation(imap);
    
    map:=[];
    for i in [1..Length(imap)] do
        for j in imap[i] do
            map[j]:=i;
        od;
    od;
    domdegreelist:=ListWithIdenticalEntries(nof,0);
    for i in clr do
       sb:=startBlock[i];
       domdegreelist[sb]:=domdegreelist[sb]+OutValencies(tensor)[i];
    od;
    
    cand:=rec(cgr:=cgr,
              blocks:=blocks,
              perm:=perm,
              startBlock:=startBlock,
              finishBlock:=finishBlock,
              map:=map,
              imap:=imap,
              domain:=[1..Length(imap)],
              currentRow:=0,
              set:=[],
              maxlength:=Int((OrderOfTensor(tensor)-nof)/2),
              blockingmat:=List([1..nof], a->List([1..nof], b->[])),
              degreelist:=ListWithIdenticalEntries(nof,0),
              maxdeg:=0,
              domdegreelist:=domdegreelist,
              ridx:=[],
              fullrows:=[],
              kIsForced:=false,
              k:=0);
    
    return Objectify(NewType(PartialRegularSetsFamily(cgr), IsSymPartialRegularSet and IsSymPartialRegularSetBlkRep), cand);
end);



##############################################################################
#
# homogeneous partial asymmetric godd set for inhomogeneous CCs
#
##############################################################################

DeclareRepresentation("IsAsymPartialRegularSetBlkRep",
        IsPartialRegularSetRep,
        [ "cgr",
          "blocks",
          "perm",
          "startBlock",
          "finishBlock",
          "map",
          "imap",
          "domain",
          "currentRow",
          "set",
          "maxlength",
          "blockingmat",
          "rowdegs",
          "coldegs",
          "rmaxdeg",
          "cmaxdeg",
          "domrowdegs",
          "domcoldegs",
          "ridx",
          "cidx",
          "fullrows",
          "kIsForced",
          "k"
          ]);


InstallMethod(IsCompletePartialStableSet,
    "for asymmetric partial regular sets in AsymPartialRegularSetBlkRep",
    [IsAsymPartialRegularSet and IsAsymPartialRegularSetBlkRep],
function(cand)
    local a,b,block;
    
    if cand!.set=[] then
        return false;
    fi;
    if Length(cand!.set)>cand!.maxlength then
        return false;
    fi;

    if cand!.kIsForced then 
        return Length(cand!.fullrows)=Length(cand!.blocks);
    else
        if cand!.rmaxdeg<>cand!.cmaxdeg then
            return false;
        fi;
        if ForAny([1..Length(cand!.blocks)], b->cand!.rowdegs[b]<>cand!.rmaxdeg) then
            return false;
        fi;
        if ForAny([1..Length(cand!.blocks)], b->cand!.coldegs[b]<>cand!.rmaxdeg) then
            return false;
        fi;
        
    fi;
    
    
    return true;
end);


InstallMethod(ExtendedPartialStableSet,
    "for asymmetric partial regular sets in AsymPartialRegularSetBlkRep and positive integers",
    [IsAsymPartialRegularSet and IsAsymPartialRegularSetBlkRep, IsPosInt],
function(cand,pt)
    local clr,t,bm,npgs,color,sb,fb,sd,i,j,k,kmts,a,b,block,md,sq,icolor,ksb,kfb,sbinfr,ent,blkIdx,ba,bb,bc,bbl;
    
    clr:=cand!.imap[pt];
    if Length(cand!.set) + Length(clr) > cand!.maxlength then
        Error("this is not supposed to happen");
        
        return fail;
    fi;

    t:=StructureConstantsOfColorGraph(cand!.cgr);
    
    npgs:=rec(
              cgr:=cand!.cgr,
              blocks:=cand!.blocks,
              perm:=cand!.perm,
              startBlock:=cand!.startBlock,
              finishBlock:=cand!.finishBlock,
              map:=cand!.map,
              imap:=cand!.imap,
              maxlength:=cand!.maxlength
              );
    
    color:=clr[1];
    sb:=cand!.startBlock[color];
    fb:=cand!.finishBlock[color];
    
    npgs.currentRow:=sb;
    
    npgs.fullrows:=ShallowCopy(cand!.fullrows);
    npgs.kIsForced:=cand!.kIsForced;
    npgs.k:=cand!.k;
    
    if not npgs.kIsForced then
        if sb>1 then
            npgs.kIsForced:=true;
            npgs.k:=cand!.rowdegs[1];
            if npgs.k<cand!.rmaxdeg or npgs.k<cand!.cmaxdeg then
                return fail;
            fi;
            if ForAny([2..sb-1], x->cand!.rowdegs[x]<>npgs.k) then
                return fail;
            fi;
            npgs.fullrows:=[1..sb-1];
        fi;
    fi;
    
    npgs.set:=Union(cand!.set, [color]);
   
    npgs.ridx:=Union(cand!.ridx,[sb]);
    npgs.cidx:=Union(cand!.cidx,[fb]);
    
    sd:=OutValencies(t);
    
    npgs.blockingmat:=ShallowCopy(cand!.blockingmat);
    npgs.blockingmat[sb]:=ShallowCopy(npgs.blockingmat[sb]);
    npgs.blockingmat[sb][fb]:=ShallowCopy(npgs.blockingmat[sb][fb]);
    AddSet(npgs.blockingmat[sb][fb],color);   
   
    npgs.rowdegs:=ShallowCopy(cand!.rowdegs);
    npgs.coldegs:=ShallowCopy(cand!.coldegs);

    npgs.rowdegs[sb]:=npgs.rowdegs[sb]+sd[color];
    npgs.rmaxdeg:=Maximum(npgs.rowdegs[sb], cand!.rmaxdeg);
    icolor:=color^Mates(t);
    npgs.coldegs[fb]:=npgs.coldegs[fb]+sd[icolor];
    npgs.cmaxdeg:=Maximum(npgs.coldegs[fb], cand!.cmaxdeg);    
    md:=Maximum(npgs.rmaxdeg, npgs.cmaxdeg);
    
    if npgs.kIsForced and md>npgs.k then
        return fail;
    fi;
    
    sbinfr:=npgs.kIsForced and npgs.rowdegs[sb]=npgs.k;
    if sbinfr then
        AddSet(npgs.fullrows,sb);
    fi;
    
    if Length(npgs.set) = npgs!.maxlength then
        npgs.domain:=[];
        npgs.domrowdegs:=ListWithIdenticalEntries(Length(cand!.domrowdegs), 0);
        npgs.domcoldegs:=ListWithIdenticalEntries(Length(cand!.domcoldegs), 0);
    else
        npgs.domain:=[];
        npgs.domrowdegs:=ShallowCopy(cand!.domrowdegs);
        npgs.domcoldegs:=ShallowCopy(cand!.domcoldegs);
        for k in cand!.domain do
            kmts:=[cand!.imap[k][1],cand!.imap[k][1]^Mates(t)];
            ksb:=cand!.startBlock[kmts[1]];
            kfb:=cand!.finishBlock[kmts[1]];
            if k<=pt  
               or kmts[1]=color^Mates(t) 
               or ksb in npgs.fullrows  
               or npgs.kIsForced and (sd[kmts[1]]+npgs.rowdegs[ksb]>npgs.k 
                                      or sd[kmts[2]]+npgs.coldegs[kfb]>npgs.k) 
            then
                npgs.domrowdegs[ksb]:=npgs.domrowdegs[ksb]-sd[kmts[1]];
                npgs.domcoldegs[kfb]:=npgs.domcoldegs[kfb]-sd[kmts[2]];
                if npgs.domrowdegs[ksb]+npgs.rowdegs[ksb]<md or npgs.domcoldegs[kfb]+npgs.coldegs[kfb]<md then
                    return fail;
                fi;
            else 
                Add(npgs.domain,k);
            fi;
        od;    
    fi;
    
    Objectify(NewType(PartialRegularSetsFamily(cand!.cgr), IsAsymPartialRegularSet and IsAsymPartialRegularSetBlkRep), npgs);
    return npgs;
end);


InstallMethod(EmptyAsymPartialRegularSet,
        "for inhomogeneous WL-stable color graphs",
        [IsColorGraph and IsWLStableColorGraph],
function(cgr)
    local tensor,mat,vec,perm,blocks,startBlock,finishBlock,nof,imap,a,b,map,i,clr,cand,sb,fb,domrowdegs,domcoldegs;
    
    tensor:=StructureConstantsOfColorGraph(cgr);
    if not IsBlockedTensorRep(tensor) then
        TryNextMethod();
        ErrorNoReturn("This is not supposed to happen!");
    fi;
    
    mat:=List(tensor!.blocks, a->List(tensor!.blocks, Length));
    vec:=List(mat,Sum);
    # perm:=();
    perm:=SortingPerm(vec);
    blocks:=tensor!.blocks;
    blocks:=Permuted(List(tensor!.blocks, x->Permuted(x,perm)),perm);
    startBlock:=List([1..Order(tensor)], i->StartBlock(tensor,i)^perm);
    finishBlock:=List([1..Order(tensor)], i->FinishBlock(tensor,i)^perm);
    
    nof:=Length(blocks);
    imap:=[];
    
    for a in [1..nof] do
        for b in [1..nof] do 
            if a=b then
                clr:=Filtered(blocks[a][a], x->x^Mates(tensor)<>x);
                SortBy(clr, i->-OutValencies(tensor)[i]);
                Append(imap, clr);
            else
                clr:=ShallowCopy(blocks[a][b]);
                SortBy(clr, i->-OutValencies(tensor)[i]);
                Append(imap, clr);
            fi;
        od;
    od;
  
    map:=[];
    for i in [1..Length(imap)] do
        map[imap[i]]:=i;
    od;
    clr:=Set(imap);
    imap:=List(imap, x->[x]);    
    
    domrowdegs:=ListWithIdenticalEntries(nof,0);
    domcoldegs:=ListWithIdenticalEntries(nof,0);
    for i in clr do
        sb:=startBlock[i];
        fb:=finishBlock[i];
        domrowdegs[sb]:=domrowdegs[sb]+OutValencies(tensor)[i];
        domcoldegs[fb]:=domcoldegs[fb]+OutValencies(tensor)[i^Mates(tensor)];
    od;
    
    
    cand:=rec(cgr:=cgr,
              blocks:=blocks,
              perm:=perm,
              startBlock:=startBlock,
              finishBlock:=finishBlock,
              map:=map,
              imap:=imap,
              domain:=[1..Length(imap)],
              currentRow:=0,
              set:=[],
              maxlength:=Int((OrderOfTensor(tensor)-nof)/2),
              blockingmat:=List([1..nof], a->List([1..nof], b->[])),
              rowdegs:=ListWithIdenticalEntries(nof,0),
              coldegs:=ListWithIdenticalEntries(nof,0),
              rmaxdeg:=0,
              cmaxdeg:=0,
              domrowdegs:=domrowdegs,
              domcoldegs:=domcoldegs,
              ridx:=[],
              cidx:=[],
              fullrows:=[],
              kIsForced:=false,
              k:=0);
    return Objectify(NewType(PartialRegularSetsFamily(cgr), IsAsymPartialRegularSet and IsAsymPartialRegularSetBlkRep), cand);
end);


InstallMethod(ConstructorOfStableSetOrbit,
        "for all regular sets",
        [IsRegularSet],
function(orb)
    return RegularSetOrbit;
end);
