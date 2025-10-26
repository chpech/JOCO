 InstallGlobalFunction(ColorGraphBySymmetrization,
function(cgr)
    return ColorGraph(KnownGroupOfAutomorphisms(cgr),[1..OrderOfColorGraph(cgr)],OnPoints,true,
                    function(u,v)
                        return Set([ArcColorOfColorGraph(cgr,u,v),ArcColorOfColorGraph(cgr,v,u)]);
                    end);
end);
 
InstallGlobalFunction(MapReps,
function(list,fct)
    local  obj, map, i, idx;

    map:=[];

    for i in [1..Length(list)] do
        idx:=First([1..Length(list)], j->fct(list[i],list[j]));
        if idx = i then
            COCOPrint("+\c");
        else
            COCOPrint("-\c");
        fi;

        map[i]:=idx;
    od;
    return map;
end);


InstallGlobalFunction(StringCocoIndented,
function(s,i)
    local  strin, res, strout, line;
    
    if s="" then
        return s;
    fi;
    
    strin := InputTextString(s);
    res:="";
    strout:= OutputTextString(res,true);
    SetPrintFormattingStatus(strout,false);
    
    line:=Chomp(ReadLine(strin));
    PrintTo(strout, line,"\n");
    line:=Chomp(ReadLine(strin));
    while line <> fail do
        PrintTo(strout, String("",i), line, "\n");
        line:=Chomp(ReadLine(strin));
    od;
    CloseStream(strin);
    CloseStream(strout);
    return res;
end);


InstallGlobalFunction(StringCocoColorReps,
function(cgr)
    local  cols, res, str, table, len, header, format, row, i;
    
    cols:=ValueOption("cols");
    if cols=fail then
        cols:=4;
    fi;
    

    res:="";
    str:=OutputTextString(res,true);
    SetPrintFormattingStatus(str,false);
    table:=[];
    len:=Length(String(Rank(cgr)-1));
    header:=Concatenation(List([1..cols], i->[String("#  ",len),"rep"]));
    format:=Concatenation(List([1..cols], i->[1,-1]));
    row:=[];

    for i in [1..Rank(cgr)] do
        Add(row, Concatenation(String(i-1,len),") "));
        Add(row, StringCocoTuple(ColorRepresentative(cgr,i)-1));
        if i mod cols = 0 then
            Add(table,row);
            row:=[];
        fi;
    od;
    
    if row <> [] then
        for i in [((Length(row)/2) mod cols)+1..cols] do
            Append(row,["",""]);
        od;
        
        Add(table,row);
    fi;
    
    
    
    Add(table,header,1);
    
    PrintTo(str, StringCocoTable(table,format));
    CloseStream(str);
    return res;
end);


# table is a list of rows
# each row is a list of entries
# the first row is the header
# format is a list of integers -1,0, or 1
# -1 means flush left
# 0 means centred
# 1 means flush right
#string cocotable decides for optimal cell widths
InstallGlobalFunction(StringCocoTable,
function(table,format)
    local  res, str, width, row, i, entries, j, spl, spr;
    
    res:="";
    str:=OutputTextString(res,true);
    SetPrintFormattingStatus(str,false);

    width:=List(table[1], x->0);
    for row in table do
        if IsChar(row) then
            continue;
        fi;
        
        for i in [1..Length(row)] do
            if width[i]<Length(String(row[i])) then
                width[i]:=Length(String(row[i]));
            fi;
        od;
    od;
    width:= width+2;
    entries:=[];
    for i in [1..Length(table)] do
        entries[i]:=[];
        if IsChar(table[i]) then
            continue;
        fi;
        
        for j in [1..Length(table[i])] do
            if format[j]=0 then
                spl:=Int((width[j]-Length(String(table[i][j])))/2);
                spr:=Int((width[j]-Length(String(table[i][j]))+1)/2);
                entries[i][j]:=Concatenation(ListWithIdenticalEntries(spl,' '),
                                             String(table[i][j]),
                                             ListWithIdenticalEntries(spr,' '));
            else
                entries[i][j]:=String(table[i][j], width[j]*format[j]);
            fi;
        od;
    od;
    for i in [1..Length(table)] do
        if IsChar(table[i]) then
            PrintTo(str, ListWithIdenticalEntries(Sum(width),table[i]));
            PrintTo(str,"\n");
            continue;
        fi;
        
        for j in [1..Length(table[i])] do
            PrintTo(str, entries[i][j]);
        od;
        PrintTo(str,"\n");
        if i=1 then
            PrintTo(str, ListWithIdenticalEntries(Sum(width),'='));
            PrintTo(str,"\n");
        fi;
        if i=Length(table) then
            PrintTo(str, ListWithIdenticalEntries(Sum(width),'-'));
            PrintTo(str, "\n");
        fi;
    od;
    CloseStream(str);
    
    return res;
end);



InstallGlobalFunction(StringCocoListListsSets,
function(mrg)
    local  res, str, l, m, cls, i;

    res:="";
    str:=OutputTextString(res,true);
    SetPrintFormattingStatus(str,false);
    
    
    l:=0;
    PrintTo(str,"(");
    l:=l+1;
    for m in mrg do
        PrintTo(str,"(");
        l:=l+1;
        for cls in m do
            PrintTo(str,"{");l:=l+1;
            for i in [1..Length(cls)-1] do
                PrintTo(str,cls[i],",");l:=l+1+Length(String(cls[i]));
                if l>55 then
                    PrintTo(str,"*\n");
                    l:=0;
                fi;
            od;
            PrintTo(str,cls[Length(cls)],"}");
            l:=l+1+Length(String(cls[Length(cls)]));
            if not cls = m[Length(m)] then
                PrintTo(str,",");
                l:=l+1;
                if l>50  then
                    PrintTo(str,"*\n");
                    l:=0;
                fi;
            fi;
        od;
        PrintTo(str,")");
        l:=l+1;
        if not m = mrg[Length(mrg)] then
            PrintTo(str,", ");
            l:=l+2;
            if l>50  then
                PrintTo(str,"*\n");
                l:=0;
            fi;
        fi;
    od;
    PrintTo(str,")");
    
    CloseStream(str);
    return res;
end);


InstallGlobalFunction(StringList@,
function(s)
    local str,res,i;
    res:="";
    str:=OutputTextString(res,true);
    SetPrintFormattingStatus(str,false);

    for i in [1..Length(s)] do
        PrintTo(str,s[i]);
        if i<Length(s) then
            PrintTo(str,",");
        fi;
    od;
    CloseStream(str);
    return res;
end);

InstallGlobalFunction(StringCocoTuple,
function(s)
    local str,res,i;
    res:="";
    str:=OutputTextString(res,true);
    SetPrintFormattingStatus(str,false);

    PrintTo(str,"(");
    for i in [1..Length(s)] do
        PrintTo(str,s[i]);
        if i<Length(s) then
            PrintTo(str,",");
        fi;
    od;
    PrintTo(str,")");
    CloseStream(str);
    return res;
end);
