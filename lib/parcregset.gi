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
"for a color graph",
[IsColorGraph],
function(cgr)
   local fam;
   fam:=NewFamily("PartialArcRegularSetsFam", IsPartialArcRegularSet);
   return fam;
end);

InstallMethod(PartialArcRegularSetOrbitFamilyOp,
"for a color graph and a permutation group",
[IsColorGraph, IsPermGroup],
function(cgr,g)
    return NewFamily("PartialArcRegularSetOrbitFam", IsPartialStableSetOrbit);
end);

InstallMethod(GetPartialStableSetOrbitFamily,
"for a partial arc regular set in PartialArcRegularSetRep and a permutation group",
[IsPartialArcRegularSet and IsPartialArcRegularSetRep, IsPermGroup],
function(prset,grp)  
    return PartialArcRegularSetOrbitFamily(prset!.cgr,grp);
end);

InstallMethod( ViewString,
"for a partial arc regular set in PartialArcRegularSetRep",
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


InstallMethod(ConstructorOfStableSetOrbit,
"for an arc regular set",
[IsRegularSet and IsArcRegularSet],
function(orb)
    return RegularSetOrbit;
end);

InstallMethod(IsCompletePartialStableSet,
"for a partial arc regular set in PartialArcRegularSetRep",
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
"for a symmetric partial arc regular set in PartialArcRegularSetRep and a positive integer",
[IsSymPartialArcRegularSet and IsPartialArcRegularSetRep, IsPosInt],
function(cand,pt)
    local tensor,ndom,obj,ent,sq,mates,i;
    
    mates:=cand!.imap[pt];
    if Length(cand!.set) + Length(mates) > cand!.maxlength then
        Error("this is not supposed to happen");
       return fail;
    fi;
    
    tensor:=StructureConstantsOfColorGraph(cand!.cgr);
    if not IsTensorRep(tensor) then
        Error("this is not supposed to happen");
    fi;
    
    ent:=tensor!.entries;
    sq:=ShallowCopy(cand!.square);
    for i in cand!.set do
        sq:=sq+ent[i][mates[1]];
        sq:=sq+ent[mates[1]][i];
    od;
    sq:=sq+ent[mates[1]][mates[1]];
    if Length(mates)=2 then
        for i in cand!.set do
            sq:=sq+ent[i][mates[2]];
            sq:=sq+ent[mates[2]][i];
        od;
        sq:=sq+ent[mates[1]][mates[2]];
        sq:=sq+ent[mates[2]][mates[1]];
        sq:=sq+ent[mates[2]][mates[2]];
    fi;
   
    obj:=rec(
              cgr:=cand!.cgr,
              map:=cand!.map,
              imap:=cand!.imap,
              set:=Union(cand!.set,mates),
              maxlength:=cand!.maxlength,
              square:=sq);
    
    if Length(cand!.set) + Length(mates) = cand!.maxlength then
        ndom := [];
    else
        ndom:=Filtered(cand!.domain, x->x>pt and 
                      Length(obj.set)+Length(obj.imap[x])<=obj.maxlength);
    fi;
    

    obj.domain:=ndom;
    
    return Objectify(NewType(PartialArcRegularSetsFamily(cand!.cgr), IsSymPartialArcRegularSet and IsPartialArcRegularSetRep), obj);
end);

InstallMethod(EmptySymPartialArcRegularSet,
"for a regular WL-stable color graph",
[IsColorGraph and IsWLStableColorGraph and IsHomogeneous],
function(cgr)
    local aaut,rclr,clr,sclr,aclr,imap,map, i, j,act,cand, maxlength, domain;
   
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
    
    maxlength:=Int((RankOfColorGraph(cgr)-1)/2);
    domain:=Filtered([1..Length(imap)], x->Length(imap[x])<=maxlength);
    
    
    cand:=rec(cgr:=cgr,
              map:=map,
              imap:=imap,
              domain:=domain,
              set:=[],               
              maxlength:=maxlength,
              square:=ListWithIdenticalEntries(RankOfColorGraph(cgr),0)
              );
   
   return Objectify(NewType(PartialArcRegularSetsFamily(cgr), IsSymPartialArcRegularSet and IsPartialArcRegularSetRep), cand);
end);


InstallMethod(ExtendedPartialStableSet,
"for an asymmetric partial arc regular set in PartialArcRegularSetRep and a positive integer",
[IsAsymPartialArcRegularSet and IsPartialArcRegularSetRep, IsPosInt],
function(cand,pt)
    local cgr,t,clr,ent,ipt,ndom,obj,sq,i;
    

    cgr:=cand!.cgr;
    t:=StructureConstantsOfColorGraph(cgr);
    if not IsTensorRep(t) then
        Error("this is not supposed to happen");
    fi;
    
    if Length(cand!.set) + 1 > cand!.maxlength then
        Error("this is not supposed to happen");
       return fail;
    fi;

    clr:=cand!.imap[pt][1];
    ipt:=cand!.map[cand!.imap[pt][1]^ColorMates(cgr)];
    
    ent:=t!.entries;
    if Length(cand!.set) + 1 > cand!.maxlength then
        Error("this is not supposed to happen");
        return fail;
    fi;
    
    sq:=ShallowCopy(cand!.square);
    for i in cand!.set do
        sq:=sq+ent[i][clr];
        sq:=sq+ent[clr][i];
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
"for a regular WL-stable color graph",
[IsColorGraph and IsWLStableColorGraph and IsHomogeneous],
function(cgr)
    local imap,map,i,grp,act,cand, maxlength, domain;
    
    imap:=Filtered([1..RankOfColorGraph(cgr)], x->x^ColorMates(cgr)<>x);
    map:=[];
    for i in [1..Length(imap)] do
        map[imap[i]]:=i;
    od;

    imap:=List(imap, x->[x]);
    
    maxlength:=Int((RankOfColorGraph(cgr)-1)/2);
    if maxlength > 0 then
        domain:=[1..Length(imap)];
    else
        domain:=[];
    fi;
    
    cand:=rec(cgr:=cgr,
              map:=map,
              imap:=imap,
              domain:=domain,
              set:=[],
              maxlength:=maxlength,
              square:=ListWithIdenticalEntries(RankOfColorGraph(cgr),0)
              );
    
    return Objectify(NewType(PartialArcRegularSetsFamily(cgr), IsAsymPartialArcRegularSet and IsPartialArcRegularSetRep), cand);
end);

DeclareRepresentation("IsAsymPartialArcRegularSetBlkRep",
        IsPartialArcRegularSetRep,
        [ "cgr",
          "map",
          "imap",
          "domain",
          "set",
          "maxlength",
          "square",
          "blocks", # blocks[a][b] contains all colors i with sb(i)=a, fb(i)=b
          "perm",   # this permutation sorts the blocks by increasing size 
          "startBlock",
          "finishBlock",
          "currentRow",
          "blockingmat",
          "rowdegs",
          "coldegs",
          "rmaxdeg",
          "cmaxdeg",
          "domrowdegs",
          "domcoldegs",
          "ridx",   # block rows from which colors are present in set
          "cidx",   # block columns from which colors a re present in set
          "fullrows",
          "kIsForced",
          "k",
          "lbdIsForced",
          "lbd",
          "maxlbd"
          ]);

InstallMethod(EmptyAsymPartialArcRegularSet,
"for WL-stable color graph",
[IsColorGraph and IsWLStableColorGraph],
function(cgr)
    local  tensor, mat, vec, perm, blocks, startBlock, finishBlock, 
           nof, imap, a, b, clr, map, i, domrowdegs, domcoldegs, sb, 
           fb, cand, maxlength, domain;
    
    tensor:=StructureConstantsOfColorGraph(cgr);
    if not IsBlockedTensorRep(tensor) then
        Error("this is not supposed to happen");
        TryNextMethod();
    fi;
    
    mat:=List(tensor!.blocks, a->List(tensor!.blocks, Length));
    vec:=List(mat,Sum);
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
                clr:=Filtered(blocks[a][a], x->x^ColorMates(cgr)<>x);
                SortBy(clr, i->-OutValencies(cgr)[i]);
                Append(imap, clr);
            else
                clr:=ShallowCopy(blocks[a][b]);
                SortBy(clr, i->-OutValencies(cgr)[i]);
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
    
    maxlength:=Int((RankOfColorGraph(cgr)-nof)/2);
    domain:=Filtered([1..Length(imap)], x->Length(imap[x]) <= maxlength);
    

    domrowdegs:=ListWithIdenticalEntries(nof,0);
    domcoldegs:=ListWithIdenticalEntries(nof,0);
    for i in Union(imap{domain}) do
        
        sb:=startBlock[i];
        fb:=finishBlock[i];
        domrowdegs[sb]:=domrowdegs[sb]+OutValencies(cgr)[i];
        domcoldegs[fb]:=domcoldegs[fb]+OutValencies(cgr)[i^ColorMates(cgr)];
    od;
    
    
    cand:=rec(cgr:=cgr,
              map:=map,
              imap:=imap,
              domain:=domain,
              blocks:=blocks,
              perm:=perm,
              startBlock:=startBlock, # the block from which a color starts
              finishBlock:=finishBlock, # the block where a color finishes
              # colors are added row by row
              # the order of blocks is [1,1], [1,2], [1,3], ... [1,n-1], [1,n],
              #                        [2,1], [2,2], [2,3], ... [2,n-1], [2,n],
              #                         ...
              #                                                        [n,n].
              currentRow:=0, # the row/column of blocks where currently colors are added
              set:=[],
              maxlength:=maxlength,
              blockingmat:=List([1..nof], a->List([1..nof], b->[])),
              rowdegs:=ListWithIdenticalEntries(nof,0),
              coldegs:=ListWithIdenticalEntries(nof,0),
              rmaxdeg:=0,
              cmaxdeg:=0,
              maxlbd:=0,
              domrowdegs:=domrowdegs,
              domcoldegs:=domcoldegs,
              ridx:=[],
              cidx:=[],
              square:=ListWithIdenticalEntries(RankOfColorGraph(cgr),0),
              fullrows:=[],
              kIsForced:=false,
              k:=0,
              lbdIsForced:=false,
              lbd:=0);
    return Objectify(NewType(PartialArcRegularSetsFamily(cgr), 
           IsAsymPartialArcRegularSet and IsAsymPartialArcRegularSetBlkRep), cand);
end);

InstallMethod(IsCompletePartialStableSet,
"for an asymmetric partial arc regular set in AsymPartialArcRegularSetBlkRep",
[IsAsymPartialArcRegularSet and IsAsymPartialArcRegularSetBlkRep],
function(cand)
    local a,b,block;
    
    if cand!.set=[] then
        return false;
    fi;

    if cand!.rowdegs[1] <> cand!.coldegs[1] then
        return false;
    fi;
    if Length(cand!.blocks) > 1 then
        if ForAny([2..Length(cand!.blocks)], i->cand!.rowdegs[i] <> cand!.rowdegs[1]) then
            return false;
        elif ForAny([2..Length(cand!.blocks)], i->cand!.coldegs[i] <> cand!.coldegs[1]) then
            return false;
        fi;
    fi;
    
    for b in [1..Length(cand!.blocks)] do
        for a in [1..b] do # is ok for the because AA* is symmetric
            block:=cand!.blockingmat[a][b];
            if ForAny(block, x->cand!.square[x]<>cand!.maxlbd) then
                return false;
            fi;
        od;
    od;
    
    return true;
end);

InstallMethod(ExtendedPartialStableSet,
"for an asymmetric partial arc regular set in AsymPartialArcRegularSetBlkRep",
[IsAsymPartialArcRegularSet and IsAsymPartialArcRegularSetBlkRep, IsPosInt],
function(cand,pt)
    local  cgr, t, npgs, color, sb, fb,  
           a, b, block, sd, icolor, md, fbinfc, 
           k, kmts, ksb, kfb, sq, bm, ent, blkIdx, bbl, 
           c, ba, bb, bc, i, j, ii, ij;
    
    cgr:=cand!.cgr;
    
    t:=StructureConstantsOfColorGraph(cgr);
    
    npgs:=rec(
               cgr:=cand!.cgr,
               map:=cand!.map,
               imap:=cand!.imap,
               maxlength:=cand!.maxlength,
               blocks:=cand!.blocks,
               perm:=cand!.perm,
               startBlock:=cand!.startBlock,
               finishBlock:=cand!.finishBlock
              );
    
    color:=cand!.imap[pt][1];
    sb:=cand!.startBlock[color];
    fb:=cand!.finishBlock[color];
    
    
    if cand!.kIsForced and sb>cand!.currentRow then  
        if ForAny([cand!.currentRow..sb-1], b->cand!.rowdegs[b] <> cand!.k) then
            return nonextensible; 
        fi;
    fi;
    
    npgs.currentRow:=sb;
    
    npgs.fullrows:=ShallowCopy(cand!.fullrows);
    npgs.kIsForced:=cand!.kIsForced;
    npgs.k:=cand!.k;
    npgs.lbdIsForced:=cand!.lbdIsForced;
    npgs.lbd:=cand!.lbd;
    
    if not npgs.kIsForced then
        if sb > 1 then
            
            npgs.kIsForced:=true;
            npgs.k:=cand!.rowdegs[1];
            
            npgs.fullrows:=[1..sb-1];
            
            if npgs.k<cand!.rmaxdeg or npgs.k<cand!.cmaxdeg then
                return nonextensible;
            fi;
            if ForAny([2..sb-1], x->cand!.rowdegs[x]<>npgs.k) then
                return nonextensible;
            fi;
            
            for i in [1..Length(npgs.fullrows)] do
                b:=npgs.fullrows[i];
                for j in [1..i] do
                    a:=npgs.fullrows[j];
                    block:=cand!.blockingmat[a][b];
                    if block<>[] then
                        npgs.lbdIsForced:=true;
                        npgs.lbd:=cand!.square[block[1]];
                        if npgs.lbd<cand!.maxlbd then
                            return nonextensible;
                        fi;
                        break;
                    fi;
                od;
                if npgs.lbdIsForced then
                    break;
                fi;
            od;
            if npgs.lbdIsForced then
                for i in [i..Length(npgs.fullrows)] do
                    b:=npgs.fullrows[i];
                    for j in [1..i] do
                        a:=npgs.fullrows[j];
                        if ForAny(cand!.blockingmat[a][b], x->cand!.square[x]<>npgs.lbd) then
                            return nonextensible;
                        fi;
                    od;
                od;
            fi;
        fi;
    fi;
    
    if npgs.lbdIsForced and cand!.square[color]>npgs.lbd then
        return fail;
    fi;
    npgs.set:=Union(cand!.set, [color]);
    npgs.ridx:=Union(cand!.ridx,[sb]);
    npgs.cidx:=Union(cand!.cidx,[fb]);
    
    sd:=OutValencies(cgr);
    
    npgs.blockingmat:=ShallowCopy(cand!.blockingmat);
    npgs.blockingmat[sb]:=ShallowCopy(npgs.blockingmat[sb]);
    npgs.blockingmat[sb][fb]:=ShallowCopy(npgs.blockingmat[sb][fb]);
    AddSet(npgs.blockingmat[sb][fb],color);   
    
    npgs.rowdegs:=ShallowCopy(cand!.rowdegs);
    npgs.coldegs:=ShallowCopy(cand!.coldegs);
    
    npgs.rowdegs[sb]:=npgs.rowdegs[sb]+sd[color];
    npgs.rmaxdeg:=Maximum(npgs.rowdegs[sb], cand!.rmaxdeg);
    icolor:=color^ColorMates(cgr);
    npgs.coldegs[fb]:=npgs.coldegs[fb]+sd[icolor];
    npgs.cmaxdeg:=Maximum(npgs.coldegs[fb], cand!.cmaxdeg);    
    md:=Maximum(npgs.rmaxdeg, npgs.cmaxdeg);
    
    if npgs.kIsForced and md>npgs.k then
        return fail;
    fi;
    
    if npgs.kIsForced and npgs.rowdegs[sb]=npgs.k then
        AddSet(npgs.fullrows,sb);
    fi;
    
    
    if Length(npgs.set) = npgs.maxlength then
        npgs.domain:=[];
        npgs.domrowdegs:=ListWithIdenticalEntries(Length(cand!.domrowdegs), 0);
        npgs.domcoldegs:=ListWithIdenticalEntries(Length(cand!.domcoldegs), 0);
        if ForAny(npgs.rowdegs, x->x <> npgs.rmaxdeg) or 
           ForAny(npgs.coldegs, x->x <> npgs.camxdeg) 
        then
            return fail;
        fi;
    else
        npgs.domain:=ShallowCopy(cand!.domain);
        npgs.domrowdegs:=ShallowCopy(cand!.domrowdegs);
        npgs.domcoldegs:=ShallowCopy(cand!.domcoldegs);
        for k in cand!.domain do
            kmts:=[cand!.imap[k][1],cand!.imap[k][1]^ColorMates(cgr)];
            ksb:=cand!.startBlock[kmts[1]];
            kfb:=cand!.finishBlock[kmts[1]];
            if k<=pt or  
               kmts[1]=icolor or 
               ksb in npgs.fullrows or
               npgs.kIsForced and (sd[kmts[1]]+npgs.rowdegs[ksb]>npgs.k 
                                   or sd[kmts[2]]+npgs.coldegs[kfb]>npgs.k) 
            then
                npgs.domrowdegs[ksb]:=npgs.domrowdegs[ksb]-sd[kmts[1]];
                npgs.domcoldegs[kfb]:=npgs.domcoldegs[kfb]-sd[kmts[2]];
                RemoveSet(npgs.domain,k);
                if npgs.domrowdegs[ksb]+npgs.rowdegs[ksb]<md 
                   or npgs.domcoldegs[kfb]+npgs.coldegs[kfb]<md then
                    return fail;
                fi;
            fi;
            Assert(1, List(List(BlockingMat(StructureConstantsOfColorGraph(cgr), 
                                            OnSets(Union(npgs!.imap{npgs!.domain}),())),
                                r->List(r,c->Sum(OutValencies(cgr){c}))),Sum)
                      =npgs.domrowdegs);
            Assert(1, List(List(BlockingMat(StructureConstantsOfColorGraph(cgr), 
                                            OnSets(Union(npgs!.imap{npgs!.domain}),
                                                   ColorMates(cgr))),
                                r->List(r,c->Sum(OutValencies(cgr){c}))),Sum)
                      =npgs.domcoldegs);

        od;
    fi;
    
        
    npgs.square:=ShallowCopy(cand!.square);
    sq:=npgs.square;
    bm:=npgs.blockingmat;
    npgs.maxlbd:=cand!.maxlbd;
    ent:=t!.entries;
    blkIdx:=t!.blkIdx;
    
    for a in npgs!.ridx do
        for b in npgs!.ridx do
            block:=bm[a][b];
            bbl:=cand!.blocks[a][b];
            if bbl = [] or a <> sb and b <> sb then
                continue;
            fi;
            if b = sb then # A C* 
                c:=fb;
                ba:=a/npgs.perm;
                bb:=b/npgs.perm;
                bc:=c/npgs.perm;
                for i in cand!.blockingmat[a][c] do
                    sq{bbl}:=sq{bbl}+ent[ba][bb][bc][blkIdx[i]][blkIdx[icolor]];
                od;
            fi;
            
            if a = sb then # C A*
                c:=fb;
                ba:=a/npgs.perm;
                bb:=b/npgs.perm;
                bc:=c/npgs.perm;
                for j in cand!.blockingmat[b][c] do
                    sq{bbl}:=sq{bbl}+ent[ba][bb][bc][blkIdx[color]][blkIdx[j^ColorMates(cgr)]];
                od;
            fi;
            if a = sb and b = sb then # C C*
                c:=fb;
                ba:=a/npgs.perm;
                bb:=b/npgs.perm;
                bc:=c/npgs.perm;
                sq{bbl}:=sq{bbl}+ent[ba][bb][bc][blkIdx[color]][blkIdx[icolor]];
            fi;
            if block <> [] then
                npgs.maxlbd:=Maximum(npgs.maxlbd, Maximum(sq{block}));
                    
                if npgs.lbdIsForced  and npgs.maxlbd > npgs.lbd then
                    return fail;
                fi;
                    
                # check all new complete blocks of npgs
                if a in npgs.fullrows and b in npgs.fullrows and
                   not ( a in cand!.fullrows and b in cand!.fullrows )
                then
                    if not npgs.lbdIsForced then
                        npgs.lbdIsForced := true;
                        npgs.lbd:=sq[block[1]];
                        if npgs.lbd <> npgs.maxlbd then
                            return fail;
                        fi;
                        # if ForAny(block, x->sq[x]<>npgs.lbd) then
                        #     return fail;
                        # fi;
                    fi;
                    
                    if ForAny(block, x->sq[x]<>npgs.lbd) then
                        return fail;
                    fi;
                    
                fi;
            fi;
        od;
    od;
    
    Assert(1,sq=ComplexProduct(t,npgs.set,OnSets(npgs.set,ColorMates(cgr))));
    
    Objectify(NewType(PartialArcRegularSetsFamily(cgr), IsAsymPartialArcRegularSet and IsAsymPartialArcRegularSetBlkRep), npgs);
    return npgs;
end);

InstallMethod(GetPartialStableSetOrbitFamily,
"for a partial arc regular set in PartialArcRegularSetRep and a permutation group",
[IsPartialArcRegularSet and IsPartialArcRegularSetRep, IsPermGroup],
function(prset,grp)  
    return PartialArcRegularSetOrbitFamily(prset!.cgr,grp);
end);

InstallMethod( ViewString,
"for a partial arc regular set in PartialArcRegularSetRep",
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

InstallMethod(StableSetFromPartialStableSet,
"for a partial arc regular set in PartialArcRegularSetRep",
[IsPartialArcRegularSet and IsPartialArcRegularSetRep],
function(cand)
    return RegularSet( IsArcRegularSet, cand!.cgr, cand!.set);
end);

##############################################################################
#
# homogeneous symmetric arc regular sets for inhomogeneous CCs
#
##############################################################################

DeclareRepresentation("IsSymPartialArcRegularSetBlkRep",
        IsPartialArcRegularSetRep,
        [ "tensor",
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
          "maxlbd",
          "domdegreelist",
          "ridx",
          "square",
          "fullrows",
          "kIsForced",
          "k",
          "lbdIsForced",
          "lbd"
          ]);

InstallMethod(EmptySymPartialArcRegularSet,
"for a WL-stable color graph",
[IsColorGraph and IsWLStableColorGraph],
function(cgr)
    local tensor,mat,vec,perm,blocks,startBlock,finishBlock,rclr,clr,nof,imap,a,sclr,aclr,b,map,i,j,domdegreelist,cand,sb,bclr,idxBlk, maxlength,domain;
    
    tensor:=StructureConstantsOfColorGraph(cgr);
    if not IsBlockedTensorRep(tensor) then
        Error("this is not supposed to happen");
        TryNextMethod();
    fi;
    
    mat:=List(tensor!.blocks, a->List(tensor!.blocks, Length));
    vec:=List(mat,Sum);
    perm:=SortingPerm(vec);
    blocks:=Permuted(List(tensor!.blocks, x->Permuted(x,perm)),perm);
    startBlock:=List([1..Order(tensor)], i->StartBlock(tensor,i)^perm);
    finishBlock:=List([1..Order(tensor)], i->FinishBlock(tensor,i)^perm);
    
    rclr:=ReflexiveColors(cgr);
    clr:=Difference([1..RankOfColorGraph(cgr)], rclr);
    nof:=Length(rclr);
    
    imap:=[];
    
    for a in [1..nof] do
        sclr:=Intersection(Filtered(blocks[a][a], x->x^ColorMates(cgr)=x),clr);
        aclr:=Filtered(blocks[a][a], x->x<x^ColorMates(cgr));
        imap[a]:=List(sclr, x->[x]);
        Append(imap[a], List(aclr, x->[x,x^ColorMates(cgr)]));
        SortBy(imap[a], x->-Sum(List(x,i->-OutValencies(cgr)[i])));
    od;

    for a in [1..nof] do
        for b in [a+1..nof] do
            bclr:=ShallowCopy(blocks[a][b]);
            SortBy(bclr, i->-OutValencies(cgr)[i]);
            Append(imap[a], List(bclr, x->Set([x,x^ColorMates(cgr)])));
        od;
    od;
    imap:=Concatenation(imap);
    
    map:=[];
    for i in [1..Length(imap)] do
        for j in imap[i] do
            map[j]:=i;
        od;
    od;
    maxlength:=Int((RankOfColorGraph(cgr)-nof)/2);
    domain:=Filtered([1..Length(imap)], x->Length(imap[x]) <= maxlength);
    
    domdegreelist:=ListWithIdenticalEntries(nof,0);
    for i in Union(imap{domain}) do
       sb:=startBlock[i];
       domdegreelist[sb]:=domdegreelist[sb]+OutValencies(cgr)[i];
    od;
    
    cand:=rec(cgr:=cgr,
              blocks:=blocks,
              perm:=perm,
              startBlock:=startBlock,
              finishBlock:=finishBlock,
              map:=map,
              imap:=imap,
              domain:=domain,
              currentRow:=0,
              set:=[],
              maxlength:=maxlength,
              blockingmat:=List([1..nof], a->List([1..nof], b->[])),
              degreelist:=ListWithIdenticalEntries(nof,0),
              maxdeg:=0,
              maxlbd:=0,
              domdegreelist:=domdegreelist,
              ridx:=[],
              square:=ListWithIdenticalEntries(RankOfColorGraph(cgr),0),
              fullrows:=[],
              kIsForced:=false,
              k:=0,
              lbdIsForced:=false,
              lbd:=0);
    
    return Objectify(NewType(PartialArcRegularSetsFamily(cgr), 
                             IsSymPartialArcRegularSet and IsSymPartialArcRegularSetBlkRep), cand);
end);

InstallMethod(IsCompletePartialStableSet,
"for a symmetric partial arc regular set in SymPartialArcRegularSetBlkRep",
[IsSymPartialArcRegularSet and IsSymPartialArcRegularSetBlkRep],
function(cand)
    local a,b,block;
    
    if cand!.set=[] then
        return false;
    fi;
    
    
    if cand!.kIsForced then
        return Length(cand!.fullrows)=Length(cand!.blocks);
    else
        if ForAny([1..Length(cand!.blocks)], b->cand!.degreelist[b]<>cand!.maxdeg) then
            return false;
        fi;
    
        for b in [1..Length(cand!.blocks)] do
            for a in [1..b] do 
                block:=cand!.blockingmat[a][b];
                if ForAny(block, x->cand!.square[x]<>cand!.maxlbd) then
                    return false;
                fi;
            od;
        od;
    fi;
    
    return true;
end);

InstallMethod(ExtendedPartialStableSet,
"for a symmetric partial arc regular set in SymPartialArcRegularSetBlkRep and a positive integer",
[IsSymPartialArcRegularSet and IsSymPartialArcRegularSetBlkRep, IsPosInt],
function(cand,pt)
    local  cgr, t, npgs, color, icolor, sb, fb, i, a, j, b, block, sd, 
           k, kmts, ksb, kfb, 
           sq, ent, blkIdx, bbl, c, ba, bb, bc, bm;
    
    cgr:=cand!.cgr;
    
    t:=StructureConstantsOfColorGraph(cgr);
    
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
    
    color:=cand!.imap[pt][1];
    icolor:=color^ColorMates(cgr);
    sb:=cand!.startBlock[color];
    fb:=cand!.finishBlock[color];
    
    Assert(1, not color in cand!.set and not icolor in cand!.set);
    
    if fb<sb then
        color:=cand!.imap[pt][2];
        icolor:=cand!.imap[pt][1];
        sb:=cand!.startBlock[color];
        fb:=cand!.finishBlock[color];
    fi;
    
    if cand!.kIsForced and sb > cand!.currentRow then  
        if ForAny([cand!.currentRow..sb-1], b->cand!.degreelist[b] <> cand!.k) then
            return nonextensible; 
        fi;
    fi;

    npgs.currentRow:=sb;
    npgs.fullrows:=ShallowCopy(cand!.fullrows);
    npgs.kIsForced:=cand!.kIsForced;
    npgs.k:=cand!.k;
    npgs.lbdIsForced:=cand!.lbdIsForced;
    npgs.lbd:=cand!.lbd;
    
    if not cand!.kIsForced then
        if sb>1 then
            
            npgs.kIsForced:=true;
            npgs.k:=cand!.degreelist[1];
            npgs.fullrows:=Filtered([1..Length(cand!.blocks)], x->cand!.degreelist[x]=npgs.k);
            
            if npgs.k<cand!.maxdeg then
                return nonextensible;
            fi;
            if ForAny([2..sb-1], x->cand!.degreelist[x]<>npgs.k) then
                return nonextensible;
            fi;
            
#            if ForAny([sb..Length(cand!.blocks)], x->cand!.degreelist[x]>npgs.k) then
#                return nonextensible;
#            fi;
            
            for i in [1..Length(npgs.fullrows)] do
                a:=npgs.fullrows[i];
                for j in [i..Length(npgs.fullrows)] do
                    b:=npgs.fullrows[j];
                    block:=cand!.blockingmat[a][b];
                    if block<>[] then
                        npgs.lbdIsForced:=true;
                        npgs.lbd:=cand!.square[block[1]];
                        if npgs.lbd<cand!.maxlbd then
                            return nonextensible;
                        fi;
                        break;
                    fi;
                od;
                if npgs.lbdIsForced then
                    break;
                fi;
            od;
            if npgs.lbdIsForced then
                for i in [i..Length(npgs.fullrows)] do
                    a:=npgs.fullrows[i];
                    for j in [i..Length(npgs.fullrows)] do
                        b:=npgs.fullrows[j];
                        if ForAny(cand!.blockingmat[a][b], x->cand!.square[x]<>npgs.lbd) then
                            return nonextensible;
                        fi;
                    od;
                od;
            fi;
        fi;
    fi;
        
    if npgs.lbdIsForced and (cand!.square[color]>npgs.lbd or (color<>icolor and cand!.square[icolor]>npgs.lbd) )then
        return fail;
    fi;
    
    # starting from here we actually define the set of npgs
    npgs.set:=Union(cand!.set, [color,icolor]);
    npgs.ridx:=Union(cand!.ridx,[sb,fb]);
    
    sd:=OutValencies(cgr);
    
    npgs.blockingmat:=ShallowCopy(cand!.blockingmat);
    npgs.blockingmat[sb]:=ShallowCopy(npgs.blockingmat[sb]);
    npgs.blockingmat[sb][fb]:=ShallowCopy(npgs.blockingmat[sb][fb]);
    AddSet(npgs.blockingmat[sb][fb],color);
    
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
    
    if npgs.kIsForced and npgs.degreelist[sb]=npgs.k then
        AddSet(npgs.fullrows,sb);
    fi;
    
    if fb<>sb and  npgs.kIsForced and npgs.degreelist[fb]=npgs.k then
        AddSet(npgs.fullrows,fb);
    fi;
    if Length(npgs.set) = npgs.maxlength then
        npgs.domain:=[];
        npgs.domdegreelist:=ListWithIdenticalEntries(Length(cand!.domdegreelist), 0);
        if ForAny(npgs.degreelist, x->x<> npgs.maxdeg) then
            return fail;
        fi;
    else
        npgs.domain:=ShallowCopy(cand!.domain);
        npgs.domdegreelist:=ShallowCopy(cand!.domdegreelist);
        for j in [1..Length(cand!.domain)] do
            k:=cand!.domain[j];
            kmts:=cand!.imap[k];
            ksb:=cand!.startBlock[kmts[1]];
            kfb:=cand!.finishBlock[kmts[1]];
            if kfb < ksb then
                kmts:=Reversed(kmts);
                ksb:=cand!.startBlock[kmts[1]];
                kfb:=cand!.finishBlock[kmts[1]];
            fi;
            if k<=pt or
               Length(npgs.set)+Length(kmts) > npgs.maxlength or 
               ksb in npgs.fullrows or
               kfb in npgs.fullrows or
               (npgs.kIsForced and ksb=kfb  and Length(kmts)=2 and sd[kmts[1]]+sd[kmts[2]]+npgs.degreelist[ksb]>npgs.k) or
               (npgs.kIsForced and ksb=kfb  and Length(kmts)=1 and sd[kmts[1]]+npgs.degreelist[ksb]>npgs.k) or
               (npgs.kIsForced and ksb<>kfb and sd[kmts[1]]+npgs.degreelist[ksb]>npgs.k) or
               (npgs.kIsForced and ksb<>kfb and Length(kmts)=2 and sd[kmts[2]]+npgs.degreelist[kfb]>npgs.k)
            then
                npgs.domdegreelist[ksb]:=npgs.domdegreelist[ksb]-sd[kmts[1]];
                RemoveSet(npgs.domain,k);
                if npgs.domdegreelist[ksb]+npgs.degreelist[ksb]<npgs.maxdeg then
                    return fail;
                fi;
                if Length(kmts)=2 then
                    npgs.domdegreelist[kfb]:=npgs.domdegreelist[kfb]-sd[kmts[2]];
                    if npgs.domdegreelist[kfb]+npgs.degreelist[kfb]<npgs.maxdeg then
                        return fail;
                    fi;
                fi;
            fi;
        od;    
    fi;
    
    Assert(1, ForAll([1..Length(npgs.blocks)], i->npgs.domdegreelist[i]+npgs.degreelist[i] >= npgs.maxdeg));
    
    # starting from here the field npgs.square is computed

    npgs.square:=ShallowCopy(cand!.square);
    npgs.maxlbd:=cand!.maxlbd;
    
    sq:=npgs.square;
    ent:=t!.entries;
    blkIdx:=t!.blkIdx;
    bm:=npgs.blockingmat;

    for a in npgs.ridx do
        for b in npgs.ridx do
            block:=bm[a][b];
            bbl:=cand!.blocks[a][b];
            if bbl = [] or not a in [sb,fb] and not b in [sb,fb]  then
                continue;
            fi;
            ba:=a/npgs.perm;
            bb:=b/npgs.perm;
            if a = sb and b = sb then # C C*
                c:=fb;
                bc:=c/npgs.perm;
                sq{bbl}:=sq{bbl}+ent[ba][bb][bc][blkIdx[color]][blkIdx[icolor]];
            fi;
            if a = sb  then # C A*
                c:=fb;
                bc:=c/npgs.perm;
                for j in cand!.blockingmat[c][b] do
                    sq{bbl}:=sq{bbl}+ent[ba][bb][bc][blkIdx[color]][blkIdx[j]];
                od;
            fi;
            if  b = sb then # A C*
                c:=fb;
                bc:=c/npgs.perm;
                for i in cand!.blockingmat[a][c] do
                    sq{bbl}:=sq{bbl}+ent[ba][bb][bc][blkIdx[i]][blkIdx[icolor]];
                od;
            fi;
            if color <> icolor then 
                if  b=fb  then # A C
                    c:=sb;
                    bc:=c/npgs.perm;
                    for i in cand!.blockingmat[a][c] do
                        sq{bbl}:=sq{bbl}+ent[ba][bb][bc][blkIdx[i]][blkIdx[color]];
                    od;
                fi;
            
                if a = sb and b = fb and sb = fb then # C C, C* C*
                    c:=sb;
                    bc:=c/npgs.perm;
                    sq{bbl}:=sq{bbl}+ent[ba][bb][bc][blkIdx[color]][blkIdx[color]];
                    sq{bbl}:=sq{bbl}+ent[ba][bb][bc][blkIdx[icolor]][blkIdx[icolor]];
                fi;
            
                if a = fb then # C* A*
                    c:=sb;
                    bc:=c/npgs.perm;
                    for j in cand!.blockingmat[b][c] do
                        sq{bbl}:=sq{bbl}+ent[ba][bb][bc][blkIdx[icolor]][blkIdx[j^ColorMates(cgr)]];
                    od;
                fi;
                if a = fb and b = fb then # C* C
                    c:=sb;
                    bc:=c/npgs.perm;
                    sq{bbl}:=sq{bbl}+ent[ba][bb][bc][blkIdx[icolor]][blkIdx[color]];
                fi;
            fi;
            
            if block <> [] then
                npgs.maxlbd:=Maximum(npgs.maxlbd, Maximum(sq{block}));
                    
                if npgs.lbdIsForced  and npgs.maxlbd > npgs.lbd then
                    return fail;
                fi;
                        
                if a in npgs.fullrows and b in npgs.fullrows then
                    if not npgs.lbdIsForced then
                        npgs.lbdIsForced := true;
                        npgs.lbd:=sq[block[1]];
                        if npgs.lbd <> npgs.maxlbd then
                            return fail;
                        fi;
                    fi;
                    if ForAny(block, x->sq[x]<>npgs.lbd) then
                        return fail;
                    fi;
                fi;
            fi;
        od;
    od;
    Assert(1,sq=ComplexProduct(t,npgs.set,npgs.set));
    Objectify(NewType(PartialArcRegularSetsFamily(cgr), IsSymPartialArcRegularSet and IsSymPartialArcRegularSetBlkRep), npgs);
    return npgs;
end);

