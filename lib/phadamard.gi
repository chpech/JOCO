# we are looking for sets M of colors of cgr with the property that the associated 
# matrix H = H(M) = J - 2A(M) of order Order(cgr) satisfies 
#                 HH^t = nI - (J-I) = (n+1)I - J, and 
#                   HJ = JH = -J.
# Here A(M) is the n x n matric that has A_{i,j} = 1 iff the color of the arc (i,j) 
# in cgr is an element of M, and A_{i,j} = 0, otherwise.
# note that M is allowed to contain reflexive colors.
# If M is a Hadamard set of cgr, then adding a row and a column of ones to H(M),
# we obtain a Hadamard matrix. It follows that n should be congruent 3 mod 4. 
# Since we are working with the Jordan product, the first identity above translates to 
#              H * H^t = 2nI - 2(J-I)


DeclareRepresentation("IsPartialHadamardSetRep",
        IsPartialStableSetRep,
        [ "cgr",
          "map",
          "imap",
          "domain",
          "set",
          "square"]);

                      
DeclareRepresentation("IsPartialHadamardSetBlkRep",
        IsPartialHadamardSetRep,
        [ "cgr",
          "map",
          "imap",
          "domain",
          "set",
          "square",
          "blocks", # blocks[a][b] contains all colors i with sb(i)=a, fb(i)=b
          "perm",   # this permutation sorts the blocks by increasing size 
          "startBlock",
          "finishBlock",
          "currentRow",
          "blockingmat",
          "rowdegs",
          "coldegs",
          "rmindeg",
          "cmindeg",
          "domrowdegs",
          "domcoldegs",
          "ridx",   # block rows from which colors are present in set
          "cidx",   # block columns from which colors a re present in set
          "fullrows",
          "fullcols",
          "minlbd",
          ]);


InstallMethod(PartialHadamardSetsFamily,
"for color graphs",
[IsColorGraph],
function(cgr)
   local fam;
   fam:=NewFamily("PartialHadamardSetsFam", IsPartialHadamardSet);
   return fam;
end);

InstallMethod(EmptyPartialHadamardSet,
        "for well-fibred J-stable color graphs",
        [IsColorGraph and IsJStableColorGraph and IsWellFibredRainbow],
function(cgr)
    local  tensor, mat, vec, perm, blocks, startBlock, finishBlock, 
           nof, imap, a, b, clr, map, i, domrowdegs, domcoldegs, sb, 
           fb, cand;
    
    if OrderOfColorGraph(cgr) mod 4 <> 3 then
        return fail;
    fi;
    
    tensor:=JStructureConstantsOfColorGraph(cgr);
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
        for b in [a..nof] do 
            if a=b then
                clr:=ShallowCopy(blocks[a][a]);
                SortBy(clr, i->-OutValencies(cgr)[i]);
                Append(imap, clr);
            else
                clr:=ShallowCopy(blocks[a][b]);
                SortBy(clr, i->-OutValencies(cgr)[i]);
                clr:=Concatenation(List(clr, c->[c,c^ColorMates(cgr)]));
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
        domrowdegs[sb]:=domrowdegs[sb]+OutValencies(cgr)[i];
        domcoldegs[fb]:=domcoldegs[fb]+OutValencies(cgr)[i^ColorMates(cgr)];
    od;
    
    
    cand:=rec(cgr:=cgr,
              map:=map,
              imap:=imap,
              domain:=[1..Length(imap)],
              blocks:=blocks,
              perm:=perm,
              startBlock:=startBlock, # the block from which a color starts
              finishBlock:=finishBlock, # the block where a color finishes
              # colors are added in a Gamma-shape
              # the order of blocks is [1,1], [1,2], [2,1], ... [1,n], [n,1],
              #                        [2,2], [2,3], [3,2], ... [2,n], [n,2],
              #                         ...
              #                                                        [n,n].
              currentRow:=0, # the row/column of blocks where currently colors are added
              set:=[],
              maxlength:=RankOfColorGraph(cgr),
              blockingmat:=List([1..nof], a->List([1..nof], b->[])),
              rowdegs:=ListWithIdenticalEntries(nof,OrderOfColorGraph(cgr)),
              coldegs:=ListWithIdenticalEntries(nof,OrderOfColorGraph(cgr)),
              rmindeg:=OrderOfColorGraph(cgr),
              cmindeg:=OrderOfColorGraph(cgr),
              minlbd:=2*OrderOfColorGraph(cgr),
              domrowdegs:=domrowdegs,
              domcoldegs:=domcoldegs,
              ridx:=[],
              cidx:=[],
              square:=ListWithIdenticalEntries(RankOfColorGraph(cgr),2*OrderOfColorGraph(cgr)),
              fullrows:=[],
              fullcols:=[]);
    return Objectify(NewType(PartialHadamardSetsFamily(cgr), 
           IsPartialHadamardSet and IsPartialHadamardSetBlkRep), cand);
end);


