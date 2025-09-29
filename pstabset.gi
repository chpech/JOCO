DeclareRepresentation("IsPartialStableSetRep",
        IsAttributeStoringRep,
        [ "set"                   # the partial stable set
        ]);

InstallMethod(IsEmptyPartialStableSet,
        "for partial stable sets in PartialStableSetRep",
        [IsPartialStableSet and IsPartialStableSetRep],
function(cand)
    return cand!.set=[];
end);
