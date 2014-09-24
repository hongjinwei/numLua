local lab = require 'lib.lab'
util = {}

--check if the data is the correct datatype
--multiple args accepted
----use util.check(data, 'a','a_t','num','str', 'm', 'table') to check if data 
----is array or array_t or number or str or matrix or table type 
function util.check(data, ...)
    for _, v in ipairs(arg) do
        if v == 'num' and type(data) == 'number' then
            return true, 'number' 
        elseif v == 'str' and type(data) == 'string' then
            return true, 'string' 
        elseif v == 'table' and type(data) == 'table' then
            return true, 'table' 
        end
        
        if type(data) ~= 'table' then 
            return false, type(data)
        end 
        
        if data.datatype == v then 
            return true, data.datatype
        end
    end
    return false, "Unkown datatype"
end

function util.cutter()
end

return util
