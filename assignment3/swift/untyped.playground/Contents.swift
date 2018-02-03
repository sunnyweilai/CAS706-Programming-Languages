

import UIKit

//-----------------------------------------------------typed term


class Typed{}
class TypeInt: Typed {}
class TypeBool:Typed {}
class TypeVar :Typed {
    var number :Int
    init(num:Int)
    { number = num }
}
class TypeFun :Typed {
    var argg : Typed
    var bodyy: Typed
    init (arg:Typed,body:Typed) {
        argg = arg;
        bodyy = body;}
    
}

// -----------------------------------------------RECONSTRUCT TYPED TERM

class T_Type{
    var typecounter: TypeVar;
    init(){
        typecounter = TypeVar(num:0);
    }
}
class T_INT : T_Type {
    var valuetype:Int;
    
    init(int:INT) {
        valuetype = int.ii
    }
}

class T_BOOL : T_Type {
    var valuetype:Bool
    init(bool:BOOL) {
         valuetype = bool.bb
    }
}

class T_STR: T_Type{
    var valuetype: String
    init (str:STR){
        valuetype = str.ss
    }
}

class T_VAR: T_Type{
    var valuetype:String
    init(variable:VAR){
        valuetype = variable.vv
         }
        }

class T_OP1 : T_Type{
    var op1: T_STR
    var valuetype1: T_INT
    var valuetype2: T_INT
    init (op: T_STR,t1:T_INT,t2:T_INT)
    {
        op1 = op
        valuetype1 = t1;
        valuetype2 = t2;
    }
}

class T_OP2 : T_Type{
    var op1: T_STR
    var valuetype1: T_BOOL
    var valuetype2: T_BOOL
    init (op: T_STR,t1:T_BOOL,t2:T_BOOL)
    {
        op1 = op
        valuetype1 = t1;
        valuetype2 = t2;
    }
}

class T_APP: T_Type{
    var valuetype1: T_Type
    var valuetype2: T_Type
    
    init (t1:T_Type,t2:T_Type)
    {
        valuetype1 = t1;
        valuetype2 = t2;
    }
}

class T_ABS: T_Type{
    var vartype: T_VAR
    var returntype: T_Type
    
    init(variable:T_VAR,result:T_Type) {
        vartype = variable;
        returntype = result;
    }
}

//-----------------------------------------------------------untyped term
class Term {}
class INT:Term {
        var ii:Int
        init(int:Int) {
            ii = int
        }
    }
class VAR:Term {
        var vv:String
        init(str:String) {
            vv = str
        }
    }
class BOOL:Term {
        var bb:Bool
        init(bool:Bool) {
            bb = bool
        }
    }
class STR:Term {
    var ss:String
    init(str:String) {
        ss = str
    }
}
class OP1: Term {
        var op:STR
        var t1:INT
        var t2:INT
        init(o:STR,t11:INT,t22:INT) {
            op = o
            t1 = t11
            t2 = t22
        }
    }
class OP2: Term{
        var op:STR
        var t1:BOOL
        var t2:BOOL
        init(o:STR,t11:BOOL,t22:BOOL) {
            op = o
            t1 = t11
            t2 = t22
    }
}
class APP: Term {
        var t1:Term
        var t2:Term
        init(t11:Term,t22:Term) {
            t1 = t11
            t2 = t22
        }
        
}
        
class ABS: Term {
        var t: VAR
        var body: Term
        init(tt:VAR,bodyy:Term) {
            t = tt
            body = bodyy
           }
        }

