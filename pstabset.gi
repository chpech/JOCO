DeclareRepresentation("IsPartialStableSetRep",
        IsAttributeStoringRep,
        [ "set",                   # the partial stable set
          "map",
          "imap"
        ]);

InstallMethod(IsEmptyPartialStableSet,
        "for partial stable sets in PartialStableSetRep",
        [IsPartialStableSet and IsPartialStableSetRep],
function(cand)
    return cand!.set=[];
end);

InstallMethod(IMapOfPartialStableSet,
        "for partial stable sets in PartialStableSetRep",
        [IsPartialStableSet and IsPartialStableSetRep],
function(cand)
    return cand!.imap;
end);
