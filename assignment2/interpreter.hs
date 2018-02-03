type Var = String
data Term = 
	  VV Var
	| BB Bool
	| II Integer
	| Op1 Uni Term
	| Op2 Bin Term Term
	| Lambda Var Term
	| App Term Term
	deriving Show
data Uni = Minus | Not deriving Show
data Bin = 
	  Plus
	| Multi
	| And
	| Or
	deriving Show
option1:: Uni -> Term -> Either String Term
option1 Minus(II i) = Right (II (-i))
option1 Minus _ = Left "It is not an integer"
option1 Not (BB b)  = Right (BB (not b))
option1 Not _   = Left "It is not a boolean" 

option2:: Bin -> Term -> Term -> Either String Term 
option2 Plus(II i1)(II i2) = Right $ II $ i1 + i2
option2 Multi(II i1)(II i2) = Right $ II $ i1 * i2
option2 Plus _ _  = Left "They are not integers"
option2 Multi _ _ = Left "They are not integers"
option2 And (BB b1)(BB b2) = Right $ BB $ b1 && b2
option2 Or  (BB b1)(BB b2) = Right $ BB $ b1 || b2
option2 And _ _ = Left "They are not booleans"
option2 Or _ _  = Left "They are not booleans"


-------- ??? haven't figured out how to use environment ???-------
-- type Env = String -> Either String Term
-- savein:: String -> Value -> [(String,Value)]
-- savein (VV v)(II i) = [(v,i)]


calcu1::  Term -> Either String Term
calcu1  (II i)= Right $ II i
calcu1  (BB b)= Right $ BB b
calcu1  (Op1 o t) = do
	r <- calcu1  t
	option1 o r
calcu1  (Op2 o t1 t2) = do
	r1 <- calcu1  t1
	r2 <- calcu1  t2
	option2 o r1 r2
	---------------- some idea about "Lambda" and "Apply"----------
-- calcu1 (VV v) = do
-- 	lookup(v,env)
--  calcu1 (Lambda Var t)=do
--  	closure ((Lambda Var t) env)
--  calcu1 (App t1 t2)=do
--  	r1<- calcu1 t1
--  	r2<- calcu1 t2
--  	env2 = extend(VV r2 env)
--  	calcu1 (r1,env2)

ex1 :: Term
ex1 = Op2 Plus (II 1) (II 2)

ex2 :: Term
ex2 = Op1 Minus (Op2 Plus (II 7) (II 9))

ex3:: Term
ex3 = Op1 Not (Op2 And (BB True)(BB False))