//reconstruct function
var i:Int = 0
var env = Dictionary<String,TypeVar>();
 func reconstruct (expression:Term) ->T_Type {
 
 switch expression {
    case is INT:
        let  T__INT = T_INT(int:expression as! INT);
             i = i + 1;
             T__INT.typecounter = TypeVar(num:i);
             return  T__INT;

    case is BOOL:
        let T__BOOL = T_BOOL(bool:expression as! BOOL);
            i = i + 1;
            T__BOOL.typecounter = TypeVar(num:i);
        
            return T__BOOL;
    
    case is STR:
         let T__STR = T_STR(str: expression as! STR);
             return T__STR;
    
    case is VAR:
         let exp = expression as! VAR;
         let v = exp.vv;
            if let _ = env[v]  {
                let T__VAR = T_VAR(variable:exp);
                T__VAR.typecounter = TypeVar(num:i);
                return T__VAR;
            }
            else {
                let T__VAR = T_VAR(variable:exp);
                T__VAR.typecounter = TypeVar(num:i);
                i = i + 1;
                env[v] = TypeVar(num:i);

                return T__VAR;
                
            }
    
     case is ABS:
       let  exp = expression as! ABS;
       let  v1 = reconstruct(expression: exp.t) as! T_VAR;
       let  v2 = reconstruct(expression: exp.body);
       let  T__ABS = T_ABS(variable:v1,result:v2);
          i = i+1;
         T__ABS.typecounter = TypeVar(num:i);
       
    return T__ABS;
    
    
    case is OP1:
         let exp = expression as! OP1;
         let r_op = reconstruct(expression:exp.op);
         let R_op = r_op as! T_STR;
         let t11 = reconstruct(expression: exp.t1) as! T_INT;
         let t22 = reconstruct(expression: exp.t2) as! T_INT;
         let T__OP1 = T_OP1 (op:R_op,t1:t11,t2:t22);
          i = i + 1;
         T__OP1.typecounter = TypeVar(num:i);
        
         return T__OP1;
    
     case is OP2:
         let exp = expression as! OP2;
         let r_op = reconstruct(expression:exp.op);
         let R_op = r_op as! T_STR;
         let t11 = reconstruct(expression: exp.t1) as! T_BOOL;
         let t22 = reconstruct(expression: exp.t2) as! T_BOOL;
         let T__OP2 = T_OP2 (op:R_op,t1:t11,t2:t22);
          i = i + 1;
         T__OP2.typecounter = TypeVar(num:i);
        
         return T__OP2;
         
    
    case is APP:
        let exp = expression as! APP;
        let t11 = reconstruct(expression: exp.t1);
        let t22 = reconstruct(expression: exp.t2);
        let T__APP = T_APP(t1:t11,t2:t22);
            i = i + 1;
            T__APP.typecounter = TypeVar(num:i);
        
            return T__APP;
    
 default:   return T_Type();
    
    }
   
}

class constraint {
    var tA: Typed;
    var tB: Typed;
    init(t1:Typed,t2:Typed) {
        tA = t1;
        tB = t2;
    }
}


var set = Dictionary<Int,constraint>();
var counter = 0;
func getconstraint (re_expression:T_Type) -> Dictionary<Int,constraint> {
    switch re_expression {
    case is T_INT:
        let exp = re_expression as! T_INT;
        let v0 = exp.typecounter;
        let v1 = TypeInt();
        counter = counter + 1;
        set[counter] = constraint(t1:v0,t2:v1)
        
        return set;
        
    case is T_BOOL:
                 let exp = re_expression as! T_BOOL;
                 let v0 = exp.typecounter;
                 let v1 = TypeBool();
                 counter = counter + 1;
                 set[counter] = constraint(t1:v0,t2:v1)
                 
                 return set;
        
    case is T_VAR:

        return Dictionary<Int,constraint>();
        
    case is T_STR:
        return Dictionary<Int,constraint>();
      
    case is T_OP1:
                let exp = re_expression as! T_OP1;
                let v0 = exp.typecounter;
                let v1 = exp.valuetype1.typecounter;
                let v2 = exp.valuetype2.typecounter;
                counter = counter + 1;
                set[counter] = constraint(t1:v0,t2:v1);
                counter = counter + 1;
                set[counter] = constraint(t1:v1,t2:v2);
                counter = counter + 1;
                set[counter] = constraint(t1:v0,t2:v2);
                
                getconstraint(re_expression:exp.valuetype1);
                getconstraint(re_expression:exp.valuetype2);
                return set;
        
    case is T_OP2:
        let exp = re_expression as! T_OP2;
        let v0 = exp.typecounter;
        let v1 = exp.valuetype1.typecounter;
        let v2 = exp.valuetype2.typecounter;
        counter = counter + 1;
        set[counter] = constraint(t1:v0,t2:v1);
        counter = counter + 1;
        set[counter] = constraint(t1:v1,t2:v2);
        counter = counter + 1;
        set[counter] = constraint(t1:v0,t2:v2);
        getconstraint(re_expression:exp.valuetype1);
        getconstraint(re_expression:exp.valuetype2);
        return set;
        
    case is T_ABS:
                let exp = re_expression as! T_ABS;
                let v0 = exp.typecounter;
                let v1 = exp.vartype.typecounter;
                let v2 = exp.returntype.typecounter;
                let t3 = TypeFun(arg:v1,body:v2);
                counter = counter + 1;
                set[counter] = constraint(t1:v0,t2:t3);
                
                getconstraint(re_expression:exp.vartype);
                getconstraint(re_expression:exp.returntype);
                return set;
        
    case is T_APP:
                let exp = re_expression as! T_APP;
                let v0 = exp.typecounter;
                let v1 = exp.valuetype1.typecounter;
                let v2 = exp.valuetype2.typecounter;
                let t3 = TypeFun(arg: v2, body: v0)
                 counter = counter + 1;
                set[counter] = constraint(t1:v1,t2:t3);
               
                getconstraint(re_expression:exp.valuetype1);
                getconstraint(re_expression:exp.valuetype2);
                return set;
    
    default:
        return Dictionary<Int,constraint>();
    }
}

