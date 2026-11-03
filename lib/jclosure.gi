#############################################################################
##
##  jclosure.g4                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Implementation of the Jordan stabilisation that works inside
##  a given J-stable color graph
##
#############################################################################

InstallGlobalFunction(JRepartition,
function(T, part, u,v,min)
    local sym,vec,ix,x,i,j,ii,jj,colour, classes,map;

    sym:=ValueOption("sym");
    if sym=fail then
        sym:=false;
    fi;
    
    vec := ComplexProduct(T, WLPartitionClass(part,u), WLPartitionClass(part,v));    

    for ix in part.fixed do
        x:=WLPartitionClass(part,ix);
        colour:=vec[x[1]];
        if ForAny([2..Length(x)], j->vec[x[j]]<>colour) then
            return fail;
        fi;
    od;

    for ii in part.variable do
        x:=WLPartitionClass(part,ii);
        colour:=Set(x, y->vec[y]);
        if Length(colour)>1 then
            map:=[];
            for i in [1..Length(colour)] do
                map[colour[i]+1]:=i;
            od;
            classes:=List(colour, x->[]);
            for v in x do
                Add(classes[map[vec[v]+1]], v);
            od;
            
            #            classes:=List(colour, y->Filtered(x, z->vec[z]=y));
            if ForAny(classes, x->Length(x) < Length(min) or (Length(x)=Length(min) and x < min)) then
                return fail;
            fi;
            if sym and ForAny(classes, x->not x[1]^Mates(T) in x) then
                return fail;
            fi;
            
            part.classes[ii]:=classes[1];
            if not WLIsInstabil(part,ii) then
                WLSetInstabilFlag(part,ii);
                FiFoAdd(part.instabil, ii);
            fi;
            if not WLIsToTest(part,ii) then
                WLSetToTestFlag(part,ii);
                FiFoAdd(part.totest,ii);
            fi;

            ix:=Length(part.classes);
            for j in [2..Length(classes)] do
                jj:=ix+j-1;
                Add(part.classes, classes[j]); Add(part.variable, jj);
                part.colorNames[jj]:=[part.colorNames[ii][1], part.numberClasses[part.colorNames[ii][1]]+j-1];
                WLSetInstabilFlag(part,jj);
                FiFoAdd(part.instabil,jj);
                WLSetToTestFlag(part,jj);
                FiFoAdd(part.totest,jj);
            od;
            part.numberClasses[part.colorNames[ii][1]]:=part.numberClasses[part.colorNames[ii][1]]+Length(classes)-1;
        fi;
    od;
    return part;
end);


InstallGlobalFunction(JStabil,
function(arg)
    local u,v, i,T,part,min;

    min:=[];
    if Length(arg)<2 or Length(arg)>3 then
       Error("JStabil(T,part,[minsize])");
    else
       T:=arg[1];
       part:=arg[2];
       if Length(arg)=3 then
          min:=arg[3];
       fi;
    fi;
    
    
    
    u:=WLInstabilQueueRemove(part);
    while u<>false do
        for i in [1..Length(part.classes)] do
            WLToTestQueueAdd(part, i);
        od;
        v:=WLToTestQueueRemove(part);
        while v<>false do
            if JRepartition(T, part, u, v,min)=fail then
                return fail;
            fi;
            # if u<>v and
            #    not IsCommutativeTensor(T) and
            #    (WLIsAntiSymmetricSet(T,part,v) or
            #     WLIsAntiSymmetricSet(T,part,u)) then
            #     if JRepartition(T, part, v, u,min)=fail then
            #         return fail;
            #     fi;
            # fi;
            v:=WLToTestQueueRemove(part);
        od;
        u:=WLInstabilQueueRemove(part);
    od;
    return part;
end);






