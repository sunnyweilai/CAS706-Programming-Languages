
function checkvar(exp)---rename
    if exp[1]=="value" then return exp
    elseif exp[1]=="string" then return exp
    elseif exp[1]=="boolean" then return exp
    elseif exp[1]=="variable" then exp[2]= exp[2].."cc" return exp
    elseif exp[1]=="lambda" then return {exp[1],checkvar(exp[2]),checkvar(exp[3])}
    elseif exp[1][1]=="op" then  return {exp[1],checkvar(exp[2]),checkvar(exp[3])}  
    elseif exp[1]=="apply" then return {exp[1],checkvar(exp[2]),check(exp[3])}
    else error(print("This doesn't work!"))
    end
end



env={}--empty environment

function extend(var,value,environment)  
    environment[var] = value --extend environment
    return environment 
end

function lookup(var,environment)--lookup value
     value = environment[var]
     return value
end


function interp(exp,env)--interpreter 
    if (exp[1]=="value") then return exp[2]
elseif (exp[1]=="string") then return exp[2]
elseif (exp[1]=="boolean") then return exp[2]
elseif (exp[1]=="variable")then local v3=lookup(exp[2],env) return v3
elseif (exp[1]=="lambda" )then return {exp,env}
elseif (exp[1]=="apply") then 
    local v1 = interp(exp[2],env)
    local v2 = interp(exp[3],env)
    local env2 = extend(exp[2][2][2],v2,env)
    return interp(v1[1][3],env2)
elseif (exp[1][1]=="op" )then
    local v1 = interp(exp[2],env)
    local v2 = interp(exp[3],env) 
        if     exp[1][2] == '+'  then return v1 + v2
        elseif exp[1][2] == '-'  then return v1 - v2
        elseif exp[1][2] == '*'  then return v1 * v2
        elseif exp[1][2] == '/'  then return v1 / v2
        end
        elseif exp[1][2] == '==' then  
            if  v1 == v2 then return true
            else return false
            end
        elseif exp[1][2] == '<'  then 
            if  (v1 < v2) then return true
            else return false
            end
        elseif exp[1][2] == '<=' then 
            if  (v1 <= v2) then return true
            else return false
            end   
        elseif exp[1][2] == "and" then 
            if type(v1)=="string" and type(v2)=="string" then return v1..v2
            elseif type(v1)=="boolean" and type(v2)=="boolean" then 
              if  (v1 and v2) then return true
              else return false 
              end
            end  
        elseif exp[1][2] == "or"  then 
            if  (v1 or v2) then return true
                else return false
            end  
        else error(print("This doesn't work!"))
        end
    end
end

function INTE(exp)--main
    local exp = checkvar(exp)
    return interp(exp,env)  
end


-----test
exp1={"value",2}
exp2={{"op","+"},{"value",2},{"value",4}}
exp3={"apply",{"lambda",{"variable","x"},{{"op","+"},{"variable","x"},{"value",4}}},{"value",3}}
exp4={"apply",{"lambda",{"variable","y"},{"apply",{"lambda",{"variable","x"},{{"op","+"},{"variable","x"},{"variable","y"}}},{"value",3}}},{"value",8}}
exp5={{1,2}}
exp6={"apply",{"lambda",{"variable","x"},{{"op","and"},{"variable","x"},{"string","me"}}},{"string","you"}}
exp7={{"op","and"},{"boolean",true},{"boolean",false}}
print(INTE(exp1))
print(INTE(exp2))
print(INTE(exp3))
print(INTE(exp4))
print(INTE(exp6))
print(INTE(exp7))
(interp(exp5,env))