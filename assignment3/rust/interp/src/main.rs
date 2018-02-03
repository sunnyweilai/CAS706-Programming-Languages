use std::collections::HashMap;

fn main(){
 enum UTERM {
  	INT{value: u32},
  	VAR{value:String},
  	BOOL{value:bool},
  	OP1{op:String, arg1:Box<UTERM>, arg2:Box<UTERM>},
  	OP2{op: String, arg1:Box<UTERM>, arg2:Box<UTERM>},
  	ABS{v:Box<UTERM>,body:Box<UTERM>},
  	APP{t1:Box<UTERM>,t2:Box<UTERM>},
  }
  
  enum TTERM
 {
 	TYPEINT,
 	TYPEBOOL,
 	TYPEVAR{num:u32},
 	TYPEFUN{arg:Box<TTERM>,body:Box<TTERM>},
 	
 }
  
 enum RETYPE{
 RE_INT {index:TTERM,value:u32},
 RE_BOOL{index:TTERM,value:bool},
 RE_VAR {index:TTERM,value:String},
 RE_OP1 {index:TTERM,op:String,value1:Box<RETYPE>,value2:Box<RETYPE>},
 RE_OP2 {index:TTERM,op:String,value1:Box<RETYPE>,value2:Box<RETYPE>},
 RE_ABS {index:TTERM,value1:Box<RETYPE>,value2:Box<RETYPE>},
 RE_APP {index:TTERM,value1:Box<RETYPE>,value2:Box<RETYPE>},
 
 }
 // counter for variable numbers
 impl TTERM{
 fn counter( i: &mut u32)-> TTERM{
 	*i +=1;
 	TTERM::TYPEVAR{num:*i}
 }
 }
 // CHECK SAME VARIABLE
 struct ENV {
 env:HashMap<String,TTERM>
 }
 impl ENV {
 fn checkvar(self,var:UTERM)->RETYPE{
 	match var {
 	UTERM::VAR{value:v}=> {
 	if self.env.contains_key(&v) 
 {
 	let I = self.env.get(&v).unwrap().clone();
 	RETYPE::RE_VAR{index:I,value:v}//--------I is a reference, but I don't know how to fix this problem.
 }
 else 
 {  
 	   let  typeindex = TTERM::counter(&mut 0);
 	   self.env.insert(v,typeindex);
 	   RETYPE::RE_VAR{index:typeindex,value:v}  
 }
 	
 	},
 	_ => panic!{"it is wrong!"}
 }
 	
 }
 }
 
 
 //RECONSTRUCT 
 
 fn reconstruct (exp:UTERM,env:ENV)->RETYPE{
 	match exp {
 		UTERM::INT{value:v}=>
 		{
 			let  typeindex = TTERM::counter(&mut 0);
 			RETYPE::RE_INT{index:typeindex,value:v}
 		},
 			
 		
 		UTERM::BOOL{value:v}=>
 		{
 			let  typeindex = TTERM::counter(&mut 0);
 			RETYPE::RE_BOOL{index:typeindex,value:v}
 		},
 		UTERM::VAR{value:v}=> env.checkvar(exp),
 		UTERM::OP1{op: o, arg1: a1, arg2:a2}=> 
 		{
 			let  typeindex = TTERM::counter(&mut 0);
 			let v1 = reconstruct(*a1,env);
 			let v2 = reconstruct(*a2,env);
 			RETYPE::RE_OP1{index:typeindex,op:o,value1:Box::new(v1),value2: Box::new(v2)}
 			
 		},
  	    UTERM::OP2{op: o, arg1: a1, arg2:a2}=>
  	   {
 			let  typeindex = TTERM::counter(&mut 0);
 			let v1 = reconstruct(*a1,env);
 			let v2 = reconstruct(*a2,env);
 			RETYPE::RE_OP2{index:typeindex,op:o,value1:Box::new(v1),value2: Box::new(v2)}
 			
 		},
 		UTERM::ABS{v:arg,body:b}=>
 		{
 			let typeindex = TTERM::counter(&mut 0);
 			let v1 = reconstruct(*arg,env);
 			let v2 = reconstruct(*b,env);
 			RETYPE::RE_ABS{index:typeindex,value1:Box::new(v1),value2: Box::new(v2)}
 			
 		},
 		UTERM::APP{t1:term1,t2:term2}=>
 			{
 			let typeindex = TTERM::counter(&mut 0);
 			let v1 = reconstruct(*term1,env);
 			let v2 = reconstruct(*term2,env);
 			RETYPE::RE_APP{index:typeindex,value1:Box::new(v1),value2: Box::new(v2)}
 			
 		},
 	
 	}
 }
 
 //GET CONSTRAINT
impl RETYPE{
fn gettype(self)->TTERM{
	match self{
		RETYPE::RE_INT {index:i,value:v}=>i,
        RETYPE::RE_BOOL{index:i,value:v}=>i,
        RETYPE::RE_VAR {index:i,value:v}=>i,
        RETYPE::RE_OP1 {index:i,op:o,value1:v1,value2:v2}=>i,
        RETYPE::RE_OP2 {index:i,op:o,value1:v1,value2:v2}=>i,
        RETYPE::RE_ABS {index:i,value1:v1,value2:v2}=>i,
        RETYPE::RE_APP {index:i,value1:v1,value2:v2}=>i,
	}
}
}
 struct constraint 
 {
 	typeA: TTERM,
 	typeB: TTERM
 }

 fn getconstraint(get:RETYPE) -> Vec<constraint> {
 	match get {
 		RETYPE::RE_INT {index:ty,value:v}  => vec![constraint{typeA: ty, typeB: TTERM::TYPEINT}],
 		RETYPE::RE_BOOL{index:ty,value:v}  => vec![constraint{typeA: ty, typeB: TTERM::TYPEBOOL}],
 		RETYPE::RE_VAR {index:ty,value:v}  => vec![],
 		RETYPE::RE_OP1 {index:ty,op:String,value1:v1,value2:v2}  => {
 			let t1 = RETYPE::gettype(*v1);
 			let t2 = RETYPE::gettype(*v2);
 			let mut constraintset = vec![constraint{typeA: ty, typeB: t1}, constraint{typeA: ty, typeB: t2},constraint{typeA: t1, typeB: t2}];
 			constraintset.append(&mut getconstraint(*v1));
 			constraintset.append(&mut getconstraint(*v2));
 			constraintset
 		},
 		RETYPE::RE_OP2 {index:ty,op:String,value1:v1,value2:v2}  => {
 			let t1 = RETYPE::gettype(*v1);
 			let t2 = RETYPE::gettype(*v2);
 			let mut constraintset = vec![constraint{typeA: ty, typeB: t1}, constraint{typeA: ty, typeB: t2},constraint{typeA: t1, typeB: t2}];
 			constraintset.append(&mut getconstraint(*v1));
 			constraintset.append(&mut getconstraint(*v2));
 			constraintset
 		},
 		RETYPE::RE_ABS {index:ty,value1:v1,value2:v2} =>{
 			let t1 = RETYPE::gettype(*v1);
 			let t2 = RETYPE::gettype(*v2);
 			let t = TTERM::TYPEFUN{arg:Box::new(t1),body:Box::new(t2)};
 			let mut constraintset = vec![constraint{typeA: ty, typeB: t}];
 			constraintset.append(&mut getconstraint(*v1));
 			constraintset.append(&mut getconstraint(*v2));
 			constraintset
 			}
 		RETYPE::RE_APP {index:ty,value1:v1,value2:v2} =>{
 			let t1 = RETYPE::gettype(*v1);
 			let t2 = RETYPE::gettype(*v2);
 		    let t = TTERM::TYPEFUN{arg:Box::new(ty),body:Box::new(t2)};
 			let mut constraintset = vec![constraint{typeA: t1, typeB: t}];
 			constraintset.append(&mut getconstraint(*v1));
 			constraintset.append(&mut getconstraint(*v2));
 			constraintset
 		}
 		} 
 	}// end get constraint
 	
// 	------------------------------------test example------------------------------------
//    let a = UTERM::BOOL{value:true};
// 	let b = reconstruct(a,env);
// 	let c = getconstraint(b);
 	// SOLVE ONE CONSTRAINT
// fn solveone(oneset:&RETYPE)->Vec {
// match *oneset{
//       [RE_INT,REINT]    =>
//       [RE_BOOL,RE_BOOL] =>
//       [RE_VAR,RETYPE]   => solvevar()
//       [RETYPE,RE_VAR]   => solvevar()
//       [RE_FUN,RE_FUN]   => solveone(),solveone()
//       [_,_]                 => throw error
// }
// }
 	
 }// end main function
 
 





