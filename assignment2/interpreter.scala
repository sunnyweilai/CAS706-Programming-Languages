
abstract class Term 
case class Str(val strr:String) extends Term
case class Num(val numm:Int) extends Term
case class Boo(val booo:Boolean) extends Term
case class Var(val varr:String) extends Term
case class Op1(val op1:Str, val arg:Term) extends Term
case class Op2(val op2:Str, val left:Term,val right:Term) extends Term
case class Apply(val t1:Term,val t2:Term) extends Term
case class Lambda(val variable:Var,val body:Term) extends Term
case class Let(val variable:Var,val t1:Term,val t2: Term ) extends Term
case class Closure(val t1:Lambda, val env:Map[String,Any]) extends Term
 

object test1{
  def main(args: Array[String]) {
    val env = Map[String,Any]()
    val exp1 = Op2(Str("+"),Num(2),Num(3)) //test1
    val exp2 = Apply(Lambda(Var("x"),Op2(Str("+"),Var("x"),Num(3))),Num(7))//test2
    println(interp(exp1,env))
    println(interp(exp2,env))
  }//end main
  
def interp(exp:Term,env:Map[String,Any]):Any={
  val exp1=checkvar(exp)
  interpreter(exp1,env) 
} //end interp

  def checkvar(exp:Term):Term={
  exp match{
    case Str(t)=>exp
    case Num(t)=>exp
    case Var(t)=> 
      val t2=t.concat("cc")
      Var(t2)
    case Lambda(t1,t2)=>
      val Var(t3)=t1
      val t4 = t3.concat("cc")
      Lambda(Var(t4),checkvar(t2))
    case Apply(t1,t2)=>
      Apply(checkvar(t1),checkvar(t2))
    case Op1(o,t)=>Op1(o,checkvar(t))
    case Op2(o,t1,t2)=>Op2(o,checkvar(t1),checkvar(t2))
    case _ => Str("error")
  }

}// end checkvar

  def interpreter(exp:Term,env:Map[String,Any]):Any = 
exp match {
    case Str(t)=>t
    case Num(t)=>t
    case Boo(t)=>t
    case Var(t)=> lookup(t,env)
    case Op1(o,t)=> 
        val v = interpreter(t,env) 
          (o,v) match {
            case (Str("-"),Num(v))=> 0-v
            case (Str("Not"),Boo(v))=> !v
            case _ => println("you are wrong")
                      }
    case Op2(o,t1,t2)=>
          val v1 = interpreter(t1,env)
          val v2 = interpreter(t2,env) 
          (o,v1,v2) match {
            case (Str("+"),v1:Int,v2:Int)=> v1 + v2
            case (Str("*"),v1:Int,v2:Int)=> v1 * v2
            case (Str("/"),v1:Int,v2:Int)=> v1 / v2
            case (Str("and"),v1:Boolean,v2:Boolean)=> v1 && v2
            case (Str("or"),v1:Boolean,v2:Boolean)=> v1 || v2
            case _ => (o,v1,v2) 
                             }
    case Lambda(t1,t2)=> Closure(Lambda(t1,t2),env) // Lambda case
    case Apply(t1,t2) =>                           //  Apply case
       val v3 = interpreter(t1,env)
       val v4 = interpreter(t2,env)
         v3 match {
            case  Closure(Lambda(e1,e2),env)=>
              e1 match{
                case Var(e3)=>
                   val env2 = extend(e3,v4,env)
                   interpreter(e2,env2)
                 case _=> "error"
                      }
            case _=>"error"    
                  }
//-----------????haven't solved the problem: when return a closure to print the result without closure
//    case Let(Var(t),t1,t2)=>  //Let case
//       val v5 = interpreter(t1,env)
//       val v6 = interpreter(t2,env)
//         v5 match{
//         case Closure(Lambda(e1,e2),env)=>
//           val env2 = extend(t,Lambda(e1,e2),env)
//       }
//       
//        interpreter(v6,env2)
      
    case _=> "error"// Final error case
} //end interpreter
  
  def lookup(t1:String,env:Map[String,Any]):Any={
  if (env.contains(t1)){
    env(t1)
  }
  else
  {
    println("There is no value for this variable!")
    
    }
}//end lookup

def extend(t1:String,t2:Any,env:Map[String,Any]):Map[String,Any]={
  env + (t1->t2)
 }//end extend



}//end object

//---------------------------------Reference-------------------------------------------------
//[1]Yin,W.. 如何写一个解释器  [online]Available at<http://www.yinwang.org/blog-cn/2012/08/01/interpreter> (21/08/2012)


