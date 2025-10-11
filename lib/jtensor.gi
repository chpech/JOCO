############################################
#F  JTensorFromColorReps( <cgr>, <creps> )
##    Trys to construct a tensor of J-structure constants for <cgr>
##    <creps> is a list of arcs of <cgr>.
##    There has to be at least one arc from each color of <cgr>.
##    This constructor is not supposed to be used by the user of coco
#
# cgr must be a rainbow (otherwise it can not be J-stable and hence 
# it cannot have a tensor of J-structure constants)
# for rainbows the colors of cgr may be blocked according to the reflexive colors of cgr
# if there is just one reflexive color then a tensor in IsTensorRep is returned
# otherwise a tensor in IsBlockedTensorRep is returned
# note that the partition of vertices into fibres is not necessarily equitable for cgr
# as there are, e.g.,  homogeneous J-stable cgrs that are not regular
InstallGlobalFunction(JTensorFromColorReps,
function(cgr,tor)
    local o,r,k,i,j,tensor,mat,submat,
          row,column,pos,
          part,
          refl,irrefl,
          reflexiveColors, rowBlk, colBlk,
          blocks, blockIndices,
          entries,a,b,c,
          rb,cb,
          bltensor;
    
    if not IsRainbow(cgr) then
        return fail;
    fi;
    
    part := List([1..RankOfColorGraph(cgr)], x->[]);
    refl:=List([1..RankOfColorGraph(cgr)], x->false);
    irrefl:=List([1..RankOfColorGraph(cgr)], x->false);
    for i in [1..Length(tor)] do
        j:=ArcColorOfColorGraph(cgr,tor[i]);
        Add(part[j], i);
        if tor[i][1]=tor[i][2] then
            refl[j]:=true;
        else
            irrefl[j]:=true;
        fi;
        if irrefl[j] and refl[j] then
            return fail;
        fi;
    od;
    
    reflexiveColors:=ListBlist([1..RankOfColorGraph(cgr)], refl);
    rowBlk:=[];
    colBlk:=[];
    blocks:=List([1..Length(reflexiveColors)], x->List([1..Length(reflexiveColors)], x->[]));
    blockIndices:=[];
    for i in [1..RankOfColorGraph(cgr)] do
        for o in part[i] do
            rb:=Position(reflexiveColors, ArcColorOfColorGraph(cgr, tor[o][1],tor[o][1]));
            if not IsBound(rowBlk[i]) then
                rowBlk[i]:=rb;
            else
                if rowBlk[i]<>rb then
                    return fail;
                fi;
            fi;
            cb:=Position(reflexiveColors, ArcColorOfColorGraph(cgr, tor[o][2],tor[o][2]));
            if not IsBound(colBlk[i]) then
                colBlk[i]:=cb;
            else
                if colBlk[i]<>cb then
                    return fail;
                fi;
            fi;
        od;
        Add(blocks[rowBlk[i]][colBlk[i]],i);
        blockIndices[i]:=Length(blocks[rowBlk[i]][colBlk[i]]);
        # if color i has starting block a and finishing block b then
        # blockIndices[i] is the index of i on the blocks[a][b]
        # recall the blocks[a][b] is the list of all colors that start 
        # at block a and finish at block b
    od;
    
    entries:=List([1..Length(reflexiveColors)],
                  a->List([1..Length(reflexiveColors)],
                          b->List([1..Length(reflexiveColors)],
                                  c->[])));
    
    for r in tor do
        k:=ArcColorOfColorGraph(cgr,r);
        a:=rowBlk[k];
        b:=colBlk[k];
        mat:=LocalIntersectionArray(cgr,r);
        mat:=mat + TransposedMat(mat);   # note that we do not divide by two anymore because 
                                         # of the changed definition os JStructureConstants
        for c in [1..Length(reflexiveColors)] do
            submat:=List(mat{blocks[a][c]}, x->x{blocks[c][b]});
            if IsBound(entries[a][b][c][blockIndices[k]]) then
                if submat<>entries[a][b][c][blockIndices[k]] then
                    
                    return fail;
                fi;
            else
                entries[a][b][c][blockIndices[k]]:=submat;
            fi;
        od;
    od;
    
    if Length(blocks)>1 then
        for a in [1..Length(reflexiveColors)] do
            for b in [1..Length(reflexiveColors)] do
                for c in [1..Length(reflexiveColors)] do
                    bltensor:=[];
                    for k in [1..Length(entries[a][b][c])] do
                        for i in [1..Length(entries[a][b][c][k])] do
                            for j in [1..Length(entries[a][b][c][k][i])] do
                                if not IsBound(bltensor[i]) then
                                    bltensor[i]:=[];
                                fi;
                                if not IsBound(bltensor[i][j]) then
                                    bltensor[i][j]:=[];
                                fi;
                                bltensor[i][j][k]:=entries[a][b][c][k][i][j];
                            od;
                        od;
                    od;
                    entries[a][b][c]:=bltensor;
                od;
            od;
        od;
        tensor:=rec(
                     reflexiveColors := reflexiveColors,
                     rowBlk          := rowBlk,
                     colBlk          := colBlk,
                     blocks          := blocks,
                     blkIdx          := blockIndices,
                     knownAutGroup   := KnownGroupOfColorAutomorphismsOnColors(cgr),
                     vertexNames     := ColorNames(cgr),
                     entries         := entries
                    );

        tensor:=Objectify(NewType(TensorFam, IsBlockedTensorRep), tensor);
    else
        tensor := rec(
                       entries:=List([1..RankOfColorGraph(cgr)],i->
                                                                 List([1..RankOfColorGraph(cgr)], j->
                                                                                                   List([1..RankOfColorGraph(cgr)],k->entries[1][1][1][k][i][j]))),
                       knownAutGroup   := KnownGroupOfColorAutomorphismsOnColors(cgr),
                       vertexNames     := ColorNames(cgr)
                      );
        
        tensor:= Objectify(NewType(TensorFam, IsTensorRep), tensor);
    fi;
    
    if HasMates(cgr) then
        SetMates(tensor, Mates(cgr));
    fi;
    SetReflexiveColors(tensor, reflexiveColors);
    SetOrderOfCocoObject(tensor, RankOfColorGraph(cgr));
    
    return tensor;
end);

