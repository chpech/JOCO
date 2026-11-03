#! @Chapter Databases

#! @Section Small Jordan schemes

#! @Description
#! This function returns the list of all regular Jordan schemes
#! of order <A>n</A>. Every color graph has a name of the shape
#! `JS(n,k)` where `k` is the index of the graph
#! in the list of Jordan schemes <A>n</A>.
#! @Arguments n
DeclareGlobalFunction("AllJordanSchemes"); 

#! @Description
#! This function returns the regular Jordan scheme `JS(n,k)` (see
#! <Ref Func='AllJordanSchemes'/>).
#! @Arguments n,k
DeclareGlobalFunction("SmallJordanScheme"); 

#! @Description
#! This function returns the number of regular Jordan schemes of order <A>n</A>.
#! @Arguments n
DeclareGlobalFunction("NumberJordanSchemes");

#! @Description
#! If the argument <A>n</A> is given, then the function returns `true` if the regular Jordan schemes
#! of order <A>n</A> are contained in the database of small regular Jordan schemes and `false` otherwise.
#! If <A>n</A> is omitted, the function returns the list of orders for which the complete list of
#! regular Jordan schemes is contained in the database of small regular Jordan schemes
#! @Arguments [n]
DeclareGlobalFunction("SmallJordanSchemesAvailable"); 


smallJordanSchemesAvailable@:=Immutable([2..12]);
smallCoherentConfigurationsAvailable@:=Immutable([2..15]);
