
(* version1-- use List.partition to sort*)
let rec quicksort1(x : int list ) = match x with	
|[] ->[]
|pivot::tail -> let before,after=List.partition(fun x -> x<pivot) tail
         in quicksort1 before @ (pivot ::quicksort1 after);;

 (* test1 *)
 quicksort1 [1;2;5;3;6];;

(* version2-- use comparison functions and a fixed partition function to sort*)


let less a b = let b = fst a in fun a -> a<b;;

let greater a b = let b = fst a in fun a -> a>b;;

let rec quicksort2 comp x = match x with	
|[] ->[]
|pivot::tail -> let before,after=List.partition(comp x pivot) tail
         in quicksort2 comp before @ (pivot ::quicksort2 comp after);;

(* test 2 *)
(* ???it worked for the first time, but after that it didn't I don't know why ???*)
quicksort2 greater [1;2;4;5;5;4];;
quicksort2 less ["a";"s";"r";"d"];;

(* version 3 use comparison and partition functions*)
let greater a b = 
	if a>b then true else false;;

let less a b =
	if a<b then true else false;;

let rec partition_ comp pivot before after x =
 match x with 
        | [] -> before,after 
        | head::tail -> if comp head pivot then 
                           partition_ comp pivot (head::before) after tail
                        else partition_ comp pivot before (head::after) tail;;

let rec quicksort3 parti comp x =
 match x with
  | [] -> []
  | pivot::tail ->
      let before,after = parti comp pivot [] [] tail 
      in (quicksort3 parti comp before) @ (pivot :: (quicksort3 parti comp after));;

(* test 3 *)
quicksort3 partition_ less [2;5;5;3;6];;
quicksort3 partition_ less ["a";"s";"r";"d"];;

(* ---------reference--------- *)
(* [1]Pad. ocaml efficient quicksort  [online]Available at<https://stackoverflow.com/questions/10598823/ocaml-efficient-quicksort>  *)