InstallMethod(EntryOfTensor,
     "for blocked tensors",
        [IsTensor and IsBlockedTensorRep and IsTensorOfJC,
         IsPosInt,
         IsPosInt,
         IsPosInt],
function(T,i,j,k)
    local  blk1, blk2, blk, a, b, c;
    
    blk1:=[T!.rowBlk[i],T!.colBlk[j]];
    blk2:=[T!.rowBlk[j],T!.colBlk[i]];
    blk:=[T!.rowBlk[k],T!.colBlk[k]];
    if blk = blk1 then
        a:=blk1[1];
        b:=blk1[2];
        c:=T!.colBlk[i];
        if T!.rowBlk[j]<>c then
            return 0;
        fi;
        return T!.entries[a][b][c][T!.blkIdx[i]][T!.blkIdx[j]][T!.blkIdx[k]];
    elif blk=blk2 then
        a:=blk2[1];
        b:=blk2[2];
        c:=T!.colBlk[j];
        if T!.rowBlk[i]<>c then
            return 0;
        fi;
        return T!.entries[a][b][c][T!.blkIdx[j]][T!.blkIdx[i]][T!.blkIdx[k]];
    fi;
    
    return 0;
end);



InstallMethod(PbagInvariant,
   "for tensors",
   [IsTensor and IsTensorOfJC, IsTensor and IsTensorOfJC],
function(tensor1,tensor2)
   local TestAutomorphism, TestIsomorphism, Invariant, HashFunction;

   TestIsomorphism:=function(T1, T2, perm)
       local W1,W2, i, j, k,o;

       W1:=T1.T;
       W2:=T2.T;
       o:=T1.v;
       for i in [1..o] do
          for j in [1..o] do
             for k in [1..o] do
                if EntryOfTensor(W1,i,j,k) <> EntryOfTensor(W2, i^perm, j^perm, k^perm) then
                                   return false;
                fi;
             od;
          od;
       od;
       return true;
   end;

   TestAutomorphism:=function(T1, perm)
       local W1,W2, i, j, k,o;

       W1:=T1.T;
       o:=T1.v;
       for i in [1..o] do
          for j in [1..o] do
             for k in [1..o] do
                if EntryOfTensor(W1,i,j,k) <> EntryOfTensor(W1, i^perm, j^perm, k^perm) then
                                   return false;
                fi;
             od;
          od;
       od;
       return true;
   end;

   Invariant:=function(TRec, i)
       local j, k, kidx, inv, inc, color1, color2,a,b,c,lk;
       inv:=[];

        for j in TRec.ST do
           Add(inv, EntryOfTensor(TRec.T, j,j,i));
           if TRec.S<>[] then
             lk:=[TRec.S[Length(TRec.S)]];
           else
             lk:=[];
           fi;
           for k in lk do #TRec.ST do
               Add(inv, 2*EntryOfTensor(TRec.T,i,j,k));
               Add(inv, 2*EntryOfTensor(TRec.T,i,k,j));
               Add(inv, 2*EntryOfTensor(TRec.T,j,i,k));
               Add(inv, 2*EntryOfTensor(TRec.T,j,k,i));
               Add(inv, 2*EntryOfTensor(TRec.T,k,i,j));
               Add(inv, 2*EntryOfTensor(TRec.T,k,j,i));
           od;
       od;
       Add(inv, TRec.fvc[i]);
       return inv;
   end;

   HashFunction:=function(Tinv)
       return Tinv*[1..Length(Tinv)];
   end;

   return rec(finv   :=Invariant,
              hashinv:=HashFunction,
              test   :=TestIsomorphism,
              autTest:=TestAutomorphism);
end);

InstallOtherMethod(ReflexiveColors,
   "for tensors of Jordan configurations",
   [IsTensor  and IsTensorOfJC],
function(tensor)
    local result;
    result := Filtered([1..Order( tensor )],
                      x -> EntryOfTensor( tensor, x, x, x ) = 1);
    result := Filtered(result, x -> Sum(ComplexProduct(tensor, [x], [x]))=1);
    return result;
end);

InstallOtherMethod( IsPrimitive,
        "for J-structure constants tensors",
        [IsTensor and IsTensorOfJC],
function(tensor)
    
    return IsHomogeneous(tensor) and ForAll(Difference([1..Order(tensor)],ReflexiveColors(tensor)), x->ClosureSet( tensor, [x] ) = [1..Order(tensor)]);
end);

InstallOtherMethod(NumberOfFibres,
		"for J-structure constants tensors",
		[IsTensor and IsTensorOfJC],
function(tensor)
   return Length(ReflexiveColors(tensor));
end);

InstallImmediateMethod(IsHomogeneousTensor,
		"for J-structure constants tensors",
	IsTensor and IsTensorOfJC,
function(tensor)
  return NumberOfFibres(tensor)=1;
end);

InstallOtherMethod(IsHomogeneous,
		"for J-structure constants tensors",
	[IsTensor and IsTensorOfJC],
function(tensor)
  return IsHomogeneousTensor(tensor);
end);

InstallOtherMethod(Mates,
   "for tensors of J-structure constants",
   [IsTensor and IsTensorOfJC],
function(tensor)
    return ();
end);