InstallMethod(IsCompletePartialStableSet,
    "for partial Hadamard sets in PartialHadamardSetBlkRep",
    [IsPartialHadamardSet and IsPartialHadamardSetBlkRep],
function(cand)
    local a,b,block;
    
    if cand!.set=[] then
        return false;
    fi;

    if cand!.rowdegs[1] <> cand!.coldegs[1] then
        return false;
    fi;
    if cand!.rowdegs[1] <> -1 then
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
        for a in [1..b] do 
            block:=cand!.blocks[a][b];
            if a = b then 
                block:=Difference(block, ReflexiveColors(cand!.cgr));
            fi;
            
            if ForAny(block, x->cand!.square[x]<>-2) then # we use jordan product AA* + A*A
                return false;  
            fi;
        od;
    od;
    
    return true;
end);


CheckSquare:=function(npgs)
    local  M2, M1, A1, A2, A, AA, sq;
    
    M2:=npgs!.set;
    M1:=Difference([1..Rank(npgs!.cgr)], M2);
    A1:=AdjacencyMatrix(npgs!.cgr, M1);
    A2:=AdjacencyMatrix(npgs!.cgr, M2);
    A:=A1-A2;
    AA:=A*TransposedMat(A) + TransposedMat(A) * A;
    sq:=List([1..Rank(npgs!.cgr)], i->ColorRepresentative(npgs!.cgr,i));
    sq:=List(sq, x->AA[x[1]][x[2]]);
    if sq <> npgs!.square then
        
        return false;
    fi;
    return true;
