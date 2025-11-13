#############################################################################
##
##  regfusion.gi                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Implementation of the datatype of regular fusions
##
#############################################################################


# InstallMethod(RegularFusionsFamily,
# "for a color graph",
# [IsColorGraph],
# function(cgr)
#    local fam;
#    fam:=NewFamily("RegularFusionsFam", IsRegularFusion);
#    return fam;
# end);

InstallMethod(ColorPartition,
"for WL-fusions",
[ IsColorPartition and IsRegularFusion, IsColorGraph, IsList ],
function(filter, cgr, set)
   local res;

    res:=ColorPartition(IsColorPartition, cgr,set);
    SetIsRegularFusion(res,true);

    return res;

end);

InstallMethod(OnColorPartitions,
"for a WL-fusion and a permutation",
[IsColorPartition and IsWLFusion, IsPerm],
function(cpart, g)
    local res;
    
    return ColorPartition(IsColorPartition and IsRegularFusion, 
                          UnderlyingCgrOfColorPartition(cpart),
                          OnTuplesSets(UnderlyingPartitionOfColorPartition(cpart), g));
end);

InstallMethod( StablePartitionFromCompletePartialStablePartition,
"for a partial regular fusion in PartialColorPartitionRep",
[IsPartialRegularFusion and IsPartialColorPartitionRep],
function(cpfus)
    return ColorPartition(IsColorPartition and IsRegularFusion, cpfus!.cgr, cpfus!.part.classes);
end);

InstallMethod(FusionColorGraph,
"for regular fusions",              
[IsColorPartition and IsRegularFusion],
function(rfus)
    local cgr;
    
    cgr:=ColorGraphByFusion(UnderlyingCgrOfColorPartition(rfus),
                            UnderlyingPartitionOfColorPartition(rfus));
    SetIsRainbow(cgr,true);
    SetIsRegularColorGraph(cgr,true);
    return cgr;
end);

#########################################################################################

InstallMethod(ViewString,
"for a regular fusion",
[IsColorPartition and IsRegularFusion],
function(x)
    return Concatenation("<Regular fusion of order ", String(Order(x)), " and rank ", String(Rank(x)), ">");
end);

# InstallMethod(ViewString,
# "for a regular fusion orbit",
# [IsRegularFusionOrbit],
# function(x)
#     local res;
    
#     res:="<";
#     if IsMutable(x) then
#         Append(res,"mutable ");
#     fi;
#     Append(res, Concatenation("RegularFusionOrbit of length ", String(Size(x)),">"));
#     return res;
# end);

InstallOtherMethod(RegularFusionOrbits,
"for a stable rainbow and a list of regular set orbits",
[IsRainbow and IsStableRainbow, IsList],
function(cgr,gsorbits)
    local pfus, iter,max;
    
    if not ForAll(gsorbits, IsRegularSetOrbit) then
        ErrorNoReturn("RegularFusionOrbits: expecting a list of regular set orbits");
    fi;
    if not ForAll(gsorbits, gso->IsIdenticalObj(FamilyObj(Representative(gso)),FamilyObj(Representative(gsorbits[1])))) then
        ErrorNoReturn("RegularFusionOrbits: regular set orbits are incompatible");
    fi;
    
    if gsorbits=[] then
        max:=0;
    else
        max:=Maximum(List(gsorbits, x->Size(Representative(x))));
        if not IsIdenticalObj(cgr,UnderlyingCgrOfColorSet(Representative(gsorbits[1]))) then
            ErrorNoReturn("RegularFusionOrbits: regular set orbits are incompatible");
        fi;
    fi;
    
    pfus:=EmptyPartialRegularFusion(cgr, max);

    iter:=IteratorOfPartialStablePartitionOrbits(pfus,gsorbits);
    
    return AllStablePartitionOrbits(iter);
end);

# InstallMethod(RegularFusionOrbitsFamilyOp,
# "for a color graph and a permutation groups",
# [IsColorGraph, IsPermGroup],
# function(cgr,g)
#     return NewFamily("RegularFusionOrbitsFam", IsRegularFusionOrbit);
# end);


# RegularFusionOrbit(<group>, <Rfusion> [,<stab>] )
# <stab> is supposed to be a subgroup of the stabilizer of <fusion> in <group>
# InstallGlobalFunction(RegularFusionOrbit,
# function(arg)
#     local group,fusion,stab, can,xstab,nstab;

