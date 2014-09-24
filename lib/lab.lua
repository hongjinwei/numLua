--this is a lua matlab module
--mainly deal with matrix cacilating problems

---------data type--------
--array = {data = {1,2,3,4,5},datatype = 'a',size = 5}
--matrix = {
--      size = {
--          len = 5,
--          height = 3
--      },
--      datatype = 'm'
--      data ={
--      [1] = {1,2,3,4,5},
--      [2] = {2,3,4,5,6},
--      [3] = {3,4,5,6,7}
--      }
--}
local cjson = require 'cjson'
local getn = table.getn
local find = string.find

lab = {}
lab.version = '0.0.1'

--------------------------------------------------------------
------ local util function
-------------------------------------------------------------
local function LAB_ERROR(msg, data)
    print('===ERROR===')
    if msg then 
        print(msg)
    end
    if data then 
        if type(data) == 'table' then 
            print(cjson.encode(table))
        else
            print(data)
        end
    end
end

-------------------------------------------------------------
------- array calculation
-------------------------------------------------------------

local function array_len(array)
    if not string.find(array.datatype, 'a') then 
        return 0, "not a array type"
    end
    return #(array.data)
end

local function array_add(a,b)
    if type(a) ~= 'table' and type(b) ~= 'table' then 
        return nil
    elseif a.datatype ~= b.datatype then 
        return nil
    elseif a.size ~= b.size then 
        return nil
    end
    local data = {}
    for i=1,#(a.data) do
        data[#(data) + 1] = a.data[i] + b.data[i]
    end
    local t
    if a.datatype == 'a_t' then 
        t = 't'
    end
    return lab.array(data,t)
end

local function array_sub(a,b)
    if type(a) ~= 'table' and type(b) ~= 'table' then 
        return nil
    elseif a.datatype ~= b.datatype then 
        return nil
    elseif a.size ~= b.size then 
        return nil
    end
    local data = {}
    for i=1,#(a.data) do
        data[#(data) + 1] = a.data[i] - b.data[i]
    end
    local t
    if a.datatype == 'a_t' then 
        t = 't'
    end
    return lab.array(data,t)
end

local function array_mul(a,b)
    if type(a) == 'number' and type(b) == 'table' then 
        local data = {}
        for i=1,b.size do
            data[#data+1] = a * b.data[i]
        end
        local t
        if b.datatype == 'a_t' then 
            t = 't'
        end
        return lab.array(data,t)
    elseif type(a) == 'table' and type(b) == 'number' then 
        local data = {}
        for i=1,a.size do
            data[#data+1] = b * a.data[i]
        end
        local t
        if a.datatype == 'a_t' then 
            t = 't'
        end
        return lab.array(data,t)
    elseif type(a) == 'table' and type(b) == 'table' then 
        if find(a.datatype, 'a') and find(b.datatype,'a') then 
            if a.size ~= a.size then 
                return nil
            end
            if a.datatype == b.datatype then 
                local data = {}
                for i=1,a.size do
                    data[#data+1] = (a.data[i]) * (b.data[i])
                end
                local t
                if a.datatype == 'a_t' then 
                    t = 't'
                end
                return lab.array(data,t)
            elseif a.datatype == 'a' and b.datatype == 'a_t' then 
                local data = 0
                for i=1,a.size do
                    data = data + (a.data[i]) * (b.data[i])
                end
                return data
            elseif a.datatype == 'a_t' and b.datatype == 'a' then 
                local data = 0
                for i=1,a.size do
                    data =  data + a.data[i] * b.data[i]
                end
                return data
            end
        elseif a.datatype == 'm' then 
            --TODO
        elseif b.datatype == 'm' and a.datatype == 'a' then 
            local res = {}
            if a.size ~= b.size.height then 
                return nil, "error size"
            end
            for i=1,b.size.len do 
                local tmp = 0
                for j=1,b.size.height do
                    tmp = tmp + a.data[j] * b.data[j][i]
                end
                res[i] = tmp
            end
            return lab.array(res,t)
        elseif a.datatype == 'a_t' and b.datatype == 'm' then 
            local res = {}
            if b.size.height ~= 1 then 
                return nil, 'error size'
            end
            for i=1,a.size do
                res[i] = {}
                for j=1,b.size.len do 
                    res[i][j] =  a.data[i] * b.data[1][j]
                end
            end 
            return lab.matrix(res)
        end
    else
        return nil
    end
end

local function array_div(a,b)
    if type(a) == 'number' and type(b) == 'table' then 
        return nil
    elseif type(a) == 'table' and type(b) == 'number' then 
        local data = {}
        for i=1,a.size do
            data[#data+1] = a.data[i] / b
        end
        local t
        if a.datatype == 'a_t' then 
            t = 't'
        end
        return lab.array(data,t)
    elseif type(a) == 'table' and type(b) == 'table' then 
        if a.size ~= a.size then 
            return nil
        end
        if a.datatype == b.datatype then 
            local data = {}
            for i=1,a.size do
                data[#data+1] = (a.data[i]) / (b.data[i])
            end
            local t
            if a.datatype == 'a_t' then 
                t = 't'
            end
            return lab.array(data,t)
        else
            return nil
        end
    else
        return nil
    end
end

local function array_concat(a,b)
    if type(a) == 'number' or type(b) == 'number' then 
        local data
        local datatype
        if type(a) == 'table' then 
            data = a.data
            datatype = a.datatype
            data[#data+1] = b
        elseif type(b) == 'table' then 
            data = {}
            data[1] = a
            for i=1,b.size do
                data[#data + 1] = b.data[i]
            end
            datatype = b.datatype
        end
        local t
        if datatype == 'a_t' then 
            t = 't'
        end
        return lab.array(data,t)
    elseif a.datatype == 'a' and b.datatype == 'a' then 
        if a.size ~= b.size then 
            return nil, "error size"
        end
        data = {}
        data[1] = {}
        data[2] = {}
        for i=1,b.size do
            data[1][i] = a.data[i]
            data[2][i] = b.data[i]
        end
        return lab.matrix(data)
    elseif a.datatype == 'a_t' and b.datatype == 'a_t' then 
        if a.size ~= b.size then 
            return nil, "error size"
        end
        data = {}
        for i=1,a.size do
            data[i] = {}
            data[i][1] = a.data[i]
            data[i][2] = b.data[i]
        end
        return lab.matrix(data)
    elseif a.datatype == 'a' and b.datatype == 'm' then 
        if a.size ~= b.size.len then 
            return nil
        end
        local res = {}
        res[1] = a.data
        for i=2,b.size.height+1 do
            res[i] = b.data[i-1]
        end
        return lab.matrix(res)
    elseif a.datatype == 'a_t' and  b.datatype == 'm' then 
        if a.size ~= b.size.height then 
            return nil
        end
        local res = {}
        for i=1, a.size do
            res[i] = {}
            res[i][1] = a.data[i] 
            for j=1, b.size.len do 
                res[i][j+1] = b.data[i][j]
            end
        end
        return lab.matrix(res)
    else
        return nil
    end
end

local function array_pow(a,b)
    if type(a) == 'table' and type(b) == 'number' then 
        local res = {}
        for i=1, a.size do
            res[#res + 1] = a.data[i] ^ b  
        end
        local t 
        if a.datatype == 'a_t' then 
            t = 't'
        end
        return lab.array(res,t)
    else
        return nil
    end
end

local function array_unm(a)
    local res = {}
    local t 
    if a.datatype == 'a_t' then 
        t = 't'
    end
    for i=1,a.size do
        res[#res + 1] = 0 - a.data[i]
    end
    return lab.array(res, t)
end
--------------------------------------------------------------
--------matrix calculation
--------------------------------------------------------------
local function matrix_size(matrix)
    if type(matrix) ~= 'table' or not string.find(matrix.datatype, 'm') 
          or not next(matrix.data) then 
        return nil, 'not correct type'
    end
    
    size = {}
    size.len = #(matrix.data[1])
    size.height = #(matrix.data)
    return size
end

local function matrix_add(a,b)
    if type(a) ~= 'table' or type(b) ~= 'table' then 
        return nil, 'error value, matrix needed'
    elseif a.datatype ~= 'm' or b.datatype ~= 'm' then 
        return nil, 'error value, matrix needed'
    elseif a.size.len ~= b.size.len or a.size.height ~= b.size.height then 
        return nil, 'error: different matrix size'
    end

    local l, h = a.size.len , a.size.height
    local data = {}
    for i=1,h do
        data[i] = {}
        for j=1, l do
            data[i][j] = a.data[i][j] + b.data[i][j]
        end
    end
    return lab.matrix(data)
end

local function matrix_sub(a,b)
    if type(a) ~= 'table' or type(b) ~= 'table' then 
        return nil, 'error value, matrix needed'
    elseif a.datatype ~= 'm' or b.datatype ~= 'm' then 
        return nil, 'error value, matrix needed'
    elseif a.size.len ~= b.size.len or a.size.height ~= b.size.height then 
        return nil, 'error: different matrix size'
    end

    local l, h = a.size.len , a.size.height
    local data = {}
    for i=1,h do
        data[i] = {}
        for j=1, l do
            data[i][j] = a.data[i][j] - b.data[i][j]
        end
    end
    return lab.matrix(data)
end

local function matrix_mul(a,b)
    local res = {}
    if not a or not b then 
        return nil
    end
    if type(a) == 'number' or type(b) == 'number' then 
        local l,h,data,num
        if type(a) == 'number' then 
            l, h = b.size.len, b.size.height 
            data = b.data
            num = a
        else
            l, h = a.size.len, a.size.height 
            data = a.data
            num = b
        end
        for i=1, h do
            res[i] = {}
            for j=1,l do
                res[i][j] = data[i][j] * num
            end
        end
        return lab.matrix(res)
    end
    
    if find(a.datatype,'a') or find(b.datatype,'a') then 
        if a.datatype == 'a' then 
            --TODO            
        elseif b.datatype == 'a' then 
            if a.size.len ~= 1 then 
                return nil, 'error size'
            end
            for i=1,a.size.height do
                res[i] = {}
                for j=1,b.size do
                    res[i][j] = a.data[i][1] * b.data[j]
                end
            end
            return lab.matrix(res) 
        elseif b.datatype == 'a_t' then 
            if a.size.len ~= b.size then 
                return nil,'error size'
            end

            for i=1,a.size.height do
                local tmp = 0
                for j=1,a.size.len do
                    tmp = tmp + a.data[i][j] * b.data[j]
                end
                res[i] = tmp
            end
            return lab.array(res,'t')
        else
            return nil
        end
    end

    if a.datatype == 'm' and b.datatype == 'm' then 
        if a.size.len ~= b.size.height then 
            return nil,'error size'
        end

        for i=1,a.size.height do
            res[i]={}
            for j=1,b.size.len do
                local tmp = 0
                for k=1, a.size.len do
                    tmp = tmp + a.data[i][k] * b.data[k][j]
                end      
                res[i][j] = tmp
            end
        end
        return lab.matrix(res)
    end
    return nil,'unkwon'
end

local function matrix_div(a,b)
    if type(a) == 'table' and find(a.datatype, 'm') and type(b) == 'number'  then 
        local res = {}
        for i=1,a.size.height do
            res[i] = {}
            for j=1, a.size.len do
                res[i][j] = a.data[i][j] / b
            end
        end
        return lab.matrix(res)
    else
        return nil
    end
end

local function matrix_concat(a,b)
    if not a or not b then 
        return nil
    end
    if not (type(a) == 'table' and type(b) == 'table') then 
        print("error datatype")
        return nil
    end
    
    if b.datatype == 'a' then 
        if b.size ~= a.size.len then 
            return nil
        end
        local res = {}
        for i=1, a.size.height do
            res[i] = a.data[i]
        end
        res[a.size.height + 1] = b.data
        return lab.matrix(res)
    elseif b.datatype == 'a_t' then 
        if b.size ~= a.size.height then 
            return nil
        end
        local res = {} 
        for i=1, a.size.height do
            res[i] = a.data[i]
        end
        
        for j=1, a.size.height do
            res[j][a.size.len + 1] = b.data[j]
        end
        return lab.matrix(res)
    else 
        print("two matrixs can not be concated!")
        return nil
    end
end

local function matrix_unm(a)
    if type(a) == 'table' and a.datatype == 'm' then 
        local res = {}
        for i=1, a.size.height do
            res[i] = {}
            for j=1, a.size.len do
                res[i][j] = -a.data[i][j]
            end
        end
        return lab.matrix(res)
    else
        return nil
    end
end

local function matrix_pow(a,b)
    if type(a) == 'table' and type(b) == 'number' and a.datatype == 'm' then 
        local res = {}
        for i=1, a.size.height do
            res[i] = {}
            for j=1, a.size.len do
                res[i][j] = a.data[i][j] ^ b
            end
        end
        return lab.matrix(res)
    else
        return nil
    end
end
---------------------------------------------
---------------------------------------------
--given the table{1,2,3,4,5} and return an array obj
function lab.array(tbl,t)
    if not tbl or type(tbl) ~= 'table' then 
        return nil, "not table datatype or a nil table!"
    end
    if not getn(tbl) and getn(tbl) == 0  then 
        return nil, "error table"
    end
    local array = {}
    if not t then 
        array.datatype = "a"
    else 
        array.datatype = "a_t"
    end
    array.data = {}
    for _,v in ipairs(tbl) do
        array.data[#(array.data) + 1] = v
    end
    local mt = {
        __add = array_add,
        __sub = array_sub,
        __mul = array_mul,
        __div = array_div,
        __pow = array_pow,
        __unm = array_unm,
        __concat = array_concat,
        __index = {
            size = array_len(array),
            T = function()  
                    local mat = {}
                    if array.datatype == 'a' then 
                        mat.datatype = 'a_t' 
                    else 
                        mat.datatype = 'a'
                    end
                    return mat 
                end    
        }
    } 
    setmetatable(array,mt)
    return array
end

--give table like  {{1,2,3},{4,5,6}} create a matrix obj
function lab.matrix(tbl)
    if type(tbl) ~= 'table' or type(tbl[1]) ~= 'table' then 
        return nil, 'not correct argument'
    end
    
    if not next(tbl[1]) then 
        return nil, 'empty table'
    end

    len = #(tbl[1])
    for _,v in ipairs(tbl) do
        if len ~= #v then 
            return nil,'not correct argument'
        end
    end

    matrix = {}
    matrix.datatype = 'm'
    matrix.data = tbl
    matrix.size = matrix_size(matrix)
    mt = {
        __add = matrix_add,
        __sub = matrix_sub,
        __mul = matrix_mul,
        __div = matrix_div,
        __unm = matrix_unm,
        __pow = matrix_pow,
        __concat = matrix_concat,
        __index = {
            size = matrix_size(matrix),
            T = function()
                    mat = {}
                    mat.data = {}
                    mat.datatype = 'm'
                    mat.size ={
                        len = matrix.size.height,
                        height = matrix.size.len
                    }
                    for i=1,mat.size.height do
                        for j=1,mat.size.len do
                            if type(mat.data[i]) ~= 'table' then 
                                mat.data[i] = {}
                            end
                            mat.data[i][j] =  matrix.data[j][i]
                        end
                    end
                    return mat
                end 
        }
    }
    setmetatable(matrix,mt)
    return matrix
end

--eye function return a nxn eye matrix
function lab.eye(n)
    
    if n <=0 or type(n) ~= 'number' or not tonumber(n) then 
        return nil, 'wrong number!' 
    end
    local tbl = {}
    for i=1, n do 
        tbl[i] = {}
        for j = 1, n do
            if j == i then 
                tbl[i][j] = 1 
            else 
                tbl[i][j] = 0
            end
        end
    end
    return lab.matrix(tbl)
end

function lab.tostring(obj)
    if type(obj) ~= 'table' or not obj.datatype or not (string.find(obj.datatype,'a')
        or string.find(obj.datatype,'m')) then 
        return nil, 'error datatype'
    end
    if obj.datatype == 'a' then 
        local str = 'array['
        local sep = ''
        for _,v in ipairs(obj.data) do
            str = str .. sep .. v 
            sep = ', '
        end
        return str .. ']'
    elseif obj.datatype == 'a_t' then 
        local str = 'array[\n'
        local sep = ','
        head = '        ' 
        for k,v in ipairs(obj.data) do
            if k == obj.size then sep = '' end
            str = str .. head .. v .. sep .. '\n' 
        end
        return str .. '     ]'
    elseif obj.datatype == 'm' then 
        if not next(obj.data) then
            return 'matrix{}'
        end
        str = 'matrix{\n'
        head = '        '
        tail = ','
        for k,v in ipairs(obj.data) do
            inner = '['
            sep = ''
            if k == obj.size.height then 
                tail = ''
            end
            for _,e in ipairs(v) do
                inner = inner .. sep .. e 
                sep = ','
            end
            str = str .. head .. inner .. ']' .. tail .. '\n'
        end
        return  str .. '      }'
    end
end

function lab.I(matrix)
    if type(matrix) ~= 'table' or not string.find(matrix.datatype, 'm') 
        or not next(matrix.data) then 
        return nil, "not a correct data"
    end
    local data = matrix.data
    local size = matrix.size
    if size.len == size.height then 
        return nil, "not a correct matrix"
    end
    local new = lab.eye (size.len)
    
end

return lab
