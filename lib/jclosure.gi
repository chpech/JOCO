#############################################################################
##
##  jclosure.g4                  COCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##                                                             Sven Reichard
##
##  Implementation of the Jstabilisation that works inside
##  a given coherent configuration
##
#############################################################################


# a partition is a record:
#rec(
#    fixed=[],              # list of colors not allowed to split during stabilization
#    variable=[],           # list of colors allowd to split during stabilization
#    classes=[],            # ordered partition of colors of the underlying CC
#                           # numbers in fixed and variable refer to indices into this list
#    instabil=FiFoNew(),
#    instabilFlags=[],
#    totest==FiFoNew(),
#    totestFlags=[],
#    colorNames,
#    numberClasses
#    );




JRepartition:=function(T, part, u,v,min)
    local sym,vec,ix,x,i,j,ii,jj,colour, classes;

    sym:=ValueOption("sym");
    if sym=fail then
        sym:=false;
    fi;
    
    vec := ComplexProduct(T, WLPartitionClass(part,u), WLPartitionClass(part,v));
    if u <> v then 
        vec := vec + ComplexProduct(T, WLPartitionClass(part,v), WLPartitionClass(part,u));
    fi;
    

    for ix in part.fixed do
        x:=WLPartitionClass(part,ix);
        colour:=vec[x[1]];
        for j in [2..Length(x)] do
            if vec[x[j]]<>colour then
                
                return fail;
            fi;
        od;
    od;

    for ii in part.variable do
        x:=WLPartitionClass(part,ii);
        colour:=Set(x, y->vec[y]);
        if Length(colour)>1 then
            classes:=List(colour, y->Filtered(x, z->vec[z]=y));
            if ForAny(classes, x->Length(x)< Length(min) or (Length(x)=Length(min) and x< min)) then
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
end;


JStabil:=function(arg)
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
            if u<>v and
               not IsCommutativeTensor(T) and
               (WLIsAntiSymmetricSet(T,part,v) or
                WLIsAntiSymmetricSet(T,part,u)) then
                if JRepartition(T, part, v, u,min)=fail then
                    return fail;
                fi;
            fi;
            v:=WLToTestQueueRemove(part);
        od;
        u:=WLInstabilQueueRemove(part);
    od;
    return part;
end;



IsJStablePartition:=function(T,p)
    local part;

    part:=WLBuildFixedPartition(p);
    if JStabil(T,part)<>fail then
        return true;
    else
        return false;
    fi;
end;