#     group:=arg[1];
#     fusion:=arg[2];
#     if Length(arg)=2 then
#         stab:=Stabilizer(group,AsPartition(fusion), OnSetsSets);
#     else
#         stab:=arg[3];
#     fi;

#     can:=SetsSetsCanonifiers(group, stab, UnderlyingPartitionOfColorPartition(fusion));
#     nstab:=ClosureGroup(stab, List(can, x->can[1]*x^(-1)));
#     Assert(1, nstab=Stabilizer(group, UnderlyingPartitionOfColorPartition(OnRegularFusions(fusion,can[1])),OnSetsSets));
    

#     return RegularFusionOrbitNC(group, OnRegularFusions(fusion,can[1]), nstab^can[1]);
# end);


# RegularFusionOrbitNC(<group>, <Jfusion> [,<stab>])
# <Rfusion> is a R-fusion that is assumed to be minimal (rev-lex wise) in its orbit
# the minimality property is not checked
# <stab> is supposed to be the full (SetsSets-wise) stabilizer of <Rfusion> in <group>
# InstallGlobalFunction(RegularFusionOrbitNC,
# function(group,fusion,stab)
#     local res;


#     res:=rec(
#               group:=group,
#               rep:=fusion,
#               stab:=stab);
#     return Objectify(NewType(RegularFusionOrbitsFamily(UnderlyingCgrOfColorPartition(fusion),group), IsRegularFusionOrbit and IsCocoOrbitRep), res);
# end);

# InstallMethod(OnRegularFusions,
# "for a regular fusion in ColorPartitionRep and a permutation",
# [IsRegularFusion and IsColorPartitionRep, IsPerm],
# function(fusion, g)
#     local res;
#     res:=rec(
#               cgr:=fusion!.cgr,
#               partition:=MakeImmutable(ShortLexSorted(OnSetsSets(Set(fusion!.partition),g)))
#              );
    
#     return Objectify(NewType(RegularFusionsFamily(fusion!.cgr), IsRegularFusion and IsColorPartitionRep), res);
# end);


InstallMethod(RegularFusionOrbits,
"for a stable rainbow",
[IsColorGraph and IsRainbow and IsStableRainbow],
function(cgr)
    local gsorbs,rforb;
    
    gsorbs:=RegularSetOrbits(cgr);
    rforb:=RegularFusionOrbits(cgr,gsorbs);
    return rforb;  
end);

InstallOtherMethod(RegularFusionOrbits,
"for a stable rainbow and a permutation group",
[IsColorGraph and IsRainbow and IsStableRainbow, IsPermGroup],
function(cgr,g)
    local gsorbs,rforb;
    
    gsorbs:=RegularSetOrbits(cgr,g);
    rforb:=RegularFusionOrbits(cgr,gsorbs);
    return rforb;
end);

# InstallMethod(OnCocoOrbits,
# "for a regular fusion orbit and a permutation",
# [IsRegularFusionOrbit, IsPerm],
# function(orb,perm)
#     local   grp,  rep,  stab,  nrep;
    
#     if perm=() then
#         return orb;
#     fi;
    
#     grp:=UnderlyingGroupOfCocoOrbit(orb);
#     rep:=CanonicalRepresentativeOfCocoOrbit(orb);
#     stab:=StabilizerOfCanonicalRepresentative(orb);

#     nrep:=OnColorPartitions(rep,perm);

#     return RegularFusionOrbitNC(grp,nrep,Stabilizer(grp,AsPartition(nrep),OnSetsSets));
# end);

# InstallMethod(ActionOfCocoOrbit,
# "for a regular fusion orbit",
# [IsRegularFusionOrbit],
# function(orb)
#     return OnRegularFusions;
# end);




# InstallMethod(ConstructorOfCocoOrbit,
# "for a  regular fusion orbit",
# [IsRegularFusionOrbit],
# function(orb)
#     return RegularFusionOrbit;
# end);

# InstallMethod(ConstructorOfCocoOrbitNC,
# "for a regular fusion orbit",
# [IsRegularFusionOrbit],
# function(orb)
#     return RegularFusionOrbitNC;
# end);

# InstallMethod(ConstructorOfStablePartitionOrbit,
# "for a regular Fusion",
# [IsRegularFusion],
# function(rfus)
#     return RegularFusionOrbit;
# end);

# InstallMethod(ConstructorOfStablePartitionOrbitNC,
# "for a regular fusion",
# [IsRegularFusion],
# function(rfus)
#     return RegularFusionOrbitNC;
# end);