var newset = Dictionary<Int,constraint>();
//var instantset = Dictionary<Int,constraint>();
var count = 0;
//solveone function
func solveone(oneset:constraint)->Dictionary<Int,constraint> {
    let TA = oneset.tA;
    let TB = oneset.tB;
    
    //solvevar function
    func solvevar(t1:TypeVar,t2:Typed) -> Dictionary<Int,constraint>{
        switch t2 {
        case is TypeVar:
                        let v0 = t2 as! TypeVar;
                        if t1.number == v0.number{
                            return Dictionary<Int,constraint>();
                        }
                        else{
                            count = count + 1;
                            newset[count]=constraint(t1: t1, t2: t2);
                            
                            return newset;
                        }
        
        case is TypeFun:
                        func ifoccur(t1:TypeVar,t2:Typed) -> Bool{
                            switch t2 {
                            case is TypeFun:
                                let v0 = t2 as! TypeFun;
                                let v1 = v0.argg, v2 = v0.bodyy;
                                let r1 = ifoccur(t1:t1, t2: v1);
                                let r2 = ifoccur(t1:t1, t2: v2);
                                if (r1 || r2 == true) {return true;}
                                else {return false;}
            
                            case is TypeVar:
                                let v0 = t2 as! TypeVar;
                                if t1.number == v0.number {return true;}
                                else {return false;}
            
                            default: return false;
                            }
                        }//end ifoccur
            
                    let result = ifoccur(t1:t1,t2:t2);
                        if result == false {
                             count = count + 1;
                            newset[count] = constraint(t1:t1,t2:t2);
                           
                            return newset;
                        }
                        else {return Dictionary<Int,constraint>();}// wrong????}
        
        case is  TypeInt:
           
            count = count + 1;
            newset[count]=constraint(t1: t1, t2: t2);
            return newset;
            
        case is TypeBool:
        
             count = count + 1;
            newset[count]=constraint(t1: t1, t2: t2);
            
            return newset;
            
        default: return Dictionary<Int,constraint>();
        }// end solvevar function
    }
        // start solve one constraint
        switch (TA,TB) {
        case is (TypeInt,TypeInt):
            return Dictionary<Int,constraint>();

        case is (TypeBool,TypeBool):
            return Dictionary<Int,constraint>();

        case is (TypeFun,TypeFun):
            let TA = oneset.tA as! TypeFun;
            let TB = oneset.tB as! TypeFun;
            let v1 = TA.argg;
            let v2 = TA.bodyy;
            let v3 = TB.argg;
            let v4 = TB.bodyy;
            let s1 = solveone(oneset:constraint(t1:v1,t2:v3));
            let s2 = solveone(oneset:constraint(t1:v2,t2:v4));
            if s1.isEmpty && s2.isEmpty {return Dictionary<Int,constraint>();}
            else {return newset;}

        case is (TypeVar,Typed):
            let ta = TA as! TypeVar;
            return solvevar(t1:ta,t2:TB);
           

        case is (Typed,TypeVar):
           let tb = TB as! TypeVar;
           return solvevar(t1:tb,t2:TA);
          
        default:
            fatalError("The input is not well typed!")
        }
   
}

