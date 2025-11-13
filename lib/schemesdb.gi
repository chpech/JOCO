
InstallGlobalFunction(AllJordanSchemes,
function(n)
    local  suff, nameshort, path, name, lcode, lmat, res;
    
    
    if not SmallJordanSchemesAvailable(n) then
        Info(InfoCOCO,1, Concatenation("AllJordanSchemes: Only degrees ",
                 StringCocoList@COCO2P(SmallJordanSchemesAvailable())," are availably."));
        return fail;
    fi;
    if n in [0..9] then 
        suff:=Concatenation("0",String(n));
    else
        suff:=String(n);
    fi;
    
    nameshort:=Concatenation("js",suff);
    path:=PackageInfo("joco")[1].InstallationPath;
    name:=Concatenation(path,"js/",nameshort,".g7.gz");
    lcode:=ReadG7File@COCO2P(name);
    lmat:=List(lcode, MatrixFromCode@COCO2P);
    
    res:= List(lmat, ColorGraphByMatrix);
    Perform(res, function(x) 
               SetIsJStableColorGraph(x,true); 
               SetIsRegularColorGraph(x,true);
           end);
    Perform([1..Length(res)], function(i) SetName(res[i], Concatenation("JS(", String(n),",", String(i),")")); end);
    return res;    
end);
    
InstallGlobalFunction(NumberJordanSchemes,
function(n)
    local  suff, nameshort, path, name, lcode;
    
    if not SmallJordanSchemesAvailable(n) then 
        Info(InfoCOCO,1, Concatenation("NumberJordanSchemes: Only degrees ", 
                                       StringCocoList@COCO2P(SmallJordanSchemesAvailable())," are availably."));
        return fail;
    fi;
    if n in [0..9] then 
        suff:=Concatenation("0",String(n));
    else
        suff:=String(n);
    fi;
    
    nameshort:=Concatenation("js",suff);
    path:=PackageInfo("joco")[1].InstallationPath;
    name:=Concatenation(path,"js/",nameshort,".g7.gz");
    lcode:=ReadG7File@COCO2P(name);
    return Length(lcode);
end);

InstallGlobalFunction(SmallJordanSchemesAvailable,
function(arg)
    
    if arg=[] then
        return smallJordanSchemesAvailable@;
    fi;
    return arg[1] in smallJordanSchemesAvailable@;
end);

    
InstallGlobalFunction(SmallJordanScheme,
function(n,i)
    local  suff, nameshort, path, name, lcode, mat, cgr;
    
    if not SmallJordanSchemesAvailable(n) then
        Info(InfoCOCO,1, Concatenation("SmallJordanScheme: Only degrees ", 
                                       StringCocoList@COCO2P(SmallJordanSchemesAvailable())," are availably."));
        return fail;
    fi;
    if n in [0..9] then 
        suff:=Concatenation("0",String(n));
    else
        suff:=String(n);
    fi;
    
    nameshort:=Concatenation("js",suff);
    path:=PackageInfo("joco")[1].InstallationPath;
    name:=Concatenation(path,"js/",nameshort,".g7.gz");
    lcode:=ReadG7File@COCO2P(name);
    if i > Length(lcode) then
        Info(InfoCOCO,1,Concatenation("SmallJordanScheme: There are only ", String(Length(lcode))," Jordan schemes of degree ", String(n),"."));
        return fail;
    fi;
    
    mat:=MatrixFromCode@COCO2P(lcode[i]);
    cgr:=ColorGraphByMatrix(mat);
    SetIsJStableColorGraph(cgr,true);
    SetIsRegularColorGraph(cgr,true);
    SetName(cgr, Concatenation("JS(", String(n),",", String(i),")"));
    return cgr;
end);
    
