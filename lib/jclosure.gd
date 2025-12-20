#############################################################################
##
##  jclosure.gd                  JOCO package
##                                                              Mikhail Klin
##                                                            Christian Pech
##
##  Declarations for the Jordan closure algorithm that works inside
##  of a given J-stable color graph
##
#############################################################################

# DeclareGlobalFunction("IsJStablePartition");

#! @Chapter jclosure

#! @Section The internal partition type

#! when &COCO; or &JOCO; need to compute WL-stable or J-stable partitions they make use of 
#! an internal format of partitions. As it stands, this format is not the most efficient one 
#! but it has been doing good service now for decades. Also the code for WL-stabilization and for 
#! J-stabilization is quite independent of the rest of &JOCO; and &COCO; so that at some moment 
#! it can be replaced by something better without causing big problems. 
#! To distinguish this type of partitions from the partition-datatypes used in &JOCO;, we are 
#! going to refer to this old type of partitions as __internal partitions__.
#!
#! An __internal partition__ is a record with the following components:
#! * `classes`: an ordered partition of the colors of the underlying color graph $(V,C,f)$;
#! * `fixed`: a list of indices into `classes` that are fobidden to split during the 
#!   stabilization process;
#! * `variable` the list of indices to elements of `classes` that are still allowed to get 
#!   in the course of the stabilization process;
#! * `instabil` a fifo-queue consisting of indices into `classes` to such sets for which it is 
#!   still possible that they are going to split inthe further course of the stabilization;
#! * `instabilFlags` a boolean list that records for eqch element of `classes` whether or not  
#!   it is instabil;
#! * `totest` a fifo-queue. Whenever the stabilization procedure takes in instabile class
#!   and tries to stabilize it, it creates a queue of classes to test against this class.
#!   For each of these classes a complex product is computed and the result of this is used 
#!   for refining the partition. This refining takes place in `WLRepartition` and `JRepartition`,
#!   respectively;
#! * `totestflags` a bolean list coresponding to the queue `totest`
#! * `colorNames` as the a color graph gets refined the algorithms generates new names of the 
#!   colors of the refined color graph. 
#! * `numberClasses` an internal data-structure that is used for the generation of the `colorNames`


#! @Section Jordan stabilization
#! @Description
#! * <A>tensor</A> is a tensor of intersection numbers of some J-stable color graph,
#! * <A>ipart</A> is an internal partition,
#! * <A>u</A> and <A>v</A> are indices into `<A>tensor</A>.classes`,
#! * <A>min</A> is a set.
#! `JRepartition` computes the complex Jordan product of `<A>ipart</A>.classes[u]` and 
#! `<A>ipart</A>.classes[u]` in <A>tensor</A>. The resulting coefficients of the colors 
#! give rise to a partition of the colors. This partition is used to refine <A>ipart</A>.
#! if some fixed partition class of <A>ipart</A> gets split in this process, then `fail` 
#! is returned. If some variable partition class of <A>ipart</A> gets split into smaller parts
#! and if any of these parts are  &lt; <A>min</A> in the short-lex ordering, then `fail` is 
#! returned. Any new classes are marked as `instable` and as `totest`. 
#! The function changes the input internal partition in place.
#! @Arguments tensor, ipart, u, v, min
DeclareGlobalFunction("JRepartition");


#! @Description
#! * <A>tensor</A> is a tensor of intersection numbers of some J-stable color graph,
#! * <A>ipart</A> is an internal partition,
#! * <A>min</A> is a set. If not given then `<A>min</A>=[]` is taken.
#! This function goes through the queue of instable classes and for each of them through the queue of 
#! classes to test and calles `JRepartition` for them. It goes on until all queues are empty or 
#! until JRepartition returns fail, whetever happens first. In the former case the final 
#! internal partition is retured. The function changes the input internal partition in place.
#! No new class is allowed to be smaller than <A>min</A> in short-lex ordering.
#! @Arguments tensor, ipart [, min] 
DeclareGlobalFunction("JStabil");


