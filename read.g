SetInfoHandler(InfoJOCO, 
function( infoclass, level, list )
    local out, fun, s;
    
    out := InfoOutput(infoclass);
    if out = "*Print*" then
        
        if UserPreference("UseColorsInTerminal")=true  then
            Print(TextAttr.(String(level+1)));
        fi;
        
        for s in list do
            Print(s);
        od;
    
        if UserPreference("UseColorsInTerminal")=true  then
            Print(TextAttr.reset);
        fi;
        Print("\c");
    else
        for s in list do
            AppendTo( out, s );
        od;
        AppendTo( out, "\c" );
    fi;
    return;
end);

ReadPackage("joco", "lib/pstabset.gi");
ReadPackage("joco", "lib/pstabfus.gi");
ReadPackage("joco", "lib/jclosure.gi");
ReadPackage("joco", "lib/jtensor.gi");
ReadPackage("joco", "lib/rainbows.gi");
ReadPackage("joco", "lib/jgoodsets.gi");
ReadPackage("joco", "lib/jfusion.gi");
ReadPackage("joco", "lib/jpartfus.gi");
ReadPackage("joco", "lib/partregset.gi");
ReadPackage("joco", "lib/regsets.gi");
ReadPackage("joco", "lib/parcregset.gi");
ReadPackage("joco", "lib/arcregset.gi");
ReadPackage("joco", "lib/rpartfus.gi");
ReadPackage("joco", "lib/regfusion.gi");
# ReadPackage("joco", "lib/setorbits.gi");
# ReadPackage("joco", "lib/partorbits.gi");
ReadPackage("joco", "lib/auxiliary.gi");
