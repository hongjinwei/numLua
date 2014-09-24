local lab = require 'lib.lab'
local util = require 'lib.util'

local a= {1,2,3,4,5}

local array_a = lab.array(a)
local b = {4,5,6,7,8}
local array_b = lab.array(b)
--print(lab.tostring(array_a))
--print(lab.tostring(array_b))

array_c = array_a / array_b
--print(lab.tostring(array_c))

local c = {
            {1,2,3},
            {4,5,6}
          }

local d = {
            {2,3,4},
            {7,8,9}
          }
matrix_c = lab.matrix(c)
matrix_d = lab.matrix(d)
print(lab.tostring(matrix_c))
print(lab.tostring(matrix_c.T()))

print(util.check({a=3},"a","a_t","m"))