//var updateset = Dictionary<Int,constraint>();
func unification (unify:Dictionary<Int,constraint>)->Dictionary<Int,constraint>
{
    var unify = set;
    var I = 0;
    firstloop: for i in  stride(from: 1, through: counter, by: 1)
        {
           // print(counter)
         if unify.isEmpty {return newset}
            else {
           // print(counter)
            let updateset = solveone(oneset: unify[i]!);
            //updateset = newset;
            unify.removeValue(forKey:i);
            if updateset.isEmpty {
                continue firstloop
            }
            else{
                I = I + 1
            let newta = updateset[I]!.tA;
            let newtb = updateset[I]!.tB;
           
           
            if unify.isEmpty {return newset}
            else {
            for j in stride(from: i+1, through: counter, by: 1){
                let oldta = unify[j]!.tA;
                let oldtb = unify[j]!.tB;
               
               
                switch newta {
                case is TypeVar:
                    let v1 = newta as! TypeVar;
                    let num1 = v1.number;
                   
                    switch oldta {
                    case is TypeVar:
                        let v2 = oldta as! TypeVar;
                        let num2 = v2.number ;
                       // print(num2)
                        if num2 == num1 {
                            unify.updateValue(constraint(t1: newtb, t2: oldtb),forKey:j)
                            
                        }
                        else{
                            switch oldtb {
                            case is TypeVar:
                                let v2 = oldtb as! TypeVar;
                                let num2 = v2.number ;
                                if num2 == num1 {
                                    unify.updateValue(constraint(t1: oldta, t2: newtb),forKey:j)
                                }
                            default: ()
                            }// end match oldtb
                        }
                        
                    case is Typed:
                        switch oldtb {
                        case is TypeVar:
                            let v2 = oldtb as! TypeVar;
                            let num2 = v2.number ;
                            if num2 == num1 {
                               unify.updateValue(constraint(t1: oldta, t2: newtb),forKey:j)
                                
                            } else{
                                //return set;
                                
                            }
                        default: ()
                        }// end match oldtb
                        
                    default:() // end match oldta
                    }//
                default: ()
                    //return set;
                }// end match newta
               } // end loop i
              }// end if else
            }
        }
    }
    return newset;
}
//compose and finally refresh

func finalupdate(final:Dictionary<Int,constraint>)-> Dictionary<Int,constraint>{
    var final = newset
    if final.count <= 1 {return final}
    else{
        for n in stride(from: count, through: 2, by: -1){
            let updateta = final[n]!.tA;
            let updatetb = final[n]!.tB;
        for m in stride(from: n - 1, through: 1, by: -1){
            let needta = final[m]!.tA;
            let needtb = final[m]!.tB;
            
            switch updateta {
            case is TypeVar:
                let nta = updateta as! TypeVar;
                let nta_num = nta.number;

                switch needtb {
                case is TypeVar:
                    let otb = needtb as! TypeVar;
                    let otb_num = otb.number;
                    if nta_num == otb_num {

                        final.updateValue(constraint(t1:needta,t2:updatetb),forKey:m)
                       
                    }
                    else {
                    }
                case is TypeFun:
                    let otb = needtb as! TypeFun;
                    let otb_arg = otb.argg;
                    let otb_byd = otb.bodyy;
                    switch otb_arg {
                    case is TypeVar:
                        let a = otb_arg as! TypeVar;
                        let otb_arg_num = a.number;
                        if otb_arg_num == nta_num {final.updateValue(constraint(t1:needta,t2:updatetb),forKey:m)}
                        
                    case is Typed:
                        switch otb_byd {
                        case is TypeVar:
                            let b = otb_byd as! TypeVar;
                            let otb_byd_num = b.number;
                            if otb_byd_num == nta_num {final.updateValue(constraint(t1:needta,t2:updatetb),forKey:m)}
                        default:
                            ()
                        }// end matching otb_byd
                    default:
                        ()
                    }// end matching TypeFun

                default:
                    ()
                }// end matching needtb
            default:
                return final;
            }// end matching updateta
        }
    }
    }
    return final;
}



//let exp = APP(t11:OP1(o:STR(str:"+"),t11:INT(int:2),t22:INT(int:2)),t22:OP2(o:STR(str:"and"),t11:BOOL(bool:false),t22:BOOL(bool:false)))
//let exp = APP(t11:OP1(o:STR(str:"+"),t11:INT(int:2),t22:INT(int:2)),t22:OP1(o:STR(str:"+"),t11:INT(int:2),t22:INT(int:2)))
//let exp = APP(t11:ABS(tt:VAR(str:"x"),bodyy:VAR(str:"x")),t22:BOOL(bool:false));
//let exp = BOOL(bool:false)
//let exp = ABS(tt:VAR(str:"x"),bodyy:VAR(str:"y"))
//let exp = OP1(o:STR(str:"+"),t11:INT(int:2),t22:INT(int:2));
//let exp = OP2(o:STR(str:"and"),t11:BOOL(bool:false),t22:BOOL(bool:false))
//let b = reconstruct(expression:exp)
//let c = getconstraint(re_expression:b)
//let  f = unification(unify:c)
//let g = finalupdate(final: f)



