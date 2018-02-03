# Typed Lambda calculus interpreter
 The operational semantics is the same as for A2 (Rust,Swift)

You should first write down the typing rules for your language. You are allowed, even highly encouraged, to improve the A2 grammar to make your life easier, so that typing rules can be made simpler. Your task is to have your interpreter first do type reconstruction for all inputs before any reduction is done. Decent error messages should be returned for untypable terms. The interpreter should then proceed as in assignment 2.

You should also be providing some test cases for your interpreter - make sure to test higher-order functions as well as cases that do not type (such as old stuck cases from assignment 2) and cases that work but are rejected in your typed language.

You should try to leverage the host system as much as you can for this assignment. This can mean having the type inference algorithm return a typed term, from a different ADT, than the original source. Then your interpreter can be much much simpler (and it should be) because all the 'impossible' cases have been removed already.

In other words, you are writing a type inference routine as the most important part of this assignment. The unification algorithm is thus key.