end;

    
InstallMethod(ExtendedPartialStableSet,
"for partial Hadamard sets in PartialarcHadamardSetBlkRep",
[IsPartialHadamardSet and IsPartialHadamardSetBlkRep, IsPosInt],
function(cand,pt)
    local  cgr, t, npgs, color, sb, fb, sblk, 
           a, b, block, sd, icolor, md, 
           k, kmts, ksb, kfb, sq, bm, ent, blkIdx, bbl, 
           c, ba, bb, bc, i, j, ii, ij;
    
    cgr:=cand!.cgr;
    
    t:=JStructureConstantsOfColorGraph(cgr);
    
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
    
    sblk:=AsSortedList([sb,fb]);
    
    if cand!.fullrows <> [] and sblk[1]>cand!.currentRow then  
        if ForAny([cand!.currentRow..sblk[1]-1], b->cand!.rowdegs[b] <> -1) then
            Info(InfoCOCO,2,"D");
            return nonextensible; 
        fi;
        if ForAny([cand!.currentRow..sblk[1]-1], b->cand!.coldegs[b] <> -1) then
            Info(InfoCOCO,2,"E");
            return nonextensible; 
        fi;
    fi;
    
    npgs.currentRow:=sblk[1];
    
    npgs.fullrows:=ShallowCopy(cand!.fullrows);
    npgs.fullcols:=ShallowCopy(cand!.fullcols);
    
    if npgs.fullrows = [] then
        if sblk[1] > 1 then
            
            npgs.fullrows:=Filtered([1..Length(cand!.blocks)], x->cand!.rowdegs[x]=-1);
            npgs.fullcols:=Filtered([1..Length(cand!.blocks)], x->cand!.coldegs[x]=-1);
            
            if ForAny([2..sblk[1]-1], x->cand!.rowdegs[x]<>-1 ) then
                Info(InfoCOCO,2,"A");
                return nonextensible;
            fi;
            if ForAny([2..sblk[1]-1], x->cand!.coldegs[x]<>-1) then
                Info(InfoCOCO,2,"B");
                return nonextensible;
            fi;
            
            for a in npgs.fullrows do
                for b in npgs.fullcols do
                    block:=cand!.blockingmat[a][b];
                    if a = b then
                        block:=Difference(block, ReflexiveColors(cgr));
                    fi;
                    
                    if ForAny(block, x->cand!.square[x]<>-2) then
                        
                        Info(InfoCOCO,2,"C");
                        return nonextensible;
                    fi;
                od;
            od;
            
        fi;
    fi;
    
    # if cand!.square[color]<-2 then
    #     Info(InfoCOCO,2,"1");
        
    #     return fail;
    # fi;
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
    
    npgs.rowdegs[sb]:=npgs.rowdegs[sb]-2*sd[color];
    npgs.rmindeg:=Minimum(npgs.rowdegs[sb], cand!.rmindeg);
    icolor:=color^ColorMates(cgr);
    npgs.coldegs[fb]:=npgs.coldegs[fb]-2*sd[icolor];
    npgs.cmindeg:=Minimum(npgs.coldegs[fb], cand!.cmindeg);    
    md:=Minimum(npgs.rmindeg, npgs.cmindeg);
    
    if md<-1 then
        Info(InfoCOCO,2,"2");
        return fail;
    fi;
    
    if npgs.rowdegs[sb]=-1 then
        AddSet(npgs.fullrows,sb);
    fi;
    
    if npgs.coldegs[fb]=-1 then
        AddSet(npgs.fullcols,fb);
    fi;
    
    
    if npgs.fullrows = [1..Length(npgs.blocks)] then 
        npgs.domain:=[];
        npgs.domrowdegs:=ListWithIdenticalEntries(Length(cand!.domrowdegs), 0);
        npgs.domcoldegs:=ListWithIdenticalEntries(Length(cand!.domcoldegs), 0);
    else
        npgs.domain:=ShallowCopy(cand!.domain);
        npgs.domrowdegs:=ShallowCopy(cand!.domrowdegs);
        npgs.domcoldegs:=ShallowCopy(cand!.domcoldegs);
        for k in cand!.domain do
            kmts:=[cand!.imap[k][1],cand!.imap[k][1]^ColorMates(cgr)];
            ksb:=cand!.startBlock[kmts[1]];
            kfb:=cand!.finishBlock[kmts[1]];
            if k<=pt or  
               ksb in npgs.fullrows or
               kfb in npgs.fullcols or
               -2*sd[kmts[1]]+npgs.rowdegs[ksb]<-1 or 
               -2*sd[kmts[2]]+npgs.coldegs[kfb]<-1 
            then
                
                npgs.domrowdegs[ksb]:=npgs.domrowdegs[ksb]-sd[kmts[1]];
                npgs.domcoldegs[kfb]:=npgs.domcoldegs[kfb]-sd[kmts[2]];
                RemoveSet(npgs.domain,k);
                if -2*npgs.domrowdegs[ksb]+npgs.rowdegs[ksb]>-1 or 
                   -2*npgs.domcoldegs[kfb]+npgs.coldegs[kfb]>-1 then
                    Info(InfoCOCO,2,"3");
                    
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
    npgs.minlbd:=cand!.minlbd;
    ent:=t!.entries;
    blkIdx:=t!.blkIdx;
    
    #2(J * c) + 2(J * c*)
    for a in [1..Length(npgs.blocks)] do
        bbl:=cand!.blocks[a][fb];
        sq{bbl}:=sq{bbl} - 2*List(bbl, x->sd[icolor]);
        bbl:=cand!.blocks[sb][a];
        sq{bbl}:=sq{bbl} - 2*List(bbl, x->sd[color]);
        bbl:=cand!.blocks[a][sb];
        sq{bbl}:=sq{bbl} - 2*List(bbl, x->sd[color]);
        bbl:=cand!.blocks[fb][a];
        sq{bbl}:=sq{bbl} - 2*List(bbl, x->sd[icolor]);
    od;
    
        
    if sb = fb then 
        for a in Union(npgs.ridx,npgs.cidx) do
            for b in Union(npgs.ridx,npgs.cidx) do
                block:=bm[a][b];
                if a=b then
                    block:=Difference(block,ReflexiveColors(cgr));
                fi;
                
                bbl:=cand!.blocks[a][b];
                if a <> sb and b <> sb then
                    continue;
                fi;
                c:=fb;
                ba:=a/npgs.perm;
                bb:=b/npgs.perm;
                bc:=c/npgs.perm;
                if a = sb and b = sb then  # color * icolor
                    sq{bbl}:=sq{bbl}+4*ent[ba][bb][bc][blkIdx[color]][blkIdx[icolor]];
                fi;
                
                if a in cand!.ridx and b = sb then # A icolor
                    for i in cand!.blockingmat[a][c] do
                        sq{bbl}:=sq{bbl}+4*ent[ba][bb][bc][blkIdx[i]][blkIdx[icolor]];
                    od;
                fi;
                if a = fb and b in cand!.cidx and b<>sb  then # icolor A
                    for j in cand!.blockingmat[c][b] do
                        sq{bbl}:=sq{bbl}+4*ent[ba][bb][bc][blkIdx[icolor]][blkIdx[j]];
                    od;
                fi;
                if a in cand!.cidx and b = fb then # A* color
                    for i in cand!.blockingmat[c][a] do
                        ii:=i^ColorMates(cgr);
                        sq{bbl}:=sq{bbl}+4*ent[ba][bb][bc][blkIdx[ii]][blkIdx[color]];
                    od;
                fi;
                if a =sb and b in cand!.ridx and b <> fb  then # color A*
                    for j in cand!.blockingmat[b][c] do
                        ij:=j^ColorMates(cgr);
                        sq{bbl}:=sq{bbl}+4*ent[ba][bb][bc][blkIdx[color]][blkIdx[ij]];
                    od;
                fi;
                if block <> [] then
                    npgs.minlbd:=Minimum(npgs.minlbd, Minimum(sq{block}));
                    
                    # if npgs.minlbd < -2 then
                    #     Info(InfoCOCO,2,"4");
                    #     return fail;
                    # fi;
                    
                    # check all new complete blocks of npgs
                    if a in npgs.fullrows and a in npgs.fullcols and
                       b in npgs.fullrows and b in npgs.fullcols and
                       not ( a in cand!.fullrows and a in cand!.fullcols and
                             b in cand!.fullrows and b in cand!.fullcols) and
                           ForAny(block, x->sq[x]<>-2) then
                        Info(InfoCOCO,2,"5");
                        return fail;
                    fi;
                fi;
            od;
        od;
        
        Assert(1, CheckSquare(npgs));
        
    #        Assert(1,sq=ComplexProduct(t,npgs.set,OnSets(npgs.set,ColorMates(cgr))));
    else
        for a in Union(npgs.ridx,npgs.cidx) do
            for b in Union(npgs.ridx, npgs.cidx) do
                block:=bm[a][b];
                
                if a = b then
                    block:=Difference(block,ReflexiveColors(cgr));
                fi;
                
                bbl:=cand!.blocks[a][b];
                if not a in [sb,fb] and  not b in [sb,fb] then
                    continue;
                fi;

                ba:=a/npgs.perm;
                bb:=b/npgs.perm;
                if a = sb and b = sb then # c c*
                    c:=fb;
                    bc:=c/npgs.perm;
                    sq{bbl}:=sq{bbl}+4*ent[ba][bb][bc][blkIdx[color]][blkIdx[icolor]];
                fi;
                if a = fb and b = fb then # c* c
                    c:=sb;
                    bc:=c/npgs.perm;
                    sq{bbl}:=sq{bbl}+4*ent[ba][bb][bc][blkIdx[icolor]][blkIdx[color]];
                fi;
                if a in cand!.ridx and b = sb then # A icolor
                    c:=fb;
                    bc:=c/npgs.perm;
                    for i in cand!.blockingmat[a][c] do
                        sq{bbl}:=sq{bbl}+4*ent[ba][bb][bc][blkIdx[i]][blkIdx[icolor]];
                    od;
                fi;
                if a = fb and b in cand!.cidx then # icolor A
                    c:=sb;
                    bc:=c/npgs.perm;
                    for j in cand!.blockingmat[c][b] do
                        sq{bbl}:=sq{bbl}+4*ent[ba][bb][bc][blkIdx[icolor]][blkIdx[j]];
                    od;
                fi;
                if a in cand!.cidx and b = fb then # A* color
                    c:=sb;
                    bc:=c/npgs.perm;
                    for i in cand!.blockingmat[c][a] do
                        ii:=i^ColorMates(cgr);
                        sq{bbl}:=sq{bbl}+4*ent[ba][bb][bc][blkIdx[ii]][blkIdx[color]];
                    od;
                fi;
                if a = sb and b in cand!.ridx then # color A*
                    c:=fb;
                    bc:=c/npgs.perm;
                    for j in cand!.blockingmat[b][c] do
                        ij:=j^ColorMates(cgr);
                        sq{bbl}:=sq{bbl}+4*ent[ba][bb][bc][blkIdx[color]][blkIdx[ij]];
                    od;
                fi;
                
                        
                if block <> [] then
                    npgs.minlbd:=Minimum(npgs.minlbd, Minimum(sq{block}));
                    
                    # if npgs.minlbd < -2 then
                    #     Info(InfoCOCO,2,"6");
                    #     return fail;
                    # fi;
                        
                    # check all new complete blocks of npgs
                    if a in npgs.fullrows and a in npgs.fullcols and
                       b in npgs.fullrows and b in npgs.fullcols and
                       not ( a in cand!.fullrows and a in cand!.fullcols and
                             b in cand!.fullrows and b in cand!.fullcols) and 
                           ForAny(block, x->sq[x]<> -2) then
                        
                        
                        Info(InfoCOCO,2,"7");
                        return fail;
                    fi;
                fi;
            od;
        od;
        Assert(1, CheckSquare(npgs));
        
#        Assert(1,sq=ComplexProduct(t,npgs.set,OnSets(npgs.set,ColorMates(cgr))));
    fi;
    
    
    Objectify(NewType(PartialHadamardSetsFamily(cgr), IsPartialHadamardSet and IsPartialHadamardSetBlkRep), npgs);
    return npgs;
end);

InstallMethod(PartialHadamardSetOrbitsFamilyOp,
        "for a color graph  and a permutation group",
        [IsColorGraph, IsPermGroup],
function(cgr,g)
    return NewFamily("PartialHadamardSetOrbitsFam", IsPartialStableSetOrbit);
end);

InstallMethod(GetPartialStableSetOrbitFamily,
"for partial Hadamard sets in PartialHadamardSetRep and a permutation group",
[IsPartialHadamardSet and IsPartialHadamardSetRep, IsPermGroup],
function(prset,grp)  
    return PartialHadamardSetOrbitsFamily(prset!.cgr,grp);
end);

InstallMethod( ViewString,
        "for partial Hadamard sets in PartialHadamardSetRep",
        [IsPartialHadamardSet and IsPartialHadamardSetRep],
function(prs)
    local cgr,s;
    
    cgr:=prs!.cgr;
    s:=prs!.set;

    return Concatenation("<partial Hadamard set ", String(s), ">");
end);


InstallMethod(ConstructorOfStableSetOrbit,
        "for all Hadamard sets",
        [IsHadamardSet],
function(orb)
    return HadamardSetOrbit;
end);
